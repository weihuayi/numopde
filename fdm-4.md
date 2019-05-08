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


考虑如下混合问题差分离散的算法实现，

$$
\begin{aligned}
  \frac{\partial u}{\partial t} + \frac{\partial u}{\partial x} = 
  & 0,\quad 0 < x < 2,\quad t > 0,\\
  u(x,0) = & \left| x - 1 \right|,\\
  u(0,t) = & 1.
\end{aligned}
$$
其真解为

$$
u\left( x, t \right) = 
\begin{cases}
   1, & x \leqslant t,~t \geqslant 0\\
   1 - x + t,  & t < x \leqslant t + 1,~t \geqslant 0\\
   x - t - 1,  &x > t + 1,~t \geqslant 0
\end{cases}
$$ 


注意，这里 $$a=1>0$$, 程序考虑实现如下格式：

* 迎风格式
$$
\frac{u_{j}^{n+1}-u_{j}^{n}}{\tau}+a \frac{u_{j}^{n}-u_{j-1}^{n}}{h}=0
$$ 
截断误差为 $$O(\tau + h)$$, 稳定的充要条件为 $$ a\geq 0, \left|\frac{a\tau}{h}\right| \leq 1.$$ 
$$
\frac{u_{j}^{n+1}-u_{j}^{n}}{\tau}+a \frac{u_{j+1}^{n}-u_{j}^{n}}{h}=0
$$
截断误差为 $$O(\tau + h)$$, 稳定的充要条件为 $$a\leq 0, \left|\frac{a\tau}{h}\right| \leq 1.$$ 

* 中心格式 
$$
\frac{u_{j}^{n+1}-u_{j}^{n}}{\tau}+a \frac{u_{j+1}^{n}-u_{j-1}^{n}}{2 h}=0
$$ 
该格式恒不稳定。

* Lax-Friedrichs 格式
$$
\frac{u_{j}^{n+1}-\frac{1}{2}\left(u_{j+1}^{n}+u_{j-1}^{n}\right)}{\tau}+
a \frac{u_{j+1}^{n}-u_{j-1}^{n}}{2 h}=0
$$ 
其截断误差为 $$O(\tau + h^2)$$， 其稳定的允要条件为 $$\left|\frac{a\tau}{h}\right| \leq 1.$$

* 迎风格式的带粘性项的表达形式
$$
\frac{u_{j}^{n+1}-u_{j}^{n}}{\tau}+a \frac{u_{j+1}^{n}-u_{j-1}^{n}}{2 h}=
\frac{h}{2} a \frac{u_{j+1}^{n}-2 u_{j}^{n}+u_{j-1}^{n}}{h^{2}}
$$

