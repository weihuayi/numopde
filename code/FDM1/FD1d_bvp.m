function [uh, x] = FD1d_bvp(model, NS)
%*************************************************************
%% FD1d_bvp 利用中心差分格式求解两点边值问题.
%
% Input
% -----
%   model : 模型数据
%   NS    ：网格剖分段数
% Output
% ------
%   uh ：列向量，长度为 NS+1， 解向量
%   x  : 列向量，长度为 NS+1， 网格节点
%      

[x, h] = model.init_mesh(NS);
NV = NS + 1;

%
%  创建线性差分方程组系数矩阵
%

c1 = -1/h/h;
c2 = 2/h/h;
g = [c1*ones(1, NV-2), 0];
c = [0, c1*ones(1, NV-2)];
d = [1, c2*ones(1, NV-2), 1];
A = diag(g, -1) + diag(d) + diag(c,1);

%
%  创建线性差分方程组右端项
%

rhs = model.source(x);
rhs(1) = model.solution(x(1));
rhs(end) = model.solution(x(end));

%
%  求解上述代数系统.
%

uh = A \ rhs;
end

