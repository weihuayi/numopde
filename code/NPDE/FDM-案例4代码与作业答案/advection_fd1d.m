function [X,T,U] = advection_fd1d(NS,NT,pde,method)
%% WAVE_EQUATION_FD1D 利用有限差分方法计算一维双曲方程
%   
%   输入参数：
%       NS 整型，空间剖分段数.
%       NT 整型，时间剖分段数.
%       pde 结构体，待求解的微分方程模型的已知数据，
%                  如边界、初始、系数和右端项等条件.
%       method 字符串，代表求解所用格式
%           'explicity' 或 'e' 或 'E' ：显式迎风格式
%           'implicity' 或 'i' 或 'I' : 隐式迎风格式
%           'explicity center' 或 'ec' 或 'EC' : 显式中心格式
%           'implicity center' 或 'ic' 或 'IC': 隐式中心格式
%           'leap frog' 或 'lf' 或 'LF' : 跳蛙格式
%   输出参数：
%       X 长度为 NS+1 的列向量，空间网格剖分
%       T 长度为 NT+1 的行向量，时间网格剖分
%       U (NS+1)*(NT+1) 矩阵，U(:,i) 表示第 i 个时间层网格部分上的数值解
%
%   作者：魏华祎 <weihuayi@xtu.edu.cn>

[X,h] = pde.space_grid(NS);
[T,tau] = pde.time_grid(NT);
N = length(X);M = length(T);


U = zeros(N,M);
% 初值条件
U(:,1) = pde.u_initial(X); 
a = pde.a;
r = a*tau/h;
% 边值条件
if a >= 0 % 左边值条件
   U(1,:) = pde.u_left(T);  
else
   U(end,:) = pde.u_right(T); %右边值条件
end



%% 
switch(method)
    case {'explicity','e','E'}
        explicity();
    case {'implicity','i','I'}
        implicity();
    case {'explicity center', 'ec','EC'}
        explicity_center();
    case {'implicity center', 'ic','IC'}
        implicity_center();
    case {'leap frog','lf','LF'}
        leap_frog();
    otherwise
        disp(['Sorry, I do not know your ', method]);
end

    function explicity()
        for i = 2:M
           if a > 0
               U(2:end,i) = U(2:end,i-1) - r*(U(2:end,i-1) - U(1:end-1,i-1));
           else
               U(1:end-1,i) = U(1:end-1,i-1) - r*(U(2:end,i-1) - U(1:end-1,i-1));
           end
        end    
    end

    function implicity()
        if a > 0
            d = (1+r)*ones(N-1,1);
            c = -r*ones(N-2,1);
            A = diag(d) + diag(c,-1);
            for i = 2:M
                F = zeros(N-1,1);
                F(1) = r*U(1,i);
                U(2:end,i) = A\(U(2:end,i-1)+F);
            end
        else
            d = (1-r)*ones(N-1,1);
            c = r*ones(N-2,1);
            A = diag(d) + diag(c,1);
            for i = 2:M
                F = zeros(N-1,1);
                F(end) = -r*U(end,i);
                U(1:end-1,i) = A\(U(1:end-1,i-1)+F);
            end
        end
    end
    function explicity_center()

    end
    function implicity_center()
        
    end
    function leap_frog()
        
    end


end
