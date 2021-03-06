using Pkg
Pkg.activate(pwd())

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



# ---
# 
# ### Exercise:
# Write the dependence on the petal width on the petal length. Plot it in the previous
# graph.
# 
# ---
# ### Solution:
