clc,clear,,clf,close all;
[firm,firmID]=xlsread('D:\CODA\matlab\9-10\data\附件2.xlsx','企业信息','A2:B303');
[sell,sellID]=xlsread('D:\CODA\matlab\9-10\data\附件2.xlsx','销项发票信息','A2:H7836');%H330836
[buy,buyID]=xlsread('D:\CODA\matlab\9-10\data\附件2.xlsx','进项发票信息','A2:H38096');%H395176
disp('数据读取完毕');

%处理附件二
firm_ID=[];
firm_Name=[];
for i=1:size(firmID,1)
    firm_ID = [firm_ID;firmID{i,1}];
    firm_Name = [firm_Name;firmID{i,2}];
end

firm_buyID=[];
buy_time=[];
buy_time_year=[];
buy_time_month=[];
buy_time_day=[];
buyer=[];
buy_money=[];
buy_tex_money=[];
buy_all_money=[];
buy_inv=[];
for i=1:size(buyID,1)
    k = regexp(buyID{i,3}, '\s+', 'split');
    buyID{i,3} = k{1};
    
    time = regexp(buyID{i,3}, '/', 'split');
    buy_time_year=[buy_time_year;str2num(time{1})];
    buy_time_month=[buy_time_month;str2num(time{2})];
    buy_time_day=[buy_time_day,str2num(time{3})];
    
    tmp = buyID{i,8}=='有效发票';
    if tmp(1)*tmp(2)*tmp(3)*tmp(4)==1
        buyID{i,8} = 1;
    else
        buyID{i,8} = 0;
    end
    firm_buyID = [firm_buyID;buyID{i,1}];
    buyer = [buyer;buyID{i,4}];
    buy_inv = [buy_inv;buyID{i,8}];
    buy_money = [buy_money;buy(i,1+3)];
    buy_tex_money = [buy_tex_money;buy(i,2+3)];
    buy_all_money = [buy_all_money;buy(i,3+3)];
end

firm_sellID=[];
sell_time=[];
sell_time_year=[];
sell_time_month=[];
sell_time_day=[];
seller=[];
sell_money=[];
sell_tex_money=[];
sell_all_money=[];
sell_inv=[];
for i=1:size(sellID,1)
    k = regexp(sellID{i,3}, '\s+', 'split');
    sellID{i,3} = k{1};
    time = regexp(sellID{i,3}, '/', 'split');
    sell_time_year=[sell_time_year;str2num(time{1})];
    sell_time_month=[sell_time_month;str2num(time{2})];
    sell_time_day=[sell_time_day,str2num(time{3})];
    tmp = buyID{i,8}=='有效发票';
    if tmp(1)*tmp(2)*tmp(3)*tmp(4)==1
        buyID{i,8} = 1;
    else
        buyID{i,8} = 0;
    end
    firm_sellID = [firm_sellID;sellID{i,1}];
    seller = [seller;sellID{i,4}];
    sell_inv = [sell_inv;sellID{i,8}];
    sell_money = [sell_money;sell(i,1+3)];
    sell_tex_money = [sell_tex_money;sell(i,2+3)];
    sell_all_money = [sell_all_money;sell(i,3+3)];    
end
disp('数据预处理完毕');

%clear firm firmID sell sellID buy buyID i k tmp

firm_ID_index = [];
firm_ID_index = firm_ID(1,:);
for i=1:size(firm_ID,1)
    for j=1:size(firm_ID_index,1)
        tmp = firm_ID(i,:) == firm_ID_index(j,:);
        if ~(tmp(1)*tmp(2)*tmp(3)*tmp(4))
             firm_ID_index = [firm_ID_index;firm_ID(i,:)];
        end
    end
end
disp('公司种类分析完毕');
firm_ID_index



inv_buy_sort=[];
inv_sell_sort=[];
for i=1:size(buy_all_money,1)
    inv_buy_sort=[inv_buy_sort;buy_tex_money(i)/buy_money(i)];
end
for i=1:size(sell_all_money,1)
    inv_sell_sort=[inv_sell_sort;sell_tex_money(i)/sell_money(i)];
end
disp('税价处理完毕');

%clear i j tmp

%获得每种公司开始和结束的地方
buy_analyse_start = [];
buy_analyse_end = [];
for index = 1:size(firm_ID_index,1)
    firm_analyse_index = index;
    firm_analyse_name = firm_ID_index(firm_analyse_index,:);
    buy_analyse_start = [buy_analyse_start;-1];
    buy_analyse_end = [buy_analyse_end;-1];
    for i=1:size(firm_buyID,1)
        tmp = firm_analyse_name==firm_buyID(i,:);
        if (buy_analyse_start(index)==-1)&(tmp(1)*tmp(2)*tmp(3)*tmp(4))
            buy_analyse_start(index) = i;
        end
        if ~(buy_analyse_start(index)==-1)&(buy_analyse_end(index)==-1)&(~(tmp(1)*tmp(2)*tmp(3)*tmp(4)))
            buy_analyse_end(index) = i-1;
        end
        if (~(buy_analyse_start(index)==-1))&(~(buy_analyse_end(index)==-1))
            continue;
        end
        if (i==size(firm_buyID,1))&(~(buy_analyse_start(index)==-1))&(buy_analyse_end(index)==-1)
            buy_analyse_end(index) = i;
        end
    end
    
end

sell_analyse_start = [];
sell_analyse_end = [];
for index = 1:size(firm_ID_index,1)
    firm_analyse_index = index;
    firm_analyse_name = firm_ID_index(firm_analyse_index,:);
    sell_analyse_start = [sell_analyse_start;-1];
    sell_analyse_end = [sell_analyse_end;-1];
    for i=1:size(firm_sellID,1)
        tmp = firm_analyse_name==firm_sellID(i,:);
        if (sell_analyse_start(index)==-1)&(tmp(1)*tmp(2)*tmp(3)*tmp(4))
            sell_analyse_start(index) = i;
        end
        if ~(sell_analyse_start(index)==-1)&(sell_analyse_end(index)==-1)&(~(tmp(1)*tmp(2)*tmp(3)*tmp(4)))
            sell_analyse_end(index) = i-1;
        end
        if (~(sell_analyse_start(index)==-1))&(~(sell_analyse_end(index)==-1))
            continue;
        end
        if (i==size(firm_sellID,1))&(~(sell_analyse_start(index)==-1))&(sell_analyse_end(index)==-1)
            sell_analyse_end(index) = i;
        end
    end
end








