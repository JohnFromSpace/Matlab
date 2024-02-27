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
    
    % Construct the optimal path
    optimalPath = [1, 1];
    i = 1;
    j = 1;
    while ~(i == rows && j == cols)
        if optimalAction(i, j) == 1 % Move right
            j = j + 1;
        else % Move down
            i = i + 1;
        end
        optimalPath = [optimalPath; [i, j]];
    end
    
    % Compute the optimal cost
    optimalCost = costToGo(1, 1);
    
    % Visualization of the forest, obstacles, and optimal path
    figure;
    imagesc(costMatrix);
    colormap(customColormap);
    colorbar;
    hold on;
    
    % Plot obstacles
    [obs_i, obs_j] = find(obstacles);
    plot(obs_j, obs_i, 's', 'MarkerSize', obstacleMarkerSize, 'MarkerFaceColor', obstacleMarkerColor, 'MarkerEdgeColor', 'k', 'DisplayName', 'Obstacles');
    
    % Plot optimal path
    plot(optimalPath(:,2), optimalPath(:,1), 'ro-', 'LineWidth', 2, 'LineStyle', pathLineStyle, 'DisplayName', 'Optimal Path');
    
    title('Forest Grid with Obstacles and Optimal Path');
    xlabel('Column');
    ylabel('Row');
    
    % Add labels to the grid cells
    for i = 1:rows
        for j = 1:cols
            text(j, i, num2str(costMatrix(i,j)), 'HorizontalAlignment', 'center', 'Color', 'w');
        end
    end
    
    % Add legend with detailed information
    legend('Location', 'northeastoutside');
    legend('show');
    
    % Add grid lines
    for i = 1:rows
        plot([0.5, cols+0.5], [i+0.5, i+0.5], 'k', 'LineWidth', 0.5);
    end
    for j = 1:cols
        plot([j+0.5, j+0.5], [0.5, rows+0.5], 'k', 'LineWidth', 0.5);
    end
    
    axis equal;
    hold off;
end
