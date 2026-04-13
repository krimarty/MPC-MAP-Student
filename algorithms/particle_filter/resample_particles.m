function [new_particles] = resample_particles(particles, weights)
%RESAMPLE_PARTICLES Summary of this function goes here
% Reseni je dle Prob Robotics, low_variance_sampler

new_particles = zeros(size(particles));

M = length(particles);

% Vyberu nahodny krok 0 - M^-1
r = rand() / M;

c = weights(1);
i = 1;

for m = 1:M

    % Rovnomerne pokryti intervalu
    u = r + (m-1) / M;

    while u > c
        i = i + 1;
        c = c + weights(i);
    end

    new_particles(m,:) = particles(i,:);
    
end

end

