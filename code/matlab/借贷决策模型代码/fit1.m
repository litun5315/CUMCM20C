function profit = fit1(x,dim)

sell = xlsread('fit1.xls',1,'A1:A123')'; 
buy = xlsread('fit1.xls',1,'B1:B123')';
ALR = xlsread('fit1.xls',1,'C1:C29')';
A_lost = xlsread('fit1.xls',1,'D1:D29')';
B_lost = xlsread('fit1.xls',1,'E1:E29')';
C_lost  = xlsread('fit1.xls',1,'F1:F29')';
credit = xlsread('fit1.xls',1,'G1:G123')';
illgal = xlsread('fit1.xls',1,'H1:H123')';

firm_number = dim/2;

J = zeros(firm_number,1);
for i=1:firm_number
    if credit(i)==1 | illgal(i)==1
        J(i)=0;
    else
        J(i)=1;
    end
end

Money = 1000000000;    %假设总金额是10亿
M = ones(firm_number,1);    %获取比例
p = zeros(firm_number,1);     %每种的策略

grow = -1:0.1:1;     %自然增长率
g=0;

w1 = 0.1;    %近期
w2 = 1-w1;    %权重


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%提供的信息
L_m = x(1:firm_number);      %123直接算比例
M = L_m;
L_p = round(x(firm_number+1:firm_number*2));      %取值29种策略
p = L_p;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%计算下一年的收入
profit = 0;
profit_each = [];
for i = 1:firm_number
    if credit(i) == 4
        p_each = A_lost(L_p(i));
    end
    if credit(i) == 3
        p_each = B_lost(L_p(i));
    end
    if credit(i) == 2
        p_each = C_lost(L_p(i));
    end
    if credit(i) == 1
        p_each = 1;
    end
    
    profit_each = [profit_each,J(i)*((1+g-p_each)*Money*M(i)*ALR(p(i)))];
    profit = profit + profit_each(i);
    
end

profit_oneyear = profit;



year_limit = 10;

money = [];
for i=1:123
    money = [money;Money];
end

profit_year = [];

for year = 1:year_limit
    profit_year = [];
    profit = 0;
    profit_each = [];
    
    for i = 1:firm_number
        if credit(i) == 4
            p_each = A_lost(L_p(i));
        end
        if credit(i) == 3
            p_each = B_lost(L_p(i));
        end
        if credit(i) == 2
            p_each = C_lost(L_p(i));
        end
        if credit(i) == 1
            p_each = 1;
        end
        
        profit_each = [profit_each,J(i)*((1+g-p_each)*money(i)*M(i)*ALR(p(i)))];
        profit = profit + profit_each(i);
        money(i) = money(i)* (1+g-p_each);
    end
    profit_year = [profit_year,profit];
    
end

profit_eahyear = profit/year_limit;



allprofit = w1*profit_oneyear + w2*profit_eahyear;

profit = allprofit/(Money*30);



end

