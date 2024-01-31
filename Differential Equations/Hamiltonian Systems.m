function hamiltonian_simulation(tspan, dt, integration_method, save_results, plot_options, custom_hamiltonian, external_force, initial_conditions, ode45_options, energy_landscape_options, bifurcation_options, poincare_options)
    % Default parameters
    if nargin < 12
        poincare_options = struct();
    end

    if nargin < 11
        bifurcation_options = struct();
    end

    if nargin < 10
        energy_landscape_options = struct();
    end

    if nargin < 9
        ode45_options = [];
    end

    if nargin < 8
        initial_conditions = struct();
    end

    if nargin < 7
        external_force = @(t) 0; % Default no external force
    end

    if nargin < 6
        custom_hamiltonian = @(q, p) 0.5 * p.^2 + 0.5 * (1 * q).^2; % Default harmonic oscillator
    end

    % Extract parameters
    q0 = get_param(initial_conditions, 'q0', 1);
    p0 = get_param(initial_conditions, 'p0', 0);
    mass = get_param(initial_conditions, 'mass', 1);
    omega = get_param(initial_conditions, 'omega', 1);

    % Hamiltonian function with external force
    H = @(q, p, t) custom_hamiltonian(q, p) + external_force(t);

    % Hamilton's equations
    dqdt = @(q, p) p / mass;
    dpdt = @(q, p, t) -mass * omega^2 * q - gradient(external_force, t);

    % Poincaré section parameters
    if isfield(poincare_options, 'plane')
        poincare_plane = poincare_options.plane;
    else
        poincare_plane = 'xy';
    end

    if isfield(poincare_options, 'slice_value')
        poincare_slice_value = poincare_options.slice_value;
    else
        poincare_slice_value = 0;
    end
    
end
