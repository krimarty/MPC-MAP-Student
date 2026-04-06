function [vr, vl] = kinematics(v, w, read_only_vars)
%KINEMATICK Summary of this function goes here
%   Detailed explanation goes here

vr = ((2 * v) + (w * read_only_vars.agent_drive.interwheel_dist)) / 2;
vl = ((2 * v) - (w * read_only_vars.agent_drive.interwheel_dist)) / 2;

end

