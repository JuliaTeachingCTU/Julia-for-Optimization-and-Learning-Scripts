using Pkg
Pkg.activate(pwd())

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



# ---
# 
# ## BSON.jl

using BSON

BSON.bson(joinpath(pwd(), "lecture_05", "test2.bson"), a = [1+2im, 3+4im], b = "Hello, World!")

#+

data = Dict(:a => [1+2im, 3+4im], :b => "Hello, World!")
BSON.bson(joinpath(pwd(), "lecture_05", "test1.bson"), data)

#+

BSON.load(joinpath(pwd(), "lecture_05", "test1.bson"))
BSON.load(joinpath(pwd(), "lecture_05", "test2.bson"))

#+

using BSON: @save, @load

a = [1+2im, 3+4im];
b = "Hello, World!";

@save joinpath(pwd(), "lecture_05", "test.bson") a b # Same as above
@load joinpath(pwd(), "lecture_05", "test.bson") a b # Loads `a` and `b` back into the workspace

# ## ProgressMeter.jl

using ProgressMeter

@showprogress 1 "Computing..." for i in 1:50
    sleep(0.1)
end

#+

x, n = 1 , 10;
p = Progress(n);

for iter in 1:10
    x *= 2
    sleep(0.5)
    ProgressMeter.next!(p; showvalues = [(:iter, iter), (:x, x)])
end

# ## BenchmarkTools.jl

using BenchmarkTools

@benchmark sin(x) setup=(x=rand())

#+

A = rand(3,3);
@btime inv($A);
