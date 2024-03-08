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
    
        
end

