function [public_vars] = plan_motion(read_only_vars, public_vars)
%PLAN_MOTION Summary of this function goes here

if (public_vars.kf_enabled)
    uncertainty = trace(public_vars.sigma);
else
    uncertainty = 0;
end

% CONFIG - choose the method
method   = 'pure_pursuit';   % 'xte', 'pure_pursuit'
L        = 0.5;                % lookahead distance (pure_pursuit)
k_v      = 2.0;                % xte, how much to slow down when turn

switch method
    case 'xte'
        XTE = cross_track_error(public_vars.path, public_vars.estimated_pose(1:2));
        [w, public_vars] = my_pid(XTE, public_vars, read_only_vars);
        v = read_only_vars.agent_drive.max_vel * max(0.3, 1 - k_v * abs(XTE));
        [vr, vl] = kinematics(v, -w, read_only_vars);

    case 'pure_pursuit'
        target = get_target(public_vars.path, public_vars.estimated_pose(1:2), L);
        [v, w] = pure_pursuit(target, public_vars.estimated_pose, read_only_vars, public_vars, L, uncertainty);
        [vr, vl] = kinematics(v, w, read_only_vars);

    otherwise
        error('plan_motion: wrong motion: %s', method);
end

% Safety collision function
if (read_only_vars.lidar_distances(1) < 0.5 || read_only_vars.lidar_distances(2) < 0.5 || read_only_vars.lidar_distances(8) < 0.5)
    if (read_only_vars.lidar_distances(2) < 0.4 || read_only_vars.lidar_distances(8) < 0.4) && ...
       read_only_vars.lidar_distances(2) < read_only_vars.lidar_distances(8)
        public_vars.motion_vector = [-0.2, 0.2];
    elseif (read_only_vars.lidar_distances(2) < 0.4 || read_only_vars.lidar_distances(8) < 0.4) && ...
           read_only_vars.lidar_distances(8) < read_only_vars.lidar_distances(2)
        public_vars.motion_vector = [0.2, -0.2];
    else
        public_vars.motion_vector = [-0.2, 0.2];
    end
else
    public_vars.motion_vector = [vr, vl];
end

end