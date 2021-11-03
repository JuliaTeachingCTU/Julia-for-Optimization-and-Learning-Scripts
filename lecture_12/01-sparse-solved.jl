# # Linear regression with sparse constraints
# ## Ridge regression

using LinearAlgebra
using Random
using Plots

n = 10000
m = 1000

Random.seed!(666)

#+

X = randn(n, m)
y = 10*X[:,1] + X[:,2] + randn(n)

# ### Exercise:
# Implement the methods for the `ridge_reg` function. Verify that the result in the same
# result.
# 
# **Hints:**
# - The eigendecomposition can be found by `eigen(A)` or `eigen(A).values`.
# - The identity matrix is implemented by `I` in the `LinearAlgebra` package.
# 
# ---
# ### Solution:

ridge_reg(X, y, μ) = (X'*X + μ*I) \ (X'*y)
ridge_reg(X, y, μ, Q, Q_inv, λ) = Q * ((Diagonal(1 ./ (λ .+ μ)) * ( Q_inv * (X'*y))))

#+

eigen_dec = eigen(X'*X)
Q = eigen_dec.vectors
Q_inv = Matrix(Q')
λ = eigen_dec.values

#+

w1 = ridge_reg(X, y, 10)
w2 = ridge_reg(X, y, 10, Q, Q_inv, λ)

#+

norm(w1 - w2)

# ---

using BenchmarkTools

@btime ridge_reg(X, y, 10);
@btime ridge_reg(X, y, 10, Q, Q_inv, λ);

#+

μs = range(0, 1000; length=50)
ws = hcat(ridge_reg.(Ref(X), Ref(y), μs, Ref(Q), Ref(Q_inv), Ref(λ))...)

plot(μs, abs.(ws');
    label="",
    yscale=:log10,
    xlabel="mu",
    ylabel="weights: log scale",
)

# ## Lasso

S(x, η) = max(x-η, 0) - max(-x-η, 0)

function lasso(X, y, μ, Q, Q_inv, λ;
        max_iter = 100,
        ρ = 1e3,
        w = zeros(size(X,2)),
        u = zeros(size(X,2)),
        z = zeros(size(X,2)),
    )
    
    for i in 1:max_iter
        w = Q * ( (Diagonal(1 ./ (λ .+ ρ)) * ( Q_inv * (X'*y + ρ*(z-u))))) 
        z = S.(w + u, μ / ρ)
        u = u + w - z
    end
    return w, u, z
end

#+

ws = zeros(size(X,2), length(μs))

for (i, μ) in enumerate(μs)
    global w, u, z
    w, u, z = i > 1 ? lasso(X, y, μ, Q, Q_inv, λ; w, u, z) : lasso(X, y, μ, Q, Q_inv, λ)
    ws[:,i] = w
end

plot(μs, abs.(ws');
    label="",
    yscale=:log10,
    xlabel="mu",
    ylabel="weights: log scale",
)
