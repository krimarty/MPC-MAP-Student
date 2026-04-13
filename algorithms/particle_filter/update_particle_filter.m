function [public_vars] = update_particle_filter(read_only_vars, public_vars)
%UPDATE_PARTICLE_FILTER Summary of this function goes here

particles = public_vars.particles;

% I. Prediction
for i=1:size(particles, 1)
    particles(i,:) = predict_pose(particles(i,:), public_vars.motion_vector, read_only_vars);
end

% II. Correction
measurements = zeros(size(particles,1), length(read_only_vars.lidar_config));
for i=1:size(particles, 1)
    measurements(i,:) = compute_lidar_measurement(read_only_vars.map, particles(i,:), read_only_vars.lidar_config);
end
[weights, public_vars] = weight_particles(measurements, read_only_vars.lidar_distances, public_vars);


warmup_steps = 10;

% Estimate pose
if read_only_vars.counter > warmup_steps
    public_vars = pose_estimation_pf(particles, weights, public_vars);
end

% III. Resampling
if read_only_vars.counter > warmup_steps && mod(read_only_vars.counter, 4) == 0

    particles = resample_particles(particles, weights);
    particles = add_random_particles(particles, read_only_vars, public_vars);

end

public_vars.particles = particles;

end

