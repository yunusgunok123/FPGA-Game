function PNGtoVerilog(filename, colorPalette, registername)
    % Validate the color palette
    numColors = size(colorPalette, 1);
    if size(colorPalette, 2) ~= 3
        error('Color palette must be an Nx3 matrix representing RGB colors.');
    end

    % Determine the number of bits needed to represent the palette indices
    numBits = ceil(log2(numColors));
    
    % Read the image
    img = imread(filename);
    [height, width, ~] = size(img);

    % Open a file to write the Verilog code
    [~, name, ~] = fileparts(filename);
    verilogFilename = strcat(name, '.txt');
    fid = fopen(verilogFilename, 'w');
    
    % Iterate through each pixel and write the Verilog code to assign values
    for y = 1:height
        for x = 1:width
            % Get the RGB values of the pixel
            pixel = squeeze(img(y, x, :))';
            
            % Find the index of the matching color in the palette
            colorIndex = find(all(colorPalette == pixel, 2)) - 1;
            
            if isempty(colorIndex)
                error('Pixel color not found in the palette.');
            end
            
            % Write the assignment to the file
            fprintf(fid, '    '+registername+'[%d][%d] = %d''h%X;\n', x-1, y-1 , numBits, colorIndex);
        end
    end
    
    % Close the file
    fclose(fid);
    
    % Display a message to indicate completion
    fprintf('Verilog code generated and saved to %s\n', verilogFilename);
end