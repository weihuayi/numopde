function showsolution1d(node,elem, uh, varargin)
%%
%
    
NT = size(elem,1);
for i = 1:NT
    x = node(elem(i,:));
    y = uh(elem(i,:));
    plot(x,y,varargin{:});
    hold on
end
%axis equal; axis tight; 

hold off;
    
