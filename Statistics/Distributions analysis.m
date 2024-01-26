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

        case 'exponential'
            % For exponential distribution
            mean_value = mean(data);
            median_value = median(data);
            std_deviation = std(data);
            fprintf('Exponential Distribution:\n');
            fprintf('Mean: %.4f\n', mean_value);
            fprintf('Median: %.4f\n', median_value);
            fprintf('Standard Deviation: %.4f\n', std_deviation);

        case 'gamma'
            % For gamma distribution
            alpha = mean(data)^2 / var(data);
            beta = var(data) / mean(data);
            mean_value = alpha / beta;
            median_value = gaminv(0.5, alpha, beta);
            std_deviation = sqrt(alpha) / beta;
            fprintf('Gamma Distribution:\n');
            fprintf('Mean: %.4f\n', mean_value);
            fprintf('Median: %.4f\n', median_value);
            fprintf('Standard Deviation: %.4f\n', std_deviation);

        otherwise
            error('Invalid distribution type. Supported types: normal, poisson, binomial, uniform, exponential, gamma');
    end   

    % Additional Statistical Measures
    if size(data, 2) > 1
        % Covariance and Correlation
        covariance_matrix = cov(data);
        correlation_matrix = corrcoef(data);
        disp('Covariance Matrix:');
        disp(covariance_matrix);
        disp('Correlation Coefficients:');
        disp(correlation_matrix);
    end
    
    % Skewness and Kurtosis
    skewness_value = skewness(data);
    kurtosis_value = kurtosis(data);
    fprintf('Skewness: %.4f\n', skewness_value);
    fprintf('Kurtosis: %.4f\n', kurtosis_value);

    % Confidence Intervals
    if nargin > 2
        confidence_interval = CI(data, confidence_level);
        fprintf('Confidence Interval (%.1f%%): [%.4f, %.4f]\n', confidence_level*100, confidence_interval(1), confidence_interval(2));
    end

    % Box Plot
    figure;
    boxplot(data);
    title('Box Plot');
    xlabel('Variables');
    ylabel('Values');
    
    % Probability Density Function (PDF) or Probability Mass Function (PMF)
    figure;
    edges = linspace(min(data), max(data), 100);
    histogram(data, 'Normalization', 'probability', 'EdgeColor', 'white');
    hold on;

    switch distribution_type
        case 'normal'
            pdf_values = normpdf(edges, mean(data), std(data));
        case 'poisson'
            pdf_values = poisspdf(edges, mean(data));
        case 'binomial'
            n = length(data);
            p = mean(data) / n;
            pdf_values = binopdf(edges, n, p); 
        case 'uniform'
            pdf_values = unifpdf(edges, min(data), max(data));
        case 'exponential'
            pdf_values = exppdf(edges, 1 / mean(data));
        case 'gamma'
            pdf_values = gampdf(edges, alpha, beta);
        otherwise
            error('Invalid distribution type for PDF/PMF plotting.');
    end

    plot(edges, pdf_values, 'LineWidth', 2);
    title(sprintf('%s Distribution and PDF', distribution_type));
    xlabel('Values');
    ylabel('Probability');

    % Interactive Plotting (it requires MATLAB version R2020a or later, which supports data cursors with custom data tips)
    dcm = datacursormode(gcf);
    set(dcm, 'UpdateFcn', @(obj,event_obj) custom_datatip(obj, event_obj, data, distribution_type));
    datacursormode on;
    
end

function interval = CI(data, confidence_level)
    % Calculate confidence interval for the mean
    alpha = 1 - confidence_level;
    [mu, sigma] = normfit(data);
    z_value = norminv(1 - alpha/2);
    interval = mu + z_value * sigma / sqrt(length(data));    
end

% Interacive Plotting (it requires MATLAB version R2020a or later, which supports data cursors with custom data tips)
function txt = custom_datatip(~, event_obj, data, distribution_type)
    idx = get(event_obj, 'DataIndex');
    value = data(idx);
    txt = {sprintf('Value: %.4f', value); sprintf('Distribution: %s', distribution_type)};    
end
