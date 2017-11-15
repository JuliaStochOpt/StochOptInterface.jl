# Graph utilities

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
    setchildx!(sp::AbstractStochasticProgram, node, child, sol)

Sets the parent solution of `child` as `sol`, the solution obtained at `node`.
"""
function setchildx! end


"""
    setprobability!(sp::AbstractStochasticProgram, edge, probability)

Sets the probability to take the edge `edge` in the stochastic problem `sp` to `probability`.
"""
function setprobability! end
