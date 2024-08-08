clear all % Clears the workspace in MATLAB
%% 1. Examples of Reading images in MATLAB
im = imread('Ameer.jpeg'); %
I_shape = size(im); % Gives the size of the image
figure, imshow(im); % Visualises the image

im_gray = rgb2gray(im); % Converts a colour image into a grey level image
figure, imshow(im_gray)

%% 2. Writing Images in MATLAB
imwrite(im,'Ameer_2.jpg');    % The string contained in filename  

%% 3. Changing the Image Brightness
I_b = im - 20;
figure, imshow(I_b)
I_s = im + 20;
figure, imshow(I_s)

%% 4. Flipping an Image
flippedImage = flipLtRt(im);
figure, imshow(flippedImage)

%% 5. Detection of an Area of a Predefined Colour 
im = imread('duckMallardDrake.jpg');
figure, imshow(im);
[nr, nc, np] = size(im);
newIm = zeros(nr, nc, np);
newIm = uint8(newIm);

for r = 1:nr
    for c = 1:nc
        if (im(r, c, 1) > 180 && im(r, c, 2) > 180 && im(r, c, 3) > 180)
            % white feather of the duck; now change it to yellow
            newIm(r, c, 1) = 225;
            newIm(r, c, 2) = 225;
            newIm(r, c, 3) = 0;
        else
            % the rest of the picture; no change
            for p = 1:np
                newIm(r, c, p) = im(r, c, p);
            end
        end
    end
end

figure, imshow(newIm);

% Find the pixels indexes with the yellow colour on the image
im_1 = imread('Two_colour.jpg'); % read the image
imshow(im_1);

% extract RGB channels separatelly
red_channel = im_1(:, :, 1);
green_channel = im_1(:, :, 2);
blue_channel = im_1(:, :, 3);

% label pixels of yellow colour
yellow_map = green_channel > 150 & red_channel > 150 & blue_channel < 50;

% extract pixels indexes
[i_yellow, j_yellow] = find(yellow_map > 0); 

% visualise the results
figure, imshow(im_1); % plot the image
hold on;
figure, scatter(j_yellow, i_yellow, 5, 'filled') % highlighted the yellow pixels

% find the pixels indexes with the yellow colour on the image ‘Two_colour.jpg’. 
im_1 = imread('Two_colour.jpg'); % read the image
imshow(im_1); % extract RGB channels separatelly 

red_channel = im_1(:, :, 1);  
green_channel = im_1(:, :, 2);  
blue_channel = im_1(:, :, 3);  % label pixels of yellow colour 

yellow_map = green_channel > 150 & red_channel > 150 & blue_channel < 50;  % extract pixels indexes 
[i_yellow, j_yellow] = find(yellow_map > 0); 

% visualise the results 
figure; 
imshow(im_1); % plot the image 
hold on; 
scatter(j_yellow, i_yellow, 5, 'filled') % highlighted the yellow pixels

%% 6. Conversion between Different Formats

gray_im = rgb2gray(im);
hsv_im = rgb2hsv(im);
bw_im =  im2bw(im);

figure;
% Display grayscale image
subplot(1,3,1);
imshow(gray_im);
title('Grayscale Image');

% Display HSV image
subplot(1,3,2);
imshow(hsv_im);
title('HSV Image');

% Display binary image
subplot(1,3,3);
imshow(bw_im);
title('Binary Image');

% 1. Resize image
resizedImage = imresize(im, 0.14);

% 2. Convert binary image to its complement
complementImage = imcomplement(im);

% 3. Convert binary image to edge image
edgeImage = edge(gray_im);

figure;
% Displaying images in subplots
subplot(1,3,1);
imshow(resizedImage);
title('Resized Image');

subplot(1,3,2);
imshow(complementImage);
title('Complement Image');

subplot(1,3,3);
imshow(edgeImage);
title('Edge Image');

%% 7. Understanding Image Histogram (including in the report)
% (1) calculate the histogram and visualise it

figure;
subplot(1,2,1);
imshow(im);
title('Original Image');

subplot(1,2,2);
imshow(im_gray);
title('Grayscale Image');

% Display histogram
figure;
imhist(im_gray);
xlabel('Pixel Intensity');
ylabel('Frequency');
title('Histogram of Grayscale Image');


% Extracting every 5th value from histogram data
h = imhist(im_gray); 
h1 = h(1:5:256); 
horz = 1:5:256;  
figure, bar(horz,h1) 
xlabel('Pixel Intensity');
ylabel('Frequency');
title('Subset of Histogram Data');

% Plot of complete histogram data
figure;
plot(h);
xlabel('Pixel Intensity');
ylabel('Frequency');
title('Complete Histogram');

% (2) Calculate and visualise the histogram of an RGB image:
% Extracting RGB channels
r = double(im(:,:,1));
g = double(im(:,:,2));
b = double(im(:,:,3));

% Display histograms in subplots
figure;
hist(r(:), 80);
title('Histogram of the Red Color');

figure;
hist(g(:),124);
title('Histogram of the Green Color');

figure;
hist(b(:),124);
title('Histogram of the Blue Color');

% Convert grayscale image to binary
ImBinary = im2bw(im, 80/255);

% Display binary image
figure;
imshow(ImBinary);
title('Binary Image');

% (3) The histogram of an HSV image:

figure;
% Display the original image.
subplot(2, 4, 1);
imshow(im, [ ]);
title('Original RGB image');

% Convert to HSV color space
hsvimage = rgb2hsv(im);

% Extract out the individual channels.
hueImage = hsvimage(:,:,1);
satImage = hsvimage(:,:,2);
valueImage = hsvimage(:,:,3);

% Display the individual channels.
subplot(2, 4, 2);
imshow(hueImage, [ ]);
title('Hue Image');

subplot(2, 4, 3);
imshow(satImage, [ ]);
title('Saturation Image');

subplot(2, 4, 4);
imshow(valueImage, [ ]);
title('Value Image');

% Take histograms
[hCount, hValues] = imhist(hueImage(:), 18);
[sCount, sValues] = imhist(satImage(:), 3);
[vCount, vValues] = imhist(valueImage(:), 3);

% Plot histograms.
subplot(2, 4, 5);
bar(hValues, hCount);
title('Hue Histogram');

subplot(2, 4, 6);
bar(sValues, sCount);
title('Saturation Histogram');

subplot(2, 4, 7);
bar(vValues, vCount);
title('Value Histogram');

%% Understanding image histogram – the difference between one-colour and two-colour images
im_1 = imread('One_colour.jpg'); % read the image
figure, imshow(im_1);

im_2 = imread('Two_colour.jpg'); % read the image
figure, imshow(im_2);

gray_im_1 = rgb2gray(im_1);
figure, imhist(gray_im_1);

gray_im_2 = rgb2gray(im_2);
figure, imhist(gray_im_2);

