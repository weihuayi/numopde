function [X, T, U] = wave_equation_fd1d_hlz(pde)
%% WAVE_EQUATION_FD1D 利用有限差分方法计算一维弦振动方程
%   
%   输入参数：

%       pde 结构体，待求解的微分方程模型的已知数据，
%                  如边界、初始、系数和右端项等条件.
 
%   输出参数：
%       X 长度为 NS+1 的列向量，空间网格剖分
%       T 长度为 NT+1 的行向量，时间网格剖分
%       U (NS+1)*(NT+1) 矩阵，U(:,i) 表示第 i 个时间层网格部分上的数值解


[X,h ] = pde.space_grid();
[T,tau ] = pde.time_grid();

N = length(X);
M = length(T);
r = pde.a()*tau/h;
if r >1 
   error('时间空间离散不满足显格式的稳定条件！') 
end
r2 = r*r;
U = zeros(N,M);
% 初值条件
U(:,1) = pde.init_solution(X); 
U(:, 2) =U(:, 1)+ tau*pde.init_dt_solution(X);
% 边值条件
U(1,:) = pde.left_solution(T);
U(end,:) = pde.right_solution(T);

%% 隐格式
d = ones(N-2,1);
A2 = diag(d);

d = 2 - 2*ones(N-2,1)*r2;
c = ones(N-3,1)*r2;
A1 = diag(c,-1) + diag(c,1)+diag(d);

d = -1*ones(N-2,1);
A0 = diag(d);
for i=3:M
    U(2:end-1,i) = A2\(A1*U(2:end-1,i-1) + A0*U(2:end-1,i-2));
end

end
