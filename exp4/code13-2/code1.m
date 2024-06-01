clear
clc

N = 100;
F_sam_freq=1000;    %采样频率
F_freq = 200; 
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
[Peri_Y, f_Y] = periodogram(Y_receive,window,FFT_length,F_sam_freq);
[Max_value, Max_index] = max(Peri_Y);

F_freq_estimate = (Max_index-1)/FFT_length*F_sam_freq;
omega_estimate  = (Max_index-1)/FFT_length*2*pi;

figure(1)
X_plot = [0:FFT_length-1]/FFT_length*2;
plot(X_plot, Peri_Y)


%% test of computational time of 'periodogram'
length_1 = 1001;
length_2 = 10000001;
tic
[Peri_Y, f_Y] = periodogram(Y_receive,window,length_1,F_sam_freq);
time_1 = toc;
[Max_value, Max_index] = max(Peri_Y);
F_freq_estimate_1 =  (Max_index-1)/length_1*F_sam_freq;

tic
[Peri_Y, f_Y] = periodogram(Y_receive,window,length_2,F_sam_freq);
time_2 = toc;
[Max_value, Max_index] = max(Peri_Y);
F_freq_estimate_2 =  (Max_index-1)/length_2*F_sam_freq;



