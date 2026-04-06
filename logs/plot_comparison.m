% Porovnani metod rizeni podle XTE

here   = fileparts(mfilename('fullpath'));
pure02 = readmatrix(fullfile(here, 'pure_02.csv'), 'NumHeaderLines', 1);
xte    = readmatrix(fullfile(here, 'xte_01.csv'),  'NumHeaderLines', 1);

% --- XTE (PID) vs Pure Pursuit L=0.2 ---
figure(1); clf;
plot(xte(:,1),    xte(:,2),    'g-', 'LineWidth', 1.5, 'DisplayName', 'XTE (PID)');
hold on;
plot(pure02(:,1), pure02(:,2), 'r-', 'LineWidth', 1.5, 'DisplayName', 'Pure Pursuit L=0.2 m');
xlabel('Time [s]');
ylabel('XTE [m]');
title('XTE (PID) vs Pure Pursuit L=0.2 m');
legend('Location', 'best');
grid on;
set(gca, 'FontSize', 16);
set(findall(gcf, 'Type', 'text'), 'FontSize', 16);
