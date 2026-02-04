% Team Assignment #4 Part 2
% Team: Jane Kozz, Tracy Robinson, and Brandon Scott
% Display decoded text from professor with required adjustments
clc; % Clear the command window
% Load the attached file
data = load('BE340_MATLABTeamAssignment_secretcode.mat');
% Extract the variable
fn = fieldnames(data);
if isempty(fn)
error('MAT file is unreadable');
end
coded = data.(fn{1});
% Step 1: Subtract 3 from row 1, columns 26–50
coded(1,26:50) = coded(1,26:50) - 3;
% Step 2: Add 10 to row 2, columns 1–9
coded(2,1:9) = coded(2,1:9) + 10;
% Step 3: Subtract 5 from row 2, columns 10–30
coded(2,10:30) = coded(2,10:30) - 5;
% Convert numbers to ASCII characters
decoded = char(coded);
% Display the decoded message neatly, one row per line
fprintf('\nDecoded message:\n%s\n%s\n\n', ...
strtrim(decoded(1,:)), strtrim(decoded(2,:)));
