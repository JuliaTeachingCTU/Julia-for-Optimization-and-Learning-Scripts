# ------------------------------------------------------------------------------------------
# Methods
# ------------------------------------------------------------------------------------------

product(x, y) = x * y

product(1, 4.5)

product(2.4, 3.1)

methods(product)

product(:a, :b)

product(x::Number, y::Number) = x * y

product(x, y) = throw(ArgumentError("product is defined for numbers only."))

methods(product)

product(1, 4.5)

product(:a, :b)

product("a", "b")


# ------------------------------------------------------------------------------------------
# Type hierarchy
# ------------------------------------------------------------------------------------------

using InteractiveUtils: supertype

supertype(Float64)


# ==========================================================================================
# Exercise:
# Create a function `supertypes_tree` which prints the whole tree of all supertypes. If the
# input type `T` satisfies the following condition `T === Any`, then the function should do
# nothing. Use the following function declaration:

function supertypes_tree(T::Type, level::Int = 0)
    # code
end

# The optional argument `level` sets the printing indentation level.
# Hints:
# - Use the `supertype` function in combination with recursion.
# - Use the `repeat` function and string with white space `"    "` to create a proper indentation.
# ==========================================================================================

supertypes_tree(Float64)

Float64 <: AbstractFloat <: Real <: Number

using InteractiveUtils: subtypes

subtypes(Number)


# ==========================================================================================
# Exercise:
# Create a function `subtypes_tree` which prints the whole tree of all subtypes for the
# given type. Use the following function declaration:

function subtypes_tree(T::Type, level::Int = 0)
    # code
end

# The optional argument `level` sets the printing indentation level.
# Hints:
# - Use the `subtypes` function in combination with recursion.
# - Use the `repeat` function and string with white space `"    "` to create a proper indentation.
# ==========================================================================================

subtypes_tree(Number)


# ------------------------------------------------------------------------------------------
# Multiple dispatch
# ------------------------------------------------------------------------------------------

supertypes_tree(String)

product(x::AbstractString, y::AbstractString) = x * y

product(x, y) = throw(ArgumentError("product is defined for numbers and strings only."))

product(1, 4.5)

product("a", "b")

product(:a, :b)

using InteractiveUtils: @which

@which product(1, 4.5)

@which product("a", :a)

@which product("a", "b")

g(x::Real) = x + 1

g(x::String) = repeat(x, 4)

g(1.2)

g("a")

g(:a)

product_new(x, y) = x * y

product(1, 4.5)

product_new(1, 4.5)

product("a", "b")

product_new("a", "b")

product("a", :a)

product_new("a", :a)


# ==========================================================================================
# Exercise:
# We define the abstract type `Student` and specific types `Master` and `Doctoral`. The
# latter two are defined as structures containing one and three fields, respectively.

abstract type Student end

struct Master <: Student
    salary
end

struct Doctoral <: Student
    salary
    exam_mid::Bool
    exam_english::Bool
end

# We can check that the `subtypes_tree` works correctly on any type, including the type
# `Student` which we defined.

subtypes_tree(Student)

# We create instances of two students by providing values for the struct fields.

s1 = Master(5000)
s2 = Doctoral(30000, 1, 0)

# Write the `salary_yearly` function which computes the yearly salary for both student
# types. The monthly salary is computed from the base salary (which can be accessed via `s1.
# salary`). Monthly bonus for doctoral students is 2000 for the mid exam and 1000 for the
# English exam.
# ==========================================================================================

# ------------------------------------------------------------------------------------------
# Method ambiguities
# ------------------------------------------------------------------------------------------

f(x::Float64, y) = x * y

f(x, y::Float64) = x + y

f(2.0, 3)

f(2, 3.0)

f(2.0, 3.0)

f(x::Float64, y::Float64) = x - y

f(2.0, 3.0)