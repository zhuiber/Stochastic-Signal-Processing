% Parameters
N = 1000;       % Number of samples
fs = 1000;      % Sampling frequency (Hz)
T = 1/fs;       % Sampling period
t = (0:N-1)*T;  % Time vector

% Signal parameters
f = 100;          % Signal frequency (Hz)
A = 1;          % Amplitude
theta = pi/4;   % Phase
true_period = 1/f;  % True period
variances = [0.1, 0.5, 1, 5];  % Variance of Gaussian noise
num_runs = 100; % Number of runs

accuracies = zeros(num_runs, length(variances));

for i = 1:length(variances)
    variance = variances(i);
    for j = 1:num_runs
        % Generate noisy signal with different noise variances
        noise = sqrt(variance) * randn(1, N);
        X = A*cos(2*pi*f*t + theta) + noise;

        % Compute the autocorrelation of the signal
        [autocor, lags] = xcorr(X, 'coeff');

        % Find short period peaks
        [pksh, lcsh] = findpeaks(autocor);
        if length(lcsh) > 1
            short = mean(diff(lcsh))/fs;
        else
            short = NaN; % In case not enough peaks are found
        end

        % Calculate accuracy
        if ~isnan(short)
            accuracies(j, i) = (true_period - abs(true_period - short)) / true_period;
        else
            accuracies(j, i) = 0; % Assign zero accuracy if estimation failed
        end
    end
end

% Plot histograms of accuracies
figure;
for i = 1:length(variances)
    subplot(2, 2, i);
    histogram(accuracies(:, i), 'Normalization', 'probability');
    title(['Variance = ', num2str(variances(i))]);
    xlabel('Accuracy');
    ylabel('Probability');
    axis([0 1 0 1]); % Set axis limits for better comparison
end
