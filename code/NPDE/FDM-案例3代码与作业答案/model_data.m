function pde = model_data()
% MODEL_DATA 模型数据

pde = struct('u_initial',@u_initial,'udt_initial',@udt_initial,...
    'u_left',@u_left,'u_right',@u_right,'f',@f,'time_grid',...
    @time_grid,'space_grid',@space_grid,'a',@a);

    function [T,tau] = time_grid(NT)
        T = linspace(0,4,NT+1);
        tau = 4/NT;
    end
    function [X,h] = space_grid(NS)
        X = linspace(0,1,NS+1)';
        h = 1/NS;
    end
    function u = u_initial(x)
        u = zeros(size(x));
        u(x < 0.7) = 0.5/7*x(x<0.7);
        u(x >= 0.7) = 0.5/3*(1-x(x>=0.7));
    end

    function u =udt_initial(x)
       u = zeros(size(x)); 
    end
    function u = u_left(t)
        u = zeros(size(t));
    end
    function u = u_right(t)
        u = zeros(size(t));
    end
    function f = f(x,t)
        f = zeros(size(x));
    end
    function a = a()
        a = 1;
    end
end

