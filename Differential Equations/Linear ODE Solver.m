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
end
