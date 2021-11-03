# # Bank account

abstract type Currency end

struct Euro <: Currency
    value::Float64
end

struct Dollar <: Currency
    value::Float64
end

#+

Euro(1)

isa(Dollar(2), Currency) # equivalent to typeof(Dollar(2)) <: Currency

#+

struct BankAccount{C<:Currency}
    owner::String
    transaction::Vector{Currency}

    function BankAccount(owner::String, C::Type{<:Currency})
        return new{C}(owner, Currency[C(0)])
    end
end

#+

b = BankAccount("Paul", Euro)
push!(b.transaction, Dollar(2))
b

#+

w = [Euro(0)]
push!(w, Dollar(2))

#+

[Int32(123), 1, 1.5, 1.234f0]
Real[Int32(123), 1, 1.5, 1.234f0]

# ## Custom print

symbol(T::Type{<:Currency}) = string(nameof(T))
symbol(::Type{Euro}) = "€"

Base.show(io::IO, c::C) where {C <: Currency} = print(io, c.value, " ", symbol(C))
Base.show(io::IO, c::Currency) = print(io, c.value, " ", symbol(typeof(c)))

#+

Euro(1)
Euro(1.5)


# ### Exercise:
# Define a new method for the `symbol` function for `Dollar`.
#
# **Hint:** the dollar symbol `$` has a special meaning in Julia. Do not forget to use the
# `\` symbol when using the dollar symbol in a string.
# 
# ---
# ### Solution:

symbol(::Type{Dollar}) = "\$"
Dollar(1)
Dollar(1.5)

# ---
# 
# ## Conversion

dollar2euro(c::Dollar) = Euro(0.83 * c.value)
euro2dollar(c::Euro) = Euro(c.value / 0.83)

#+

eur = dollar2euro(Dollar(1.3))
euro2dollar(eur)

#+

rate(::Type{Euro}, ::Type{Dollar}) = 0.83
rate(T::Type{<:Currency}, ::Type{Euro}) = 1 / rate(Euro, T)

#+

rate(Euro, Dollar)
rate(Dollar, Euro)

#+

rate(Euro, Euro)
rate(Dollar, Dollar)

#+

rate(::Type{T}, ::Type{T}) where {T<:Currency} = 1

#+

rate(Dollar, Dollar)
rate(Euro, Euro)

#+

methods(rate)

#+

rate(::Type{Euro}, ::Type{Euro}) = 1

#+

rate(Euro, Euro)

#+

rate(T::Type{<:Currency}, C::Type{<:Currency}) = rate(Euro, C) * rate(T, Euro)

#+

struct Pound <: Currency
    value::Float64
end

symbol(::Type{Pound}) = "£"
rate(::Type{Euro}, ::Type{Pound}) = 1.13

#+

rate(Pound, Pound) # 1
rate(Euro, Pound) # 1.13
rate(Pound, Euro) # 1/1.13 = 0.8849557522123894
rate(Dollar, Pound) # 1.13 * 1/0.83 = 1.36144578313253
rate(Pound, Dollar) # 0.83 * 1/1.13 = 0.7345132743362832

#+

Base.convert(::Type{T}, c::T) where {T<:Currency} = c
Base.convert(::Type{T}, c::C) where {T<:Currency, C<:Currency} = T(c.value * rate(T, C))

#+

eur = convert(Euro, Dollar(1.3))
pnd = convert(Pound, eur)
dlr = convert(Dollar, pnd)

# ### Exercise:
# We see that the print style of currencies is not ideal. Usually, we are not interested in
# more than the first two digits after the decimal point. Redefine the method in the `show`
# function to print currencies so that the result will be rounded to 2 digits after the
# decimal point.
# 
# ---
# ### Solution:

function Base.show(io::IO, c::T) where {T <: Currency}
    val = round(c.value; digits = 2)
    return print(io, val, " ", symbol(T))
end

#+

eur = convert(Euro, Dollar(1.3))
pnd = convert(Pound, eur)
dlr = convert(Dollar, pnd)

# ---
# 
# Promotion

Base.promote_rule(::Type{Euro}, ::Type{<:Currency}) = Euro
Base.promote_rule(::Type{Dollar}, ::Type{Pound}) = Dollar

#+

promote_type(Euro, Dollar)
promote_type(Pound, Dollar)
promote_type(Pound, Dollar, Euro)

#+

promote(Euro(2), Dollar(2.4))
promote(Pound(1.3), Euro(2))
promote(Pound(1.3), Dollar(2.4), Euro(2))

# ### Exercise:
# Define a new currency, `CzechCrown`, that will represent Czech crowns. The exchange rate
# to euro is `0.038`, and all other currencies should take precedence over the Czech crown.
# 
# ---
# ### Solution:


struct CzechCrown <: Currency
    value::Float64
end

symbol(::Type{CzechCrown}) = "Kč"
rate(::Type{Euro}, ::Type{CzechCrown}) = 0.038

