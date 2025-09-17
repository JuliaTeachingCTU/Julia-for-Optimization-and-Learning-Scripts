using Pkg

@time begin
    @info "Installing and compiling packages for all lectures ..."
    lecture_dirs = filter(x -> isdir(x) && startswith(basename(x), "lecture"), readdir(".", join=true))

    for dir in lecture_dirs
        @info "$dir"
        Pkg.activate(dir)
        
        manifest_path = joinpath(dir, "Manifest.toml")
        if isfile(manifest_path)
            rm(manifest_path)
        end

        if haskey(Pkg.project().dependencies, "ImageInspector")
            Pkg.rm("ImageInspector")
            Pkg.resolve()
            Pkg.add(url="https://github.com/JuliaTeachingCTU/ImageInspector.jl", rev="master")
        end
        
        Pkg.instantiate()
        Pkg.precompile()
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
