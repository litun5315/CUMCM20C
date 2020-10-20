%FileReader
clc,clear,close all;
[prize_in,BigData_in]=xlsread('data2','in','A1:C377939');
[prize_out,BigData_out]=xlsread('data2','out','A1:C303280');
[nothing,mixFirm]=xlsread('行业分类.xls','公司种类','A2:C303');



num_in = size(prize_in,1);
num_out = size(prize_out,1);
num_frim = 123;

connect_in = zeros(425-num_frim,num_in);
for i=1:size(BigData_in,1)
     firm = str2num(BigData_in{i,1}(2:4));
     in = str2num(BigData_in{i,2}(2:6));
     connect_in(firm-num_frim,in) = 1;
end

connect_out = zeros(425-num_frim,num_out);
for i=1:size(BigData_out,1)
     firm = str2num(BigData_out{i,1}(2:4));
     out = str2num(BigData_out{i,2}(2:6));
     connect_out(firm-num_frim,out) = 1;
end

connect_in_cal = zeros(425-num_frim,num_in);
for i=1:size(BigData_in,1)
     firm = str2num(BigData_in{i,1}(2:4));
     in = str2num(BigData_in{i,2}(2:6));
     connect_in_cal(firm-num_frim,in) = connect_in_cal(firm-num_frim,in) + 1;
end

connect_out_cal = zeros(425-num_frim,num_out);
for i=1:size(BigData_out,1)
     firm = str2num(BigData_out{i,1}(2:4));
     out = str2num(BigData_out{i,2}(2:6));
     connect_out_cal(firm-num_frim,out) = connect_out_cal(firm-num_frim,out) + 1;
end

connect_in_pri = zeros(425-num_frim,num_in);
for i=1:size(BigData_in,1)
     firm = str2num(BigData_in{i,1}(2:4));
     in = str2num(BigData_in{i,2}(2:6));
     connect_in_pri(firm-num_frim,in) = connect_in_pri(firm-num_frim,in) + abs(prize_in(i));
end

connect_out_pri = zeros(425-num_frim,num_out);
for i=1:size(BigData_out,1)
     firm = str2num(BigData_out{i,1}(2:4));
     out = str2num(BigData_out{i,2}(2:6));
     connect_out_pri(firm-num_frim,out) = connect_out_pri(firm-num_frim,out) + (prize_out(i));
end



connect_in_pri = connect_in_pri./connect_in_cal;
connect_out_pri = connect_out_pri./connect_out_cal;
firm_class =mixFirm(:,3);

clear prize_in prize_out nothing BigData_in BigData_out mixFirm



