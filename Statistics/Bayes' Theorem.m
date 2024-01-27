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

    % Check if input probabilities are valid
    if is_valid_probability(prior_prob_A) && is_valid_probability(prior_prob_B) && ...
       is_valid_probability(prob_B_given_A) && is_valid_probability(prob_A_given_B)
        break;
    else
        disp('Invalid input. Probabilities must be between 0 and 1. Please try again.');
    end
end

% Calculate the marginal probability of event B
prob_B = prior_prob_A * prob_B_given_A + prior_prob_B * (1 - prob_A_given_B);

% Apply Bayes' Theorem to calculate the posterior probability of event A given B
posterior_prob_A_given_B = (prior_prob_A * prob_B_given_A) / prob_B;

% Display the results
disp('Results:');
disp(['Prior probability of ' event_A_name ': ' num2str(prior_prob_A)]);
disp(['Prior probability of ' event_B_name ': ' num2str(prior_prob_B)]);
disp(['Probability of ' event_B_name ' given ' event_A_name ': ' num2str(prob_B_given_A)]);
disp(['Probability of ' event_A_name ' given ' event_B_name ': ' num2str(prob_A_given_B)]);
disp(['Posterior probability of ' event_A_name ' given ' event_B_name ': ' num2str(posterior_prob_A_given_B)]);

% Plot probabilities on a bar chart
bar([prior_prob_A, prior_prob_B, prob_B_given_A, prob_A_given_B, posterior_prob_A_given_B]);
title('Probabilities');
ylabel('Probability');
xticks(1:5);
xticklabels({'Prior A', 'Prior B', ['P(' event_B_name '|', event_A_name, ')'], ['P(' event_A_name '|', event_B_name, ')'], ['Posterior ', event_A_name, '|', event_B_name]});

% Function to check if a probability is valid
function valid = is_valid_probability(prob)
    valid = isscalar(prob) && isnumeric(prob) && prob >= 0 && prob <= 1;
end
