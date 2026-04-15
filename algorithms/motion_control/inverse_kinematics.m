function [v, omega] = inverse_kinematics(vr, vl, read_only_vars)

d = read_only_vars.agent_drive.interwheel_dist;

v     = (vr + vl) / 2;
omega = (vr - vl) / d;

end