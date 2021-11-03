using Pkg
Pkg.activate(pwd())

# # Plots.jl

using Plots

x = range(0, 2π; length = 100)
y = sin.(x)

plot(x, y)

#+

y = hcat(sin.(x), cos.(x))

plot(x, y);
plot!(x, sin.(x .+ π/4))

#+

plt = plot(x, hcat(sin.(x), cos.(x)));
plot!(plt, x, sin.(x .+ π/4))

# ## Plot attributes

x = range(0, 2π; length = 100)
y = hcat(sin.(x), cos.(x))

plot(x, y;
    label = ["sine" "cosine"],
    xguide = "x",
    yguide = "y",
    legend = :bottomleft,
    title = "Trigonometric functions",
    xticks = (0:0.5π:2π, ["0", "0.5π", "π", "1.5π", "2π"]),
    color = [:red :blue],
    linestyle = [:dash :dot],
    linewidth = [2 4],
)

#+

n = 200
x = range(0, 2π; length = n)
linewidth = range(1, 50; length = n)
color = palette(:viridis, n)
xlims = (0, 7)
ylims = (-1.2, 1.2)
label = ""

plot(x, sin.(x); linewidth, color, label, xlims, ylims)

#+

plot(x, [sin.(x) cos.(x)]; linewidth, color = [color :red], label, xlims, ylims)

#+

plotattr(:Series)

#+

plotattr("title")

#+

plotattr("xguide")

#+

plotattr("guide")


# ### Exercise:
# Consider the following set of equations
#
# $$
# \begin{aligned}
# x(t) & = \cos(3t), \\
# y(t) & = \sin(2t),\\
# \end{aligned}
# $$
#
# where $t \in [0, 2\pi]$. Create a plot of the curve described by the equations above.
# Use plot attributes to set the following properties:
#
# 1. The line width should start at `1`, increase to `50` and then decrease back to `1`.
# 2. The line color should change with the changing line width.
#
# Use `:viridis` color scheme or any other
# [color scheme](http://docs.juliaplots.org/latest/generated/colorschemes/) supported by
# the Plots package. Use additional plot attributes to get a nice looking graph.
#
# **Hints:**
# - use the `pallete` function combined with the `collect` function to generate a vector of
# colors from the `:viridis` color scheme.
# - remove all decorators by using: `axis = nothing`, `border = :none`.
# 
# ---
# ### Solution:



# ---
# 
# ## Function plotting

t = range(0, 2π; length = 100)

plot(t, [sin, cos]; label = ["sine" "cosine"])

#+

plot(sin, x -> sin(2x), t; linewidth = 2, label = "")

#+

plot(sin, x -> sin(2x), 0, 2π, 100; linewidth = 2, label = "")

# ### Exercise:
# Create a plot given by the following set of equations:
#
# $$
# \begin{aligned}
# x(t) & = (a + b)\cos(t) - b \cdot \cos \left( \left(\frac{a}{b} + 1 \right)t \right), \\
# y(t) & = (a + b)\sin(t) - b \cdot \sin \left( \left(\frac{a}{b} + 1 \right)t \right), \\
# \end{aligned}
# $$
# where $a = 4.23$, $b = 2.35$ and $t \in [-15, 20]$. Use additional plot attributes
# to get a nicely looking graph.
# 
# ---
# ### Solution:



# ---
# 
# Changing the plotting series

x = range(0, 2π; length = 100)
y = sin.(x)

plot(x, y; seriestype = :scatter)

#+

scatter(x, y)

# ### Exercise:
# Consider the following function:
#
# $$
# f(x, y) = \frac{x^2 \cdot y^2}{x^4 + y^4}.
# $$
#
# Draw this function for $x, y \in [-5, 5]$. Use the following three plot series
# `contourf`, `heatmap`, and `surface` with the following settings:
# - `:viridis` color scheme,
# - camera angle `(25, 65)`,
# - no legend, color bar, or decorators (`axis`, `frame` and `ticks`).
# 
# ---
# ### Solution:



# ---
# 
# Subplots

x = range(0, 2π; length = 100)

plot(x, [sin, cos, tan, sinc];
    layout = 4,
    linewidth = 2,
    legend = false,
    title = ["1" "2" "3" "4"],
)

#+

plot(x, [sin, cos, tan, sinc];
    layout = grid(4, 1; heights = [0.1 ,0.4, 0.4, 0.1]),
    linewidth = 2,
    legend = false,
)

#+

l = @layout [a ; b{0.3w} c]
plot(x, [sin, cos, tan]; layout = l, linewidth = 2, legend = false)

#+

linewidth = range(1, 20; length = 100)

p1 = plot(x, sin; legend = false, line_z = 1:100, color = :viridis, linewidth);
p2 = plot(x, cos; legend = false, line_z = 1:100, color = :Blues_9, linewidth);
p3 = plot(x, tan; legend = false, line_z = 1:100, color = :hsv, linewidth);

l = @layout [a ; b{0.3w} c]
plot(p1, p2, p3; layout = l)

# ## Animations

n = 300

plt = plot(Float64[], [sin, cos];
    legend = false,
    xlims = (0, 6π),
    ylims = (-1.1, 1.1),
    linewidth = range(1, 20; length = n),
    color = palette(:viridis, n),
    axis = nothing,
    border = :none
)

anim = Animation()

for x in range(0, 6π; length = n)
    push!(plt, x, [sin(x), cos(x)])
    frame(anim)
end

gif(anim, joinpath(pwd(), "lecture_05", "animsincos.gif"), fps = 15)

#+

x = range(-5, 5; length = 400)
fz(x, y) = x^2*y^2/(x^4 + y^4)

plt = surface(x, x, fz;
    camera = (30, 65),
    color = :viridis,
    legend = false,
    axis = nothing,
    border = :none,
    cbar = false,
)

anim = @animate for i in vcat(30:60, 60:-1:30)
    plot!(plt, camera = (i, 65))
end

gif(anim, joinpath(pwd(), "lecture_05", "animsurf.gif"), fps = 15)
