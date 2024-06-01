    N_runs = 200; % Number of independent runs
    Return_total = zeros(1, N_runs); % Initialize array to store returns for each run
    
    for run = 1:N_runs
        % Generate a random probability of betrayal for the current counterparty
        counterparty_betray_prob = rand() * 0.4 + 0.4; % Uniform distribution in [0.4, 0.8]
        
        % Implement your strategy
        Your_Strategy = your_strategy();
        
        % Determine the action based on the strategy and counterparty's action
        if Your_Strategy == 0 % Trust
            if rand() <= counterparty_betray_prob % Counterparty trusts
                Return_total(run) = 10; % Both gain 10
            else % Counterparty betrays
                Return_total(run) = -5; % You lose 5
            end
        else % Reject
            if rand() <= counterparty_betray_prob % Counterparty trusts
                Return_total(run) = 0; % No gain or loss
            else % Counterparty betrays
                Return_total(run) = 5; % You gain 5
            end
        end
    end
    
    % Calculate average return over all runs
    Avg_Return = mean(Return_total);
    fprintf('Average Return: %.2f\n', Avg_Return);

    % Plot the figure of Avg_Return
figure;
plot(1:N_runs, cumsum(Return_total) ./ (1:N_runs));
xlabel('Run');
ylabel('Average Return');
title('Average Return vs. Run');
grid on;

