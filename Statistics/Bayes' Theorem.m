disp('Bayes'' Theorem Calculator');

while true
    % Get user input for event names
    event_A_name = input('Enter the name of event A: ', 's');
    event_B_name = input('Enter the name of event B: ', 's');

    % Get user input for prior probabilities
    prior_prob_A = input(['Enter the prior probability of ' event_A_name ' (between 0 and 1): ']);
    prior_prob_B = input(['Enter the prior probability of ' event_B_name ' (between 0 and 1): ']);

    % Get user input for conditional probabilities
    prob_B_given_A = input(['Enter the probability of ' event_B_name ' given ' event_A_name ' (between 0 and 1): ']);
    prob_A_given_B = input(['Enter the probability of ' event_A_name ' given ' event_B_name ' (between 0 and 1): ']);
end
