clc
clear
close all
% Define parameters
fs = 1000; % Sample rate in Hz
t = 0:1/fs:2-1/fs; % Time vector for 2 seconds
omega1 = 100 * pi; % Angular frequency in rad/s
omega2 = 150 * pi; % Angular frequency in rad/s
sigma2 = 0.1; % Variance of the Gaussian noise
M = 100; % Number of runs

% Preallocate storage for periodograms
Pxx_all = zeros(M, length(t));
f_all = [];

% Perform M runs
for i = 1:M
    omegaI = 50 * pi + (80 - 50) * pi * rand; % Randomly distributed omegaI
    N = sqrt(sigma2) * randn(size(t)); % White Gaussian noise with variance sigma^2
    X = sin(omega1 * t) + 2 * cos(omega2 * t) + 4 * cos(omegaI * t) + N;

    % Compute periodogram
    [Pxx, f] = myPeriodogram(X, fs);
    Pxx_all(i, :) = Pxx;

    if i == 1
        Pxx_1 = Pxx;
    elseif i == 50
        Pxx_50 = Pxx;
    elseif i == 100
        Pxx_100 = Pxx;
    end

    if isempty(f_all)
        f_all = f;
    end
end

% Average power spectrum
Pxx_avg = mean(Pxx_all, 1);

% Plotting the results
figure;

subplot(4, 1, 1);
plot(f_all, 10*log10(Pxx_1));
title('Periodogram of the 1st Run');
xlabel('Frequency (Hz)');
ylabel('Power/Frequency (dB/Hz)');

subplot(4, 1, 2);
plot(f_all, 10*log10(Pxx_50));
title('Periodogram of the 50th Run');
xlabel('Frequency (Hz)');
ylabel('Power/Frequency (dB/Hz)');

subplot(4, 1, 3);
plot(f_all, 10*log10(Pxx_100));
title('Periodogram of the 100th Run');
xlabel('Frequency (Hz)');
ylabel('Power/Frequency (dB/Hz)');

subplot(4, 1, 4);
plot(f_all, 10*log10(Pxx_avg));
title('Average Power Spectrum over 100 Runs');
xlabel('Frequency (Hz)');
ylabel('Power/Frequency (dB/Hz)');

set(gcf, 'Units', 'centimeters', 'Position', [10 10 20 25]);

function [Pxx, f] = myPeriodogram(x, fs)
    N = length(x); % Number of samples
    X = fft(x); % FFT of the signal
    Pxx = (1/N) * abs(X).^2; % Periodogram
    f = (0:N-1) * (fs/N); % Frequency vector
end
