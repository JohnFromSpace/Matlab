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

function offspring = crossover_and_mutation(parents, mutation_rate, lower_bound, upper_bound)
    % Single-point crossover
    num_offspring = size(parents, 1);
    crossover_point = randi(size(parents, 2));
    crossover_indices = randperm(num_offspring);
    offspring = parents;
    for i = 1:2:num_offspring
        if i + 1 <= num_offspring
            % Perform crossover
            offspring(i, crossover_point:end) = parents(i + 1, crossover_point:end);
            offspring(i + 1, crossover_point:end) = parents(i, crossover_point:end);
        end
    end
    
    % Mutation
    mutation_indices = rand(num_offspring, size(parents, 2)) < mutation_rate;
    mutation_values = rand(num_offspring, size(parents, 2)) .* (upper_bound - lower_bound) + lower_bound;
    offspring = offspring + mutation_indices .* mutation_values;
    % Ensure offspring values are within bounds
    offspring = min(upper_bound, max(lower_bound, offspring));    
end

function packed_tripods = pack_tripods_from_solution(container_dimensions, tripods, solution)
    % Pack tripods based on the solution (gene values)
    packed_tripods = [];
    container_grid = zeros(container_dimensions(2), container_dimensions(1));
    for i = 1:size(tripods, 1)
        tripod = tripods(i, :);
        position = solution(i, :);
        row = round(position(2));
        col = round(position(1));
        if row >= 1 && row + tripod(2) - 1 <= container_dimensions(2) && ...
                col >= 1 && col + tripod(1) - 1 <= container_dimensions(1) && ...
                all(container_grid(row:row+tripod(2)-1, col:col+tripod(1)-1) == 0)
            container_grid(row:row+tripod(2)-1, col:col+tripod(1)-1) = 1;
            packed_tripods = [packed_tripods; [col, row, tripod]];
        end
    end    
end

% Example usage:
container_dimensions = [10, 20]; % Dimensions of the container (width, height)
tripods = [5, 5; 8, 6; 4, 7; 6, 10]; % Dimensions of tripods (width, height)
population_size = 50; % Size of the population
max_generations = 100; % Maximum number of generations

[best_solution, best_fitness] = pack_tripods(container_dimensions, tripods, population_size, max_generations);
