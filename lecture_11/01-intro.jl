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
    Dense(size(X_train,1) => n_hidden, relu),
    Dense(n_hidden => size(y_train,1), identity),
    softmax,
)

#+

using Flux: params

m(X_train)
params(m[2])[2] .= [-1;0;1]

## Training the network

using Flux: crossentropy

L(ŷ, y) = crossentropy(ŷ, y)
L(m(X_train), y_train)

#+

grads = Flux.gradient(m -> L(m(X_train), y_train), m)
grads[1][:layers][2]

#+

using Plots

opt = Descent(0.1)
opt_state = Flux.setup(opt, m)
max_iter = 250

acc_train = zeros(max_iter)
acc_test = zeros(max_iter)
for i in 1:max_iter
    gs = Flux.gradient(m -> L(m(X_train), y_train), m)
    Flux.update!(opt_state, m, gs[1])
    acc_train[i] = accuracy(X_train, y_train)
    acc_test[i] = accuracy(X_test, y_test)
end

plot(acc_train, xlabel="Iteration", ylabel="Accuracy", label="train", ylim=(-0.01,1.01))
plot!(acc_test, xlabel="Iteration", label="test", ylim=(-0.01,1.01))

savefig("Iris_train_test_acc.svg")
