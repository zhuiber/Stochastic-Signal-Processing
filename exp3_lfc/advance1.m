close all;
clear;
clc;

fs = 50000;      % Sample rate
f0 = 1000;       % Starting frequency
kf0 = 12000;     % Frequency sweep rate
T_end = 0.1;     % Duration of the chirp signal
T = 1/fs;        % Sampling period
t = 0:T:T_end-T; % Time vector for the chirp signal
rng(1);          % Set random seed to observe the result

% Generate the transmitted chirp signal
x = cos(2*pi*(f0*t + 0.5*kf0*t.^2));

% Number of tests
N = 500;

% SNR values (in dB) to test
SNR_values = [1000]; % Example SNR values

% Initialize results
MSE = zeros(1, length(SNR_values));
success_rate = zeros(1, length(SNR_values));

% Loop over different SNR values
for s = 1:length(SNR_values)
    SNR_dB = SNR_values(s);
    SNR_linear = 10^(SNR_dB/10);
    Ps = mean(abs(x).^2);
    sigma2 = Ps / SNR_linear;
    sigma = sqrt(sigma2);

    estimated_times = zeros(1, N);
    true_times = zeros(1, N);
    
    for k = 1:N
        % Random delay between 0.11s and 1s
        delay = 0.11 + (1 - 0.11) * rand;
        
        % Generate received signal with noise
        y = [zeros(1, round(delay*fs)), x];
        y = y + sigma * randn(size(y));
        
        % Matched filter implementation
        h = fliplr(x);    % Impulse response of the matched filter
        mf_output = conv(y, h); % Filter the received signal

        % Apply cross-correlation to find the time delay
        [cc, lags] = xcorr(mf_output, x);
        
        % Smooth the cross-correlation result
        cc_smooth = smoothdata(cc, 'gaussian', 10);
        
        % Find the peak in the smoothed cross-correlation output
        [~, I] = max(cc_smooth);
        t_estimated_start = lags(I) / fs;
        
        % Fine-tuning around the peak
        search_range = max(1, I-10) : min(length(cc_smooth), I+10);
        [~, refined_index] = max(cc_smooth(search_range));
        refined_index = search_range(refined_index);
        t_estimated_start = lags(refined_index) / fs;
        
        % Calculate the end time based on the duration of the chirp signal
        t_estimated_end = t_estimated_start + T_end;
        
        % Store the estimated and true end time
        estimated_times(k) = t_estimated_end;
        true_times(k) = delay + T_end;
    end
    
    % Calculate MSE
    MSE(s) = mean((estimated_times - true_times).^2);
    
    % Calculate success rate
    success_count = sum(abs(estimated_times - true_times) < 0.03);
    success_rate(s) = success_count / N;
    
    % Plot the distribution of estimated end times
    figure;
    histogram(estimated_times, 'Normalization', 'pdf');
    hold on;
    xline(mean(true_times), 'r', 'LineWidth', 2, 'Label', 'True End Time');
    xlabel('Estimated End Time (s)');
    ylabel('Probability Density');
    title(['Estimated End Time Distribution (SNR = ', num2str(SNR_dB), ' dB)']);
    hold off;
end

% Display results
disp('MSE for different SNR values:');
disp(MSE);
disp('Success rate for different SNR values:');
disp(success_rate);
