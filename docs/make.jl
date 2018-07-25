using Documenter, StochOptInterface

makedocs(
    format = :html,
    sitename = "StochOptInterface",
    pages = [
        "Index" => "index.md",
        "Stopping Criterion" => "stopcrit.md"
    ],
    # The following ensures that we only include the docstrings from
    # this module for functions define in Base that we overwrite.
    modules = [StochOptInterface]
)

deploydocs(
    repo   = "github.com/JuliaStochOpt/StochOptInterface.jl.git",
    target = "build",
    osname = "linux",
    julia  = "0.6",
    deps   = nothing,
    make   = nothing
)
