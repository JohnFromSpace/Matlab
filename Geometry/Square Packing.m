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

    for i = 1:k
        idx = randperm(num_individuals, 2);
        if fitness(idx(1)) > fitness(idx(2))
            selected_parents(i, :) = population(idx(1), :);
        else
            selected_parents(i, :) = population(idx(2), :);
        end
    end
end

function offspring = crossover(selected_parents, crossover_rate)
    % One-point crossover
    num_parents = size(selected_parents, 1);
    offspring = zeros(num_parents, size(selected_parents, 2));
    for i = 1:2:num_parents
        if rand < crossover_rate
            crossover_point = randi(size(selected_parents, 2));
            offspring(i, :) = [selected_parents(i, 1:crossover_point), selected_parents(i+1, crossover_point+1:end)];
            offspring(i+1, :) = [selected_parents(i+1, 1:crossover_point), selected_parents(i, crossover_point+1:end)];
        else
            offspring(i, :) = selected_parents(i, :);
            offspring(i+1, :) = selected_parents(i+1, :);
        end
    end
end

function mutated_offspring = mutation(offspring, mutation_rate, container_width, container_height)
    % Mutation
    mutated_offspring = offspring;
    [num_offspring, ~] = size(mutated_offspring);
    for i = 1:num_offspring
        if rand < mutation_rate
            num_squares = size(mutated_offspring, 2) / 2;
            idx = randi(num_squares);
            mutated_offspring(i, (idx-1)*2+1) = randi([1, container_width]);
            mutated_offspring(i, (idx-1)*2+2) = randi([1, container_height]);
        end
    end    
end

function mutated_population = apply_lkh(population, square_sizes, container_width, container_height, iterations)
    % Apply Lin-Kernighan Heuristic to each individual in the population
    num_individuals = size(population, 1);
    mutated_population = population;
    parfor i = 1:num_individuals
        solution = population(i, :);
        for j = 1:iterations
            new_solution = apply_lkh_once(solution, square_sizes, container_width, container_height);
            if calculate_fitness(new_solution, square_sizes, container_width, container_height) > calculate_fitness(solution, square_sizes, container_width, container_height)
                solution = new_solution;
            end
        end
        mutated_population(i, :) = solution;
    end    
end

function new_solution = apply_lkh_once(solution, square_sizes, container_width, container_height)
    % Apply Lin-Kernighan Heuristic once to improve a solution
    packed_squares = decode_solution(solution, square_sizes);
    tour = encode_tour(packed_squares, square_sizes, container_width, container_height);
    new_tour = LKH(tour);
    new_packed_squares = decode_tour(new_tour, square_sizes, container_width, container_height);
    new_solution = encode_solution(new_packed_squares);    
end

function tour = encode_tour(packed_squares, square_sizes, container_width, container_height)
    % Encode packed squares into a tour for LKH
    num_squares = size(packed_squares, 1);
    tour = zeros(num_squares+1, 2); % Include a dummy node for LKH
    for i = 1:num_squares
        tour(i, :) = packed_squares(i, :) + square_sizes(i)/2; % Tour node at the center of each square
    end
    tour(end, :) = [container_width/2, container_height/2]; % Dummy node at the center of the container
end

function packed_squares = decode_tour(tour, square_sizes, container_width, container_height)
    % Decode tour from LKH into packed squares
    num_squares = size(tour, 1) - 1;
    packed_squares = zeros(num_squares, 2);
    for i = 1:num_squares
        packed_squares(i, :) = tour(i, :) - square_sizes(i)/2; % Square position is at the center
    end    
end

function solution = encode_solution(packed_squares)
    % Encode packed squares into a solution
    num_squares = size(packed_squares, 1);
    solution = zeros(1, num_squares * 2);
    for i = 1:num_squares
        solution((i-1)*2+1:i*2) = packed_squares(i, :);
    end    
end

function packed_squares = decode_solution(solution, square_sizes)
    
end
