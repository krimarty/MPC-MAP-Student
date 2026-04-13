function [new_pose] = predict_pose(old_pose, motion_vector, read_only_vars)
%PREDICT_POSE Summary of this function goes here

% Alfy, parametry, ktere vystihuji pohyb robota
a1 = 1.5;
a2 = 1.5;
a3 = 1.5;
a4 = 1.5;
a5 = 1.5;
a6 = 1.5;

vel  = motion_vector(1);
omeg = motion_vector(2);

% Zasumele rychlosti 
v_hat = vel + my_randn(a1 * abs(vel) + a2 * abs(omeg));
w_hat = omeg + my_randn(a3 * abs(vel) + a4 * abs(omeg));
gamma_hat = my_randn(a5 * abs(vel) + a6 * abs(omeg));

dt = read_only_vars.sampling_period;
x  = old_pose(1);
y  = old_pose(2);
fi = old_pose(3);

% Vypocet nove pozy, osetrenim w = 0, tj. nekonecny radius
if abs(w_hat) < 1e-6
    x_new  = x + v_hat * cos(fi) * dt;
    y_new  = y + v_hat * sin(fi) * dt;
    fi_new = fi + gamma_hat * dt;
else
    r = v_hat / w_hat;
    x_new  = x - r*sin(fi) + r*sin(fi + w_hat*dt);
    y_new  = y + r*cos(fi) - r*cos(fi + w_hat*dt);
    fi_new = fi + w_hat*dt + gamma_hat*dt;
end

% Kontrola, aby se particles nedostali mimo mapu map_width  = read_only_vars.map.limits(3);
x_new = max(0, min(read_only_vars.map.limits(3),  x_new));
y_new = max(0, min(read_only_vars.map.limits(4), y_new));

new_pose = [x_new y_new fi_new];

end


