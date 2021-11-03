# # Constrained Optimization
# ## Numerical method

using Plots, Random

function create_anim(
    f,
    path,
    xlims,
    ylims,
    file_name = joinpath(pwd(), randstring(12) * ".gif");
    xbounds = xlims,
    ybounds = ylims,
    fps = 15,
)
    xs = range(xlims...; length = 100)
    ys = range(ylims...; length = 100)
    plt = contourf(xs, ys, f; color = :jet)

    # add constraints if provided
    if !(xbounds == xlims && ybounds == ylims)
        x_rect = [xbounds[1]; xbounds[2]; xbounds[2]; xbounds[1]; xbounds[1]]
        y_rect = [ybounds[1]; ybounds[1]; ybounds[2]; ybounds[2]; ybounds[1]]

        plot!(x_rect, y_rect; line = (2, :dash, :red), label="")
    end

    # add an empty plot
    plot!(Float64[], Float64[]; line = (4, :arrow, :black), label = "")

    # extract the last plot series
    plt_path = plt.series_list[end]

    # create the animation and save it
    anim = Animation()
    for x in eachcol(path)
        push!(plt_path, x[1], x[2]) # add a new point
        frame(anim)
    end
    gif(anim, file_name; fps = fps, show_msg = false)
    return nothing
end

f(x) = sin(x[1] + x[2]) + cos(x[1])^2
f(x1,x2) = f([x1;x2])
g(x) = [cos(x[1] + x[2]) - 2*cos(x[1])*sin(x[1]); cos(x[1] + x[2])]

#+

function optim(f, g, P, x, α; max_iter=100)
    xs = zeros(length(x), max_iter+1)
    ys = zeros(length(x), max_iter)
    xs[:,1] = x
    for i in 1:max_iter
        ys[:,i] = xs[:,i] - α*g(xs[:,i])
        xs[:,i+1] = P(ys[:,i])
    end
    return xs, ys
end

#+

P(x, x_min, x_max) = min.(max.(x, x_min), x_max)

x_min = [-1; -1]
x_max = [0; 0]

xs, ys = optim(f, g, x -> P(x,x_min,x_max), [0;-1], 0.1)

xlims = (-3, 1)
ylims = (-2, 1)

#+

create_anim(f, xs, xlims, ylims, joinpath(pwd(), "lecture_08", "anim6.gif");
    xbounds=(x_min[1], x_max[1]),
    ybounds=(x_min[2], x_max[2]),
)

#+

xys = hcat(reshape([xs[:,1:end-1]; ys][:], 2, :), xs[:,end])

create_anim(f, xys, xlims, ylims, joinpath(pwd(), "lecture_08", "anim7.gif");
    xbounds=(x_min[1], x_max[1]),
    ybounds=(x_min[2], x_max[2]),
)