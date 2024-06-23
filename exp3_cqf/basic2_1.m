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
sigma2 = 0.1; 

periodograms = zeros(M, N/2+1);

for k = 1:M
    % Uniformly distributed omega_I for each run
    wI = (50*pi) + (80*pi - 50*pi) * rand;
    
    % Generate signals
    x1 = sin(w1 * t);
    x2 = 2 * cos(w2 * t);
    x3 = 4 * cos(wI * t);
    N_t = sigma2 * randn(size(t));
    X_t = x1 + x2 + x3 + N_t;
    
    % Compute the periodogram
    X_fft = fft(X_t);
    Sx_w = (1/N) * abs(X_fft).^2;
    Sx_w = Sx_w(1:N/2+1);
    periodograms(k, :) = Sx_w;
    % Store periodograms of specific runs for plotting
    if k == 1
        Pxx_1 = Sx_w;
    elseif k == 50
        Pxx_50 = Sx_w;
    elseif k == 100
        Pxx_100 = Sx_w;
    end
end

% Average periodogram to get power spectrum
avg_periodogram = mean(periodograms, 1);
f = (0:N/2) * (fs / N);

% Plotting
figure;
subplot(4,1,1);
plot(f, 10*log10(Pxx_1));
title('Periodogram of the 1st Run');
xlabel('Frequency (Hz)');
ylabel('Power/Frequency (dB/Hz)');
xlim([0 100]); % Limit x-axis to 100 Hz
grid on;

subplot(4,1,2);
plot(f, 10*log10(Pxx_50));
title('Periodogram of the 50th Run');
xlabel('Frequency (Hz)');
ylabel('Power/Frequency (dB/Hz)');
xlim([0 100]); % Limit x-axis to 100 Hz

grid on;

subplot(4,1,3);
plot(f, 10*log10(Pxx_100));
title('Periodogram of the 100th Run');
xlabel('Frequency (Hz)');
ylabel('Power/Frequency (dB/Hz)');
xlim([0 100]); % Limit x-axis to 100 Hz

grid on;

subplot(4,1,4);
plot(f, 10*log10(avg_periodogram));
title('Average Power Spectrum');
xlabel('Frequency (Hz)');
ylabel('Power/Frequency (dB/Hz)');
xlim([0 100]); % Limit x-axis to 100 Hz
grid on;
