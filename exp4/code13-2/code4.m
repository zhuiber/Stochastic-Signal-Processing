clear
clc

N = 8;
T_snapshot = 100; 
F_sam_freq=1000;    %采样频率
F_freq = 200.07; 
omega = F_freq/F_sam_freq*2*pi;
SNR = 10;
Amplitude_A_mean = 0;
Amplitude_A_std = 1;
n_array = [0:N-1]';
t_array = [0:T_snapshot-1];
% FFT_length = 4096;

Theta = rand(1)*2*pi;
Amplitude_At = Amplitude_A_std*randn(1,T_snapshot)+Amplitude_A_mean;
Theta_t = rand(1,T_snapshot)*2*pi;
Frequnecy_t = exp(1j*omega*n_array);
X_signal = Frequnecy_t * (Amplitude_At.*exp(1j*Theta_t));
X_reshape = reshape(X_signal, N*T_snapshot, 1);
X_signal_power = X_reshape'*X_reshape/(N*T_snapshot);
Noise_sigma2 = X_signal_power / [10^(SNR/10)];
Noise = sqrt(Noise_sigma2) * randn(N, T_snapshot) .* exp(1j*rand(N, T_snapshot)*2*pi);
Y_receive = X_signal + Noise;

%% detection method
Y_cov_matrix = Y_receive*Y_receive';
[SigNoise_Vectors,SigNoise_Values] = eig(Y_cov_matrix);

Noise_cov_matrix = Noise*Noise';
[Noise_Vectors,Noise_Values] = eig(Noise_cov_matrix);



