function pde = model_data(t0, t1, x0, x1)
% MODEL_DATA 模型数据

pde = struct(...
    'init_solution', @init_solution, ...
    'init_dt_solution', @init_dt_solution, ...
    'left_solution', @left_solution, ...
    'right_solution', @right_solution, ...
    'source', @source, ...
    'time_grid', @time_grid, ...
    'space_grid', @space_grid, ...
    'a', @a);

    function [T,tau] = time_grid(NT)
        T = linspace(t0, t1, NT+1);
        tau = (t1 - t0)/NT;
    end

    function [X,h] = space_grid(NS)
        X = linspace(x0, x1, NS+1)';
        h = (x1 - x0)/NS;
    end

    function u = init_solution(x)
        u = zeros(size(x));
        u(x < 0.7) = 0.5/7*x(x<0.7);
        u(x >= 0.7) = 0.5/3*(1-x(x>=0.7));
    end

    function u =init_dt_solution(x)
       u = zeros(size(x)); 
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
end
