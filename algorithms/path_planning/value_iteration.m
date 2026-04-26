function [value, policy] = value_iteration(map, goal)

actions = [-1  0;    % NAHORU
            1  0;    % DOLŮ
            0 -1;    % VLEVO
            0  1;    % VPRAVO
           -1 -1;    % NAHORU-VLEVO
           -1  1;    % NAHORU-VPRAVO
            1 -1;    % DOLŮ-VLEVO
            1  1];   % DOLŮ-VPRAVO

action_costs = [1; 1; 1; 1;
                1.414; 1.414; 1.414; 1.414];

drifts_left  = [ 0 -1;    % NAHORU      → vlevo = VLEVO
                 0  1;    % DOLŮ        → vlevo = VPRAVO
                 1  0;    % VLEVO       → vlevo = DOLŮ
                -1  0;    % VPRAVO      → vlevo = NAHORU
                 1 -1;    % NAHORU-VLEVO  → vlevo = DOLŮ-VLEVO
                -1 -1;    % NAHORU-VPRAVO → vlevo = NAHORU-VLEVO
                 1  1;    % DOLŮ-VLEVO    → vlevo = DOLŮ-VPRAVO
                -1  1];   % DOLŮ-VPRAVO   → vlevo = NAHORU-VPRAVO

drifts_right = [ 0  1;    % NAHORU      → vpravo = VPRAVO
                 0 -1;    % DOLŮ        → vpravo = VLEVO
                -1  0;    % VLEVO       → vpravo = NAHORU
                 1  0;    % VPRAVO      → vpravo = DOLŮ
                -1  1;    % NAHORU-VLEVO  → vpravo = NAHORU-VPRAVO
                 1  1;    % NAHORU-VPRAVO → vpravo = DOLŮ-VPRAVO
                -1 -1;    % DOLŮ-VLEVO    → vpravo = NAHORU-VLEVO
                 1 -1];   % DOLŮ-VPRAVO   → vpravo = DOLŮ-VLEVO

stochastic_model = [0.4 0.3 0.3];
[rows, cols] = size(map);
policy = zeros(rows, cols);
value = (rows * cols) * ones(rows, cols);
value(goal(2), goal(1)) = 0;

% 
danger_radius = 3;
danger_weight = 100;
danger = wall_danger(map, danger_radius, danger_weight);



change = true;
while change
    change = false;
    for x = 1:cols
        for y = 1:rows
            if map(y,x) == 1
                continue;
            end
            for a = 1:8
                x2 = x + actions(a, 2);
                y2 = y + actions(a, 1);

                if x2 < 1 || x2 > cols || y2 < 1 || y2 > rows || map(y2, x2) == 1
                    continue;
                end

                % Kontrola volnych smeru pri diagonalni jizde
                if a >= 5
                    if map(y, x2) == 1 || map(y2, x) == 1
                        continue;
                    end
                end

                % Vypocet sousedu
                xl = x + drifts_left(a, 2);
                yl = y + drifts_left(a, 1);
                xr = x + drifts_right(a, 2);
                yr = y + drifts_right(a, 1);

                % Kontrola zdi a hranic
                if xl < 1 || xl > cols || yl < 1 || yl > rows || map(yl, xl) == 1
                    vl = value(y, x); 
                    dl = danger(y, x);
                else
                    vl = value(yl, xl); 
                    dl = danger(yl, xl);
                end

                if xr < 1 || xr > cols || yr < 1 || yr > rows || map(yr, xr) == 1
                    vr = value(y, x); 
                    dr = danger(y, x);
                else
                    vr = value(yr, xr); 
                    dr = danger(yr, xr);
                end

                % Vypocet hodnoty bez stochasticity
                %v2 = action_costs(a) + (value(y2,x2) + danger(y2,x2));
                % Vypocet hodnoty se stochasticitou
                v2 = action_costs(a) ...
                   + stochastic_model(1)*(value(y2,x2) + danger(y2,x2)) ...
                   + stochastic_model(2)*(vl + dl) ...
                   + stochastic_model(3)*(vr + dr);

                if v2 < value(y, x)
                    change = true;
                    value(y, x) = v2;
                    policy(y, x) = a;
                end
            end
        end
    end
end
end

function danger = wall_danger(map, radius, weight)
[rows, cols] = size(map);
danger = zeros(rows, cols);
for y = 1:rows
    for x = 1:cols
        if map(y,x) == 1
            continue; 
        end
        min_dist = radius + 1;
        for dy = -radius:radius
            for dx = -radius:radius
                ny = y + dy; nx = x + dx;
                is_wall = (ny < 1 || ny > rows || nx < 1 || nx > cols) || map(ny,nx) == 1;
                if is_wall
                    d = sqrt(dy^2 + dx^2);
                    if d < min_dist, min_dist = d; end
                end
            end
        end
        if min_dist <= radius
            danger(y,x) = weight * (1 - min_dist / radius);
        end
    end
end

% % Vizualizace
% figure(3)
% clf
% danger_display = danger;
% danger_display(map == 1) = NaN;
% imagesc(danger_display)
% colormap(flipud(autumn))
% colorbar
% hold on
% [wy, wx] = find(map == 1);
% for k = 1:numel(wy)
%     rectangle('Position', [wx(k)-0.5, wy(k)-0.5, 1, 1], ...
%         'FaceColor', [0.15 0.15 0.15], 'EdgeColor', 'none')
% end
% title('Danger zone')
% axis equal tight
% hold off

end