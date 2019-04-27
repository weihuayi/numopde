function e = get_maxreeor_hlz(X,T,U,pde)


[x, t] = meshgrid(X, T);
u = pde.real_solution(x,t)';

[T ,tau] = pde.time_grid();
l = 0.5/tau + 1;
d = 0.5/tau;
r = l+3*d;

%e = max(abs(u(:,l:d:r)-U(:,l:d:r)));

disp([u(:, end), U(:, end)])

e = max(max(abs(u - U)));
