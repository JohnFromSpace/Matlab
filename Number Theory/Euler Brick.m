function euler_bricks = euler_brick()
    n = 100;
    euler_bricks = [];
    
    % Precompute all possible values of d
    d_values = round(sqrt((1:n).^2 + (1:n).^2 + (1:n).^2));
    
    % Calculate upper bound for loops based on symmetry
    upper_bound = ceil(sqrt(3 * n^2 / 2));
    
    for a = 1:upper_bound
        for b = a:upper_bound
            for c = b:upper_bound
                d = d_values(a) + d_values(b) + d_values(c) - a - b - c;
                if d > n
                    break; % Break if d exceeds the limit
                end
                
                e = d + a - c;
                f = d + b - c;
                
                % Check if e and f are within valid range and satisfy Euler brick conditions
                if e > 0 && f > 0 && e <= n && f <= n && a+b+c == d+e && d >= c
                    euler_bricks = [euler_bricks; [a, b, c, d, e, f]];
                end
            end
        end
    end    
end
