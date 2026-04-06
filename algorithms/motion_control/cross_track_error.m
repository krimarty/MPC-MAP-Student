function [XTE] = cross_track_error(path, robotPos)
%CROSS_TRACK_ERROR Summary of this function goes here
%   Detailed explanation goes here

n_waypoints = size(path, 1);

% 1) Choosing right segment + 2) Calculate nearest point
best_dist = inf;
best_Wp   = path(1, :);
best_d    = path(2, :) - path(1, :);
best_v    = robotPos - path(1, :);

for i = 1:n_waypoints-1

    Wx = path(i, :);   %[x,y]
    Wy = path(i+1, :); %[x,y]

    d = Wy - Wx;
    v = robotPos - Wx;
    t = (v(1)*d(1) + v(2)*d(2)) / (d(1)*d(1) + d(2)*d(2));
    t = max(0, min(1, t));

    % Nearest point
    Wp_i = Wx + d * t;
    dist = norm(robotPos - Wp_i);

    if dist < best_dist
        best_dist = dist;
        best_Wp   = Wp_i;
        best_d    = d;
        best_v    = v;
    end
end

% 3) XTE
XTE = norm(robotPos - best_Wp);

% Sign (cross product: d x v)
sign_xte = best_d(1) * best_v(2) - best_d(2) * best_v(1);
if sign_xte < 0
    XTE = -XTE;
end

end

