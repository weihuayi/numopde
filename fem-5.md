# Galerkin 算法设计、实现与数值实验


## 模型问题

考虑如下两点边值问题：

$$
\left\{
\begin{array}{l}
{L u :=u^{\prime \prime}+u=-x, \quad 0<x<1} \\ 
{u(0)=u(1)=0}
\end{array}\right.
$$ 

其真解为

$$
u(x)=\frac{\sin x}{\sin 1}-x
$$ 

令 
$$
H_{0}^{1}(I)=\left\{u \in H^{1}(I), u(0)=u(1)=0\right\},
$$ 

则上述问题的基于虚功方程的变分问题为： 求 $$u \in H_{0}^{1}(I)$$, 使得：

$$
a(u, v)=-(x, v), \forall v \in H_{0}^{1}(l)
$$ 

其中
$$
a(u, v)=(L u, v)=\int_{0}^{1}\left(-u^{\prime} v^{\prime}+u v\right) dx
$$ 

## 离散算法设计

记 $$\omega(x)=x(1-x)$$, 引入 $$H_0^1(I)$$ 的 $$n$$ 维近似子空间

$$
U_{n}=\left\{\phi_{1}, \cdots, \phi_{n}\right\},
\phi_{i}=\omega(x) x^{i-1}, i=1, \cdots, n
$$

上述问题可近似为：在空间 $$U_n$$ 中，找到一个近似解 

$$
u_{n}(x)=\sum_{i=1}^{n} c_{i} \phi_{i}(x)
$$

满足

$$
\sum_{j=1}^{n} a\left(\phi_{j}, \phi_{i}\right) c_{j}=
-\left(x, \phi_{i}\right), i=1,2, \cdots, n
$$


## 程序实现


### 模型数据

```matlab
function pde = model_data()
%% MODELDATA
%  u(x) = sin(x)/sin(1) - x
%  Du(x) = cos(x)/sin(1) -1 
%  f(x) = -x

pde = struct('solution', @solution, 'source',@source, 'gradient', @gradient);

%% 精确解
function z = solution(x)
z = sin(x)/sin(1) - x;
end
%% 右端项
function z = source(x)
z = -x;
end
%% 精确解梯度
function z = gradient(x)
z = cos(x)/sin(1) - 1;
end 
end 
```

### 数值积分点

```matlab

function [lambda,weight] = gquadpts1d(numPts)
%% QUADPTS1d quadrature points in 1-D.
%
% [lambda,weight] = QUADPTS1d(numPts) 
%
% Copyright (C) Long Chen. See COPYRIGHT.txt for details. 


if numPts > 10
   numPts = 10; 
end

switch numPts
    case 1
        A = [0      2.0000000000000000000000000];
        
    case 2
        A = [0.5773502691896257645091488 	1.0000000000000000000000000
        -0.5773502691896257645091488 	1.0000000000000000000000000];
        
    case 3
        A = [0 	0.8888888888888888888888889
            0.7745966692414833770358531 	0.5555555555555555555555556
            -0.7745966692414833770358531 	0.5555555555555555555555556];
        
    case 4
        A = [0.3399810435848562648026658 	0.6521451548625461426269361
            0.8611363115940525752239465 	0.3478548451374538573730639
            -0.3399810435848562648026658 	0.6521451548625461426269361
            -0.8611363115940525752239465 	0.3478548451374538573730639];
        
    case 5
        A = [0 	                            0.5688888888888888888888889
            0.5384693101056830910363144 	0.4786286704993664680412915
            0.9061798459386639927976269 	0.2369268850561890875142640
            -0.5384693101056830910363144 	0.4786286704993664680412915
            -0.9061798459386639927976269 	0.2369268850561890875142640];
        
    case 6
        A = [0.2386191860831969086305017 	0.4679139345726910473898703
            0.6612093864662645136613996 	0.3607615730481386075698335
            0.9324695142031520278123016 	0.1713244923791703450402961
            -0.2386191860831969086305017 	0.4679139345726910473898703
            -0.6612093864662645136613996 	0.3607615730481386075698335
            -0.9324695142031520278123016 	0.1713244923791703450402961];
        
    case 7
        A = [0 	                            0.4179591836734693877551020
            0.4058451513773971669066064 	0.3818300505051189449503698
            0.7415311855993944398638648 	0.2797053914892766679014678
            0.9491079123427585245261897 	0.1294849661688696932706114
            -0.4058451513773971669066064 	0.3818300505051189449503698
            -0.7415311855993944398638648 	0.2797053914892766679014678
            -0.9491079123427585245261897 	0.1294849661688696932706114];
        
    case 8
        A = [0.1834346424956498049394761 	0.3626837833783619829651504
            0.5255324099163289858177390 	0.3137066458778872873379622
            0.7966664774136267395915539 	0.2223810344533744705443560
            0.9602898564975362316835609 	0.1012285362903762591525314
            -0.1834346424956498049394761 	0.3626837833783619829651504
            -0.5255324099163289858177390 	0.3137066458778872873379622
            -0.7966664774136267395915539 	0.2223810344533744705443560
            -0.9602898564975362316835609 	0.1012285362903762591525314];
        
    case 9
        A = [0 	                            0.3302393550012597631645251
            0.3242534234038089290385380 	0.3123470770400028400686304
            0.6133714327005903973087020 	0.2606106964029354623187429
            0.8360311073266357942994298 	0.1806481606948574040584720
            0.9681602395076260898355762 	0.0812743883615744119718922
            -0.3242534234038089290385380 	0.3123470770400028400686304
            -0.6133714327005903973087020 	0.2606106964029354623187429
            -0.8360311073266357942994298 	0.1806481606948574040584720
            -0.9681602395076260898355762 	0.0812743883615744119718922];
        
    case 10
        A = [0.1488743389816312108848260 	0.2955242247147528701738930
            0.4333953941292471907992659 	0.2692667193099963550912269
            0.6794095682990244062343274 	0.2190863625159820439955349
            0.8650633666889845107320967 	0.1494513491505805931457763
            0.9739065285171717200779640 	0.0666713443086881375935688
            -0.1488743389816312108848260 	0.2955242247147528701738930
            -0.4333953941292471907992659 	0.2692667193099963550912269
            -0.6794095682990244062343274 	0.2190863625159820439955349
            -0.8650633666889845107320967 	0.1494513491505805931457763
            -0.9739065285171717200779640 	0.0666713443086881375935688];
end
lambda = (A(:,1)+1)/2;
weight = A(:,2)/2;
```

### 测试脚本

```matlab

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
```

### 有限维空间

```matlab
function [phi,gradPhi] = basis(x, n)
%% BASIS 计算 n 维空间的 n 个基函数在 [x_1, x_2, ..., x_m] 点处的函数值与梯度值
%
%  H_0^1([0,1]) 的 n 维近似子空间 w(x) = x*(1-x)，n 个基函数分别为： 
%          phi_i = w(x)*x^{i-1}, i = 1, 2,..., n
%
%  输入： 
%   x: 空间离散点
%   n: 空间维数 
%
%  输出： 
%   phi(1:n, 1:m): phi(i, j) 为第 i 个基函数在第 x_j 点处的函数值。 
%   gradPhi(1:n, 1:m): gradPhi(i, j) 为第 i 个基函数在 x_j 点处的导数值。 

m = length(x);
X = ones(n+1, 1)*x;
X = cumprod(X, 1);
phi = X(1:n,:) - X(2:end, :);
T = [ones(1, m);X(1:n-1, :)];
gradPhi = diag(1:n)*T - diag(2:n+1)*X(1:n, :);
```

### Galerkin 算法实现

```matlab
function uh = Galerkin(pde, I, n, option)
%% GALERKIN 组装矩阵  A 和右端向量 b， 并求解 
%
%   pde: 数据模型 
%   I : 模型区间 
%   n ：空间维数 

% 区间长度 
h = I(2) - I(1);

% 区间 [0,1] 上的 Gauss 积分点及权重 
[lambda, weight] = gquadpts1d(option.quadOrder);

% 积分点的个数
nQuad = length(weight); 

%% 构造矩阵 A 和 b
A = zeros(n,n);
b = zeros(n,1);
for q = 1:nQuad
  gx = lambda(q);
  w = weight(q);
  [phi, gradPhi] = basis(gx, n);
  A = A + (-gradPhi*gradPhi' + phi*phi')*w;
  b = b + pde.source(gx)*phi*w;
end
A = h*A;
b = h*b;

%% 求解
uh = A\b;
```


## 实验报告

用 Ritz-Galerkin 方法求边值问题

$$
\begin{cases}
 u''+u=x^2, & 0 < x < 1,\\
 u(0) = 0, u(1) = 1
 \end{cases}
$$

的第 $$n$$ 次近似 $$u_n(x)$$, 基函数为 $$\phi_i(x)=sin(i\pi x), i=1, 2,..., n$$。
并用表格列出 $$\frac{1}{4}$$, $$\frac{1}{2}$$, $$\frac{3}{4}$$
三点处的真解和 $$n=1, 2, 3, 4$$ 时的数值解。 该问题的真解为
$$
u(x) = 2\cos(x) + \frac{\left(2 - 2\cos(1)\right)\sin(x)}{\sin(1)} + x^2 - 2, \quad
x\in[0, 1]
$$ 



