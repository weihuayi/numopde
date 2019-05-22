function [phi,gradPhi] = basis(x, n)
%% BASIS 计算 n 维空间的 n 个基函数在 [x_1, x_2, ..., x_m] 点处的函数值与梯度值
%
%  H_0^1([0,1]) 的 n 维近似子空间 w(x) = x*(1-x)，n 个基函数分别为： 
%          phi_i = w(x)*x^{i-1}, i = 1, 2,..., n
%
%  输入： 
%   x: 空间离散点
%   n: 空间维数 
%
%  输出： 
%   phi(1:n, 1:m): phi(i, j) 为第 i 个基函数在第 x_j 点处的函数值。 
%   gradPhi(1:n, 1:m): gradPhi(i, j) 为第 i 个基函数在 x_j 点处的导数值。 

m = length(x);
X = ones(n+1, 1)*x;
X = cumprod(X, 1);
phi = X(1:n,:) - X(2:end, :);
T = [ones(1, m);X(1:n-1, :)];
gradPhi = diag(1:n)*T - diag(2:n+1)*X(1:n, :);
