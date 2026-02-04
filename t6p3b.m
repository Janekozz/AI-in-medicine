% Team Assignment No.6 Part 3 - MRI Denoise + Ventricles Coloring + Crop (Central-Biased)
% Names: Jane Kozz, Tracy Robinson, & Brandon Scott
%
% Example Generative-AI prompt used (required in comments):
% "Write MATLAB code to read a brain MRI JPG, convert to grayscale, denoise,
% show original vs filtered, segment ventricles (auto bright/dark), recolor them
% green, and crop tightly to the skull. Favor central, compact components."

clear; clc; close all;

%% Tunables
IMG_FILE         = 'MRI_brain_image2.jpg';
SENS             = 0.45;    % try 0.45–0.65 if segmentation is weak
MIN_VENT_PIX     = 80;      % min pixel count for candidate blobs
VENT_COLOR_RGB   = [0 255 0];
SAVE_PNGS        = false;
SHOW_DEBUG       = true;

% Centrality/size bias for ventricles
MIN_AREA_STRICT  = 200;     % min area for central candidates
CENTRAL_RADIUS_F = 1/3;     % keep components within (min(H,W)*CENTRAL_RADIUS_F) of center
MAX_KEEP         = 3;       % keep up to N central components

%% 0) Preconditions
if ~license('test','image_toolbox'), error('Image Processing Toolbox required.'); end
if ~exist(IMG_FILE,'file'), error('Image not found: %s', IMG_FILE); end

%% 1) Read & to grayscale uint8
I0 = imread(IMG_FILE);
if size(I0,3) == 3, G = rgb2gray(I0); else, G = I0; end
G = im2uint8(G);

%% 2) Denoise (median ×2 + Wiener)
Gm  = medfilt2(G,[3 3]);     % median 1
Gm2 = medfilt2(Gm,[3 3]);    % median 2
Gf  = wiener2(Gm2,[5 5]);    % adaptive smoothing

if SHOW_DEBUG
    figure('Name','Original vs. Filtered','Color','w');
    subplot(1,2,1), imshow(I0,[]), title('Original');
    subplot(1,2,2), imshow(Gf,[]), title('Grayscale After Denoising');
end

%% 3) Auto bright/dark guess (T2 bright vs T1 dark ventricles)
Id = im2double(Gf);
[H,W] = size(Id);
r1 = max(1, round(H*0.40)); r2 = min(H, round(H*0.60));
c1 = max(1, round(W*0.40)); c2 = min(W, round(W*0.60));
win = Id(r1:r2, c1:c2);

gth = graythresh(Id);
isBright = median(win(:)) > gth;
polarity = 'bright'; if ~isBright, polarity = 'dark'; end

% Adaptive if available; fallback to global Otsu
try
    BW = imbinarize(Id,'adaptive','ForegroundPolarity',polarity,'Sensitivity',SENS);
catch
    BW = imbinarize(Id);
    if strcmp(polarity,'dark'), BW = ~BW; end
end

% Clean
BW = bwareaopen(BW, MIN_VENT_PIX);
BW = imopen(BW, strel('disk',2));
BW = imclearborder(BW);

%% 4) Component selection with CENTRAL BIAS (area + distance + solidity)
CC = bwconncomp(BW);
if CC.NumObjects == 0
    % Auto-flip polarity once if empty
    polarity = strcmp(polarity,'bright') * "dark" + strcmp(polarity,'dark') * "bright";
    try
        BW = imbinarize(Id,'adaptive','ForegroundPolarity',polarity,'Sensitivity',SENS);
    catch
        BW = imbinarize(Id);
        if strcmp(polarity,'dark'), BW = ~BW; end
    end
    BW = bwareaopen(BW, MIN_VENT_PIX);
    BW = imopen(BW, strel('disk',2));
    BW = imclearborder(BW);
    CC = bwconncomp(BW);
end
if CC.NumObjects == 0
    error('No candidate components. Try SENS in [0.45, 0.65] or check image contrast.');
end

S   = regionprops(CC,'Area','Centroid','Solidity','Eccentricity');
ctr = [W/2, H/2];
cents = cat(1,S.Centroid);
dists = sqrt(sum((cents - ctr).^2,2));
areas = [S.Area]';
solids = [S.Solidity]';
ecc   = [S.Eccentricity]';

% Strict central filter (prefer compact, central, not too tiny)
rad_max = min(H,W) * CENTRAL_RADIUS_F;
idx = find(solids > 0.85 & areas > MIN_AREA_STRICT & dists < rad_max & ecc < 0.95);

% Fallback: if too strict, take closest 1–2 to center
if isempty(idx)
    [~,ord] = sort(dists,'ascend');
    idx = ord(1:min(2,numel(ord)));
end

% Keep up to MAX_KEEP components
if numel(idx) > MAX_KEEP
    [~,ord] = sort(dists(idx),'ascend');
    idx = idx(ord(1:MAX_KEEP));
end

ventMask = false(size(BW));
for k = 1:numel(idx)
    ventMask(CC.PixelIdxList{idx(k)}) = true;
end
ventMask = imclose(ventMask, strel('disk',2)); % tidy joins

if SHOW_DEBUG
    figure('Name','Chosen Ventricles (Central-Biased)','Color','w');
    imshow(ventMask); title('Selected Central Components');
end

%% 5) Head mask & tight crop (with Otsu fallback)
Id01 = mat2gray(Gf);
head = Id01 > 0.08;
head = imclearborder(head);
head = bwareaopen(head, 2000);
head = imclose(head, strel('disk',5));
head = imfill(head,'holes');

if ~any(head(:))
    lvl = graythresh(Id01)*0.6;
    head = Id01 > lvl;
    head = imclearborder(head);
    head = imclose(head, strel('disk',5));
    head = imfill(head,'holes');
end
head = bwareafilt(head,1);

[r,c] = find(head);
if isempty(r), error('Head mask empty. Raise threshold (0.08→0.10) or check image.'); end
pad = 2;
row1 = max(min(r)-pad,1); row2 = min(max(r)+pad, size(Gf,1));
col1 = max(min(c)-pad,1); col2 = min(max(c)+pad, size(Gf,2));

Gcrop    = Gf(row1:row2, col1:col2);
ventCrop = ventMask(row1:row2, col1:col2);

%% 6) Recolor ventricles on cropped image
G8  = im2uint8(Gcrop);
RGB = cat(3, G8, G8, G8);

V = ventCrop;                    % logical
R = RGB(:,:,1); Gc = RGB(:,:,2); B = RGB(:,:,3);
R(V)  = uint8(VENT_COLOR_RGB(1));
Gc(V) = uint8(VENT_COLOR_RGB(2));
B(V)  = uint8(VENT_COLOR_RGB(3));

% Optional thin magenta outline for QA
outline = bwperim(ventCrop);
R(outline) = max(R(outline), uint8(255));
B(outline) = max(B(outline), uint8(255));
RGB = cat(3, R, Gc, B);

%% 7) Display 
figure('Name','Ventricles Colored + Cropped','Color','w');
imshow(RGB);
title(sprintf('Ventricles Recolored GREEN (auto-%s, SENS=%.2f)', polarity, SENS));

