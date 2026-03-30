function [public_vars] = collect_measurements(read_only_vars, public_vars)
%COLLECT_MEASUREMENTS Collects LiDAR data

if (~isfield(public_vars, 'lidar_history'))
    public_vars.lidar_history = [];
end
public_vars.lidar_history = [public_vars.lidar_history; read_only_vars.lidar_distances];

end
