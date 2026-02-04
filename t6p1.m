% Team Assignment #6 – Part 1
% Title: 3D Animated Surface Plot
% Team Members: Jane Kozz, Tracy Robinson, & Brandon Scott
% Course: BE340 – Fall 2025
%
% Example Generative AI Prompt Used:
% "Write a MATLAB program that generates a 3D surface animation of
% Z = sin(X + a) + cos(Y) where X ranges from 1:0.1:10, Y from 1:0.2:50,
% and the phase 'a' increments from 1 to 500. Include colorbar, colormap,
% and a short pause for animation."

% --- Generate X and Y arrays ---
x = 1:0.1:10; % X-axis range with increment 0.1
y = 1:0.2:50; % Y-axis range with increment 0.2
[X, Y] = meshgrid(x, y); % Create 2-D grids

% --- Loop to increment phase and create animation ---
for a = 1:500
Z = sin(X + a) + cos(Y); % Compute Z as function of X, Y, and phase a

% --- Create 3-D surface plot ---
surf(X, Y, Z);
shading interp; % Smooth color transition
colormap('jet'); % Select color scheme
colorbar; % Display color scale
title(['3D Surface Animation, Phase = ', num2str(a)]);
xlabel('X-axis');
ylabel('Y-axis');
zlabel('Z = sin(X + a) + cos(Y)');
view(45, 30); % Set 3-D view angle
pause(0.025); % 25 ms pause per iteration
end