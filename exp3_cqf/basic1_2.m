% ------------------------------------------------------------
% ------------------------------------------------------------

% Different Sampling Rate
T = 2;
fs = 300; % Sampling
t = 0:1/fs:T-1/fs;
w1 = 100 * pi; 
w2 = 150 * pi; 
sigma2 = 0.1;
N_t = sqrt(sigma2) * randn(size(t));
x = sin(w1*t) + 2*cos(w2*t) +  N_t;

figure(1);
subplot(1,3,1)
periodogram(x,rectwin(length(x))); % rectangle window
set(get(gca,'title'),'FontSize',10,'FontName','Times New Roman');
set(gca,'fontsize',12,'fontname','times');
xlabel('Normalized frequency (rad/sample)')
ylabel('Power/frequency (dB/(rad/sample))')
title('The power spectrum calculated by rectwin window (300hz)','fontsize',14);

T = 2;
fs = 600; % Sampling
t = 0:1/fs:T-1/fs;
w1 = 100 * pi; 
w2 = 150 * pi; 
sigma2 = 0.1;
N_t = sqrt(sigma2) * randn(size(t));
x = sin(w1*t) + 2*cos(w2*t) +  N_t;

subplot(1,3,2)
periodogram(x,rectwin(length(x))); % rectangle window
set(get(gca,'title'),'FontSize',10,'FontName','Times New Roman');
set(gca,'fontsize',12,'fontname','times');
xlabel('Normalized frequency (rad/sample)')
ylabel('Power/frequency (dB/(rad/sample))')
title('The power spectrum calculated by rectwin window (600hz)','fontsize',14);

T = 2;
fs = 900; % Sampling
t = 0:1/fs:T-1/fs;
w1 = 100 * pi; 
w2 = 150 * pi; 
sigma2 = 0.1;
N_t = sqrt(sigma2) * randn(size(t));
x = sin(w1*t) + 2*cos(w2*t) +  N_t;

subplot(1,3,3)
periodogram(x,rectwin(length(x))); % rectangle window
set(get(gca,'title'),'FontSize',10,'FontName','Times New Roman');
set(gca,'fontsize',12,'fontname','times');
xlabel('Normalized frequency (rad/sample)')
ylabel('Power/frequency (dB/(rad/sample))')
title('The power spectrum calculated by rectwin window (900hz)','fontsize',14);


% ------------------------------------------------------------
% ------------------------------------------------------------
% Different Signal length

T = 1;
fs = 1000; % Sampling
t = 0:1/fs:T-1/fs;
w1 = 100 * pi; 
w2 = 150 * pi; 
sigma2 = 0.1;
N_t = sqrt(sigma2) * randn(size(t));
x = sin(w1*t) + 2*cos(w2*t) +  N_t;

figure(2);
subplot(1,3,1)
periodogram(x,rectwin(length(x))); % rectangle window
set(get(gca,'title'),'FontSize',10,'FontName','Times New Roman');
set(gca,'fontsize',12,'fontname','times');
xlabel('Normalized frequency (rad/sample)')
ylabel('Power/frequency (dB/(rad/sample))')
title('The power spectrum calculated by rectwin window (T=1)','fontsize',14);

T = 2;
fs = 1000; % Sampling
t = 0:1/fs:T-1/fs;
w1 = 100 * pi; 
w2 = 150 * pi; 
sigma2 = 0.1;
N_t = sqrt(sigma2) * randn(size(t));
x = sin(w1*t) + 2*cos(w2*t) +  N_t;

subplot(1,3,2)
periodogram(x,rectwin(length(x))); % rectangle window
set(get(gca,'title'),'FontSize',10,'FontName','Times New Roman');
set(gca,'fontsize',12,'fontname','times');
xlabel('Normalized frequency (rad/sample)')
ylabel('Power/frequency (dB/(rad/sample))')
title('The power spectrum calculated by rectwin window (T=2)','fontsize',14);

T = 3;
fs = 1000; % Sampling
t = 0:1/fs:T-1/fs;
w1 = 100 * pi; 
w2 = 150 * pi; 
sigma2 = 0.1;
N_t = sqrt(sigma2) * randn(size(t));
x = sin(w1*t) + 2*cos(w2*t) +  N_t;

subplot(1,3,3)
periodogram(x,rectwin(length(x))); % rectangle window
set(get(gca,'title'),'FontSize',10,'FontName','Times New Roman');
set(gca,'fontsize',12,'fontname','times');
xlabel('Normalized frequency (rad/sample)')
ylabel('Power/frequency (dB/(rad/sample))')
title('The power spectrum calculated by rectwin window (T=3)','fontsize',14);

