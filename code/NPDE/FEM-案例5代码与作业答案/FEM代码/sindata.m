function pde = sindata( )
%% SINDATA
%
%  u = sin(pi*x)
%  f = pi*pi*sin(pi*x)
%  Du = pi*cos(pi*x)
%

pde = struct('f',@f,'exactu',@exactu,'g_D',@g_D,'Du',@Du);

% right hand side function
function z = f(p)
    x = p;
    z = pi*pi*sin(pi*x);
end
% exact solution
function z = exactu(p)
    x = p;
    z = sin(pi*x);
end
% Dirichlet boundary condition
function z = g_D(p)
    x = p;
    z = exactu(p);
end
% Derivative of the exact solution
function z = Du(p)
    x = p;
    z = pi*cos(pi*x);
end

end 