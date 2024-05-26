function Multiple_converter_new(foldername, colorcodes, registername, new_foldername,func_name)
    % Reconstructs png files in a given folder for given color palette
    % Convert all the reconstructed png files into a single txt file as a verilog code

    % Get a list of all PNG files in the folder
    pngFiles = dir(fullfile(foldername, '*.png'));

    % Check if there are any PNG files in the folder
    if isempty(pngFiles)
        error('No PNG files found in the folder "%s".', foldername);
    end

    % Create the new folder to store new png files
    if ~exist(new_foldername, 'dir')
        mkdir(new_foldername);
    end

    % Loop through each PNG file and read it
    for m = 1:length(pngFiles)
        % Read the image file
        image = imread(fullfile(foldername, pngFiles(m).name));

        % Ensure the image has 3 channels (RGB)
        if size(image, 3) ~= 3
            error('Image %s does not have 3 RGB channels.', pngFiles(m).name);
        end

        % Convert the image data into a new image with the closest color from the palette
        for j = 1:size(image, 2)
            for i = 1:size(image, 1)
                color = [0, 0, 0];
                min_dist = 255 * 3; % Maximum possible distance
                for k = 1:size(colorcodes, 1)
                    % Calculate Manhattan distance between pixel and color from palette
                    dist = sum(abs(int16(colorcodes(k, :)) - int16(squeeze(image(i, j, :))')));
                    if dist < min_dist
                        min_dist = dist;
                        color = colorcodes(k, :);
                    end
                end
                % Assign the closest color from the palette to the pixel
                image(i, j, :) = color;
            end
        end

        % Define the name of the PNG files to be created inside the folder
        filepath = fullfile(new_foldername, pngFiles(m).name);

        % Save the image as a PNG file in the specified folder
        imwrite(image, filepath);
    end
    fprintf('Arranged image files are completed and saved to the folder %s\n', new_foldername);

    % Start generating Verilog code
    numColors = size(colorcodes, 1);
    numBits = ceil(log2(numColors));

    palette_len = length(colorcodes);

    % Get a list of all PNG files in the folder
    pngFiles2 = dir(fullfile(new_foldername, '*.png'));

    % Open a file to write the Verilog code
    [~, name, ~] = fileparts(registername);
    verilogFilename = strcat(name, '.txt');
    fid = fopen(verilogFilename, 'w');
    fprintf(fid, 'case(angle)\n');

    for m = 1:length(pngFiles2)
        fprintf(fid, '// %s %d\n', registername, m-1);
        img = imread(fullfile(new_foldername, pngFiles2(m).name));
        [height, width, ~] = size(img);
        fprintf(fid, "3'd%d: begin\n", m-1);
        fprintf(fid, 'case(y)\n');
        
        for y = 1:height
            fprintf(fid, "6'd%d: begin\n", y-1);
            fprintf(fid, 'case(x)\n');
            row = zeros(1, width);
            for x = 1:width
                pixel = squeeze(img(y, x, :))';
                row(x) = find(all(colorcodes == pixel, 2));
            end

            countOccurrences = zeros(1, palette_len);
            indexes = cell(1, palette_len);
            
            for i = 1:palette_len
                indexes{i} = find(row == i);
                countOccurrences(i) = length(indexes{i});
            end
        
            [~, maxIndex] = max(countOccurrences);

            for i = 1:palette_len
                if i == maxIndex
                    fprintf(fid, "default: "+func_name+" = 4'd%d;\n", i - 1);
                else
                    len = countOccurrences(i);
                    if len ~= 0
                        for j = 1:len
                            fprintf(fid, "6'd%d", indexes{i}(j));
                            if j ~= len
                                fprintf(fid, ',');
                            end
                        end
                        fprintf(fid, ": "+func_name+" = 4'd%d;\n", i - 1);
                    end
                end
            end

            fprintf(fid, 'endcase\n');
            fprintf(fid, 'end\n');
        end

        fprintf(fid, 'endcase\n');
        fprintf(fid, 'end\n');
    end
    fprintf(fid, 'endcase\n');

    % Close the file
    fclose(fid);

    % Display a message to indicate completion
    fprintf('Verilog code generated and saved to %s\n', verilogFilename);
end