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

% Main program
disp('Basic Statistics Program in MATLAB');

% Sample data (replace this with your own dataset)
data = [4, 7, 2, 8, 5, 3, 7, 6, 9, 5];
