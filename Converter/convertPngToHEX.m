function convertPngToHEX(folderPath, colorCodes, hexfilename)
    % Ensure the input folder exists
    if ~exist(folderPath, 'dir')
        error('Input folder does not exist.');
    end
    
    % Get a list of all PNG files in the folder
    pngFiles = dir(fullfile(folderPath, '*.png'));

    % Check if there are PNG files in the folder
    if isempty(pngFiles)
        error('No PNG files found in the input folder.');
    end
    
    % Open the .hex file for writing
    fid = fopen(hexfilename, 'w');
    if fid == -1
        error('Cannot open file for writing: %s', hexfilename);
    end
    
    % Loop through each PNG file
    for k = 1:length(pngFiles)
        % Read the PNG image
        fileName = pngFiles(k).name;
        img = imread(fullfile(folderPath, fileName));
        
        % Initialize the index matrix
        [rows, cols, ~] = size(img);
        indexMatrix = zeros(rows, cols, 'uint8');
        
        % Map the RGB values to the color palette indices
        for i = 1:rows
            for j = 1:cols
                pixelColor = squeeze(img(i, j, :))'; % Ensure it's a row vector
                index = find(all(colorCodes == pixelColor, 2)); % Find matching indices
                if ~isempty(index)
                    indexMatrix(i, j) = index(1) - 1; % MATLAB index starts at 1
                end
            end
        end
        
        % Write the index matrix to the .hex file
        for i = 1:rows
            for j = 1:cols
                fprintf(fid, '%X\n', indexMatrix(i, j)); % Format with leading zeros
            end
        end
    end
    
    % Close the .hex file
    fclose(fid);
end