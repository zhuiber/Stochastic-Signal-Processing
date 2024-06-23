% Generate 5000 random numbers from Uniform distribution
a = 2; % Lower bound of the uniform distribution
b = 8; % Upper bound of the uniform distribution
x1 = unifrnd(a, b, 1, 5000);

% Histogram of the generated random numbers with normalization
histogram(x1, 'normalization', 'pdf'); 
hold on;

% Kernel density estimation (KDE) for the generated random numbers
ksdensity(x1); 
hold on;

% Uniform distribution PDF
x = linspace(a, b, 100); % Range for x-axis
y = unifpdf(x, a, b); % Uniform PDF formula
plot(x, y, 'linewidth', 1.5);

title('PDF of Uniform distribution by 5000 random numbers');
legend('Histogram (Normalized)', 'Kernel Density Estimation', 'Uniform PDF');
