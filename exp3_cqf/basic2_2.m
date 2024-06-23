clc;
clear;
close all;

% Define parameters
fs = 1000; 
T = 2; 
N = T * fs; 
t = (0:N-1)/fs; 
w1 = 100 * pi; 
w2 = 150 * pi; 
M = 100; 
sigmas2 = [0.1, 1, 10, 100]; 
periodograms = zeros(M, N/2+1); 
f = (0:N/2) * (fs / N);

% Create figure for subplots
figure;

for i = 1:length(sigmas2)
    s = sigmas2(i);
    periodograms = zeros(M, N/2+1); % Preallocate for averaging
    for run = 1:M
        wI = (50*pi) + (80*pi - 50*pi) * rand;
        x1 = sin(w1 * t);
        x2 = 2 * cos(w2 * t);
        x3 = 4 * cos(wI * t);
        N_t = s * randn(size(t));
        X_t = x1 + x2 + x3 + N_t;
        X_fft = fft(X_t);
        Sx_w = (1/N) * abs(X_fft).^2;
        Sx_w = Sx_w(1:N/2+1);
        periodograms(run, :) = Sx_w;
    end
    % Average periodogram
    avg_periodogram = mean(periodograms, 1);
    
    % Plotting
    subplot(4, 1, i);
    plot(f, 10*log10(avg_periodogram));
    title(['Periodogram for \sigma^2 = ', num2str(s)]);
    xlabel('Frequency (Hz)');
    ylabel('Power/Frequency (dB/Hz)');
    xlim([0 100]); % Limit x-axis to 100 Hz
    grid on;
end
