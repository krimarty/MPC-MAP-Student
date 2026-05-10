function [estimated_pose] = estimate_pose(public_vars)
%ESTIMATE_POSE Summary of this function goes here

% Week 4
if (public_vars.pf_enabled == 1)
    estimated_pose = public_vars.estimated_pose_pf;
else
    estimated_pose = public_vars.mu';
end

end

