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
    
    % Perform dynamic programming
    for i = rows:-1:1
        for j = cols:-1:1
            % Check if it's not the destination cell and not an obstacle
            if ~(i == rows && j == cols) && ~obstacles(i, j)
                % Compute the cost of moving right
                costRight = inf;
                if j < cols && ~obstacles(i, j+1)
                    costRight = costMatrix(i, j+1);
                end
                
                % Compute the cost of moving down
                costDown = inf;
                if i < rows && ~obstacles(i+1, j)
                    costDown = costMatrix(i+1, j);
                end
                
                % Update the cost-to-go matrix
                [costToGo(i, j), optimalAction(i, j)] = min([costRight, costDown]) + costMatrix(i, j);
            end
        end
    end
    
    
end
