function showsolution1d(node, uh, varargin)
%% show the FEM solution
    
[node, I] = sort(node);
plot(node, uh(I), varargin{:});
    
