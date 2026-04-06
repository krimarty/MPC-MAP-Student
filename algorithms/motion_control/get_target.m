function [target] = get_target(path, robotPos, L)
%GET_TARGET Finds the lookahead target point on the path
n_waypoints = size(path, 1);

target = path(end, :);

for i = 1:n_waypoints-1
    W1 = path(i, :);
    W2 = path(i+1, :);
    
    d = W2 - W1;
    f = W1 - robotPos;
    
    a = d(1)*d(1) + d(2)*d(2);
    b = 2 * (f(1)*d(1) + f(2)*d(2));
    c = (f(1)*f(1) + f(2)*f(2)) - L^2;
    
    disc = b^2 - 4*a*c;
    
    if disc >= 0
        t2 = (-b + sqrt(disc)) / (2*a);
        if t2 >= 0 && t2 <= 1
            target = W1 + t2 * d;
        end
    end
end

end