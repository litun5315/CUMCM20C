function profit = fit2(xk,dim)

firm_number = dim;

AIR = xlsread('fit2.xls',1,'A1:A29')';
A_lost = xlsread('fit2.xls',1,'B1:B29')';
B_lost = xlsread('fit2.xls',1,'C1:C29')';
C_lost = xlsread('fit2.xls',1,'D1:D29')';
credit = xlsread('fit2.xls',1,'E1:E302')';
v1 = xlsread('fit2.xls',1,'F1:F302')';
v2 = xlsread('fit2.xls',1,'G1:G302')';
v3 = xlsread('fit2.xls',1,'H1:H302')';
v4 = xlsread('fit2.xls',1,'I1:I302')';
v5 = xlsread('fit2.xls',1,'J1:J302')';
v6 = xlsread('fit2.xls',1,'K1:K302')';
v7 = xlsread('fit2.xls',1,'L1:L302')';
v8 = xlsread('fit2.xls',1,'M1:M302')';
v9 = xlsread('fit2.xls',1,'N1:N302')';
v10 = xlsread('fit2.xls',1,'O1:O302')';


J = zeros(firm_number,1);
for i=1:firm_number
    if credit(i)==1 | v6(i)<0.8 | v7(i)<0.8
        J(i)=0;
    else
        J(i)=1;
    end
end

Money = 100000000;   
M = ones(firm_number,1);   
p = zeros(firm_number,1);  

grow = -1:0.1:1;    
g=0;

w1 = 0.1;    
w2 = 1-w1;   


L_m = xk(1:firm_number); 
M = L_m;

L_p = round(xk(firm_number+1:firm_number*2));  
p = L_p;




if sum(Q)>1
    profit = 0;
end

for i=1:size(Q,2)
     Q(i) = Q(i) * 9.98;
end

Money = 100000000;

all = 0;
for i=1:302
    if credit(i) == 4 & ~(JC(i)==0)
        p_each = A_lost(JC(i));
    end
    if credit(i) == 3 & ~(JC(i)==0)
        p_each = B_lost(JC(i));
    end
    if credit(i) == 2 & ~(JC(i)==0)
        p_each = C_lost(JC(i));
    end
    if credit(i) == 1
        p_each = 1;
    end
    if ~(JC(i)==0)
        all = all + Q(i)*Money*(1-p_each)*ALR(JC(i));
    end
end

profit = all/Money



end

