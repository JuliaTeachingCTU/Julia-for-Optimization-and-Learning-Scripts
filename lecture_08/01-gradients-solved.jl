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

using Plots

f(x) = sin(x[1] + x[2]) + cos(x[1])^2
g(x) = [cos(x[1] + x[2]) - 2*cos(x[1])*sin(x[1]); cos(x[1] + x[2])]
f(x1,x2) = f([x1;x2])

#+

f([0; 0])
f(0, 0)

#+

xs = range(-3, 1, length = 40)
ys = range(-2, 1, length = 40)

contourf(xs, ys, f, color = :jet)

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

finite_difference(f, x::Real; h=1e-8) = (f(x+h) - f(x)) / h

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

x = [-2; -1]
fin_diff(h) = finite_difference(y -> f(x[1], y), x[2]; h=h)
true_grad = g(x)[2]
hs = 10. .^ (-15:0.01:-1)

#+

plot(hs, fin_diff,
    xlabel = "h",
    ylabel = "Partial gradient wrt y",
    label = ["Approximation" "True gradient"],
    xscale = :log10,
)

hline!([true_grad]; label =  "True gradient")

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

xs = range(-3, 1, length = 20)
ys = range(-2, 1, length = 20)

plt = contourf(xs, ys, f;
    xlims = (minimum(xs), maximum(xs)),
    ylims = (minimum(ys), maximum(ys)),
    color = :jet
)

# ---

α = 0.25
for x1 in xs, x2 in ys
    x = [x1; x2]
    x_grad = [x x.+α.*g(x)]

    plot!(x_grad[1, :], x_grad[2, :];
        line = (:arrow, 2, :black),
        label = "",
    )
end
display(plt)
