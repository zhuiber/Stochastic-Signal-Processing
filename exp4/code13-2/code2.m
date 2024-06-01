clear
clc

N = 100;
F_sam_freq=1000;    %采样频率
F_freq = 200.07; 
omega = F_freq/F_sam_freq*2*pi;
SNR = 10;
Amplitude_A = 1;
n_array=[0:N-1]';
FFT_length = 4096;

Theta = rand(1)*2*pi;
X_signal = Amplitude_A*exp(1j*(omega*n_array+Theta));
Noise_sigma2 = Amplitude_A^2 / [10^(SNR/10)];
Noise = sqrt(Noise_sigma2) * randn(N, 1) .* exp(1j*rand(N, 1)*2*pi);
Y_receive = X_signal + Noise_sigma2;
window = boxcar(N);        %矩形窗
%% the Auto Regressive (AR) method
Y_r1 = Y_receive(2:end);
Y_r2 = Y_receive(1:end-1);
tic
beta_est = (Y_r2'*Y_r2)\Y_r2'*Y_r1;
time_AR = toc;
omega_AR_estimate = angle(beta_est);
freq_AR_estimate = omega_AR_estimate/2/pi*F_sam_freq;

%% test of computational time of 'periodogram'
length_1 = 1001;
length_2 = 10000001;
tic
[Peri_Y, f_Y] = periodogram(Y_receive,window,length_1,F_sam_freq);
time_peri_1e3 = toc;
[Max_value, Max_index] = max(Peri_Y);
F_freq_estimate_1e3 =  (Max_index-1)/length_1*F_sam_freq;

tic
[Peri_Y, f_Y] = periodogram(Y_receive,window,length_2,F_sam_freq);
time_peri_1e7 = toc;
[Max_value, Max_index] = max(Peri_Y);
F_freq_estimate_1e7 =  (Max_index-1)/length_2*F_sam_freq;



