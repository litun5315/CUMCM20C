function [X,V]=move(X,a,V)

%movement.
[N,dim]=size(X);
V=rand(N,dim).*V+a; 
X=X+V; 