function model = model_data(l, r)
% MODEL_DATA 模型数据
% 
% Input
% -----
%  l: 区间左端点
%  r: 区间右端点

L = l;
R = r;

model = struct('init_mesh', @init_mesh, 'solution', @solution,...
    'source', @source);

function [X, h] = init_mesh(NS)
    X = linspace(L, R,NS+1)';
    h = (R - L)/NS;
end

function u = solution(x)
    u=sin(4*pi*x);
end

function f = source(x)
    f=16*pi*pi*sin(4*pi*x);
end

end
