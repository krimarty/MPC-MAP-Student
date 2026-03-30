function analyze_lidar(public_vars)
%ANALYZE_LIDAR Calculates std of LiDAR data + plot histogram

% STD
lidar_sigma = std(public_vars.lidar_history);
% Print std table
fprintf('\nLiDAR Standard Deviations:\n');
fprintf('%-12s %10s\n', 'Channel', 'Std');
fprintf('%s\n', repmat('-', 1, 24));
for i = 1:8
    fprintf('%-12s %10.4f\n', ['Channel ' num2str(i)], lidar_sigma(i));
end
fprintf('\n');

% Histogram
figure;
for i = 1:8
    subplot(2,4,i);
    histogram(public_vars.lidar_history(:,i));
    title(['LiDAR channel ' num2str(i)], 'FontSize', 15);
    xlabel('distance (m)', 'FontSize', 15);
    ylabel('N (-)', 'FontSize', 15);
end

% Save data
lidar_history = public_vars.lidar_history;
save('algorithms/uncertainty/lidar_data.mat', 'lidar_history');
fprintf('Data saved to lidar_data.mat\n');

% Cov matrix
lidar_covariance = cov(public_vars.lidar_history)
lidar_variance = lidar_sigma.^2

end
