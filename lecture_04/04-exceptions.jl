# ------------------------------------------------------------------------------------------
# Exception handling
# ------------------------------------------------------------------------------------------

function fact(n)
    isinteger(n) && n >= 0 || error("argument must be non-negative integer")
    return n == 0 ? 1 : n * fact(n - 1)
end

fact(1.4)

fact(-5)

function fact(n)
    isinteger(n) && n >= 0 || throw(DomainError(n, "argument must be non-negative integer"))
    return n == 0 ? 1 : n * fact(n - 1)
end

fact(1.4)

fact(-5)

fact("a")

function fact_new(n::Real)
    isinteger(n) && n >= 0 || throw(DomainError(n, "argument must be non-negative integer"))
    return n == 0 ? 1 : n * fact(n - 1)
end

fact_new("aaa")

methods(fact_new)
