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

