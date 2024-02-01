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
end
