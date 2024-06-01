fs = 1000; % sample rate
f1 = 50; % 
f2 = 200; % 
t = 0:1/fs:1-1/fs; %  sample point
x = 1.8*cos(2*pi*f1*t)+0.5*cos(2*pi*f2*t) + randn(size(t)); % length 1s
subplot(1,2,1)
periodogram(x,rectwin(length(x))); % Periodogram with rectangular Window
set(gca,'fontsize',12,'fontname','times');
title('\fontname{} Periodogram ','fontsize',14);
subplot(1,2,2)
periodogram(x,hamming(length(x))); % Periodogram with Hamming Window
set(gca,'fontsize',12,'fontname','times');
title('\fontname{} Modified Periodogram','fontsize',14);
set(gcf,'Units','centimeter','Position',[10 10 28 10]);
