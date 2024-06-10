clc
clear
close all

% Define parameters
fs = 1000; % Sample rate in Hz
t = 0:1/fs:2-1/fs; % Time vector for 2 seconds
omega1 = 100 * pi; % Angular frequency in rad/s
omega2 = 150 * pi; % Angular frequency in rad/s
sigma2_values = [0.01, 0.1, 0.5, 1.0]; % Different noise variances
M = 100; % Number of runs

% Preallocate storage for periodograms
Pxx_all = zeros(length(sigma2_values), M, length(t));
f_all = [];

% Loop through each sigma^2 value
for s_idx = 1:length(sigma2_values)
    sigma2 = sigma2_values(s_idx);

    % Perform M runs for each sigma^2
    for i = 1:M
        omegaI = 50 * pi + (80 - 50) * pi * rand; % Randomly distributed omegaI
        N = sqrt(sigma2) * randn(size(t)); % White Gaussian noise with variance sigma^2
        X = sin(omega1 * t) + 2 * cos(omega2 * t) + 4 * cos(omegaI * t) + N;

        % Compute periodogram
        [Pxx, f] = myPeriodogram(X, fs);
        Pxx_all(s_idx, i, :) = Pxx;

        if isempty(f_all)
            f_all = f;
        end
    end

    % Average power spectrum for current sigma^2
    Pxx_avg = mean(squeeze(Pxx_all(s_idx, :, :)), 1);

    % Plotting the average power spectrum
    figure;
    plot(f_all, 10*log10(Pxx_avg));
    title(['Average Power Spectrum for \sigma^2 = ', num2str(sigma2)]);
    xlabel('Frequency (Hz)');
    ylabel('Power/Frequency (dB/Hz)');
    set(gca, 'FontSize', 12, 'FontName', 'Times');
end

% Plotting all power spectra in a single figure for comparison
figure;
hold on;
colors = {'b', 'r', 'g', 'm'};
legends = cell(length(sigma2_values), 1);
for s_idx = 1:length(sigma2_values)
    Pxx_avg = mean(squeeze(Pxx_all(s_idx, :, :)), 1);
    plot(f_all, 10*log10(Pxx_avg), 'Color', colors{s_idx});
    legends{s_idx} = ['\sigma^2 = ', num2str(sigma2_values(s_idx))];
end
title('Comparison of Average Power Spectra for Different \sigma^2 Values');
xlabel('Frequency (Hz)');
ylabel('Power/Frequency (dB/Hz)');
legend(legends);
set(gca, 'FontSize', 12, 'FontName', 'Times');
hold off;

function [Pxx, f] = myPeriodogram(x, fs)
    N = length(x); % Number of samples
    X = fft(x); % FFT of the signal
    Pxx = (1/N) * abs(X).^2; % Periodogram
    f = (0:N-1) * (fs/N); % Frequency vector
end
