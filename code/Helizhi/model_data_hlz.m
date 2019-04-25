function pde = model_data_hlz(t0,t1, x0, x1,NT,NX)
% MODEL_DATA 模型数据

pde = struct(...
    'init_solution', @init_solution, ...
    'init_dt_solution', @init_dt_solution, ...
    'left_solution', @left_solution, ...
    'right_solution', @right_solution, ...
    'source', @source, ...
    'time_grid', @time_grid, ...
    'space_grid', @space_grid, ...
    'a', @a,...
    'real_solution',@real_solution);

    function [T,tau] = time_grid()
        tau = (t1-t0)/NT ;
        T = t0:tau:t1;
    end

    function [X,h] = space_grid()
        h = (x1-x0)/NX ;
        X = (x0:h:x1)';
    end

    function u = init_solution(x)
        %u = zeros(size(x));
        u = sin(pi*x);
    end

    function u =init_dt_solution(x)
       %u = zeros(size(x));
       u = cos(pi*x);
    end

    function u = left_solution(t)
        u = zeros(size(t));
    end

    function u = right_solution(t)
        u = zeros(size(t));
    end

    function f = source(x,t)
        f = zeros(size(x));
    end

    function a = a()
        a = 1;
    end
    
    function u_real = real_solution(x,t)
        u_real = 0.5*(sin(pi*(x-t))+sin(pi*(x+t)))...
        +(0.5/pi)*(sin(pi*(x+t))-sin(pi*(x-t)));
    end
end
