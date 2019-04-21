function [X,T,U] = wave_equation_fd1d(NS,NT,pde,theta)
%% WAVE_EQUATION_FD1D 利用有限差分方法计算一维弦振动方程
%   
%   输入参数：
%       NS 整型，空间剖分段数.
%       NT 整型，时间剖分段数.
%       pde 结构体，待求解的微分方程模型的已知数据，
%                  如边界、初始、系数和右端项等条件.
%       theta 双精度类型， 隐格式参数， 在 [0,1] 之间， 
%             当 theta=0 时，格式为显格式. 
%   输出参数：
%       X 长度为 NS+1 的列向量，空间网格剖分
%       T 长度为 NT+1 的行向量，时间网格剖分
%       U (NS+1)*(NT+1) 矩阵，U(:,i) 表示第 i 个时间层网格部分上的数值解
%
%   作者：魏华祎 <weihuayi@xtu.edu.cn>

if nargin < 4
    theta = 0; % 默认用显格式
end
[X,h] = pde.space_grid(NS);
[T,tau] = pde.time_grid(NT);
N = length(X);M = length(T);
r = pde.a()*tau/h;
if r >=1 && theta==0
   error('时间空间离散不满足显格式的稳定条件！') 
end
r2 = r*r;
U = zeros(N,M);
% 初值条件
U(:,1) = pde.u_initial(X); 
U(2:end-1,2) = r2/2*(U(1:end-2,1)+U(3:end,1)) + (1-r2)*U(2:end-1,1)...
    + tau*pde.udt_initial(X(2:end-1));
% 边值条件
U(1,:) = pde.u_left(T);
U(end,:) = pde.u_right(T);

%% 隐格式
d = 1 + 2*ones(N-2,1)*r2*theta;
c = -ones(N-3,1)*r2*theta;
A2 = diag(c,-1) + diag(c,1)+diag(d);

d = 2 - 2*ones(N-2,1)*r2*(1-2*theta);
c = ones(N-3,1)*r2*(1-2*theta);
A1 = diag(c,-1) + diag(c,1)+diag(d);

d = -1 - 2*ones(N-2,1)*r2*theta;
c = ones(N-3,1)*r2*theta;
A0 = diag(c,-1) + diag(c,1)+diag(d);
for i=3:M
    RHS = tau*tau*pde.f(X,T(i));
    RHS(2) = RHS(2) + theta*r2*U(1,i) + ...
        (1-2*theta)*r2*U(1,i-1)+ theta*r2*U(1,i-2);
    RHS(end-1) = RHS(end-1) + theta*r2*U(end,i) + ...
        (1-2*theta)*r2*U(end,i-1)+ theta*r2*U(end,i-2);
    U(2:end-1,i) = A2\(A1*U(2:end-1,i-1) + A0*U(2:end-1,i-2)+RHS(2:end-1));
end

end
