function [public_vars] = plan_motion(read_only_vars, public_vars)
%PLAN_MOTION Summary of this function goes here

% Week 2 
if (isfield(public_vars, 'config') && isfield(public_vars.config, 'meas_mode'))

    if (strcmp(public_vars.config.meas_mode, 'motion'))
        % Task 5
        c = read_only_vars.counter;
        if c < 120
            public_vars.motion_vector = [0.5, 0.5];    % rovne nahoru
        
        elseif c < 240
            public_vars.motion_vector = [0.45, 0.5];   % otocka vpravo (na vychod)
        
        elseif c < 350
            public_vars.motion_vector = [0.5, 0.5];    % rovne doprava
        
        elseif c < 400
            public_vars.motion_vector = [0.5, 0.4];   % otocka vpravo (na jih)
        
        else
            public_vars.motion_vector = [0.5, 0.5];    % rovne dolu
        
        end

    else
        % Task 2,3
        public_vars.motion_vector = [0, 0];

    end

else

% Week 5
uncertainty = 0;%trace(public_vars.sigma);

% Week 3
% CONFIG - choose the method
method   = 'pure_pursuit';   % 'xte', 'pure_pursuit'
L        = 0.5;                % lookahead distance (pure_pursuit)
k_v      = 2.0;                % xte, how much to slow down when turn

switch method
    case 'xte'
        XTE = cross_track_error(public_vars.path, public_vars.estimated_pose(1:2));
        [w, public_vars] = my_pid(XTE, public_vars, read_only_vars);
        v = read_only_vars.agent_drive.max_vel * max(0.3, 1 - k_v * abs(XTE));
        [vr, vl] = kinematics(v, -w, read_only_vars);

    case 'pure_pursuit'
        target = get_target(public_vars.path, public_vars.estimated_pose(1:2), L);
        [v, w] = pure_pursuit(target, public_vars.estimated_pose, read_only_vars, L, uncertainty);
        [vr, vl] = kinematics(v, w, read_only_vars);

    otherwise
        error('plan_motion: wrong motion: %s', method);
end

public_vars.motion_vector = [vr, vl];

% % Week 3 method camparison
% % Plot XTE vs time (
% if ~isfield(public_vars, 'y_history')
%     public_vars.y_history = [];
% end
% 
% public_vars.y_history = [public_vars.y_history; read_only_vars.mocap_pose(2)];
% 
% XTE_log = cross_track_error(public_vars.path, read_only_vars.mocap_pose(1:2));
% t_now   = (length(public_vars.y_history) - 1) * read_only_vars.sampling_period;
% 
% % Logovani XTE do souboru
% log_path = fullfile('logs', ['xte_01', '.csv']);
% if length(public_vars.y_history) == 1
%     fid = fopen(log_path, 'w');
%     fprintf(fid, 'time,xte\n');
% else
%     fid = fopen(log_path, 'a');
% end
% fprintf(fid, '%.4f,%.6f\n', t_now, XTE_log);
% fclose(fid);

end



end