% ------------------------------------------------------------
% ------------------------------------------------------------
% Different FFT length

T = 2;
fs = 1000; % Sampling
t = 0:1/fs:T-1/fs;
w1 = 100 * pi; 
w2 = 150 * pi; 
sigma2 = 0.1;
N_t = sqrt(sigma2) * randn(size(t));
x = sin(w1*t) + 2*cos(w2*t) +  N_t;

figure(3);
subplot(1,3,1)
periodogram(x,rectwin(length(x)),fix(length(x)/3)); % rectangle window
set(get(gca,'title'),'FontSize',10,'FontName','Times New Roman');
set(gca,'fontsize',12,'fontname','times');
xlabel('Normalized frequency (rad/sample)')
ylabel('Power/frequency (dB/(rad/sample))')
title('The power spectrum calculated by rectwin window (1/3 length(x))','fontsize',14);

T = 2;
fs = 1000; % Sampling
t = 0:1/fs:T-1/fs;
w1 = 100 * pi; 
w2 = 150 * pi; 
sigma2 = 0.1;
N_t = sqrt(sigma2) * randn(size(t));
x = sin(w1*t) + 2*cos(w2*t) +  N_t;

subplot(1,3,2)
periodogram(x,rectwin(length(x)),fix(2*length(x)/3)); % rectangle window
set(get(gca,'title'),'FontSize',10,'FontName','Times New Roman');
set(gca,'fontsize',12,'fontname','times');
xlabel('Normalized frequency (rad/sample)')
ylabel('Power/frequency (dB/(rad/sample))')
title('The power spectrum calculated by rectwin window (2/3 length(x))','fontsize',14);

T = 2;
fs = 1000; % Sampling
t = 0:1/fs:T-1/fs;
w1 = 100 * pi; 
w2 = 150 * pi; 
sigma2 = 0.1;
N_t = sqrt(sigma2) * randn(size(t));
x = sin(w1*t) + 2*cos(w2*t) +  N_t;

subplot(1,3,3)
periodogram(x,rectwin(length(x))); % rectangle window
set(get(gca,'title'),'FontSize',10,'FontName','Times New Roman');
set(gca,'fontsize',12,'fontname','times');
xlabel('Normalized frequency (rad/sample)')
ylabel('Power/frequency (dB/(rad/sample))')
title('The power spectrum calculated by rectwin window (length(x))','fontsize',14);


% ------------------------------------------------------------
% ------------------------------------------------------------
% Different sigma

T = 2;
fs = 1000; % Sampling
t = 0:1/fs:T-1/fs;
w1 = 100 * pi; 
w2 = 150 * pi; 
sigma2 = 0.1;
N_t = sqrt(sigma2) * randn(size(t));
x = sin(w1*t) + 2*cos(w2*t) +  N_t;

figure;
subplot(1,3,1)
periodogram(x,rectwin(length(x))); % rectangle window
set(get(gca,'title'),'FontSize',10,'FontName','Times New Roman');
set(gca,'fontsize',12,'fontname','times');
xlabel('Normalized frequency (rad/sample)')
ylabel('Power/frequency (dB/(rad/sample))')
title('The power spectrum calculated by rectwin window (sigma=0.1)','fontsize',14);

T = 2;
fs = 1000; % Sampling
t = 0:1/fs:T-1/fs;
w1 = 100 * pi; 
w2 = 150 * pi; 
sigma2 = 0.3;
N_t = sqrt(sigma2) * randn(size(t));
x = sin(w1*t) + 2*cos(w2*t) +  N_t;

subplot(1,3,2)
periodogram(x,rectwin(length(x))); % rectangle window
set(get(gca,'title'),'FontSize',10,'FontName','Times New Roman');
set(gca,'fontsize',12,'fontname','times');
xlabel('Normalized frequency (rad/sample)')
ylabel('Power/frequency (dB/(rad/sample))')
title('The power spectrum calculated by rectwin window (sigma=0.3)','fontsize',14);

T = 2;
fs = 1000; % Sampling
t = 0:1/fs:T-1/fs;
w1 = 100 * pi; 
w2 = 150 * pi; 
sigma2 = 0.5;
N_t = sqrt(sigma2) * randn(size(t));
x = sin(w1*t) + 2*cos(w2*t) +  N_t;

subplot(1,3,3)
periodogram(x,rectwin(length(x))); % rectangle window
set(get(gca,'title'),'FontSize',10,'FontName','Times New Roman');
set(gca,'fontsize',12,'fontname','times');
xlabel('Normalized frequency (rad/sample)')
ylabel('Power/frequency (dB/(rad/sample))')
title('The power spectrum calculated by rectwin window (sigma=0.5)','fontsize',14);


