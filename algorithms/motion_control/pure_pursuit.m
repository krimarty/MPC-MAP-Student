function [v, w] = pure_pursuit(target, robotPose, read_only_vars, L)
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

w_max = 2 * read_only_vars.agent_drive.max_vel / read_only_vars.agent_drive.interwheel_dist;
R_min = read_only_vars.agent_drive.max_vel / w_max;

if abs(R) >= R_min
    v = read_only_vars.agent_drive.max_vel;
    w = v / R;
else
    w = w_max * sign(R);
    v = R_min * w_max;
end

end

