function solveLinearODE()
    try
        % Get user input for the system of differential equations
        prompt = 'Enter the system of differential equations in terms of t and y(t): ';
        equationStr = input(prompt, 's');

        % Define the symbolic variables
        syms t
        y = sym('y', [1, length(str2num(equationStr))]);

        % Convert the user input string to a symbolic expression
        ode = evalin(symengine, equationStr);

        % Check if the system of differential equations is linear
        if ~isLinearODE(ode, y)
            error('The provided system of differential equations is not linear.');
        end

        % Get user input for initial conditions
        prompt = 'Enter initial conditions as a matrix [y1(t0), y2(t0), ...]: ';
        initialConditions = input(prompt);

        % Get user input for integration method
        prompt = 'Choose integration method (e.g., ''ode45'', ''ode23'', ''ode15s''): ';
        integrationMethod = input(prompt, 's');

        % Get user input for the time span
        prompt = 'Enter the time span as [t_start, t_end]: ';
        timeSpan = input(prompt);

        % Get user input for the number of time steps
        prompt = 'Enter the number of time steps: ';
        numTimeSteps = input(prompt);

        % Get user input for animation speed
        prompt = 'Enter animation speed (e.g., 1 for normal speed): ';
        animationSpeed = input(prompt);

        % Solve the system of differential equations with the initial conditions using the chosen method
        sol = dsolve(ode, initialConditions, 'Solver', integrationMethod);

        % Display the solution
        disp('Solution:');
        disp(sol);

        % Plot the solution, phase portrait, time evolution, and eigenvalue evolution
        plotSolution(sol, ode, integrationMethod, initialConditions, timeSpan, numTimeSteps, animationSpeed);
    catch ME
        fprintf('Error: %s\n', ME.message);
    end
end

function isLinear = isLinearODE(ode, y)
    % Check if the system of differential equations is linear
    isLinear = all(arrayfun(@(eq) isLinear(eq, y), ode));
end

function isLinear = isLinear(expr, y)
    % Check if the expression is linear with respect to the variable y
    isLinear = islinear(expr, y);
end

function plotSolution(sol, ode, integrationMethod, initialConditions, timeSpan, numTimeSteps, animationSpeed)
    % Plot the solution, phase portrait, time evolution, eigenvalue evolution, and perform sensitivity analysis

    % Define a time span for the trajectory
    tspan = linspace(timeSpan(1), timeSpan(2), numTimeSteps);

    % Create a figure with sliders for initial conditions and parameter
    figure('Name', 'Interactive Phase Portrait Explorer', 'Position', [100, 100, 1200, 800]);
    
    % Define sliders for each initial condition
    sliderHandlesIC = zeros(1, length(initialConditions));
    for i = 1:length(initialConditions)
        sliderHandlesIC(i) = uicontrol('Style', 'slider', 'Min', -10, 'Max', 10, 'Value', initialConditions(i), ...
            'Position', [20 + 120 * (i - 1), 10, 100, 20], 'Callback', {@updateSliderIC, i});
        uicontrol('Style', 'text', 'Position', [20 + 120 * (i - 1), 35, 100, 20], 'String', ['y' num2str(i) '(t0)']);
    end
end
