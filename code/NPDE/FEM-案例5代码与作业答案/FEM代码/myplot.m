load solution10
showsolution1d(node,elem,uh,'-og')
hold on
load solution20
showsolution1d(node,elem,uh,'-sg')
hold on 
load solution40
showsolution1d(node,elem,uh,'-dr')
hold on
load solution80
showsolution1d(node,elem,pde.exactu(node),'-*k')