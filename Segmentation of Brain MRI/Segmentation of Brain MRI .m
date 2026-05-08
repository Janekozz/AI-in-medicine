clear; close all; clc;
addpath('auxFiles');
%===================================================
% Load input volume
load('C:\');
vol = uint8(original);

%===================================================
% global thresholding using Otsu's method
TO = multithresh(vol(:),3);
%=====================================================
% global thresholding using iterative thresholding
TI = MultiIterativeGlobalThresholding(vol,3);

%=====================================================
% Use obtained threshold to label the volume
segO = imquantize(vol(:),TO);
segO = reshape(segO,size(vol));
%
segI = imquantize(vol(:),TI);
segI = reshape(segI,size(vol));
%=====================================================
% Display the threshold values
disp(TO);
disp(TI);
%=====================================================
% Visualize the histogram and the obtained threshold
% Calculate the image histogram
h = imhist(vol(:));
%
figure, plot(h,'LineWidth',1.5);
yL = get(gca,'YLim');

% Iterative threshols
line([TI(1) TI(1)],yL.*.75,'Color','r','LineWidth',1.5);
line([TI(2) TI(2)],yL.*.75,'Color','r','LineWidth',1.5);
line([TI(3) TI(3)],yL.*.75,'Color','r','LineWidth',1.5);

% Otsu's threshold
line([TO(1) TO(1)],yL.*.75,'Color','G','LineWidth',1.5);
line([TO(2) TO(2)],yL.*.75,'Color','G','LineWidth',1.5);
line([TO(3) TO(3)],yL.*.75,'Color','G','LineWidth',1.5);

% Title and legend
title('Global threshold using Iterative and Otsu''s methods','FontSize', 16);
xlabel('Intensity values','FontSize', 14); % x-axis label
ylabel('number of pixels/volxels','FontSize', 14); % y-axis label
legend('Histogram ','Iterative Threshold','','', 'Otsu''s Threshold', 'FontSize', 12);

%Visualisation
slice = 25; % any slice

figure;

subplot(2,2,1)
imshow(vol(:,:,slice), [])
colormap gray
colorbar
title('Original MRI')

subplot(2,2,2)
imshow(labeled(:,:,slice), [])
colormap(gca, 'jet')
colorbar
title('Ground Truth')

subplot(2,2,3)
imshow(segI(:,:,slice), [])
colormap(gca, 'jet')
colorbar
title('Iterative Segmentation')

subplot(2,2,4)
imshow(segO(:,:,slice), [])
colormap(gca, 'jet')
colorbar
title('Otsu Segmentation')


