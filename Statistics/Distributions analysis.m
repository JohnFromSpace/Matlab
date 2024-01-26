function analyze_distribution(data, distribution_type, confidence_level)
    % Input:
    %   - data: a vector representing the dataset
    %   - distribution_type: a string specifying the distribution type ('normal', 'poisson', 'binomial', 'uniform', 'exponential', 'gamma')
    %   - confidence_level: the confidence level for calculating confidence intervals (optional)

    switch distribution_type
        case 'normal'
            % For normal distribution
            mean_value = mean(data);
            median_value = median(data);
            std_deviation = std(data);
            fprintf('Normal Distribution:\n');
            fprintf('Mean: %.4f\n', mean_value);
            fprintf('Median: %.4f\n', median_value);
            fprintf('Standard Deviation: %.4f\n', std_deviation);

        case 'poisson'
            % For Poisson distribution
            lambda = mean(data); % Poisson distribution parameter
            mean_value = lambda;
            median_value = floor(lambda + 1 / 3 - 0.02 / lambda);
            std_deviation = sqrt(lambda);
            fprintf('Poisson Distribution:\n');
            fprintf('Mean: %.4f\n', mean_value);
            fprintf('Median: %.4f\n', median_value);
            fprintf('Standard Deviation: %.4f\n', std_deviation);

        case 'binomial'
            % For binomial distribution
            n = length(data); % Number of trials
            p = mean(data) / n; % Probability of success
            mean_value = n * p;
            median_value = floor(n * p);
            std_deviation = sqrt(n * p * (1 - p));
            fprintf('Binomial Distribution:\n');
            fprintf('Mean: %.4f\n', mean_value);
            fprintf('Median: %.4f\n', median_value);
            fprintf('Standard Deviation: %.4f\n', std_deviation);   
    
        case 'uniform'
            % For uniform distribution
            mean_value = mean(data);
            median_value = median(data);
            std_deviation = std(data) / sqrt(12); % Approximate standard deviation for a uniform distribution
            fprintf('Uniform Distribution:\n');
            fprintf('Mean: %.4f\n', mean_value);
            fprintf('Median: %.4f\n', median_value);
            fprintf('Standard Deviation: %.4f\n', std_deviation);     
    end   
end
