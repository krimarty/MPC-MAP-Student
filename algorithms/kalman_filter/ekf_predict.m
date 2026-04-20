function [new_mu, new_sigma] = ekf_predict(mu, sigma, u, kf, sampling_period)
%EKF_PREDICT Summary of this function goes here

% State prediction
new_mu = [mu(1) + cos(mu(3))*u(1)*sampling_period;
          mu(2) + sin(mu(3))*u(1)*sampling_period;
          mod(mu(3) + u(2)*sampling_period + pi, 2*pi) - pi];

% Jacobian G
G = [1, 0, -sin(mu(3))*u(1)*sampling_period;
     0, 1,  cos(mu(3))*u(1)*sampling_period;
     0, 0,  1];

% Covariance prediction
new_sigma = G * sigma * G' + kf.R;

end
