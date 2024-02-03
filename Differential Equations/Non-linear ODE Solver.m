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

    % Parse user inputs
    if nargin > 0
        for i = 1:2:(nargin - 1)
            switch varargin{i}
                case 'tspan'
                    tspan = varargin{i + 1};
                case 'initial_conditions'
                    initial_conditions = varargin{i + 1};
                case 'parameters'
                    parameters = varargin{i + 1};
                case 'options'
                    options = varargin{i + 1};
                case 'plot_options'
                    plot_options = varargin{i + 1};
                case 'save_results'
                    save_results = varargin{i + 1};
                case 'show_phase_portrait'
                    show_phase_portrait = varargin{i + 1};
                case 'output_function'
                    output_function = varargin{i + 1};
                case 'ode_solver'
                    ode_solver = varargin{i + 1};
                case 'animation_speed'
                    animation_speed = varargin{i + 1};
                case 'csv_filename'
                    csv_filename = varargin{i + 1};
                case 'parameter_variations'
                    parameter_variations = varargin{i + 1};
                case 'interactive_mode'
                    interactive_mode = varargin{i + 1};
                case 'higher_order_ode'
                    higher_order_ode = varargin{i + 1};
                case 'sensitivity_analysis'
                    sensitivity_analysis = varargin{i + 1};
                case 'sensitivity_options'
                    sensitivity_options = varargin{i + 1};
                case 'bifurcation_analysis'
                    bifurcation_analysis = varargin{i + 1};
                case 'bifurcation_parameter_range'
                    bifurcation_parameter_range = varargin{i + 1};
                case 'periodic_orbit_analysis'
                    periodic_orbit_analysis = varargin{i + 1};
                case 'periodic_orbit_options'
                    periodic_orbit_options = varargin{i + 1};
                otherwise
                    error(['Unexpected input: ', varargin{i}]);
            end
        end
    end

    % Solve the system of non-linear ODEs
    try
        if interactive_mode
            interactive_simulation(tspan, initial_conditions, parameters, options, plot_options, csv_filename, higher_order_ode, sensitivity_analysis, sensitivity_options, bifurcation_analysis, bifurcation_parameter_range, periodic_orbit_analysis, periodic_orbit_options, ode_solver, output_function, animation_speed, varargin);
        else
            solve_ode_system(tspan, initial_conditions, parameters, options, plot_options, save_results, show_phase_portrait, output_function, ode_solver, animation_speed, csv_filename, parameter_variations, higher_order_ode, sensitivity_analysis, sensitivity_options, bifurcation_analysis, bifurcation_parameter_range, periodic_orbit_analysis, periodic_orbit_options, varargin);
        end
    catch
        error('Error solving the ODEs. Check your input functions and parameters.');
    end
end

function solve_ode_system(tspan, initial_conditions, parameters, options, plot_options, save_results, show_phase_portrait, output_function, ode_solver, animation_speed, csv_filename, parameter_variations, higher_order_ode, sensitivity_analysis, sensitivity_options, bifurcation_analysis, bifurcation_parameter_range, periodic_orbit_analysis, periodic_orbit_options, user_inputs)
    % Solve the system of non-linear ODEs with given parameters

    % Check if parameter_variations is provided, otherwise set to empty
    if isempty(parameter_variations)
        parameter_variations = parameters;
    end
    
    % Check if user_inputs is provided, otherwise set to empty
    if isempty(user_inputs)
        user_inputs = cell(1, 1);
    end

    % Check if options is provided, otherwise set to default
    if isempty(options)
        options = odeset('RelTol', 1e-6, 'AbsTol', 1e-8);
    end

    % Preallocate results cell array
    results = cell(length(parameter_variations), 1);

    % Iterate through parameter variations
    for i = 1:length(parameter_variations)
        current_parameters = parameter_variations{i};
        [~, y] = ode_solver(@(t, y) ode_function(t, y, current_parameters, user_inputs), tspan, initial_conditions, options, 'OutputFcn', output_function);

        % Save results to cell array
        results{i}.parameters = current_parameters;
        results{i}.time = tspan;
        results{i}.solution = y;
    end

    % Plot and save results for each parameter variation
    for i = 1:length(results)
        % Plot the results with customizable options
        figure;
        plot(results{i}.time, results{i}.solution(:, 1), 'r-', results{i}.time, results{i}.solution(:, 2), 'b-');
        xlabel(plot_options.xlabel);
        ylabel(plot_options.ylabel);
        legend(plot_options.legend);
        title([plot_options.title, ' (', sprintf('Parameters: %.2f, %.2f', results{i}.parameters), ')']);
        grid on;

        % Save results to a CSV file if requested
        if save_results
            save_results_to_csv(results{i}.time, results{i}.solution, csv_filename);
        end
    end

    % Display the phase portrait if requested
    if show_phase_portrait
        display_phase_portrait(results, plot_options.legend);
    end

    % Animate the time evolution of the solution if output_function is provided
    if ~isempty(output_function)
        animate_solution(results, plot_options, animation_speed);
    end

    % Perform sensitivity analysis if requested
    if sensitivity_analysis
        perform_sensitivity_analysis(results, sensitivity_options, csv_filename);
    end

    % Perform bifurcation analysis if requested
    if bifurcation_analysis
        perform_bifurcation_analysis(results, plot_options, csv_filename, bifurcation_parameter_range);
    end

    % Perform periodic orbit analysis if requested
    if periodic_orbit_analysis
        perform_periodic_orbit_analysis(results, plot_options, csv_filename, periodic_orbit_options);
    end
end
