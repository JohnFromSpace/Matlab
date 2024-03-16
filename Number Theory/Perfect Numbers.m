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
