function [public_vars] = student_workspace(read_only_vars,public_vars)
%STUDENT_WORKSPACE Summary of this function goes here

% Week 5
if (read_only_vars.counter <= 100)

    public_vars.gnss_covariance = cov(read_only_vars.gnss_history);
    public_vars.init_pos = [mean(read_only_vars.gnss_history(:,1)), mean(read_only_vars.gnss_history(:,2))];

    % Week 2, task 2,3
    % 7. Uncertainty
    % Measuring standard deviation
    if (isfield(public_vars, 'config') && isfield(public_vars.config, 'meas_mode'))
    
        public_vars = collect_measurements(read_only_vars, public_vars);
        if (read_only_vars.counter >= 100)
    
            if (strcmp(public_vars.config.meas_mode, 'lidar'))
    
                analyze_lidar(public_vars);
                error('Konec mereni - lidar');
    
            elseif (strcmp(public_vars.config.meas_mode, 'gnss'))
    
                analyze_gnss(read_only_vars);
                error('Konec mereni - gnss');
    
            end   
        end
    end
    if (read_only_vars.counter == 1)
        tmp = load('algorithms/uncertainty/lidar_sigma.mat');
        public_vars.lidar_sigma = tmp.lidar_sigma;
        tmp = load('algorithms/uncertainty/gnss_sigma.mat');
        public_vars.gnss_sigma = tmp.gnss_sigma;
    end

        % 8. Perform initialization procedure
    if (read_only_vars.counter == 100)
              
        %public_vars = init_particle_filter(read_only_vars, public_vars);
        public_vars = init_kalman_filter(read_only_vars, public_vars);
    
    end

else
    
    % 9. Update particle filter
    %public_vars = update_particle_filter(read_only_vars, public_vars);
    
    % 10. Update Kalman filter
    [public_vars.mu, public_vars.sigma] = update_kalman_filter(read_only_vars, public_vars);
    
    % 11. Estimate current robot position
    public_vars.estimated_pose = estimate_pose(public_vars, read_only_vars); % (x,y,theta)
    
    % 12. Path planning
    % Week 6
    public_vars = plan_path(read_only_vars, public_vars);
    % Week 3
    %public_vars.path = custom_path(read_only_vars, public_vars);
    
    
    % 13. Plan next motion command
    public_vars = plan_motion(read_only_vars, public_vars);
    
    % Week 3, task 3, PID tunning for XTE
    % Plot Y vs time (pro tuning PID)
    % if ~isfield(public_vars, 'y_history')
    %     public_vars.y_history = [];
    % end
    % public_vars.y_history = [public_vars.y_history; read_only_vars.mocap_pose(2)];
    % 
    % figure(2);
    % t = (0:length(public_vars.y_history)-1) * read_only_vars.sampling_period;
    % plot(t, public_vars.y_history);
    % xlabel('Time [s]');
    % ylabel('Y [m]');
    % title('Y souradnice v case');
    % grid on;
    % drawnow limitrate;
end

end

