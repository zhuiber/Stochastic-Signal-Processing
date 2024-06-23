clc
clear
% Parameters
f1 = 1; % Frequency in Hz
f2 = 150; % Frequency in Hz
sigma_sq = 0.1; % Variance of noise
duration = 4; % Duration in seconds
Fs = 1000; % Sampling frequency in Hz

% Time vector
t = 0:1/Fs:duration-1/Fs;

% Stochastic signal
X = sin(2*pi*f1*t) + 2*cos(2*pi*f2*t) + sqrt(sigma_sq)*randn(size(t));

% Autocorrelation
[RX, lags] = xcorr(X, 'coeff');

% White Gaussian noise
N = sqrt(sigma_sq)*randn(size(t));

% Cross-correlation
[RXN, lags] = xcorr(X, N, 'coeff');

% Plotting
figure;

subplot(3,1,1);
plot(t, X);
title('Stochastic Signal X(t)');
xlabel('Time (s)');
ylabel('Amplitude');

subplot(3,1,2);
plot(lags/Fs, RX);
title('Autocorrelation R_X(\tau)');
xlabel('Lag (\tau)');
ylabel('Correlation');

subplot(3,1,3);
plot(lags/Fs, RXN);
title('Cross-Correlation R_{XN}(\tau)');
xlabel('Lag (\tau)');
ylabel('Correlation');

sgtitle('Stochastic Signal Analysis');
