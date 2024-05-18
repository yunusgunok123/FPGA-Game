function PNG_converter(filename, colorcodes)
    % Read the image file
    image = imread(filename + ".png");

    % Calculate the total number of iterations
    total_iterations = length(image(:,1,1)) * length(image(1,:,1));

    % Convert the image data into a hexadecimal representation
    iteration_count = 0;
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

    % Save the image with the new color palette
    imwrite(image,'new_'+filename+'.png');
    fprintf('Arranged image file is completed and saved to %s\n',"new_"+filename + ".png");
end
