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