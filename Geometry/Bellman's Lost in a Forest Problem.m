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

    
end
