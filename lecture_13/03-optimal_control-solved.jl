using Pkg
Pkg.activate(pwd())

# # Optimal control
# ## Computing trajectories with no control

struct PMSM{T<:Real}
    ρ::T
    ω::T
    A::Matrix{T}
    invA::Matrix{T}

    function PMSM(ρ, ω)
        A = -ρ*[1 0; 0 1] -ω*[0 -1; 1 0]
        return new{eltype(A)}(ρ, ω, A, inv(A))
    end
end

#+

function expA(p::PMSM, t)
    ρ, ω = p.ρ, p.ω
    return exp(-ρ*t)*[cos(ω*t) sin(ω*t); -sin(ω*t) cos(ω*t)]
end

#+

ρ = 0.1
ω = 2
x0 = [0;-0.5]
q = [1;0]

ps = PMSM(ρ, ω)


# ### Exercise:
# 
# Verify that the matrix exponential is computed correctly and that it is different from
# the elementwise exponential.
# 
# **Hint**: The matrix exponential can also be computed directly by the `exp` function from 
# the `LinearAlgebra` package.
# 
# ---
# ### Solution:

using LinearAlgebra

t = 5
exp0 = exp.(t*ps.A)
exp1 = exp(t*ps.A)
exp2 = expA(ps, t)

#+

norm(exp1 - exp0) >= 1e-10 || error("Matrices are wrong")
norm(exp1 - exp2) <= 1e-10 || error("Matrices are wrong")

# ---
# 
# ### Exercise:
# 
# Write two function `trajectory_fin_diff` and `trajectory_exact` which compute the 
# trajectory. The first one should use the finite difference method to discretize the
# time, while the second one should use the closed-form formula.
# 
# Plot both trajectories on time interval ``[0,10]`` with time discretization step
# ``\Delta t=0.01``. Since ``x(t)`` is a two-dimensional vector, plot each component
# on one axis.
# 
# ---
# ### Solution:

function trajectory_fin_diff(p::PMSM, x0, ts, q)
    xs = zeros(length(x0), length(ts))
    xs[:, 1] = x0

    for i in 1:length(ts)-1
        xs[:, i+1] = xs[:, i] + (ts[i+1]-ts[i])*(p.A * xs[:, i] + q)
    end
    return xs
end

function trajectory_exact(p::PMSM, x0, ts, q)
    xs = zeros(length(x0), length(ts))

    for (i, t) in enumerate(ts)
        xs[:, i] = expA(p, t)*(x0 + p.invA * (I - expA(p, -t))*q)
    end
    return xs
end

#+

using Plots

ts = 0:0.01:10

xs1 = trajectory_fin_diff(ps, x0, ts, q)
xs2 = trajectory_exact(ps, x0, ts, q)

plot(xs1[1,:], xs1[2,:], label="Finite differences");
plot!(xs2[1,:], xs2[2,:], label="True value")

# ---

ts = 0:0.0001:10

xs1 = trajectory_fin_diff(ps, x0, ts, q)
xs2 = trajectory_exact(ps, x0, ts, q)

plot(xs1[1,:], xs1[2,:], label="Finite differences");
plot!(xs2[1,:], xs2[2,:], label="True value")

# ## Solving the optimal control problem
# ### Exercise:
# 
# Solve the optimal time for ``x_{\rm tar}= (0.25, -0.5)`` with the maximum voltage
# ``U_{\rm max} = 0.1``.
# 
# **Hint**: To solve the equation above for ``t``, use the bisection method.

function bisection(f, a, b; tol=1e-6)
    fa = f(a)
    fb = f(b)
    fa == 0 && return a
    fb == 0 && return b
    fa*fb > 0 && error("Wrong initial values for bisection")
    while b-a > tol
        c = (a+b)/2
        fc = f(c)
        fc == 0 && return c
        if fa*fc > 0
            a = c
            fa = fc
        else
            b = c
            fb = fc
        end
    end
    return (a+b)/2
end

# ---
# ### Solution:

U_max = 0.1
x_t = [0.25;-0.5]

f(t) = norm(expA(ps, -t)*x_t - x0 - ps.invA*(I-expA(ps, -t))*q) - U_max/ps.ρ*(exp(ps.ρ*t)-1)
τ = bisection(f, minimum(ts), maximum(ts))

# ---

function trajectory_control(p::PMSM, x0, ts, q, U_max, p0)
    xs = zeros(length(x0), length(ts))

    for (i, t) in enumerate(ts)
        eAt  = expA(p, t)
        emAt = expA(p, -t)
        xs[:, i] = eAt*(x0 + p.invA * (I - emAt)*q + U_max/ρ*(exp(ρ*t) - 1)*p0)
    end
    return xs
end

#+

p0 = ps.ρ/(U_max*(exp(ps.ρ*τ)-1))*(expA(ps, -τ)*x_t - x0 - ps.invA*(I-expA(ps, -τ))*q)
p0 /= norm(p0)

#+

ts = range(0, τ; length=100)
traj = trajectory_control(ps, x0, ts, q, U_max, p0)

#+

plot(traj[1,:], traj[2,:], label="Optimal trajectory");
scatter!([x0[1]], [x0[2]], label="Starting point");
scatter!([x_t[1]], [x_t[2]], label="Target point")

#+

ts = 0:0.01:10
plt = plot();

for α = 0:π/4:2*π
    trj = trajectory_control(ps, x0, ts, q, U_max, [sin(α); cos(α)])
    plot!(plt, trj[1,:], trj[2,:], label="")
end

display(plt)