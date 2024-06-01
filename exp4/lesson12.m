fs = 20000; % sample rate
f0 = 1000; % 
% kf0 = 12000;
% % kf0 = 20000;
% T_end=0.1;
kf0 = 1200;
T_end=1;
T=1/fs;
t = 0:T:T_end-T; %  sample point
x = sin(2*pi*(t.*f0+kf0.*t.^2));
% x = sin(2*pi*t.*(f0+kf0.*t)) + 0.1*randn(size(t));
subplot(1,2,1)
periodogram(x,rectwin(length(x))); % Periodogram with rectangular Window
set(gca,'fontsize',12,'fontname','times');
title('\fontname{} Periodogram Rectangular','fontsize',14);
subplot(1,2,2)
periodogram(x,hamming(length(x))); % Periodogram with Hamming Window
set(gca,'fontsize',12,'fontname','times');
title('\fontname{} Periodogram Hamming','fontsize',14);
set(gcf,'Units','centimeter','Position',[10 10 28 10]);
