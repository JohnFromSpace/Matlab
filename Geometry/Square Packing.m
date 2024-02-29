function [packed_squares, remaining_space] = pack_squares_genetic_lkh(container_width, container_height, square_sizes, population_size, generations, local_search_iterations, num_workers)
    % Genetic Algorithm parameters
    mutation_rate = 0.1;
    crossover_rate = 0.8;
    
    % Generate initial population
    population = generate_population(population_size, square_sizes, container_width, container_height);
    
    % Evolution loop
    parfor gen = 1:generations
        % Evaluate fitness of each individual
        fitness = evaluate_fitness(population, square_sizes, container_width, container_height);
        
        % Selection
        selected_parents = tournament_selection(population, fitness, 2);
        
        % Crossover
        offspring = crossover(selected_parents, crossover_rate);
        
        % Mutation
        mutated_offspring = mutation(offspring, mutation_rate, container_width, container_height);
        
        % Apply LKH local search
        mutated_offspring = apply_lkh(mutated_offspring, square_sizes, container_width, container_height, local_search_iterations);
        
        % Replace old population with new generation
        population = mutated_offspring;
    end
    
    % Find the best individual in the final population
    [~, idx] = min(evaluate_fitness(population, square_sizes, container_width, container_height));
    best_individual = population(idx, :);
    
    % Decode best individual into packed squares
    packed_squares = decode_solution(best_individual, square_sizes);
    
    % Calculate remaining space
    remaining_space = calculate_remaining_space(container_width, container_height, packed_squares);    
end

function population = generate_population(population_size, square_sizes, container_width, container_height)
    % Generate initial population randomly
    num_squares = numel(square_sizes);
    population = zeros(population_size, num_squares * 2);

    for i = 1:population_size
        population(i, :) = generate_random_solution(square_sizes, container_width, container_height);
    end
end

function solution = generate_random_solution(square_sizes, container_width, container_height)
    % Generate a random solution
    num_squares = numel(square_sizes);
    solution = zeros(1, num_squares * 2); % Each square represented by [x, y] coordinates
    for i = 1:num_squares
        x = randi([1, container_width - square_sizes(i)]);
        y = randi([1, container_height - square_sizes(i)]);
        solution((i-1)*2+1:i*2) = [x, y];
    end
end

function fitness = evaluate_fitness(population, square_sizes, container_width, container_height)
    % Evaluate fitness of each individual
    num_individuals = size(population, 1);
    fitness = zeros(num_individuals, 1);
    for i = 1:num_individuals
        packed_squares = decode_solution(population(i, :), square_sizes);
        remaining_space = calculate_remaining_space(container_width, container_height, packed_squares);
        fitness(i) = -remaining_space; % Maximizing remaining space is equivalent to minimizing used space
    end    
end

function selected_parents = tournament_selection(population, fitness, k)
    % Tournament selection
    num_individuals = size(population, 1);
    selected_parents = zeros(k, size(population, 2));
    
end
