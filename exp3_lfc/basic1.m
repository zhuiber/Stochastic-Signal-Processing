%part 1
%（1）绘制不同窗口的周期
%参数
omega1 = 100 * pi;
omega2 = 150 * pi;
sigma_squared = 0.1;
duration = 2; % 信号长度2秒
fs = 1000; % 采样率

% 时间序列
t = 0:1/fs:duration-1/fs;

% 生成信号
N_t = sqrt(sigma_squared) * randn(size(t)); % 零均值高斯白噪声
X_t = sin(omega1 * t) + 2 * cos(omega2 * t) + N_t;

% 绘制不同窗口下的周期图并比较
figure;
subplot(1,2,1)
periodogram(X_t, rectwin(length(X_t)), [], fs); % 使用矩形窗口
set(gca,'fontsize',12,'fontname','times');
title('Periodogram with Rectangular Window', 'fontsize',14);

subplot(1,2,2)
periodogram(X_t, hamming(length(X_t)), [], fs); % 使用Hamming窗口
set(gca,'fontsize',12,'fontname','times');
title('Periodogram with Hamming Window', 'fontsize',14);

set(gcf,'Units','centimeter','Position',[10 10 28 10]);

%(2)分析采样率，信号长度和噪声方差对功率谱估计的影响(仅使用矩形窗口)

figure;

%不同采样率
fs_values = [500, 1000, 2000];
for i = 1:length(fs_values)
    fs = fs_values(i);
    t = 0:1/fs:duration-1/fs;
    N_t = sqrt(sigma_squared) * randn(size(t));
    X_t = sin(omega1 * t) + 2 * cos(omega2 * t) + N_t;
    subplot(length(fs_values), 1, i);
    periodogram(X_t, rectwin(length(X_t)), [], fs);
    title(['Periodogram with Sampling Rate = ' num2str(fs) ' Hz'], 'fontsize',14);
    set(gca,'fontsize',12,'fontname','times');
end

% 不同信号长度
figure;
durations = [1, 2, 4];
for i = 1:length(durations)
    duration = durations(i);
    t = 0:1/fs:duration-1/fs;
    N_t = sqrt(sigma_squared) * randn(size(t));
    X_t = sin(omega1 * t) + 2 * cos(omega2 * t) + N_t;
    subplot(length(durations), 1, i);
    periodogram(X_t, rectwin(length(X_t)), [], fs);
    title(['Periodogram with Signal Length = ' num2str(duration) ' s'], 'fontsize',14);
    set(gca,'fontsize',12,'fontname','times');
end

% 不同噪声方差
figure;
sigma_squared_values = [0.1, 0.5, 1];
for i = 1:length(sigma_squared_values)
    sigma_squared = sigma_squared_values(i);
    N_t = sqrt(sigma_squared) * randn(size(t));
    X_t = sin(omega1 * t) + 2 * cos(omega2 * t) + N_t;
    subplot(length(sigma_squared_values), 1, i);
    periodogram(X_t, rectwin(length(X_t)), [], fs);
    title(['Periodogram with Noise Variance \sigma^2 = ' num2str(sigma_squared)], 'fontsize',14);
    set(gca,'fontsize',12,'fontname','times');
end


%(3)
% 参数设置
fs = 1000; % 采样频率 (Hz)
t = 0:1/fs:1; % 时间向量，从 0 到 1 秒
omega1 = 100 * pi; % 角频率1
omega2 = 150 * pi; % 角频率2

% 生成信号分量
N = length(t); % 样本数
N_t = wgn(1, N, 0); % 零均值白高斯噪声
X_t = sin(omega1 * t) + 2 * cos(omega2 * t) + N_t; % 信号 X(t)

% 绘制信号
figure;
plot(t, X_t);
title('信号 X(t)');
xlabel('时间 (s)');
ylabel('幅值');

% 使用自定义周期图
[Sx_omega_custom, f_custom] = custom_periodogram(X_t, fs);

% 使用自定义自相关图
[Sx_omega_corr, f_corr] = custom_correlogram(X_t, fs);

% 绘制自定义周期图
figure;
plot(f_custom, 10*log10(Sx_omega_custom));
title('自定义周期图');
xlabel('频率 (Hz)');
ylabel('功率/频率 (dB/Hz)');

% 绘制自定义自相关图
figure;
plot(f_corr, 10*log10(Sx_omega_corr));
title('自定义自相关图');
xlabel('频率 (Hz)');
ylabel('功率/频率 (dB/Hz)');

% 使用 MATLAB 内置周期图
[pxx, f] = periodogram(X_t, [], [], fs);

% 绘制内置周期图
figure;
plot(f, 10*log10(pxx));
title('内置周期图');
xlabel('频率 (Hz)');
ylabel('功率/频率 (dB/Hz)');

% 比较自定义周期图与内置周期图
figure;
hold on;
plot(f_custom, 10*log10(Sx_omega_custom), 'r', 'DisplayName', '自定义周期图');
plot(f, 10*log10(pxx), 'b--', 'DisplayName', '内置周期图');
title('周期图方法比较');
xlabel('频率 (Hz)');
ylabel('功率/频率 (dB/Hz)');
legend;
hold off;

% 比较自定义自相关图与内置周期图
figure;
hold on;
plot(f_corr, 10*log10(Sx_omega_corr), 'r', 'DisplayName', '自定义自相关图');
plot(f, 10*log10(pxx), 'b--', 'DisplayName', '内置周期图');
title('自相关图与周期图方法比较');
xlabel('频率 (Hz)');
ylabel('功率/频率 (dB/Hz)');
legend;
hold off;

% 自定义周期图函数
function [Sx_omega, f] = custom_periodogram(X_t, fs)
    N = length(X_t);
    X_omega = fft(X_t);
    Sx_omega = (1/N) * abs(X_omega).^2;
    f = (0:N-1) * (fs/N); % 频率向量
end

% 自定义自相关图函数
function [Sx_omega, f] = custom_correlogram(X_t, fs)
    N = length(X_t);
    R_X = xcorr(X_t, 'biased'); % 计算自相关
    R_X = R_X(N:end); % 仅考虑非负滞后
    Sx_omega = fft(R_X);
    f = (0:N-1) * (fs/N); % 频率向量
end
