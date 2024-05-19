%Example code structure

%foldername = "rocket";
%colorcodes = [26 28 43; 93 38 93; 178 62 83; 239 125 88; 255 205 118; 168 240 112; 54 184 101; 36 113 121; 42 54 112; 59 93 201; 65 166 246; 115 239 247; 244 244 244; 149 176 195; 86 107 134; 50 60 87];
%registername = "rocket"
%Multiple_converter(foldername, colorcodes, registername)

function Multiple_converter(foldername, colorcodes, registername)
% Reconstructs png files in a given folder for given color palette
% Convert all the reconstructed png files into a single txt file as a verilog code

% foldername is a string corresponding to the name of the folder

% colorcodes is an Mx3 array where M can be any integer, and that represent the color palette

% registername represent the register name which will be written for the verilog code, and it is a string such as "register_1"

% Get a list of all PNG files in the folder
pngFiles = dir(fullfile(foldername, '*.png'));

% Check if there are any PNG files in the folder
if isempty(pngFiles)
    error('No PNG files found in the folder "%s".', foldername);
end

% Create the new folder to store new png files
folder = mkdir(registername);

% Loop through each PNG file and read it
for m = 1:length(pngFiles)

   % Read the image file
    image = imread(fullfile(foldername, pngFiles(m).name));

    % Convert the image data into a hexadecimal representation
    for j = 1:length(image(1,:,1))
        for i = 1:length(image(:,1,1))
            color = [0 0 0];
            min_dist = 255 * 3; % Maximum possible distance
            for k = 1:length(colorcodes(:,1))
                % Calculate Manhattan distance between pixel and color from palette
                dist = sum(abs(int16(colorcodes(k,:)) - int16([image(i,j,1) image(i,j,2) image(i,j,3)])));
                if dist <= min_dist
                    min_dist = dist;
                    color = colorcodes(k,:);
                end
            end
            % Assign the closest color from the palette to the pixel
            image(i,j,:) = color;
        end
    end

    % Define the name of the PNG files to be created inside the folder
    filename = ""+registername+""+(m-1)+".png";
    filepath = fullfile(registername, filename);

    % Save the image as a PNG file in the specified folder
    imwrite(image, filepath);
end
fprintf('Arranged image files are completed and saved to the folder %s\n',""+registername +"");

numColors = size(colorcodes, 1);
% Determine the number of bits needed to represent the palette indices
numBits = ceil(log2(numColors));

% Get a list of all PNG files in the folder
pngFiles2 = dir(fullfile(registername, '*.png'));

% Open a file to write the Verilog code
[~, name, ~] = fileparts(registername);
verilogFilename = strcat(name, '.txt');
fid = fopen(verilogFilename, 'w');

fprintf(fid, '\n');
% Loop through each PNG file and read it
for m = 1:length(pngFiles)
    fprintf(fid, '//'+registername+' '+(m-1)+'\n');
    % Read the image
    img = imread(fullfile(registername, pngFiles2(m).name));
    [height, width, ~] = size(img);
    
    
    % Iterate through each pixel and write the Verilog code to assign values
    for y = 1:height
        for x = 1:width
            % Get the RGB values of the pixel
            pixel = squeeze(img(y, x, :))';
            
            % Find the index of the matching color in the palette
            colorIndex = find(all(colorcodes == pixel, 2)) - 1;
            
            if isempty(colorIndex)
                error('Pixel color not found in the palette.');
            end
            
            % Write the assignment to the file
            fprintf(fid, '    '+registername+''+(m-1)+'[%d][%d] = %d''h%X;\n', x-1, y-1 , numBits, colorIndex);
        end
    end
    fprintf(fid, ' \n');

end
    
    % Close the file
    fclose(fid);
    
    % Display a message to indicate completion
    fprintf('Verilog code generated and saved to %s\n', verilogFilename);
end