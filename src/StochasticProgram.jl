

module StochasticProgram

using LightGraphs


export AbstractStochasticProgram, stochasticprogram


"""
    AbstractStochasticProgram

Stochastic program instance
"""
abstract type AbstractStochasticProgram <: AbstractGraph{Int} end


"""
    stochasticprogram(args...)

Creates a stochastic program from the arguments
"""
function StochasticProgram end


include("src/graph.jl")
include("src/node.jl")

end
