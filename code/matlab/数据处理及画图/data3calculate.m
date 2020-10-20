clc,clear,,clf,close all;
money=xlsread('附件3.xlsx','Sheet1','A3:D31');
annual_interest_rate = money(:,1);
AIR = annual_interest_rate;
A = money(:,2);
B = money(:,3);
C = money(:,4);
grow_path = [0.1,0.2,0.3,0.4,0.5,1];
for k=1:6    
    grow = grow_path(k);
    figure(k)
    for j = 1:size(A,1)
        num_customer = 1000;
        money = 100;
        year = 10;
        year_change = [];
        allmoney = [];
        for i=1:year
            moneyGet = num_customer*money*AIR(j);
            year_change = [year_change;moneyGet];
            num_customer = num_customer*((1-A(j))+grow);
            if i==1
                allmoney = [allmoney;moneyGet];
            else
                allmoney = [allmoney;allmoney(i-1)+moneyGet];
            end
        end
        hold on;
        plot(1:1:10,allmoney);
        xlabel('年份');
        ylabel('银行总收益')
        title("不同年自然增长率下的银行总收益的年变化情况");
    end
end

