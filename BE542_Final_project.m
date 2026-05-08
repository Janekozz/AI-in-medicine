% BE542 Final project
% OCTA image processing Project
% Author: Jane Kozz

clear; clc; close all; warning off;

% 5 OCTA images
folder = 'C:\Users\kozzj\Documents\UofL\BE542\Data\OCTA';

% Image filenames
files = {
'OCTA_01.jpg'
'OCTA_02.jpg'
'OCTA_03.jpg'
'OCTA_04.jpg'
'OCTA_IM.jpg'
};

n = numel(files);
images = cell(n,1);

fprintf('Loading OCTA images...\n\n');

for k = 1:n
filename = fullfile(folder, files{k});
I = imread(filename);

% Convert to grayscale
if ndims(I) == 3
I = rgb2gray(I);
end

% Convert to double in [0,1]
I = im2double(I);

images{k} = I;

fprintf('Image %d: %s\n', k, files{k});
fprintf(' Size: %d x %d\n', size(I,1), size(I,2));
fprintf(' Min intensity: %.4f\n', min(I(:)));
fprintf(' Max intensity: %.4f\n', max(I(:)));
fprintf(' Mean intensity: %.4f\n\n', mean(I(:)));
end

% Display all images
figure('Name','Original OCTA Images');
montage(images, 'Size', [1 n]);
title('Selected OCTA Images');

figure('Name','Intensity Histograms');

for k = 1:numel(images)
subplot(2,3,k);
imhist(images{k});
title(files{k}, 'Interpreter', 'none');
end


%% Enhancement + Filtering

clahe_images = cell(n,1);
diff_images = cell(n,1);
bw_images = cell(n,1);
bw_clean_images = cell(n,1);

for k = 1:n
I = images{k};

% CLAHE
I_clahe = adapthisteq(I, 'NumTiles', [8 8], 'ClipLimit', 0.01);

% Anisotropic diffusion
I_diff = imdiffusefilt(I_clahe, ...
    'NumberOfIterations', 15, ...
    "GradientThreshold", 0.08, ...
    "Connectivity","minimal","ConductionMethod","exponential");

%Segmentation
bw = imbinarize(I_diff, 'adaptive', 'ForegroundPolarity', ...
    'bright','Sensitivity',0.20);

% Postprocessing
bw_clean = bwareaopen(bw, 80);
bw_clean = imclose(bw_clean, strel('disk', 1));

clahe_images{k} = I_clahe;
diff_images{k} = I_diff;
bw_images{k} = bw;
bw_clean_images{k} = bw_clean;

end

% Display results
figure('Name','Enhancement, Filtering and Postprocessing','Position',[100 100 1200 680]);

for k = 1:n
subplot(5,n,k);
imshow(images{k});
title(['Original ', num2str(k)]);

subplot(5,n,k+n);
imshow(clahe_images{k});
title('CLAHE');

subplot(5,n,k+2*n);
imshow(diff_images{k});
title('Anis diff');

subplot(5,n,k+3*n);
imshow(bw_images{k});
title('Binary');

subplot(5,n,k+4*n);
imshow(bw_clean_images{k});
title('Cleaned vessel map');
end

% Pipeline for each image
for k = 1:n 

figure('Name',['Pipeline Example - Image ', num2str(k)], ...
'Position',[150 150 1200 600]);

subplot(2,3,1); imshow(images{k}); title(['Original ', num2str(k)]);
subplot(2,3,2); imshow(clahe_images{k}); title('CLAHE');
subplot(2,3,3); imshow(diff_images{k}); title('Anis diff');
subplot(2,3,4); imshow(bw_images{k}); title('Binary');
subplot(2,3,5); imshow(bw_clean_images{k}); title('Cleaned');
end


%% Simple evaluation for chosen pipeline

fprintf('\nSimple evaluation for chosen OCTA pipeline:\n\n');

for k = 1:n

I_original = images{k};
I_clahe = clahe_images{k};
I_diff = diff_images{k};
BW = bw_images{k};
BW_clean = bw_clean_images{k};

% Basic intensity measurements
original_contrast = max(I_original(:)) - min(I_original(:));
clahe_contrast = max(I_clahe(:)) - min(I_clahe(:));
diff_contrast = max(I_diff(:)) - min(I_diff(:));

original_noise = std(I_original(:));
clahe_noise = std(I_clahe(:));
diff_noise = std(I_diff(:));

% Edge strength using Sobel gradient
[Gx, Gy] = imgradientxy(I_diff, 'sobel');
edge_strength = mean(sqrt(Gx(:).^2 + Gy(:).^2));

% Binary / cleaned vessel area
binary_area_percent = 100 * nnz(BW) / numel(BW);
cleaned_area_percent = 100 * nnz(BW_clean) / numel(BW_clean);

fprintf('Image %d\n', k);
fprintf('Original contrast: %.4f\n', original_contrast);
fprintf('CLAHE contrast: %.4f\n', clahe_contrast);
fprintf('Anisotropic diffusion contrast: %.4f\n', diff_contrast);
fprintf('Original noise std: %.4f\n', original_noise);
fprintf('CLAHE noise std: %.4f\n', clahe_noise);
fprintf('Anisotropic diffusion noise std: %.4f\n', diff_noise);
fprintf('Edge strength after filtering: %.4f\n', edge_strength);
fprintf('Binary vessel area: %.2f%%\n', binary_area_percent);
fprintf('Cleaned vessel area: %.2f%%\n\n', cleaned_area_percent);
end
