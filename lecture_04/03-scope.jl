using Pkg
Pkg.activate(pwd() * "/lecture_04")
Pkg.instantiate()

# # Scope of variables
# ## Local scope

function f()
    z = 42
    return
end

#+

f()
z

#+

function f()
    global z = 42
    return
end

#+

f()
z

#+

function f()
    z = 42
    return z
end

#+

z = f()
z

# ## Global scope

module A
    a = 1 # a global in A's scope
    b = 2 # b global in A's scope
end

a # errors as Main's global scope is separate from A's

#+

using .A: b # make variable b from module A available

A.a
b

#+

b = 4
c = 10

#+

foo(x) = x + c

#+

foo(1)

#+

x = rand(10^6);
y = rand(10^6);

function f_global()
    z = similar(x)
    for i in eachindex(x, y)
        z[i] = x[i] + y[i]
    end
    return z
end

function f_local(x, y)
    z = similar(x)
    for i in eachindex(x, y)
        z[i] = x[i] + y[i]
    end
    return z
end

#+

hcat(f_global(), f_local(x, y))

#+

# The first call also includes compilation time, so we call each function
# once before timing it.

f_global();
f_local(x, y);

@time f_global();
@time f_local(x, y);

#+

x1, x2 = 1:10^6, (10^6+1):2*10^6;

@time f_local(x1, x2);
@time f_local(x1, x2);
