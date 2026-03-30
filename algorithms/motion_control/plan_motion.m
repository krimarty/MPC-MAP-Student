function [public_vars] = plan_motion(read_only_vars, public_vars)
%PLAN_MOTION Summary of this function goes here

% I. Pick navigation target

target = get_target(public_vars.estimated_pose, public_vars.path);


% II. Compute motion vector

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

end


end