Base.promote_rule(::Type{CzechCrown}, ::Type{Dollar}) = Dollar
Base.promote_rule(::Type{CzechCrown}, ::Type{Pound}) = Pound

#+

CzechCrown(2.8)
dl = convert(Dollar, CzechCrown(64))
convert(CzechCrown, dl)
promote(Pound(1.3), Dollar(2.4), Euro(2), CzechCrown(2.8))

# ---
# 
# Basic arithmetic operations


Base.:+(x::Currency, y::Currency) = +(promote(x, y)...)
Base.:+(x::T, y::T) where {T <: Currency} = T(x.value + y.value)

#+

Dollar(1.3) + CzechCrown(4.5)
CzechCrown(4.5) + Euro(3.2) + Pound(3.6) + Dollar(12)

#+

sum([CzechCrown(4.5), Euro(3.2), Pound(3.6), Dollar(12)])

#+

CzechCrown.([4.5, 2.4, 16.7, 18.3]) .+ Pound.([1.2, 2.6, 0.6, 1.8])
CzechCrown.([4.5, 2.4, 16.7, 18.3]) .+ Dollar(12)

#+

Base.broadcastable(c::Currency) = Ref(c)

#+

c_ref = Ref(Euro(1))
axes(c_ref)
ndims(c_ref)
c_ref[]

#+

CzechCrown.([4.5, 2.4, 16.7, 18.3]) .+ Dollar(12)

# ### Exercise:
# In the section above, we defined the addition for all subtypes of the `Currency`. We also
# told the broadcasting system in Julia to treat all subtypes of the `Currency` as scalars.
# Follow the same pattern and define all following operations: `-`, `*`, `/`.
#
# **Hint:** Define only the operations that make sense. For example, It makes sense
# to multiply
# `1 €` by 2 and get `2 €`. But it does not make sense to multiply `1 €` by `2 €`.
# 
# ---
# ### Solution:

Base.:-(x::Currency, y::Currency) = -(promote(x, y)...)
Base.:-(x::T, y::T) where {T <: Currency} = T(x.value - y.value)

#+

Dollar(1.3) - CzechCrown(4.5)
CzechCrown.([4.5, 2.4, 16.7, 18.3]) .- Dollar(12)

#+

Base.:*(a::Real, x::T) where {T <: Currency} = T(a * x.value)
Base.:*(x::T, a::Real) where {T <: Currency} = T(a * x.value)

#+

2 * Dollar(1.3) * 0.5
2 .* CzechCrown.([4.5, 2.4, 16.7, 18.3]) .* 0.5

#+

Base.:/(x::T, a::Real) where {T <: Currency} = T(x.value / a)
Base.:/(x::Currency, y::Currency) = /(promote(x, y)...)
Base.:/(x::T, y::T) where {T <: Currency} = x.value / y.value

#+

Dollar(1.3) / 2
2 .* CzechCrown.([1, 2, 3, 4]) ./ CzechCrown(1)

# ---
# 
# ## Currency comparison

Dollar(1) == Euro(0.83)
Dollar(1) != Euro(0.83)

#+

Base.:(==)(x::Currency, y::Currency) = ==(promote(x, y)...)
Base.:(==)(x::T, y::T) where {T <: Currency} = ==(x.value, y.value)

#+

Dollar(1) == Euro(0.83)
Dollar(1) != Euro(0.83)

#+

Base.isless(x::Currency, y::Currency) = isless(promote(x, y)...)
Base.isless(x::T, y::T) where {T <: Currency} = isless(x.value, y.value)

#+

Dollar(1) < Euro(0.83)
Dollar(1) > Euro(0.83)
Dollar(1) <= Euro(0.83)
Dollar(1) >= Euro(0.83)

#+

vals = Currency[CzechCrown(100), Euro(0.83),  Pound(3.6), Dollar(1.2)]

extrema(vals)
argmin(vals)
sort(vals)

# ## Back to bank account

balance(b::BankAccount{C}) where {C} = convert(C, sum(b.transaction))

#+

account = BankAccount("Paul", CzechCrown)
balance(account)

#+

function Base.show(io::IO, b::BankAccount{C}) where {C<:Currency}
    println(io, "Bank Account:")
    println(io, "  - Owner: ", b.owner)
    println(io, "  - Primary currency: ", nameof(C))
    println(io, "  - Balance: ", balance(b))
    print(io,   "  - Number of transactions: ", length(b.transaction))
end

#+

account

#+

function (b::BankAccount{T})(c::Currency) where {T}
    balance(b) + c >= T(0) || throw(ArgumentError("insufficient bank account balance."))
    push!(b.transaction, c)
    return
end

#+

account(Dollar(10))
account(-2*balance(b))
account(Pound(10))
account(Euro(23.6))
account(CzechCrown(152))

#+

account
account.transaction
