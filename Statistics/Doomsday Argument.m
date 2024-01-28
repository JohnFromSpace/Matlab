function doomsdayArgument() 
    % Display information about the Doomsday Argument
    disp('Welcome to the Doomsday Argument Estimator!');
    disp('The Doomsday Argument suggests that your birth rank among all humans who will ever live is likely to be around the median.');
    disp('Enter your birth rank and estimate the total number of humans who will ever live to calculate the probability of the world ending soon.');
    
    % Allow the user to run the program multiple times
    while true
        try
            % Prompt the user for their birth rank
            userBirthRank = input('Enter your birth rank among all humans who will ever live: ');

            % Prompt the user for the total estimated human population
            totalHumansEstimate = input('Enter the estimated total number of humans who will ever live: ');

            % Validate inputs
            if ~isnumeric(userBirthRank) || ~isnumeric(totalHumansEstimate) || userBirthRank <= 0 || totalHumansEstimate <= 0
                error('Please enter valid positive numerical values for birth rank and total human population estimate.');
            end

             % Perform sensitivity analysis
            sensitivityAnalysis = input('Do you want to perform sensitivity analysis by varying the total estimated human population? (yes/no): ', 's');
            if strcmpi(sensitivityAnalysis, 'yes')
                performSensitivityAnalysis(userBirthRank);
            else
                % Symbolic math for the integration
                syms x;
                doomsdayFunction = x / totalHumansEstimate;
                probabilityOfDoomsday = double(int(doomsdayFunction, x, 1, userBirthRank));

                % Calculate confidence intervals (e.g., 95% confidence)
                confidenceLevel = 0.95;
                alpha = 1 - confidenceLevel;
                z = norminv(1 - alpha / 2);
                standardError = sqrt(probabilityOfDoomsday * (1 - probabilityOfDoomsday) / totalHumansEstimate);
                confidenceInterval = [probabilityOfDoomsday - z * standardError, probabilityOfDoomsday + z * standardError];

                % Display the result
                fprintf('Estimated probability of the world ending soon: %.2f%%\n', probabilityOfDoomsday * 100);
                fprintf('Confidence interval ( %.0f%% ): [%.2f%%, %.2f%%]\n', confidenceLevel * 100, confidenceInterval * 100);

                % Display actual birth rank for the estimated probability
                actualBirthRank = round(totalHumansEstimate * probabilityOfDoomsday);
                fprintf('Your estimated probability corresponds to around birth rank %d\n', actualBirthRank);

                % Option to run Monte Carlo simulation
                runSimulation = input('Do you want to run a Monte Carlo simulation to visualize the probability distribution? (yes/no): ', 's');

                if strcmpi(runSimulation, 'yes')
                    % Prompt the user for the number of simulation runs
                    numSimulations = input('Enter the number of simulation runs: ');

                    % Prompt the user for the histogram range
                    histogramRange = input('Enter the histogram range (e.g., [0 1]): ');

                    % Run Monte Carlo simulation
                    [simulatedProbabilities, actualSimulationResult] = monteCarloSimulation(userBirthRank, totalHumansEstimate, numSimulations, histogramRange);

                    % Display actual birth rank for the simulated probability
                    fprintf('In the Monte Carlo simulation, your estimated probability corresponds to around birth rank %d\n', actualSimulationResult);
                end

                % Option to export results to a text file
                exportResults = input('Do you want to export the results to a text file? (yes/no): ', 's');
                if strcmpi(exportResults, 'yes')
                    exportFileName = input('Enter the export file name (e.g., doomsday_results): ', 's');
                    exportResultsToFile(exportFileName, userBirthRank, totalHumansEstimate, probabilityOfDoomsday, confidenceInterval, actualBirthRank, numSimulations, simulatedProbabilities, actualSimulationResult);
                    disp(['Results exported to ', exportFileName, '.txt']);
                end
            end

            % Ask the user if they want to run the program again
            runAgain = input('Do you want to run the program again? (yes/no): ', 's');
            if ~strcmpi(runAgain, 'yes')
                break;
            end 
        catch exception
            % Display error message and allow the user to try again
            disp(exception.message);
        end
    end
    
    disp('Thank you for using the Doomsday Argument Estimator!');
end

