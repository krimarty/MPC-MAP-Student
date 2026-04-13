% Cislo konfigurace
CONFIG = 3;

if CONFIG == 1
    % Pro mereni lidarovych dat
    map_name       = 'maps/indoor_1.txt';
    start_position = [5, 5, pi/2];
    MEAS_MODE      = 'lidar';
    public_vars.config.meas_mode = MEAS_MODE;

elseif CONFIG == 2
    % Pro mereni gnss dat
    map_name       = 'maps/outdoor_1.txt';
    start_position = [8, 8, pi/2];
    MEAS_MODE      = 'gnss';
    public_vars.config.meas_mode = MEAS_MODE;

elseif CONFIG == 3
    % Mereni nejistot pohybu
    map_name       = 'maps/indoor_1.txt';
    start_position = [1, 1, pi/2];
    MEAS_MODE      = 'motion';
    public_vars.config.meas_mode = MEAS_MODE;

elseif CONFIG == 4
    % Custom mapa
    map_name       = 'maps/custom_1.txt';
    start_position = [5, 10, pi/2];

elseif CONFIG == 5
    map_name       = 'maps/indoor_1.txt';
    start_position = [1, 1, pi/2];
end

% =========================================================

clear CONFIG MEAS_MODE;
