function pde = model_data()
%% MODELDATA
%  u(x) = sin(x)/sin(1) - x
%  Du(x) = cos(x)/sin(1) -1 
%  f(x) = -x

pde = struct('solution', @solution, 'source',@source, 'gradient', @gradient);

%% 精确解
function z = solution(x)
z = sin(x)/sin(1) - x;
end
%% 右端项
function z = source(x)
z = -x;
end
%% 精确解梯度
function z = gradient(x)
z = cos(x)/sin(1) - 1;
end 
end 
