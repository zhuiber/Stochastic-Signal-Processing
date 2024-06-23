clc
clear all
close all
load noise.mat      % load the special noise if needed
% for the special noise, the odd lines are the opposite of the even lines

fig=0;                      % Figure ID
[sig_ori,FS]=audioread('test_audio.wav');  % read the original speech, you can use anything you like
% The sig_ori is the discrete type signal with a sampling rate FS
% Here, FS=16000 means that in 1 second, there are 16000 samples of the speech
sig_ori = sig_ori';
Lsig = length(sig_ori);     % detect the length of the signal
dt=1/FS;    % the dt is the samping interval, which is, for dt second, there will be one sample of the speech
t=0:dt:Lsig/FS;
t=t(1:Lsig);    % how many seconds; for example, for a sampling rate 16000, 32000 samples means 2 seconds
% SNR_dB = 1000; % this indicate the Signal_to_Noise_Ratio = 10 * log_10(signal_power / noise_power)
% SNR_dB = 0; % this indicate the Signal_to_Noise_Ratio = 10 * log_10(signal_power / noise_power)
SNR_dBS = [30, 10, -10]; % this indicate the Signal_to_Noise_Ratio = 10 * log_10(signal_power / noise_power)
Is_add_special_noise = 1;   % if 0, add random noise; otherwise, add predefined noise
% assume Gaussian Noise
% note that the SNR_dB = 1000 refers to no noise approximately; SNR_dB = 20 is large noise in speech processing

% this code is for ploting the FFT of the signal ------------------------
% we can see that for a speech, The energy is mainly concentrated in low frequency
f=linspace(0,FS/2,Lsig/2);
f=f';
Y=fft(sig_ori,Lsig);
inputy=Y(1:Lsig/2);
yabs=abs(Y); 
yy=yabs(1:Lsig/2);

fig=fig+1;
figure(fig)
plot(f,yy);
title('FFT')
%----------------------------------------------------------------------------------

 % this code place the microphones and source ------------------------
M=4;        % 4 microphones
c=340;     % The speed at which sound travels through the air is 340m/s
 % We now place four microphones in four different places
Loc(1,:)=[0, 20, 0, 20]; 
Loc_M_x=Loc(1,:);
Loc(2,:)=[0, 0, 10, 10];
Loc_M_y=Loc(2,:);
% the location of the microphones are in Loc above, in this example, the
% locations are in (0,0)m, (25,5)m, (50,0)m and (75,5)m

% this code place the microphones and source ------------------------ another setting
% M=2;        % 2 microphones
% c=340;     % The speed at which sound travels through the air is 340m/s
% We now place two microphones in two different places
% Loc(1,:)=[0, 50]; 
% Loc_M_x=Loc(1,:);
% Loc(2,:)=[0, 10];
% Loc_M_y=Loc(2,:);
% the location of the microphones are in Loc above, in this example, the
% locations are in (0,0)m and (50,10)m


xs=1;
ys=1;
% source located in (1, 1)m
%----------------------------------------------------------------------------------

% distance between microphones and source ---------------------
Rsm=[];
 for q=1:M
     rsm=sqrt((xs-Loc_M_x(q))^2+(ys-Loc_M_y(q))^2);
     Rsm=[Rsm rsm];  % distance between microphones and source
 end
TD=Rsm/c; 
% time delay between microphones and source, for example, if the distance
% between source and microphone is 3.4m, then the time delay is 0.01s,
% which is, when a signal is sent out from the source, after 0.01s, the
% microphone will receive the signal.
% note that in this case, given a sampling rate of FS=16000, 0.01s means
% 160 samples, which is, the L_TD below
L_TD=TD/dt;
L_TD=fix(L_TD);
%----------------------------------------------------------------------------------

%----------------------------------------------------------------------------------
Signal_Received=zeros(M,Lsig); % Initialize Signal_Received with zeros
signal_power = sig_ori*sig_ori'/Lsig;       % calculate signal power

