# # Gradients
# ## Visualization of gradients
#
# ### Exercise: Contour plot
# Write a function `g(x)` which computes the derivative of `f` at a point  `x`.
# Plot the contours of `f` on the domain.
#
# **Hint:** Use the optional argument `color = :jet` for better visualization.
#
# ---
# ### Solution:




# ---
#
# ## Computation of gradients
#
# ### Exercise: Finite difference approximation
# Write a function `finite_difference` which computes the approximation of $f'(x)$ by
# finite differences. The inputs are a function $f:\mathbb R\to\mathbb R$ and a point
# $x \in \mathbb{R}$. It should have an optional input $h \in \mathbb{R}$, for which
# you need to choose a reasonable value.
#
# ---
# ### Solution:




# ---
#
# ### Exercise: Finite difference approximation
# Fix a point $x = (-2,-1)$. For a proper discretization of $h \in [10^{-15}, 10^{-1}]$
# compute the finite difference approximation of the partial derivative of $f$ with
# respect to the second variable.
#
# Plot the dependence of this approximation on $h$. Add the true derivative computed
# from $g$.
#
# ---
# ### Solution:




# ---

x = 1;
h = 1e-13;
(x+h)^2 - x^2
2*x*h + h^2

# ---
#
# ### Exercise: Direction of gradients
# Reproduce the previous figure with the vector field of derivatives. Therefore, plot the
# contours of $f$ and its gradients at a grid of its domain $[-3,1] \times [-2,1]$.
#
# **Hint**: when a plot is updated in a loop, it needs to be saved to a variable `plt`
# and then displayed via `display(plt)`.
#
# ---
# ### Solution:
