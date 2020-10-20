import cma
import pandas as pd
import numpy as np
import math

best_x = [ 1.46885133e-09, 5.34345815e-05,  4.26222723e-06, -1.04118604e-05,
  9.38681267e-05, -9.14566945e-01,  3.68779825e+00,  9.93900826e-10,
 -2.22299045e-13, -3.50627408e-12]
best_rank_c = [1.6961353,  2.46727745, 3.41847722]



cols = ["v1", "v2", "v3", "v4", "v5", "v6", "v7","v8", "v9", "v10"]

def map_classify(v, rank_c):
    if v < rank_c[0]:
        return 1
    if v < rank_c[1]:
        return 2
    if v < rank_c[2]:
        return 3
    return 4

def target(np_data, params, rnk):
    cost_val = 0
    index = 0
    factors = params[0:10]
    rank_c = params[10:13]
    
    for row in np_data:
        val = sum(row * factors)
        predict_rank = map_classify(val, rank_c)
        cost_val = cost_val + (predict_rank - rnk[index])**2
        index = index + 1
    return cost_val

if __name__ == "__main__":
    df = pd.read_excel("./data1_model1.xlsx", usecols=cols, sheet_name=0)
    df_rank = pd.read_excel("./data/data1_rank.xlsx", usecols=["rank"], sheet_name=0)
    org_dat = df.to_numpy()
    rnk = [x[0] for x in df_rank.to_numpy()]
    dat = org_dat
    
    def target_wrapper(params):
        con = list(params) + best_rank_c
        return target(dat, con, rnk)
    
    es = cma.CMAEvolutionStrategy(best_x, 0.1)
    while not es.stop():
        solutions = es.ask()
        es.tell(solutions, [target_wrapper(x) for x in solutions])
        es.logger.add()
        es.disp()
    
    es.result_pretty()
    print(es.result[0])
