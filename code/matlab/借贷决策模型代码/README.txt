（fit0,fit1,fit2等excel文件是计算时读取的文件，丢失后不能计算）

该部分为GSA算法，只需要修改main.m中的参数即可使用
其中修改min_flag为0时求最大值，为1时求最小值
修改F_index可控制题号
其中-1为测试函数测试算法能否运行，0为加入K-means后聚类分析（曾被用于计算问题一但效果不佳故舍弃）1代表第一问求解，2代表第二问求解
算法可修改性强，可以再test_functions_rang.m和test_functions.m文件中修改范围和目标函数
