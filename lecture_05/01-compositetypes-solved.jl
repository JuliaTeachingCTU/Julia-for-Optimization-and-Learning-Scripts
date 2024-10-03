# Abstract types

Signed <: Integer
Signed <: Number
Signed <: AbstractFloat

#+

isa(1, Int64) # equivalent to typeof(1) <: Int64
isa(1, Integer) # equivalent to typeof(1) <: Integer
isa(1, AbstractFloat) # equivalent to typeof(1) <: AbstractFloat

#+

isabstracttype(Real)
isabstracttype(Float64)

#+

isconcretetype(Real)
isconcretetype(Float64)

# ## Composite types

struct Rectangle
    bottomleft::Vector{Float64}
    width
    height
end

#+

r = Rectangle([1,2], 3, 4)
isa(r, Rectangle)

#+

methods(Rectangle)

#+

r.width
getproperty(r, :width)

#+

area(r::Rectangle) = r.width * r.height

function vertices(r::Rectangle)
    x, y = r.bottomleft
    w, h = r.width, r.height
    return [[x, y], [x + w, y], [x + w, y + h], [x, y + h]]
end

#+

area(r)
vertices(r)

#+

fieldnames(Rectangle)
fieldnames(typeof(r))

# ## Mutable composite types

r.bottomleft = [2;2]

#+

r.bottomleft[1] = 5
r.bottomleft

#+

area(r)
vertices(r)

#+

mutable struct MutableRectangle
    bottomleft::Vector{Float64}
    width
    height
end

#+

mr = MutableRectangle([1,2], 3, 4)
isa(mr, MutableRectangle)

#+

mr.width = 1.5
setproperty!(mr, :height, 2.5)
mr

#+

const AbstractRectangle = Union{Rectangle, MutableRectangle}

Rectangle <: AbstractRectangle
MutableRectangle <: AbstractRectangle

#+

perimeter(r::AbstractRectangle) = 2*(r.width + r.height)

perimeter(r)
perimeter(mr)

# ## Parametric types

abstract type AbstractPoint{T} end

struct Point{T <: Real} <: AbstractPoint{T}
    x::T
    y::T
end

#+

isconcretetype(Point{Float64})

#+

Point{Float64} <: Point <: AbstractPoint
Point{Int64} <: Point <: AbstractPoint

#+

Point{Float64} <: Point{Real}
Point{Float64} <: AbstractPoint{Float64}
Point{Float64} <: AbstractPoint{Real}

#+

coordinates(p::Point{Real}) = (p.x, p.y)

coordinates(Point(1,2))
coordinates(Point(1.0,2.0))

#+

coordinates(p::Point{<:Real}) = (p.x, p.y)

coordinates(Point(1,2))
coordinates(Point(1.0,2.0))

#+

Base.show(io::IO, p::AbstractPoint) = print(io, coordinates(p))

Point(4, 2)
Point(0.2, 1.3)

#+

Point(1, 2)
Point{Float32}(1, 2)

#+

Point(1, 2.0)


# ### Exercise:
# Define a structure that represents 3D-points. Do not forget to define it as a subtype of
# the AbstractPoint type. Then add a new method to the `coordinates` function.
# 
# ---
# ### Solution:

struct Point3D{T <: Real} <: AbstractPoint{T}
    x::T
    y::T
    z::T
end

coordinates(p::Point3D) = (p.x, p.y, p.z)

#+

Point3D(1, 2, 3)
Point3D{Float32}(1, 2, 3)

# ---
# 
# ## Constructors


Point(x::Real, y::Real) = Point(promote(x, y)...)
Point(1, 2.0)

#+

typeof(Point(1, 2.0))

#+

struct OrderedPair{T <: Real}
    x::T
    y::T

    function OrderedPair(x::Real, y::Real)
        x > y && error("the first argument must be less than or equal to the second one")
        xp, yp = promote(x, y)
        return new{typeof(xp)}(xp, yp)
    end
