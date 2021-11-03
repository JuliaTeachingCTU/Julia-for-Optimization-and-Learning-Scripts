# # Linear regression revisited
# ## Hypothesis testing

using Random
using Statistics
using LinearAlgebra
using Plots

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

Random.seed!(666)
n = 1000
xs = randn(n)

# ### Exercise:
# Use the ``t``-test to verify whether the samples were generated from a distribution with 
# zero mean.
# 
# **Hints:**
# - The Student's distribution is invoked by `TDist()`.
# - The probability ``\mathbb P(T\le t)`` equals to the
# [distribution function](https://en.wikipedia.org/wiki/Cumulative_distribution_function)
# ``F(t)``, which can be called by `cdf`.
# 
# ---
# ### Solution:

using Distributions

t = mean(xs) / std(xs) * sqrt(n)
prob = cdf(TDist(n-1), t)
p = 2*min(prob, 1-prob)

# ---

using HypothesisTests

OneSampleTTest(xs)


# ## Linear models

using RDatasets

wages = dataset("plm", "Snmesp")
wages.W = 2. .^ (wages.W)

#+

X = Matrix(wages[:, [:N, :Y, :I, :K, :F]])
X = hcat(ones(size(X,1)), X)
y = wages[:, :W]

w0 = (X'*X) \ (X'*y)

#+

using GLM

model = lm(@formula(W ~ 1 + N + Y + I + K + F), wages)

# ### Exercise:
# Check that the solution computed by hand and by `lm` are the same.
# 
# Then remove the feature with the highest ``p``-value and observe whether there was any 
# performance drop. The performance is usually evaluated by the
# [coeffient of determination](https://en.wikipedia.org/wiki/Coefficient_of_determination) 
# denoted by ``R^2\in[0,1]``. Its higher values indicate a better model.
# 
# **Hint**: Use functions `coef` and `r2`.
# 
# ---
# ### Solution:

norm(coef(model) - w0)
model_red = lm(@formula(W ~ 1 + N + Y + I + F), wages)

(r2(model), r2(model_red))

# ---

y_hat = predict(model)

plot_histogram(y_hat, x -> pdf(Normal(mean(y_hat), std(y_hat)), x)) |> display
plot_histogram(y_hat, x -> pdf(fit(Normal, y_hat), x)) |> display

#+

test_normality = ExactOneSampleKSTest(y_hat, Normal(mean(y_hat), std(y_hat)))

# ## Generalized linear models

model = glm(@formula(W ~ 1 + N + Y + I + K + F), wages, InverseGaussian(), SqrtLink())


# ### Exercise:
# Create the scatter plot of predictions and labels. Do not use the `predict` function.
# 
# ---
# ### Solution:

g_inv(z) = z^2
y_hat = g_inv.(X*coef(model))

scatter(y, y_hat;
    label="",
    xlabel="Label",
    ylabel="Prediction",
)
