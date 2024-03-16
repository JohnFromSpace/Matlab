function perfectNumbers(limit)
    if limit < 2
        error('Limit must be greater than or equal to 2.');
    end
    
    fprintf('Perfect numbers up to %d:\n', limit);
    for n = 2:limit
        if isPerfect(n)
            fprintf('%d\n', n);
        end
    end    
end

function result = isPerfect(num)
    % Compute factors up to square root of num
    factors = [1, find(mod(num, 2:sqrt(num)) == 0)];
    
    % Adjust factor sum for perfect squares
    if sqrt(num) == floor(sqrt(num))
        factor_sum = sum(factors) - sqrt(num);
    else
        factor_sum = sum(factors);
    end
    
    % Check if sum of factors is equal to the number itself
    result = (factor_sum == num);    
end
