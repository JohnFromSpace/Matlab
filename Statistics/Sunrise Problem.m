function solarInfo = calculateSolarInfo(latitude, longitude, dateStr, timeZone)
    % Function to calculate sunrise, sunset, and moon-related information using Laplace's method and SAMPA

    % Add the path to the SAMPA library
    addpath('path_to_sampa_library');

    try
        % Check if latitude and longitude are within valid ranges
        if abs(latitude) > 90 || abs(longitude) > 180
            error('Invalid latitude or longitude. Latitude must be between -90 and 90, and longitude must be between -180 and 180.');
        end

        % Check if the date string is in the correct format
        try
            dateNum = datenum(dateStr);
        catch
            error('Invalid date format. Please use yyyy-mm-dd format.');
        end

        % Calculate day of the year
        dayOfYear = day(dateNum, 'dayofyear');

        % Laplace's method for solar calculations
        h = 360 * (dayOfYear - 81) / 365;
        delta = 23.45 * sind(h);

        % Calculate solar noon time
        solarNoon = 12:0.1:13; % Assume solar noon occurs between 12:00 and 13:00
        [~, solarAzimuth, solarElevation] = sampa(dateNum, latitude, longitude, solarNoon);

        % Find the time at which solar elevation is maximized (solar noon)
        [~, maxElevationIdx] = max(solarElevation);
        solarNoonTime = solarNoon(maxElevationIdx);

        % Convert solar noon time to the specified time zone
        solarNoonTime = solarNoonTime + hours(timeZone);

        % Calculate sunrise and sunset times
        sunriseTime = solarNoonTime - hours(0.5 * abs(h));
        sunsetTime = solarNoonTime + hours(0.5 * abs(h));

        % Calculate moonrise and moonset times
        [moonriseTime, moonsetTime] = moonrise_set(latitude, longitude, dateNum, timeZone);

        % Calculate moon position over time
        moonTimes = linspace(moonriseTime, moonsetTime, 100);
        [~, moonAzimuth, moonElevation] = sampa(moonTimes, latitude, longitude);

        % Store the results in a structure
        solarInfo.latitude = latitude;
        solarInfo.longitude = longitude;
        solarInfo.date = dateStr;
        solarInfo.timeZone = timeZone;
        solarInfo.sunriseTime = datestr(sunriseTime, 'HH:MM:SS');
        solarInfo.sunsetTime = datestr(sunsetTime, 'HH:MM:SS');
        solarInfo.daylightDuration = hours(sunsetTime - sunriseTime);
        solarInfo.solarNoon = datestr(solarNoonTime, 'HH:MM:SS');
        solarInfo.solarAzimuth = solarAzimuth(maxElevationIdx);
        solarInfo.solarElevation = solarElevation(maxElevationIdx);
        solarInfo.moonriseTime = datestr(moonriseTime, 'HH:MM:SS');
        solarInfo.moonsetTime = datestr(moonsetTime, 'HH:MM:SS');
        solarInfo.moonAzimuth = moonAzimuth;
        solarInfo.moonElevation = moonElevation;

    catch exception
        % Handle any errors during calculation
        fprintf('Error: %s\n', exception.message);
        fprintf('Make sure the SAMPA library is correctly installed and the location and date inputs are valid.\n');
    end
end    

% Function to calculate moonrise and moonset times
function [moonriseTime, moonsetTime] = moonrise_set(latitude, longitude, dateNum, timeZone)
    [moonriseTime, moonsetTime] = lunarTimes(latitude, longitude, dateNum, timeZone, 'riseSet');
end

% Main script

% Example location (San Francisco, CA)
latitude = 37.7749;
longitude = -122.4194;

% Example date range (start and end dates)
startDate = '2024-01-01';
endDate = '2024-12-31';

% Specify time zone (e.g., Pacific Time)
timeZone = -8; % Adjust this based on the location's time zone

% Generate a date array for the given range
dateRange = datetime(startDate):datetime(endDate);

% Initialize structure arrays to store results
results = [];

% Calculate solar information for each date
for i = 1:length(dateRange)
    solarInfo = calculateSolarInfo(latitude, longitude, datestr(dateRange(i), 'yyyy-mm-dd'), timeZone);
    
    % Append the result to the structure array
    results = [results; solarInfo];
end

% Display the results in a tabular format
disp('Solar and Lunar Information:');
disp('-------------------------------------------------------------------------------------------------------------------');
disp('  Latitude   |  Longitude  |    Date    | Time Zone | Sunrise Time | Sunset Time | Solar Noon | Duration of Daylight |');
disp('-------------------------------------------------------------------------------------------------------------------');
for i = 1:length(results)
    fprintf('  %10.4f | %10.4f | %s |   %+02d:00   | %s | %s | %s | %.2f hours |\n', ...
        results(i).latitude, results(i).longitude, results(i).date, ...
        results(i).timeZone, results(i).sunriseTime, results(i).sunsetTime, ...
        results(i).solarNoon, results(i).daylightDuration);
end
disp('-------------------------------------------------------------------------------------------------------------------');
disp('  Moonrise Time | Moonset Time | Moon Azimuth | Moon Elevation |');
disp('-------------------------------------------------------------------------------------------------------------------');
for i = 1:length(results)
    fprintf('    %s    |    %s    | %.2f degrees | %.2f degrees |\n', ...
        results(i).moonriseTime, results(i).moonsetTime, ...
        results(i).moonAzimuth, results(i).moonElevation);
end
disp('-------------------------------------------------------------------------------------------------------------------');

% Optionally, save results to a CSV file
saveToCSV = input('Do you want to save results to a CSV file? (yes/no): ', 's');
if strcmpi(saveToCSV, 'yes')
    % Validate user input for the file name
    validFileName = false;
    while ~validFileName
        filename = input('Enter the CSV file name (including .csv extension): ', 's');
        if ~isempty(filename) && isvarname(filename) && ~exist(filename, 'file')
            validFileName = true;
        else
            disp('Invalid file name. Please enter a valid, non-existing file name.');
        end
    end

    writetable(struct2table(results), filename);
    disp(['Results saved to ', filename]);
end

% Visualize the results using plots
figure;

% Plot 1: Duration of Daylight and Civil Twilight
subplot(3, 2, 1);
bar(datetime({results.date}, 'Format', 'yyyy-MM-dd'), [vertcat(results.daylightDuration), vertcat(results.civilTwilightDuration)], 'stacked');
title('Duration of Daylight and Civil Twilight');
xlabel('Date');
ylabel('Duration (hours)');
legend('Daylight', 'Civil Twilight');
datetick('x', 'mmm dd', 'keepticks');

% Plot 2: Solar Azimuth over Time
subplot(3, 2, 2);
plot(datetime({results.date}, 'Format', 'yyyy-MM-dd'), [vertcat(results.solarAzimuth)], '-o', 'MarkerSize', 8, 'Color', [0.8 0.2 0.2]);
title('Solar Azimuth over Time');
xlabel('Date');
ylabel('Solar Azimuth (degrees)');
datetick('x', 'mmm dd', 'keepticks');

% Plot 3: Solar Elevation over Time
subplot(3, 2, 3);
plot(datetime({results.date}, 'Format', 'yyyy-MM-dd'), [vertcat(results.solarElevation)], '-o', 'MarkerSize', 8, 'Color', [0.2 0.2 0.8]);
title('Solar Elevation over Time');
xlabel('Date');
ylabel('Solar Elevation (degrees)');
datetick('x', 'mmm dd', 'keepticks');

% Plot 4: Moonrise and Moonset Times
subplot(3, 2, 4);
yyaxis left;
plot(datetime({results.date}, 'Format', 'yyyy-MM-dd'), [vertcat(results.moonriseTime)], '-o', 'MarkerSize', 8, 'Color', [0.2 0.8 0.2]);
ylabel('Moonrise Time');
datetick('x', 'mmm dd', 'keepticks');
