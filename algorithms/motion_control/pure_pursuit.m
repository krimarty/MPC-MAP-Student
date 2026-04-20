function [v, w] = pure_pursuit(target, robotPose, read_only_vars, L, uncertainty)
%PURE_PERSUIT Summary of this function goes here
%   Detailed explanation goes here

% 1) From map frame to robot frame
H_trans_x = [1  0  0  -robotPose(1);
             0  1  0   0;
             0  0  1   0;
             0  0  0   1          ];

H_trans_y = [1  0  0   0
             0  1  0   -robotPose(2);
             0  0  1   0;
             0  0  0   1          ];

theta = robotPose(3);
H_rot_z = [ cos(theta)  sin(theta)  0  0;
           -sin(theta)  cos(theta)  0  0;
           0           0           1  0;
           0           0           0  1];

G_map   = [target(1); target(2); 0; 1];
G_robot = H_rot_z * H_trans_x * H_trans_y * G_map;

% Pure pursuit
R = L^2/(2*G_robot(2));

% Week 5, adjust speed
k_v = 1;
v_min = 0.1; % minimální rychlost
v_max_lim = 0.8; % max 1
v_max = v_min + (v_max_lim - v_min) * exp(-k_v * uncertainty);

w_max = 2 * v_max / read_only_vars.agent_drive.interwheel_dist;
R_min = v_max / w_max;

if abs(R) >= R_min
    v = v_max;
    w = v / R;
else
    w = w_max * sign(R);
    v = R_min * w_max;
end

end

