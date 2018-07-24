abstract type AbstractAlgorithm end

# Solution of the full optimization, not an AbstractSolution
struct SolutionSummary
    status
    objval
    sol
    attrs
end

# Path represents a scenario along with a vector of AbstractSolution that corresponds to solutions for each node visited by the scenario
struct Path{<:AbstractTransition, <: AbstractSolution}
    scenario::Vector{<:AbstractTransition}
    sol_scenario::Vector{<:AbstractSolution}
end

"""
    optimize!(sp::AbstractStochasticProgram, algo::AbstractAlgorithm, stopcrit::AbstractStoppingCriterion, verbose=0)

Run the algorithm `algo` on the stochastic program `sp` until the termination criterion `stopcrit` requires stopping with verbose level `verbose`.
"""
function optimize!(sp::AbstractStochasticProgram, algo::AbstractAlgorithm, stopcrit::AbstractStoppingCriterion=IterLimit(), verbose=0)
    # Default implementation, define a specific method for algorithms for which
    # this default is not appropriate
    paths = nothing
    totalstats = Stats()
    stats = Stats()
    stats.niterations = 1
    totalto = TimerOutput()
    to = totalto

    while (paths === nothing || getstatus(paths[1]) != :Infeasible) && !stop(stopcrit, to, stats, totalstats)
        @timeit totalto "iteration $(totalstats.niterations+1)" paths, stats = iterate!(sp, algo, totalto, verbose)
        to = totalto["iteration $(totalstats.niterations+1)"]
        fto = TimerOutputs.flatten(totalto)
        totalstats += stats
        if verbose >= 2
            println("Stats for this iteration:")
            println(to)
            println("Status: $(getstatus(mastersol))")
            println("Solution value: $(getstatevalue(mastersol))")
            println(stats)
            println("Total stats:")
            println(fto)
            println(totalstats)
        end
    end

    fto = TimerOutputs.flatten(totalto)

    if verbose >= 1
        println(fto)
        println("Status: $(getstatus(mastersol))")
        println("Objective value: $(getobjectivevalue(mastersol))")
        println(totalstats)
    end

    attrs = Dict()
    attrs[:stats] = totalstats
    attrs[:niter] = totalstats.niterations
    attrs[:nfcuts] = nfcuts(fto)
    attrs[:nocuts] = nocuts(fto)
    SolutionSummary(getstatus(mastersol), getobjectivevalue(mastersol), getstatevalue(mastersol), attrs)
end

"""
    iterate!(sp::AbstractStochasticProgram, algo::AbstractAlgorithm, to::TimerOutput, verbose)

Run one iteration of the algorithm `algo` on the stochastic program `sp` with verbose level `verbose`.
Return the solution of the master state and the stats.
"""
function iterate!(sp::AbstractStochasticProgram, algo::AbstractAlgorithm, to::TimerOutput, verbose)
    # Default implementation, define a specific method for algorithms for which
    # this default is not appropriate
    paths, forward_stats = forward_pass(sp, algo, to, verbose)
    backward_pass!(sp, algo, paths, to, verbose)

    process!(sp, algo, paths, to, verbose)

    # Uses forward_stats in the RHS so that its values are used for upperbound, lowerbound, σ_UB and npaths
    paths, stats
end

"""
    forward_pass(sp::AbstractStochasticProgram, algo::AbstractAlgorithm, to::TimerOutput, verbose)

Run the forward pass of algorithm `algo` on the stochastic program `sp` with verbose level `verbose`.
Returns the forward paths and the stats.
"""
function forward_pass(sp::AbstractStochasticProgram, algo::AbstractAlgorithm, to::TimerOutput, verbose)
    # Default implementation, define a specific method for algorithms for which
    # this default is not appropriate
    forward_stats = SDDPStats()
    scenarios = sample_scenarios(sp,algo,to,verbose)

    paths = Vector{Path}(length(scenarios)) #Consider that sample_scenarios always return at least one scenario

    i = 1
    for s in scenarios
        path = simulate_scenario(sp,s,to,verbose)
        paths[i] = path
        i += 1
    end

    # Stats update
    z_UB, σ = compute_bounds(algo,paths)
    forward_stats.npaths = length(paths)
    forward_stats.lowerbound = getobjectivevalue(paths[1])
    forward_stats.upperbound = z_UB
    forward_stats.σ_UB = σ

    paths, forward_stats
end

"""
    backward_pass!(sp::AbstractStochasticProgram, algo::AbstractAlgorithm, paths::Vector{Path}, to::TimerOutput, verbose)

Run the backward pass of algorithm `algo` on the stochastic program `sp` for the paths `paths` with verbose level `verbose`.
"""
function backward_pass! end

"""
    simulate_scenario(sp::AbstractStochasticProgram, scenario::Vector{<:AbstractTransition}, to::TimerOutput, verbose)

Simulate a scenario `scenario` on the stochastic program `sp` with verbose level `verbose`.
"""
function simulate_scenario end

"""
    sample_scenarios(sp::AbstractStochasticProgram, algo::AbstractAlgorithm, to::TimerOutput, verbose)

Return a vector of scenarios where each scenario is a vector of AbstractTransition from the stochastic program `sp`
sampled according to algorithm `algo` with verbose level `verbose`.
"""
function sample_scenarios end

"""
    compute_bounds(algo::AbstractAlgorithm, paths::Vector{Path}, verbose)

Return a tuple `(z_UB, σ)` where z_UB reprensets the upperbound computed by the algorithm `algo` by using paths `paths`
generated during the forward pass and σ represents the standard deviation of this upper bound.
"""
function compute_bounds end

"""
    process(sp::AbstractStochasticProgram, algo::AbstractAlgorithm, paths::Vector{Path}, to::TimerOutput)

Function called at the end of function iterate! to update necessary elements related with the implementation of the
algorithm `algo` on the stochastic program `sp` considering forward paths `paths`.
"""
function process!(sp::AbstractStochasticProgram, algo::AbstractAlgorithm, paths::Vector{Path}, to::TimerOutput, verbose)
end
