%% 1. Read a preliminary chosen image ‘Image.gif’ (with imread)
im = imread('Leaves.jpg'); % read the image
figure, imshow(im);

%% 2. Compute an image histogram for the image (imhist)
% Extracting RGB channels
r = double(im(:,:,1));
g = double(im(:,:,2));
b = double(im(:,:,3));

% Display histograms in subplots
subplot(3,1,1);
hist(r(:),124);
title('Histogram of the Red Color');

subplot(3,1,2);
hist(g(:),124);
title('Histogram of the Green Color');

subplot(3,1,3);
hist(b(:),124);
title('Histogram of the Blue Color');

%% 3. Apply the histogram equalisation operation to the image (histeq)
% Perform histogram equalization
r_eq = histeq(r/255)*255;
g_eq = histeq(g/255)*255;
b_eq = histeq(b/255)*255;

% Combine the equalized channels into an RGB image
im_eq = uint8(cat(3, r_eq, g_eq, b_eq));

% Display the original and equalized images
figure;
subplot(1,2,1); imshow(im); title('Original Image');
subplot(1,2,2); imshow(im_eq); title('Equalized Image');

% Compute histograms for the equalized image
r_eq_hist = imhist(im_eq(:,:,1), 124);
g_eq_hist = imhist(im_eq(:,:,2), 124);
b_eq_hist = imhist(im_eq(:,:,3), 124);

% Visualize histograms
figure;
subplot(3,2,1); imshow(im_eq(:,:,1)); title('Equalized Red Channel');
subplot(3,2,2); bar(r_eq_hist); title('Equalized Red Histogram');
subplot(3,2,3); imshow(im_eq(:,:,2)); title('Equalized Green Channel');
subplot(3,2,4); bar(g_eq_hist); title('Equalized Green Histogram');
subplot(3,2,5); imshow(im_eq(:,:,3)); title('Equalized Blue Channel');
subplot(3,2,6); bar(b_eq_hist); title('Equalized Blue Histogram');

% Compare with original histograms
figure;
subplot(3,2,1); imshow(im(:,:,1)); title('Original Red Channel');
subplot(3,2,2); hist(r(:), 124); title('Original Red Histogram');
subplot(3,2,3); imshow(im(:,:,2)); title('Original Green Channel');
subplot(3,2,4); hist(g(:), 124); title('Original Green Histogram');
subplot(3,2,5); imshow(im(:,:,3)); title('Original Blue Channel');
subplot(3,2,6); hist(b(:), 124); title('Original Blue Histogram');

%% 4. Apply the gamma correction of the histogram to the image (imadjust)

% Apply gamma correction
gamma_values = [0.5, 1, 1.5, 2]; % Experiment with different gamma values

figure;
for i = 1:length(gamma_values)
    gamma_corrected_im = imadjust(im, [], [], gamma_values(i));
    subplot(1, length(gamma_values), i);
    imshow(gamma_corrected_im);
    title(['Gamma = ', num2str(gamma_values(i))]);
end

opt_im = imadjust(im, [], [], 1.5);

% Compute and visualize histograms
figure;
subplot(2, 2, 1);
imshow(im);
title('Original Image');

subplot(2, 2, 2);
imhist(im);
title('Original Histogram');

subplot(2, 2, 3);
imshow(opt_im);
title('The optimal one, Gamma = 1.5');

subplot(2, 2, 4);
imhist(opt_im);
title('Corrected Histograms');

% Perform histogram equalization for comparison
orignal_equalized_im = histeq(im);

figure;
subplot(2, 2, 1);
imshow(orignal_equalized_im);
title('Orignal Equalized Image');
subplot(2, 2, 2);
imhist(orignal_equalized_im);
title('Orignal Equalized Histogram');
subplot(2, 2, 3);
imshow(opt_im);
title('Gamma Corrected Image');
subplot(2, 2, 4);
imhist(opt_im);
title('Gamma Corrected Histogram');

%% 5. Images with Different Types of Noise and Image Denoising 
% Read the original image
originalImage = imread('Strawberry.jpg');

% Add Gaussian noise
gaussianNoiseImage = imnoise(originalImage, 'gaussian');

% Add salt and pepper noise
saltPepperNoiseImage = imnoise(originalImage, 'salt & pepper');

% Visualize the results
subplot(3,1,1);
imshow(originalImage);
title('Original Image');

subplot(3,1,2);
imshow(gaussianNoiseImage);
title('Image with Gaussian Noise');

subplot(3,1,3);
imshow(saltPepperNoiseImage);
title('Image with Salt and Pepper Noise');

%% 6. Apply the Gaussian filter to the Gaussian noised image 

