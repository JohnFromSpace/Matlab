function main()
% Initialize GUI
    fig = uifigure('Name', 'Moving Sofa Problem');
    
    % Add sliders for initial guess of sofa dimensions
    lengthSlider = uislider(fig, 'Position', [100, 200, 120, 3], 'Limits', [0, 1], 'ValueChangedFcn', @updatePlot);
    widthSlider = uislider(fig, 'Position', [100, 150, 120, 3], 'Limits', [0, 0.5], 'ValueChangedFcn', @updatePlot);
    
    % Add labels for sliders
    uilabel(fig, 'Text', 'Initial Guess for Length:', 'Position', [20, 200, 150, 22]);
    uilabel(fig, 'Text', 'Initial Guess for Width:', 'Position', [20, 150, 150, 22]);
    
    % Create plot axes
    ax = uiaxes(fig, 'Position', [300, 100, 400, 400]);
    
    % Define initial guess for sofa dimensions (length and width)
    initialLength = 1;
    initialWidth = 0.5;
    
    % Plot initial sofa with initial guess
    plotSofa(ax, initialLength, initialWidth);
    
    % Define non-linear constraints
    nonlcon = @constraints;
    
    % Perform optimization on button press
    optimizeButton = uibutton(fig, 'push', 'Text', 'Optimize', 'Position', [100, 100, 100, 22], 'ButtonPushedFcn', @(btn,event) optimizeCallback(btn, lengthSlider, widthSlider, ax, nonlcon));
end

% Objective function to maximize sofa area
function obj = objective(x)
    
end
