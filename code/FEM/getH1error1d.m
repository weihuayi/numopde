function err = getH1error1d(node, elem, grad_solution, uh, quadOrder)
%% GETH1ERROR1D H1 norm of approximation error of linear finite
%% element
% 
% compute H1 error element-wise using quadrature rule 
% with order quadOrder

NT = size(elem,1);
err = zeros(NT,1);
[lambda,weight] = quadpts1d(quadOrder);
phi = lambda;
lens = node(elem(:,2))-node(elem(:,1));
Dphi = [-1./lens,1./lens];

nQuad = length(weight);
Duh = uh(elem(:,1)).*Dphi(:,1) + uh(elem(:,2)).*Dphi(:,2);

for i = 1:nQuad
    px = node(elem(:,1))*phi(i,1) + node(elem(:,2))*phi(i,2);
    err = err + weight(i)*(grad_solution(px)-Duh).^2;
end
err = err.*lens;
err = sqrt(sum(err));

