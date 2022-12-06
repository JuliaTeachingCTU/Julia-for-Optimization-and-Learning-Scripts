using Pkg
Pkg.activate(pwd())

# # Introduction to Flux

include(joinpath(pwd(), "lecture_11", "utilities.jl"))

using RDatasets
using Random

Random.seed!(666)
iris = dataset("datasets", "iris")

#+

X = Matrix(iris[:, 1:4])
y = iris.Species

X_train, y_train, X_test, y_test, classes = prepare_data(X', y; dims=2)

# ## Creating the network

using Flux

n_hidden = 5
m = Chain(
    Dense(size(X_train,1), n_hidden, relu),
    Dense(n_hidden, size(y_train,1), identity),
    softmax,
)

#+

using Flux: params

m(X_train)
params(m[2])[2] .= [-1;0;1]

## Training the network

using Flux: crossentropy

L(x, y) = crossentropy(m(x), y)
L(X_train, y_train)

#+

ps = params(m)
grad = gradient(() -> L(X_train, y_train), params(X_train))
size(grad[X_train])

#+

using Plots

opt = Descent(0.1)
max_iter = 250

acc_test = zeros(max_iter)
for i in 1:max_iter
    gs = gradient(() -> L(X_train, y_train), ps)
    Flux.Optimise.update!(opt, ps, gs)
    acc_test[i] = accuracy(X_test, y_test)
end

plot(acc_test, xlabel="Iteration", ylabel="Test accuracy", label="", ylim=(-0.01,1.01))
