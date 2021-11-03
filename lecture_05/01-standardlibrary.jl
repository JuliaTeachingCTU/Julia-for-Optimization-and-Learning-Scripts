# # Useful packages
# ## Statistics

using Statistics

x = rand(10);

mean(x)
var(x)
std(x)

# ## LinearAlgebra

using LinearAlgebra

A = [-4.0 -17.0; 2.0 2.0]

det(A)
inv(A)
norm(A)
eigvals(A)
eigvecs(A)

#+

D = Diagonal([1,2,3])

#+

D + I
D - I

# ## Random

using Random
using Random: seed!

seed!(1234);
rand(2)

#+

seed!(1234);
rand(2)

#+

randperm(4)

#+

v = [1,2,3,4]
shuffle(v)
