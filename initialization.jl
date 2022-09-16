@info "Installing and precompiling packages"

@time begin
    using Pkg
    Pkg.activate(@__DIR__)

    # removes ImageInspector if installed
    if haskey(Pkg.project().dependencies, "ImageInspector")
        Pkg.rm("ImageInspector")
        Pkg.resolve()
    end

    Pkg.instantiate()
    Pkg.precompile()
    Pkg.add(url="https://github.com/JuliaTeachingCTU/ImageInspector.jl", rev="master")

    using BSON
    using BenchmarkTools
    using CSV
    using DataFrames
    using DifferentialEquations
    using Distributions
    using Flux
    using GLM
    using GLPK
    using HypothesisTests
    using Ipopt
    using JuMP
    using LinearAlgebra
    using MLDatasets
    using PkgTemplates
    using Plots
    using ProgressMeter
    using Query
    using RDatasets
    using Random
    using SpecialFunctions
    using Statistics
    using StatsPlots

    @info "Downloading datasets"

    ENV["DATADEPS_ALWAYS_ACCEPT"] = true

    dataset("datasets", "iris"); # download iris dataset
    dataset("plm", "Snmesp"); # download Snmesp dataset

    MLDatasets.MNIST(Float32, :train)[:];  # download MNIST dataset
    MLDatasets.FashionMNIST(Float32, :train)[:];  # download FashionMNIST dataset
    MLDatasets.CIFAR10(Float32, :train)[:];  # download CIFAR10 dataset

    @info "Finished"
end
