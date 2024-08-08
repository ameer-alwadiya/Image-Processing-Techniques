close all; 
clear all;

% Reading image
im_easy = imread('Treasure_easy.jpg'); % change name to process other images
im_medium = imread('Treasure_medium.jpg'); % change name to process other images
im_hard = imread('Treasure_hard.jpg'); % change name to process other images

figure;
subplot(1,3,1);
imshow(im_easy);
title('Image 1');

subplot(1,3,2);
imshow(im_medium);
title('Image 2');

subplot(1,3,3);
imshow(im_hard);
title('Image 3');

% Binarisation
bin_threshold = 0.05; 
bin_im_easy = im2bw(im_easy, bin_threshold);
bin_im_medium = im2bw(im_medium, bin_threshold);
bin_im_hard = im2bw(im_hard, bin_threshold);

figure;
subplot(1,3,1);
imshow(bin_im_easy);
title('Image 1');

subplot(1,3,2);
imshow(bin_im_medium);
title('Image 2');

subplot(1,3,3);
imshow(bin_im_hard);
title('Image 3');

% Extracting connected components
con_im_easy = bwlabel(bin_im_easy);
con_im_medium = bwlabel(bin_im_medium);
con_im_hard = bwlabel(bin_im_hard);

figure;
subplot(1,3,1);
imshow(label2rgb(con_im_easy));
title('Image 1');

subplot(1,3,2);
imshow(label2rgb(con_im_medium));
title('Image 2');

subplot(1,3,3);
imshow(label2rgb(con_im_hard));
title('Image 3');

% Compute properties 
props_easy = regionprops(bin_im_easy, 'Area', 'Centroid', 'BoundingBox');
props_medium = regionprops(bin_im_medium, 'Area', 'Centroid', 'BoundingBox');
props_hard = regionprops(bin_im_hard, 'Area', 'Centroid', 'BoundingBox');

% Visualize bounding boxes for easy image
figure;
imshow(im_easy);
title('Bounding Boxes for Easy Image');
hold on;
for i = 1:numel(props_easy)
    rectangle('Position', props_easy(i).BoundingBox, 'EdgeColor', 'r', 'LineWidth', 2);
end
hold off;

% Visualize bounding boxes for medium image
figure;
imshow(im_medium);
title('Bounding Boxes for Medium Image');
hold on;
for i = 1:numel(props_medium)
    rectangle('Position', props_medium(i).BoundingBox, 'EdgeColor', 'r', 'LineWidth', 2);
end
hold off;

% Visualize bounding boxes for hard image
figure;
imshow(im_hard);
title('Bounding Boxes for Hard Image');
hold on;
for i = 1:numel(props_hard)
    rectangle('Position', props_hard(i).BoundingBox, 'EdgeColor', 'r', 'LineWidth', 2);
end
hold off;

%% Arrow/non-arrow determination

% Define arrow_finder as an anonymous function
arrow_finder = @(props) find([props.Area] >= 1400 & [props.Area] <= 1650);

% Finding red arrow
arrow_ind = arrow_finder(props_easy);
n_arrows = numel(arrow_ind);

start_arrow_id = 0;
% check each arrow until find the red one
for arrow_num = 1 : n_arrows
    object_id = arrow_ind(arrow_num);    % determine the arrow id

    % extract colour of the centroid point of the current arrow
    centroid_colour = im_easy(round(props_easy(object_id).Centroid(2)), round(props_easy(object_id).Centroid(1)), :); 
    if centroid_colour(:, :, 1) > 240 && centroid_colour(:, :, 2) < 10 && centroid_colour(:, :, 3) < 10
	% the centroid point is red, memorise its id and break the loop
        start_arrow_id = object_id;
        break;
    end
end

%% Hunting
% Initialize an array to store the IDs of the objects
all_object_ids = [];

% Iterate through all objects in props_easy
for i = 1:numel(props_easy)
    % Get the ID of the current object and append it to the array
    all_object_ids(end + 1) = i;
end

cur_object = start_arrow_id; % start from the red arrow
path = cur_object;

% while the current object is an arrow, continue to search
while ismember(cur_object, arrow_ind) 
    % You should develop a function next_object_finder, which returns
    % the ID of the nearest object, which is pointed at by the current
    % arrow. You may use any other parameters for your function.

    cur_object = next_object_finder(props_easy, cur_object, im_easy, all_object_ids);
    path(end + 1) = cur_object;
end

%% visualisation of the path
imshow(im_easy);
hold on;
for path_element = 1 : numel(path) - 1
    object_id = path(path_element); % determine the object id
    rectangle('Position', props_easy(object_id).BoundingBox, 'EdgeColor', 'y');
    str = num2str(path_element);
    text(props_easy(object_id).BoundingBox(1), props_easy(object_id).BoundingBox(2), str, 'Color', 'r', 'FontWeight', 'bold', 'FontSize', 14);
end

% visualisation of the treasure
treasure_id = path(end);
rectangle('Position', props_easy(treasure_id).BoundingBox, 'EdgeColor', 'g');

%% functions 
function next_object_label = next_object_finder(props, current_object_id, im, all_object_ids)
    % Isolate the portion of the image containing the current arrow using its bounding box
    bbox = round(props(current_object_id).BoundingBox);
    arrowImage = im(bbox(2):bbox(2)+bbox(4)-1, bbox(1):bbox(1)+bbox(3)-1, :);

    % Convert this sub-image to HSV to focus on color characteristics
    hsvArrowImage = rgb2hsv(arrowImage);

    % Create a mask for yellow regions (typically used for arrow pointers)
    maskYellow = (hsvArrowImage(:,:,1) >= 1/7) & (hsvArrowImage(:,:,1) <= 1/4) & ...
                 (hsvArrowImage(:,:,2) > 0.5) & (hsvArrowImage(:,:,3) > 0.5);

    % Find the centroid of the yellow region which indicates the direction of the arrow
    yellowProps = regionprops(maskYellow, 'Centroid');
    yellowCentroid = yellowProps.Centroid;

    % Adjust centroid to global image coordinates
    yellowCentroidGlobal = yellowCentroid + [bbox(1), bbox(2)] - 1;

    % Compute a vector from the arrow's centroid to the yellow centroid
    directionVector = yellowCentroidGlobal - props(current_object_id).Centroid;

    % Normalize this direction vector for consistent magnitude
    directionVector = directionVector / norm(directionVector);

    % Extend by a scalar (enough to cover the distance from one arrow's bounding box to the next object's bounding box)
    extendedVector = directionVector * 90; % Adjust the scalar factor according to your requirements

    % Calculate the end point of the extended vector
    end_point = round(props(current_object_id).Centroid + extendedVector);
    % Find the label of the object at the end point
    next_object_label = find_object_id(end_point, props, all_object_ids);
end

function id = find_object_id(point, props, all_object_ids)
    id = 0;
    
    % Iterate through all arrows
    for i = 1:numel(all_object_ids)
        % Get the bounding box of the current arrow
        bbox = round(props(all_object_ids(i)).BoundingBox);
        
        % Check if the end_point falls within the bounding box
        if point(1) >= bbox(1) && point(1) <= bbox(1) + bbox(3) && ...
           point(2) >= bbox(2) && point(2) <= bbox(2) + bbox(4)
            % If end_point is within the bounding box, set arrow_id to the ID of the current arrow
            id = all_object_ids(i);
            break; % Exit the loop since we found the arrow
        end
    end
end

