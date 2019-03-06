%jacobi迭代验证程序
A  = [4 -1 1;4 -8 1;-2 1 5];
b  = [7 -21 15]';
x0 = [0 0 0]'; 
tol = 1e-7;
x = jacobi(A, b, x0, 1e-7);
fprintf('      x(1)             x(2)            x(3)\n');
fprintf('%12.8e   %12.8e    %12.8e\n', x);

