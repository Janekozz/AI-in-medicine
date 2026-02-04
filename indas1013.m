% Individual Assignment 2 #5
% Author Jane Kozz
% Prompt to AI used:
% "Write MATLAB code to simulate the pH and temperature levels in a bioreactor,
% The MATLAB program should:
% - Ask the user for max/min pH and temperature
% - Randomly initialize pH and temperature within these limits
% - Apply random drifts over time
% - Allow pH correction using NaOH addition when pH is low
% - Apply heating or cooling when temperature is out of range
% - Run continuously with periodic updates"

clear; clc; rng('shuffle');

%% --- User input section ---
max_pH = input('Enter the maximum acceptable pH level: ');
min_pH = input('Enter the minimum acceptable pH level: ');

if max_pH <= min_pH
error('Maximum pH must be greater than minimum pH.');
end

t_max = input('Enter the maximum acceptable temperature (°C): ');
t_min = input('Enter the minimum acceptable temperature (°C): ');

if t_max <= t_min
error('Maximum temperature must be greater than minimum temperature.');
end

%% --- Initial conditions ---
pH = min_pH + (max_pH - min_pH) * rand();
tempC = t_min + (t_max - t_min) * rand();
step = 0;
STEP_MIN = 5; % Each iteration represents 5 minutes

fprintf('\nStarting simulation... Press Ctrl+C to stop.\n\n');

%% --- Continuous simulation loop ---
while true
step = step + 1;
elapsed = step * STEP_MIN;
fprintf('\nTime: %d min\n', elapsed);
fprintf('pH level: %.2f\n', pH);

% Check pH range
if pH >= min_pH && pH <= max_pH
fprintf('The pH level is within the acceptable range.\n');
elseif pH < min_pH
choice = input('The pH level is too low. Add NaOH to the bioreactor? (y/n): ', 's');
if strcmpi(choice, 'y')
add_amount = 0.20 + 0.40 * rand(); % +0.20 to +0.60
pH = pH + add_amount;
fprintf('Added %.2f units of NaOH. New pH: %.2f\n', add_amount, pH);
end
else
% pH > max_pH
fprintf('(pH slightly high, no action taken.)\n');
end

% Natural downward pH drift
drift = 0.05 * rand();
pH = pH - drift;

%% --- Temperature control section ---
tempC = tempC + (rand() * 0.3 - 0.15); % -0.15 to +0.15 random drift

if tempC < t_min
heat = 0.20 + 0.40 * rand();
tempC = tempC + heat;
fprintf('Temperature low: +%.2f°C heat applied. Temp now: %.2f°C\n', heat, tempC);
elseif tempC > t_max
cool = 0.20 + 0.40 * rand();
tempC = tempC - cool;
fprintf('Temperature high: -%.2f°C cooling applied. Temp now: %.2f°C\n', cool, tempC);
else
fprintf('Temperature OK: %.2f°C\n', tempC);
end

%% --- Safety clamps ---
pH = max(min(pH, 14), 0); % pH realistic range
tempC = max(min(tempC, 200), -100);

pause(1); % Simulated real-time delay (1 second per step)
end
