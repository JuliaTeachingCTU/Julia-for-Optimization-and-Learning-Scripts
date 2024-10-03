using Pkg
Pkg.activate(pwd() * "/lecture_03")

# # DataFrames.jl

using DataFrames

df = DataFrame(A = 1:4, B = ["M", "F", "F", "M"], C = rand(4))

#+

df.A

#+

df[!, :A]

#+

df.A[1] = 5
df

#+

col = df[:, :A]
col[1] = 4
df

#+

using CSV

CSV.write(joinpath(pwd(), "lecture_03", "dataframe.csv"), df)
table = CSV.read(joinpath(pwd(), "lecture_03", "dataframe.csv"), DataFrame; header = true)

#+

df.D = [:a, :b, :c, :d]
df

#+

insertcols!(df, 3, :B => rand(4), :B => 11:14; makeunique = true)
push!(df, [10, "F", 0.1, 15, 0.235, :f])
push!(df, (10, "F", 0.1, 15, 0.235, :f))
push!(df, Dict(:B_1 => 0.1, :B_2 => 15, :A => 10, :D => :f, :B => "F", :C => 0.235))
df

#+

df_empty = DataFrame()
df_empty.A = 1:3
df_empty.B = [:a, :b, :c]
df_empty

#+

df_empty = DataFrame(A = Int[], B = Symbol[])
push!(df_empty, [1, :a])
push!(df_empty, (2, :b))
push!(df_empty, Dict(:A => 3, :B => :c))
df_empty

# ## Renaming

names(df)

#+

propertynames(df)

#+

rename!(df, [:a, :b, :c, :d, :e, :f])
df

#+
rename!(df, :a => :A, :f => :F)
df

#+

myname(x) = string("column_", uppercase(x))
rename!(myname, df)
df

# ## Working with `DataFrame`s

using RDatasets, DataFrames

iris = dataset("datasets", "iris")
first(iris, 6)

#+

describe(iris)

#+

iris[2:4, [:SepalLength, :Species]]

#+

iris[2:4, Not([:SepalLength, :Species])]

#+

using Query

table = @from row in iris begin
    @where row.SepalLength >= 6 && row.SepalWidth >= 3.4
    @select {
        row.Species,
        SepalSum = row.SepalLength + row.SepalWidth,
        PetalSum = row.PetalLength + row.PetalWidth,
    }
    @collect DataFrame
end

# ## Visualizing using StatsPlots

using StatsPlots

@df iris scatter(
    :SepalLength,
    :SepalWidth;
    group = :Species,
    xlabel = "SepalLength",
    ylabel = "SepalWidth",
    marker = ([:d :h :star7], 8),
)

#+

@df iris marginalkde(
    :SepalLength,
    :SepalWidth;
    xlabel = "SepalLength",
    ylabel = "SepalWidth",
)

@df iris corrplot(
    cols(1:4);
    grid = false,
    nbins = 15,
    fillcolor = :viridis,
    markercolor = :viridis,
)
