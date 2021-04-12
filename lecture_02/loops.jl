# ------------------------------------------------------------------------------------------
# `for` and `while` loops
# ------------------------------------------------------------------------------------------

i = 1

while i <= 5
    @show i
    i += 1
end

a, b, c = 1, "hello", :world;

@show (a, b, c);

for i in 1:5
    @show i
end

for i = 1:5
    @show i
end

persons = ["Alice", "Bob", "Carla", "Daniel"];

for name in persons
    println("Hi, my name is $name.")
end

persons = Dict("Alice" => 10, "Bob" => 23, "Carla" => 14, "Daniel" => 34);

for (name, age) in persons
    println("Hi, my name is $name and I am $age old.")
end


# ==========================================================================================
# Exercise:
# Use `for` or `while` loop to print all integers between `1` and `100` which can be
# divided by both ``3`` and ``7``.
#
# Hint: use the `mod` function.
# ==========================================================================================

# ------------------------------------------------------------------------------------------
# `break` and `continue`
# ------------------------------------------------------------------------------------------

for i in 1:10
    i == 4 && break
    @show i
end

for i in 1:10
    mod(i, 2) == 0 || continue
    @show i
end


# ==========================================================================================
# Exercise:
# Rewrite the code from the exercise above. Use a combination of the `while` loop and the
# keyword `continue` to print all integers between `1` and `100` divisible by both `3` and
# `7`. In the declaration of the `while` loop use the `true` value instead of a condition.
# Use the `break` keyword and a proper condition to terminate the loop.
# ==========================================================================================

# ------------------------------------------------------------------------------------------
# Nested loops
# ------------------------------------------------------------------------------------------
for i in 1:3
    for j in i:3
        @show (i, j)
    end
end

for i in 1:3, j in i:3
    @show (i, j)
end

for i in 1:3
    for j in i:10
        j > 3 && break
        @show (i, j)
    end
end

for i in 1:3, j in i:10
    j > 3 && break
    @show (i, j)
end


# ==========================================================================================
# Exercise:
# Use nested loops to create a matrix with elements given by the formula
#
# A_{i, j} = \frac{1}{2}\exp\left\{\frac{1}{2} (x_{i}^2 - y_{j}^2) \right\}
# \quad i \in \{1, 2, 3\}, \; j \in  \{1, 2, 3, 4\},
#
# where ``x \in \{0.4, 2.3, 4.6\}`` and ``y \in \{1.4, -3.1, 2.4, 5.2\}``.
#
# Bonus: create the same matrix in a more effective way.
# ==========================================================================================

# ------------------------------------------------------------------------------------------
# List comprehension
# ------------------------------------------------------------------------------------------

X = [0.4, 2.3, 4.6];

Y = [1.4, -3.1, 2.4, 5.2];

A = [exp((x^2 - y^2)/2)/2 for x in X, y in Y]

A = Float32[exp((x^2 - y^2)/2)/2 for x in X, y in Y]

[(x, y, x + y)  for x in 1:10, y in 1:10 if x + y < 5]


# ==========================================================================================
# Exercise:
# Use the list comprehension to create a vector of all integers from `1` to `100` divisible
# by `3` and `7` simultaneously. What is the sum of all these integers?
# ==========================================================================================

# ------------------------------------------------------------------------------------------
# Generator expressions
# ------------------------------------------------------------------------------------------
gen = (1/n^2 for n in 1:1000);

sum(gen)

sum(1/n^2 for n in 1:1000)

[(i,j) for i in 1:3, j in 1:2]

gen = ((i,j) for i in 1:3, j in 1:2);

collect(gen)

gen = ((i,j) for i in 1:3 for j in 1:i);

collect(gen)

gen = ((i,j) for i in 1:3 for j in 1:i if i+j == 4);

collect(gen)


# ==========================================================================================
# Exercise:
# Use a generator to sum the square of all integers from `1` to `100`, which are divisible
# by `3` and `7` simultaneously.
# ==========================================================================================

# ------------------------------------------------------------------------------------------
# Iterators
# ------------------------------------------------------------------------------------------

A = [2.3 4.5; 6.7 7.1]

for i in 1:length(A)
    println("i = $(i) and A[i] = $(A[i])")
end

for (i, val) in enumerate(A)
    println("i = $(i) and A[i] = $(val)")
end

for col in eachcol(A)
    println("col = $(col)")
end

for (i, j, k) in zip([1, 4, 2, 5], 2:12, (:a, :b, :c))
    @show (i, j, k)
end

for (i, vals) in enumerate(zip([1, 4, 2, 5], 2:12, (:a, :b, :c)))
    @show (i, vals)
end


# ==========================================================================================
# Exercise:
# Create a matrix with elements given by the following formula
#
# A_{i, j} = \frac{1}{2}\exp\left\{\frac{1}{2} (x_{i}^2 - y_{j}^2) \right\}
# \quad i \in \{1, 2, 3\}, \; j \in  \{1, 2, 3, 4\}
#
# where ``x \in \{0.4, 2.3, 4.6\}``, ``y \in \{1.4, -3.1, 2.4, 5.2\}``. Compute the sum of
# all elements in each row and print the following message:
#
# Sum of all elements in a row `i` is `i_sum`
#
# where `i` represents row's number and `i_sum` the sum of all elements in this row. Do the
# same for each column and print the following message:
#
# Sum of all elements in a column `i` is `i_sum`
#
# Hint: use iterators `eachcol` and `eachrow`.
# ==========================================================================================
