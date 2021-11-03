# # Soft Local Scope

for i in 1:2
    t = 1 + i
    @show t
end

t

#+

for j in 1:5
    for i in 1:2
        @show i + j
    end
    i
end

#+

s = 0

for i = 1:10
    t = 1 + i # new local variable t
    s = t # assign a new value to the global variable
end

s

#+

code = """
s = 0
for i = 1:10
    t = 1 + i # new local variable t
    s = t # new local variable s and warning
end
s
""";

include_string(Main, code)

#+

code_local = """
s = 0
for i = 1:10
    t = 1 + i # new local variable t
    local s = t # assigning a new value to the global variable
end
s
"""

code_global = """
s = 0
for i = 1:10
    t = 1 + i # new local variable t
    global s = t # assigning a new value to the global variable
end
s
"""

#+

include_string(Main, code_global)
include_string(Main, code_local)
