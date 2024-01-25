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

% Display the dataset
disp('Dataset:');
disp(data);

% Calculate and display mean
meanResult = calculateMean(data);
disp(['Mean: ' num2str(meanResult)]);

% Calculate and display mode
modeResult = calculateMode(data);
disp(['Mode: ' num2str(modeResult)]);

% Calculate and display median
medianResult = calculateMedian(data);
disp(['Median: ' num2str(medianResult)]);

% Calculate and display variance
varianceResult = calculateVariance(data);
disp(['Variance: ' num2str(varianceResult)]);

% Calculate and display standard deviation
stdDevResult = calculateStandardDeviation(data);
disp(['Standard Deviation: ' num2str(stdDevResult)]);
