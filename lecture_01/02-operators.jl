using Pkg
Pkg.activate(pwd() * "lecture_01")

# # Arithmetic operators

1 + 2
2*3
4/3

#+

x = 1;
y = 3;

(x + 2)/(y - 1) - 4*(x - 2)^2

#+

2(3 + 4) # equivalent to 2*(3 + 4)

# ### Exercise:
# Determine the value and type of $y$ given by the following expression
# $$
# y = \frac{(x + 2)^2 - 4}{(x - 2)^{p - 2}},
# $$
# where $x = 4$ and $p = 5$.
# 
# ---
# ### Solution:



# ---
# 
# ## Promotion system

x = 1.0 # Float64
y = 2 # Int64

xp, yp = promote(x, y)

typeof(xp)
typeof(yp)

#+

promote(1, 2f0, true, 4.5, Int32(1))
promote_type(Float64, Int64, Bool, Int32)

#+

x = 1 # Int64
y = 2f0 # Float32
z = x + y

typeof(z)

# ### Exercise:
# All of these values represent number ``1``. Determine the smallest type which can
# represent them.

x = 1
y = 1f0
z = true
w = Int32(1)

# ---
# ### Solution:



# ---
# 
# ## Updating operators

x = 1
x += 3 # x = x + 3
x *= 4 # x = x * 4
x /= 2 # x = x / 2
x \= 16 # x = x \ 16 = 16 / x

# ### Exercise:
# Compute the value of $y$ given by the following expression
# $$
# y = \frac{(x + 4)^{\frac{3}{2}}}{(x + 1)^{p - 1}},
# $$
# where $x = 5$ and $p = 3$. Then multiply the result by $8$, add $3$, divide by $3$, and
# subtract $1$. What are all the intermediate results and the final result?
# 
# ---
# ### Solution:



# ---
# 
# ## Numeric comparison

1 == 1
1 == 1.0

#+

-1 <= 1
-1 ≥ 1

#+

3 > 2 > 1
3 > 2 & 2 > 1

#+

1 < 2 <= 2 < 3 == 3 > 2 >= 1 == 1 < 3 != 5

#+

NaN == NaN
NaN != NaN
NaN < NaN

#+

isequal(NaN, NaN)
!isequal(NaN, NaN)

#+

!true
!false

# ## Rounding functions

x = 3141.5926

round(x)
floor(x)
ceil(x)

#+

round(Int64, x)
floor(Int32, x)
ceil(Int16, x)

#+

round(x; digits = 3)
round(x; sigdigits = 3)

# ### Exercise:
# Use rounding functions to solve the following tasks:
# - Round `1252.1518` to the nearest larger integer and convert the resulting value to
#   `Int64`.
# - Round `1252.1518` to the nearest smaller integer and convert the resulting value to
#   `Int16`.
# - Round `1252.1518` to `2` digits after the decimal point.
# - Round `1252.1518` to `3` significant digits.
# 
# ---
# ### Solution:



# ---
# 
# ## Numerical Conversions

convert(Float32, 1.234)
Float32(1.234)

#+

convert(Int64, 1.0)
Int64(1.0)

#+

convert(Int64, 1.234)
Int64(1.234)

# ### Exercise:
# Use the proper numeric conversion to get the correct result (not approximate) of summing
# the following two numbers
# 
# ```julia
# x = 1//3
# y = 0.5
# ```
# 
# **Hint:** rational numbers can be summed without approximation.
# 
# ---
# ### Solution:
