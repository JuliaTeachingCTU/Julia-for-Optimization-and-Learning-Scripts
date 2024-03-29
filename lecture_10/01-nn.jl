using Pkg
Pkg.activate(pwd())

# # Neural networks
# ## Prepare data

using RDatasets

iris = dataset("datasets", "iris")
X = Matrix(iris[:, 1:4])
y = iris.Species

#### Exercise:
#Write the `split` function, which randomly splits the dataset and the labels into training 
#and testing sets. Its input should be the dataset `X` and the labels `y`. It should have 
#four outputs. Include 80% of data in the training set and 20% of data in the testing set 
# by default.
#
#**Hints:**
#- Use the `randperm` function from the `Random` package.
#- While `y` can be assumed to a vector, `X` is a matrix or a more-dimensional array. Then 
#it is beneficial to use the `selectdim` function to select subindices along the correct 
#dimension.
#
#---
#### Solution:


#+

X_train, y_train, X_test, y_test = split(X, y)

# ---
# 
# ### Exercise:
# Write the `normalize` functions as described above. It should have two inputs and two 
# outputs. The keyword argument `dims` should also be included.
# 
# **Hint**: check the help for the `mean` function.
# 
# ---
# ### Solution:



# ---
# 
# ### Exercise:
# Write the `onehot` function that converts the labels `y` into their one-hot 
# representation. The samples should be along the second dimension. Write the `onecold` 
# function that converts the one-hot representation into the one-cold (original)
# representation. Both these functions need to have two arguments; the second one is 
# `classes`, which equals `unique(y)`.
# 
# Write a check that both functions work correctly.
# 
# **Hints:**
# - The one-hot representation for a label has the size equalling to the number of classes. 
# All entries besides one are zeros.
# - Since the one-hot representation represents probabilities, the prediction is the class 
# with the highest probability.
# 
# ---
# ### Solution:



# ---

using LinearAlgebra

function prepare_data(X, y; do_normal=true, do_onehot=true, kwargs...)
    X_train, y_train, X_test, y_test = split(X, y; kwargs...)

    if do_normal
        X_train, X_test = normalize(X_train, X_test; kwargs...)
    end

    classes = unique(y)

    if do_onehot
        y_train = onehot(y_train, classes)
        y_test = onehot(y_test, classes)
    end

    return X_train, y_train, X_test, y_test, classes
end

#+

Random.seed!(666)

iris = dataset("datasets", "iris")
X = Matrix(iris[:, 1:4])
y = iris.Species

X_train, y_train, X_test, y_test, classes = prepare_data(X', y; dims=2)

#+

Random.seed!(666)
aux1 = prepare_data(X, y; dims=1)

#+

Random.seed!(666)
aux2 = prepare_data(X', y; dims=2)

#+

norm(aux1[1] - aux2[1]')

# ## Create the network

struct SimpleNet{T<:Real}
    W1::Matrix{T}
    b1::Vector{T}
    W2::Matrix{T}
    b2::Vector{T}
end

# ### Exercise:
# Write an outer constructor for `SimpleNet`. Its inputs should be three integers 
# representing the input size of the three layers. All matrices should be initialized based 
# on the normal distribution.
# 
# **Hint**: think about the representation of the dense layer.
# 
# ---
# ### Solution:



# ---

Random.seed!(666)
m = SimpleNet(size(X_train,1), 5, size(y_train,1))

# ### Exercise:
# Write a functor `function (m::SimpleNet)(x)` which computes the prediction (forward pass) 
# of the neural network `SimpleNet`.
# 
# **Bonus**: try to make the functor work for both vectors (one sample) and matrices 
# (multiple samples) `x`.
# 
# ---
# ### Solution:



# ---

m(X_train[:,1:2]) 

# ## Train the network

function grad(m::SimpleNet, x::AbstractVector, y; ϵ=1e-10)
    z1 = m.W1*x .+ m.b1
    a1 = max.(z1, 0)
    z2 = m.W2*a1 .+ m.b2
    a2 = exp.(z2) ./ sum(exp.(z2), dims=1)
    l = -sum(y .* log.(a2 .+ ϵ))

    e_z2 = exp.(z2)
    l_part = (- e_z2 * e_z2' + Diagonal(e_z2 .* sum(e_z2))) / sum(e_z2)^2

    l_a2 = - y ./ (a2 .+ ϵ)
    l_z2 = l_part * l_a2
    l_a1 = m.W2' * l_z2
    l_z1 = l_a1 .* (a1 .> 0)
    l_x = m.W1' * l_z1

    l_W2 = l_z2 * a1'
    l_b2 = l_z2
    l_W1 = l_z1 * x'
    l_b1 = l_z1

    return l, l_W1, l_b1, l_W2, l_b2
end

#+

g_all = [grad(m, X_train[:,k], y_train[:,k]) for k in 1:size(X_train,2)]
typeof(g_all)

#+

function mean_tuple(d::AbstractArray{<:Tuple})
    Tuple([mean([d[k][i] for k in 1:length(d)]) for i in 1:length(d[1])])
end

#+

g_mean = mean_tuple(g_all)
typeof(g_mean)

# ### Exercise:
# Train the network with a gradient descent with stepsize ``\alpha=0.1`` for ``200`` 
# iterations. Save the objective value at each iteration and plot the results.
# 
# ---
# ### Solution:



# ---

using Plots

plot(L;
    xlabel="Iteration",
    ylabel="Loss function",
    label="",
    title="Loss function on the training set"
)

# ## Prediction
# ### Exercise:
# 
# Write a function which predict the labels for samples. Show the accuracy on both training # and testing sets.
# 
# ---
# ### Solution:
