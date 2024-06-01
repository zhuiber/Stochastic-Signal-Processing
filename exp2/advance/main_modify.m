clear;
clc;
warning off

N_runs = 500;                              % Number of independent runs
N_trades = 100;                            % trade N_trades times per run
Return_total = zeros(1, N_runs);           % Initialize array to store returns for each run

for run = 1:N_runs
    counterparty_betray_prob = rand(1);   % randomly initialize the probability of betray of the counterparty for each run
    counterparty_previous_action_list = rand(10,1);
    counterparty_previous_action = double(counterparty_betray_prob > counterparty_previous_action_list);

    Return_run = 0;                        % Initialize return for this run

    for n_trade = 1:N_trades
        Your_Strategy_modify = Your_Strategies_modify(counterparty_previous_action);
        % this time, you can pass anything you want into the 'Your_Strategies',
        % except the 'counterparty_betray_prob'
        % you can change the whole system as you wish
        counterparty_action = double(counterparty_betray_prob > rand(1)); % 1 for true, 0 for false
        
        if Your_Strategy_modify == 0
            if counterparty_action == 0
                Return_current = 10;   % both trust, add 10 points
            else
                Return_current = -10;  % self trust, counterparty betray, -10 points
            end
        else
            if counterparty_action == 0
                Return_current = -10;  % self call police, counterparty trust, -10 points
            else
                Return_current = 10;   % self call police, counterparty betray, -10 points
            end
        end
        
        Return_run = Return_run + Return_current; % update the return for this run
    end
    
    Return_total(run) = Return_run; % Store the total return for this run
end

% Calculate average return over all runs
Avg_Return = mean(Return_total)


% Plot the figure of Avg_Return
figure;
plot(1:N_runs, cumsum(Return_total) ./ (1:N_runs));
xlabel('Run');
ylabel('Average Return');
title('Average Return vs. Run');
grid on;
