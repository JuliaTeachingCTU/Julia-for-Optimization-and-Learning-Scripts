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



# ---

hcat(sol(tspan[2]), sol0(tspan[2]))