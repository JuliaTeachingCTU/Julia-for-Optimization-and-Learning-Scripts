using Pkg
Pkg.activate(pwd() * "/lecture_01")

# # Strings

str = "Hello, world."
str[1] # returns the first character

#+

typeof(str[1])
'x'

#+

Int('x')
Char(120)

#+

str[1:5] # returns the first five characters
str[[1,2,5,6]]

#+

str[1] # returns the first character as Char
str[1:1] # returns the first character as String

#+

str1 = "This is how a string is created: \"string\"."
str2 = "\$\$\$ dollars everywhere \$\$\$"

println(str1)
println(str2)

#+

mstr = """
This is how a string is created: "string".
"""
print(mstr)

#+

str = """
  Hello,
  world.
"""
print(str)

# ### Exercise:
# Create a string with the following text
# 
# > Quotation is the repetition or copy of someone else's statement or thoughts.
# > Quotation marks are punctuation marks used in text to indicate a quotation.
# > Both of these words are sometimes abbreviated as "quote(s)".
# 
# and print it into the REPL. The printed string should look the same as the text above,
# i.e., each sentence should be on a separate line. Use an indent of length 4 for each
# sentence.
# 
# ---
# ### Solution:

str = """
    Quotation is the repetition or copy of someone else's statement or thoughts.
    Quotation marks are punctuation marks used in text to indicate a quotation.
    Both of these words are sometimes abbreviated as "quote(s)".
""";

println(str)

str = "    Quotation is the repetition or copy of someone else's statement or thoughts.\n    Quotation marks are punctuation marks used in text to indicate a quotation.\n    Both of these words are sometimes abbreviated as \"quote(s)\".";

println(str)

# ---
# 
# ## String concatenation and interpolation

string("Hello,", " world")

#+

a = 1.123
string("The variable a is of type ", typeof(a), " and its value is ", a)

#+

"Hello," * " world"
"Hello"^3
repeat("Hello", 3)

#+

a = 1.123

string("The variable a is of type ", typeof(a), " and its value is ", a)
"The variable a is of type $(typeof(a)), and its value is $(a)"

#+

"$typeof(a)"

"$(typeof(a))"

#+

myfunc = typeof

"$myfunc(a)"

"$(myfunc(a))"

#+

v = [1,2,3]
"vector: $v"

t = (1,2,3)
"tuple: $(t)"


# ### Exercise:
# Print the following message for a given vector
# 
# > "<vec> is a vector of length <len> with elements of type <type>"
# 
# where `<vec>` is the string representation of the given vector, `<len>` is the actual
# length of the given vector, and `<type>` is the type of its elements. Use the following
# two vectors.
# 
# ```julia

a = [1,2,3]
b = [:a, :b, :c, :d]

# **Hint:** use the `length` and` eltype` functions.
# 
# ---
# ### Solution:

a = [1,2,3];
str = string(a, " is a vector of length ",  length(a), " with elements of type ", eltype(a));
println(str)
b = [:a, :b, :c, :d];
str = "$(b) is a vector of length $(length(b)) with elements of type $(eltype(b))";
println(str)

# ---
# 
# ## Useful functions

join(["apples", "bananas", "pineapples"], ", ", " and ")

#+

str = "JuliaLang is a pretty cool language!"

split(str)
split(str, " a ")

#+

contains("JuliaLang is pretty cool!", "Julia")
occursin("Julia", "JuliaLang is pretty cool!")
endswith("figure.png", "png")

#+

str = "JuliaLang is a pretty cool language!"

findall(isequal('a'), str)
findfirst(isequal('a'), str)
findlast(isequal('a'), str)

#+

replace("Sherlock Holmes", "e" => "ee")
replace("Sherlock Holmes", "e" => uppercase)

# ### Exercise:
# Use the `split` function to split the following string
# 
# > "Julia!"
# 
# into a vector of single-character strings.
# **Hint:** we can say that an empty string `""` separates the characters in the string.
# 
# ---
# ### Solution:

split("Julia!", "")