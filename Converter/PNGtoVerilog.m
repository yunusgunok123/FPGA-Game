colorcodes = [26 28 43; 93 38 93; 178 62 83; 239 125 88; 255 205 118; 168 240 112; 54 184 101; 36 113 121; 42 54 112; 59 93 201; 65 166 246; 115 239 247; 244 244 244; 149 176 195; 86 107 134; 50 60 87];

PNGtoVerilog("space_ship_0.png", colorcodes)

function PNGtoVerilog(filename, colorPalette)

    palette_len = length(colorPalette);

    % Read the image
    img = imread(filename);
    [height, width, ~] = size(img);

    % Open a file to write the Verilog code
    [~, name, ~] = fileparts(filename);
    verilogFilename = strcat(name, '.txt');
    fid = fopen(verilogFilename, 'w');

    fprintf(fid, 'function [3:0] %s(input [8:0] x, input [8:0] y);\n', name);
    fprintf(fid, 'begin\n');
    fprintf(fid, 'case(y)\n');

    for y = 1:height
        fprintf(fid, "9'd%d: begin\n", y-1);
        fprintf(fid, 'case(x)\n');
        
        row = zeros(1, width);
        for x = 1:width
            pixel = squeeze(img(y, x, :))';
            row(x) = find(all(colorPalette == pixel, 2));
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
                fprintf(fid, "default: %s = 4'd%d;\n", name, i - 1);
            else
                len = countOccurrences(i);
                if len ~= 0
                    for j = 1:len
                        fprintf(fid, "9'd%d", indexes{i}(j));
                        if j ~= len
                            fprintf(fid, ',');
                        end
                    end
                    fprintf(fid, ': %s = %d;\n', name, i - 1);
                end
            end
        end

        fprintf(fid, 'endcase\n');
        fprintf(fid, 'end\n');
    end

    fprintf(fid, 'endcase\n');
    fprintf(fid, 'end\n');
    fprintf(fid, 'endfunction\n');
        
    % Close the file
    fclose(fid);
    
    % Display a message to indicate completion
    fprintf('Text file generated and saved to %s\n', verilogFilename);
end
