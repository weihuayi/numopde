function Galerkin_test
%% 准备初始数据

% 微分方程模型数据。函数 modeldata 返回一个结构体 pde
% pde.f : 右端项函数
% pde.exactu : 真解函数
% pde.Du ：真解导数
pde = model_data();

% 区间
I = [0,1];

% 空间维数（基函数个数）
n = 3;

% 积分精度
option.quadOrder = 5;

%% Galerkin 方法求解
uh = Galerkin(pde,I,n,option);

%% 显示数值解图像
showsolution(uh,'-k');

%% 计算代表点处真解和数值解
x = [1/4, 1/2, 3/4];
[v,~] = basis(x,n);
format shorte
u = pde.solution(x) 
ux = v'*uh
