using Pkg
Pkg.activate(pwd())

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

function solve_wave(T, L, wave::Wave; n_t=100, n_x=100)
    ts = range(0, T; length=n_t)
    xs = range(0, L; length=n_x)
    Δt = ts[2] - ts[1]
    Δx = xs[2] - xs[1]
    y = zeros(n_t, n_x)
    
    # boundary conditions
    y[:,1] .= wave.f(0)
    y[:,end] .= wave.f(L)

    # initial conditions
    y[1,2:end-1] = wave.f.(xs[2:end-1])
    y[2,2:end-1] = y[1,2:end-1] + Δt*wave.g.(xs[2:end-1])

    # solution for t = 2Δt, 3Δt, ..., T
    for t in 2:n_t-1, x in 2:n_x-1
        ∂y_xx = (y[t, x+1] - 2*y[t, x] + y[t, x-1])/Δx^2
        y[t+1, x] = c^2 * Δt^2 * ∂y_xx  + 2*y[t, x] - y[t-1, x]
    end

    return y
end

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

f(x,L) = 2*exp(-(x-L/2)^2) + x/L
g(x) = 0

L = 1.5*pi
T = 240
c = 0.02

wave = Wave(x -> f(x,L), g, c)

#+

y1 = solve_wave(T, L, wave; n_t=241, n_x=101)
plot_wave(y1, joinpath(pwd(), "lecture_13", "wave1.gif"); ylims=(-2,3), label="")

#+

y2 = solve_wave(T, L, wave; n_t=241, n_x=7)
plot_wave(y2, joinpath(pwd(), "lecture_13", "wave2.gif"); ylims=(-2,3), label="")