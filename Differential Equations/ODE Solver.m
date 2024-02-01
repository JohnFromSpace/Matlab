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

    % Initialize figure
    figure('Position', [100, 100, p.Results.FigureSize]);

    % Loop through different values of 'a'
    for i = 1:length(a_values)
        % Solve the ODE
        sol = p.Results.Solver(@(t, y) odeFunction(t, y, a_values(i)), tspan, y0, p.Results.SolverOptions);

        % Extract solution
        t = sol.x;
        y = sol.y;

        % Plot the solution with customizable colors, line styles, and line widths
        plot(t, y, 'LineWidth', p.Results.LineWidths(i), 'DisplayName', p.Results.LegendEntries{i}, ...
            'Color', p.Results.Colors(i, :), 'LineStyle', p.Results.LineStyles, ...
            'Marker', p.Results.Markers{i}, 'MarkerSize', p.Results.MarkerSize, 'MarkerFaceColor', p.Results.Colors(i, :));

        % Hold on for subsequent plots
        hold on;
    end

    % Plot additional user-defined functions
    for j = 1:length(p.Results.AdditionalFunctions)
        fun = p.Results.AdditionalFunctions{j};
        plot(tspan, fun(tspan), '--', 'DisplayName', func2str(fun), ...
            'Color', p.Results.Colors(j, :), 'LineStyle', p.Results.LineStyles, ...
            'Marker', p.Results.Markers{j}, 'MarkerSize', p.Results.MarkerSize, 'MarkerFaceColor', p.Results.Colors(j, :));
        hold on;
    end

    % Display phase portrait if specified
    if p.Results.PhasePortrait
        if p.Results.MultiplePhasePortraits && ~isempty(p.Results.InitialConditions)
            % Display multiple phase portraits with different initial conditions
            for k = 1:size(p.Results.InitialConditions, 1)
                figure;
                phase_portrait(@(t, y) odeFunction(t, y, a_values(1)), tspan, p.Results.InitialConditions(k, :), p.Results.SolverOptions, ...
                    'TrajectoryArrows', p.Results.TrajectoryArrows, 'ArrowScale', p.Results.ArrowScale, 'ArrowColor', p.Results.ArrowColor, 'ArrowDensity', p.Results.ArrowDensity);
                title(['Phase Portrait - Initial Conditions: ', num2str(p.Results.InitialConditions(k, :))], 'FontSize', p.Results.TitleFontSize);
                xlabel('Solution (y)', 'FontSize', p.Results.AxisFontSize);
                ylabel("dy/dt", 'FontSize', p.Results.AxisFontSize);
                grid on;

                % Save each phase portrait as an image file if specified
                if p.Results.PhasePortraitSave
                    saveas(gcf, ['phase_portrait_', num2str(k), '.', p.Results.PhasePortraitSaveFormat]);
                end
            end
        else
            % Display a single phase portrait
            figure;
            phase_portrait(@(t, y) odeFunction(t, y, a_values(1)), tspan, y0, p.Results.SolverOptions, ...
                'TrajectoryArrows', p.Results.TrajectoryArrows, 'ArrowScale', p.Results.ArrowScale, 'ArrowColor', p.Results.ArrowColor, 'ArrowDensity', p.Results.ArrowDensity);
            title('Phase Portrait', 'FontSize', p.Results.TitleFontSize);
            xlabel('Solution (y)', 'FontSize', p.Results.AxisFontSize);
            ylabel("dy/dt", 'FontSize', p.Results.AxisFontSize);
            grid on;

            % Save phase portrait as an image file if specified
            if p.Results.PhasePortraitSave
                saveas(gcf, ['phase_portrait.', p.Results.PhasePortraitSaveFormat]);
            end
        end
    end

    % Display 3D plot if specified
    if p.Results.ThreeDPlot
        figure;
        plot3(sol(:, 1), sol(:, 2), t, ...
            'Color', p.Results.3DPlotColor, 'LineStyle', p.Results.3DPlotLineStyle, 'LineWidth', p.Results.3DPlotLineWidth, ...
            'Marker', p.Results.3DPlotMarker, 'MarkerSize', p.Results.3DPlotMarkerSize, 'MarkerFaceColor', p.Results.3DPlotColor);
        grid on;
        xlabel('Solution (y)', 'FontSize', p.Results.AxisFontSize);
        ylabel("dy/dt", 'FontSize', p.Results.AxisFontSize);
        zlabel('Time (t)', 'FontSize', p.Results.AxisFontSize);
        title('3D Plot of ODE Solutions', 'FontSize', p.Results.TitleFontSize);
    end

    % Display colorbar if ColormapParameter is specified
    if ~isempty(p.Results.ColormapParameter)
        colormap(p.Results.Colormap);
        colorbar('Ticks', linspace(0, 1, length(a_values)), 'TickLabels', arrayfun(@(x) num2str(x), p.Results.ColormapParameter, 'UniformOutput', false));
        caxis([min(p.Results.ColormapParameter), max(p.Results.ColormapParameter)]);
        colorbar('Label', p.Results.ColorbarLabel, 'FontSize', p.Results.AxisFontSize);
    end

    % Customize the plot
    xlabel(p.Results.XLabel, 'FontSize', p.Results.AxisFontSize);
    ylabel(p.Results.YLabel, 'FontSize', p.Results.AxisFontSize);
    title(p.Results.Title, 'FontSize', p.Results.TitleFontSize);

    % Customize axis limits
    if ~isempty(p.Results.XLim)
        xlim(p.Results.XLim);
    end
    if ~isempty(p.Results.YLim)
        ylim(p.Results.YLim);
    end

    % Customize grid visibility
    if p.Results.Grid
        grid on;
    else
        grid off;
    end

    % Customize legend visibility and indices
    if p.Results.ShowLegend
        if isempty(p.Results.LegendIndices)
            legend('Location', p.Results.LegendLocation, 'FontSize', p.Results.LegendFontSize);
        else
            legend(p.Results.LegendIndices, 'Location', p.Results.LegendLocation, 'FontSize', p.Results.LegendFontSize);
        end
    else
        legend('off');
    end

    % Save the plot if specified
    if p.Results.SavePlot
        saveas(gcf, [p.Results.SaveFilename, '.', p.Results.SaveFormat]);
    end
end

function phase_portrait(ode, tspan, y0, options, varargin)
    p = inputParser;
    addParameter(p, 'TrajectoryArrows', false, @islogical);
    addParameter(p, 'ArrowScale', 0.5, @isnumeric);
    addParameter(p, 'ArrowColor', 'k', @ischar);
    addParameter(p, 'ArrowDensity', 10, @isnumeric);
    parse(p, varargin{:});

    [~, sol] = ode45(ode, tspan, y0, options);
    plot(sol(:, 1), sol(:, 2));

    if p.Results.TrajectoryArrows
        hold on;
        quiver(sol(1:p.Results.ArrowDensity:end, 1), sol(1:p.Results.ArrowDensity:end, 2), ...
            sol(1:p.Results.ArrowDensity:end, 1) - sol(1:p.Results.ArrowDensity:end - 1, 1), ...
            sol(1:p.Results.ArrowDensity:end, 2) - sol(1:p.Results.ArrowDensity:end - 1, 2), p.Results.ArrowScale, 'Color', p.Results.ArrowColor);
    end

    axis('equal');
end
