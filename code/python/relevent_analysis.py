import numpy as np
import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt
from matplotlib import cm
from matplotlib.colors import ListedColormap, LinearSegmentedColormap

cols = ["v1", "v2", "v3", "v4", "v5", "v6", "v7", "v8", "v9", "v10"]

if __name__ == "__main__":
    df = pd.read_excel("./data1_model1.xlsx", usecols=cols)
    dat = df.to_numpy()
    mat = []

    max_len = len(cols)
    i = 0
    while i < max_len:
        col1 = dat[:,i]
        j = 0
        tmp = []
        while j < max_len:
            col2 = dat[:,j]
            k = np.corrcoef(col1, col2)[0][1]
            tmp.append(k)
            j = j + 1
        mat.append(tmp)
        i = i + 1
    
    df_out = pd.DataFrame(data=mat, columns=cols)
    print(df_out)

    ax = sns.heatmap(mat, center = 0)
    plt.savefig("./fig1.jpeg")
    plt.show()


    # for figure 2
    df = pd.read_excel("./data2_model1.xlsx", usecols=cols)
    dat = df.to_numpy()
    mat = []

    max_len = len(cols)
    i = 0
    while i < max_len:
        col1 = dat[:,i]
        j = 0
        tmp = []
        while j < max_len:
            col2 = dat[:,j]
            k = np.corrcoef(col1, col2)[0][1]
            tmp.append(k)
            j = j + 1
        mat.append(tmp)
        i = i + 1
    
    df_out = pd.DataFrame(data=mat, columns=cols)
    print(df_out)

    ax = sns.heatmap(mat, center = 0)
    plt.savefig("./fig2.jpeg")
    plt.show()
