using Pkg
Pkg.activate(pwd() * "/lecture_01")

# # Tuples

t = (1, 2.0, "3")
t = 1, 2.0, "3"

#+

typeof(t)

#+

t[1] # the first element
t[end] # the last element
t[1:2] # the first two elements

#+

a, b, c = t
println("The values stored in the tuple are: $a, $b and $c")

# ### Exercise:
# Create a tuple that contains the first four letters of the alphabet (these letters should
# be of type `String`). Then unpack this tuple into four variables `a`, `b`, `c` and `d`.
# 
# ---
# ### Solution:



# ---
# 
# # Named Tuples

t = (a = 1, b = 2.0, c = "3")

#+

a = 1;
b = 2.0;
c = "3";

t = (; a, b, c)

#+

t[1] # the first element
t[end] # the last element
t[1:2] # error

#+

t.a
t.c
a, b, c = t

println("The values stored in the tuple are: a = $a, b = $b")