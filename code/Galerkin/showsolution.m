function showsolution(uh,varargin)

n = length(uh);
x = 0:0.01:1;
[v,~] = basis(x,n);
y = v'*uh;
plot(x,y,varargin{:});