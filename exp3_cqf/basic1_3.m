clearvars;

% Signal parameters
T = 2;
fs = 1000; % Sampling rate
t = 0:1/fs:T-1/fs;
w1 = 100 * pi; 
w2 = 150 * pi; 
sigma2 = 0.1;
N_t = sqrt(sigma2) * randn(size(t));
x = sin(w1*t) + 2*cos(w2*t) +  N_t;

% Compute spectra using different methods
% Default periodogram (rectangular window)
[pxx_rect, f_rect] = periodogram(x, rectwin(length(x)), [], fs);
% Default periodogram (Hamming window)
[pxx_hamming, f_hamming] = periodogram(x, hamming(length(x)), [], fs);
% Custom periodogram
[Pxx_custom, f_custom] = custom_periodogram(x, fs);
% Custom correlogram
[Pxx_corr, f_corr] = custom_correlogram(x, fs);


figure;

% Plot default periodogram (rectangular window)
subplot(2,2,1);
plot(f_rect, 10*log10(pxx_rect));
xlabel('Frequency (Hz)');
ylabel('Power/frequency (dB/Hz)');
title('Default Periodogram (Rectangular Window)');
grid on;

% Plot default periodogram (Hamming window)
subplot(2,2,2);
plot(f_hamming, 10*log10(pxx_hamming));
xlabel('Frequency (Hz)');
ylabel('Power/frequency (dB/Hz)');
title('Default Periodogram (Hamming Window)');
grid on;

% Plot custom periodogram
subplot(2,2,3);
plot(f_custom, 10*log10(Pxx_custom));
xlabel('Frequency (Hz)');
ylabel('Power/frequency (dB/Hz)');
title('Custom Periodogram');
xlim([0, 500]); 
grid on;

% Plot custom correlogram
subplot(2,2,4);
plot(f_corr, 10*log10(Pxx_corr));
xlabel('Frequency (Hz)');
ylabel('Power/frequency (dB/Hz)');
title('Custom Correlogram');
xlim([0, 500]); 
grid on;
% Adjust figure properties
set(gcf, 'Position', [100, 100, 1000, 800]); % Adjust figure size


figure;
hold on;
plot(f_rect, 10*log10(pxx_rect), 'r', 'DisplayName', 'Default (Rectangular)');
plot(f_hamming, 10*log10(pxx_hamming), 'b', 'DisplayName', 'Default (Hamming)');
plot(f_custom, 10*log10(Pxx_custom), 'g', 'DisplayName', 'Custom Periodogram');
plot(f_corr, 10*log10(Pxx_corr), 'm', 'DisplayName', 'Custom Correlogram');

hold off;
title('Comparison of Spectral Estimation Methods');
xlabel('Frequency (Hz)');
ylabel('Power Spectral Density (dB/Hz)');
xlim([0, 200]);  % Adjust xlim as needed
grid on;
legend('show', 'Location', 'best');

% Custom periodogram function
function [Pxx, f] = custom_periodogram(x, fs)
    N = length(x);
    X_fft = fft(x);
    Pxx = (1/N) * abs(X_fft).^2;
    f = (0:N-1)*(fs/N); % Frequency vector in Hz
end

% Custom correlogram function
function [Pxx, f] = custom_correlogram(x, fs)
    N = length(x);
    X_fft = xcorr(x, 'biased');
    Rxx = fft(X_fft);
    Pxx = (1/fs) * abs(fftshift(Rxx)).^2; 
    f = linspace(-fs/2, fs/2, length(Pxx));
end

