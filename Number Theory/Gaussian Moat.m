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

        % Button pushed function: SaveButton
        function SaveButtonPushed(app, event)
            % Get current date and time
            date_string = datestr(now, 'yyyy_mm_dd_HH_MM_SS');

            % Open file dialog for saving plot
            [file, path] = uiputfile(['GaussianMoatPlot_' date_string '.png'], 'Save Plot As');

            % Check if user canceled
            if isequal(file, 0) || isequal(path, 0)
                app.FeedbackLabel.Text = 'Plot not saved.';
                return;
            end

            % Save plot
            saveas(app.UIAxes, fullfile(path, file), 'png');
            app.FeedbackLabel.Text = 'Plot saved successfully.';
        end

        % Button pushed function: ResetButton
        function ResetButtonPushed(app, event)
            % Reset parameter values to defaults
            app.IslandRadiusSlider.Value = 10;
            app.MaximumMoatWidthSlider.Value = 5;
            app.SigmaSlider.Value = 5;
            app.GridSizeSlider.Value = 100;
            app.ColormapDropDown.Value = 'cool';

            % Display feedback message
            app.FeedbackLabel.Text = 'Parameters reset to defaults.';
        end

    end

    % App initialization and construction
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)
            % Create UIFigure
            app.UIFigure = uifigure('Name', 'Gaussian Moat Problem');
            app.UIFigure.Position = [100 100 640 480];

            % Create GridLayout
            app.GridLayout = uigridlayout(app.UIFigure);
            app.GridLayout.ColumnWidth = {'1x'};
            app.GridLayout.RowHeight = {'1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x'};

            % Create UIAxes
            app.UIAxes = uiaxes(app.GridLayout);
            app.UIAxes.Position = [21 54 600 400];
            title(app.UIAxes, 'Gaussian Moat Problem');
            xlabel(app.UIAxes, 'X');
            ylabel(app.UIAxes, 'Y');
            app.UIAxes.FontSize = 11;
            app.UIAxes.XGrid = 'on';
            app.UIAxes.YGrid = 'on';
            app.UIAxes.XMinorGrid = 'on';
            app.UIAxes.YMinorGrid = 'on';
            app.UIAxes.Box = 'on';

            % Create GridLayout2
            app.GridLayout2 = uigridlayout(app.GridLayout);
            app.GridLayout2.RowHeight = {'1x'};
            app.GridLayout2.ColumnWidth = {'1x', '1x', '1x', '1x'};

            % Create IslandRadiusLabel
            app.IslandRadiusLabel = uilabel(app.GridLayout2);
            app.IslandRadiusLabel.HorizontalAlignment = 'right';
            app.IslandRadiusLabel.VerticalAlignment = 'top';
            app.IslandRadiusLabel.FontSize = 11;
            app.IslandRadiusLabel.Text = 'Island Radius:';
            app.GridLayout2.Row = 1;
            app.GridLayout2.Column = 1;

            % Create IslandRadiusSlider
            app.IslandRadiusSlider = uislider(app.GridLayout2);
            app.IslandRadiusSlider.Limits = [1 20];
            app.IslandRadiusSlider.MajorTicks = [1 5 10 15 20];
            app.IslandRadiusSlider.ValueChangedFcn = createCallbackFcn(app, @PlotButtonPushed, true);
            app.GridLayout2.Row = 1;
            app.GridLayout2.Column = [2 4];
            app.IslandRadiusSlider.Value = 10;

            % Create MaximumMoatWidthLabel
            app.MaximumMoatWidthLabel = uilabel(app.GridLayout2);
            app.MaximumMoatWidthLabel.HorizontalAlignment = 'right';
            app.MaximumMoatWidthLabel.VerticalAlignment = 'top';
            app.MaximumMoatWidthLabel.FontSize = 11;
            app.MaximumMoatWidthLabel.Text = 'Maximum Moat Width:';
            app.GridLayout2.Row = 2;
            app.GridLayout2.Column = 1;

            % Create MaximumMoatWidthSlider
            app.MaximumMoatWidthSlider = uislider(app.GridLayout2);
            app.MaximumMoatWidthSlider.Limits = [1 10];
            app.MaximumMoatWidthSlider.MajorTicks = [1 3 5 7 10];
            app.MaximumMoatWidthSlider.ValueChangedFcn = createCallbackFcn(app, @PlotButtonPushed, true);
            app.GridLayout2.Row = 2;
            app.GridLayout2.Column = [2 4];
            app.MaximumMoatWidthSlider.Value = 5;

            % Create SigmaLabel
            app.SigmaLabel = uilabel(app.GridLayout2);
            app.SigmaLabel.HorizontalAlignment = 'right';
            app.SigmaLabel.VerticalAlignment = 'top';
            app.SigmaLabel.FontSize = 11;
            app.SigmaLabel.Text = 'Sigma:';
            app.GridLayout2.Row = 3;
            app.GridLayout2.Column = 1;

            % Create SigmaSlider
            app.SigmaSlider = uislider(app.GridLayout2);
            app.SigmaSlider.Limits = [1 20];
            app.SigmaSlider.MajorTicks = [1 5 10 15 20];
            app.SigmaSlider.ValueChangedFcn = createCallbackFcn(app, @PlotButtonPushed, true);
            app.GridLayout2.Row = 3;
            app.GridLayout2.Column = [2 4];
            app.SigmaSlider.Value = 5;

            % Create GridSizeLabel
            app.GridSizeLabel = uilabel(app.GridLayout2);
            app.GridSizeLabel.HorizontalAlignment = 'right';
            app.GridSizeLabel.VerticalAlignment = 'top';
            app.GridSizeLabel.FontSize = 11;
            app.GridSizeLabel.Text = 'Grid Size:';
            app.GridLayout2.Row = 4;
            app.GridLayout2.Column = 1;

            % Create GridSizeSlider
            app.GridSizeSlider = uislider(app.GridLayout2);
            app.GridSizeSlider.Limits = [50 150];
            app.GridSizeSlider.MajorTicks = [50 75 100 125 150];
            app.GridSizeSlider.ValueChangedFcn = createCallbackFcn(app, @PlotButtonPushed, true);
            app.GridLayout2.Row = 4;
            app.GridLayout2.Column = [2 4];
            app.GridSizeSlider.Value = 100;

            % Create ColormapLabel
            app.ColormapLabel = uilabel(app.GridLayout2);
            app.ColormapLabel.HorizontalAlignment = 'right';
            app.ColormapLabel.VerticalAlignment = 'top';
            app.ColormapLabel.FontSize = 11;
            app.ColormapLabel.Text = 'Colormap:';
            app.GridLayout2.Row = 5;
            app.GridLayout2.Column = 1;

            % Create ColormapDropDown
            app.ColormapDropDown = uidropdown(app.GridLayout2);
            app.ColormapDropDown.Items = {'parula', 'jet', 'hsv', 'hot', 'cool', 'spring', 'summer', 'autumn', 'winter', 'gray', 'bone', 'copper', 'pink', 'lines'};
            app.ColormapDropDown.ValueChangedFcn = createCallbackFcn(app, @PlotButtonPushed, true);
            app.GridLayout2.Row = 5;
            app.GridLayout2.Column = [2 4];
            app.ColormapDropDown.Value = 'cool';

            % Create PlotButton
            app.PlotButton = uibutton(app.GridLayout2, 'push');
            app.PlotButton.ButtonPushedFcn = createCallbackFcn(app, @PlotButtonPushed, true);
            app.GridLayout2.Row = 6;
            app.GridLayout2.Column = [1 2];
            app.PlotButton.Text = 'Plot';

            % Create SaveButton
            app.SaveButton = uibutton(app.GridLayout2, 'push');
            app.SaveButton.ButtonPushedFcn = createCallbackFcn(app, @SaveButtonPushed, true);
            app.GridLayout2.Row = 6;
            app.GridLayout2.Column = [3 4];
            app.SaveButton.Text = 'Save';

            % Create ResetButton
            app.ResetButton = uibutton(app.GridLayout2, 'push');
            app.ResetButton.ButtonPushedFcn = createCallbackFcn(app, @ResetButtonPushed, true);
            app.GridLayout2.Row = 7;
            app.GridLayout2.Column = [1 4];
            app.ResetButton.Text = 'Reset Parameters';

            % Create FeedbackLabel
            app.FeedbackLabel = uilabel(app.GridLayout2);
            app.FeedbackLabel.HorizontalAlignment = 'center';
            app.FeedbackLabel.FontSize = 11;
            app.GridLayout2.Row = 8;
            app.GridLayout2.Column = [1 4];
            app.FeedbackLabel.Text = '';

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = GaussianMoatApp
            % Create UIFigure and components
            createComponents(app);

            % Register the app with App Designer
            registerApp(app, app.UIFigure);
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure);
        end
    end
end

