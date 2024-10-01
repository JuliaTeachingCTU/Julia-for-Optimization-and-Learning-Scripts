using Pkg
Pkg.activate(pwd() * "lecture_01")

# # Dictionaries

d = Dict("a" => [1, 2, 3], "b" => 1)
d = Dict(:a => [1, 2, 3], :b => 1)

#+

d[:a]
d[:c]

#+

haskey(d, :c)
get(d, :c, 42)
get!(d, :c, 42)
get!(d, :d, ["hello", "world"])

d

#+

delete!(d, :d)
haskey(d, :d)

#+

pop!(d, :c)
haskey(d, :c)

#+

haskey(d, :c)
pop!(d, :c, 444)
