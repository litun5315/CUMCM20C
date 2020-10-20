function flag = connction(in,out,firm,CD,in0out)
flag = 0;
if in0out == 0    %—∞’“in
    firm_connect = find(in(:,CD)==1)+123;
    if find(firm_connect==firm)
        flag = 1;
    end
else    %—∞’“out
    firm_connect = find(out(:,CD)==1)+123;
    if find(firm_connect==firm)
        flag = 1;
    end
end
end

