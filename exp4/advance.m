clc
clear
close all
% Parameters
f0 = 1000; % Hz
k = 12000; % Hz/s
t_min = 0; % s
t_max = 0.1; % s
fs = 50000; % Hz
N = 500; % Number of tests
SNRs = -1000:50:-400; % Range of SNRs to test, extended for clear 100% success and 100% fail
dt = 1/fs;
t = t_min:dt:t_max-dt;
chirp_signal = cos(2*pi*(f0*t + 0.5*k*t.^2));

% Preallocate arrays
MSE = zeros(size(SNRs));
success_rate = zeros(size(SNRs));

for i = 1:length(SNRs)
    snr = SNRs(i);
    errors = zeros(1, N);
    successes = 0;
    for j = 1:N
        % Generate the delayed signal
        delay = 0.11 + (1 - 0.11) * rand();
        delay_samples = round(delay * fs);
        received_signal = [zeros(1, delay_samples), chirp_signal, zeros(1, fs - delay_samples - length(chirp_signal))];
        
        % Add noise
        noisy_signal = awgn(received_signal, snr, 'measured');
        
        % Matched filter (time-reversed chirp signal)
        h = flip(chirp_signal);
        mf_output = conv(noisy_signal, h, 'same');
        
        % Find the peak
        [~, peak_idx] = max(mf_output);
        estimated_delay = (peak_idx - length(chirp_signal)) / fs;
        
        % Calculate error
        error = (estimated_delay - delay)^2;
        errors(j) = error;
        
        % Check success
        if abs(estimated_delay - delay) < 0.03
            successes = successes + 1;
        end
    end
    MSE(i) = mean(errors);
    success_rate(i) = successes / N;
end

% Plot results
figure;
subplot(2, 1, 1);
plot(SNRs, MSE, 'o-');
xlabel('SNR (dB)');
ylabel('MSE');
title('Mean Squared Error vs SNR');

subplot(2, 1, 2);
plot(SNRs, success_rate, 'o-');
xlabel('SNR (dB)');
ylabel('Success Rate');
title('Success Rate vs SNR');
grid on;
