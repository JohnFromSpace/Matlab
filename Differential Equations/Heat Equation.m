function solveHeatEquation(pdeCoefficients, domain, spatialResolution, timeResolution, initialCondition, plotOptions, boundaryConditions, solver, timeSpan)
    % Set default values if not provided
    if nargin < 9
        timeSpan = [0, 0.1]; % Default time span
    end
    if nargin < 8
        solver = 'pdepe'; % Default solver is pdepe
    end
    if nargin < 7
        boundaryConditions.left = 'Dirichlet';   % Default left boundary condition
        boundaryConditions.right = 'Dirichlet';  % Default right boundary condition
    end
    if nargin < 6
        plotOptions.colormap = 'parula';         % Default colormap
        plotOptions.plotTitle = 'Heat Equation Solution';
        plotOptions.savePlot = false;            % Do not save the plot by default
        plotOptions.savePath = '';               % Save path (empty by default)
        plotOptions.showHeatmap = true;          % Show the heatmap by default
        plotOptions.heatmapTimes = [0.05, 0.1];  % Default time points for heatmaps
    end
    if nargin < 5
        initialCondition = @(x) sin(pi * x);     % Default initial condition
    end
    if nargin < 4
        timeResolution = 100;                    % Default time resolution
    end
    if nargin < 3
        spatialResolution = 100;                 % Default spatial resolution
    end
    if nargin < 2
        domain.start = 0;
        domain.end = 1;
    end
    if nargin < 1
        % Default PDE coefficients
        pdeCoefficients.convection = @(x, t) 0; % No convection term
        pdeCoefficients.diffusion = @(x, t) 1;  % Default diffusion coefficient
        pdeCoefficients.reaction = @(x, t) 0;   % No reaction term
    end
        
    % Define the spatial and time span
    xspan = linspace(domain.start, domain.end, spatialResolution);
    tspan = linspace(timeSpan(1), timeSpan(2), timeResolution);

    try
        % Solve the PDE using the specified solver
        solution = solvePDE(pdeCoefficients, initialCondition, xspan, tspan, boundaryConditions, solver);

        % Plot and save the solution
        plotAndSaveSolution(solution, xspan, tspan, plotOptions);
    catch exception
        disp(['Error: ', exception.message]);
    end
end

function solution = solvePDE(coefficients, initialCondition, xspan, tspan, boundaryConditions, solver)
    % Solve the PDE using the specified solver
    switch lower(solver)
        case 'pdepe'
            solution = solvePDEPDEPE(coefficients, initialCondition, xspan, tspan, boundaryConditions);
        case 'finitedifference'
            solution = solvePDEFiniteDifference(coefficients, initialCondition, xspan, tspan, boundaryConditions);
        otherwise
            error('Invalid solver specified.');
    end
end

function solution = solvePDEPDEPE(coefficients, initialCondition, xspan, tspan, boundaryConditions)
    % Solve the PDE using pdepe
    m = 0; % Assume one-dimensional problem
    
    % Convert boundary conditions to pdepe format
    pdepeBC.left = getBoundaryCondition(boundaryConditions.left);
    pdepeBC.right = getBoundaryCondition(boundaryConditions.right);

    % Define variable diffusion coefficient
    diffusionCoefficient = coefficients.diffusion;

    % Solve the PDE
    sol = pdepe(m, @heatEquationPDE, initialCondition, pdepeBC, xspan, tspan, 'diffusion', diffusionCoefficient);

    % Store the solution in a structure for easy access
    solution.x = sol.x;
    solution.u = sol.u;
end

function solution = solvePDEFiniteDifference(coefficients, initialCondition, xspan, tspan, boundaryConditions)
    % Solve the PDE using finite difference method
    dx = xspan(2) - xspan(1);
    dt = tspan(2) - tspan(1);
    spatialPoints = length(xspan);
    timePoints = length(tspan);

    % Initialize solution matrix
    solution.u = zeros(timePoints, spatialPoints);
    solution.x = xspan;

    % Set initial condition
    solution.u(1, :) = initialCondition(xspan);
    
    % Finite difference method
    for n = 1:timePoints - 1
        for i = 2:spatialPoints - 1
            % Variable diffusion coefficient
            diffusionCoefficient = coefficients.diffusion(xspan(i), tspan(n));

            % Variable convection coefficient
            convectionCoefficient = coefficients.convection(xspan(i), tspan(n));

            solution.u(n + 1, i) = solution.u(n, i) + ...
                diffusionCoefficient * dt / dx^2 * (solution.u(n, i + 1) - 2 * solution.u(n, i) + solution.u(n, i - 1)) ...
                + convectionCoefficient * dt / (2 * dx) * (solution.u(n, i + 1) - solution.u(n, i - 1));
        end

        % Apply boundary conditions
        solution.u(n + 1, 1) = boundaryConditions.left(xspan(1), tspan(n + 1));
        solution.u(n + 1, end) = boundaryConditions.right(xspan(end), tspan(n + 1));
    end
end

function [c, f, s] = heatEquationPDE(x, t, u, DuDx, coefficients)
    % PDE coefficients
    c = 1;                   % Coefficient multiplying u_t
    f = coefficients.diffusion(x, t) * DuDx; % Variable diffusion term
    s = coefficients.reaction(x, t) * u;          % Reaction term
end

function bc = getBoundaryCondition(type)
    % Convert boundary condition type to pdepe format
    switch type
        case 'dirichlet'
            bc = @(x) 0; % Dirichlet condition
        case 'neumann'
            bc = @(x) 0; % Neumann condition (zero flux)
        case 'mixed'
            bc = @(x) [0; 0]; % Mixed condition (both Dirichlet and Neumann)
        otherwise
            error('Invalid boundary condition type.');
    end
end

function plotAndSaveSolution(solution, xspan, tspan, plotOptions)
    % Plot the solution interactively
    plot3DSolution(solution, xspan, tspan, plotOptions);

    % Save the plot if specified
    if plotOptions.savePlot
        savePlotAsImage(plotOptions.savePath, plotOptions.plotTitle);
    end

    % Display the heatmaps if specified
    if plotOptions.showHeatmap
        plotMultipleHeatmaps(solution, xspan, tspan, plotOptions.heatmapTimes, plotOptions.colormap);
    end
end

function plot3DSolution(solution, xspan, tspan, plotOptions)
    % Plot the solution interactively
    figure;
    surf(solution.x, tspan, solution.u, 'EdgeColor', 'none');
    xlabel('Position (x)');
    ylabel('Time (t)');
    zlabel('Temperature (u)');
    title(plotOptions.plotTitle);
    axis tight;
    rotate3d on;
    view(45, 30);
    colorbar;
    colormap(plotOptions.colormap);
end

function savePlotAsImage(savePath, plotTitle)
    % Save the plot as an image
    [~, ~, ext] = fileparts(savePath);
    supportedFormats = {'.png', '.jpg', '.jpeg', '.pdf', '.fig'};

    if ~any(strcmpi(ext, supportedFormats))
        warning('Unsupported file format. Plot not saved.');
        return;
    end

    saveas(gcf, savePath);
    disp(['Plot saved as ', savePath]);
end

function plotMultipleHeatmaps(solution, xspan, tspan, targetTimes, colormapName)
    % Plot multiple 2D heatmaps at different time points
    figure;
    for i = 1:length(targetTimes)
        subplot(1, length(targetTimes), i);
        plotHeatmap(solution, xspan, tspan, targetTimes(i), [tspan(1), tspan(end)], colormapName);
    end
end

function plotHeatmap(solution, xspan, tspan, targetTime, timeSpan, colormapName)
    % Plot a 2D heatmap of the temperature distribution at a specific time
    timeIndex = find(tspan >= targetTime, 1, 'first');
    
    % Ensure the specified time is within the time span
    if isempty(timeIndex) || targetTime < timeSpan(1) || targetTime > timeSpan(2)
        warning('Invalid time specified for heatmap. Not plotted.');
        return;
    end
    
    
end
