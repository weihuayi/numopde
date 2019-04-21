function [Dphi,len] = gradbasis1d(node,elem)

len = node(elem(:,2))-node(elem(:,1));
Dphi = [-1./len,1./len];