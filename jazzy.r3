REBOL [
    Title: "Jazzy Interpreter"
    Authors: ["Thomas Royko" "Jayde Carney"]
]

do %Interpreter/core.r3

file: ask "Please enter a file: "
file: read/string to-rebol-file file

;print machine/memory

valid: parse file firstpass-rule

;print machine/memory

print either valid [
	parse file master-rule
][
	"Input is not valid Jaz code!"
]
