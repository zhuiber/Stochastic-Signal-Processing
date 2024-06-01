clc;
clear;
close all;
load noise.mat; % 加载特殊噪声

% 读取原始音频信号
[sig_ori, FS] = audioread('test_audio.wav');  
sig_ori = sig_ori';
Lsig = length(sig_ori);     % 信号长度
dt = 1 / FS;    % 采样间隔
t = 0:dt:Lsig/FS;
t = t(1:Lsig);  

N = 44100; % 采样率

% 麦克风和源的参数
M = 8; % 8个麦克风
c = 340; % 声速，单位：m/s

% 8个麦克风的位置
Loc = zeros(2, M); % 初始化位置矩阵
for i = 0:7
    Loc(2, i+1) = 0.085 * i; % 设置麦克风的y坐标
end

% 生成随机DOA
theta = (rand * pi) - (pi / 2); % 随机生成[-π/2, π/2]范围内的DOA
fprintf('True DOA: %.2f degrees\n', theta * (180/pi));

% 计算到达时间差
tau = (Loc(2,:) * sin(theta)) / c;

% 生成多麦克风信号
mic_signals = zeros(M, Lsig);
for m = 1:M
    delay_samples = round(tau(m) * FS);
    if delay_samples < 0
        mic_signals(m, 1:(Lsig + delay_samples)) = sig_ori((-delay_samples + 1):end);
    else
        mic_signals(m, (delay_samples + 1):end) = sig_ori(1:(Lsig - delay_samples));
    end
end

% 添加噪声
SNR_dB = 0; % 可以更改为其他值测试
noise_level = 10^(-SNR_dB/20);
noise = noise_level * randn(size(mic_signals));
mic_signals_noisy = mic_signals + noise;

% 延时求和波束形成
angles = -pi/2:pi/180:pi/2; % 评估角度范围
P = zeros(size(angles));

for ai = 1:length(angles)
    angle = angles(ai);
    tau_est = (Loc(2,:) * sin(angle)) / c;
    aligned_signals = zeros(M, Lsig);

    for m = 1:M
        delay_samples = round(tau_est(m) * FS);
        if delay_samples < 0
            aligned_signals(m, 1:(Lsig + delay_samples)) = mic_signals_noisy(m, (-delay_samples + 1):end);
        else
            aligned_signals(m, (delay_samples + 1):end) = mic_signals_noisy(m, 1:(Lsig - delay_samples));
        end
    end
    
    P(ai) = mean(sum(aligned_signals, 1).^2); % 延时求和后的信号平均功率
end

% 找到最大功率对应的角度
[~, max_idx] = max(P);
estimated_angle = angles(max_idx);
fprintf('Estimated DOA: %.2f degrees\n', - estimated_angle * (180/pi));

% 绘制波束形成结果
figure;
plot(angles * (180/pi), P);
xlabel('Angle (degrees)');
ylabel('Power');
title('Beamforming Power vs. Angle');
grid on;
