# # Logistic regression
# ## Loading and preparing data


using StatsPlots
using RDatasets

iris = dataset("datasets", "iris")

# ### Exercise:
# Create the `iris_reduced` dataframe in the following way:
# - Label "setosa" will be deleted.
# - Label "versicolor" will be the negative class.
# - Label "virginica" will be the positive class.
# - Add the `intercept` column with ones as entries.
# For the features, consider only petal length and petal width.
# 
# **Hint**: Use the `Query` package or do it manually via the `!insertcols` function.
# 
# ---
# ### Solution:

using Query

iris_reduced = @from i in iris begin
    @where i.Species != "setosa"
    @select {
        i.PetalLength,
        i.PetalWidth,
        intercept = 1,
        i.Species,
        label = i.Species == "virginica",
    }
    @collect DataFrame
end

#+

iris_reduced2 = iris[iris.Species .!= "setosa", :]
iris_reduced2 = iris_reduced2[:,[3;4;5]]

insertcols!(iris_reduced2, 3, :intercept => 1)
insertcols!(iris_reduced2, 5, :label => iris_reduced2.Species .== "virginica")

#+

isequal(iris_reduced, iris_reduced2)

# ---

X = Matrix(iris_reduced[:, 1:3])
y = iris_reduced.label


# ### Exercise:
# Since X has two features (columns), it is simple to visualize. Use scatter plot to show
# the data. Use different colours for different classes. Try to produce a nice graph by
# including names of classes and axis labels (petal length and petal width).
# 
# ---
# ### Solution:

using Plots

@df iris_reduced scatter(
    :PetalLength,
    :PetalWidth;
    group = :Species,
    xlabel = "Petal length",
    ylabel = "Petal width",
    legend = :topleft,
)

# ---
# 
# ## Training the classifier
# ### Exercise:
# Write a function log_reg which takes as an input the dataset, the labels and the initial 
# point. It should use Newton's method to find the optimal weights ``w``. Print the results 
# when started from zero.
# 
# It would be possible to use the code optim(f, g, x, s::Step) from the previous lecture
# and define only the step function s for the Newton's method. However, sometimes it may be 
# better to write simple functions separately instead of using more complex machinery.
# 
# ---
# ### Solution:

using Statistics

σ(z) = 1/(1+exp(-z))

function log_reg(X, y, w; max_iter=100, tol=1e-6)
    X_mult = [row*row' for row in eachrow(X)]
    for i in 1:max_iter
        y_hat = σ.(X*w)
        grad = X'*(y_hat.-y) / size(X,1)
        hess = y_hat.*(1 .-y_hat).*X_mult |> mean
        w -= hess \ grad
    end
    return w
end

w = log_reg(X, y, zeros(size(X,2)))

# ---
# 
# ## Analyzing the solution

using LinearAlgebra

separ(x::Real, w) = (-w[3]-w[1]*x)/w[2]

xlims = extrema(iris_reduced.PetalLength) .+ [-0.1, 0.1]
ylims = extrema(iris_reduced.PetalWidth) .+ [-0.1, 0.1]

@df iris_reduced scatter(
    :PetalLength,
    :PetalWidth;
    group = :Species,
    xlabel = "Petal length",
    ylabel = "Petal width",
    legend = :topleft,
    xlims,
    ylims,
)

plot!(xlims, x -> separ(x,w); label = "Separation", line = (:black,3))

#+

y_hat = σ.(X*w)
grad = X'*(y_hat.-y) / size(X,1)
norm(grad)


# ### Exercise:
# Compute how many samples were correctly and incorrectly classified.
# 
# ---
# ### Solution:

pred = y_hat .>= 0.5
"Correct number of predictions: " * string(sum(pred .== y)) |> println
"Wrong   number of predictions: " * string(sum(pred .!= y)) |> println