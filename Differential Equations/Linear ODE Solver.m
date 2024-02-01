function solveLinearODE()
    try
        % Get user input for the system of differential equations
        prompt = 'Enter the system of differential equations in terms of t and y(t): ';
        equationStr = input(prompt, 's');

        % Define the symbolic variables
        syms t
        y = sym('y', [1, length(str2num(equationStr))]);

end
