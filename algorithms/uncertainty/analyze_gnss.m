function analyze_gnss(read_only_vars)
%ANALYZE_GNSS Calculates std of GNSS data + plot histogram

% STD
gnss_sigma = std(read_only_vars.gnss_history);
% Print std table
fprintf('\nGNSS Standard Deviations:\n');
fprintf('%-12s %10s\n', 'Axis', 'Std');
fprintf('%s\n', repmat('-', 1, 24));
fprintf('%-12s %10.4f\n', 'x', gnss_sigma(1));
fprintf('%-12s %10.4f\n', 'y', gnss_sigma(2));
fprintf('\n');

% Histogram
figure;
subplot(1,2,1); histogram(read_only_vars.gnss_history(:,1)); title('GNSS x', 'FontSize', 15); xlabel('x (m)', 'FontSize', 15); ylabel('N (-)', 'FontSize', 15);
subplot(1,2,2); histogram(read_only_vars.gnss_history(:,2)); title('GNSS y', 'FontSize', 15); xlabel('y (m)', 'FontSize', 15); ylabel('N (-)', 'FontSize', 15);

% Save data
gnss_history = read_only_vars.gnss_history;
save('algorithms/uncertainty/gnss_data.mat', 'gnss_history');
fprintf('Data saved to gnss_data.mat\n');

% Cov matrix
gnss_covariance = cov(read_only_vars.gnss_history)
gnss_variance = gnss_sigma.^2

end
