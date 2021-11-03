using Pkg
Pkg.activate(@__DIR__)
Pkg.instantiate()


ENV["DATADEPS_ALWAYS_ACCEPT"] = true

using BSON
using BenchmarkTools
using CSV
using DataFrames
using DifferentialEquations
using Distributions
using Flux
using GLM
using GLPK
using GR
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

dataset("datasets", "iris"); # download iris dataset
dataset("plm", "Snmesp"); # download Snmesp dataset
MNIST.traindata();  # download MNIST dataset
