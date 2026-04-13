function [particles] = add_random_particles(particles, read_only_vars, public_vars)
%ADD_RANDOM_PARTICLES Summary of this function goes here
%   Detailed explanation goes here

p_random = max(0, 1 - public_vars.pf.w_fast/public_vars.pf.w_slow);
n_random = round(p_random * size(particles, 1));

if n_random == 0
    return;
end

idx = randperm(size(particles, 1), n_random);
map_width  = read_only_vars.map.limits(3);
map_height = read_only_vars.map.limits(4);

particles(idx, 1) = rand(n_random, 1) * map_width;
particles(idx, 2) = rand(n_random, 1) * map_height;
particles(idx, 3) = rand(n_random, 1) * 2*pi - pi;

end