function fit = fit0(L,dim)
%用于计算适应度
K_data=[4,4,2,2,3,4,4,4,4,3,2,3,4,2,4,4,4,4,4,3,3,4,3,4,2,4,4,3,2,3,4,3,3,3,3,1,3,3,2,2,2,4,3,2,3,2,2,4,2,2,3,1,2,4,2,2,3,3,4,3,3,3,3,4,3,3,3,2,2,3,3,2,2,3,2,3,2,2,3,2,4,1,3,4,3,2,2,4,4,2,4,2,3,2,3,2,3,3,1,1,1,1,1,2,2,3,1,1,1,2,1,1,1,1,1,1,1,1,1,1,1,1,1];
A = find(K_data==4);
B = find(K_data==3);
C = find(K_data==2);
D = find(K_data==1);

firm_data = xlsread('fit0.xls','Sheet1','A1:K123');

value_data = [];
for i=1:size(firm_data,1)
    calculate_value = 0;
    for j=1:11
        calculate_value = calculate_value + L(j) * (firm_data(i,j) +  L(j+11));
    end
    value_data = [value_data;calculate_value];
end

value_Kmeans = kmeans(value_data, 4);

A_num = [];
B_num = [];
C_num = [];
D_num = [];
for i=1:size(A,2)
    A_num = [A_num;value_Kmeans(A(i)) - K_data(A(i))];
end
for i=1:size(B,2)
    B_num = [B_num;value_Kmeans(B(i)) - K_data(B(i))];
end
for i=1:size(C,2)
    C_num = [C_num;value_Kmeans(C(i)) - K_data(C(i))];
end
for i=1:size(D,2)
    D_num = [D_num;value_Kmeans(D(i)) - K_data(D(i))];
end
fit = var(A_num*10) + var(B_num*10) + var(C_num*10) + var(D_num*10);

end

