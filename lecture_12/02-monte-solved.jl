# # Monte Carlo sampling
# ## Gamma function

using SpecialFunctions
using Plots

plot(0:0.1:10, gamma;
    xlabel="x",
    ylabel="gamma(x): log scale",
    label="",
    yscale=:log10,
)


# ## Volume of m-dimensional ball
# ### Exercise:
# Use the [formula](https://en.wikipedia.org/wiki/Volume_of_an_n-ball) to compute the volume
# of a $m$-dimensional ball. Plot the dependence of the volume on the dimension
# $m=1, \dots, 100$.
# 
# ---
# ### Solution:

volume_true(m, R) = π^(m/2) *R^2 / gamma(m/2 + 1)

plot(1:100, m -> volume_true.(m, 1);
    xlabel="dimension",
    ylabel="unit ball volume: log scale",
    label="",
    yscale=:log10,
)

# ---
# 
# ### Exercise:
# Write the function `volume_monte_carlo`, which estimates the volume of the 
# $m$-dimensional ball based on $n$ randomly sampled points.
# 
# **Hint**: function `rand(m,n)` creates a $m\times n$ matrix, which can be understood as 
# $n$ randomly sampled points in $[0,1]^m$. Transform them to $[-1,1]^m$.
# 
# ---
# ### Solution:

using Random
using Statistics

function volume_monte_carlo(m::Int; n::Int=10000)
    X = 2*rand(m, n).-1
    X_norm_sq = sum(X.^2; dims=1)
    return 2^m*mean(X_norm_sq .<= 1)
end

# ---

ms = 1:15
ns = Int64.([1e1; 1e3; 1e5])

Random.seed!(666)

plt = plot(ms, m -> volume_true(m, 1);
    xlabel="dimension",
    ylabel="unit ball volume",
    legend=:topleft,
    label="True",
    line=(4,:black),
)

#+

for n in ns
    plot!(plt, ms, m -> volume_monte_carlo.(m; n=n); label="n = $n")
end

display(plt)

#+

using Distributions

rand(Uniform(-1, 1), 10, 5)


# ## Sampling from distributions

using Distributions

d1 = Normal()
d2 = Normal(1, 1)
d3 = Normal(0, 0.01)

#+

f1(x) = pdf(d1, x)
f2(x) = pdf(d2, x)
f3(x) = pdf(d3, x)

#+

function plot_histogram(xs, f; kwargs...)
    plt = histogram(xs;
        label="Sampled density",
        xlabel = "x",
        ylabel = "pdf(x)",
        nbins = 85,
        normalize = :pdf,
        opacity = 0.5,
        kwargs...
    )

    plot!(plt, range(minimum(xs), maximum(xs); length=100), f;
        label="True density",
        line=(4,:black),
    )

    return plt
end

#+

plot_histogram(rand(d1, 1000000), f1)


# ### Exercise:
# Implement the `rejection_sampling` function. It should generate $n$ trial points and 
# return all accepted points.
# 
# ---
# ### Solution:

function rejection_sampling(f, f_max, x_min, x_max; n=1000000)
    xs = x_min .+ (x_max - x_min)*rand(n)
    ps = f_max*rand(n)
    return xs[f.(xs) .>= ps]
end

# ---

xlims = (-10, 10)

for (f, d) in zip((f1, f2, f3), (d1, d2, d3))
    Random.seed!(666)
    xs = rejection_sampling(f, f(d.μ), xlims...)

    plt = plot_histogram(xs, f)
    display(plt)
end

#+

h(x) = cos(100*x)

Δx = 0.001
xs = range(xlims...; step=Δx)
e0 = Δx * sum(f3.(xs) .* h.(xs))

#+

expectation1(h, d; n = 1000000) = mean(h, rand(d, n))

function expectation2(h, f, f_max, xlims; n=1000000)
    return mean(h, rejection_sampling(f, f_max, xlims...; n))
end

function expectation3(h, f, d_gen; n=1000000)
    g(x) = h(x)*f(x)/pdf(d_gen, x)
    return mean(g, rand(d_gen, n))
end

#+

n = 100000
n_rep = 20

Random.seed!(666)
e1 = [expectation1(h, d3; n=n) for _ in 1:n_rep]
e2 = [expectation2(h, f3, f3(d3.μ), xlims; n=n) for _ in 1:n_rep]
e3 = [expectation3(h, f3, d1; n=n) for _ in 1:n_rep]

#+

scatter([1], [e0]; label="Integral discretization", legend=:topleft);
scatter!(2*ones(n_rep), e1; label="Generating from Distributions.jl");
scatter!(3*ones(n_rep), e2; label="Generating from rejection sampling");
scatter!(4*ones(n_rep), e3; label="Generating from other distribution")

# # How many samples do we need?
# ### Exercise:
# 
# Sample $n=1000$ in the $m=9$-dimensional space. What is the minimum distance of these 
# points? Before implementing the exercise, try to guess the answer.
# 
# ---
# ### Solution:

using LinearAlgebra

n = 1000
m = 9

Random.seed!(666)
xs = rand(m, n)

dist1 = [norm(x-y) for x in eachcol(xs), y in eachcol(xs)]
dist2 = [dist1[i,j] for i in 1:n for j in i+1:n]

extrema(dist2)

# ---

quantile_sampled1(d, n::Int, α) = partialsort(rand(d, n), floor(Int, α*n))
quantile_sampled2(d, n::Int, α) = quantile(rand(d, n), α)
quantile_sampled1(d, ns::AbstractVector, α) = quantile_sampled1.(d, ns, α)
quantile_sampled2(d, ns::AbstractVector, α) = quantile_sampled2.(d, ns, α)

#+

α = 0.99
n_rep = 20
ns = round.(Int, 10 .^ (1:0.05:5))

Random.seed!(666)
qs1 = hcat([quantile_sampled1(d1, ns, α) for _ in 1:n_rep]...)

#+

Random.seed!(666)
qs2 = hcat([quantile_sampled2(d1, ns, α) for _ in 1:n_rep]...)

#+

plt1 = plot([0.9*minimum(ns); 1.1*maximum(ns)], quantile(d1, α)*ones(2);
    xlabel="n: log scale",
    ylabel="sampled quantile",
    xscale=:log10,
    label="True quantile",
    line=(4,:black),
    ylims=(0,3.5),
);
plt2 = deepcopy(plt1);


for i in 1:size(qs1,1)
    scatter!(plt1, ns[i]*ones(size(qs1,2)), qs1[i,:];
        label="",
        color=:blue,
        markersize = 2,
    )
    scatter!(plt2, ns[i]*ones(size(qs2,2)), qs2[i,:];
        label="",
        color=:blue,
        markersize = 2,
    )
end

plot!(plt1, ns, mean(qs1; dims=2);
    label="Sampled mean",
    line=(4,:red),
);
plot!(plt2, ns, mean(qs2; dims=2);
    label="Sampled mean",
    line=(4,:red),
);

display(plt1)
display(plt2)