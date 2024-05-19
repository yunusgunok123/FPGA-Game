function GIFtoPNG_converter(gifFileName, outputFolder)
    % Read the GIF file
    info = imfinfo(gifFileName);
    numFrames = numel(info);
    
    % Create the output folder if it doesn't exist
    if ~exist(outputFolder, 'dir')
        mkdir(outputFolder);
    end
    
    % Loop through each frame in the GIF
    for k = 1:numFrames
        % Read each frame
        [img, cmap] = imread(gifFileName, k);
        
        % Convert indexed image to RGB if needed
        if ~isempty(cmap)
            img = ind2rgb(img, cmap);
        end
        
        % Create the filename for each frame
        frameFilename = sprintf('frame_%03d.png', k-1);
        
        % Save the frame as a PNG file
        imwrite(img, fullfile(outputFolder, frameFilename));
    end
end

% Example usage:
% GIF file name
% gifPath = 'deneme.gif';

% Output folder name
% outputFolder = 'deneme';

% Extract frames
% GIFtoPNG_converter(gifPath, outputFolder);