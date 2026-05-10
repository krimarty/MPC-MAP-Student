function [p_x, p_y, p_theta] = get_GNSSd_particles(read_only_vars)
% Generuje particles rovnomerne rozlozene across vsechny GNSS denied zony

N_zones = size(read_only_vars.map.gnss_denied, 1);
particles_per_zone = floor(read_only_vars.max_particles / N_zones);

p_x = [];
p_y = [];
p_theta = [];

for i = 1:N_zones
    % Vytáhni souřadnice zóny
    zone = read_only_vars.map.gnss_denied(i, :);
    x_coords = zone(1:2:end);
    y_coords = zone(2:2:end);

    % Bounding box
    x_min = min(x_coords);
    x_max = max(x_coords);
    y_min = min(y_coords);
    y_max = max(y_coords);

    % Rejection sampling
    x = zeros(particles_per_zone, 1);
    y = zeros(particles_per_zone, 1);
    count = 0;

    while count < particles_per_zone
        x_candidate = rand() * (x_max - x_min) + x_min;
        y_candidate = rand() * (y_max - y_min) + y_min;

        if inpolygon(x_candidate, y_candidate, x_coords, y_coords)
            count = count + 1;
            x(count) = x_candidate;
            y(count) = y_candidate;
        end
    end

    theta = rand(particles_per_zone, 1) * 2*pi - pi;

    p_x     = [p_x;     x];
    p_y     = [p_y;     y];
    p_theta = [p_theta; theta];
end
end