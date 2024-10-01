using Pkg
Pkg.activate(pwd() * "/lecture_02")

# # Functions

# ## Function definition

function quadratic(x::Real; a::Real = 1, b::Real = 1, c::Real = 1)
    value = a*x^2 + b*x + c 
    deriv = 2* a*x + b

    return value, deriv
end