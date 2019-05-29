function pde = sin4pidata( )
%% SINDATA
%
%  u = sin(4*pi*x)
%  f = 16*pi*pi*sin(4*pi*x)
%  Du = 4*pi*cos(4*pi*x)
%

pde = struct(...
    'source', @source, ...
    'solution', @solution, ...
    'dirichlet', @dirichlet, ...
    'grad_solution', @grad_solution);

% right hand side function
function z = source(p)
    x = p;
    z = 16*pi*pi*sin(4*pi*x);
end

function z = solution(p)
    x = p;
    z = sin(4*pi*x);
end

% Dirichlet boundary condition
function z = dirichlet(p)
    x = p;
    z = solution(p);
end

% Derivative of the exact solution
function z = grad_solution(p)
    x = p;
    z = 4*pi*cos(4*pi*x);
end

end 
