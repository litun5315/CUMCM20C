function   fitness=evaluateF(X,F_index);

[N,dim]=size(X);
for i=1:N 
    L=X(i,:); 
    fitness(i)=test_functions(L,F_index,dim);
end