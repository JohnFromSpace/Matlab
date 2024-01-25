% Basic Statistics Program in MATLAB

% Function to calculate mean
function meanValue = calculateMean(data)
    meanValue = mean(data);
end

% Function to calculate median
function medianValue = calculateMedian(data)
    medianValue = median(data);
end

% Function to calculate mode
function modeValue = calculateMode(data)
    modeValue = mode(data);
end

% Function to calculate variance
function varianceValue = calculateVariance(data)
    varianceValue = var(data);
end

% Function to calculate standard deviation
function stdDevValue = calculateStandardDeviation(data)
    stdDevValue = std(data);
end
