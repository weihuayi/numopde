function pde = modeldata()
%% MODELDATA
%  u(x) = sin(x)/sin(1) - x
%  Du(x) = cos(x)/sin(1)
%  f(x) = -x

pde = struct('exactu',@exactu,'f',@f,'Du',@Du);
%% 精确解
function z = exactu(x)
z = sin(x)/sin(1) - x;
end
%% 右端项
function z = f(x)
z = -x;
end
%% 精确解梯度
function z = Du(x)
z = cos(x)/sin(1);
end 
end 