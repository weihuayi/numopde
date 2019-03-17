%% 测试脚本 FD1d_bvp_test.m

clear all
close all
 
 % 初始化相关数据
NS = [5, 10, 20, 40, 80];
L = 0;
R = 1;

model = model_data(L, R);

emax = zeros(5,1);
e0 = zeros(5,1);
e1 = zeros(5,1);

%% 求解并计算误差
for i = 1:5
    [uh, x] = FD1d_bvp(model, NS(i));
    [e0(i), e1(i), emax(i)]=FD1d_error(model.solution, uh, x);
    X{i} = x;
    U{i} = uh;
end

u = model.solution(X{5});

%% 显示真解及不同网格剖分下的数值解
plot(X{5}, u, '-k*', X{1}, U{1}, '-ro', X{2},...
    U{2}, '-gs', X{3}, U{3}, '-bd',...
    X{4}, U{4}, '-ch', X{5}, U{5},'-mx');
title('The solution plot');
xlabel('x');  ylabel('u');
legend('exact','NS=5','NS=10','NS=20','NS=40','NS=80');

%% 显示误差
format shorte
disp('     emax           e0          e1');
disp([emax, e0, e1]);
  
  
 