% Apply Gaussian filter with different standard deviations
sigmaValues = 1:0.5:3.5;
filteredImages = cell(1, numel(sigmaValues));
% In MATLAB, a cell array is a data structure that can contain data of different types and sizes. 
% 'cell' creates a cell array.
% 'numel(sigmaValues)' is the number of elements in the sigmaValues array.

for i = 1:numel(sigmaValues)
    filteredImages{i} = imgaussfilt(gaussianNoiseImage, sigmaValues(i));
end

% Visualize the results
figure;
for i = 1:numel(sigmaValues)
    subplot(2, 3, i);
    imshow(filteredImages{i});
    title(['\sigma = ', num2str(sigmaValues(i))]);
end

%% 7. Apply the Gaussian filter to the salt and pepper noisy image 

% Apply Gaussian filter with different standard deviations
sigmaValues = 1:0.5:3.5;
filteredImages = cell(1, numel(sigmaValues));

for i = 1:numel(sigmaValues)
    filteredImages{i} = imgaussfilt(saltPepperNoiseImage, sigmaValues(i));
end

% Visualize the results
figure;
for i = 1:numel(sigmaValues)
    subplot(2, 3, i);
    imshow(filteredImages{i});
    title(['\sigma = ', num2str(sigmaValues(i))]);
end

%% 8. Apply the median filter to the salt and pepper noised image (medfilt2)

% Apply median filter with different window sizes
windowSizes = [3, 5, 7]; % Try different window sizes
filteredImages = cell(1, numel(windowSizes));

for i = 1:numel(windowSizes)
    filteredImages{i} = medfilt2(rgb2gray(saltPepperNoiseImage), [windowSizes(i), windowSizes(i)]);
end

% Visualize the results
figure;
for i = 1:numel(windowSizes)
    subplot(1, numel(windowSizes), i);
    imshow(filteredImages{i});
    title(['Window Size = ', num2str(windowSizes(i))]);
end

%% 9. Static Objects Segmentation by Edge Detection, Find edges on the image with the Sobel operator

% Apply Sobel edge detection operator
edge_image = edge(rgb2gray(originalImage), 'sobel');

% Vary threshold parameter value and observe quality
threshold_values = [0.01, 0.02, 0.03, 0.04]; % threshold values

figure;
for i = 1:length(threshold_values)
    subplot(2, 2, i);
    imshow(edge(rgb2gray(originalImage), 'sobel', threshold_values(i)));
    title(['Threshold = ' num2str(threshold_values(i))]);
end

% Visualize results with optimal threshold value
optimal_threshold = 0.04; % optimal threshold value
optimal_edge_image = edge(rgb2gray(originalImage), 'sobel', optimal_threshold);

figure;
subplot(1, 2, 1);
imshow(originalImage);
title('Original Image');

subplot(1, 2, 2);
imshow(optimal_edge_image);
title(['Edge Image with Threshold = ' num2str(optimal_threshold)]);

%% 10. Repeat the step 9 with the Canny operator

% Apply Sobel edge detection operator
edge_image = edge(rgb2gray(originalImage), 'canny');

% Vary threshold parameter value and observe quality
threshold_values = [0.1, 0.2, 0.3, 0.4]; % Example threshold values

figure;
for i = 1:length(threshold_values)
    subplot(2, 2, i);
    imshow(edge(rgb2gray(originalImage), 'canny', threshold_values(i)));
    title(['Threshold = ' num2str(threshold_values(i))]);
end

% Visualize results with optimal threshold value
optimal_threshold = 0.2; % Example optimal threshold value
optimal_edge_image = edge(rgb2gray(originalImage), 'canny', optimal_threshold);

figure;
subplot(1, 2, 1);
imshow(originalImage);
title('Original Image');

subplot(1, 2, 2);
imshow(optimal_edge_image);
title(['Edge Image with Threshold = ' num2str(optimal_threshold)]);

%% 11. Repeat the step 9 with the Prewitt operator

% Apply Sobel edge detection operator
edge_image = edge(rgb2gray(originalImage), 'prewitt');

% Vary threshold parameter value and observe quality
threshold_values = [0.01, 0.02, 0.03, 0.04]; % Example threshold values

figure;
for i = 1:length(threshold_values)
    subplot(2, 2, i);
    imshow(edge(rgb2gray(originalImage), 'prewitt', threshold_values(i)));
    title(['Threshold = ' num2str(threshold_values(i))]);
end

% Visualize results with optimal threshold value
optimal_threshold = 0.04; % Example optimal threshold value
optimal_edge_image = edge(rgb2gray(originalImage), 'prewitt', optimal_threshold);

figure;
subplot(1, 2, 1);
imshow(originalImage);
title('Original Image');

subplot(1, 2, 2);
imshow(optimal_edge_image);
title(['Edge Image with Threshold = ' num2str(optimal_threshold)]);