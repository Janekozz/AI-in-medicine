% Team Assignment #6 – Part 4: Simple tumor detection on a gray MRI image
% Names: Jane Kozz, Tracy Robinson, Brandon Scott
%
% Example Generative-AI prompt we used:
% "Write a short MATLAB script that reads an MRI image (grayscale JPG),
% converts it to a binary mask with imbinarize, finds the tumor region,
% draws its boundary with bwboundaries, and prints the area (pixels) at the centroid."

clear; clc; close all;

% 1) Read and show the image (grayscale JPG)
I = imread('MRI_brain_tumor_image.jpg'); % <-- keep the file in current folder
if size(I,3) == 3, I = rgb2gray(I); end % robust if the jpg is accidentally RGB
I = im2uint8(I); % ensure standard 8-bit grayscale for display

figure; imshow(I,[], 'Border','tight'); title('Original MRI (grayscale)');

% 2) Light pre-processing (optional but helps)
Ieq = imadjust(I); % contrast stretch (keeps it simple)
If = medfilt2(Ieq,[3 3]); % small speckle smoothing

% 3) Binary image of *bright* objects (tumor is bright)
BW = imbinarize(If,'adaptive', ...
'ForegroundPolarity','bright', 'Sensitivity',0.45);

% Clean up: remove tiny bits and thin edges (e.g., skull rim/letters)
BW = bwareaopen(BW, 50); % drop very small blobs
BW = imopen(BW, strel('disk',2)); % remove thin bright rims
BW = imclearborder(BW); % remove anything touching the image border

% 4) Choose the tumor region
% Heuristic: pick the largest *solid* bright blob after cleanup.
CC = bwconncomp(BW);
if CC.NumObjects == 0
error('No bright regions found. Try a slightly higher Sensitivity (e.g., 0.55).');
end
stats = regionprops(CC, 'Area','Centroid','Solidity');

keep = find([stats.Solidity] > 0.85 & [stats.Area] > 100); % favor compact filled blobs
if isempty(keep), keep = 1:CC.NumObjects; end % fall back to all blobs

[~,ix] = max([stats(keep).Area]); % take the largest kept blob
tumorIdx = keep(ix);

tumorMask = false(size(BW));
tumorMask(CC.PixelIdxList{tumorIdx}) = true;

% 5) Outline around the tumor and print the area at its centroid
[B,L] = bwboundaries(tumorMask,'noholes'); 
tProp = regionprops(tumorMask,'Area','Centroid');

figure; imshow(I,[], 'Border','tight'); hold on;
title('Tumor outline and area (pixels)');

% Draw the boundary
for k = 1:numel(B)
boundary = B{k};
plot(boundary(:,2), boundary(:,1), 'g', 'LineWidth', 2);
end

% Label with area at centroid
Apx = round(tProp.Area);
c = tProp.Centroid; % [x,y]
text(c(1), c(2), sprintf('Area = %d px', Apx), ...
'Color','y','FontSize',12,'FontWeight','bold', ...
'HorizontalAlignment','center');

% Optional: show the binary mask you used
figure; imshow(tumorMask); title('Final binary mask of tumor');
