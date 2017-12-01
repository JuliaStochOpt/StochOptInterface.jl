# Graph and edges utilities

"""
    getmaster(sp::AbstractStochasticProgram)

Returns the master node of stochastic problem `sp`.
"""
function getmaster end


"""
    probability(sp::AbstractStochasticProgram, edge)

Returns the probability to take the edge `edge` in the stochastic problem `sp`.
"""
function probability end


"""
    setchildstate!(sp::AbstractStochasticProgram, node::AbstractNode, child::AbstractNode, sol::AbstractSolution)

Sets the parent solution of `child` as `sol`, the solution obtained at `node`.
"""
function setchildstate! end


"""
    setprobability!(sp::AbstractStochasticProgram, edge, probability)

Sets the probability to take the edge `edge` in the stochastic problem `sp` to `probability`.
"""
function setprobability! end


"""
    edges(sp::AbstractStochasticProgram, node::AbstractNode)

Returns iterable of outgoing edges in `node`.
"""
function edges end
