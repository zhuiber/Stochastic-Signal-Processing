#作业二：洗发水市场份额
import numpy as np
import matplotlib.pyplot as plt

# 定义初始条件和参数
transition_matrix = np.array([
    [0.7, 0.1, 0.1, 0.1],
    [0.2, 0.4, 0.2, 0.2],
    [0.1, 0.1, 0.6, 0.2],
    [0.3, 0.0, 0.3, 0.4]
])
initial_market_share = np.array([0.25, 0.25, 0.25, 0.25])
months = 24

# 初始化市场份额矩阵
market_share = np.zeros((months + 1, 4))
market_share[0] = initial_market_share

# 递推计算每个月的市场份额
for month in range(1, months + 1):
    market_share[month] = np.dot(market_share[month - 1], transition_matrix)

# 绘制市场份额变化图
plt.plot(range(1, months + 1), market_share[1:, 0], label='Shampoo A')
plt.plot(range(1, months + 1), market_share[1:, 1], label='Shampoo B')
plt.plot(range(1, months + 1), market_share[1:, 2], label='Shampoo C')
plt.plot(range(1, months + 1), market_share[1:, 3], label='Shampoo D')
plt.xlabel('Months')
plt.ylabel('Market Share')
plt.title('Market Share of Shampoos Over 24 Months')
plt.legend()
plt.grid(True)
plt.show()

# 输出第2个月和第12个月的市场份额
print(f"Market shares in month 2: {market_share[2]}")
print(f"Market shares in month 12: {market_share[12]}")