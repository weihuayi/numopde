function [X,T,U] = heat_equation_fd1d(NS,NT,pde,method)
%% HEAT_EQUATION_FD1D 利用有限差分方法计算一维热传导方程
%   
%   输入参数：
%       NS 整型，空间剖分段数
%       NT 整型，时间剖分段数
%       pde 结构体，待求解的微分方程模型的已知数据，
%                  如边界、初始、系数和右端项等条件
%       method 字符串，代表求解所用离散格式
%           F 或 f 或 forward ： 向前差分格式
%           B 或 b 或 backward ： 向后差分格式
%           CN 或 cn 或 crank-nicholson 或 Crank-Nicholson ：
%                      -- 六点对称格式( Crank-Nicholson 格式)
%   输出参数：
%       X 长度为 NS+1 的列向量，空间网格剖分
%       T 长度为 NT+1 的行向量，时间网格剖分
%       U (NS+1)*(NT+1) 矩阵，U(:,i) 表示第 i 个时间层网格部分上的数值解
%
%   作者：魏华祎 <weihuayi@xtu.edu.cn>

[X,h] = pde.space_grid(NS);
[T,tau] = pde.time_grid(NT);
N = length(X);M = length(T);
r = pde.a()*tau/h/h;
if r >= 0.5 && ismember(method,{'F','f','forward'})
    error('时间空间离散不满足向前差分的稳定条件！')
end
U = zeros(N,M);
U(:,1) = pde.u_initial(X);
U(1,:) = pde.u_left(T);
U(end,:) = pde.u_right(T);
switch(method)
    case {'F','f','forward'}
        forward();
    case {'B','b','backward'}
        backward();
    case {'CN','cn','crank-nicholson','Crank-Nicholson'}
        crank_nicholson();
    otherwise
        disp(['Sorry, I do not know your ', method]);
end
%% 向前差分方法
    function forward()
        d = 1 - 2*ones(N-2,1)*r;
        c = ones(N-3,1)*r;
        A = diag(c,-1) + diag(c,1)+diag(d);
        for i = 2:M
            RHS = tau*td.f(X,T(i));
            RHS(2) = RHS(2) + r*U(1,i-1);
            RHS(end-1) = RHS(end-1) + r*U(end,i-1);
            U(2:end-1,i)=A*U(2:end-1,i-1)+ RHS(2:end-1);
        end
    end
%% 向后差分方法
    function backward()
        d = 1 + 2*ones(N-2,1)*r;
        c = -ones(N-3,1)*r;
        A = diag(c,-1) + diag(c,1)+diag(d);    
        for i = 2:M
            RHS = tau*td.f(X,T(i));
            RHS(2) = RHS(2) + r*U(1,i);
            RHS(end-1) = RHS(end-1) + r*U(end,i);
            U(2:end-1,i)=A\(U(2:end-1,i-1)+ RHS(2:end-1));
        end 
    end
%% 六点对称格式， 即 Crank_Nicholson 格式
    function crank_nicholson()
        d1 = 1 + ones(N-2,1)*r;
        d2 = 1 - ones(N-2,1)*r;
        c = 0.5*ones(N-3,1)*r;
        A1 = diag(-c,-1) + diag(-c,1)+diag(d1);  
        A0 = diag(c,-1) + diag(c,1) + diag(d2);
        for i = 2:M
            RHS = tau*td.f(X,T(i));
            RHS(2) = RHS(2) + 0.5*r*(U(1,i)+U(1,i-1));
            RHS(end-1) = RHS(end-1) + ...
                0.5*r*(U(end,i)+U(end,i-1));
            U(2:end-1,i)=A1\(A0*U(2:end-1,i-1)+ RHS(2:end-1));
        end 
    end
end