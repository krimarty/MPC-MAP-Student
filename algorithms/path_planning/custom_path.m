function [path] = custom_path(read_only_vars, public_vars)
%CUSTOM_PATH Summary of this function goes here

% CONFIG - choose the path
path_type = 'sine';   % 'linear', 'sine', 'arc'

n = 100;
x = linspace(5, 40, n)';

switch path_type
    case 'linear'
        path = [5 10;
                40 10];

    case 'sine'
        y = 10 + 7.5 * sin(-2*pi*x / 10);
        path = [x, y];

    case 'arc'
        y = -5.14 + sqrt(23.14^2 - (x - 22.5).^2);
        path = [x, y];

    otherwise
        error('custom_path: wrong path format: %s', path_type);
end

end

