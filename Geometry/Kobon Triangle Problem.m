function [x3, y3, success] = kobonTriangle(x1, y1, side1, x2, y2, varargin)
    % Kobon Triangle Problem Solver
    % Given two vertices (x1, y1) and (x2, y2) of a triangle, and either:
    %   1. Two sides and an angle between them, or
    %   2. Two sides and an included angle
    % This function calculates the coordinates (x3, y3) of the third vertex.
    %
    % Input:
    %   - x1, y1: Coordinates of the first vertex
    %   - side1: Length of the side opposite the first vertex
    %   - x2, y2: Coordinates of the second vertex
    %   - varargin: Angle in radians or degrees (if specified)
    %               OR side2 (length of the side opposite the second vertex)
    %               AND angle: 'angle' or 'included angle' (optional)
    %
    % Output:
    %   - x3, y3: Coordinates of the third vertex
    %   - success: Boolean flag indicating whether the computation was successful

    % Default values
    angleMode = 'radians'; % default angle mode (radians)
    visualize = false;     % default visualization flag

    % Parse optional arguments
    if ~isempty(varargin)
        for i = 1:numel(varargin)
            if ischar(varargin{i}) && strcmpi(varargin{i}, 'angle') || strcmpi(varargin{i}, 'included angle')
                angleMode = 'angle';
            elseif ischar(varargin{i}) && strcmpi(varargin{i}, 'degrees')
                angleMode = 'degrees';
            elseif isnumeric(varargin{i}) && numel(varargin{i}) == 1
                side2 = varargin{i};
            elseif isnumeric(varargin{i}) && numel(varargin{i}) == 2
                angle = varargin{i};
            elseif islogical(varargin{i}) && numel(varargin{i}) == 1
                visualize = varargin{i};
            else
                error('Invalid input arguments.');
            end
        end
    end

    % Validate inputs
    validateattributes(x1, {'numeric'}, {'scalar','finite'});
    validateattributes(y1, {'numeric'}, {'scalar','finite'});
    validateattributes(side1, {'numeric'}, {'scalar','positive','finite'});
    validateattributes(x2, {'numeric'}, {'scalar','finite'});
    validateattributes(y2, {'numeric'}, {'scalar','finite'});
    if exist('side2', 'var')
        validateattributes(side2, {'numeric'}, {'scalar','positive','finite'});
    elseif exist('angle', 'var')
        validateattributes(angle, {'numeric'}, {'scalar','finite'});
    else
        error('Insufficient input arguments.');
    end

    % Calculate the distance between the two given vertices
    d = hypot(x2 - x1, y2 - y1);

    % Check if the given sides are longer than the distance between the points
    if side1 >= d || (exist('side2', 'var') && side2 >= d)
        error('Side lengths are too long.');
    end

    % Check if triangle inequality is satisfied
    if (exist('side2', 'var') && side1 + side2 <= d) || (exist('angle', 'var') && angle >= pi)
        error('Triangle cannot be formed with the given inputs.');
    end

    % Calculate the direction from the first vertex to the second
    dx = (x2 - x1) / d;
    dy = (y2 - y1) / d;

    if strcmpi(angleMode, 'degrees')
        angle = deg2rad(angle);
    end

    % Calculate the coordinates of the unknown vertex
    if exist('angle', 'var')
        % Given two sides and an angle
        if exist('side2', 'var')
            % Cosine rule
            x3 = x1 + side1 * dx + side2 * cos(angle) * (-dy);
            y3 = y1 + side1 * dy + side2 * cos(angle) * dx;
        else
            % Sine rule
            x3 = x1 + side1 * dx + side1 * sin(angle) * dy;
            y3 = y1 + side1 * dy + side1 * sin(angle) * (-dx);
        end
    else
        % Given two sides and an included angle
        x3 = x1 + side1 * dx + side2 * cos(angle) * (-dy);
        y3 = y1 + side1 * dy + side2 * cos(angle) * dx;
    end

    % Set success flag
    success = true;

                    
end

