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
    end   
end
