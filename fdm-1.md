# 一维椭圆问题的有限差分求解算法实现

对每一件稍微复杂一点的事情，一般只要稍微合理安排一下做事流程，就可以大大提高
做事效率和成就感, 对于写一个数值实验程序也一样。

编写数值实验程序的一般流程：

1. 深入理解数值算法，并用最直观的数学语言写出算法。
    + 很多算法涉及到数组，常用的数组是矩阵和向量，所以算法最好能用矩阵向量的语言
      写出来，如果写不出来就别写程序了。
    + 矩阵向量的运算要尽量避免用连加和连乘等不直观的运算表示。
    + 运算过程中出现的矩阵向量也要显式的写出来。
    + 对算法进行切割，横向分块和纵向分层。
    + 构造一个尽量简单的模型数据，手写算法过程中出现的中间和结果数据，用于对比程序结果。
1. 编写模型数据程序。
    + 这是核心算法的输入部分，有了模型数据，才能测试你的算法写的对不对。
    + 模型数据程序要尽量通用，适应你编程解决问题的一般情形。 
1. 编写测试流程程序框架。
    + 测试流程程序中需要调用的核心算法函数开始不必实现，只需要先实现一个接口就可以了。
    + 测试模型数据尽量简单，简单到你可以动手验证程序的结果对不对。  
1. 实现核心算法。
    + 交互实现测试流程框架中没有实现的部分。
    + 要有尽量多的打印语句，输出中间结果。

有很多初学者，开始就直接写核心算法，结果当然是大概率得到不正确的结果，也就体验不
到编程的乐趣，也会自己贴上“不善长编程”的标签，总想着远离编程。

## 一维椭圆两点边值问题的有限差分方法实现    

利用有限差分法去求解

$$
\begin{aligned}
&-u''(x)=16\pi^2\sin(4\pi x),\\
& u(0)=0,\quad u(1)=0.
\end{aligned}
$$ 

问题的真解为

$$
u(x)=\sin(4\pi x)
$$


把 $$[0, 1]$$ 均匀分成 $$n$$ 段，每段长度为 $$h$$, 用中心有限差分离散后的矩阵向量形式为：

$$
\begin{equation}
\begin{bmatrix}
   1 & 0 & 0 & \cdots & \cdots& \cdots  &  0                                  \\
   a_1 & d_1 & c_1& 0 &  &   & \vdots    \\
   0 & a_2 & d_2 & c_2 & 0  &  &\vdots\\
   \vdots & \ddots & \ddots&\ddots&\ddots& \ddots& \vdots \\
   \vdots &   & 0 & a_{n-2} & d_{n-2} & c_{n-2} & 0\\
   \vdots &   &   & 0 & a_{n-1} & d_{n-1} & c_{n-1}\\
   0 & \cdots & \cdots & \cdots & 0 & 0 & 1
  \end{bmatrix}\begin{bmatrix}
    u_0 \\
    u_1\\
    u_2\\
    \vdots   \\
    u_{n-2}\\
    u_{n-1}  \\
   u_{n}  \end{bmatrix}=\begin{bmatrix}
    \alpha \\
   f_1\\
    f_2\\
    \vdots   \\
    f_{n-2}\\
    f_{n-1}  \\
   \beta  
\end{bmatrix}
\end{equation}
$$

其中 

$$
a_i=-\frac{1}{h^2},\quad d_i= \frac{2}{h^2},\quad c_i=-\frac{1}{h^2}
$$


1) 首先定义模型数据

```Matlab
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
```

2) 编写测试框架

```Matlab
%% 测试脚本 FD1d_bvp_test.m

clear all
close all
 
 % 初始化相关数据
NS = [5, 10, 20, 40, 80];
L = 0;
R = 1;

model = model_data(L, R);

emax = zeros(5,1);
e0 = zeros(5,1);
e1 = zeros(5,1);

%% 求解并计算误差
for i = 1:5
    [uh, x] = FD1d_bvp(model, NS(i));
    [e0(i), e1(i), emax(i)]=FD1d_error(model.solution, uh, x);
    X{i} = x;
    U{i} = uh;
end

u = model.solution(X{5});

%% 显示真解及不同网格剖分下的数值解
plot(X{5}, u, '-k*', X{1}, U{1}, '-ro', X{2},...
    U{2}, '-gs', X{3}, U{3}, '-bd',...
    X{4}, U{4}, '-ch', X{5}, U{5},'-mx');
title('The solution plot');
xlabel('x');  ylabel('u');
legend('exact','NS=5','NS=10','NS=20','NS=40','NS=80');

%% 显示误差
format shorte
disp('     emax           e0          e1');
disp([emax, e0, e1]);
```

3) 实现核心算法

```Matlab
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
```
4) 编写误差分析函数

```Matlab
function [e0, e1, emax] = FD1d_error(solution, uh, X)

NN = length(X);
h = (X(end) - X(1))/(NN -1);
u = solution(X);
ee= u - uh;

e0 = h*sum(ee.^2);
e1 = sum((ee(2:end)-ee(1:end-1)).^2)/h;
e1 = e1+e0;

e0 = sqrt(e0);
e1 = sqrt(e1);
emax=max(abs(ee));

end
```

## 上机实践

利用中心有限差分法格式求解

$$
\begin{aligned}
&-u''(x)+u(x)=f(x),\\
& u(-1)=0,\quad u(1)=0.
\end{aligned}
$$

真解为

$$
u(x)=e^{-x^2}(1-x^2)
$$

要求如下：
1. 用 `sparse` 命令组装有限差分矩阵 A。
1. 算出区间 $$[-1, 1]$$ 分段数为 [5, 10, 20, 40, 80, 160] 下的数值解及误差，画出
   数值解图像，并给出误差分析。

<div id="container"></div>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/gh/theme-next/theme-next-gitment@1/default.css"/>
<script src="https://cdn.jsdelivr.net/gh/theme-next/theme-next-gitment@1/gitment.browser.js"></script>

<script>
var gitment = new Gitment({
  id: 'window.location.pathname', // 可选。默认为 location.href
  owner: 'weihuayi',
  repo: 'weihuayi.github.io',
  oauth: {
    client_id: '7dd9c9fc3ac45352b55b',
    client_secret: '4e6f74b82a7ac18671c7e9e0d17a1ceb9359a5ad',
  },
})

gitment.render('container')
</script>
