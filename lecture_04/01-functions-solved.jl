# # Functions

function plus(x,y)
    x + y
end

#+

plus(2, 3)
plus(2, -3)

#+

function plus(x,y)
    return x + y
end

#+

function plus(x, y)
    return x + y
    println("I am a useless line of code!!")
end

#+

plus(4, 5)
plus(3, -5)

#+

function powers(x)
    return x, x^2, x^3, x^4
end

#+

ps = powers(2)
typeof(ps)

#+

x1, x2, x3, x4 = powers(2)
x3

# ### Exercise:
# Write function `power(x::Real, p::Integer)` that for a number $x$ and a (possibly
# negative) integer $p$ computes $x^p$ without using the `^` operator. Use only basic
# arithmetic operators `+`, `-`, `*`, `/` and the `if` condition. The annotation
# `p::Integer` ensures that the input `p` is always an integer.
#
# **Hint:** use recursion.
# 
# ---
# ### Solution:

function power(x::Real, p::Integer)
    if p == 0
        return 1
    elseif p > 0
        return x * power(x, p - 1)
    else
        return power(1/x, -p)
    end
end

#+

power(2, 5)
power(2, -2)
power(2, 5) == 2^5
power(5, -3) == 5^(-3)
power(2, 2.5)

# ---
# 
# ## One-line functions


plus(x, y) = x + y

#+

plus(4, 5)
plus(3, -5)

#+

f(φ) = -4sin(φ - π/12)

#+

g(x) = (x -= 1; x *= 2; x)

#+

g(3)

# ### Exercise:
# Write a one-line function that returns `true` if the input argument is an even number and
# `false` otherwise.
#
# **Hint:** use modulo function and [ternary operator](@ref Ternary-operator) `?`.
# 
# ---
# ### Solution:

even(x::Integer) = mod(x, 2) == 0 ? true : false

#+

even(11)
even(14)

# ---
# 
# ## Optional arguments


hello(x = "world") = println("Hello $(x).")

#+

hello()
hello("people")

#+

powers(x, y = x*x, z = y*x, v = z*x) = x, y, z, v

#+

powers(2)
powers(2, 3)

#+

f(x = 1, y = x) = (x, y)
g(x = y, y = 1) = (x, y)

#+

f()
g()

# ### Exercise:
# Write a function which computes the value of the following quadratic form
# $$
# q_{a,b,c}(x,y) = ax^2 + bxy + cy^2,
# $$
# where $a, b, c, x \in \mathbb{R}$. Use optional arguments to set default values for
# parameters
# $$
# a = 1, \quad b = 2a, \quad c = 3(a + b).
# $$
# What is the function value at point $(4, 2)$ for default parameters? What is the
# function value at the same point if we use $c = 3$?
# 
# ---
# ### Solution:

q(x, y, a = 1, b = 2*a, c = 3*(a + b)) = a*x^2 + b*x*y + c*y^2

#+ 

q(4, 2)
q(4, 2, 1, 2, 3)

# ---
# 
# ## Keyword arguments

linear(x; a = 1, b = 0) = a*x + b

#+

linear(2)
linear(2; a = 2)
linear(2; b = 4)
linear(2; a = 2, b = 4)

#+

linear(b = 4, 2, a = 2) # If you use this, you will burn in hell 🔥🔥🔥🔥

#+

a, b = 2, 4

linear(2; a = a, b = b)
linear(2; a, b)

# ### Exercise:
# Write a probability density function for the
# [Gaussian distribution](https://en.wikipedia.org/wiki/Normal_distribution)
# $$
# f_{\mu, \sigma}(x) = \frac{1}{\sigma \sqrt{ 2\pi }} \exp\left\{ -\frac{1}{2} \left(
# \frac{x - \mu}{\sigma} \right) ^2 \right\},
# $$
# where $\mu \in \mathbb{R}$ and $\sigma^2 > 0$. Use keyword arguments to obtain the
# standardized normal distribution ($\mu = 0$ and $\sigma = 1$). Check that the inputs
# are correct.
#
# **Bonus:** verify that this function is a probability density function, i.e., its integral
# equals 1.
# 
# ---
# ### Solution:

function gauss(x::Real; μ::Real = 0, σ::Real = 1)
    σ^2 > 0 || error("the variance `σ^2` must be positive")
    return exp(-1/2 * ((x - μ)/σ)^2)/(σ * sqrt(2*π))
end

#+

