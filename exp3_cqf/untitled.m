clc;
clear;
close all;

% Parameters
f0 = 1000;        % Initial frequency
k_chirp = 12000;  % Frequency change rate
T = 0.1;          % Signal duration
fs = 50000;       % Sampling frequency
t = 0:1/fs:T-1/fs; % Time vector

% Generate chirp signal
signal = cos(2*pi*(f0*t + (1/2)*k_chirp*t.^2));

% FFT to compute power spectral density
x_w = fft(signal);  % Compute FFT of signal
N = length(t);      % Signal length
S_w = (abs(x_w)).^2 / N; % Power spectral density

% Simulation parameters
k_simulations = 1000; % Number of simulations (increased for higher accuracy)
SNR_list = -50:2:-10; % SNR values in dB
MSE = zeros(length(SNR_list), 1);
accuracy = zeros(length(SNR_list), 1);

% Preallocate array for storing estimated end times
estimated_end_times = cell(length(SNR_list), 1);

for SNR_idx = 1:length(SNR_list)
    snr = SNR_list(SNR_idx);
    sigma2 = mean(S_w) / (10^(snr/10)); % Noise variance
    total_mse = 0;
    total_success = 0;
    estimated_end_times{SNR_idx} = zeros(k_simulations, 1);
    
    % Simulation loop for each SNR
    for n = 1:k_simulations
        % Generate random end time
        end_time = 0.11 + 0.1;
        start_time = end_time - T;
        
        % Convert times to indices
        start_idx = round(start_time * fs) + 1;
        end_idx = round(end_time * fs);
        
        % Simulate received signal and add noise
        signal_received = zeros(size(t));
        signal_received(start_idx:end_idx) = signal;
        noise = sqrt(sigma2) * randn(size(signal_received));
        y = signal_received + noise;
        
        % Matched filter (reverse signal)
        matched_filter = fliplr(signal);
        
        % Convolve received signal with matched filter
        matched_output = conv(y, matched_filter);
        
        % Find peak in matched filter output to estimate end time
        [~, max_idx] = max(abs(matched_output));
        estimated_end_time = (max_idx - 1) / fs;
        
        % Store the estimated end time
        estimated_end_times{SNR_idx}(n) = estimated_end_time;
        
        % Calculate squared error
        squared_error = (end_time - estimated_end_time)^2;
        total_mse = total_mse + squared_error;
        
        % Check success criteria (accuracy)
        if abs(estimated_end_time - end_time) < 0.03 % Adjusted to 0.01 for higher accuracy
            total_success = total_success + 1;
        end
    end
    
    % Calculate average MSE and accuracy for current SNR
    MSE(SNR_idx) = total_mse / k_simulations;
    accuracy(SNR_idx) = total_success / k_simulations * 100;
end

% Generate table
T = table(SNR_list', accuracy, MSE, 'VariableNames', {'SNR (dB)', 'Accuracy (%)', 'MSE'});

% Display table
disp('Simulation Results:');
disp(T);

% Save the table as an Excel file
writetable(T, 'images/Simulation_Results.xlsx');

% Plot and save MSE and Accuracy results
figure;
subplot(2,1,1);
plot(SNR_list, MSE, 'o-');
title('MSE vs SNR');
xlabel('SNR (dB)');
ylabel('MSE');
grid on;
saveas(gcf, 'images/MSE_vs_SNR.png');

subplot(2,1,2);
plot(SNR_list, accuracy, 'o-');
title('Accuracy vs SNR');
xlabel('SNR (dB)');
ylabel('Accuracy (%)');
grid on;
saveas(gcf, 'images/Accuracy_vs_SNR.png');

% Plot and save histograms of estimated end times for each SNR
for SNR_idx = 1:length(SNR_list)
    figure;
    histogram(estimated_end_times{SNR_idx}, 'Normalization', 'pdf');
    title(['Estimated End Time Distribution for SNR = ', num2str(SNR_list(SNR_idx)), ' dB']);
    xlabel('Estimated End Time (s)');
    ylabel('Probability Density');
    grid on;
    saveas(gcf, ['images/Estimated_End_Time_Distribution_SNR_', num2str(SNR_list(SNR_idx)), '.png']);
end
