function A = getstiffmatrix1d(node,elem,area)
% GETMASSMATRIX
N = size(node,1);
Dphi = [-1./area,1./area];
A = sparse(N,N);
for i = 1:2
    for j = i:2
        Aij = Dphi(:,i).*Dphi(:,j).*area;
        if (j==i)
            A = A + sparse(elem(:,i), elem(:,j),Aij,N,N);
        else
            A = A + sparse([elem(:,i);elem(:,j)],[elem(:,j);elem(:,i)],...
                [Aij; Aij],N,N);
        end
    end
end