function [public_vars] = pose_estimation_pf(particles, weights, public_vars)
%POSE_ESTIMATION Summary of this function goes here
%   Detailed explanation goes here

public_vars.estimated_pose_pf(1) = sum(weights .* particles(:,1));
public_vars.estimated_pose_pf(2) = sum(weights .* particles(:,2));

sin_avg = sum(weights .* sin(particles(:,3)));
cos_avg = sum(weights .* cos(particles(:,3)));
public_vars.estimated_pose_pf(3) = atan2(sin_avg, cos_avg);

% Not a robust solution
% [~, idx] = max(weights);
% public_vars.estimated_pose_pf = particles(idx, :);

end

