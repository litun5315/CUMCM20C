% This function gives boundaries and dimension of search space for test functions.
function [down,up,dim]=test_functions_range(F_index)

%If lower bounds of dimensions are the same, then 'down' is a value.
%Otherwise, 'down' is a vector that shows the lower bound of each dimension.
%This is also true for upper bounds of dimensions.

%Insert your own boundaries with a new F_index.


if F_index==-1
    down=-100;up=100;dim=30;
end
    
if F_index==0
    down=-10;up=10;dim=22;
end

if F_index==1
    down=1;up=29;dim=123*2;
end

if F_index==2
     down=1;up=29;dim=302*2;
end