using Pkg

@time begin
    @info "Installing and compiling packages for all lectures ..."
    lecture_dirs = filter(x -> isdir(x) && startswith(basename(x), "lecture"), readdir(".", join=true))

    for dir in lecture_dirs
        @info "$dir"
        Pkg.activate(dir)
        Pkg.update()
    end

    @info "Downloading datasets ..."
    Pkg.activate(@__DIR__)
    Pkg.add(["RDatasets", "MLDatasets"])
    # so that downloads do not ask for confirmation
    ENV["DATADEPS_ALWAYS_ACCEPT"] = true

    using RDatasets
    dataset("datasets", "iris");  # download iris dataset
    dataset("plm", "Snmesp");  # download Snmesp dataset
    
    using MLDatasets
    MLDatasets.MNIST(Float32, :train)[:];  # download MNIST dataset
    MLDatasets.FashionMNIST(Float32, :train)[:];  # download FashionMNIST dataset
    MLDatasets.CIFAR10(Float32, :train)[:];  # download CIFAR10 dataset
    
    @info "Clearing up ..."
    Pkg.activate()
    rm(joinpath(@__DIR__, "Manifest.toml"))
    rm(joinpath(@__DIR__, "Project.toml"))

    @info "Done"
end # time
