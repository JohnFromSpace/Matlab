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

    % Define sliders for each parameter
    sliderHandleParam = uicontrol('Style', 'slider', 'Min', -10, 'Max', 10, 'Value', 1, ...
        'Position', [20, 70, 100, 20], 'Callback', @updateSliderParam);
    uicontrol('Style', 'text', 'Position', [20, 95, 100, 20], 'String', 'Parameter Value');

    % Plot initial trajectories, time evolution, and eigenvalue evolution
    plotInteractiveTrajectories(ode, integrationMethod, initialConditions, tspan, get(sliderHandleParam, 'Value'));

    % Add Save buttons
    uicontrol('Style', 'pushbutton', 'String', 'Save Phase Portrait', 'Position', [400, 10, 150, 30], 'Callback', {@savePlots, 'PhasePortrait'});
    uicontrol('Style', 'pushbutton', 'String', 'Save Eigenvalue Trajectories', 'Position', [560, 10, 200, 30], 'Callback', {@savePlots, 'EigenvalueTrajectories'});

    % Add Sensitivity Analysis button
    uicontrol('Style', 'pushbutton', 'String', 'Perform Sensitivity Analysis', 'Position', [800, 10, 220, 30], 'Callback', @performSensitivityAnalysis

    function updateSliderIC(~, ~, index)
        % Callback function for updating initial condition sliders
        initialConditions(index) = get(sliderHandlesIC(index), 'Value');
        plotInteractiveTrajectories(ode, integrationMethod, initialConditions, tspan, get(sliderHandleParam, 'Value'));
    end

    function updateSliderParam(~, ~)
        % Callback function for updating parameter slider
        paramValue = get(sliderHandleParam, 'Value');
        plotInteractiveTrajectories(ode, integrationMethod, initialConditions, tspan, paramValue);
    end

    function plotInteractiveTrajectories(ode, integrationMethod, initialConditions, tspan, paramValue)
        % Plot trajectories, time evolution, and eigenvalue evolution

        clf; % Clear the current figure

        % Substitute parameter value into the system
        odeWithParam = subs(ode, 'k', paramValue);

        % Initialize matrices to store time evolution and eigenvalues
        yEvolution = zeros(length(tspan), length(initialConditions));
        eigenvalueEvolution = zeros(length(tspan), length(initialConditions));

        for i = 1:length(tspan)
            % Solve the system of differential equations at each time step
            [t, y] = feval(integrationMethod, @(t, y) double(subs(odeWithParam, {'t', 'y'}, {t, y})), [tspan(i), tspan(end)], initialConditions);

            % Plot the trajectory in the phase plane
            subplot(2, 3, [1, 2]);
            plot(y(:,1), y(:,2), 'LineWidth', 1.5, 'DisplayName', ['t = ' num2str(tspan(i))]);
            xlabel('y1(t)');
            ylabel('y2(t)');
            title('Interactive Phase Portrait');
            legend('Location', 'Best');
            grid on;
            hold on;

            % Store the time evolution and eigenvalues
            yEvolution(i, :) = y(end, :);
            eigenvalueEvolution(i, :) = eig(subs(odeWithParam, {'t', 'y'}, {t(end), y(end, :)}));
        end

        % Plot time evolution
        subplot(2, 3, 4);
        plot(tspan, yEvolution, 'LineWidth', 1.5);
        xlabel('Time');
        ylabel('y(t)');
        title('Time Evolution');
        legend('y1(t)', 'y2(t)');
        grid on;
        
        % Plot eigenvalue evolution
        subplot(2, 3, 5);
        plot(tspan, real(eigenvalueEvolution), 'LineWidth', 1.5, 'DisplayName', 'Real');
        hold on;
        plot(tspan, imag(eigenvalueEvolution), 'LineWidth', 1.5, 'DisplayName', 'Imaginary');
        xlabel('Time');
        ylabel('Eigenvalues');
        title('Eigenvalue Evolution');
        legend('Location', 'Best');
        grid on;
        hold off;
        
        % Animate time evolution
        subplot(2, 3, 6);
        animateTimeEvolution(tspan, yEvolution, animationSpeed);                
    end

    function animateTimeEvolution(tspan, yEvolution, speed)
        % Animate the time evolution of trajectories

        for i = 1:length(tspan)
            plot(yEvolution(1:i, 1), yEvolution(1:i, 2), 'LineWidth', 1.5, 'DisplayName', ['t = ' num2str(tspan(i))]);
            xlabel('y1(t)');
            ylabel('y2(t)');
            title('Animated Time Evolution');
            legend('Location', 'Best');
            grid on;
            pause((tspan(2) - tspan(1)) / speed);
        end
    end

    function performSensitivityAnalysis(~, ~)
        % Perform sensitivity analysis by varying initial conditions and plotting trajectories and eigenvalue evolution

        % Initialize matrices to store sensitivity analysis results
        sensitivityResults = zeros(length(initialConditions), length(tspan), 2);

        % Vary each initial condition and observe the impact
        for i = 1:length(initialConditions)
            perturbedInitialConditions = initialConditions;
            perturbedInitialConditions(i) = perturbedInitialConditions(i) + 0.1; % Perturb the initial condition

            % Solve the system of differential equations with perturbed initial conditions
            [~, y] = feval(integrationMethod, @(t, y) double(subs(odeWithParam, {'t', 'y'}, {t, y})), tspan, perturbedInitialConditions);

            % Store the results for sensitivity analysis
            sensitivityResults(i, :, 1) = y(:, 1);
            sensitivityResults(i, :, 2) = y(:, 2);
        end

        
    end
end
