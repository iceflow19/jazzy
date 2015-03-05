REBOL [
    Title: "Jazzy Interpreter"
    Authors: ["Thomas Royko" "Jayde Carney"]
]

do %Interpreter/core.r3

jazzy-about: {
**************************************************************************
**                                                                      **
**  Jazzy - An Interpreter for the Jaz Language Written in Rebol 3      **
**                                                                      **
**    Copyright: 2015 Thomas Royko, Jayde Carney                        **
**               All rights reserved.                                   **
**    Website:   https://github.com/iceflow19/jazzy                     **
**    License:   MIT                                                    **
**    Version:   1.0.0.0                                                **
**                                                                      **
**************************************************************************
}

jazzy-help: {
=== Jazzy Help ===

quit        - exit interpreter
debug on    - turn on debugging
debug off   - turn off debugging
verbose on  - turn on verbose output
verbose off - turn off verbose output
dir         - print out current directory
about       - display interpreter about header
help        - print out this help
cd          - change directory
ls          - list files in directory
reset       - reset the interpreter
}

original-dir: what-dir
print jazzy-about

forever [
	input: ask ">> "
	print ""
	switch/default input [
		"quit" [break]
		"debug on" [debug: true]
		"debug off" [debug: false]
		"verbose on" [verbose: true]
		"verbose off" [verbose: false]
		"dir" [ print ["==" what-dir]]
		"about" [print jazzy-about]
		"help" [print jazzy-help]
		"cd" [
			dir: ask ">> Enter a directory: "
			cd :dir
			print ""
			print ["==" what-dir]
		]
		"ls" [ ls ]
		"reset" [
			cd :original-dir
			print ["==" what-dir]
			do %Interpreter/core.r3
		]
	][
		file: read/string to-rebol-file input
		if debug [ print ["===== First Pass =====" newline] ]
		valid: parse file firstpass-rule
		if debug [ print [newline "===== Second Pass =====" newline] ]
		comment either valid [
			parse file master-rule
		][
			print "Input is not valid Jaz code!"
		]
	]
	print ""
]