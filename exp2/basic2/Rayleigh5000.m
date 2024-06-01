% generate 5000 random numbers from Rayleigh distribution
x1 = raylrnd(1, 1, 5000); % Rayleigh distribution with scale parameter 1

% histogram of the generated random numbers with normalization
histogram(x1, 'normalization', 'pdf'); 
hold on;

% kernel density estimation (KDE) for the generated random numbers
ksdensity(x1); 
hold on;

% Rayleigh distribution PDF
x = 0:0.1:5; % Range for x-axis
y = x./1^2 .* exp(-x.^2./(2*1^2)); % Rayleigh PDF formula with scale parameter 1
plot(x, y, 'linewidth', 1.5);

title('PDF of Rayleigh distribution by 5000 random numbers');
legend('Histogram (Normalized)', 'Kernel Density Estimation', 'Rayleigh PDF');
