function EuclidNumbers(varargin)
    % Function to generate Euclid numbers within a range of prime numbers
    % or up to a specified limit

    % Parse input arguments
    switch nargin
        case 0
            error('Not enough input arguments. Please specify the range of prime numbers or a limit.');
        case 1
            if isscalar(varargin{1}) && varargin{1} > 0 && floor(varargin{1}) == varargin{1}
                start_prime = 2;
                end_prime = varargin{1};
                display_option = 'list';
            else
                limit = varargin{1};
                start_prime = 2;
                end_prime = limit;
                display_option = 'list';
            end
        case 2
            start_prime = varargin{1};
            end_prime = varargin{2};
            display_option = 'list';
        case 3
            start_prime = varargin{1};
            end_prime = varargin{2};
            display_option = varargin{3};
        otherwise
            error('Too many input arguments.');
    end

    
end


