clc;
clear;

% Parameters
fs = 50000; % Sampling frequency (Hz)
f0 = 1000; % Initial frequency (Hz)
k = 12000; % Frequency slope (Hz/s)
T = 0.1; % Duration of the linear frequency modulated signal (s)
t = 0:1/fs:T-1/fs; % Time vector

% Generate linear frequency modulated signal
X = cos(2*pi*(f0*t + 0.5*k*t.^2));

% Signal-to-noise ratios (SNR) to test
SNR_values = [-20, -10, 0, 10]; % SNR values in dB

% True end time range
t_min = 0.11;
t_max = 1;

% Number of simulations
N = 100; % Reduce the number of simulations for faster runtime

% Preallocate arrays for results
MSE_periodogram = zeros(length(SNR_values), 1);
success_rate_periodogram = zeros(length(SNR_values), 1);

% Loop over different SNR values
for snr_idx = 1:length(SNR_values)
    SNR = SNR_values(snr_idx);
    successes = 0;
    errors = zeros(1, N);
    
    % Precompute noise standard deviation for current SNR
    sigma = sqrt(mean(X.^2) / (10^(SNR / 10)));
    
    % Precompute random noise sequences to save time
    noise_sequences = sigma * randn(N, round((t_max + T) * fs));
    
    % Loop over number of simulations
    for k = 1:N
        % Generate random true end time
        t_shift_true = t_min + (t_max - t_min) * rand;
        
        % Compute signal length
        signal_length = round((t_shift_true + T) * fs);
        
        % Generate received signal with noise
        Y = [zeros(1, round(t_shift_true * fs)), X, zeros(1, signal_length - length(X) - round(t_shift_true * fs))];
        Y = Y + noise_sequences(k, 1:length(Y));
        
        % Window size and sliding step
        window_length = T * fs; % Window size (0.1s)
        step = 50; % Increase step size to reduce computational load
        
        % Compute energy for each window using sum of squares
        num_windows = floor((length(Y) - window_length) / step) + 1;
        window_energies = zeros(num_windows, 1);
        
        for i = 1:num_windows
            start_idx = (i - 1) * step + 1;
            end_idx = start_idx + window_length - 1;
            if end_idx <= length(Y)
                window = Y(start_idx:end_idx);
                window_energies(i) = sum(window.^2); % Sum of squared magnitudes
            end
        end
        
        % Find position of maximum energy
        [~, max_idx] = max(window_energies);
        t_end_est = (max_idx - 1) * step / fs; % Estimated end time
        
        % Calculate error (end time)
        error = abs(t_end_est - t_shift_true);
        errors(k) = error;
        
        % Check if estimation is successful
        if error < 0.02  % Adjust error threshold as needed
            successes = successes + 1;
        end
    end
    
    % Calculate mean squared error (MSE)
    MSE_periodogram(snr_idx) = mean(errors.^2);
    
    % Calculate success rate
    success_rate_periodogram(snr_idx) = successes / N;
end

% Display results
disp('MSE using Periodogram:');
disp(MSE_periodogram);
disp('Success Rate using Periodogram:');
disp(success_rate_periodogram);

% Plot results
figure;

% Plot MSE vs SNR
subplot(2, 1, 1);
plot(SNR_values, MSE_periodogram, '-o');
title('MSE vs SNR (Periodogram)');
xlabel('SNR (dB)');
ylabel('MSE');
grid on;

% Plot Success Rate vs SNR
subplot(2, 1, 2);
plot(SNR_values, success_rate_periodogram, '-o');
title('Success Rate vs SNR (Periodogram)');
xlabel('SNR (dB)');
ylabel('Success Rate');
ylim([0 1]);
grid on;
