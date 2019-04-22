j 一维热传导问题的有限差分算法实现

## 算法描述

## Matlab 实现

$$
\begin{aligned}
&\frac{\partial u}{\partial t}-a\frac{\partial^2u}{\partial x^2}=0,\\
& u(0,t)=0,\quad u(1,t)=0,\\
& u(x,0)=e^{-\frac{(x-0.25)^2}{0.01}} + 0.1\sin(20\pi x).
\end{aligned}
$$

其中系数 $$a=1$$。

1) 首先定义模型数据

```matlab
function pde = model_data(t0, t1, l, r)
% 一维热传导问题的数学模型

pde = struct('init_solution',@init_solution,'left_solution',@left_solution,...
    'right',@right_solution,'source',@source,'time_grid',@time_grid,...
    'space_grid',@space_grid,'a',@a);

    function [T,tau] = time_grid(NT)
    %% 时间方向的网格离散
        T = linspace(t0, t1,NT+1);
        tau = 0.1/NT;
    end

    function [X,h] = space_grid(NS)
    %% 空间方向的网格离散
        X = linspace(l, r, NS+1)';
        h = 1/NS;
    end

    function u = init_solution(x)
    %% 模型真解的初值条件
        u = exp(-(x-0.025).^2/0.01)+0.1*sin(20*pi*x);
    end

    function u = left_solution(t)
    %% 模型左端边值条件
        u = zeros(size(t));
    end

    function u = right_solution(t)
    %% 模型右端边值条件
        u = zeros(size(t));
    end

    function f = source(x,t)
    %% 模型右端项
        f = zeros(size(x));
    end

    function a = a()
        a = 1;
    end
end
```

2) 编写测试框架

```matlab
%% 一维热传导方程有限差分方法主测试脚本 main_test.m
%   测试流程如下：
%   1. 向前差分
%   1. 向后差分
%   1. 六点对称格式
%   1. 可视化数值计算结果。
%
% 作者：魏华祎 <weihuayi@xtu.edu.cn> 

pde = model_data(0, 0.1, 0, 1); %模型数据结构体

% 向前差分格式
[X,T,U] = heat_equation_fd1d(100,10000,pde,'forward');
showvarysolution(X,T,U);% 以随时间变化方式显示数值解
showsolution(X,T,U); % 以二元函数方式显示数值解

% 向后差分格式
[X,T,U] = heat_equation_fd1d(100,100,pde,'backward');
showvarysolution(X,T,U);% 以随时间变化方式显示数值解
showsolution(X,T,U); % 以二元函数方式显示数值解

% 六点对称格式，即 Crank-Nicholson 格式
[X,T,U] = heat_equation_fd1d(100,100,pde,'crank-nicholson');
showvarysolution(X,T,U);% 以随时间变化方式显示数值解
showsolution(X,T,U); % 以二元函数方式显示数值解
```

3) 实现核心算法

