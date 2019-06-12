function pde = model_data(t0, t1, x0, x1)
% MODEL_DATA 模型数据

pde = struct(...
    'solution', @solution, ...
    'init_solution', @init_solution,...
    'right_solution', @right_solution, ...
    'time_grid', @time_grid, ...
    'space_grid', @space_grid, ...
    'a', @a);

    function [T, tau] = time_grid(NT)
        T = linspace(t0, t1,NT+1);
        tau = (t1 - t0)/NT;
    end

    function [X, h] = space_grid(NS)
        X = linspace(x0, x1, NS+1)';
        h = (x1 - x0)/NS;
    end

    function U = solution(X, T)
      [x,t] = meshgrid(X,T);
      U = 1 + sin(2*pi*(x + 2*t));
      U = U';
    end

    function u = init_solution(x)
        u = 1 + sin(2*pi*x);
    end

    function u = right_solution(t)
        u = 1 + sin(4*pi*t);
    end

    function val = a()
        val = -2;
    end
end