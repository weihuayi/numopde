%% 一维双曲方程有限差分方法主测试脚本 main_test.m
%   依次测试：
%       显格式 
%       隐格式
%   并可视化数值计算结果。
%
% 作者：魏华祎 <weihuayi@xtu.edu.cn> 

pde = model_data(0, 4, 0, 1); %模型数据结构体
[X,T,U] = advection_fd1d(50, 400, pde, 'elw');
UE = pde.solution(X, T);
disp(max(abs(U(:) - UE(:))));
%showvarysolution(X, T, U, UE);

