# 弦的横振动问题  

## 模型

波动方程的初值问题模型为

$$
\begin{array}{l}
{
\frac{\partial^{2} u}{\partial t^{2}}-a^{2} 
\frac{\partial^{2} u}{\partial x^{2}} = 0,\quad -\infty<x<\infty,\quad t>0
} \\ 
{
u(x, 0) = \phi_{0}(x), u_{t}(x, 0) = \phi_{1}(x),\quad -\infty<x<\infty
}
\end{array}
$$ 

## 有限差分离散

给定空间和时间步长：$$h$$ 和 $$\tau$$，  对求解区域 $$G=(-\infty, \infty)
\times(0, \infty)$$， 做均匀网格剖分，相应的 $$\theta$$ 格式为

$$
\begin{aligned} 
& \frac{u_{j}^{n+1}-2 u_{j}^{n}+u_{j}^{n-1}}{\tau^{2}}\\ 
= & a^{2} \left[\theta \frac{u_{j+1}^{n+1}-2 u_{j}^{n+1}+u_{j-1}^{n+1}}{h^{2}}
\right.\\
& + (1-2 \theta) \frac{u_{j+1}^{n}-2 u_{j}^{n}+u_{j-1}^{n}}{h^{2}}\\
& + \left.\theta \frac{u_{j+1}^{n-1}-2 u_{j}^{n-1}+u_{j-1}^{n-1}}{h^{2}} 
\right] \\
\end{aligned}
$$

引入网比 

$$
r = \frac{a\tau}{h},
$$ 

可得

$$
\begin{aligned}
& u_{j}^{n+1}-2 u_{j}^{n}+u_{j}^{n-1}\\
= & r^2\left[\theta (u_{j+1}^{n+1}-2 u_{j}^{n+1}+u_{j-1}^{n+1})
\right.\\
& + (1-2 \theta) (u_{j+1}^{n}-2 u_{j}^{n}+u_{j-1}^{n})\\
& + \left.\theta (u_{j+1}^{n-1}-2 u_{j}^{n-1}+u_{j-1}^{n-1}) 
\right] \\
\end{aligned}
$$ 

进一步变形可得：

$$
\begin{aligned}
&-r^2\theta u_{j+1}^{n+1} + (1 + 2r^2 \theta) u_{j}^{n+1} 
- r^2\theta u_{j-1}^{n+1} \\
= & r^2(1 - 2\theta)u_{j+1}^n + \left(2 - 2r^2(1 - 2\theta)\right)u_{j}^n 
+ r^2(1 - 2\theta)u_{j-1}^n\\
= & r^2\theta u_{j+1}^{n-1} -(2r^2\theta + 1) u_j^{n-1} + r^2\theta
u_{j-1}^{n-1}
\end{aligned}
$$ 

最后可得上述格式的矩阵形式
$$
A_0 U^{n+1} = A_1 U^{n} + A_2 U^{n-1}
$$ 

上面的格式中要用到过去两个时间层的函数值，所以必须知道第 0 层和第 1 层的函数值
，才能用上面的格式进行计算。下面讨论如何构造第 1 层的函数值。首先假设第 0 层下
在还有一个第 -1 层， 利用中心差分格式可得下式

$$
\frac{u_{j}^{1}-2 u_{j}^{0}+u_{j}^{-1}}{\tau^{2}}
=a^{2}\frac{u_{j+1}^{0}-2 u_{j}^{0}+u_{j-1}^{0}}{h^{2}}
$$ 

用数值微分替代在第 0 层的导数条件

$$
\frac{u_{j}^{1}-u_{j}^{-1}}{2 \tau}=\phi_{1}\left(x_{j}\right)
$$ 

上面两式结合，消去 $$u_j^{-1}$$， 可得

$$
u_{j}^{1}=\frac{r^{2}}{2}\left[\phi_{0}\left(x_{j-1}\right)
+\phi_{0}\left(x_{j+1}\right)\right]
+\left(1-r^{2}\right) \phi_{0}\left(x_{j}\right)
+\tau \phi_{1}\left(x_{j}\right)
$$ 


## 数值实验

利用有限差分法去求解
$$
\begin{align}
\frac{\partial^2 u}{\partial t^2} - a^2\frac{\partial^2 u}{\partial x^2} 
= & 0, \quad 0 < x < 1, \quad 0 < t < 4, \\
u(0,t)= & 0,\\ 
u(1,t)= & 0,\\
u(x,0)= & 
\begin{cases} 
\frac{0.5}{7}x, & x<0.7\\
\frac{0.5}{3}(1-x), & x\geq 0.7
\end{cases}\\
u_t(x,0) = &0.
\end{align}
$$ 
其中系数 $$a^2=1$$。


## Matlab 实现代码 

```
function pde = model_data(t0, t1, x0, x1)
% MODEL_DATA 模型数据

pde = struct(...
    'init_solution', @init_solution, ...
    'init_dt_solution', @init_dt_solution, ...
    'left_solution', @left_solution, ...
    'right_solution', @right_solution, ...
    'source', @source, ...
    'time_grid', @time_grid, ...
    'space_grid', @space_grid, ...
    'a', @a);

    function [T,tau] = time_grid(NT)
        T = linspace(t0, t1, NT+1);
        tau = (t1 - t0)/NT;
    end

    function [X,h] = space_grid(NS)
        X = linspace(x0, x1, NS+1)';
        h = (x1 - x0)/NS;
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

t0 = 0;
t1 = 4;
x0 = 0;
x1 = 1;
pde = model_data(t0, t1, x0, x1); %模型数据结构体

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

## 实验报告

利用下面差分格式

$$
\frac{u_{j}^{n+1}-2 u_{j}^{n}+u_{j}^{n-1}}{\tau^{2}} 
=  a^{2} \frac{u_{j+1}^{n}-2 u_{j}^{n}+u_{j-1}^{n}}{h^{2}}
$$
其中 $$j=0, \pm 1, \pm 2, \cdots,\quad n = 1, 2, \cdots$$。

及初始差分方程

$$
\begin{aligned}
u_j^0 = \phi_0(x_j),\\
\frac{u_j^1 - u_j^0}{\tau} = \phi_1(x_j).
\end{aligned}
$$ 

数值求解

$$
\begin{array}{l}
{
\frac{\partial^{2} u}{\partial t^{2}}- 
\frac{\partial^{2} u}{\partial x^{2}} = 0,\quad 0 <x<1,\quad t>0
} \\ 
{
u(x, 0) = \phi_{0}(x), u_{t}(x, 0) = \phi_{1}(x),\quad 0<x<1,
}\\
u(0, t) = u(1, t) = 0, \quad t\leq=0.
\end{array}
$$ 
其中 $$\phi_{0}(x) = \sin\pi x$$， $$\phi_1(x) = \cos\pi x$$。 真解为
$$
u(x, t) = \sin\pi (x - t) + \sin\pi (x + t).
$$ 

(1) 取 $$\tau = 0.05, h = 0.1$$, 画出时间层 $$t=0.5, 1.0, 1.5, 2.0$$ 的解的图像，并计
算这些时间层上数值解与真解的误差。  
(2) 取 $$\tau = h = 0.1$$, 画出时间层 $$t=0.5, 1.0, 1.5, 2.0$$ 的解的图像，并计
算这些时间层上数值解与真解的误差。  
