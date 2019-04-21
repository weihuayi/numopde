function [N,errL2,errH1] = femtest1d() 
%% the initial data
h = 0.1;
a = 0;
b = 1;
pde = sin4pidata();
option.fQuadOrder = 3;
option.errQuadOder = 3;


maxIt = 5;
errL2 = zeros(maxIt,1);
errH1 = zeros(maxIt,1);
N = zeros(maxIt,1);

for i = 1:maxIt
    [node,elem, bdFlag] = intervalmesh(a,b,h/2^(i-1));
    uh = Poisson1d(node,elem,pde,bdFlag,option);
    N(i) = size(elem,1);
    
    name = ['solution' int2str(N(i))];
    save(name,'node','elem','uh');
    errL2(i) = getL2error1d(node,elem,pde.exactu,uh,option.errQuadOder);
    errH1(i) = getH1error1d(node,elem,pde.Du,uh,option.errQuadOder);
    
end


