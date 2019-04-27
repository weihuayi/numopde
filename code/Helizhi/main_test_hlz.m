%% 一维一维弦振动方程有限差分方法主测试脚本 main_test.m

t0 = 0;
t1 = 2;
x0 = 0;
x1 = 1;
NX = 1/0.1;
NT = 2/0.05;

pde = model_data_hlz(t0, t1, x0, x1, NT, NX); 

[X, T, U] = wave_equation_fd1d_hlz(pde);

e = get_maxreeor_hlz(X,T,U,pde);


show_solution_hlz(X,T,U,pde);
