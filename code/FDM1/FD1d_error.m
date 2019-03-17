function [e0, e1, emax] = FD1d_error(solution, uh, X)

NN = length(X);
h = (X(end) - X(1))/(NN -1);
u = solution(X);
ee= u - uh;

e0 = h*sum(ee.^2);
e1 = sum((ee(2:end)-ee(1:end-1)).^2)/h;
e1 = e1+e0;

e0 = sqrt(e0);
e1 = sqrt(e1);
emax=max(abs(ee));

end
 
