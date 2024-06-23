% Define parameters
f0 = 1000; % Frequency in Hz
k = 12000; % Chirp rate in Hz^2

% Define time vector
t = 0:1e-6:0.1; % Time vector from 0 to 0.002 seconds with a step size of 1e-6 seconds

% Calculate the signal
X_t = cos(2 * pi * (f0 * t + 0.5 * k * t.^2));

% Plot the signal
figure;
plot(t, X_t);
xlabel('Time (s)');
ylabel('X(t)');
title('Plot of X(t) = cos(2\pi(f_0 t + 0.5 k t^2))');
grid on;
