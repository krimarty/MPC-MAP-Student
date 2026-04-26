function [path] = get_path(policy, pos, goal)

actions = [-1  0;    % NAHORU
            1  0;    % DOLŮ
            0 -1;    % VLEVO
            0  1;    % VPRAVO
           -1 -1;    % NAHORU-VLEVO
           -1  1;    % NAHORU-VPRAVO
            1 -1;    % DOLŮ-VLEVO
            1  1];   % DOLŮ-VPRAVO

[rows, cols] = size(policy);
max_steps = rows * cols;
path = zeros(max_steps, 2);
path(1, :) = [pos(2), pos(1)];
step = 2;
col = pos(1);
row = pos(2);

while (row ~= goal(2) || col ~= goal(1)) && step < max_steps
    new_col = col + actions(policy(row,col), 2);
    new_row = row + actions(policy(row,col), 1);
    path(step, :) = [new_row, new_col];
    col = new_col;
    row = new_row;
    step = step + 1;
end

path(step, :) = [goal(2), goal(1)];
path = path(1:step, :);
end