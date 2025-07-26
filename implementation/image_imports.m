function import_and_display_images(directory_path)
    % Check if directory exists
    if ~isfolder(directory_path)
        error('Directory not found: %s', directory_path);
    end
    
    % Supported image extensions
    extensions = {'*.png', '*.jpg', '*.jpeg', '*.bmp'};
    file_list = [];
    for i = 1:length(extensions)
        files = dir(fullfile(directory_path, extensions{i}));
        file_list = [file_list; files];
    end
    
    % Check if any files were found
    if isempty(file_list)
        disp('No image files found in the directory.');
        return;
    end
    
    % Process each file
    for k = 1:length(file_list)
        filename = fullfile(directory_path, file_list(k).name);
        try
            % Read image (handles indexed images)
            [img, map] = imread(filename);
            if ~isempty(map)
                original = ind2rgb(img, map);  % Convert indexed to RGB
            else
                original = img;
            end
        catch ME
            fprintf('Error reading file: %s\n', filename);
            fprintf('Error message: %s\n', ME.message);
            continue;  % Skip to next file
        end
        
        % Create a new figure
        figure('Name', sprintf('Image: %s', file_list(k).name), 'NumberTitle', 'off');
        
        % Determine if original is RGB or grayscale
        if ndims(original) == 3 && size(original, 3) == 3
            is_rgb = true;
            img_gray = rgb2gray(original);
        else
            is_rgb = false;
            img_gray = original;
        end
        
        % Convert grayscale image to double in [0, 1] for consistent processing
        img_gray = im2double(img_gray);
        
        % Subplot 1: Original image
        subplot(2, 2, 1);
        imshow(original);
        title_str = sprintf('Original (%s)', ifelse(is_rgb, 'RGB', 'Grayscale'));
        title(title_str);
        
        % Generate RGB representations using different colormaps
        num_colors = 256;
        ind_img = gray2ind(img_gray, num_colors);
        
        % Subplot 2: Gray colormap
        subplot(2, 2, 2);
        rgb_gray = ind2rgb(ind_img, gray(num_colors));
        imshow(rgb_gray);
        title('Gray Colormap');
        
        % Subplot 3: Hot colormap
        subplot(2, 2, 3);
        rgb_hot = ind2rgb(ind_img, hot(num_colors));
        imshow(rgb_hot);
        title('Hot Colormap');
        
        % Subplot 4: Jet colormap
        subplot(2, 2, 4);
        rgb_jet = ind2rgb(ind_img, jet(num_colors));
        imshow(rgb_jet);
        title('Jet Colormap');
        
        drawnow;  % Update figure window
    end
end
