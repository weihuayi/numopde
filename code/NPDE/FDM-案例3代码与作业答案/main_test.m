%% 一维一维弦振动方程有限差分方法主测试脚本 main_test.m
%   依次测试：
%       显格式 (theta = 0)
%       隐格式（theta = 0.5)
%   并可视化数值计算结果。
%
% 作者：魏华祎 <weihuayi@xtu.edu.cn> 

pde = model_data(); %模型数据结构体

% 显格式
[X,T,U] = wave_equation_fd1d(100,800,pde);
showvarysolution(X,T,U);% 以随时间变化方式显示数值解
showsolution(X,T,U); % 以二元函数方式显示数值解

% 隐格式
[X,T,U] = wave_equation_fd1d(100,400,pde,0.5);
showvarysolution(X,T,U);% 以随时间变化方式显示数值解
showsolution(X,T,U); % 以二元函数方式显示数值解

