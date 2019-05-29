function [node, elem, bdFlag] = intervalmesh(a,b,h)
%% INTERVALMESH the uniform mesh on interval [a,b] with size h.
%
% node(1:N,1): node(i) is the coordinate of i-th
% mesh point.
%
% elem(1:NT,1:2): elem(j,1:2) are the indexes of the two end
% vertices of j-th elements.
%

node = a:h:b;
node = node';
N = length(node);
elem = [1:N-1;2:N];
elem = elem';
bdFlag = false(N,1);
bdFlag([1,N]) = true;
