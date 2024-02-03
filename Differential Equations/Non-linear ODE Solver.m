function solve_nonlinear_ode(varargin)
    % varargin allows users to input their own ODE function directly in the interactive mode

    % Initialize default parameters
    tspan = [0 10];
    initial_conditions = [1; 0];
    parameters = [1; 1];
    options = odeset('RelTol', 1e-6, 'AbsTol', 1e-8);
    plot_options = struct('title', 'Custom Non-linear ODE Solution', 'xlabel', 'Time', 'ylabel', 'Solution', 'legend', {'y1(t)', 'y2(t)'});
    save_results = false;
    show_phase_portrait = false;
    output_function = [];
    ode_solver = @ode45;
    animation_speed = 0.1;
    csv_filename = 'ode_solution_results.csv';
    parameter_variations = [];
    interactive_mode = false;
    higher_order_ode = false;
    sensitivity_analysis = false;
    sensitivity_options = struct('perturbation_magnitude', 1e-3, 'perturbation_duration', 0.1);
    bifurcation_analysis = false;
    bifurcation_parameter_range = [];
    periodic_orbit_analysis = false;
    periodic_orbit_options = struct('max_iterations', 1000, 'tolerance', 1e-6);

end
