import numpy as np
import matplotlib.pyplot as plt
from scipy.optimize import minimize


# Define the equation to be minimized
def equation(vars, omega):
    x, y = vars
    return (x + 2 * y - omega - 5) ** 2 + (2 * x + y - omega) ** 2


# Define the sum of two instances of the equation with different omega values
def sum_of_equations(vars, omega1, omega2, omega3):
    return equation(vars, omega1) + equation(vars, omega2) + equation(vars, omega3)


# Set the values of omega for the two instances
omega1_value = 2
omega2_value = 3
omega3_value = 5

# Generate x and y values
x_vals = np.linspace(-10, 10, 100)
y_vals = np.linspace(-10, 10, 100)

# Create a grid of x, y values
x_grid, y_grid = np.meshgrid(x_vals, y_vals)

# Initial guess for the minimization algorithm
initial_guess = [0, 4]
# Print the results at initial_guess

print(f"IC x: {initial_guess[0]}")
print(f"IC y: {initial_guess[1]} ")
print(
    f"IC value of equation for Omega1 = {omega1_value}: {equation(initial_guess, omega1_value)}"
)
print(
    f"IC value of equation for Omega2 = {omega2_value}: {equation(initial_guess, omega2_value)}"
)
print(
    f"IC value of equation for Omega3 = {omega3_value}: {equation(initial_guess, omega3_value)}"
)


# Minimize the sum of two instances of the equation
result = minimize(
    sum_of_equations, initial_guess, args=(omega1_value, omega2_value, omega3_value)
)

# Extract the optimized values
x_optimized, y_optimized = result.x

# Print the results
print(f"Optimized x: {x_optimized}")
print(f"Optimized y: {y_optimized}")
print(f"Minimum value of the sum of equations: {result.fun}")

# Plot the contours with the minimum point
plt.contour(
    x_grid,
    y_grid,
    sum_of_equations([x_grid, y_grid], omega1_value, omega2_value, omega3_value),
    levels=20,
    cmap="viridis",
)
plt.scatter(x_optimized, y_optimized, color="red", label="Minimum Point")
plt.title(
    f"Contour Plot of Sum of Equations for \nOmega1 = {omega1_value}, Omega2 = {omega2_value}, Omega3 = {omega3_value}"
)
plt.xlabel("X-axis")
plt.ylabel("Y-axis")
plt.legend()
plt.colorbar(label="Sum of Equation Values")
plt.show()
