%jacobi迭代验证程序
A  = [4 -1 1;4 -8 1;-2 1 5];
b  = [7 -21 15]';
x = [0 0 0]'; 
tol = 1e-7;
[x, k] = jacobi(A, b, x, 1e-7);

% 打印迭代结果
fprintf('      x(1)             x(2)            x(3)\n');
fprintf('%12.8e   %12.8e    %12.8e\n', x);

% 画图
plot(1:k, x)
legend('x(1)=2', 'x(2)=4', 'x(3)=3')
ylim([0, 5])
title('Jacobi 迭代结果')

