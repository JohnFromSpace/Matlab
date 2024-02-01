function solve_and_plot_ode(a_values, tspan, y0, varargin)
    % Check if 'a_values' is a scalar, if so, convert it to a vector
    if isscalar(a_values)
        a_values = [a_values];
    end

    % Define the ODE function
    odeFunction = @(t, y, a) -a*y;  % Modified ODE: dy/dt = -a*y
end
