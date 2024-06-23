fs = 1000; % Sampling 
w1 = 100 * pi; 
w2 = 150 * pi; 
t = 0:1/fs:2-1/fs; % Time vector

% Generate the signal
X_t = sin(w1*t) + 2*cos(w2*t);
sigma2 = 0.1;
N_t = sqrt(sigma2) * randn(size(t));
x = X_t + N_t;

% Plot the signal
subplot(1,2,1)
periodogram(x,rectwin(length(x))); % rectangle window
set(get(gca,'title'),'FontSize',10,'FontName','Times New Roman');
set(gca,'fontsize',12,'fontname','times');
xlabel('Normalized frequency (rad/sample)')
ylabel('Power/frequency (dB/(rad/sample))')
title('The power spectrum calculated by rectwin window','fontsize',14);

subplot(1,2,2)
periodogram(x,hamming(length(x))); % hamming window
set(get(gca,'title'),'FontSize',10,'FontName','Times New Roman');
set(gca,'fontsize',12,'fontname','times');
xlabel('Normalized frequency (rad/sample)')
ylabel('Power/frequency (dB/(rad/sample))')
title('The power spectrum calculated by hamming window','fontsize',14);
