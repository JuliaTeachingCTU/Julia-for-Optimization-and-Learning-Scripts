using Pkg
Pkg.activate(pwd())

# # Julia package
# ## Introduction

using DifferentialEquations

f(u,p,t) = 0.98*u

u0 = 1.0
tspan = (0.0, 1.0)

#+

prob = ODEProblem(f, u0, tspan)
sol = solve(prob)

#+

using Plots

plot(sol; label="")

#+

sol(0.8)

# ### Exercise:
# 
# When calling the `solve` function, we can specify the interpolation way. Solve the ODE
# with linear interpolation (`dense=false`) and the Runge-Kutta method of the fourth order 
# (`RK4()`). Plot the results and compare them with the default and original solutions.
# 
# ---
# ### Solution:

sol2 = solve(prob, dense=false)
sol3 = solve(prob, RK4())

#+

ts = range(tspan...; length = 100)

plot(ts, t->exp(0.98*t), label="True solution", legend=:topleft);
plot!(ts, t->sol(t), label="Default");
plot!(ts, t->sol2(t), label="Linear");
plot!(ts, t->sol3(t), label="Runge-Kutta")

# ---
# 
# ## Lorenz system

function lorenz(u, p, t)
    σ, ρ, β = p
    x_t = σ*(u[2]-u[1])
    y_t = u[1]*(ρ-u[3]) - u[2]
    z_t = u[1]*u[2] - β*u[3]
    return [x_t; y_t; z_t]
end

#+

u0 = [1.0; 0.0; 0.0]
p = [10; 28; 8/3] 
tspan = (0.0, 100.0)

#+

prob = ODEProblem(lorenz, u0, tspan, p)
sol = solve(prob)

#+

plot(sol)

#+

plt1 = plot(sol, vars=(1,2,3), label="")

#+

plot(sol, vars=(1,2,3), denseplot=false; label="")

#+

traj = hcat(sol.u...)
plot(traj[1,:], traj[2,:], traj[3,:]; label="")

# ### Exercise:
# 
# Use the `nextfloat` function to perturb the first parameter of `p` by the smallest
# possible value. Then solve the Lorenz system again and compare the results by plotting
# the two trajectories next to each other.
# 
# ---
# ### Solution:

p0 = (nextfloat(p[1]), p[2:end]...) 

#+

prob0 = ODEProblem(lorenz, u0, tspan, p0)
sol0 = solve(prob0)

#+

plt0 = plot(sol0, vars=(1,2,3), label="")
plot(plt1, plt0; layout=(1,2))

# ---

hcat(sol(tspan[2]), sol0(tspan[2]))