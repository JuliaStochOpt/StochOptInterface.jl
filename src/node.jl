# Nodes utilities
# Node stores:
# - an index in the graph, and a stage
# - an optimization model (with objective, dynamics and constraints)
# - a value function
# - a list of outgoing edges


abstract type AbstractNode end


"""
    solve!(node::AbstractNode, edge)

Solves the problem starting at `node` and stored inside `edge`, and
returns a AbstractSolution object.
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
    set!(node::AbstractNode, state::AbstractState)

Set state inside `node` and update out-going edges.

    set!(node::AbstractNode, vf::AbstractValueFunction)

Set value function inside `node`.

    set!(node::AbstractNode, cut::Cuts)

Add new cuts inside `node` and udpate in-going edges.
"""
function set! end


"""
    numberofpaths(sp::AbstractStochasticProgram, node, len::Integer)

Returns number of paths of length `len` starting at node `node` in `sp`. It should return 1 of `len` is zero.
"""
numberofpaths(sp::AbstractStochasticProgram, len) = numberofpaths(sp, getmaster(sp), len)


"""
    sample(node::AbstractNode, npaths::Int)

Sample `npaths` edges outgoing `node` and return a list.
"""
function sample end


"""
    isleaf(sp::AbstractStochasticProgram, node)

Returns whether `node` has no outgoing edge in `sp`.
"""
isleaf(sp::AbstractStochasticProgram, node) = iszero(outdegree(sp, node))
