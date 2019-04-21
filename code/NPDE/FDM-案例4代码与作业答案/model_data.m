function pde = model_data()
% MODEL_DATA 模型数据

TI = 0;
TF = 1;
SI = 0;
SF = 2;
pde = struct('u_exact',@u_exact,'u_initial',@u_initial,...
    'u_left',@u_left,'time_grid',@time_grid,'space_grid',@space_grid,'a',1);

    function [T,tau] = time_grid(NT)
        T = linspace(TI,TF,NT+1);
        tau = (TF - TI)/NT;
    end
    function [X,h] = space_grid(NS)
        X = linspace(SI,SF,NS+1)';
        h = (SF - SI)/NS;
    end
    function U = u_exact(X,T)
      [x,t] = meshgrid(X,T);
      U = zeros(size(x));
      case1 = (x <= t);
      case2 = (x > t+1);
      case3 = ~case1 & ~case2;
      U(case1) = 1;
      U(case3) = 1-x(case3)+t(case3);
      U(case2) = x(case2) - t(case2) -1;
      U = U';
    end
    function u = u_initial(x)
        u = abs(x-1);
    end

    function u = u_left(t)
        u = ones(size(t));
    end

end

