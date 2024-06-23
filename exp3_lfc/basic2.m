%(1)
% 参数设置
fs = 1000; % 采样频率 (Hz)
T = 2; % 信号时长 (秒)
t = 0:1/fs:T; % 时间向量
omega1 = 100 * pi; % 角频率1
omega2 = 150 * pi; % 角频率2
sigma2 = 0.1; % 噪声方差
M = 100; % 运行次数

% 初始化功率谱数组
Sx_omega_sum = zeros(1, length(t));

% 进行 M 次运行
for m = 1:M
    % 生成干扰信号
    omegaI = pi * (50 + (80-50) * rand); % 干扰频率，均匀分布在 [50π, 80π]
    interference = 4 * cos(omegaI * t);
    
    % 生成白噪声
    N_t = sqrt(sigma2) * randn(1, length(t));
    
    % 生成信号 X(t)
    X_t = sin(omega1 * t) + 2 * cos(omega2 * t) + interference + N_t;
    
    % 计算周期图
    [Sx_omega, f] = custom_periodogram(X_t, fs);
    
    % 累加周期图
    Sx_omega_sum = Sx_omega_sum + Sx_omega;
    
    % 绘制第 1 次、第 50 次、第 100 次运行的周期图
    if m == 1 || m == 50 || m == 100
        figure;
        plot(f, 10*log10(Sx_omega));
        title(['第 ', num2str(m), ' 次运行的周期图']);
        xlabel('频率 (Hz)');
        ylabel('功率/频率 (dB/Hz)');
    end
end

% 计算平均功率谱
Sx_omega_avg = Sx_omega_sum / M;

% 绘制平均功率谱
figure;
plot(f, 10*log10(Sx_omega_avg));
title('平均功率谱');
xlabel('频率 (Hz)');
ylabel('功率/频率 (dB/Hz)');

%(2)
sigma2_values = [0.01, 0.1, 1, 100]; % 噪声方差的不同取值

% 依次计算不同噪声方差的平均功率谱
for sigma2 = sigma2_values
    % 初始化功率谱数组
    Sx_omega_sum = zeros(1, length(t));
    
    % 进行 M 次运行
    for m = 1:M
        % 生成干扰信号
        omegaI = pi * (50 + (80-50) * rand); % 干扰频率，均匀分布在 [50π, 80π]
        interference = 4 * cos(omegaI * t);
        
        % 生成白噪声
        N_t = sqrt(sigma2) * randn(1, length(t));
        
        % 生成信号 X(t)
        X_t = sin(omega1 * t) + 2 * cos(omega2 * t) + interference + N_t;
        
        % 计算周期图
        [Sx_omega, f] = custom_periodogram(X_t, fs);
        
        % 累加周期图
        Sx_omega_sum = Sx_omega_sum + Sx_omega;
    end
    
    % 计算平均功率谱
    Sx_omega_avg = Sx_omega_sum / M;
    
    % 绘制平均功率谱
    figure;
    plot(f, 10*log10(Sx_omega_avg));
    title(['噪声方差 \sigma^2 = ', num2str(sigma2), ' 的平均功率谱']);
    xlabel('频率 (Hz)');
    ylabel('功率/频率 (dB/Hz)');
end

% 自定义周期图函数
function [Sx_omega, f] = custom_periodogram(X_t, fs)
    N = length(X_t);
    X_omega = fft(X_t);
    Sx_omega = (1/N) * abs(X_omega).^2;
    f = (0:N-1) * (fs/N); % 频率向量
end