
% returns a random scalar drawn from the uniform distribution in the interval (0,1).
r1 = rand
% returns an 3-by-3 matrix of uniformly distributed random numbers. 
r2 = rand(3)
%returns an sz1-by-...-by-szN array of random numbers where sz1,...,szN indicate the size of each dimension
r3 = rand(2,2,3)

pd = makedist('Normal');
% evaluate the Normal distribution and generate random numbers
r = random(pd); 

%practice 1
L = 10000; 	% length
x = randn(1,L);    % create a new 1-by-5 vector of random numbers
y = randn(1,L); 
m = mean(x);       % compute the mean
v = var(x); 	% compute the variance
s = std(x); 	% compute the standard deviation
c = cov(x,y) 	% compute the covariance between two random variables X and Y

%practice 2
N = 5000;       % length
x = randn(1,N); % create a new 1-by-N vector of random numbers
histogram(x,'normalization','pdf'); 
hold on
ksdensity(x); % estimate pdf

%practice 3
pd = makedist('Normal'); % create a Normal distribution object
x = -5:0.01:5; 		% range
y = pdf(pd,x); 		% truth pdf
z = cdf(pd,x); 		% CDF
subplot(1,2,1)
plot(x,y,'linewidth',1.5);
title('\fontname{}pdf');
subplot(1,2,2)
plot(x,z,'linewidth',1.5);
title('\fontname{}CDF');


%practice4 method1
% pdf of Normal distribution by 50 random numbers
x1 = randn(1,50);
histogram(x1,'normalization','pdf'); 
hold on
ksdensity(x1); % estimate pdf
hold on
x = -5:0.2:5; 
y =normpdf(x); % Normal distribution pdf;
plot(x,y,'linewidth',1.5);
title('pdf of Normal distribution by 50 random numbers');

%method2
%pdf of Normal distribution by 5000 random numbers
pd = makedist('Normal'); % 
x1 = random(pd,1,5000);
x = -5:0.002:5;         % range
[f,x]=ksdensity(x1,x);  % estimate pdf
histogram(x1,'normalization','pdf');
hold on
plot(x,f,'linewidth',1.5);
hold on
y = pdf(pd,x);
plot(x,y,'linewidth',1.5);
title('pdf of Normal distribution by 5000 random numbers');

