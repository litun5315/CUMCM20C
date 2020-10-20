function  X=space_bound(X,up,low);

[N,dim]=size(X);
for i=1:N 

    Tp=X(i,:)>up;Tm=X(i,:)<low;X(i,:)=(X(i,:).*(~(Tp+Tm)))+((rand(1,dim).*(up-low)+low).*(Tp+Tm));
end
