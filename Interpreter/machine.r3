REBOL [
    Title: "Jazzy Machine"
    Authors: ["Thomas Royko" "Jayde Carney"]
]

;Note: Rebol series types, such as block!, act as both values and
;references simultaneously, allowing for rich function chaining.
;The below code uses this extensively.

make object! [

	labels: make map! []
	stack: []
	call-stack: []

	memory: make object! [

		;Memory is implemented as a stack of scopes (a key-val map).
		;Two pointers (lscope & rscope) move back and forth
		;depending on location in jaz file.
		
		scopes: []

		;Ran during construction
		lscope: rscope: first append scopes make map! []

		rprev-lnext: func [
			"Return from previous scope, set in next."
		][
			append scopes lscope: make map! []
			rscope: first back back tail scopes
		]

		rlnext: func [
			"Return and set in next scope."
		][
			lscope: rscope: last scopes
		]

		rlprev: func [
			"Return and set in the previous scope."
		][
			lscope: rscope: last remove back tail scopes
		]

		rnext-lprev: func [
			"Return from the next scope and set in the previous."
		][
			rscope: last scopes
			lscope: first back back tail scopes
		]
	]

	;All of the functions, words, and objects are defined in the
	;machine context.  A context is a scope structure
	;(similar to namespace).  Objects are also a type of context.

	push-op: function [
		"Push a value onto the stack."
		val [integer! string!]
	][

		if verbose [print ["(push" val ")"]]
		append stack to-integer trim val
		return none
	]
	
	pop-op: function [
		"Pop the stack."
	][
		if verbose [print "(pop)"]
		remove back tail stack
		return none
	]

	rvalue-op: function [
		"Push the value of a label to the stack."
		key [string!]
	][
		either found? value: select memory/rscope trim key [
			if verbose [print ["(rvalue" key "->" value ")"]]
			append stack value
		][
			append stack 0
		]
		return none
	]

	lvalue-op: function [
		"Push a label onto the stack."
		key [string!]
	][
		if verbose [print ["(lvalue" key ")"]]
		append stack trim key
		return none
	]

	set-op: function [
		"Set a variable to a value."
	][
		frame: back back tail stack
		if verbose [
			print ["(" (first frame) ":=" (second frame) ")"]
		]
		key: first frame
		either string? key [
			insert memory/lscope reduce [key second frame]
			remove/part (back back tail stack) 2
		][
			make error! "not a valid memory location!"
		]
		return none
	]

	copy-op: function [
		"copy the top of stack."
	][
		if verbose = 1 [print "(copy)"]
		append stack last stack
		return none
	]

	label-op: function [
		"Add a label."
		label [string!]
		loc-after [integer!]
	][
		if verbose [print ["(label" label ")"]]
		key: trim label
		insert labels reduce [key loc-after]
		return none
	]

	goto-op: function [
		"Goto label."
		label [string!]
	][
		if verbose [print ["(goto" label ")" newline "(label" label ")"]]
		return select labels trim label
	]

	gofalse-op: function [
		"Go if false to label."
		label [string!]
	][
		if verbose [print ["(gofalse" label ")" newline "(label" label ")"]]
		temp: (last stack) = 0
		remove back tail stack
		either temp [
			return select labels trim label
		][
			return none
		]
	]

	gotrue-op: function [
		"Go if true to label."
		label [string!]
	][
		if verbose [print ["(gotrue" label ")" newline "(label" label ")"]]
		temp: not ((last stack) = 0)
		remove back tail stack
		either temp [
			return select labels trim label
		][
			return none
		]
	]

	begin-op: function [
		"Begin parameter passing."
	][
		if verbose [print "(begin)"]
		memory/rprev-lnext
		return none
	]

	end-op: function [
		"End parameter passing."
	][
		if verbose [print "(end)"]
		memory/rlprev
		return none
	]

	call-op: function [
		"Call function."
		label   [string!]
		ret-loc [integer!]
	][
		if verbose [print ["(call" label ")" newline "(label" label ")"]]
		memory/rlnext
		either found? location: select labels trim label [
			append call-stack ret-loc
			return location
		][
			make error! "label not found!"
			return none
		]
		return none
	]

	return-op: function [
		"Return from function call."
	][
		if verbose [print "(return)"]
		memory/rnext-lprev
		location: last call-stack
		remove back tail call-stack
		return location
	]

	add-op: function [
		"First value + second value."
	][
		frame: back back tail stack
		ret: (first frame) + (second frame)
		if verbose [
			print ["(" (first frame) "+" (second frame) "->" ret ")"]
		]
		remove/part (back back tail stack) 2
		append stack ret
		return none
	]

	sub-op: function [
		"First value - second value."
	][
		frame: back back tail stack
		ret: (first frame) - (second frame)
		if verbose [
			print ["(" (first frame) "-" (second frame) "->" ret ")"]
		]
		remove/part (back back tail stack) 2
		append stack ret
		return none
	]

	mul-op: function [
		"First value * second value."
	][
		frame: back back tail stack
		ret: (first frame) * (second frame)
		if verbose [
			print ["(" (first frame) "*" (second frame) "->" ret ")"]
		]
		remove/part (back back tail stack) 2
		append stack ret
		return none
	]

	div-op: function [
		"First value / second value."
	][
		frame: back back tail stack
		ret: to-integer (first frame) / (second frame)
		if verbose [
			print ["(" (first frame) "/" (second frame) "->" ret ")"]
		]
		remove/part (back back tail stack) 2
		append stack ret
		return none
	]

	mod-op: function [
		"First value | second value."
	][
		frame: back back tail stack
		ret: (first frame) // (second frame)
		if verbose [
			print ["(" (first frame) "%" (second frame) "->" ret ")"]
		]
		remove/part (back back tail stack) 2
		append stack ret
		return none
	]

	and-op: function [
		"First value && second value."
	][
		frame: back back tail stack
		ret: (first frame) and (second frame)
		if verbose [
			print ["(" (first frame) "and" (second frame) "->" ret ")"]
		]
		remove/part (back back tail stack) 2
		append stack ret
		return none
	]

	not-op: function [
		"Negate top of stack."
	][
		ret: either (last stack) = 0 [1][0]
		if verbose [
			print ["( not"(last stack) "->" ret ")"]
		]
		remove back tail stack
		append stack ret
		return none
	]

	or-op: function [
		"First value != second value."
	][
		if verbose [print "(or)"]
		frame: back back tail stack
		ret: (first frame) or (second frame)
		if verbose [
			print ["(" (first frame) "or" (second frame) "->" ret ")"]
		]
		remove/part (back back tail stack) 2
		append stack ret
		return none
	]

	not-equ-op: function [
		"First value != second value."
	][
		if verbose [print "(!=)"]
		frame:  back back tail stack
		ret: either (first frame) = (second frame) [0][1]
		if verbose [
			print ["(" (first frame) "!=" (second frame) "->" ret ")"]
		]
		remove/part (back back tail stack) 2
		append stack ret
		return none
	]

	less-equ-op: function [
		"First value  <= second value."
	][
		frame:  back back tail stack
		ret: either (first frame) <= (second frame) [1][0]
		if verbose [
			print ["(" (first frame) "<=" (second frame) "->" ret ")"]
		]
		remove/part (back back tail stack) 2
		append stack ret
		return none
	]

	more-equ-op: function [
		"First value >= second value."
	][
		frame:  back back tail stack
		ret: either (first frame) >= (second frame) [1][0]
		if verbose [
			print ["(" (first frame) ">=" (second frame) "->" ret ")"]
		]
		remove/part (back back tail stack) 2
		append stack ret
		return none
	]

	less-op: function [
		"First value < second value."
	][
		frame:  back back tail stack
		ret: either (first frame) < (second frame) [1][0]
		if verbose [
			print ["(" (first frame) "<" (second frame) "->" ret ")"]
		]
		remove/part (back back tail stack) 2
		append stack ret
		return none
	]

	more-op: function [
		"First value > second value."
	][
		frame:  back back tail stack
		ret: either (first frame) > (second frame) [1][0]
		if verbose [
			print ["(" (first frame) ">" (second frame) "->" ret ")"]
		]
		remove/part (back back tail stack) 2
		append stack ret
		return none
	]

	equ-op: function [
		"First value = second value."
	][
		frame:  back back tail stack
		ret: either (first frame) = (second frame) [1][0]
		if verbose [
			print ["(" (first frame) "=" (second frame) "->" ret ")"]
		]
		remove/part (back back tail stack) 2
		append stack ret
		return none
	]

	print-op: function [
		"Prints the top value of the stack."
	][
		if verbose [prin "(print) "]
		print last stack
		return none
	]

	halt-op: function [
		"Halts the interpreter."
	][
		if verbose [print "(halt)"]
		halt
		return none
	]

	show-op: function [
		"Shows a string to the console"
		val [string!]
	][
		if verbose [prin "(show) "]
		print val
		return none
	]

	dummy-op: does [
		return none
	]
]