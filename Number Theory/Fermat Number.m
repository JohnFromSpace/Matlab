function fermatNumbers(limit, filename)
    % Function to compute Fermat numbers up to a given limit and save/load them to/from a file
    
    if nargin < 1
        limit = 0; % Default to compute only F0 if no limit is provided
    end
    
    if nargin < 2
        filename = 'fermat_numbers.txt'; % Default filename
    end
    
    % Check if limit is a non-negative integer
    if ~isnumeric(limit) || limit < 0 || mod(limit, 1) ~= 0
        disp('Please enter a non-negative integer as the limit.');
        return;
    end
    
    fprintf('Computing Fermat numbers up to F%d:\n', limit);
    
    % Initialize array to store Fermat numbers
    fermat_numbers = zeros(1, limit + 1);
    
    % Load previously computed Fermat numbers from file if it exists
    if exist(filename, 'file') == 2
        loaded_data = load(filename, '-ascii');
        if length(loaded_data) == limit + 1
            fermat_numbers = loaded_data;
            fprintf('Fermat numbers loaded from %s\n', filename);
        else
            fprintf('The file %s exists, but it does not contain the required number of Fermat numbers.\n', filename);
        end
    end
    
    for n = find(fermat_numbers == 0)
        fermat = 2^(2^n) + 1; % Compute the nth Fermat number
        fermat_numbers(n) = fermat; % Store the result
        fprintf('F%d = %d\n', n, fermat); % Display the result
    end
    
    % Save Fermat numbers to file
    save(filename, 'fermat_numbers', '-ascii');
    fprintf('Fermat numbers saved to %s\n', filename);    
end

