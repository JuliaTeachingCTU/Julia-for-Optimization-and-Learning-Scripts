@info "Installing and precompiling packages"

using Pkg
Pkg.activate(@__DIR__)
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

MNIST.traindata();  # download MNIST dataset
FashionMNIST.traindata();  # download FashionMNIST dataset
CIFAR10.traindata();  # download CIFAR10 dataset

@info "Finished"
