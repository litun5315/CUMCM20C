import pandas as pd
import numpy as np

cols = ["v1", "v2", "v3", "v4", "v5", "v6", "v7", "v8", "v9", "v10"]

best_x = [ 1.46885133e-09, 5.34345815e-05,  4.26222723e-06, -1.04118604e-05,
  9.38681267e-05, -9.14566945e-01,  3.68779825e+00,  9.93900826e-10,
 -2.22299045e-13, -3.50627408e-12]
best_rank_c = [1.6961353,  2.46727745, 3.41847722]


def rank_class(v, ranks):
    if v < ranks[0]:
        return 1
    if v < ranks[1]:
        return 2
    if v < ranks[2]:
        return 3
    return 4

def map_rank(v, rank_c):
    if v < rank_c[0]:
        return 1
    if v < rank_c[1]:
        return 2
    if v < rank_c[2]:
        return 3
    return 4


if __name__ == "__main__":
    df = pd.read_excel("./data2_model1.xlsx", usecols=cols, sheet_name=0)
    dat = df.to_numpy()
    def class_by(v):
        return rank_class(v, best_rank_c)

    results = [class_by(sum(row * best_x)) for row in dat]
    print(results)

    df["pred_rank"] = results

    with pd.ExcelWriter("./data2_predict_rank.xlsx") as exec:
        df.to_excel(exec)


    