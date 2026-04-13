function [public_vars] = init_particle_filter(read_only_vars, public_vars)
%INIT_PARTICLE_FILTER Summary of this function goes here

N = read_only_vars.max_particles;

map_width = read_only_vars.map.limits(3);
map_height = read_only_vars.map.limits(4);

x = rand(N,1) * map_width;
y = rand(N,1) * map_height;
theta = rand(N,1) * 2*pi - pi;

public_vars.particles = [x, y, theta];

% Week 4, AMCL
public_vars.pf.w_slow = 0;
public_vars.pf.w_fast = 0;

public_vars.estimated_pose_pf = [NaN, NaN, NaN];
end

