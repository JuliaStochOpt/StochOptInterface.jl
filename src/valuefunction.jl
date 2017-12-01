# Abstraction to define value functions

abstract type AbstractValueFunction end


"""
    getvalue(vf::AbstractValueFunction, x)

Get cost-to-go at point `x`.
"""
function getvalue end
