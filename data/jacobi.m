function [x, k]=jacobi(A,b,x0,tol)
% jacobi 迭代法, 计算线性方程组的解
% tol 为输入误差容限, 迭代初值x0

    maxit = 300;  

    D=diag(diag(A));  
    L=-tril(A,-1); 
    U=-triu(A,1);
    B=D\(L+U);  
    f=D\b;

    n = length(x0);
    x = zeros(3, 300);
    x(:, 1) = x0;
    x(:, 2) = B*x(:, 1) + f;

    k=2; 
    while ((norm(x(:, k)-x(:, k-1))>=tol)&&(k<maxit))
        k = k + 1;
        x(:, k) =B*x(:, k-1) + f;  
    end
    x = x(:, 1:k);
end

