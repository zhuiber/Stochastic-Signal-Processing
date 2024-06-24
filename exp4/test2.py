import numpy as np
import matplotlib.pyplot as plt

# 定义转移矩阵
P = np.array([
    [1, 0, 0, 0, 0, 0],
    [0.25, 0, 0.75, 0, 0, 0],
    [0, 0.25, 0, 0.75, 0, 0],
    [0, 0, 0.25, 0, 0.75, 0],
    [0, 0, 0, 0.25, 0, 0.75],
    [0, 0, 0, 0, 0, 1]
])

# 初始状态分布
initial_distribution = np.array([0, 0, 1, 0, 0, 0])  # 初始状态为 (2, 3)

# 计算前 n 局游戏后无破产的概率
def probability_no_ruin(n_games):
    distribution = initial_distribution
    for _ in range(n_games):
        distribution = distribution @ P
    # 无破产的概率为非吸收状态的概率之和
    prob_no_ruin = np.sum(distribution[1:5])
    return prob_no_ruin

# 计算并绘制 1 到 20 局游戏后的无破产概率
n_games_list = list(range(1, 21))
probabilities_no_ruin = [probability_no_ruin(n) for n in n_games_list]

plt.plot(n_games_list, probabilities_no_ruin, marker='o')
plt.xlabel('Number of Games')
plt.ylabel('Probability of No Ruin')
plt.title('Probability of No Ruin for 1 to 20 Games')
plt.grid(True)
plt.show()

# 输出第 10 局游戏后的无破产概率
prob_no_ruin_10_games = probability_no_ruin(10)
print(f'Probability of no ruin for 10 games: {prob_no_ruin_10_games}')
