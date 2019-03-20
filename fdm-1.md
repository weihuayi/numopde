# 一维椭圆问题的有限差分求解算法实现

对每一件稍微复杂一点的事情，一般只要稍微合理安排一下做事流程，就可以大大提高
做事效率和成就感。 写一个数值实验程序也一样， 要安排好流程。

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
    + 模型数据程序要尽量通用，适应编程解决问题的一般情形。 
1. 编写测试流程程序框架。
    + 测试流程程序中需要调用的核心算法函数开始不必实现，只需要先实现一个接口就可以了。
    + 测试模型数据尽量简单，简单到可以动手验证程序的结果对不对。  
1. 实现核心算法。
    + 交互实现测试流程框架中没有实现的部分。
    + 要有尽量多的打印语句，输出中间结果。

有很多初学者，开始就直接写核心算法，结果当然是大概率得到不正确的结果，也就体验不
到编程的乐趣，也会自己贴上“不善长编程”的标签，总想着远离编程。

初学者还要注意处理好注释和代码之间的关系。以我的经验来看，要想写好代码，就要先写
注释，当然这里说的注释不是算法的细节说明，而是算法的流程说明。

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

这里用一个结构体把模型数据放在一起，可以直接把结构体直接输入给算法，避免给算法设
计过多的参数输入。

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

注意下面的代码是最终的版本，并不是最开始的代码。开始要先用注释的方式把测试流程写
出来，然后再按流程编写可以运行的代码，要充分利用 Matlab 语言的交互性。

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

编写时要把函数的输入输出参数及算法流程注释写一下，然后再一步步交互编写代码。

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

## 写在最后

教学生编程，到底应该教什么才能取得最好的效果？这是我一直在思考的问题。我一直在努
力教学生编程，但效果一直都不好。

很多人可能会说，现在网上介绍编程的资料课程太丰富了，学生完全可以自己来学。但仔细
想想，这些资料和课程很多只重视语法层面的内容，线下的传统编程课程也是讲讲语法就基
本就结束了，这和英语的教学现状不是如出一辙吗？

现在想来，在编程教学中，老师最应该教给学生东西就是正确的做事流程。老师在引导学生
入门后，要通过一个一个的编程问题，向学生展示如何用正确的流程去写程序，如何去调试
程序，而不是纠结在编程语法的层面。编程语法的知识，只是人们的约定而已， 一方面很
容易获取，另一方面它也是死的知识，并不能真正指导编程实践的活动。

推而广之，数学、英语等课程的教学学习也是一样，很多老师和学生只注重“死的”知识的教
学和学习，而忽略了其中流程性知识教学和学习。依我之见，这是当前学校里教学和学习效
果不好的重要原因之一。

以后我会在我的课堂上更多的写程序，直接向学生展示正确的写程序流程和方法。某一天，
也许会把自己编程的过程录下来，或者直播出来分享给大家，敬请期待。









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
