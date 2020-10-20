% This function calculates the value of the objective function.
function fit=test_functions(L,F_index,dim)

%Insert your own objective function with a new F_index.

if F_index==-1
fit=sum(L.^2);
end


if F_index==0
    fit=0;
    fit = fit0(L,dim);
end

if F_index==1
    fit=0;
    fit = fit1(L,dim);
end
    
if F_index==2
    fit=0;
    fit = fit2(L,dim);
end
