function two_envelopes_problem() 
    % User-specified parameters
    distribution_types = {'uniform', 'normal'};  % Specify the distribution types ('uniform' or 'normal')
    num_simulations = 10000;
    sample_sizes = [100, 500, 1000, 5000, 10000];  % Specify different sample sizes
    distribution_parameters = [1, 10];  % Vary the parameter of the probability distribution

    % Initialize variables
    strategies = {'Always Exchange', 'Never Exchange', 'Random Exchange', 'Optimal Exchange'};
    results = struct('strategy', {}, 'avg_amounts', {}, 'improvements', {});
end
