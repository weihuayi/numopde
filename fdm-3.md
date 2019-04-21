# 一维激波管问题

## 物理背景

冲量是力在时间上和积累。

$$
I = \int \mathbf F \mathrm d t
$$ 

物体动量随时间的变化率就是作用在物体上的力。

$$
\mathbf F = \frac{\mathrm d \mathbf p}{\mathrm d t} 
= \frac{\mathrm d (m\mathbf v)}{\mathrm d t}
= m\mathbf a
$$ 

所以冲量和动量之间的关系是
$$
I = \int \frac{\mathrm d\mathbf p}{\mathrm d t}\mathrm d t 
= \int \mathrm d\mathbf p 
= \Delta p
$$ 

对于定义在位移区间 $$[x_1(t), x_2(t)]$$ 上的函数 $$f(x, t)$$, 满足下面的关系式 

$$
\begin{align}
&\frac{\mathrm d}{\mathrm d t} 
\left(\int^{x_2(t)}_{x_1(t)} f(x, t)\mathrm d x\right) \\
=& \int^{x_2(t)}_{x_1(t)} \frac{\partial f(x, t)}{\partial t}\mathrm d x +
f(x_2(t), t) x_2'(t) - f(x_1(t), t)x_1'(t)\\
= &\int^{x_2(t)}_{x_1(t)} \frac{\partial f(x, t)}{\partial t}\mathrm d t 
+ \int^{x_2(t)}_{x_1(t)}\frac{\partial f(x, t)x'(t)}{\partial x} 
\mathrm d x
\end{align}
$$ 

## 算法设计与数值实验


$$
$$ 


## 实验代码


```
function pde = model_data()
% MODEL_DATA 模型数据

pde = struct(
    'init_solution', @init_solution, ...
    'udt_initial', @udt_initial, ...
    'left_solution', @left_solution, ...
    'right_solution', @right_solution, ...
    'source', @source, ...
    'time_grid', @time_grid, ...
    'space_grid', @space_grid, ...
    'a', @a);

    function [T,tau] = time_grid(NT)
        T = linspace(0,4,NT+1);
        tau = 4/NT;
    end
    function [X,h] = space_grid(NS)
        X = linspace(0,1,NS+1)';
        h = 1/NS;
    end
    function u = init_solution(x)
        u = zeros(size(x));
        u(x < 0.7) = 0.5/7*x(x<0.7);
        u(x >= 0.7) = 0.5/3*(1-x(x>=0.7));
    end

    function u =init_dt_solution(x)
       u = zeros(size(x)); 
    end
    function u = left_solution(t)
        u = zeros(size(t));
    end
    function u = right_solution(t)
        u = zeros(size(t));
    end
    function f = source(x,t)
        f = zeros(size(x));
    end
    function a = a()
        a = 1;
    end
end
```

```
%% 一维一维弦振动方程有限差分方法主测试脚本 main_test.m
%   依次测试：
%       显格式 (theta = 0)
%       隐格式（theta = 0.5)
%   并可视化数值计算结果。
%
% 作者：魏华祎 <weihuayi@xtu.edu.cn> 

pde = model_data(); %模型数据结构体

% 显格式
[X,T,U] = wave_equation_fd1d(100,800,pde);
showvarysolution(X,T,U);% 以随时间变化方式显示数值解
showsolution(X,T,U); % 以二元函数方式显示数值解

% 隐格式
[X,T,U] = wave_equation_fd1d(100,400,pde,0.5);
showvarysolution(X,T,U);% 以随时间变化方式显示数值解
showsolution(X,T,U); % 以二元函数方式显示数值解
```

```
function [X, T, U] = wave_equation_fd1d(NS, NT, pde, theta)
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

[X, h] = pde.space_grid(NS);
[T, tau] = pde.time_grid(NT);
N = length(X);
M = length(T);
r = pde.a()*tau/h;
if r >=1 && theta==0
   error('时间空间离散不满足显格式的稳定条件！') 
end
r2 = r*r;
U = zeros(N,M);
% 初值条件
U(:,1) = pde.init_solution(X); 
U(2:end-1,2) = r2/2*(U(1:end-2,1)+U(3:end,1)) + (1-r2)*U(2:end-1,1)...
    + tau*pde.init_dt_solution(X(2:end-1));
% 边值条件
U(1,:) = pde.left_solution(T);
U(end,:) = pde.right_solution(T);

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
    RHS = tau*tau*pde.source(X,T(i));
    RHS(2) = RHS(2) + theta*r2*U(1,i) + ...
        (1-2*theta)*r2*U(1,i-1)+ theta*r2*U(1,i-2);
    RHS(end-1) = RHS(end-1) + theta*r2*U(end,i) + ...
        (1-2*theta)*r2*U(end,i-1)+ theta*r2*U(end,i-2);
    U(2:end-1,i) = A2\(A1*U(2:end-1,i-1) + A0*U(2:end-1,i-2)+RHS(2:end-1));
end

end
```

```
function e = getmaxerror(X,T,U,u)
%%  GETMAXERROR 求最大模误差
%       E(h,\tau) = max_{x_i,t_j}| u_exact(x_i,t_j) - U(i,j)| 
%                 = O( \tau + h^2)
%
% 输入参数：
%       X 长度为 N  的列向量，空间剖分
%       T 长度为 M  的行向量，时间剖分
%       U N*M 的矩阵，U(:,i) 表示第 i 个时间步的数值解
%       u_exact 函数句柄，真解函数
% 输出参数：
%       e 最大模误差
%
% 作者：魏华祎 <weihuayi@xtu.edu.cn>

[x,t] = meshgrid(X,T);
u = u(x',t');
e = max(max(abs(u - U)));
```

```
function showsolution(X, T, U)
%%  SHOWSOLUTION  以二元函数方式显示数值解
% 
%  输入参数：
%       X 长度为N的列向量，空间网格剖分
%       T 第度为M的行向量，时间网格剖分
%       U N*M 矩阵，U(:,i) 表示第  i 个时间层网格部分上的数值解
%
%   作者：魏华祎 <weihuayi@xtu.edu.cn>   

[x, t] = meshgrid(X, T);
mesh(x, t, U');
xlabel('X');
ylabel('T');
zlabel('U(X,T)');
end
```

```
function showvarysolution(X, T, U)
%%  SHOWVARYSOLUTION  显示数值解随着时间的变化
% 
%  输入参数：
%       X 长度为N的列向量，空间网格剖分
%       T 第度为M的行向量，时间网格剖分
%       U N*M 矩阵，U(:,i) 表示第  i 个时间层网格部分上的数值解
%
%   作者：魏华祎 <weihuayi@xtu.edu.cn>   

M = size(U, 2);
figure
xlabel('X');
ylabel('U');
s = [X(1), X(end), min(min(U)), max(max(U))];
axis(s);
for i = 1:M
   plot(X, U(:,i));
   axis(s);
   pause(0.01);
   title(['T=', num2str(T(i)),' 时刻数值解的图像'])
end
```

