classdef GaussianMoatApp < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = private)
        UIFigure              matlab.ui.Figure
        GridLayout            matlab.ui.container.GridLayout
        GridLayout2           matlab.ui.container.GridLayout
        IslandRadiusLabel     matlab.ui.control.Label
        IslandRadiusSlider    matlab.ui.control.Slider
        MaximumMoatWidthLabel matlab.ui.control.Label
        MaximumMoatWidthSlider matlab.ui.control.Slider
        SigmaLabel            matlab.ui.control.Label
        SigmaSlider           matlab.ui.control.Slider
        GridSizeLabel         matlab.ui.control.Label
        GridSizeSlider        matlab.ui.control.Slider
        ColormapLabel         matlab.ui.control.Label
        ColormapDropDown      matlab.ui.control.DropDown
        PlotButton            matlab.ui.control.Button
        SaveButton            matlab.ui.control.Button
        ResetButton           matlab.ui.control.Button
        UIAxes                matlab.ui.control.UIAxes
        FeedbackLabel         matlab.ui.control.Label
    end

    % Callbacks that handle component events
    methods (Access = private)

        % Button pushed function: PlotButton
        function PlotButtonPushed(app, event)
            % Get parameter values
            island_radius = app.IslandRadiusSlider.Value;
            moat_width_max = app.MaximumMoatWidthSlider.Value;
            sigma = app.SigmaSlider.Value;
            grid_size = app.GridSizeSlider.Value;
            colormap_choice = app.ColormapDropDown.Value;

            % Generate grid
            [X, Y] = meshgrid(-grid_size:grid_size);

            % Create island
            island = (X.^2 + Y.^2 <= island_radius^2);

            % Create moat
            distance_from_center = sqrt(X.^2 + Y.^2);
            moat_width = moat_width_max * exp(-(distance_from_center.^2) / (2 * sigma^2));
            moat = moat_width - island_radius;

            % Plot the island and moat
            contour(app.UIAxes, X, Y, island, [0.5, 0.5], 'LineWidth', 2, 'LineColor', 'blue');
            hold(app.UIAxes, 'on');
            contour(app.UIAxes, X, Y, moat, [0, 0], 'LineWidth', 2, 'LineColor', 'red');
            axis(app.UIAxes, 'equal');
            title(app.UIAxes, 'Gaussian Moat Problem');
            xlabel(app.UIAxes, 'X');
            ylabel(app.UIAxes, 'Y');
            legend(app.UIAxes, app.UIAxes.Children(2), {'Island', 'Moat'});
            colormap(app.UIAxes, colormap_choice);
            colorbar(app.UIAxes);
            grid(app.UIAxes, 'on');
            grid(app.UIAxes, 'minor');

            % Display feedback message
            app.FeedbackLabel.Text = 'Plot generated successfully.';
        end

        
end

