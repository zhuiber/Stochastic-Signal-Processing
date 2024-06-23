% Generate 50 random numbers from Exponential distribution
lambda = 0.5; % Rate parameter of the exponential distribution
x1 = exprnd(1/lambda, 1, 50);

% Histogram of the generated random numbers with normalization
histogram(x1, 'normalization', 'pdf'); 
hold on;

% Kernel density estimation (KDE) for the generated random numbers
ksdensity(x1); 
hold on;

% Exponential distribution PDF
x = 0:0.1:10; % Range for x-axis
y = exppdf(x, 1/lambda); % Exponential PDF formula
plot(x, y, 'linewidth', 1.5);

title('PDF of Exponential distribution by 50 random numbers');
legend('Histogram (Normalized)', 'Kernel Density Estimation', 'Exponential PDF');
