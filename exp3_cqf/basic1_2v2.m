% ------------------------------------------------------------
% ------------------------------------------------------------

% Different Sampling Rate
figure(1);
sampling_rates = [300, 600, 900];
for i = 1:length(sampling_rates)
    T = 2;
    fs = sampling_rates(i); % Sampling frequency
    t = 0:1/fs:T-1/fs; % Time vector
    w1 = 100 * pi; 
    w2 = 150 * pi; 
    sigma2 = 0.1; % Noise variance
    N_t = sqrt(sigma2) * randn(size(t)); % Noise generation
    x = sin(w1*t) + 2*cos(w2*t) +  N_t; % Signal generation
    
    subplot(1,3,i)
    periodogram(x,rectwin(length(x))); % Periodogram with rectangular window
    set(get(gca,'title'),'FontSize',10,'FontName','Times New Roman');
    set(gca,'fontsize',12,'fontname','times');
    xlabel('Normalized frequency (rad/sample)')
    ylabel('Power/frequency (dB/(rad/sample))')
    title(['The power spectrum calculated by rectwin window (', num2str(fs), 'hz)'],'fontsize',14);
end

% ------------------------------------------------------------
% ------------------------------------------------------------
% Different Signal length

figure(2);
signal_lengths = [1, 2, 3];
fs = 1000; % Sampling frequency
for i = 1:length(signal_lengths)
    T = signal_lengths(i);
    t = 0:1/fs:T-1/fs; % Time vector
    w1 = 100 * pi; 
    w2 = 150 * pi; 
    sigma2 = 0.1; % Noise variance
    N_t = sqrt(sigma2) * randn(size(t)); % Noise generation
    x = sin(w1*t) + 2*cos(w2*t) +  N_t; % Signal generation
    
    subplot(1,3,i)
    periodogram(x,rectwin(length(x))); % Periodogram with rectangular window
    set(get(gca,'title'),'FontSize',10,'FontName','Times New Roman');
    set(gca,'fontsize',12,'fontname','times');
    xlabel('Normalized frequency (rad/sample)')
    ylabel('Power/frequency (dB/(rad/sample))')
    title(['The power spectrum calculated by rectwin window (T=', num2str(T), ')'],'fontsize',14);
end

% ------------------------------------------------------------
% ------------------------------------------------------------
% Different FFT length

figure(3);
fft_lengths = [1/3, 2/3, 1];
T = 2;
fs = 1000; % Sampling frequency
t = 0:1/fs:T-1/fs; % Time vector
w1 = 100 * pi; 
w2 = 150 * pi; 
sigma2 = 0.1; % Noise variance
N_t = sqrt(sigma2) * randn(size(t)); % Noise generation
x = sin(w1*t) + 2*cos(w2*t) +  N_t; % Signal generation
for i = 1:length(fft_lengths)
    subplot(1,3,i)
    periodogram(x,rectwin(length(x)),fix(fft_lengths(i)*length(x))); % Periodogram with rectangular window
    set(get(gca,'title'),'FontSize',10,'FontName','Times New Roman');
    set(gca,'fontsize',12,'fontname','times');
    xlabel('Normalized frequency (rad/sample)')
    ylabel('Power/frequency (dB/(rad/sample))')
    title(['The power spectrum calculated by rectwin window (', num2str(fft_lengths(i)), ' length(x))'],'fontsize',14);
end

% ------------------------------------------------------------
% ------------------------------------------------------------
% Different sigma

figure(4);
sigmas = [0.1, 0.3, 0.5];
T = 2;
fs = 1000; % Sampling frequency
t = 0:1/fs:T-1/fs; % Time vector
w1 = 100 * pi; 
w2 = 150 * pi; 
for i = 1:length(sigmas)
    sigma2 = sigmas(i); % Noise variance
    N_t = sqrt(sigma2) * randn(size(t)); % Noise generation
    x = sin(w1*t) + 2*cos(w2*t) +  N_t; % Signal generation
    
    subplot(1,3,i)
    periodogram(x,rectwin(length(x))); % Periodogram with rectangular window
    set(get(gca,'title'),'FontSize',10,'FontName','Times New Roman');
    set(gca,'fontsize',12,'fontname','times');
    xlabel('Normalized frequency (rad/sample)')
    ylabel('Power/frequency (dB/(rad/sample))')
    title(['The power spectrum calculated by rectwin window (sigma=', num2str(sigma2), ')'],'fontsize',14);
end
