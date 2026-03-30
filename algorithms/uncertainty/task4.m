clc
clear
close all

% Week 2, task 4

% Load saved data
lidar = load('algorithms/uncertainty/lidar_data.mat');
gnss  = load('algorithms/uncertainty/gnss_data.mat');

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