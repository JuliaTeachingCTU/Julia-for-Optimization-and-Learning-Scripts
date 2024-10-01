using Pkg
Pkg.activate(pwd() * "/lecture_03")

# # Other Useful Packages
# ## Distributions.jl

using Distributions

D = Normal(2, 0.5)

#+

mean(D)
var(D)
quantile(D, 0.9)
pdf(D, 2)
cdf(D, 2)

#+

using StatsPlots

plot(
    plot(D; title = "pdf"),
    plot(D; func = cdf,  title = "cdf");
    legend = false,
    xlabel = "x",
    ylabel = "f(x)",
    ylims = (0,1),
    linewidth = 2,
    layout = (1,2),
    size = (800, 400),
)

#+

x = rand(Normal(2, 0.5), 10000); # generate 10000 random numbers from Normal(2, 0.5)
D = fit(Normal, x)

#+

histogram(x; normalize = :pdf, legend = false, opacity = 0.5)
plot!(D; linewidth = 2, xlabel = "x", ylabel = "pdf(x)")

# ### Exercise:
# Create a figure that shows the gamma distributions with the following parameters:
# `(2, 2)`, `(9, 0.5)`, `(7.5, 1)` and `(0.5, 1)`.
#
# **Hint:** to plot cumulative probability functions, use the Plots ability to
# plot functions.
# 
# ---
# ### Solution:

Ds = Gamma.([2, 9, 7.5, 0.5], [2, 0.5, 1, 1])
labels = reshape(string.("Gamma", params.(Ds)), 1, :)

plot(Ds;
    xaxis = ("x", (0, 20)),
    yaxis = ("pdf(x)", (0, 0.5)),
    labels = labels,
    linewidth = 2,
    legend = :topright,
)

#+

plot(Ds;
    func = cdf,
    xaxis = ("x", (0, 20)),
    yaxis = ("cdf(x)", (0, 1.05)),
    labels = labels,
    linewidth = 2,
    legend = :bottomright,
)

#+

cdfs = [x -> cdf(D, x) for D in Ds]
plot(cdfs, 0, 20;
    xaxis = ("x", (0, 20)),
    yaxis = ("cdf(x)", (0, 1.05)),
    labels = labels,
    linewidth = 2,
    legend = :bottomright,
)

# ---
# 
# ## BSON.jl

using BSON

BSON.bson(joinpath(pwd(), "lecture_03", "test2.bson"), a = [1+2im, 3+4im], b = "Hello, World!")

#+

data = Dict(:a => [1+2im, 3+4im], :b => "Hello, World!")
BSON.bson(joinpath(pwd(), "lecture_03", "test1.bson"), data)

#+

BSON.load(joinpath(pwd(), "lecture_03", "test1.bson"))
BSON.load(joinpath(pwd(), "lecture_03", "test2.bson"))

#+

using BSON: @save, @load

a = [1+2im, 3+4im];
b = "Hello, World!";

@save joinpath(pwd(), "lecture_03", "test.bson") a b # Same as above
@load joinpath(pwd(), "lecture_03", "test.bson") a b # Loads `a` and `b` back into the workspace

# ## ProgressMeter.jl

using ProgressMeter

@showprogress 1 "Computing..." for i in 1:50
    sleep(0.1)
end

#+

x, n = 1, 10;
p = Progress(n);

for iter in 1:10
    x *= 2 # needs to be global x for this to work as a run script
    sleep(0.5)
    ProgressMeter.next!(p; showvalues = [(:iter, iter), (:x, x)])
end

# ## BenchmarkTools.jl

using BenchmarkTools

@benchmark sin(x) setup=(x=rand())

#+

A = rand(3,3);
@btime inv($A);
