function e = getmaxerror(X,T,U,u_exact)
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
ue = u_exact(x',t');
e = max(max(abs(ue - U)));