for i = 1:length(SNR_dBS)
    noise_power = signal_power/(10^(SNR_dBS(i)/10));   % noise
    for p=1:M    
        % adding noise
        noise = sqrt(noise_power)*randn(1, Lsig);    % assume noise is zero, or says, no noise
        if Is_add_special_noise==0
            sig_noise =  sig_ori + noise;
        else
            sig_noise =  sig_ori + sqrt(noise_power)*noise_default(p, 1:Lsig);
        end   
        % adding noise finished
        
        Signal_with_noise = [zeros(1, L_TD(p)), sig_noise(1:end-L_TD(p))]; % add the time delay with noise
        Signal_Received(p,:) = Signal_Received(p,:) + Signal_with_noise; % Add the signal to Signal_Received
    end
    
    % Plot the four signals received from 4 microphones
    fig=fig+1;
    figure(fig)
    plot(t, Signal_Received')
    title(['Signals Received from 4 Microphones (SNR = ', num2str(SNR_dBS(i)), ' dB)'])
    xlabel('Time (s)')
    ylabel('Amplitude')
    legend('Microphone 1', 'Microphone 2', 'Microphone 3', 'Microphone 4')
    
    % Show the signal after correctly adding the signals from the 4 microphones with correct lags
    Correct_Sum_with_lag = sum(Signal_Received, 1); % Correctly sum the signals from all microphones
    fig=fig+1;
    figure(fig)
    plot(t, Correct_Sum_with_lag)
    title(['Correctly Summed Signal with Correct Lags (SNR = ', num2str(SNR_dBS(i)), ' dB)'])
    xlabel('Time (s)')
    ylabel('Amplitude')
    
    % Plot and output the signal received in microphone 1
    fig=fig+1;
    figure(fig)
    plot(t, Signal_Received(1,:))
    title(['Signal Received in Microphone 1 (SNR = ', num2str(SNR_dBS(i)), ' dB)'])
    xlabel('Time (s)')
    ylabel('Amplitude')
    Signal_Re_1 = Signal_Received(1,:); % Save the signal received in microphone 1
    Signal_Re_1 = Signal_Re_1 ./ max(abs(Signal_Re_1)); % Normalize the signal
    audiowrite(['Signal-First_SNR', num2str(SNR_dBS(i)), '.wav'], Signal_Re_1, FS); % Output the signal
    
    % Plot and output the sum of the signal received from all microphones directly
    fig=fig+1;
    figure(fig)
    plot(t, sum(Signal_Received, 1))
    title(['Sum of Signals from All Microphones (SNR = ', num2str(SNR_dBS(i)), ' dB)'])
    xlabel('Time (s)')
    ylabel('Amplitude')
    Signal_Re_Sum = sum(Signal_Received, 1); % Sum of signals from all microphones
    Signal_Re_Sum = Signal_Re_Sum ./ max(abs(Signal_Re_Sum)); % Normalize the signal
    audiowrite(['Signal-Direct-Sum_SNR', num2str(SNR_dBS(i)), '.wav'], Signal_Re_Sum, FS); % Output the signal
    
    % Plot all the received signals in one figure
    fig=fig+1;
    figure(fig)
    plot(t, Signal_Received')
    title(['All Received Signals (SNR = ', num2str(SNR_dBS(i)), ' dB)'])
    xlabel('Time (s)')
    ylabel('Amplitude')
    
    % Calculate the cross-correlation between microphones 1 and 2, 1 and 3, 1 and 4
    Max_lag = 8000; % maximum lag for cross-correlation
    R_12 = xcorr(Signal_Received(1,:), Signal_Received(2,:), Max_lag, 'coeff');
    R_13 = xcorr(Signal_Received(1,:), Signal_Received(3,:), Max_lag, 'coeff');
    R_14 = xcorr(Signal_Received(1,:), Signal_Received(4,:), Max_lag, 'coeff');
    
    % Find the lag for each cross-correlation
    [~, Lag_12_index] = max(R_12);
    [~, Lag_13_index] = max(R_13);
    [~, Lag_14_index] = max(R_14);
    
    % Calculate the corresponding time delays
    Lag_12_estimate = Lag_12_index - (Max_lag + 1);
    Lag_13_estimate = Lag_13_index - (Max_lag + 1);
    Lag_14_estimate = Lag_14_index - (Max_lag + 1);
    
    % Apply the time delays to signals received from microphones 2, 3, and 4
    Signal_Received(2,:) = circshift(Signal_Received(2,:), [0, Lag_12_estimate]);
    Signal_Received(3,:) = circshift(Signal_Received(3,:), [0, Lag_13_estimate]);
    Signal_Received(4,:) = circshift(Signal_Received(4,:), [0, Lag_14_estimate]);
    
    % Sum up the delayed signals to get a clean speech
    Clean_Speech = sum(Signal_Received, 1);
    
    % Plot the clean speech
    fig = fig + 1;
    figure(fig)
    plot(t, Clean_Speech)
    title(['Clean Speech (SNR = ', num2str(SNR_dBS(i)), ' dB)'])
    xlabel('Time (s)')
    ylabel('Amplitude')
    
    % Plot and output the sum of the signal received from microphones 1 and 2 with correct lag
    fig=fig+1;
    figure(fig)
    plot(t, sum(Signal_Received(1:2,:), 1))
    title(['Sum of Signals from Microphones 1 and 2 with Correct Lag (SNR = ', num2str(SNR_dBS(i)), ' dB)'])
    xlabel('Time (s)')
    ylabel('Amplitude')
    Signal_Correct_Sum_12 = sum(Signal_Received(1:2,:), 1); % Sum of signals from microphones 1 and 2 with correct lag
    Signal_Correct_Sum_12 = Signal_Correct_Sum_12 ./ max(abs(Signal_Correct_Sum_12)); % Normalize the signal
    audiowrite(['Signal-Correct-Sum-12_SNR', num2str(SNR_dBS(i)), '.wav'], Signal_Correct_Sum_12, FS); % Output the signal
end
