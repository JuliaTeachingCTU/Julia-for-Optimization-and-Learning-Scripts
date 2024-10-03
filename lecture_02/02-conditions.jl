using Pkg
Pkg.activate(pwd() * "/lecture_02")

# # Conditional evalutions
# ## `if-elseif-else` statement

function compare(x, y)
    if x < y
        println("x is less than y")
    elseif x > y
        println("x is greater than y")
    else
        println("x is equal to y")
    end
    return
end

#+

compare(1, 2.3)
compare(4.7, 2.3)
compare(2.3, 2.3)

#+

x, y = 2, 1;

if x < y
    println("x is less than y")
elseif x > y
    println("x is greater than y")
end

#+

if x < y
    println("x is less than y")
end

#+

if 1
    println("Hello")
end

#+

x, y = 2, 1;

if x < y
    z = y
else
    z = x
end

z

#+

function compare(x, y)
    if x < y
        z = y
    elseif x > y
        z = x
    end
    return z
end

#+

compare(1, 2.3)
compare(4.7, 2.3)
compare(2.3, 2.3)

#+

function compare(x, y)
    z = if x < y
        y
    else
        x
    end
    return z
end

#+

compare(1, 2.3)
compare(4.7, 2.3)
compare(2.3, 2.3)

# ### Exercise:
# Write the `fact(n)` function that computes the factorial of `n`. Use the following
# function declaration:

function fact(n)
    # some code
end

# Make sure that the input argument is a non-negative integer. For negative input arguments
# and for arguments that can not be represented as an integer, the function should throw an
# error.
#
# **Hint:** use recursion, the `isinteger` function and the `error` function.
# The or operator
# is written by `|`.
# 
# ---
# ### Solution:



# ---
# 
# ## Ternary operator

x, y = 2, 1;
println(x < y ? "x is less than y" : "x is greater than or equal to y")


# ## Short-circuit evaluation

t(x) = (println(x); true)
f(x) = (println(x); false)

t(1) && println(2) # both expressions are evaluated
f(1) && println(2) # only the first expression is evaluated
t(1) || println(2) # only the first expression is evaluated
f(1) || println(2) # both expressions are evaluated

#+

f(1) & t(2)
f(1) && t(2)

#+

t(1) && t(2) || println(3) # the first two expressions are evaluated
f(1) && t(2) || println(3) # the first and the last expressions are evaluated
f(1) && f(2) || println(3) # the first and the last expressions are evaluated
t(1) && f(2) || println(3) # all expressions are evaluated

#+

t(1) || t(2) && println(3) # the first expression is evaluated
f(1) || t(2) && println(3) # all expressions are evaluated
f(1) || f(2) && println(3) # the first two expressions are evaluated
t(1) || f(2) && println(3) # the first expression is evaluated

# ### Exercise:
# Rewrite the factorial function from the exercises above. Use the short-circuit evaluation
# to check if the given number is a non-negative integer and the ternary operator for
# recursion.
#
# ---
# ### Solution:
