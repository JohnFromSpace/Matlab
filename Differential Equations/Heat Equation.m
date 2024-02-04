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

    
end
