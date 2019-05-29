# 一维有限元方法

## 模型问题

我们考虑如下一维 Poisson 方程的线性有限元求解算法
$$
-u''(x) = f(x), \text{ in } [0, 1],
$$ 
其中真解为 
$$
u = \sin(4\pi x).
$$ 

## 程序实现

### 测试模型数据

```matlab
function pde = sin4pidata( )
%% SINDATA
%
%  u = sin(4*pi*x)
%  f = 16*pi*pi*sin(4*pi*x)
%  Du = 4*pi*cos(4*pi*x)
%

pde = struct(...
    'source', @source, ...
    'solution', @solution, ...
    'dirichlet', @dirichlet, ...
    'grad_solution', @grad_solution);

% right hand side function
function z = source(p)
    x = p;
    z = 16*pi*pi*sin(4*pi*x);
end

function z = solution(p)
    x = p;
    z = sin(4*pi*x);
end

% Dirichlet boundary condition
function z = dirichlet(p)
    x = p;
    z = solution(p);
end

% Derivative of the exact solution
function z = grad_solution(p)
    x = p;
    z = 4*pi*cos(4*pi*x);
end

end 
```

### 数值积分公式

```Matlab
function [lambda, weight] = quadpts1d(order)
%% QUADPTS1 quadrature points in 1-D.
%

numPts = ceil((order+1)/2);

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
lambda1 = (A(:,1)+1)/2;
lambda2 = 1 - lambda1;
lambda = [lambda1, lambda2];
weight = A(:,2)/2;
```

### 网格生成

```matlab
function [node, elem, bdFlag] = intervalmesh(a,b,h)
%% INTERVALMESH the uniform mesh on interval [a,b] with size h.
%
% node(1:N,1): node(i) is the coordinate of i-th
% mesh point.
%
% elem(1:NT,1:2): elem(j,1:2) are the indexes of the two end
% vertices of j-th elements.
%

node = a:h:b;
node = node';
N = length(node);
elem = [1:N-1;2:N];
elem = elem';
bdFlag = false(N,1);
bdFlag([1,N]) = true;
```

### 测试脚本 

```matlab
%% 一维有限元测试函数 

h = 0.1;
a = 0;
b = 1;
pde = sin4pidata();
option.fQuadOrder = 3;
option.errQuadOder = 3;


maxIt = 5;
errL2 = zeros(maxIt,1);
errH1 = zeros(maxIt,1);
N = zeros(maxIt,1);

for i = 1:maxIt
    [node, elem, bdFlag] = intervalmesh(a,b,h/2^(i-1));
    uh = Poisson1d(node, elem, pde, bdFlag, option);
    N(i) = size(elem,1);
    hold on
    showsolution1d(node, uh);
    
    name = ['solution' int2str(N(i))];
    errL2(i) = getL2error1d(node, elem, pde.solution, uh, option.errQuadOder);
    errH1(i) = getH1error1d(node, elem, pde.grad_solution, uh, option.errQuadOder);
end

disp('L2 error:');
disp(errL2);

disp('H1 error:');
disp(errH1);
```

### 有限元算法实现

```matlab
function uh = Poisson1d(node, elem, pde, bdFlag,option)
%% POISSON1D solve 1d Poisson equation by P1 linear element.
%
%  uh = Poisson1d(node,elem,pde, bdFlag) produces linear 
%  finite element approximation of 1d Poisson equation.

N = size(node,1); NT = size(elem,1); Ndof = N;
%% Compute geometric quantities and gradient of local basis
lens = node(elem(:,2))-node(elem(:,1));
Dphi = [-1./lens,1./lens];

%% Assemble stiffness matrix
A = sparse(Ndof,Ndof);
for i = 1:2
    for j = i:2
        Aij = Dphi(:,i).*Dphi(:,j).*lens;
        if (j==i)
            A = A + sparse(elem(:,i), elem(:,j),Aij,Ndof,Ndof);
        else
            A = A + sparse([elem(:,i);elem(:,j)],[elem(:,j);elem(:,i)],...
                [Aij; Aij],Ndof,Ndof);
        end
    end
end

%% Assemble the right hand side
[lambda,weight] = quadpts1d(option.fQuadOrder);
nQuad = length(weight);
phi = lambda;
bt = zeros(NT,2);
for i = 1:nQuad
    px = node(elem(:,1))*phi(i,1) + node(elem(:,2))*phi(i,2);
    fp = pde.source(px);
    for k = 1:2
        bt(:,k) = bt(:,k) + weight(i)*fp.*phi(i,k);
    end
end
bt = bt.*repmat(lens,1,2);
b = accumarray(elem(:),bt(:),[Ndof 1]);
clear bt px;

%% modify left-hand vector
isFixed = bdFlag;
isFree = ~isFixed;
uh = zeros(Ndof,1);
uh(isFixed) = pde.dirichlet(node(isFixed));
b = b - A*uh;

%% solve 
uh(isFree) = A(isFree,isFree)\b(isFree);
```


## 实验报告

用线性有限元方法求边值问题：

$$
\begin{cases}
 -u''(x) + u(x) = f(x) \text{ in } 0 < x < 1,\\
 u(0) = u(1) = 0
\end{cases}
$$

其中真解为
$$
u = e^x\sin(2\pi x)
$$ 

网格单元长度分别取为 $$[0.4, 0.2, 0.1, 0.05, 0.025, 0.0125]$$，用线性有限元求解
，计算有限元解与真解的 $$L^2$$ 误差

$$
\|u - u_h\|_{0} := \sqrt{\int_0^1 (u - u_h)^2\mathrm d x}
$$ 

和 $$H^1$$ 误差。

$$
\|u' - u_h'\|_{0} := \sqrt{\int_0^1 (u' - u_h')^2\mathrm d x}
$$ 

