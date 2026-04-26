function [estimated_pose] = estimate_pose(public_vars, read_only_vars)
%ESTIMATE_POSE Summary of this function goes here

% Week 4
%estimated_pose = public_vars.estimated_pose_pf;
%estimated_pose = public_vars.mu';
estimated_pose = read_only_vars.mocap_pose;

end

