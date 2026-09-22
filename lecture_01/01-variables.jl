using Pkg
Pkg.activate(pwd() * "/lecture_01")
Pkg.instantiate()

# # Variables

x = 2
typeof(x)

y = x + 1
typeof(y)

x = 4
x = 3.1415

Float64

# ### Exercise:
# Create the following three variables:
# 1. Variable `x` with value `1.234`.
# 2. Variable `y` with value `1//2`.
# 3. Variable `z` with value `x + y*im`.
# What are the types of these three variables?
# 
# ---
# ### Solution:



# ---
# 
# ## Variable Names

I_am_float = 3.1415
CALL_ME_RATIONAL = 1//3
MyString = "MyVariable"

#+

α = 1
δ = 1
🍕 = "It's time for pizza!!!"

#+

π = 2
π

#+

ℯ
ℯ = 2

#+

struct = 3
