function [best_solution, best_fitness] = pack_tripods(container_dimensions, tripods, population_size, max_generations)
    % Validate input dimensions and tripods
    validateattributes(container_dimensions, {'numeric'}, {'vector', 'positive', 'numel', 2}, 'pack_tripods', 'container_dimensions');
    validateattributes(tripods, {'numeric'}, {'2d', 'positive'}, 'pack_tripods', 'tripods');
    
    % Initialize GA parameters
    num_tripods = size(tripods, 1);
    num_genes = num_tripods * 2; % Each gene represents x and y coordinates of a tripod
    lower_bound = [ones(1, num_tripods), ones(1, num_tripods)]; % Lower bound for gene values (1-based)
    upper_bound = [repmat(container_dimensions(1), 1, num_tripods), repmat(container_dimensions(2), 1, num_tripods)]; % Upper bound for gene values
    mutation_rate = 0.1;
    
    % Initialize population
    population = initialize_population(population_size, num_genes, lower_bound, upper_bound);
    
    % Main loop
    for generation = 1:max_generations
        % Evaluate fitness of each individual
        fitness_values = evaluate_fitness(population, container_dimensions, tripods);
        
        % Select parents for reproduction
        parents = select_parents(population, fitness_values);
        
        % Perform crossover and mutation
        offspring = crossover_and_mutation(parents, mutation_rate, lower_bound, upper_bound);
        
        % Replace population with offspring
        population = offspring;
    end
    
    % Find the best solution
    fitness_values = evaluate_fitness(population, container_dimensions, tripods);
    [best_fitness, idx] = max(fitness_values);
    best_solution = population(idx, :);    
end

function population = initialize_population(population_size, num_genes, lower_bound, upper_bound)
    % Initialize population randomly within the specified bounds
    population = rand(population_size, num_genes) .* (upper_bound - lower_bound) + lower_bound;    
end

function fitness_values = evaluate_fitness(population, container_dimensions, tripods)
    % Evaluate fitness of each individual (solution)
    num_individuals = size(population, 1);
    fitness_values = zeros(num_individuals, 1);
    for i = 1:num_individuals
        solution = reshape(population(i, :), [], 2);
        packed_tripods = pack_tripods_from_solution(container_dimensions, tripods, solution);
        packed_area = sum(packed_tripods(:, 3) .* packed_tripods(:, 4));
        total_area = container_dimensions(1) * container_dimensions(2);
        fitness_values(i) = packed_area / total_area; % Maximizing packing efficiency
    end    
end

function parents = select_parents(population, fitness_values)
    % Tournament selection
    num_parents = size(population, 1);
    tournament_size = 2;
    parents = zeros(num_parents, size(population, 2));
    for i = 1:num_parents
        tournament_indices = randperm(length(fitness_values), tournament_size);
        [~, idx] = max(fitness_values(tournament_indices));
        parents(i, :) = population(tournament_indices(idx), :);
    end    
end
