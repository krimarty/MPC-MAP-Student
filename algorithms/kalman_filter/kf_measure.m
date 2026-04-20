function [new_mu, new_sigma] = kf_measure(mu, sigma, z, kf)
%KF_MEASURE Summary of this function goes here

K =  sigma * kf.C' / ( kf.C * sigma * kf.C' + kf.Q );

new_mu = mu + K * (z - kf.C * mu);
new_mu(3) = mod(new_mu(3) + pi, 2*pi) - pi;

I = eye(size(sigma));
new_sigma = (I - K * kf.C) * sigma;

end
