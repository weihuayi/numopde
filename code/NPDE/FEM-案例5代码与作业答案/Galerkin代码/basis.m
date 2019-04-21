function [phi,gradPhi] = basis(x,n)
%% BASIS 计算 n 维空间 n 个基函数在 m(=length(x)) 个点上的取值
%
%  H_0^1([0,1]) 的 n 维近似子空间， 取 w(x) = x*(1-x)，n 个基函数分别为：
%          phi_i = w(x)*x^{i-1}, i = 1, 2,..., n
%
%  输入：
%   x(1:m,1): 点
%   n: 空间维数
%
%  输出：
%   phi(1:n,1:m): phi(i,j) 为第 i 个基函数在第 j 个点在处的函数值.
%   gradPhi(1:n,1:m): gradPhi(i,j) 为第 i 个基函数在第 j 个点处的导数值.


m = length(x);% 点的个数
%% 函数值
phi = cumprod(ones(n,m)*diag(x),1)*diag(1-x);


%% 函数梯度值
t = repmat(x',n,1);
t = cumprod(t,1);
v = ones(n,m);
v(2:end,:) = t(1:end-1,:);
gradPhi = diag(1:n)*v-diag(2:n+1)*t;

