% Generate 5000 random numbers from Poisson distribution
lambda = 5; % Poisson distribution parameter
x1 = poissrnd(lambda, 1, 5000);

% Histogram of the generated random numbers with normalization
histogram(x1, 'normalization', 'pdf'); 
hold on;

% Kernel density estimation (KDE) for the generated random numbers
ksdensity(x1); 
hold on;

% Poisson distribution PDF
x = 0:0.1:20; % Range for x-axis
y = poisspdf(x, lambda); % Poisson PDF formula
plot(x, y, 'linewidth', 1.5);

title('PDF of Poisson distribution by 5000 random numbers');
legend('Histogram (Normalized)', 'Kernel Density Estimation', 'Poisson PDF');
