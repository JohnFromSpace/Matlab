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
end    
