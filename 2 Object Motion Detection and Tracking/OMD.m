%% Finding Corner Points on Images
% Load images
img1 = imread('red_square_static.jpg');
img2 = imread('GingerBreadMan_first.jpg');

% Convert to grayscale
gray_img1 = rgb2gray(img1);
gray_img2 = rgb2gray(img2);

% Find corners with different maximum numbers of corners
corners_img1 = corner(gray_img1, 4);
corners_img2 = corner(gray_img2, 80);

% Plot the images with corners
figure;
subplot(1, 2, 1);
imshow(img1); 
hold on;
plot(corners_img1(:,1), corners_img1(:,2), 'b*', 'MarkerSize', 10, 'LineWidth', 2); % Adjust LineWidth as needed
title('red\_square\_static.jpg with Corners');
hold off;

subplot(1, 2, 2);
imshow(img2); 
hold on;
plot(corners_img2(:,1), corners_img2(:,2), 'b*');
title('GingerBreadMan\_first.jpg with Corners');
hold off;

%% Finding Optical Flow
% Load images for optical flow
img_first = imread('GingerBreadMan_first.jpg');
img_second = imread('GingerBreadMan_second.jpg');

% Convert to grayscale
gray_img_first = rgb2gray(img_first);
gray_img_second = rgb2gray(img_second);

% Compute optical flow
optical_flow = opticalFlowLK('NoiseThreshold', 0.01);

% initializes the optical flow object with the first frame
estimateFlow(optical_flow, gray_img_first);

flow = estimateFlow(optical_flow, gray_img_second);

% Visualize optical flow
figure;
subplot(1, 2, 1);
imshow(gray_img_first);
title('First Image');

subplot(1, 2, 2);
imshow(gray_img_second);
hold on;
plot(flow, 'DecimationFactor',[5 5],'ScaleFactor',10);
title('Optical Flow');
hold off;

%% Tracking a Single Point Using Optical Flow in a Video
% Load video
video = VideoReader('red_square_video.mp4');

% Create optical flow object
optical_flow = opticalFlowLK('NoiseThreshold', 0.01);

% Read the first frame
frame = readFrame(video);

% Find corners with different maximum numbers of corners
corners_img = corner(rgb2gray(frame), 4);

% Plot the images with corners
figure;
imshow(frame); hold on;
% plot(corners_img(:,1), corners_img(:,2), 'r*');
title('red\_square\_static.jpg with Corner');
hold off;

corners = corner(rgb2gray(frame), 4);

% Assuming corners is a 4x2 matrix
% Sum along the second dimension (rows)
top_left_corner_idx = find(sum(corners, 2) == min(sum(corners, 2)));

% Extract the top left corner
top_left_corner = corners(top_left_corner_idx, :);

x = top_left_corner(1);
y = top_left_corner(2);

% Add this position as the first position in the track
track = [x, y];

while hasFrame(video)
    % Read the next frame
    next_frame = readFrame(video);
    
    % Use the current frame and the previous position to estimate optical flow
    estimateFlow(optical_flow, rgb2gray(frame));
    
    % Find corner points in the current frame
    corners = corner(rgb2gray(next_frame), 4);

    % Find the nearest corner point to the previous position
    distances = sqrt((corners(:,1) - x).^2 + (corners(:,2) - y).^2);
    [~, idx] = min(distances);
    
    % Compute optical flow for the nearest point
    flow = estimateFlow(optical_flow, rgb2gray(next_frame));
    
    % Compute new position using flow
    new_x = corners(idx, 1) + flow.Vx(round(corners(idx, 2)), round(corners(idx, 1)));
    new_y = corners(idx, 2) + flow.Vy(round(corners(idx, 2)), round(corners(idx, 1)));
    
    % Add the new position to the track
    track = [track; new_x, new_y];
    
    % Update frame and position for the next iteration
    frame = next_frame;
    x = new_x;
    y = new_y;
end

% Load ground truth data
data = load('new_red_square_gt.mat');
gt_track_spatial = data.ground_truth_track_spatial_coordinates;

m = 1; % number of experi
% Calculate Root Mean Square Error
rmse_x_y = sqrt(sum((gt_track_spatial(2:end,:) - track(1:149,:)).^2, 2));
rmse_x = sqrt((gt_track_spatial(2:end,1) - track(1:149,1)).^2);
rmse_y = sqrt((gt_track_spatial(2:end,2) - track(1:149,2)).^2);

% fprintf('Root Mean Square Error (RMSE): %.4f\n', rmse);
average_rms_x_y = mean(rmse_x_y);
average_rms_x = mean(rmse_x);
average_rms_y = mean(rmse_y);

% Plot the results
figure;
imshow(next_frame); hold on;
plot(track(:,1), track(:,2), 'g', 'LineWidth', 2);  % Estimated trajectory
plot(gt_track_spatial(:,1), gt_track_spatial(:,2), 'r', 'LineWidth', 2);  % Ground truth trajectory
legend('Estimated Trajectory', 'Ground Truth');
title('Tracking Results with Optical Flow');
hold off;

% Plot errors
figure;
plot(rmse_x_y(2:end,:), 'b', 'LineWidth', 1);
hold on; % Add this line to hold the plot
plot(ones(size(rmse_x_y(2:end,:))) * average_rms_x_y, 'r--', 'LineWidth', 1); % Plot the constant value
hold off; % Release the hold
xlabel('Frame');
ylabel('Error');
legend('RMSE', 'Average RMSE');
title('Tracking Error Over Frames: x and y');
grid on;

% Plot errors
figure;
plot(rmse_x(2:end,:), 'b', 'LineWidth', 1);
xlabel('Frame');
ylabel('Error');
title('Tracking Error Over Frames: x');
grid on;

% Plot errors
figure;
plot(rmse_y(2:end,:), 'b', 'LineWidth', 1);
xlabel('Frame');
ylabel('Error');
title('Tracking Error Over Frames: y');
grid on;


