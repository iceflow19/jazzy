REBOL [
    Title: "Jazzy Interpreter"
    Authors: ["Thomas Royko" "Jayde Carney"]
]

do %Interpreter/core.r3

file: read/string %Test/JazzyTest.jaz
valid: parse file firstpass-rule
print either valid [
	parse file master-rule
][
	"input is not valid Jaz code!"
]
