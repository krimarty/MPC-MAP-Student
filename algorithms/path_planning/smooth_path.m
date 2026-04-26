function [new_path] = smooth_path(old_path)

alpha = 0.2;
beta = 0.3;
tolerance = 1e-6;
max_iterations = 1000;

new_path = old_path;
n = size(old_path, 1);

for k = 1:max_iterations
    prev_path = new_path;  % zapamatuj předchozí stav
    
    for i = 2:n-1
        % tah k originalu
        new_path(i,:) = new_path(i,:) + alpha * (old_path(i,:) - new_path(i,:));
        
        % tah k sousedum
        new_path(i,:) = new_path(i,:) + beta * (new_path(i-1,:) + new_path(i+1,:) - 2*new_path(i,:));
    end
    
    change = max(max(abs(new_path - prev_path)));
    if change < tolerance
        break;
    end
end

end