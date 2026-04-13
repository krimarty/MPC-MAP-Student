function x = my_randn(variance)
    x = 0;
    for i = 1:12
        x = x + rand() - 0.5;
    end
    x = x * sqrt(variance); 
end