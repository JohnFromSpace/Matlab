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
    
        
end
