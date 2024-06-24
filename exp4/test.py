import numpy as np

# Define the matrix
matrix = np.array([
    [1, 0, 0, 0, 0],
    [0.3, 0.3, 0.4, 0, 0],
    [0, 0.3, 0.3, 0.4, 0],
    [0, 0, 0.3, 0.3, 0.4],
    [0, 0, 0, 0, 1]
])

# Calculate the matrix to the 10th, 20th, and 30th power
matrix_10 = np.linalg.matrix_power(matrix, 10)
matrix_20 = np.linalg.matrix_power(matrix, 20)
matrix_30 = np.linalg.matrix_power(matrix, 30)

matrix_10, matrix_20, matrix_30
