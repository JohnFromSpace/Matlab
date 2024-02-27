function [optimalPath, optimalCost] = bellmanLostInForest(costMatrix, obstacles, pathLineStyle, obstacleMarkerSize, obstacleMarkerColor, customColormap)
    % Check if the input matrices are valid
    if ~isnumeric(costMatrix) || any(costMatrix(:) < 0) || ~all(isfinite(costMatrix(:)))
        error('Invalid cost matrix. Please provide a matrix with non-negative finite values.');
    end
    if nargin < 2
        obstacles = zeros(size(costMatrix)); % If obstacles are not provided, assume no obstacles
    else
        if ~isequal(size(costMatrix), size(obstacles))
            error('Size of cost matrix and obstacle matrix must be the same.');
        end
    end
    if nargin < 3
        pathLineStyle = '-';
    end
    if nargin < 4
        obstacleMarkerSize = 10;
    end
    if nargin < 5
        obstacleMarkerColor = 'r';
    end
    if nargin < 6
        customColormap = 'parula';
    end
    
    % Get the size of the cost matrix
    [rows, cols] = size(costMatrix);
    
    % Initialize the cost-to-go matrix with infinity
    costToGo = inf(rows, cols);
    
    % Initialize the optimal action matrix
    optimalAction = zeros(rows, cols);
    
    % Set the destination cell cost to 0
    costToGo(rows, cols) = 0;
    
    
end
