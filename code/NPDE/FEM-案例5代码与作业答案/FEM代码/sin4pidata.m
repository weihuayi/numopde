function pde = sin4pidata( )
%% SINDATA
%
%  u = sin(4*pi*x)
%  f = 16*pi*pi*sin(4*pi*x)
%  Du = 4*pi*cos(4*pi*x)
%

pde = struct('f',@f,'exactu',@exactu,'g_D',@g_D,'Du',@Du);

% right hand side function
function z = f(p)
    x = p;
    z = 16*pi*pi*sin(4*pi*x);
end
% exact solution
function z = exactu(p)
    x = p;
    z = sin(4*pi*x);
end
% Dirichlet boundary condition
function z = g_D(p)
    x = p;
    z = exactu(p);
end
% Derivative of the exact solution
function z = Du(p)
    x = p;
    z = 4*pi*cos(4*pi*x);
end

end 