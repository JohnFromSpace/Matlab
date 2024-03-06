function gaussian_moat(mu_x, mu_y, sigma, radius, resolution, save_plot)
    % Error handling for input validation
    if nargin < 4
        error('Insufficient number of input arguments.');
    end
    if sigma <= 0 || radius <= 0
        error('Standard deviation and radius must be positive.');
    end
    
    % Define limits for integration
    x_min = mu_x - 3*sigma;
    x_max = mu_x + 3*sigma;
    y_min = mu_y - 3*sigma;
    y_max = mu_y + 3*sigma;

    % Define the Gaussian function
    gaussian = @(x, y) 1/(2*pi*sigma^2) * exp(-( (x-mu_x).^2 + (y-mu_y).^2) / (2*sigma^2));

    % Define the function to integrate
    fun = @(x, y) gaussian(x, y);

    % Perform the double integration over the circular region
    integral_value = integral2(fun, x_min, x_max, y_min, y_max);

    disp(['Integral of the Gaussian function over the circular region with radius ', num2str(radius), ' is ', num2str(integral_value)]);

    % Calculate the percentage of Gaussian distribution within the circular region
    total_integral = integral2(fun, -Inf, Inf, -Inf, Inf);
    percentage_within_circle = integral_value / total_integral * 100;

    disp(['Percentage of Gaussian distribution within the circular region: ', num2str(percentage_within_circle), '%']);

    % Visualization
    % Generate grid for plotting
    [X, Y] = meshgrid(linspace(x_min, x_max, resolution), linspace(y_min, y_max, resolution));
    Z = gaussian(X, Y);

    % Plot Gaussian function
    figure;
    surf(X, Y, Z, 'EdgeColor', 'none');
    title('Gaussian Function');
    xlabel('x');
    ylabel('y');
    zlabel('f(x, y)');
    colorbar;

    hold on;

    % Plot circular region as filled contour
    theta = linspace(0, 2*pi, 100);
    circle_x = mu_x + radius*cos(theta);
    circle_y = mu_y + radius*sin(theta);
    contour(X, Y, Z, 'LevelList', [max(max(Z))*0.1, max(max(Z))*0.5], 'LineColor', 'r', 'LineWidth', 2);
    fill(circle_x, circle_y, 'r', 'FaceAlpha', 0.5);
    legend('Gaussian Function', 'Circular Region');

    hold off;

    % Save plot as image file if requested
    if nargin > 5 && save_plot
        filename = ['gaussian_moat_mu_', num2str(mu_x), '_', num2str(mu_y), '_sigma_', num2str(sigma), '_radius_', num2str(radius), '.png'];
        saveas(gcf, filename);
        disp(['Plot saved as ', filename]);
    end    
end