```matlab
function [X,T,U] = heat_equation_fd1d(NS,NT,pde,method)
%% HEAT_EQUATION_FD1D 利用有限差分方法计算一维热传导方程
%   
%   输入参数：
%       NS 整型，空间剖分段数
%       NT 整型，时间剖分段数
%       pde 结构体，待求解的微分方程模型的已知数据，
%                  如边界、初始、系数和右端项等条件
%       method 字符串，代表求解所用离散格式
%           F 或 f 或 forward ： 向前差分格式
%           B 或 b 或 backward ： 向后差分格式
%           CN 或 cn 或 crank-nicholson 或 Crank-Nicholson ：
%                      -- 六点对称格式( Crank-Nicholson 格式)
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

r = pde.a()*tau/h/h;
if r >= 0.5 && ismember(method, {'F','f','forward'})
    error('时间空间离散不满足向前差分的稳定条件！')
end

U = zeros(N,M);
U(:,1) = pde.init_solution(X);
U(1,:) = pde.left_solution(T);
U(end,:) = pde.right_solution(T);
switch(method)
    case {'F','f','forward'}
        forward();
    case {'B','b','backward'}
        backward();
    case {'CN','cn','crank-nicholson','Crank-Nicholson'}
        crank_nicholson();
    otherwise
        disp(['Sorry, I do not know your ', method]);
end

%% 子函数, 实现不同的差分格式

function forward()
%% 向前差分方法
    d = 1 - 2*ones(N-2,1)*r;
    c = ones(N-3,1)*r;
    A = diag(c,-1) + diag(c,1)+diag(d);
    for i = 2:M
        RHS = tau*pde.source(X,T(i));
        RHS(2) = RHS(2) + r*U(1,i-1);
        RHS(end-1) = RHS(end-1) + r*U(end,i-1);
        U(2:end-1,i)=A*U(2:end-1,i-1)+ RHS(2:end-1);
    end
end

function backward()
%% 向后差分方法
    d = 1 + 2*ones(N-2,1)*r;
    c = -ones(N-3,1)*r;
    A = diag(c,-1) + diag(c,1)+diag(d);    
    for i = 2:M
        RHS = tau*pde.source(X,T(i));
        RHS(2) = RHS(2) + r*U(1,i);
        RHS(end-1) = RHS(end-1) + r*U(end,i);
        U(2:end-1,i)=A\(U(2:end-1,i-1)+ RHS(2:end-1));
    end 
end

function crank_nicholson()
%% 六点对称格式， 即 Crank_Nicholson 格式
    d1 = 1 + ones(N-2,1)*r;
    d2 = 1 - ones(N-2,1)*r;
    c = 0.5*ones(N-3,1)*r;
    A1 = diag(-c,-1) + diag(-c,1)+diag(d1);  
    A0 = diag(c,-1) + diag(c,1) + diag(d2);
    for i = 2:M
        RHS = tau*pde.source(X,T(i));
        RHS(2) = RHS(2) + 0.5*r*(U(1,i)+U(1,i-1));
        RHS(end-1) = RHS(end-1) + ...
            0.5*r*(U(end,i)+U(end,i-1));
        U(2:end-1,i)=A1\(A0*U(2:end-1,i-1)+ RHS(2:end-1));
    end 
end

end
```

4) 编写可视化函数

```Matlab
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

```matlab
function showvarysolution(X,T,U)
%%  SHOWVARYSOLUTION  显示数值解随着时间的变化
% 
%  输入参数：
%       X 长度为N的列向量，空间网格剖分
%       T 第度为M的行向量，时间网格剖分
%       U N*M 矩阵，U(:,i) 表示第  i 个时间层网格部分上的数值解
%
%   作者：魏华祎 <weihuayi@xtu.edu.cn>   

M = size(U,2);
figure
xlabel('X');
ylabel('U');
s = [X(1),X(end),min(min(U)),max(max(U))];
axis(s);
for i = 1:M
   plot(X,U(:,i));
   axis(s);
   pause(0.0001);
   title(['T=', num2str(T(i)), ' 时刻的温度分布'])
end
```

## 上机实践

用向前差分求解下面热传导方程模型, 并编写最大模误差的计算函数，观察最大模误差的变
化规律。

$$
\begin{cases}
&\frac{\partial u}{\partial t}-a\frac{\partial^2u}{\partial x^2}=f(x,t),\\
& u(L,t)=u_L(x),\quad u(R,t)=u_R(x),\\
& u(x,0)=u_0(x).
\end{cases}
$$

其中, 
* 空间区间为 $$[L, R]=[0, 1]$$;
* 时间区间 $$[0, 0.1]$$;
* 热传导系数为 $$a = 1$$;
* 真解 $$ u(x,t) = \sin(2\pi x)e^{10t}$$

把真解代入上面模型, 即可得到相关的参数.

最大模误差定义如下：

$$ E = \max_{x_i,t_j}|u(x_i,t_j) - U(i,j)| $$

即**所有网格点处数值解和真解误差绝对值的最大值**, 最大模误差 $$E$$ 与时间步长
$$\tau$$ 和空间步长 $$h$$ 满足如下关系：

$$ E = O(\tau+h^2) $$

所以，当 $$\tau$$ 变为 $$\tau \over 4$$, $$h$$ 变为 $$h \over 2$$ 时， $$E$$ 应变为 $$E
\over 4$$。

