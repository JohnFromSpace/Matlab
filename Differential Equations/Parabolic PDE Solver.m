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