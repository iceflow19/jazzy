REBOL [
    Title: "Jazzy Interpreter"
    Authors: ["Thomas Royko" "Jayde Carney"]
]

do %Interpreter/core.r3

file: read/string %Test/JazzyTest.jaz
print parse file firstpass-rule
print parse file master-rule