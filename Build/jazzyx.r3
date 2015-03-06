REBOL [
    Title: "Jazzy Interpreter"
    Authors: ["Thomas Royko" "Jayde Carney"]
]

;This is one of two wrappers.  This one is used for
;inside of the packed execuatble

;Import core
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

xpackerx-dir: what-dir
run-dir: to-rebol-file read/string %XpackerX.exedir
cd :run-dir
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
			dir: ask "CD>> "
			cd :dir
			print ""
			print ["==" what-dir]
		]
		"ls" [ ls ]
		"reset" [
			save-dir: what-dir
			cd :xpackerx-dir
			do %Interpreter/core.r3
			cd :save-dir
			print ["==" what-dir]
		]
	][
		;Get the jaz file
		file: read/string to-rebol-file input
		;Run first pass and check for validity
		if debug or verbose [ print ["===== First Pass =====" newline] ]
		valid: parse file firstpass-rule
		if debug or verbose [ print [newline "===== Second Pass =====" newline] ]
		;If valid, execute jaz code, and supress the output of parse.
		comment either valid [
			parse file master-rule
		][
			;Otherwise notifiy the user.
			print "Input is not valid Jaz code!"
		]
	]
	print ""
]