end

#+

OrderedPair(1,2)
OrderedPair(2,1)

# ### Exercise:
# Define a structure that represents ND-points and stores their coordinates as `Tuple`. Do
# not forget to define it as a subtype of the `AbstractPoint` type. Redefine the default
# inner constructor to create an instance of `PointND` from different types. Then add a new
# method to the `coordinates` function, and define function `dim` that returns the
# dimension of the point.
#
# **Hints:** use the `new` function in the definition of the new inner constructor.
#
# **Bonus:** Tuples with elements of the same type can be described by the special type
# `NTuple{N, T}`, where `N` is the number of elements and `T` their type.

NTuple{2, Int64} <: Tuple{Int64, Int64}

# ---
# ### Solution:

struct PointND{N, T <: Real} <: AbstractPoint{T}
    x::NTuple{N, T}

    function PointND(args::Real...)
        vals = promote(args...)
        return new{length(args), eltype(vals)}(vals)
    end
end

coordinates(p::PointND) = p.x
dim(::PointND{N}) where N = N

#+

p = PointND(1, 2)
dim(p)

#+

p = PointND(1, 2.2, 3, 4.5)
dim(p)

# ---
# 
# ## Default field values

Base.@kwdef struct MyType
    a::Int # required keyword
    b::Float64 = 2.3
    c::String = "hello"
end

methods(MyType)

#+

MyType(1, 2.3, "aaa")
MyType(; a = 3)
MyType(; a = 5, b = 4.5)

#+

(m::MyType)() = (m.a, m.b, m.c)

m = MyType(; a = 5, b = 4.5)
m()

#+

(m::MyType)(x::Real) = m.a*x + m.b
(m::MyType)(x::String) = "$(m.c), $(x)"

m(1)
m("world")

# ### Exercise:
# [Gaussian distribution](https://en.wikipedia.org/wiki/Normal_distribution) is uniquely
# represented by its mean $\mu$ and variance $\sigma^2>0$. Write a structure `Gauss`
# with the proper fields and an inner constructor that checks if the input parameters are
# correct. Initialization without arguments `Gauss()` should return the standardized normal
# distribution ($\mu = 0$ and $ \sigma = 1$).  Define a functor that computes the
# probability density function at a given point defined by
# $$
# f_{\mu, \sigma}(x) = \frac{1}{\sigma \sqrt{ 2\pi }} \exp\left\{ -\frac{1}{2} \left( \frac
# {x - \mu}{\sigma} \right) ^2 \right\},
# $$
# Verify that the probability density function is defined correctly, i.e., its integral
# equals 1.
# 
# ---
# ### Solution:

Base.@kwdef struct Gauss{T<:Real}
    μ::T = 0
    σ::T = 1

    function Gauss(μ::Real, σ::Real)
        σ^2 > 0 || error("the variance `σ^2` must be positive")
        pars = promote(μ, σ)
        return new{eltype(pars)}(pars...)
    end
end

(d::Gauss)(x::Real) = exp(-1/2 * ((x - d.μ)/d.σ)^2)/(d.σ * sqrt(2*π))

#+

gauss = Gauss()
gauss(0)

#+

step = 0.01
x = -100:step:100;

sum(Gauss(), x) * step
sum(Gauss(0.1, 2.3), x) * step

# ---
# 

using RecipesBase

@recipe function f(d::Gauss, x = (d.μ - 4d.σ):0.1:(d.μ + 4d.σ))
    seriestype  :=  :path
    label --> "Gauss(μ = $(d.μ), σ = $(d.σ))"
    xguide --> "x"
    yguide --> "f(x)"
    linewidth --> 2
    return x, d.(x)
end

#+

using Plots

plot(Gauss());
plot!(Gauss(4, 2); linewidth = 4, color = :red);
plot!(Gauss(-3, 2); label = "new label", linestyle = :dash)