function performSensitivityAnalysis(userBirthRank)
    % Perform sensitivity analysis by varying the total estimated human population

    % Prompt the user for sensitivity analysis parameters
    lowerLimit = input('Enter the lower limit of total estimated human population: ');
    upperLimit = input('Enter the upper limit of total estimated human population: ');
    stepSize = input('Enter the step size for sensitivity analysis: ');

    % Initialize arrays to store results
    totalHumansEstimates = lowerLimit:stepSize:upperLimit;
    probabilities = zeros(size(totalHumansEstimates));
    confidenceIntervals = zeros(length(totalHumansEstimates), 2);

    % Perform sensitivity analysis
    for i = 1:length(totalHumansEstimates)
        % Symbolic math for the integration
        syms x;
        doomsdayFunction = x / totalHumansEstimates(i);
        probabilities(i) = double(int(doomsdayFunction, x, 1, userBirthRank));

        % Calculate confidence intervals (e.g., 95% confidence)
        alpha = 1 - 0.95;
        z = norminv(1 - alpha / 2);
        standardError = sqrt(probabilities(i) * (1 - probabilities(i)) / totalHumansEstimates(i));
        confidenceIntervals(i, :) = [probabilities(i) - z * standardError, probabilities(i) + z * standardError];
    end

    % Option to visualize multiple sensitivity analyses on a single plot
    visualizeMultipleAnalyses = input('Do you want to visualize multiple sensitivity analyses on a single plot? (yes/no): ', 's');

    if strcmpi(visualizeMultipleAnalyses, 'yes')
        plotMultipleSensitivityAnalyses(totalHumansEstimates, probabilities, confidenceIntervals);
    else
        % Plot sensitivity analysis results
        plotSensitivityAnalysis(totalHumansEstimates, probabilities, confidenceIntervals);
    end
end

function plotSensitivityAnalysis(totalHumansEstimates, probabilities, confidenceIntervals)
    % Plot sensitivity analysis results

    % Prompt the user for customization options
    customPlot = input('Do you want to customize the sensitivity analysis plot? (yes/no): ', 's');

    if strcmpi(customPlot, 'yes')
        % Prompt the user for y-axis range
        yRange = input('Enter the y-axis range (e.g., [0 1]): ');

        % Prompt the user for confidence interval display
        displayConfidenceInterval = input('Do you want to display confidence intervals on the plot? (yes/no): ', 's');
    else
        yRange = [];
        displayConfidenceInterval = 'no';
    end

    % Plot sensitivity analysis results
    figure;
    plot(totalHumansEstimates, probabilities, 'LineWidth', 2);
    hold on;

    % Plot confidence intervals if requested
    if strcmpi(displayConfidenceInterval, 'yes')
        fill([totalHumansEstimates, fliplr(totalHumansEstimates)], [confidenceIntervals(:, 1)', fliplr(confidenceIntervals(:, 2)')], [0.8 0.8 0.8], 'EdgeColor', 'none');
    end

    xlabel('Total Estimated Human Population');
    ylabel('Probability of World Ending Soon');
    title('Sensitivity Analysis of Doomsday Argument');
    grid on;

    % Customize the plot
    if ~isempty(yRange)
        ylim(yRange);
    end

    legend('Probability', 'Confidence Intervals', 'Location', 'Best');
    hold off;
end

function plotMultipleSensitivityAnalyses(totalHumansEstimates, probabilities, confidenceIntervals)
    % Visualize multiple sensitivity analyses on a single plot

    % Prompt the user for customization options
    customPlot = input('Do you want to customize the multiple sensitivity analyses plot? (yes/no): ', 's');

    if strcmpi(customPlot, 'yes')
        % Prompt the user for y-axis range
        yRange = input('Enter the y-axis range (e.g., [0 1]): ');

        % Prompt the user for confidence interval display
        displayConfidenceInterval = input('Do you want to display confidence intervals on the plot? (yes/no): ', 's');
    else
        yRange = [];
        displayConfidenceInterval = 'no';
    end

    % Plot multiple sensitivity analyses
    figure;
    for i = 1:size(probabilities, 1)
        plot(totalHumansEstimates, probabilities(i, :), 'LineWidth', 2, 'DisplayName', ['Analysis ' num2str(i)]);
        hold on;

        % Plot confidence intervals if requested
        if strcmpi(displayConfidenceInterval, 'yes')
            fill([totalHumansEstimates, fliplr(totalHumansEstimates)], [confidenceIntervals(i, :, 1), fliplr(confidenceIntervals(i, :, 2))], [0.8 0.8 0.8], 'EdgeColor', 'none', 'FaceAlpha', 0.5);
        end
    end
end
