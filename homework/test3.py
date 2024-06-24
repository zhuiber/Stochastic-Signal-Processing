import numpy as np

# 定义转移矩阵
P = np.array([
    [0.6, 0.4],
    [0.2, 0.8]
])

# 转置矩阵以设置线性方程
P = P.T

# 设置线性方程组
A = np.array([
    [P[0, 0] - 1, P[0, 1]],
    [P[1, 0], P[1, 1] - 1]
])
b = np.array([0, 0])

# 添加归一化条件
A = np.vstack((A, np.ones(2)))
b = np.append(b, 1)

# 解方程组
pi = np.linalg.lstsq(A, b, rcond=None)[0]

print(f'Stationary distribution: {pi}')
