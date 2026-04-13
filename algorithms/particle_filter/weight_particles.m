function [weights] = weight_particles(particle_measurements, lidar_distances, public_vars)
%WEIGHT_PARTICLES Summary of this function goes here

N = size(particle_measurements, 1);
n_ray = length(lidar_distances);
weights = ones(N,1) / N;

% Namerene sigmy z week 2
sigma = public_vars.lidar_sigma;

% Stredni hodnota = co nameril paprsek lidaru
mu = lidar_distances;

% Pro kazdou particle
for i = 1:N

    w = 1;
    valid_count = 0;

    % PDF, pro kazdy paprsek z particle vypocitam vysku 
    % Thrun kapitola 6.3.1
    % z_t^k ... vzdalenost particle, z_t^k* ... co nameril lidar, sigma ... z
    % kazeho paprsku vlastni
    % Plus se rovnou provede soucin vah
    for j = 1:n_ray

        % Osetreni proti inf hodnote, paprsek se preskoci a neovlivni vahy
        if isinf(particle_measurements(i,j)) || isinf(mu(j))
            continue
        end
        w = w * norm_pdf(particle_measurements(i,j), mu(j), sigma(j));
        valid_count = valid_count + 1;
    end

    if valid_count == 0
        w = 0;
    end

    weights(i) = w;

end

% Normalizace s osetrenim proti deleni 0
if sum(weights) == 0
    weights = ones(N, 1) / N;
else
    weights = weights / sum(weights);
end

end

% Valid count kontorluje zda se vaha alepson 1x pocitala, pokud by budou
% vsechny paprsky inf, byla by vaha 1, coz nedava smysl