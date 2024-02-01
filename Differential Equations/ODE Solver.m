function solve_and_plot_ode(a_values, tspan, y0, varargin)
    % Check if 'a_values' is a scalar, if so, convert it to a vector
    if isscalar(a_values)
        a_values = [a_values];
    end

    % Define the ODE function
    odeFunction = @(t, y, a) -a*y;  % Modified ODE: dy/dt = -a*y

    % Parse optional input arguments
    p = inputParser;
    addParameter(p, 'Colors', lines(length(a_values)), @isnumeric);
    addParameter(p, 'LineStyles', '-', @(x) ischar(x) || iscell(x));
    addParameter(p, 'LineWidths', 2, @(x) isnumeric(x) && (isscalar(x) || length(x) == length(a_values)));
    addParameter(p, 'LegendLocation', 'Best', @ischar);
    addParameter(p, 'LegendFontSize', 12, @isnumeric);
    addParameter(p, 'LegendIndices', [], @(x) isempty(x) || isnumeric(x));
    addParameter(p, 'Title', 'ODE Solutions', @ischar);
    addParameter(p, 'TitleFontSize', 14, @isnumeric);
    addParameter(p, 'XLabel', 'Time (t)', @ischar);
    addParameter(p, 'YLabel', 'Solution (y)', @ischar);
    addParameter(p, 'AxisFontSize', 12, @isnumeric);
    addParameter(p, 'SavePlot', false, @islogical);
    addParameter(p, 'SaveFormat', 'png', @ischar);
    addParameter(p, 'SaveFilename', 'ode_plot', @ischar);
    addParameter(p, 'FigureSize', [800, 600], @(x) isnumeric(x) && length(x) == 2);
    addParameter(p, 'ShowLegend', true, @islogical);
    addParameter(p, 'Solver', @ode45, @(x) isa(x, 'function_handle'));
    addParameter(p, 'SolverOptions', odeset(), @isstruct);
    addParameter(p, 'XLim', [], @(x) isempty(x) || isnumeric(x));
    addParameter(p, 'YLim', [], @(x) isempty(x) || isnumeric(x));
    addParameter(p, 'Grid', true, @islogical);
    addParameter(p, 'AdditionalFunctions', {}, @iscell);
    addParameter(p, 'PhasePortrait', false, @islogical);
    addParameter(p, 'ColormapParameter', [], @(x) isempty(x) || isnumeric(x));
    addParameter(p, 'Colormap', jet(length(a_values)), @isnumeric);
    addParameter(p, 'ColorbarLabel', '', @ischar);
    addParameter(p, 'TrajectoryArrows', false, @islogical);
    addParameter(p, 'ArrowScale', 0.5, @isnumeric);
    addParameter(p, 'ArrowColor', 'k', @ischar);
    addParameter(p, 'ArrowDensity', 10, @isnumeric);
    addParameter(p, 'LegendEntries', {}, @iscell);
    addParameter(p, 'Markers', 'o', @(x) ischar(x) || iscell(x));
    addParameter(p, 'MarkerSize', 6, @isnumeric);
    addParameter(p, 'PhasePortraitSave', false, @islogical);
    addParameter(p, 'PhasePortraitSaveFormat', 'png', @ischar);
    addParameter(p, 'MultiplePhasePortraits', false, @islogical);
    addParameter(p, 'InitialConditions', [], @isnumeric);
    addParameter(p, 'ThreeDPlot', false, @islogical);
    addParameter(p, '3DPlotColor', 'b', @ischar);
    addParameter(p, '3DPlotLineStyle', '-', @ischar);
    addParameter(p, '3DPlotLineWidth', 1, @isnumeric);
    addParameter(p, '3DPlotMarker', 'o', @ischar);
    addParameter(p, '3DPlotMarkerSize', 6, @isnumeric);
    parse(p, varargin{:});

    % Error handling for invalid solver options
    try
        [~] = p.Results.Solver(tspan, y0, odeFunction, p.Results.SolverOptions);
    catch
        error('Invalid solver or options. Please provide a valid solver function handle and options.');
    end
end
