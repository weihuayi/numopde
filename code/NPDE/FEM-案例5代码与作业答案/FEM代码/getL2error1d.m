function err = getL2error1d(node,elem, exactu, uh, quadOrder)
%% GETL2ERROR1D L2 norm of approximation of linear fintie
%% element
%
% compute L2 error element-wise using quadrature rule with order
% quadOrder

NT = size(elem,1);
err = zeros(NT,1);
[lambda,weight] = quadpts1d(quadOrder);

% basis function at quadrature points
phi = lambda;

nQuad = length(weight);
for i = 1:nQuad
    uhp = uh(elem(:,1))*phi(i,1) + uh(elem(:,2))*phi(i,2);
    px = node(elem(:,1))*phi(i,1) + node(elem(:,2))*phi(i,2);
    err = err + weight(i)*(exactu(px) - uhp).^2;
end

lens = node(elem(:,2)) - node(elem(:,1));
err = err.*lens;
err = sqrt(sum(err));

