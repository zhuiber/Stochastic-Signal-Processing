% Parameters
N = 1000;       % Number of samples
fs = 1000;      % Sampling frequency (Hz)
T = 1/fs;       % Sampling period
t = (0:N-1)*T;  % Time vector

% Signal parameters
f = 100;          % Signal frequency (Hz)
A = 1;          % Amplitude
theta = pi/4;   % Phase
variances = [0.1, 0.5, 1, 5];  % Variance of Gaussian noise

figure;
for i = 1:length(variances)
    % Generate noisy signal with different noise variances
    variance = variances(i);
    noise = sqrt(variance) * randn(1, N);
    X = A*cos(2*pi*f*t + theta) + noise;
    
    % Compute the autocorrelation of the signal
    [autocor, lags] = xcorr(X, 'coeff');
    
    % Find short period peaks
    [pksh, lcsh] = findpeaks(autocor);
    short = mean(diff(lcsh))/fs;
    
    % Plot the autocorrelation and short period peaks
    subplot(2, 2, i);
    plot(lags/fs, autocor);
    hold on;
    plot(lags(lcsh)/fs, pksh, 'or'); % Plot short period peaks
    hold off;
    legend(['Period: ', num2str(short, 0)]);
    axis([-0.05 0.05 -0.4 1.1]);
    title(['Variance = ', num2str(variance)]);
end
