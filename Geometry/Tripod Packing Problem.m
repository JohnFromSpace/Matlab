function [best_solution, best_fitness] = pack_tripods(container_dimensions, tripods, population_size, max_generations)
    % Validate input dimensions and tripods
    validateattributes(container_dimensions, {'numeric'}, {'vector', 'positive', 'numel', 2}, 'pack_tripods', 'container_dimensions');
    validateattributes(tripods, {'numeric'}, {'2d', 'positive'}, 'pack_tripods', 'tripods');
    
        
end