gauss(0)
gauss(0.1; μ = 1, σ = 1)

#+

step = 0.01
x = -100:step:100;

sum(gauss, x) * step

g(x) = gauss(x; μ = -1, σ = 1.4);
sum(g, x) * step

#+

using Plots
x = -15:0.1:15

plot(x, gauss.(x); label = "μ = 0, σ = 1", linewidth = 2, xlabel = "x", ylabel = "f(x)");
plot!(x, gauss.(x; μ = 4, σ = 2); label = "μ = 4, σ = 2", linewidth = 2);
plot!(x, gauss.(x; μ = -3, σ = 2); label = "μ = -3, σ = 2", linewidth = 2)

# ---
# 
# ## Variable number of arguments

nargs(x...) = println("Number of arguments: ", length(x))

#+

nargs()
nargs(1, 2, "a", :b, [1,2,3])

#+

args = (1, 2, 3)

nargs(args[1], args[2], args[3])
nargs(args...)
nargs(args)

#+

nargs(1:100)
nargs(1:100...)

#+

nargs([1,2,3,4,5])
nargs([1,2,3,4,5]...)

#+

roundmod(x, y; kwargs...) = round(mod(x, y); kwargs...)

#+

roundmod(12.529, 5)
roundmod(12.529, 5; digits = 2)
roundmod(12.529, 5; sigdigits = 2)

# ### Exercise:
# Write a function `wrapper`, that accepts a number and applies one of `round`, `ceil` or
# `floor` functions based on the keyword argument `type`. Use the function to solve the
# following tasks:
# - Round `1252.1518` to the nearest larger integer and convert the resulting value
# to `Int64`.
# - Round `1252.1518` to the nearest smaller integer and convert the resulting value
# to `Int16`.
# - Round `1252.1518` to `2` digits after the decimal point.
# - Round `1252.1518` to `3` significant digits.
# 
# ---
# ### Solution:

function wrapper(x...; type = :round, kwargs...)
    if type == :ceil
        return ceil(x...; kwargs...)
    elseif type == :floor
        return floor(x...; kwargs...)
    else
        return round(x...; kwargs...)
    end
end

#+

x = 1252.1518

wrapper(Int64, x; type = :ceil)
wrapper(Int16, x; type = :floor)
wrapper(x; digits = 2)
wrapper(x; sigdigits = 3)

#+

wrapper_new(x...; type = round, kwargs...) = type(x...; kwargs...)

wrapper_new(1.123; type = ceil)
wrapper_new(1.123; type = :ceil)

#+

x = 1252.1518

wrapper_new(Int64, x; type = ceil)
wrapper_new(Int16, x; type = floor)
wrapper_new(x; digits = 2)
wrapper_new(x; sigdigits = 3)

# ---
# 
# ## Anonymous functions


h1 = function (x)
    x^2 + 2x - 1
end

#+

h2 = x ->  x^2 + 2x - 1

#+

using Plots

f(x,a) = (x + a)^2
plot(-1:0.01:1, x -> f(x,0.5))

#+

map(x -> x^2 + 2x - 1, [1,3,-1])

#+

map([1,3,-1], [2,4,-2]) do x, y
    println("x = $(x), y = $(y)")
    return x + y
end

#+

function f(x, y)
    println("x = $(x), y = $(y)")
    return x + y
end

map(f, [1,3,-1], [2,4,-2])

# ## Dot syntax for vectorizing functions

x = [0, π/2, 3π/4];
A = zeros(length(x));

for (i, xi) in enumerate(x)
    A[i] = sin(xi)
end

A

#+

A = [sin(xi) for xi in x]

#+

A = sin.(x)

#+

plus(x::Real, y::Real) = x + y

#+

plus(1,3)
plus(1.4,2.7)

#+

x = [1,2,3,4]; # column vector

plus(x, x)
plus.(x, x)

#+

broadcast(plus, x, x)

#+

y = [1 2 3 4]; # row vector

plus.(x, y)
plus.(x, 1)

# ## Function composition and piping

(sqrt ∘ +)(3, 6) # equivalent to sqrt(3 + 6)
(sqrt ∘ abs ∘ sum)([-3, -6, -7])  # equivalent to sqrt(abs(sum([-3, -6, -7])))

#+

[-3, -6, -7] |> sum |> abs |> sqrt
[-4, 9, -16] .|> abs .|> sqrt

#+

["a", "list", "of", "strings"] .|> [uppercase, reverse, titlecase, length]
