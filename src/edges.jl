# Edges utilities
# Edge stores
# - an id corresponding to index in graph
# - a noise, or a collection of noise (for stagewise noise)
# - an optimization problem (implemented with JuMP or MOI)

abstract type AbstractEdge end

"""
    sync!(edge::AbstractEdge)

Synchronize state in `edge` with parent node.
"""
function sync! end


"""
    set!(edge::AbstractEdge, x)

Set current state in `edge` problem.

    set!(edge::AbstractEdge, noise)

Set current noise in `edge` problem.
"""
function set! end


"""
    rand(edge::AbstractEdge)

Draw a random realization of edge's noise (in the case that `edge` stores a
collection of noises).
"""
function rand end


"""
    build!(edge::AbstractEdge)

Build optimization model in `edge` with model stored in AbstractNode parent.
"""
function build! end


"""
    reload!(edge:AbstractEdge)

Reload optimization model in `edge`
"""
function reload! end


"""
    size(edges)

Return number of noises in `edges`.
"""
function size end
