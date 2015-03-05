REBOL [
    Title: "Jazzy Interpreter"
    Authors: ["Thomas Royko" "Jayde Carney"]
]

do %Interpreter/core.r3

forever [
	file: ask ">>"
	if file = "break" [break]
	file: read/string to-rebol-file file
	valid: parse file firstpass-rule
	comment either valid [
		parse file master-rule
	][
		print "Input is not valid Jaz code!"
	]
]