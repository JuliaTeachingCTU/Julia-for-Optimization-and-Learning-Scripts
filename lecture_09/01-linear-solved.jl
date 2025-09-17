using Pkg
Pkg.activate(pwd() * "/lecture_09")

# # Linear regression
# ## Loading and preparing data

using Plots
using StatsPlots
using RDatasets

iris = dataset("datasets", "iris")
iris[1:5,:]

# ### Exercise:
# We will simplify the goal and estimate the dependence of petal width on petal length. # Create the data $X$ (do not forget to add the bias) and the labels $y$.
# 
# Make a graph of the dependence of petal width on petal length.
# 
# ---
# ### Solution:

y = iris.PetalWidth
X = hcat(iris.PetalLength, ones(length(y)))

@df iris scatter(
    :PetalLength,
    :PetalWidth;
    label="",
    xlabel = "Petal length",
    ylabel = "Petal width"
)

# ---
# 
# ## Training the classifier
# ### Exercise:
# Use the closed-form formula to get the coefficients $w$ for the linear regression. Then
# use the `optim` method derived in the previous lecture to solve the optimization problem 
# via gradient descent. The results should be identical.
#
#---
#### Solution:

abstract type Step end

struct GD <: Step
    α::Real
end

optim_step(s::GD, f, g, x) = -s.α*g(x)

function optim(f, g, x, s::Step; max_iter=100)
    for i in 1:max_iter
        x += optim_step(s, f, g, x)
    end
    return x
end

#+

using LinearAlgebra

w = (X'*X) \ (X'*y)
g(w) = X'*(X*w-y)
w2 = optim([], g, zeros(size(X,2)), GD(1e-4); max_iter=10000)

norm(w - w2)

# ---
# 
# ### Exercise:
# Write the dependence on the petal width on the petal length. Plot it in the previous
# graph.
# 
# ---
# ### Solution:

f_pred(x::Real, w) = w[1]*x + w[2]
x_lims = extrema(iris.PetalLength) .+ [-0.1, 0.1]

@df iris scatter(
    :PetalLength,
    :PetalWidth;
    xlabel = "Petal length",
    ylabel = "Petal width",
    label = "",
    legend = :topleft,
)

plot!(x_lims, x -> f_pred(x,w); label = "Prediction", line = (:black,3))
