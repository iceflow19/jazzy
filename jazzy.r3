REBOL [
    Title: "Jazzy Interpreter"
    Authors: ["Thomas Royko" "Jayde Carney"]
]

do %Interpreter/core.r3

file: read/string %Test/foo2.jaz
print parse file master-rule