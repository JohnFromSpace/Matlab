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

   try
        % Solve the parabolic PDE using pdepe or adaptPDE
        if strcmpi(solverType, 'pdepe')
            solution = solveParabolicPDEUsingPDEPE(@parabolicPDE, initialCondition, @boundaryCondition, spatialGrid, timeGrid, pdeCoefficients, solverOptions);
        elseif strcmpi(solverType, 'adaptPDE')
            solution = solveAdaptiveParabolicPDE(@parabolicPDE, initialCondition, @boundaryCondition, spatialGrid, timeGrid, pdeCoefficients, useAMR, solverOptions);
        else
            error('Invalid solver type. Choose ''pdepe'' or ''adaptPDE''.');
        end

        % Extract the concentration field from the solution
        concentrationField = extractConcentrationField(solution);

        % Display solver summary
        displaySolverSummary(solverType, useAMR, showPlots, saveSolution, solverOptions);

        % Plot the solution(s) if specified
        if showPlots
            plotPDESolution(spatialGrid, timeGrid, concentrationField, plotStyle, plotOptions, colorMap, plotTitle);
        end

        % Save the solution if specified
        if saveSolution
            saveSolutionToFile(spatialGrid, timeGrid, concentrationField, solverType, useAMR, outputFilename);
        end

        % Display solution statistics
        displaySolutionStatistics(concentrationField);
    
    catch exception
        handleSolverError(exception);
    end 
end

function validateInput(spatialGridSize, timeGridSize, solverType)
    % Validate input parameters
    if ~(isnumeric(spatialGridSize) && isnumeric(timeGridSize) && ...
            isscalar(spatialGridSize) && isscalar(timeGridSize) && ...
            spatialGridSize > 1 && timeGridSize > 1)
        error('Invalid input. Grid sizes must be numeric scalars greater than 1.');
    end

    validSolvers = {'pdepe', 'adaptPDE'};
    if ~ismember(lower(solverType), validSolvers)
        error('Invalid solver type. Choose ''pdepe'' or ''adaptPDE''.');
    end
end

function solution = solveParabolicPDEUsingPDEPE(pde, initialCondition, boundaryCondition, spatialGrid, timeGrid, pdeCoefficients, solverOptions)
    % Solve the parabolic PDE using pdepe
    solution = pdepe(pdeCoefficients, pde, initialCondition, boundaryCondition, spatialGrid, timeGrid, solverOptions);
end

function solution = solveAdaptiveParabolicPDE(pde, initialCondition, boundaryCondition, spatialGrid, timeGrid, pdeCoefficients, useAMR, solverOptions)
    % Solve the parabolic PDE using adaptPDE with optional adaptive mesh refinement (AMR)
    if useAMR
        solverOptions = odeset(solverOptions, 'Refine', 1);
    end

    solution = adaptPDE(pde, initialCondition, boundaryCondition, spatialGrid, timeGrid, pdeCoefficients, solverOptions);
end

function [pl, ql, pr, qr] = boundaryCondition(xl, ul, xr, ur, t)
    % Set boundary conditions at x = 0 and x = 1
    pl = ul;  % Left boundary condition
    ql = 0;   % Left boundary condition derivative
    pr = 0;   % Right boundary condition
    qr = ur;  % Right boundary condition derivative
end

function concentrationField = extractConcentrationField(solution)
    % Extract the concentration field from the solution
    concentrationField = solution(:, :, 1);
end

function displaySolverSummary(solverType, useAMR, showPlots, saveSolution, solverOptions)
    % Display a summary of the solver settings
    disp('Solver Summary:');
    disp(['Solver Type: ', solverType]);
    disp(['Adaptive Mesh Refinement (AMR): ', conditional(useAMR, 'Enabled', 'Disabled')]);
    disp(['Display Plots: ', conditional(showPlots, 'Yes', 'No')]);
    disp(['Save Solution: ', conditional(saveSolution, 'Yes', 'No')]);

    if ~isempty(solverOptions)
        disp('Additional Solver Options:');
        disp(solverOptions);
    end
end

function plotPDESolution(x, t, u, plotStyle, plotOptions, colorMap, plotTitle)
    % Plot the solution(s)
    figure;

    if iscell(u)
        for i = 1:length(u)
            subplot(length(u), 1, i);
            plotSingleSolution(x, u{i}, t(i), plotStyle, plotOptions, colorMap, plotTitle);
        end
    else
        plotSingleSolution(x, u, t, plotStyle, plotOptions, colorMap, plotTitle);
    end
end

function plotSingleSolution(x, u, t, plotStyle, plotOptions, colorMap, plotTitle)
    % Plot a single solution
    if isempty(plotOptions)
        if isempty(colorMap)
            plot(x, u, plotStyle);
        else
            plotlyPlot(x, u, colorMap, plotTitle);
        end
    else
        if isempty(colorMap)
            plot(x, u, plotStyle, plotOptions{:});
        else
            plotlyPlot(x, u, colorMap, plotTitle);
        end
    end

    xlabel('Spatial coordinate (x)');
    ylabel('Concentration');
    title(['Solution at t = ', num2str(t)]);

    if ~isempty(plotOptions)
        legend(plotOptions);
    end
end

function saveSolutionToFile(x, t, u, solverType, useAMR, outputFilename)
    % Save the solution to a file
    if nargin < 6
        outputFilename = ['parabolic_pde_solution_', solverType, '_', conditional(useAMR, 'AMR', 'nonAMR'), '.mat'];
    end

    save(outputFilename, 'x', 't', 'u');
    disp(['Solution saved to ', outputFilename]);
end

function displaySolutionStatistics(concentrationField)
    % Display solution statistics
    disp('Solution Statistics:');
    disp(['Maximum Concentration: ', num2str(max(concentrationField(:)))]);
    disp(['Minimum Concentration: ', num2str(min(concentrationField(:)))]);
    disp(['Average Concentration: ', num2str(mean(concentrationField(:)))]);
end
