################################################################################
# StochasticProgram
# An interface for Stochastic Optimization in Julia
################################################################################

module StochOptInterface

using LightGraphs


export AbstractStochasticProgram, stochasticprogram, AbstractStochasticProgramSolver


"""
    AbstractStochasticProgram

Stochastic program instance
"""
abstract type AbstractStochasticProgram <: AbstractGraph end


"""
    stochasticprogram(args...)

Creates a stochastic program from the arguments
"""
function stochasticprogram end


"""
    write(sp::AbstractStochasticProgram, filename::String)

Write the StochasticProgram `sp` inside `filename`.
"""
function write end


include("node.jl")
include("edges.jl")
include("graph.jl")
include("valuefunction.jl")
include("solvers.jl")

end
