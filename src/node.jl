# Nodes utilities


abstract type AbstractNode end


"""
    solve!(sp::AbstractStochasticProgram, node)

Solves the program at node `node` in `sp` and returns the solution.
"""
function solve! end


"""
    getobjectivebound(sp::AbstractStochasticProgram, node)

Gets the current bound to the objective of `node`.
"""
function getobjectivebound end


"""
    setvaluefunctionbound!(sp::AbstractStochasticProgram, node, child, θlb)

Sets the bounds to the objective of the child `child` of `node` to `θlb`.
"""
function setvaluefunctionbound! end


"""
    statedim(sp::AbstractStochasticProgram, node)

Returns the dimension of the state at `node`.
"""
function statedim end


"""
    set(node::AbstractNode, state::AbstractState)

Set state inside `node`.
"""
function set end


"""
    numberofpaths(sp::AbstractStochasticProgram, node, len::Integer)

Returns number of paths of length `len` starting at node `node` in `sp`. It should return 1 of `len` is zero.
"""
numberofpaths(sp::AbstractStochasticProgram, len) = numberofpaths(sp, getmaster(sp), len)


"""
    sample(node::AbstractNode, npaths)

Sample `npaths` path starting from `node`.
"""
function sample end


"""
    isleaf(sp::AbstractStochasticProgram, node)

Returns whether `node` has no outgoing edge in `sp`.
"""
isleaf(sp::AbstractStochasticProgram, node) = iszero(outdegree(sp, node))
