function [output, public_vars] = my_pid(error, public_vars)
%PID Summary of this function goes here
%   Detailed explanation goes here
% Ziegler-Nicols K = 0.42, T = 13
% Kp = 0.252, Ki = 0.0646, Kd = 0.6825
Kp = 10;
Ki = 0.1;
Kd = 1;

% Inicializace pri prvnim volani
if ~isfield(public_vars, 'pid')
    public_vars.pid.integral   = 0;
    public_vars.pid.prev_error = 0;
    public_vars.pid.last_time  = tic;
    output = 0;
    return;
end

dt = min(toc(public_vars.pid.last_time), 0.5);
public_vars.pid.last_time = tic;

public_vars.pid.integral = public_vars.pid.integral + error * dt;
derivative = (error - public_vars.pid.prev_error) / dt;

output = Kp * error + Ki * public_vars.pid.integral + Kd * derivative;
public_vars.pid.prev_error = error;

end