function [public_vars] = student_workspace(read_only_vars,public_vars)
%STUDENT_WORKSPACE Summary of this function goes here

% First run
if (read_only_vars.counter == 1)

    tmp = load('algorithms/uncertainty/lidar_sigma.mat');
    public_vars.lidar_sigma = tmp.lidar_sigma;
    tmp = load('algorithms/uncertainty/gnss_sigma.mat');
    public_vars.gnss_sigma = tmp.gnss_sigma;
    tmp = load('algorithms/uncertainty/gnss_covariance.mat');
    public_vars.gnss_covariance = tmp.gnss_covariance;


    if isnan(read_only_vars.gnss_position(1))
        public_vars.state = "pf_init";
    else
        public_vars.state = "wait_for_avarage";
    end
end

if (public_vars.state == "wait_for_avarage")

    public_vars.init_pos = [mean(read_only_vars.gnss_history(:,1)), mean(read_only_vars.gnss_history(:,2))];

    % 8. Perform initialization procedure
    if (read_only_vars.counter >= 100)
        public_vars.state = "kf_init";
    end
end

if (public_vars.state == "kf_estimation" && isnan(read_only_vars.gnss_position(1)))
    public_vars.state = "pf_init";
end

if (public_vars.state == "pf_estimation" && ~isnan(read_only_vars.gnss_position(1)))
    public_vars.state = "kf_init";
end

if (public_vars.state == "kf_init")
    public_vars = init_kalman_filter(read_only_vars, public_vars);
    public_vars.kf_enabled = 1;
    public_vars.pf_enabled = 0;
    public_vars.state = "kf_estimation";
end

if (public_vars.state == "pf_init")
    public_vars = init_particle_filter(read_only_vars, public_vars);
    public_vars.kf_enabled = 0;
    public_vars.pf_enabled = 1;
    public_vars.state = "pf_estimation";
end

% PF drive
if (public_vars.pf_enabled == 1)
    public_vars = update_particle_filter(read_only_vars, public_vars);

    % 11. Estimate current robot position
    public_vars.estimated_pose = estimate_pose(public_vars); % (x,y,theta)

    % 12. Path planning + motion
    try
        public_vars = plan_path(read_only_vars, public_vars);
        public_vars = plan_motion(read_only_vars, public_vars);
    catch
        % Odhadovana poza mimo mapu - reinit
        public_vars = init_particle_filter(read_only_vars, public_vars);
    end
end

% Kalman drive
if (public_vars.kf_enabled == 1)
    [public_vars.mu, public_vars.sigma] = update_kalman_filter(read_only_vars, public_vars);

    % 11. Estimate current robot position
    public_vars.estimated_pose = estimate_pose(public_vars); % (x,y,theta)

    % 12. Path planning + motion
    try
        public_vars = plan_path(read_only_vars, public_vars);
        public_vars = plan_motion(read_only_vars, public_vars);
    catch

    end

end
    
end

