using Pkg
Pkg.activate(pwd() * "lecture_01")

# # Arrays
# ## Vectors

v = [1, 2, 3, 4, 5, 6, 7, 8] # or equivalently v = [1; 2; 3; 4; ...]

#+

typeof(v)
ndims(v)
eltype(v)
size(v)
length(v)

#+

v[3]
v[begin] # the first element
v[end] # the last element
v[[2, 3]]

#+

range(1; stop = 10, step = 2) # or equivalently range(1, 10; step = 2)
1:2:10

#+

v[1:3] # the first three elements
v[1:2:end] # select all elements with odd index
v[:] # all elements

#+

v = [1,2,3]

append!(v, 4)
append!(v, [5,6])
append!(v, 7:8)
append!(v, 3.0)
append!(v, 3.1415)

#+

isinteger(3.0)

#+

v = Float64[1, 2, 3]
append!(v, 3.1415)

#+

v = [1, 2, 3, 4]
v[2] = 4
v

#+

v[3:4] .= 11
v

# ### Exercise:
# Create a vector of positive integers that contains all odd numbers smaller than `10`.
# Then change the first element to `4` and the last two elements to `1`.
# 
# ---
# ### Solution:

v = [1,3,5,7,9]

collect(1:2:9)
Vector(1:2:9)

v[1] = 4
v[end-1:end] .= 1
v

# ---
# 
# ## Matrices

m = [1  2  3  4; 5  6  7  8]

typeof(m)
eltype(m)
ndims(m)
size(m)
length(m)

#+

m[1] # the first element, equivalent to m[begin]
m[2] # the second element
m[end-1] # the last element
m[1, 2]
m[1, [2, 3]] # the second and third element in the first row
m[1:3] # the first three elements according to linear indexing
m[:, 1:3] # the first three columns
m[1, :] # the first row
m[:] # all elements

#+

hcat(m, m)
vcat(m, m)

#+

cat(m, m; dims = 2) # equivalent to hcat(m, m)
cat(m, m; dims = 1) # equivalent to vcat(m, m)

#+

v = [11, 12]
vcat(m, v)

# ### Exercise:
# Create two vectors: vector of all odd positive integers smaller than `10` and vector of
# all even positive integers smaller than `10`. Then concatenate these two vectors
# horizontally and fill the third row with `4`.
# 
# ---
# ### Solution:

v1 = collect(1:2:9)
v2 = collect(2:2:10)

M = hcat(v1, v2)
M[3,:] .= 4
M

# ---
# 
# ## `N`-dimensional arrays


A = zeros(3, 5, 2) # equivalent to A = zeros((3, 5, 2))
B = zeros(Int64, 3, 5, 2)  # equivalent to B = zeros(Int64, (3, 5, 2))

typeof(A)
eltype(A)
ndims(A)
size(A)
length(A)

#+

B[1] = 1 # assign 1 to the first element
B[1, 2, 2] = 2 # assign 2 to the element at position (1,2,2)
B[2,:,1] .= 4

B

#+

ones(Float32, 2, 3, 1)
fill(1.234, 2, 2)

# ### Exercise:
# Create three matrices with the following properties:
# - Matrix `A` is of size `2x3`, and all its elements equal 0.
# - Matrix `B` is of size `2x3x1`, and all its elements equal 1.
# - Matrix `C` is of size `2x3`, and all its elements equal 2.
# Concatenate these three matrices along the third dimension.
#
# **Hint:** use the `cat` function and the keyword `dims`.
# 
# ---
# ### Solution:

A = zeros(2, 3)
B = ones(2, 3, 1)
C = fill(2, 2, 3)

cat(A, B, C; dims = 3)

# ---
# 
# ## Broadcasting

a = [1,2,3] # column vector

a .-= 4 # from each element of vector subtracts 4
a -= 1

#+

abs.(a)
sum(exp.(sqrt.(abs.(a .- 1)))./2)

#+

a = [1,2,3] # column vector
b = [4,5,6] # column vector

a * b
a' * b
a * b'
a .* b


# ### Exercise:
# Construct a matrix whose elements are given by the following formula
# $$
# A_{i, j} = \frac{1}{2}\exp\{(B_{i, j} + 1)^2\}, \quad i \in \{1, 2\}, \; j \in
# \{1, 2, 3\}
# $$
# where the matrix $B$ is defined by

B = [
    -1  0  2;
    2  -3  1;
]

# 
# ---
# ### Solution:

A = exp.((B .+ 1) .^ 2) ./ 2

A = @. exp((B + 1) ^ 2) / 2

A = zeros(2, 3);
for i in 1:length(A)
    A[i] = exp((B[i] + 1)^2)/2
end
A

# ---
# 
# ## Views

A = [1 2 3; 4 5 6]
B = A

B[2] = 42

A == B

#+

C = copy(A)
C[4] = 10

A == C

#+

D = A[1:2, 1:2]
D[1] = 15

D == A[1:2, 1:2]

#+

E = view(A, 1:2, 1:2)
E = @view A[1:2, 1:2]

E[4] = 78

E == A[1:2, 1:2]

#+

typeof(E)

#+

A = [1 2 3; 4 5 6]
A_view = @view A[:, :]

sum(A)
sum(A_view)
minimum(A; dims = 1)
minimum(A_view; dims = 1)

#+

A = [1 2 3; 4 5 6];

sum(exp.(sqrt.(abs.(@view(A[1, :]) .- @view(A[2, :]))))./2)
@views sum(exp.(sqrt.(abs.(A[1, :] .- A[2, :])))./2)
