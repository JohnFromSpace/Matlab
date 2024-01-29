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
end    
