function Your_Strategy_modify = Your_Strategies_modify(counterparty_previous_action)
    % Define constants
    trust_threshold = 0.6; % Adjust as needed
    betrayal_threshold = 0.4; % Adjust as needed
    
    % Count the number of recent betrayals and trusts by the counterparty
    num_betrays = sum(counterparty_previous_action);
    num_trusts = length(counterparty_previous_action) - num_betrays;
    
    % Calculate the ratio of betrayals to total actions
    betray_ratio = num_betrays / length(counterparty_previous_action);
    
    % Adjust strategy based on counterparty behavior
    if betray_ratio > trust_threshold
        % Counterparty has been betraying frequently, increase probability of calling police
        Your_Strategy_modify = 1; % Call police
    elseif betray_ratio < betrayal_threshold
        % Counterparty has been trusting frequently, increase probability of trusting
        Your_Strategy_modify = 0; % Trust
    else
        % Counterparty behavior is balanced, use default strategy
        Your_Strategy_modify = double(0.5 > rand(1)); % Default strategy
    end
end
