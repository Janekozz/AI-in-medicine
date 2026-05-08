clear; close all; clc 
%Step 1: Data Preparation 
I = im2double(imread('Dataset\Case2\q5.png')); 
tissue = im2double(imread('Dataset\Case2\q5_seg.png')); 
if size(I,3)==3 
I = rgb2gray(I); 
end 
if size(tissue,3)==3 
tissue = rgb2gray(tissue); 
end 
% Clean binary mask 
tissue = imfill(bwareaopen(tissue > 0, 50), 'holes'); 
% Figure: Original OCT image 
subplot (1,2,1) 
imshow(I, []) 
title('Original OCT Image', 'FontSize', 13, 'FontWeight', 'bold') 
% Figure: Binary mask 
subplot (1,2,2) 
imshow(tissue, []) 
title('Binary mask', 'FontSize', 13, 'FontWeight', 'bold') 
% Figure: Segmentation 
figure 
imshow(I, []) 
hold on 
visboundaries(tissue, 'Color', 'r', 'LineWidth', 1.5) 
title('Segmentation Overlay', 'FontSize', 13, 'FontWeight', 'bold') 
hold off 
% Get the inner and outer Masks 
labels = bwlabel(~tissue); 
outerMask = (labels==1); 
innerMask = (labels==2); 
% Assign higher and lower potentials for both inner and outer masks 
phiSolve = zeros(size(tissue)); 
phiSolve(innerMask==1) = -1; 
phiSolve(outerMask==1) = 1; 
phi = regionfill(phiSolve,tissue); 
% Obtain the edge for the lowe potential values to act as the start point 
Edge_in = edge(double(innerMask),'prewitt'); 
[Ystart, Xstart, ~]= find(Edge_in==1); 
[r, c] = size(phi); 
% obtain grid coordinates 
x = 1:c; 
y = 1:r; 
% The filter values are very important, it detemines how the streamline 
% goes, it is used to obtain the tangent vector fields in x- and 
% y-directions 
Hx=[-1 0 1; -2 0 2; -1 0 1]; 
Hy=[-1 -2 -1; 0 0 0; 1 2 1]; 
dxEpsi = imfilter(phi,Hx); dxEpsi(outerMask==1)=0; % To ensure that the stream 
line stops at the end of the mask, not at the begining of the outer mask 
dyEpsi = imfilter(phi,Hy); dyEpsi(outerMask==1)=0; 
%----------------- 
% Visualize the results 
figure 
imshow(tissue,[]); 
hold on; 
plot( Xstart,Ystart,'.r'); 
title('Streamlines inside the retinal layer') 
% Calculate and visualize the stram lines from the source boundary to the 
destination one 
Mystreams = streamline(x,y,dxEpsi,dyEpsi, Xstart, Ystart); 
lines = stream2(x,y,dxEpsi,dyEpsi, Xstart, Ystart); 
tissueThickness = getThickness(lines,tissue); 
% Figure : Laplace potential solution 
phiDisplay = phi; 
phiDisplay(~tissue) = NaN; 
figure 
imagesc(phiDisplay, 'AlphaData', double(tissue)) 
set(gca, 'Color', 'k') 
axis image off 
colormap(gray) 
cb = colorbar; 
cb.Label.String = 'phi value'; 
cb.Label.FontSize = 11; 
clim([-1 1]) 
title('Laplace Potential Solution', 'FontSize', 13, 'FontWeight', 'bold') 
% Figure : Final Laplace-based thickness map 
thickDisplay = tissueThickness; 
thickDisplay(~tissue) = NaN; 
vals = thickDisplay(~isnan(thickDisplay)); 
vals = vals(vals > 0); 
figure 
imshow(tissueThickness,[],'colormap',jet(256)); 
title('Colour-coded Thickness Map', 'FontSize', 13, 'FontWeight', 'bold') 
set(gca, 'Color', 'w') 
axis image off 
colormap(jet(256)) 
cb = colorbar; 
cb.Label.String = 'Thickness (pixels)'; 
cb.Label.FontSize = 11; 
if ~isempty(vals) 
clim([min(vals) max(vals)]) 
end 
% Thickness profile from Laplace-based thickness 
p = nan(1, c); 
for j = 1:c 
a = tissueThickness(logical(tissue(:, j)), j); 
a = a(a > 0); 
if ~isempty(a) 
p(j) = mean(a); 
end 
end 
meanThick = mean(p(~isnan(p))); 
% Figure : Thickness profile 
figure 
plot(p, 'b-', 'LineWidth', 1.5) 
hold on 
yline(meanThick, 'r-', 'LineWidth', 1.5) 
xlabel('Column (pixel)', 'FontSize', 12) 
ylabel('Thickness (pixels)', 'FontSize', 12) 
title('Thickness Profile', 'FontSize', 13, 'FontWeight', 'bold') 
grid on 
legend({'Laplace-based thickness', 'Mean'}, 'Location', 'best') 
hold off 
% Print statistics 
fprintf('\n========================================\n') 
fprintf(' Step2: Mean thickness value\n') 
fprintf(' Mean thickness = %.2f pixels\n', meanThick) 
fprintf(' Std thickness = %.2f pixels\n', std(p(~isnan(p)))) 
fprintf(' Min thickness = %.2f pixels\n', min(p(~isnan(p)))) 
fprintf(' Max thickness = %.2f pixels\n', max(p(~isnan(p)))) 
fprintf('========================================\n') 
% Step 3: Curvature Estimation 
% Tuning parameters 
pointSep = 40; % sample every 40 points 
scaling = 5000; % scale curvature vectors for display 
% Choose boundary 
boundaryType = 'upper'; % 'upper' or 'lower' 
[r, c] = size(tissue); 
% Extract ordered boundary points 
x = []; 
y = []; 
for j = 1:c 
rows = find(tissue(:,j)); 
if ~isempty(rows) 
if strcmpi(boundaryType,'upper') 
yj = rows(1); % upper boundary 
else 
yj = rows(end); % lower boundary 
end 
x(end+1,1) = j; 
y(end+1,1) = yj; 
end 
end 
% Smoothing 
y = smoothdata(y, 'movmean', 7); 
% Select some samples from the point list 
x = x(1:pointSep:end); 
y = y(1:pointSep:end); 
% Vertices 
Vertices = [x y]; 
% Calculate curvature 
k = abs(calculateCurvature2D(Vertices)); 
% Calculate normals 
N = calculateNormals2D(Vertices); 
% Display results 
ks = k * scaling; 
figure; 
imshow(I, []); 
hold on 
% Curvature vectors 
plot([Vertices(:,1) Vertices(:,1)+ks.*N(:,1)]', [Vertices(:,2) 
Vertices(:,2)+ks.*N(:,2)]', ... 
'g', 'LineWidth', 1.5); 
% Boundary curve 
plot(Vertices(:,1), Vertices(:,2), 'r-', 'LineWidth', 2); 
% Sampled boundary points 
plot(Vertices(:,1), Vertices(:,2), 'b.', 'LineWidth', 7); 
axis equal 
title(['Boundary with Curvature Vectors (' boundaryType ' boundary)'], ... 
'FontSize', 13, 'FontWeight', 'bold'); 
% Curvature vs. position 
figure; 
plot(Vertices(:,1), k, 'b.-', 'LineWidth', 1.5, 'MarkerSize', 12); 
xlabel('x position (pixel)', 'FontSize', 12); 
ylabel('Curvature', 'FontSize', 12); 
title(['Curvature vs. Position (' boundaryType ' boundary)'], ... 
'FontSize', 13, 'FontWeight', 'bold'); 
grid on 
% Mean curvature value 
meanCurvature = mean(k, 'omitnan'); 
fprintf('\n========================================\n'); 
fprintf('Step 3: Curvature Estimation\n'); 
fprintf('Boundary analyzed = %s\n', boundaryType); 
fprintf('Mean curvature = %.6f\n', meanCurvature); 
fprintf('========================================\n'); 
% Step 4: Tortuosity Estimation 
% Tuning parameter (fixed Euclidean test distance) 
tstDistance = 50; 
% Assume: 
% tissue = binary mask of the selected retinal layer 
% Extract 1-pixel-wide boundary curve 
curveImg = false(r,c); 
for j = 1:c 
rows = find(tissue(:,j)); 
if ~isempty(rows) 
if strcmpi(boundaryType,'upper') 
yj = rows(1); % upper boundary 
else 
yj = rows(end); % lower boundary 
end 
curveImg(yj,j) = 1; 
end 
end 
% Optional smoothing of the boundary shape 
x = []; 
y = []; 
for j = 1:c 
rows = find(curveImg(:,j)); 
if ~isempty(rows) 
x(end+1,1) = j; 
y(end+1,1) = rows(1); 
end 
end 
ySmooth = round(smoothdata(y,'movmean',7)); 
curveImg = false(r,c); 
for k = 1:length(x) 
yy = min(max(ySmooth(k),1),r); 
curveImg(yy,x(k)) = 1; 
end 
% Identify start and end points 
SEPoints = getSEPoints2(curveImg); 
if sum(SEPoints(:)) == 0 
[a,b] = find(curveImg==1); 
curveImg(a(1),b(1)) = 0; 
SEPoints = getSEPoints(curveImg); 
end 
% Calculate geodesic distance 
geoDistance = bwdistgeodesic(logical(curveImg), SEPoints(1,2), SEPoints(1,1), 
... 
'quasi-euclidean'); 
% Sort the curve points by connectivity 
[pointsSorted, geodesicDist] = getSortedPoints(geoDistance); 
% Calculate tortuosity map 
tourImg = calculateTortuosity2D(pointsSorted, geodesicDist, size(geoDistance), 
tstDistance); 
% Display tortuosity map 
tourImgD = imdilate(tourImg, strel('disk',2)); 
figure; 
imshow(tourImgD, [], 'colormap', jet); 
colorbar 
title(['Tortuosity Map (' boundaryType ' boundary)'], ... 
'FontSize', 13, 'FontWeight', 'bold'); 
% Overlay 
figure; 
imshow(I, []); 
colormap ("gray"); 
hold on 
tourRGB = ind2rgb(gray2ind(mat2gray(tourImgD), 256), jet(256)); 
h = imshow(tourRGB); 
set(h, 'AlphaData', 0.8* (tourImgD > 0)); 
plot(x,y, 'r-','LineWidth',1.5); 
title(['Tortuosity Overlay (' boundaryType ' boundary)'], 'FontSize', 13, 
'FontWeight', 'bold'); 
hold off 
% Mean tortuosity value 
tourValues = tourImg(tourImg > 0); 
meanTortuosity = mean(tourValues, 'omitnan'); 
geoDist = geodesicDist(end); 
eucDist = norm(pointsSorted(end,:) - pointsSorted(1,:)); 
tourValue = geoDist / eucDist; 
fprintf('\n========================================\n'); 
fprintf('Step 4: Tortuosity Estimation\n'); 
fprintf('Boundary analyzed = %s\n', boundaryType); 
fprintf('Test distance = %d pixels\n', tstDistance); 
fprintf('Mean tortuosity = %.6f\n', meanTortuosity); 
fprintf('Geodesic distance = %.2f pixels\n', geoDist); 
fprintf('Euclidean distance = %.2f pixels\n', eucDist); 
fprintf('Tortuosity = %.6f\n', tourValue); 
fprintf('========================================\n'); 
 
 
 
% Function was adjusted 
function SEPoints = getSEPoints2(curLayerEdges) 
% Initialize points container 
SEPoints = zeros(2,2); 
SEPointsCnt = 0; 
% loop through all image pixels 
for r = 2:size(curLayerEdges,1)-1 
   for c = 2:size(curLayerEdges,2)-1 
       % Check only Curve pixels 
       if(curLayerEdges(r,c)==1) 
           % Check how many neighbours? 
           cnt = 0;            
           for nr = -1:1 
               for nc = -1:1 
                   if ~(nr == 0 && nc == 0) 
                       if (curLayerEdges(r+nr,c+nc)==1) 
                       cnt = cnt +1; 
                       end 
                   end 
               end 
           end 
           % if there only one neighbor, take that point 
           if(cnt==2) % 
               SEPointsCnt = SEPointsCnt +1; 
               SEPoints(SEPointsCnt,:) = [r,c]; 
           end 
       end 
   end 
end 
 
