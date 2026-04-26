function [public_vars] = plan_path(read_only_vars, public_vars)

planning_required = 1;

if planning_required
    if ~isfield(public_vars, 'planning')
        [value, policy] = value_iteration(read_only_vars.discrete_map.map, ...
                                          read_only_vars.discrete_map.goal);
        public_vars.planning.value = value;
        public_vars.planning.policy = policy;

        % % Policy + value vizualizace
        % figure(2)
        % clf
        % display_val = value;
        % display_val(read_only_vars.discrete_map.map == 1) = NaN;
        % imagesc(display_val)
        % 
        % colormap(parula)
        % colorbar
        % hold on
        % 
        % [wy, wx] = find(read_only_vars.discrete_map.map == 1);
        % for k = 1:numel(wy)
        %     rectangle('Position', [wx(k)-0.5, wy(k)-0.5, 1, 1], ...
        %         'FaceColor', [0.15 0.15 0.15], 'EdgeColor', 'none')
        % end
        % 
        % action_vec = [ 0 -1;
        %                0  1;
        %               -1  0;
        %                1  0;
        %               -1 -1;
        %                1 -1;
        %               -1  1;
        %                1  1];
        % 
        % [rows, cols] = size(policy);
        % qx = []; qy = []; qu = []; qv = [];
        % for y = 1:rows
        %     for x = 1:cols
        %         a = policy(y,x);
        %         if a == 0 || read_only_vars.discrete_map.map(y,x) == 1, continue; end
        %         qx(end+1) = x;
        %         qy(end+1) = y;
        %         qu(end+1) = action_vec(a,1) * 0.6;
        %         qv(end+1) = action_vec(a,2) * 0.6;
        %     end
        % end
        % quiver(qx, qy, qu, qv, 0, 'Color', 'w', 'LineWidth', 1.5, 'MaxHeadSize', 3)
        % 
        % goal_cell = read_only_vars.discrete_map.goal;
        % plot(goal_cell(1), goal_cell(2), 'rx', ...
        %     'MarkerSize', 16, 'MarkerFaceColor', 'r', 'LineWidth', 3)
        % 
        % title('Policy + Value function')
        % axis equal tight
        % hold off
    end

    estimated_pose = public_vars.estimated_pose(1:2);
    discretization_step = read_only_vars.map.discretization_step;

    % diskretizace pozice
    x_cell = round(estimated_pose(1) / discretization_step) + 1;
    y_cell = round(estimated_pose(2) / discretization_step) + 1;
    pos = [x_cell, y_cell];

    % get path
    path_discrete = get_path(public_vars.planning.policy, pos, ...
                             read_only_vars.discrete_map.goal);

    % oddiskretizace
    path_continuous = zeros(size(path_discrete, 1), 2);
    path_continuous(:, 1) = (path_discrete(:, 2) - 1) * discretization_step;
    path_continuous(:, 2) = (path_discrete(:, 1) - 1) * discretization_step;
    
    public_vars.path = smooth_path(path_continuous);

end

end