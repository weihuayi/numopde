%% 准备初始数据

% 区间[a,b]
a = 0; 
b = 1;

%网格剖分尺寸
h = 0.1;

% 微分方程模型数据。函数 sindata 返回一个结构体 pde
% pde.f : 右端项函数
% pde.exactu : 真解函数
% pde.Du ：真解导数
% pde.g_D: D 氏边界条件函数
pde = sindata();

% 设定Gauss积分精度
option.fQuadOrder = 3;
option.errQuadOder = 3;

%% 网格剖分
[node,elem,bdFlag] = intervalmesh(a,b,h);

%% 组装刚度矩阵A及右端向量b、边界条件处理、求解
uh = Poisson1d(node, elem, pde, bdFlag,option);

%% 计算 L2 和 H1 误差、结果可视化
errL2 = getL2error1d(node,elem,pde.exactu,uh,option.errQuadOder);
errH1 = getH1error1d(node,elem,pde.Du,uh,option.errQuadOder);
showsolution1d(node,elem,uh,'-+k');

