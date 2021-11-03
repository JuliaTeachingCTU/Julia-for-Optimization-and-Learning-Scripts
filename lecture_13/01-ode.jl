# # Wave equation
# ## Solving the wave equation

struct Wave
    f
    g
    c
end

# ### Exercise:
# 
# Write the function `solve_wave(T, L, wave::Wave; n_t=100, n_x=100)` that solves the wave 
# equation.
# 
# **Hint**: Follow the procedure from the previous exercise. Discretize time and space, 
# initialize the solution, add the boundary conditions, add the initial conditions and 
# finally, iterate over time.
# 
# ---
# ### Solution:



# ---

using Plots

function plot_wave(y, file_name; fps = 60, kwargs...)
    anim = @animate for (i, y_row) in enumerate(eachrow(y))
        plot(
            y_row;
            title = "t = $(i-1)Δt",
            xlabel = "x",
            ylabel = "y(t, x)",
            legend = false,
            linewidth = 2,
            kwargs...
        )
    end
    gif(anim, file_name; fps, show_msg = false)
    
    return nothing
end

# ### Exercise:
# 
# Solve the wave equation for $L=\frac32\pi$, $T=240$, $c=0.02$ and the initial 
# conditions
# 
# $$
# \begin{aligned}
# f(x) &= 2e^{-(x-\frac L2)^2} + \frac{x}{L}, \\
# g(x) &= 0.
# \end{aligned}
# $$
# 
# Use time discretization with stepsize $\Delta t=1$ and the space discretization with 
# number of points $n_x=101$ and $n_x=7$ steps. Plot two graphs.
# 
# ---
# ### Solution:
