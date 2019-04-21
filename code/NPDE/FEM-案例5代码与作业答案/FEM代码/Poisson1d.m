function uh = Poisson1d(node, elem, pde, bdFlag,option)
%% POISSON1D solve 1d Poisson equation by P1 linear element.
%
%  uh = Poisson1d(node,elem,pde, bdFlag) produces linear 
%  finite element approximation of 1d Poisson equation.

N = size(node,1); NT = size(elem,1); Ndof = N;
%% Compute geometric quantities and gradient of local basis
lens = node(elem(:,2))-node(elem(:,1));
Dphi = [-1./lens,1./lens];

%% Assemble stiffness matrix
A = sparse(Ndof,Ndof);
for i = 1:2
    for j = i:2
        Aij = Dphi(:,i).*Dphi(:,j).*lens;
        if (j==i)
            A = A + sparse(elem(:,i), elem(:,j),Aij,Ndof,Ndof);
        else
            A = A + sparse([elem(:,i);elem(:,j)],[elem(:,j);elem(:,i)],...
                [Aij; Aij],Ndof,Ndof);
        end
    end
end

%% Assemble the right hand side
[lambda,weight] = quadpts1d(option.fQuadOrder);
nQuad = length(weight);
phi = lambda;
bt = zeros(NT,2);
for i = 1:nQuad
    px = node(elem(:,1))*phi(i,1) + node(elem(:,2))*phi(i,2);
    fp = pde.f(px);
    for k = 1:2
        bt(:,k) = bt(:,k) + weight(i)*fp.*phi(i,k);
    end
end
bt = bt.*repmat(lens,1,2);
b = accumarray(elem(:),bt(:),[Ndof 1]);
clear bt px;

%% modify left-hand vector
isFixed = bdFlag;
isFree = ~isFixed;
uh = zeros(Ndof,1);
uh(isFixed) = pde.g_D(node(isFixed));
b = b - A*uh;

%% solve 
uh(isFree) = A(isFree,isFree)\b(isFree);
