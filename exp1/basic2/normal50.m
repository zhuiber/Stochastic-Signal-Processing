% pdf of Normal distribution by 50 random numbers
x1 = randn(1,50);
histogram(x1,'normalization','pdf'); 
hold on
ksdensity(x1); 
hold on
x = -5:0.2:5; 
y =normpdf(x); 
% estimate pdf
% Normal distribution pdf;
plot(x,y,'linewidth',1.5);
title('pdf of Normal distribution by 50 random numbers');