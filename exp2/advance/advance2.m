clc;
clear;
close all;
load noise.mat; % 加载特殊噪声

% part 1
% ---------------------------------------------------------------------------------------------------------------------
fig=0;                      % Figure ID
[sig_ori,FS]=audioread('test_audio.wav');  % read the original speech, you can use anything you like
sig_ori = sig_ori';
Lsig = length(sig_ori);     % detect the length of the signal
dt=1/FS;    % the dt is the samping interval, which is, for dt second, there will be one sample of the speech
t=0:dt:Lsig/FS;
t=t(1:Lsig);    % how many seconds; for example, for a sampling rate 16000, 32000 samples means 2 seconds

N = 44100 ; % frequency

% 麦克风和源的参数
M = 8; % 8个麦克风
c = 340; % 声速，单位：m/s

% 8个麦克风的位置
Loc = zeros(2, M); % 初始化位置矩阵
for i = 0:7
    Loc(2, i+1) = 0.085 * i; % 设置麦克风的y坐标
end

% 构建表格
lags = -11:11; % 滞后范围
DOA_table = zeros(length(lags), 2); % 初始化DOA表
DOA_list = zeros(length(lags), 1);
for i = 1:length(lags)
    lag = lags(i);
    
    % 提取两个麦克风的信号
    mic_0 = sig_ori(1:end-abs(lag)); % 信号 0
    mic_1 = sig_ori(1+abs(lag):end); % 信号 1
    
    % 计算交叉相关
    cross_corr = xcorr(mic_0, mic_1);
    
    % 找到交叉相关的最大值及其索引
    [~, max_index] = max(abs(cross_corr));
    
    % 计算DOA
    DOA_degrees = asind((max_index - length(mic_0)) / N * c / (Loc(2, 2) - Loc(2, 1))); % 计算DOA
    DOA_table(i, :) = [lag, DOA_degrees]; % 存储lag和对应的DOA
    DOA_list(i) = DOA_degrees; % 存储DOA到DOAs数组
end

% 显示DOA表
fprintf('Lag\tDOA (degrees)\n');
fprintf('-------------------\n');
for i = 1:length(lags)
    fprintf('%d\t%.4f\n', DOA_table(i, 1), DOA_table(i, 2));
end

% part 2
% ------------------------------------------------------------------------------------------------------------------------------------
SNR_dB_list = [30, 0, -1000]; % this indicate the Signal_to_Noise_Ratio = 10 * log_10(signal_power / noise_power)
Is_add_special_noise = 0;   % if 0, add random noise; otherwise, add predefined noise
% assume Gaussian Noise

% 初始化正确检测计数器
correct_detection_count = zeros(length(SNR_dB_list), 1);
correct_detection_percentage = zeros(length(SNR_dB_list), 1); % 初始化正确检测百分比数组

% 重复次数
num_trials = 100;

% part 3 - 运行实验并计算正确检测的数量
for SNR_index = 1:length(SNR_dB_list)
    SNR_dB = SNR_dB_list(SNR_index);
    
    % 初始化正确检测计数器
    correct_detection_count(SNR_index) = 0;

    % 循环实验次数
    for trial = 1:num_trials
        % 从23个DOA中随机选择一个作为真实DOA
        true_DOA_idx = randi(length(DOA_list));
        true_DOA = DOA_list(true_DOA_idx);

        % 生成带有随机高斯噪声的信号
        noise_level = 10^(-SNR_dB/20); % 计算噪声水平
        noise_signal = noise_level * randn(size(sig_ori)); % 生成随机高斯噪声
        noisy_signal = sig_ori + noise_signal; % 添加噪声

        % 初始化正确估计的计数器
        correct_estimation_count = 0;

        % 循环遍历每个角度
        for lag_idx = 1:length(lags)
            lag = lags(lag_idx);

            % 提取两个麦克风的信号
            mic_0 = noisy_signal(1:end-abs(lag)); % 信号 0
            mic_1 = noisy_signal(1+abs(lag):end); % 信号 1

            % 计算交叉相关
            cross_corr = xcorr(mic_0, mic_1);

            % 找到交叉相关的最大值及其索引
            [~, max_index] = max(abs(cross_corr));

            % 计算估计的DOA
            estimated_DOA = asind((max_index - length(mic_0)) / N * c / (Loc(2, 2) - Loc(2, 1)));

            % 检查估计DOA是否与真实DOA匹配
            if abs(estimated_DOA - true_DOA) < 0.5 % 根据需要调整阈值
                correct_estimation_count = correct_estimation_count + 1;
            end
        end

        % 如果有任何角度的DOA正确估计，则将正确检测计数器增加1
        if correct_estimation_count > 0
            correct_detection_count(SNR_index) = correct_detection_count(SNR_index) + 1;
        end
    end
     % 计算此SNR的正确检测百分比
    correct_detection_percentage(SNR_index) = (correct_detection_count(SNR_index) / num_trials) * 100;
end

% part 4 - 显示结果
% ------------------------------------------------------------------------------------------------------------------------------------
fprintf('\nSNR (dB)\tCorrect Detections\tCorrect Detection Percentage\n');
fprintf('-----------------------------------------------------------\n');
for i = 1:length(SNR_dB_list)
    fprintf('%d\t\t%d\t\t\t%.2f%%\n', SNR_dB_list(i), correct_detection_count(i), correct_detection_percentage(i));
end
