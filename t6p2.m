% -------------------------------------------------------------------------
% Team Assignment No.6 Part 2 – Color Channel Splitter for 2D Image
% Team Members: Jane Kozz, Tracy Robinson, & Brandon Scott
%
% Example Generative-AI prompt used:
% "Write MATLAB code that reads 'neurons+bloodvessels.jpg' with imread,
% then creates a 2x2 subplot figure showing the original image and versions
% that keep only the red, green, and blue channels (zero the others).
% Add clear titles for each subplot."
% -------------------------------------------------------------------------

clear; clc; close all;

% Configuration
FILENAME = 'neurons+bloodvessels.jpg';   % Use imread (not load) for images

% Read image
try
    I = imread(FILENAME);
catch ME
    error('Could not read image file "%s". Make sure the file is in the current folder.\nOriginal error: %s', ...
          FILENAME, ME.message);
end

% Ensure image is RGB
if size(I, 3) == 1
    % If given a grayscale image, convert to RGB so channel masks make sense
    I = repmat(I, 1, 1, 3);
end

% Create channel-isolated versions (keep one channel, zero the others)
R_only = I;              % Keep red
R_only(:, :, 2:3) = 0;   % Zero green & blue

G_only = I;              % Keep green
G_only(:, :, [1 3]) = 0; % Zero red & blue

B_only = I;              % Keep blue
B_only(:, :, 1:2) = 0;   % Zero red & green

% Plot in a 2x2 grid
figure('Name','Color Channel Splitter','NumberTitle','off');

subplot(2,2,1);
imshow(I, 'InitialMagnification', 'fit');
title('Original');
axis image off;

subplot(2,2,2);
imshow(R_only, 'InitialMagnification', 'fit');
title('Red Channel Only');
axis image off;

subplot(2,2,3);
imshow(G_only, 'InitialMagnification', 'fit');
title('Green Channel Only');
axis image off;

subplot(2,2,4);
imshow(B_only, 'InitialMagnification', 'fit');
title('Blue Channel Only');
axis image off;

% Print a brief confirmation
fprintf('Displayed original and R/G/B channel-isolated images for: %s\n', FILENAME);
