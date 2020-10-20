import numpy as np
import pandas as pd
import pickle as pk


def filter_by(df, col, val):
    return df[df[col] == val]

def cal_v1_v8(sheet_in, sheet_out):
    sheet_in['type'] = True
    sheet_out['type'] = False
    
    sheet_in['comb_amount'] = sheet_in['amount']
    sheet_in['comb_tax'] = sheet_in['tax']
    sheet_in['comb_sum'] = sheet_in['sum']

    sheet_out['comb_amount'] = sheet_out['amount']
    sheet_out['comb_tax'] = sheet_out['tax']
    sheet_out['comb_sum'] = sheet_out['sum']


    sheet_in['amount'] = - sheet_in['amount']
    sheet_in['tax'] = - sheet_in['tax']
    sheet_in['sum'] = - sheet_in['sum']

    combined_sheet = pd.concat([sheet_in, sheet_out])
    combined_sheet = filter_by(combined_sheet, 'status', '有效发票')
    unique_company = combined_sheet["company"].unique()
    df_by_company = dict()

    for x in unique_company:
        df_by_company[x] = filter_by(combined_sheet, 'company', x).sort_values(by=['date'])

    df_changing_date = pd.DataFrame(columns=df_by_company.keys())

    for x in df_by_company.keys():
        df = df_by_company[x]
        per = df['date'].dt.to_period("M")
        df = df.groupby(per)
        df = df.sum()
        df_by_company[x] = df
        with pd.ExcelWriter("./output/" + x + ".xlsx") as exc:
            df.to_excel(exc)
    
    # company, date_length(by mounth), amount_sum, tax_sum, sum_sum, 
    df_v1 = pd.DataFrame(columns=["company", "date_length", "amount_sum", "tax_sum", "sum_sum", 
    "amount_mavg","tax_mavg","sum_mavg", 
    "comb_amount_sum", "comb_tax_sum", "comb_sum_sum"])
    for x in df_by_company.keys():
        tmp = dict()
        r,c = df_by_company[x].shape
        tmp["company"] = x
        tmp["date_length"] = r
        df_x_sum = df_by_company[x].sum()
        tmp["amount_sum"] = df_x_sum["amount"]
        tmp["tax_sum"] = df_x_sum["tax"]
        tmp["sum_sum"] = df_x_sum["sum"]
        if r != 0:
            tmp["amount_mavg"] = tmp["amount_sum"] / r
            tmp["tax_mavg"] = tmp["tax_sum"] / r
            tmp["sum_mavg"] = tmp["sum_sum"] / r
        tmp["comb_amount_sum"] = df_x_sum["comb_amount"]
        tmp["comb_tax_sum"] = df_x_sum["comb_tax"]
        tmp["comb_sum_sum"] = df_x_sum["comb_sum"]
        df_v1 = df_v1.append(tmp, ignore_index=True)
    
    #with pd.ExcelWriter("./v1v8.xlsx") as exc:
    #    df_v1.to_excel(exc)

    return df_v1

# return a dict, {stream_name : occuring times}
def get_stream_content(df_sheet, company, stream_label):
    df = filter_by(df_sheet, "company", company)
    unique_streams = df[stream_label].unique()
    streams_count = dict()
    for x in unique_streams:
        streams_count[x] = df[stream_label].apply(lambda arg : int(arg == x)).sum()
    print("calcu...")
    return streams_count

# return the rating of a company's stream status
def stream_evalute(streams_count):
    counts = []
    for x in streams_count.keys():
        counts.append(streams_count[x])
    all_sum = sum(counts)
    ped = [x ** 2 for x in counts]
    return (all_sum, sum(counts) / all_sum ** 2)

# using variance
def stream_evalute2(streams_count):
    counts = []
    for x in streams_count.keys():
        counts.append(streams_count[x])
    all_sum = sum(counts)
    var = np.var(counts)
    return (all_sum,var)

