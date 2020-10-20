import pandas as pd
import numpy as np
import pickle as pk

def filter_by(df, col, val):
    return df[df[col] == val]

global_f = 1e6
def get_f(c):
    global global_f
    return global_f

def spyder_sim():
    df_class = pd.read_excel("./data/class.xls", usecols=["company", "class"])
    def get_class(e):
        nonlocal df_class
        return df_class.loc[df_class["company"] == e].to_numpy()[0][1]

    df_in_mat_sum = pd.read_csv("./data/in_sum_mat.csv", index_col=0)
    df_out_mat_sum = pd.read_csv("./data/out_sum_mat.csv", index_col=0)

    def in_sum(com, ino):
        nonlocal df_in_mat_sum
        return df_in_mat_sum.loc[ino, com]

    def out_sum(com, ino):
        nonlocal df_out_mat_sum
        return df_out_mat_sum.loc[ino, com]


    df_in = pd.read_pickle("./data/data2_in.pkl")
    df_out = pd.read_pickle("./data/data2_out.pkl")
    df_in = filter_by(df_in, "status", "有效发票")
    df_out = filter_by(df_out, "status", "有效发票")

    group_in_dict = dict()
    grouped_in = df_in.groupby("company")
    for com, group in grouped_in:
        group_in_dict[com] = group

    group_out_dict = dict()
    grouped_out = df_out.groupby("company")
    for com, group in grouped_out:
        group_out_dict[com] = group

    def in_cnt(com):
        nonlocal group_in_dict
        return len(group_in_dict["inouts"].unique())

    def out_cnt(com):
        nonlocal group_out_dict
        return len(group_out_dict["inouts"].unique())

    compines = df_in["company"].unique()

    result_dict = dict()

    cs_dict = dict()

    def update_fm(f, ol, il):
        return f / (ol + il)

    for com in compines:
        ins = group_in_dict[com]["inout"].unique()
        ins_len = len(ins)
        outs = group_out_dict[com]["inout"].unique()
        outs_len = len(outs)

        f = get_f(get_class(com))
        f_mean = f / (outs_len + ins_len)

        in_sums = []
        for i in ins:
            in_sums.append(in_sum(com, i))

        out_sums = []
        for o in outs:
            out_sums.append(out_sum(com, o))
        
        in_sums = list(sorted(in_sums))
        out_sums = list(sorted(out_sums))

        i = 0
        while i < ins_len:
            if in_sums[i] < f_mean:
                i = i + 1
                #f_mean = f / (outs_len + ins_len - i)
                f_mean = f
            else:
                break
        if(i == ins_len):
            result_dict[com] = False
            continue

        o = 0
        while o < outs_len:
            if out_sums[o] < f_mean:
                o = o + 1
                #f_mean = f / (outs_len + ins_len - i - o)
                f_mean = f
            else:
                break
        
        if(o == outs_len):
            result_dict[com] = False
            continue

        result_dict[com] = True
        
   

    for com in compines:
        c = get_class(com)
        if not c in cs_dict.keys():
            cs_dict[c] = (0, 0)
        l,r = cs_dict[c]
        r = r + 1
        if result_dict[com]:
            l = l + 1
        cs_dict[c] = l, r
    

    # company breaks? by company
    # print(result_dict)

    # company class statistcs
    # print(cs_dict)

    return result_dict, cs_dict

if __name__ == "__main__":
    f_list = range(0, 3000000, 100000)

    df_class = pd.read_excel("./data/class.xls", usecols=["company", "class"])
    compines = df_class["company"].unique()
    classes = df_class["class"].unique()


    def dict2list(d):
        l = []
        for k in d.keys():
            l.append(d[k])
        return l
    
    def p2b(d):
        l = []
        for k in d.keys():
            x,y = d[k] 
            l.append(x/y)
        return l
    l_result = []
    l_cs = []
    l_prob = []
    for f in f_list:
        global_f = f
        result_dict, cs_dict = spyder_sim()
        l_result.append(dict2list(result_dict))
        l_cs.append(dict2list(cs_dict))
        l_prob.append(p2b(cs_dict))

    df_result = pd.DataFrame(l_result, index=f_list, columns=compines)
    df_cs = pd.DataFrame(l_cs, index=f_list, columns=classes)
    df_prob = pd.DataFrame(l_prob, index=f_list, columns=classes)
    df_result.to_csv("model3_result.csv")
    df_cs.to_csv("model3_stat_by_class.csv")
    df_prob.to_csv("model3_probability.csv")

