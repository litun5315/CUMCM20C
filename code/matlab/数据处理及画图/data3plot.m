%数据3的使用
clc,clear,,clf,close all;
money=xlsread('D:\CODA\matlab\9-10\data\附件3.xlsx','Sheet1','A3:D31');
annual_interest_rate = money(:,1);
AIR = annual_interest_rate;
A = money(:,2);
B = money(:,3);
C = money(:,4);
plot(AIR,A,'r');
hold on;
plot(AIR,B,'g');
hold on;
plot(AIR,C,'b');
xlabel('贷款年利率');
ylabel('顾客流失率');
title('贷款年利率与顾客流失率关系图');
legend('信誉评级A','信誉评级B','信誉评级C');