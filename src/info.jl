using TimerOutputs
function ncalls(to::TimerOutput, key::String)
    return haskey(to.inner_timers, key) ? TimerOutputs.ncalls(to[key]) : 0
end
const FCUTS_KEY = "fcuts"
nfcuts(to) = ncalls(to, FCUTS_KEY)
const OCUTS_KEY = "ocuts"
nocuts(to) = ncalls(to, OCUTS_KEY)
iteration_key(it) = "iteration $it"

# Path represents a scenario along with a vector of AbstractSolution that
# corresponds to solutions for each node visited by the scenario
struct Path{T<:AbstractTransition, SolT<:AbstractSolution}
    scenario::Vector{T}
    sol_scenario::Vector{SolT}
end

abstract type AbstractPaths end

struct Paths <: AbstractPaths
    paths::Vector{Path}
end

mutable struct Result
    # n forwards passes of last computation of upper-bound in the
    # form of path vector:
    paths::AbstractPaths
    # current status
    status::Symbol
    # current lower bound
    lowerbound::Float64
    # current Monte-Carlo upperbound
    upperbound::Float64
    # upper-bound std:
    σ_UB::Float64
end
Result() = Result(Paths(Path[]), :Unbounded, 0.0, Inf, 0.0)
npaths(result::Result) = length(result.paths)
function Base.show(io::IO, result::Result)
    println(io, "Exact Lower Bound: $(result.lowerbound)")
    println(io, "Monte-Carlo Upper Bound: $(result.upperbound)")
end

struct Info
    results::Vector{Result}
    timer::TimerOutput
end
Info() = Info(Result[], TimerOutput())
niterations(info::Info) = length(info.results)
result(info::Info, it::Int) = info.results[it]
last_result(info::Info) = result(info, niterations(info))
timer(info::Info, it::Int) = info.timer[iteration_key(it)]
last_timer(info::Info) = timer(info, niterations(info))
# Time is in ns
total_time_ns(info::Info) = (time_ns() - info.timer.start_data.time)
total_time(info::Info) = total_time_ns(info) / 1e9
function Base.show(io::IO, info::Info)
    println(last_result(info))
    println(info.timer)
end

function print_iteration_summary(info::Info)
    println("Iteration $(niterations(info))")
    println(last_timer(info))
    println(last_result(info))
end

function print_termination_summary(info::Info)
    println(TimerOutputs.flatten(info.timer))
    println(last_result(info))
end
