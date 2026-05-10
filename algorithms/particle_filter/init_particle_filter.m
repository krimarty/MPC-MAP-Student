function [public_vars] = init_particle_filter(read_only_vars, public_vars)
%INIT_PARTICLE_FILTER Summary of this function goes here

N = read_only_vars.max_particles;

if (public_vars.kf_enabled == 1)
    x = rand(N,1) + public_vars.estimated_pose(1) - 0.5;
    y = rand(N,1) + public_vars.estimated_pose(2) - 0.5;
    theta = public_vars.estimated_pose(3) + (rand(N,1) * pi - pi/2);

    public_vars.estimated_pose_pf = public_vars.estimated_pose;
else
    % map_width = read_only_vars.map.limits(3);
    % map_height = read_only_vars.map.limits(4);
    % x = rand(N,1) * map_width;
    % y = rand(N,1) * map_height;
    % theta = rand(N,1) * 2*pi - pi;
    [x, y, theta] = get_GNSSd_particles(read_only_vars);

    public_vars.estimated_pose_pf = [NaN, NaN, NaN];
end

public_vars.particles = [x, y, theta];

public_vars.pf.w_slow = 0;
public_vars.pf.w_fast = 0;

end

