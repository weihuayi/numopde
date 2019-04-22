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
