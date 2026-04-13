clc
clear
close all

% Week 2, task 4

% Load saved data
lidar = load('algorithms/uncertainty/lidar_data.mat');
gnss  = load('algorithms/uncertainty/gnss_data.mat');

% LiDAR - all channels
lidar_sigma = std(lidar.lidar_history);
fprintf('\nLiDAR Standard Deviations:\n');
fprintf('%-12s %10s\n', 'Channel', 'Std (m)');
fprintf('%s\n', repmat('-', 1, 24));
for i = 1:8
    fprintf('%-12s %10.4f\n', ['Channel ' num2str(i)], lidar_sigma(i));
end
fprintf('\n');

% GNSS - all axes
gnss_sigma = std(gnss.gnss_history);
fprintf('GNSS Standard Deviations:\n');
fprintf('%-12s %10s\n', 'Axis', 'Std (m)');
fprintf('%s\n', repmat('-', 1, 24));
fprintf('%-12s %10.4f\n', 'x', gnss_sigma(1));
fprintf('%-12s %10.4f\n', 'y', gnss_sigma(2));
fprintf('\n');

% LiDAR CH1
data_lidar = lidar.lidar_history(:, 1);
sig_lidar  = std(data_lidar);
data_lidar = sort(data_lidar - mean(data_lidar));
pdf_lidar  = norm_pdf(data_lidar, 0, sig_lidar);

% GNSS x
data_gnss = gnss.gnss_history(:, 1);
sig_gnss  = std(data_gnss);
data_gnss  = sort(data_gnss  - mean(data_gnss));
pdf_gnss  = norm_pdf(data_gnss, 0, sig_gnss);

% Restore original .mat files (history only)
lidar_history = lidar.lidar_history;
save('algorithms/uncertainty/lidar_data.mat', 'lidar_history');

gnss_history = gnss.gnss_history;
save('algorithms/uncertainty/gnss_data.mat', 'gnss_history');

% Save sigma values to separate files
save('algorithms/uncertainty/lidar_sigma.mat', 'lidar_sigma');
save('algorithms/uncertainty/gnss_sigma.mat', 'gnss_sigma');

fprintf('Sigma values saved to lidar_sigma.mat and gnss_sigma.mat\n');

% Plot
figure;
plot(data_lidar, pdf_lidar, 'LineWidth', 2);
hold on;
plot(data_gnss, pdf_gnss, 'LineWidth', 2);
title('Sensor noise PDF', 'FontSize', 15);
xlabel('error (m)', 'FontSize', 15);
ylabel('f(x)', 'FontSize', 15);
legend('LiDAR CH1', 'GNSS x', 'FontSize', 13);
grid on;