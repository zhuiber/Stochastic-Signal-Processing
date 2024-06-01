clear
clc

poiss_lambda = 10;
x1 = random('Poisson',poiss_lambda,[1,100]);
x = 0:1:25;         % range
[f,x]=ksdensity(x1,x);  % estimate pdf
figure(1)
histogram(x1,'normalization','pdf');
hold on
plot(x,f,'linewidth',1.5);
hold on
y = poisspdf(x,poiss_lambda);
plot(x,y,'linewidth',1.5);
title('pdf of Normal distribution by 100 random numbers');
xlim([0,25])