* 隐式迎风格式
$$
\left\{
\begin{array}{l}{\frac{u_{j}^{n+1}-u_{j}^{n}}{\tau}+
a \frac{u_{j}^{n+1}-u_{j-1}^{n+1}}{h}=0, \quad a \geqslant 0} \\ 
{\frac{u_{j}^{n+1}-u_{j}^{n}}{\tau}+a \frac{u_{j+1}^{n+1}-u_{j}^{n+1}}{h}=0, \quad a<0}
\end{array}\right.
$$
恒稳定，其截断误差为 $$O(\tau + h)$$.

* 隐式中心格式
$$
\frac{u_{j}^{n+1}-u_{j}^{n}}{\tau} + a\frac{u_{j+1}^{n+1}-u_{j-1}^{n+1}}{2 h} = 0
$$ 
恒稳定，其截断误差为 $$O(\tau + h^2)$$.

* 跳蛙格式(Leap-frog)
$$
\frac{u_{j}^{n+1}-u_{j}^{n-1}}{2 \tau}+a \frac{u_{j+1}^{n}-u_{j-1}^{n}}{2 h}=0
$$ 
其截断误差为 $$O(\tau^2) + O(h^2)$$, 其稳定的允要条件为
$$\left|\frac{a\tau}{h}\right| \leq 1$$.

* Lax-Wendroff 格式
$$
u_{j}^{n+1}=u_{j}^{n}-\frac{1}{2} a \frac{\tau}{h}\left(u_{j+1}^{n}-u_{j-1}^{n}\right)+\frac{1}{2}\left(a \frac{\tau}{h}\right)^{2}\left(u_{j+1}^{n}-2 u_{j}^{n}+u_{j-1}^{n}\right)
$$ 
其截断误差为 $$O(\tau^2) + O(h^2)$$, 其稳定的允要条件为
$$\left|\frac{a\tau}{h}\right| \leq 1$$.

## Matlab 实现代码 

```matlab
function pde = model_data(t0, t1, x0, x1)
% MODEL_DATA 模型数据

pde = struct(...
    'solution', @solution, ...
    'init_solution', @init_solution,...
    'left_solution', @left_solution, ...
    'time_grid', @time_grid, ...
    'space_grid', @space_grid, ...
    'a', @a);

    function [T, tau] = time_grid(NT)
        T = linspace(t0, t1,NT+1);
        tau = (t1 - t0)/NT;
    end

    function [X, h] = space_grid(NS)
        X = linspace(x0, x1, NS+1)';
        h = (x1 - x0)/NS;
    end

    function U = solution(X, T)
      [x,t] = meshgrid(X,T);
      U = zeros(size(x));
      case1 = (x <= t);
      case2 = (x > t+1);
      case3 = ~case1 & ~case2;
      U(case1) = 1;
      U(case3) = 1-x(case3)+t(case3);
      U(case2) = x(case2) - t(case2) -1;
      U = U';
    end

    function u = init_solution(x)
        u = abs(x-1);
    end

    function u = left_solution(t)
        u = ones(size(t));
    end

    function val = a()
        val = 1;
    end
end
```

```matlab
%% 一维双曲方程有限差分方法主测试脚本 main_test.m
%   依次测试：
%       显格式 
%       隐格式
%   并可视化数值计算结果。
%
% 作者：魏华祎 <weihuayi@xtu.edu.cn> 

pde = model_data(0, 4, 0, 2); %模型数据结构体

% 迎风显格式
[X, T, U] = advection_fd1d(100, 200, pde, 'explicity');
UE = pde.solution(X, T);
showvarysolution(X, T, U, UE);% 以随时间变化方式显示数值解
showsolution(X, T, U); % 以二元函数方式显示数值解

% 反迎风显格式
[X, T, U] = advection_fd1d(100, 200, pde, 'inv explicity');
UE = pde.solution(X, T);
showvarysolution(X, T, U, UE);% 以随时间变化方式显示数值解

% 显式中心格式
[X, T, U] = advection_fd1d(100, 200, pde, 'explicity center');
UE = pde.solution(X,  T);
showvarysolution(X,  T, U, UE);% 以随时间变化方式显示数值解

% 显式lax格式
[X, T, U] = advection_fd1d(100, 200, pde, 'explicity lax');
UE = pde.solution(X, T);
showvarysolution(X, T, U, UE);% 以随时间变化方式显示数值解

% 隐格式
[X, T, U] = advection_fd1d(100, 200, pde, 'implicity');
UE = pde.solution(X, T);
showvarysolution(X, T, U, UE);% 以随时间变化方式显示数值解
showsolution(X, T, U); % 以二元函数方式显示数值解
```


```matlab
function [X,T,U] = advection_fd1d(NS,NT,pde,method)
%% WAVE_EQUATION_FD1D 利用有限差分方法计算一维双曲方程
%   
%   输入参数：
%       NS 整型，空间剖分段数.
%       NT 整型，时间剖分段数.
%       pde 结构体，待求解的微分方程模型的已知数据，
%                  如边界、初始、系数和右端项等条件.
%       method 字符串，代表求解所用格式
%           'explicity' 或 'e' 或 'E' ：显式迎风格式
%           'inv explicity'或 'inve' 或 'invE': 反显式迎风格式
%           'implicity' 或 'i' 或 'I' : 隐式迎风格式
%           'inv implicity' 或 'invi' 或 'invI', 反隐式迎风格式
%           'explicity center' 或 'ec' 或 'EC' : 显式中心格式
%           'implicity center' 或 'ic' 或 'IC': 隐式中心格式
%           'explicity lax' 或 'el' 或 'EL': 显式 Lax 格式
%           'explicity laxw' 或 'elw' 或 'ELW': 显式 Lax windroff 格式 
%           'leap frog' 或 'lf' 或 'LF' : 跳蛙格式
%   输出参数：
%       X 长度为 NS+1 的列向量，空间网格剖分
%       T 长度为 NT+1 的行向量，时间网格剖分
%       U (NS+1)*(NT+1) 矩阵，U(:,i) 表示第 i 个时间层网格部分上的数值解
%
%   作者：魏华祎 <weihuayi@xtu.edu.cn>

[X, h] = pde.space_grid(NS);
[T, tau] = pde.time_grid(NT);
N = length(X);
M = length(T);


U = zeros(N, M);
% 初值条件
U(:, 1) = pde.init_solution(X); 
a = pde.a();
r = a*tau/h;
% 边值条件
if a >= 0 % 左边值条件
   U(1, :) = pde.left_solution(T);  
else
   U(end, :) = pde.right_solution(T); %右边值条件
end



%% 
switch(method)
    case {'explicity','e','E'}
        explicity();
    case {'inv explicity','inve','invE'}
        inv_explicity();
    case {'explicity lax','el','EL'}
        explicity_lax();
    case {'explicity laxw','elw','ELW'}
        explicity_laxw();
    case {'implicity','i','I'}
        implicity();
    case {'inv implicity','invi','invI'}
        inv_implicity();
    case {'explicity center', 'ec','EC'}
        explicity_center();
    case {'implicity center', 'ic','IC'}
        implicity_center();
    case {'leap frog','lf','LF'}
        leap_frog();
    otherwise
        disp(['Sorry, I do not know your ', method]);
end

    function explicity()
        for i = 2:M
           if a > 0
               U(2:end, i) = U(2:end, i-1) - r*(U(2:end, i-1) - U(1:end-1, i-1));
           else
               U(1:end-1, i) = U(1:end-1, i-1) - r*(U(2:end, i-1) - U(1:end-1, i-1));
           end
        end    
    end

    function inv_explicity()
        for i = 2:M
           if a > 0
               U(2:end-1, i) = U(2:end-1, i-1) - r*(U(3:end, i-1)-U(2:end-1, i-1));
               U(end, i) = 2*U(end-1, i)-U(end-2, i);
           else
               U(2:end-1, i) = U(2:end-1, i-1) - r*(U(2:end-1, i-1) - U(1:end-2, i-1));
               U(1, i) = 2*U(2, i) - U(3, i);
           end
        end    
    end

    function explicity_lax()
        for i = 2:M
           U(2:end-1, i) = (U(1:end-2, i) + U(3:end, i-1))/2 - r*(U(3:end, i-1)-U(1:end-2, i-1))/2;
           if a > 0
               U(end, i) = 2*U(end-1, i)-U(end-2, i);
           else
               U(1, i) = 2*U(2, i) - U(3, i);
           end
        end    
    end

    function explicity_laxw()
        for i = 2:M
           U(2:end-1, i) = (U(1:end-2, i) + U(3:end, i-1))/2 - r*(U(3:end, i-1)-U(1:end-2, i-1))/2;
           if a > 0
               U(end, i) = 2*U(end-1, i)-U(end-2, i);
           else
               U(1, i) = 2*U(2, i) - U(3, i);
           end
        end    
    end

    function implicity()
        if a > 0
            d = (1+r)*ones(N-1, 1);
            c = -r*ones(N-2, 1);
            A = diag(d) + diag(c, -1);
            for i = 2:M
                F = zeros(N-1, 1);
                F(1) = r*U(1, i);
                U(2:end, i) = A\(U(2:end, i-1)+F);
            end
        else
            d = (1-r)*ones(N-1, 1);
            c = r*ones(N-2, 1);
            A = diag(d) + diag(c, 1);
            for i = 2:M
                F = zeros(N-1, 1);
                F(end) = -r*U(end, i);
                U(1:end-1, i) = A\(U(1:end-1, i-1)+F);
            end
        end
    end
    function explicity_center()
        for i = 2:M
            U(2:end-1, i) = U(2:end-1, i-1) - r*(U(3:end, i-1)-U(1:end-2, i-1))/2;
            if a > 0
                U(end, i) = 2*U(end-1, i)-U(end-2, i);
            else
                U(1, i) = 2*U(2, i) - U(3, i);
            end
        end
    end

    function implicity_center()
        
    end

    function leap_frog()
        
    end

end
```

```matlab
function showsolution(X,T,U)
%%  SHOWSOLUTION  以二元函数方式显示数值解
% 
%  输入参数：
%       X 长度为N的列向量，空间网格剖分
%       T 第度为M的行向量，时间网格剖分
%       U N*M 矩阵，U(:,i) 表示第  i 个时间层网格部分上的数值解
%
%   作者：魏华祎 <weihuayi@xtu.edu.cn>

[x,t] = meshgrid(X,T);
mesh(x,t,U');
xlabel('X');
ylabel('T');
zlabel('U(X,T)');

end
```


```
function showvarysolution(X,T,U,UE)
%%  SHOWVARYSOLUTION  显示数值解随着时间的变化
% 
%  输入参数：
%       X 长度为N的列向量，空间网格剖分
%       T 第度为M的行向量，时间网格剖分
%       U N*M 矩阵，U(:,i) 表示第  i 个时间层网格上的数值解
%       UE N*M 矩阵，UE(:,i) 表示第 i 个时间层网格上的数值解
%   作者：魏华祎 <weihuayi@xtu.edu.cn>

M = size(U,2);
figure
xlabel('X');
ylabel('U');
s = [X(1),X(end),min(min(U)),max(max(U))];
axis(s);
for i = 1:M
   if nargin < 4
      plot(X,U(:,i),'-b+');
   else 
      plot(X,U(:,i),'-b+',X,UE(:,i),'-rs');
   end
   axis(s);
   pause(0.01);
   title(['T=',num2str(T(i)),' 时刻的温度分布'])
end
```

## 实验报告
利用 Lax-Wendroff 格式求解方程

$$
\begin{array}{l}
{u_{t}-2 u_{x}=0, \quad x \in(0,1), \quad t>0} \\ 
{u(x, 0)=1+\sin 2 \pi x, \quad x \in[0,1]} \\ 
{u(1, t)=1+\sin 4 \pi t}
\end{array}
$$ 

该方程的精确解为

$$
u = 1 + \sin 2\pi(x + 2t).
$$ 

数值边值条件分别取下面三种类型

$$
\begin{array}{l}
{\text { (a) } u_{0}^{n+1}=u_{0}^{n}+\frac{2 \tau}{h}\left(u_{1}^{n}-u_{0}^{n}\right)} \\
{\text { (b) } u_{0}^{n}=u_{1}^{n}} \\ 
{\text { (c) } u_{0}^{n+1}-2 u_{1}^{n+1}+u_{2}^{n+1}=0}\end{array}
$$

画图与真解进行比较。 


