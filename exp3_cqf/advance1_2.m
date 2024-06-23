clc;
clear;
close all;


% Parameters
f0 = 1000;       % Initial frequency in Hz
k = 12000;       % Chirp rate in Hz/s
t_min = 0;       % Start time in seconds
t_max = 0.1;     % End time in seconds
T = t_max - t_min;
fs = 50000;      % Sampling frequency in Hz

% Time array
t = t_min:1/fs:t_max-1/fs;

% Chirp signal generation
X_t = cos(2 * pi * (f0 * t + k * t.^2));

% Plot the chirp signal
figure;
plot(t, X_t);
title('Chirp Signal');
xlabel('Time (s)');
ylabel('Amplitude');
grid on;

% Simulation parameters
k = 500;
snr_db_range = -50:2:-0;

% Initialize arrays to store results
MSE = zeros(length(snr_db_range), 1);
accuracy = zeros(length(snr_db_range), 1);

% Main loop to evaluate performance over SNR range
for i = 1:length(snr_db_range)
    snr_db = snr_db_range(i);
    sigma2 = mean(X_t.^2) / (10^(snr_db/10)); % Noise variance
    mse = 0;
    success_count = 0;
    
    for n = 1:k
        % Generate random end time
        end_time = 0.11 + (1 - 0.11) * rand;
        start_time = end_time - T;
        % Convert times to indices
        start_idx = round(start_time * fs) + 1;
        end_idx = round(end_time * fs);
        
        % Simulate received signal and add noise
        signal_received = zeros(size(t));
        signal_received(start_idx:end_idx) = X_t;
        noise = sqrt(sigma2) * randn(size(signal_received));
        y = signal_received + noise;
        
        % Window size (0.1s)
        window_length = round(T * fs); 
        step = 1; 
        
        % Compute energy for each window 
        num_windows = floor((length(y) - window_length) / step) + 1;
        window_energy = zeros(num_windows, 1);
        for j = 1:num_windows
            start_index = (j-1)*step + 1;
            end_index = start_index + window_length - 1;
            if end_index > length(y)
                break;
            end
            window = y(start_index:end_index);
            window_energy(j) = sum(window.^2);
        end
        
        % Find position of maximum energy 
        [~, max_idx] = max(window_energy);
        end_time_estimated = (max_idx-1) * step / fs; % Estimated end time

        % Compute error 
        mse = mse + (end_time_estimated - end_time)^2;
        if abs(end_time_estimated - end_time) < 0.3
            success_count = success_count + 1;
        end
    end
    
    % Calculate average MSE and success rate
    MSE(i) = mse / k;
    accuracy(i) = success_count / k;
end

% Display results
results = table(snr_db_range', MSE, accuracy, 'VariableNames', {'SNR_db', 'MSE', 'Success_Rate'});
disp(results);

% Plot MSE results
figure;
subplot(2,1,1);
plot(results.SNR_db, results.MSE, '-o');
xlabel('SNR (dB)');
ylabel('MSE');
title('MSE vs SNR');
grid on;

% Plot Success Rate results
subplot(2,1,2);
plot(results.SNR_db, results.Success_Rate, '-x');
xlabel('SNR (dB)');
ylabel('Success Rate');
title('Success Rate vs SNR');
grid on;
