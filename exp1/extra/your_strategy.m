function Your_Strategy = your_strategy(~)
   % Estimate the counterparty's probability of betrayal using information from 100 friends
   num_betrays_total = 0;
   for friend = 1:100
       num_betrays_total = num_betrays_total + randi([40, 80]); % Randomly generated number of betrayals out of 100
   end
   counterparty_estimated_prob = num_betrays_total / (100 * 100); % Estimated probability
        
    % Strategy based on estimated probability of betrayal
    % Example strategy: Trust if estimated probability is below 0.6, otherwise Reject
    if counterparty_estimated_prob < 0.6
        Your_Strategy = 0; % Trust
    else
        Your_Strategy = 1; % Reject
    end
end
