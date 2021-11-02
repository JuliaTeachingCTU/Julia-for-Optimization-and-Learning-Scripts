# ------------------------------------------------------------------------------------------
# Scope of variables
# ------------------------------------------------------------------------------------------

# ------------------------------------------------------------------------------------------
# Local scope
# ------------------------------------------------------------------------------------------
function f()
    z = 42
    return
end

f()

z

function f()
    global z = 42
    return
end

f()

z

function f()
    z = 42
    return z
end

z = f()

z


# ------------------------------------------------------------------------------------------
# Global scope
# ------------------------------------------------------------------------------------------

module A
    a = 1 # a global in A's scope
    b = 2 # b global in A's scope
end

a # errors as Main's global scope is separate from A's

using .A: b # make variable b from module A available

A.a

b

b = 4

c = 10

foo(x) = x + c

foo(1)

x = rand(10);

y = rand(10);

f_global() = x .+ y

f_local(x, y) = x .+ y

hcat(f_global(), f_local(x, y))

@time f_global();

@time f_local(x, y);

a, b = 1:10, 11:20;

@time f_local(a, b);

@time f_local(a, b);
