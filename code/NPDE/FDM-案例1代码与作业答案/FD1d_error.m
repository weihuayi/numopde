function [e0,e1,emax] = FD1d_error(x,U,u_exact)
%% FD1D_ERROR 计算有限差分误差
%
%
%  参数:
%    输入参数：
%	  x, 网格节点坐标向量
%       U，x上的有限差分数值解向量
%	  u_exact, 真解函数
%    输出参数：
%	  e0，L2范数误差
%       e1, H1范数误差
%       emax，L无穷范数误差

  N = length(x);
  h = (x(end) - x(1))/(N-1);
  ue=u_exact(x);% 真解在网格点x处的值
  ee=ue-U;
 
  e0 = h*sum(ee.^2);
  e1 = sum((ee(2:end)-ee(1:end-1)).^2)/h;
  e1 = e1+e0;
  
  e0 = sqrt(e0);
  e1 = sqrt(e1);
  emax=max(abs(ue-U));
end
 