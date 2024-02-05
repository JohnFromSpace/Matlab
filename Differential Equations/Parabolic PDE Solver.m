function solveParabolicPDE(spatialGridSize, timeGridSize, saveSolution, pdeCoefficients, customInitialCondition, solverType, useAMR, showPlots, solverOptions, outputFilename, plotStyle, plotOptions, colorMap, plotTitle)

    % Validate input parameters
    validateInput(spatialGridSize, timeGridSize, solverType);

    % Define spatial and temporal discretization
    spatialGrid = linspace(0, 1, spatialGridSize);
    timeGrid = linspace(0, 1, timeGridSize);

    % Set up initial condition
    if nargin < 5
        initialCondition = @(x) sin(pi * x);  % Default initial condition
    else
        initialCondition = customInitialCondition;
    end

    
end
