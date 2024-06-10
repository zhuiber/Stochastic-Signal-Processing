clc
clear
close all
% Define parameters
fs = 1000; % Sample rate in Hz
t = 0:1/fs:2-1/fs; % Time vector for 2 seconds
omega1 = 100 * pi; % Angular frequency in rad/s
omega2 = 150 * pi; % Angular frequency in rad/s
sigma2 = 0.1; % Variance of the Gaussian noise

% Generate the signal
N = sqrt(sigma2) * randn(size(t)); % White Gaussian noise with variance sigma^2
X = sin(omega1 * t) + 2 * cos(omega2 * t) + N;

% Compute periodograms
[Pxx_my, f_my] = myPeriodogram(X, fs);
[Sxx_my, f_my_corr] = myCorrelogram(X, fs);

% Default MATLAB periodogram for comparison
[Pxx_default, f_default] = periodogram(X, rectwin(length(X)), [], fs);

% Plotting the results
figure;

subplot(3, 1, 1);
plot(f_default, 10*log10(Pxx_default));
title('Default Periodogram');
xlabel('Frequency (Hz)');
ylabel('Power/Frequency (dB/Hz)');

subplot(3, 1, 2);
plot(f_my, 10*log10(Pxx_my));
title('Custom Periodogram');
xlabel('Frequency (Hz)');
ylabel('Power/Frequency (dB/Hz)');

subplot(3, 1, 3);
plot(f_my_corr, 10*log10(Sxx_my));
title('Custom Correlogram');
xlabel('Frequency (Hz)');
ylabel('Power/Frequency (dB/Hz)');

set(gcf, 'Units', 'centimeters', 'Position', [10 10 20 25]);


function [Pxx, f] = myPeriodogram(x, fs)
N = length(x); % Number of samples
X = fft(x); % FFT of the signal
Pxx = (1/N) * abs(X).^2; % Periodogram
f = (0:N-1) * (fs/N); % Frequency vector
end

function [Sxx, f] = myCorrelogram(x, fs)
N = length(x); % Number of samples
Rxx = xcorr(x, 'biased'); % Biased autocorrelation
mid = ceil(length(Rxx)/2); % Middle index
Rxx = Rxx(mid:end); % Take one side of the autocorrelation
Sxx = fft(Rxx); % FFT of the autocorrelation
Sxx = Sxx(1:N); % Take the first N points
f = (0:N-1) * (fs/N); % Frequency vector
end