def cal_v2_v3(sheet_in, sheet_out):
    sheet_in = filter_by(sheet_in, "status", "有效发票")
    sheet_out = filter_by(sheet_out, "status", "有效发票")

    df_v2 = pd.DataFrame(columns=["company", "v2", "v3", "v4", "v5"])
    compines = sheet_in["company"].unique()
    for x in compines:
        tmp = dict()
        sc_in = get_stream_content(sheet_in, x, "inout")
        sc_out = get_stream_content(sheet_out, x, "inout")
        try:
            in_sum, v2_item = stream_evalute2(sc_in)
            out_sum, v3_item = stream_evalute2(sc_out)
        except:
            print("company : ", x )
            print(sc_in)
            print(sc_out)
            exit(0)
        tmp["company"] = x
        tmp["v2"] = v2_item
        tmp["v3"] = v3_item
        tmp["v4"] = in_sum
        tmp["v5"] = out_sum
        df_v2 = df_v2.append(tmp, ignore_index=True)
    #with pd.ExcelWriter("./v2v3v4v5.xlsx") as exec:
    #    df_v2.to_excel(exec)
    return df_v2

# for v6, v7
def cal_v6_v7(sheet_in, sheet_out):
    compines = sheet_in["company"].unique()
    df_v6_v7 = pd.DataFrame(columns=["company", "v6", "v7"])
    for x in compines:
        tmp = dict()
        in_df = filter_by(sheet_in, "company", x)
        in_all, _ = in_df.shape
        in_valid, _ = filter_by(in_df, "status", "有效发票").shape

        out_df = filter_by(sheet_out, "company", x)
        out_all, _ = out_df.shape
        out_valid, _ = filter_by(out_df, "status", "有效发票").shape
        tmp["company"] = x
        tmp["v6"] = float(in_valid / in_all)
        tmp["v7"] = float(out_valid / out_all)
        df_v6_v7 = df_v6_v7.append(tmp, ignore_index=True)

    #with pd.ExcelWriter("./v6_v7.xlsx") as exec:
    #    df_v6_v7.to_excel(exec)
    return df_v6_v7

def cal_v9_v10(sheet_in, sheet_out):
    sheet_in = filter_by(sheet_in, "status", "有效发票")
    sheet_out = filter_by(sheet_out, "status", "有效发票")

    df_upstream = sheet_in.groupby(["inout"]).sum().T
    df_downstream = sheet_out.groupby(["inout"]).sum().T

    df_v9_v10 = pd.DataFrame(columns=["company", "v9", "v10"])

    compines = sheet_in["company"].unique()
    for x in compines:
        tmp = dict()
        cur = filter_by(sheet_in, "company", x)
        sheet_applied = cur["inout"].apply(lambda y : df_upstream[y].values[3])

        cur2 = filter_by(sheet_out, "company", x)
        sheet_applied2 = cur2["inout"].apply(lambda y : df_downstream[y].values[3])

        tmp["company"] = x
        tmp["v9"] = sheet_applied.sum()
        tmp["v10"] = sheet_applied2.sum()

        df_v9_v10 = df_v9_v10.append(tmp, ignore_index=True)
    
    #with pd.ExcelWriter("./v9_v10.xlsx") as exec:
    #    df_v9_v10.to_excel(exec)
    
    return df_v9_v10

def cal_all_v(df_in, df_out, out_filename):
    df_v1_v8_pre = cal_v1_v8(df_in, df_out)

    df_v1_v8 = df_v1_v8_pre[["company","sum_sum","comb_sum_sum"]]
    df_v1_v8 = df_v1_v8.rename(columns={'sum_sum':'v1', 'comb_sum_sum':'v8'})
    df_v2_v3_v4_v5 = cal_v2_v3(df_in, df_out)
    df_v6_v7 = cal_v6_v7(df_in, df_out)
    df_v9_v10 =cal_v9_v10(df_in, df_out)

    tmp1 = df_v1_v8.merge(df_v2_v3_v4_v5, on="company")
    tmp2 = df_v6_v7.merge(df_v9_v10, on="company")
    
    all_v = tmp1.merge(tmp2, on="company")
    all_v.to_excel(out_filename)
    return all_v
    

if __name__ == "__main__":
    data1_in = pd.read_pickle("data/data1_out.pkl")
    data1_out = pd.read_pickle("data/data1_in.pkl")
    cal_all_v(data1_in, data1_out, "./data1_model1.xlsx")

    data2_in = pd.read_pickle("data/data2_out.pkl")
    data2_out = pd.read_pickle("data/data2_in.pkl")
    cal_all_v(data2_in, data2_out, "./data2_model1.xlsx")

