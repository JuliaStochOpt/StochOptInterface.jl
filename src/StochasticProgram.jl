################################################################################
# StochasticProgram
# An interface for Stochastic Optimization in Julia
################################################################################

module StochasticProgram

using LightGraphs


export AbstractStochasticProgram, stochasticprogram


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


include("graph.jl")
include("node.jl")
include("solvers.jl")

end
