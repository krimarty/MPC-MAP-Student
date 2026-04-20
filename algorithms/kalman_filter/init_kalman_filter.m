function [public_vars] = init_kalman_filter(read_only_vars, public_vars)
%INIT_KALMAN_FILTER Summary of this function goes here

public_vars.kf.C = [1 0 0;
                    0 1 0];

public_vars.kf.R = diag([0.0008, 0.0008, 0.00007]);  % Noisy but smaller XTE
%public_vars.kf.R = diag([0.00038, 0.00038, 0.00005]); % Smooth but bigger XTE

public_vars.kf.Q = public_vars.gnss_covariance;

public_vars.mu = [public_vars.init_pos(1); public_vars.init_pos(2); 0];

public_vars.sigma = [public_vars.gnss_covariance(1,1), 0, 0;
                     0, public_vars.gnss_covariance(2,2), 0;
                     0, 0, pi^2];

end
