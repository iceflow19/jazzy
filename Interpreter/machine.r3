REBOL [
    Title: "Jazzy Interpreter"
    Authors: ["Thomas Royko" "Jayde Carney"]
]



machine: context [

	memory: make map! []
	labels: make map! []
	stack: []
	call-stack: []
	debug: 0

	push-op: function [
		val
	][

		if debug = 1 [print ["(push" val ")"]] 
		append stack to-integer trim val
	]
	
	pop-op: function [

	][
		if debug = 1 [print "(pop)"]
		remove back tail stack
	]

	rvalue-op: function [
		key
	][
		if debug = 1 [print ["(rvalue" key ")"]]
		either found? value: memory/(key) [
			append stack value
		][
			append stack 0
		]
	]

	lvalue-op: function [
		key
	][
		if debug = 1 [print ["(lvalue" key ")"]]
		append stack trim key
	]

	set-op: function [

	][
		if debug = 1 [print "(set)"]
		frame: back back tail stack
		key: first frame
		either string? key [
			memory/(key): second frame
			remove back tail stack
			remove back tail stack
		][
			make error! "not a valid memory location!"
		]
	]

	copy-op: function [

	][
		if debug =1 [print "(copy)"]
		append stack last stack
	]

	label-op: function [
		label
		loc-after
	][
		if debug = 1 [print ["(label" label ")"]]
		key: trim label
		labels/(key): loc-after
	]

	goto-op: function [
		key
	][
		if debug = 1 [print ["(goto" location ")"]]
		return labels/(key)
	]

	gofalse-op: function [
		key
	][
		if debug = 1 [print ["(gofalse" location ")"]]
		temp: (last stack = 0)
		remove back tail stack
		if (temp) [
			return labels/(key)
		]
	]

	gotrue-op: function [
		key
	][
		if debug = 1 [print ["(gotrue" location ")"]]
		temp: not (last stack = 0)
		remove back tail stack
		if (temp) [
			return labels/(key)
		]
	]

	begin-op: function [

	][
		if debug = 1 [print "(begin)"]
	]

	end-op: function [

	][
		if debug = 1 [print "(end)"]
	]

	call-op: function [
		label
	][
		if debug = 1 [print ["(call" label ")"]]
	]

	return-op: function [

	][
		if debug = 1 [print "(return)"]
	]

	add-op: function [

	][
		if debug = 1 [print "(add)"]
		frame: back back tail stack
		ret: (first frame) + (second frame)
		remove back tail stack
		remove back tail stack
		append stack ret
	]

	sub-op: function [

	][
		if debug = 1 [print "(sub)"]
		frame: back back tail stack
		var: first frame
		var2: second frame
		append stack var - var2
	]

	mul-op: function [

	][
		if debug = 1 [print "(mul)"]
		frame: back back tail stack
		var: first frame
		var2: second frame
		append stack var * var2
	]

	div-op: function [

	][
		if debug = 1 [print "(div)"]
		frame: back back tail stack
		var: first frame
		var2: second frame
		append stack var / var2
	]

	mod-op: function [

	][
		if debug = 1 [print "(mod)"]
		frame: back back tail stack
		var: first frame
		var2: second frame
		append stack var // var2
	]

	and-op: function [

	][
		if debug = 1 [print "(and)"]
		frame: back back tail stack
		var: first frame
		var2: second frame
		append stack var and var2
	]

	not-op: function [

	][
		if debug = 1 [print "(not)"]
		frame: back tail stack
		var: first frame
		append stack not var
	]

	or-op: function [

	][
		if debug = 1 [print "(or)"]
		frame: back back tail stack
		var: first frame
		var2: second frame
		append stack var or var2
	]

	not-equ-op: function [

	][
		if debug = 1 [print "(!=)"]
		frame:  back back tail stack
		var: first frame
		var2: second frame
		append stack either var = var2 [0][1] 
	]

	less-equ-op: function [

	][
		if debug = 1 [print "(<=)"]
		frame:  back back tail stack
		var: first frame
		var2: second frame
		append stack either var <= var2 [1][0] 
	]

	more-equ-op: function [

	][
		if debug = 1 [print "(>=)"]
		frame:  back back tail stack
		var: first frame
		var2: second frame
		append stack either var >= var2 [1][0] 
	]

	less-op: function [

	][
		if debug = 1 [print "(<)"]
		frame:  back back tail stack
		var: first frame
		var2: second frame
		append stack either var < var2 [1][0] 
	]

	more-op: function [

	][
		if debug = 1 [print "(>)"]
		frame:  back back tail stack
		var: first frame
		var2: second frame
		append stack either var > var2 [1][0] 
	]

	equ-op: function [

	][	
		if debug = 1 [print "(=)"]
		frame:  back back tail stack
		var: first frame
		var2: second frame
		append stack either var = var2 [1][0] 
	]

	print-op: function [

	][
		if debug = 1 [print "(print)"]
		print last stack
	]

	halt-op: function [

	][
		if debug = 1 [print "(halt)"]
		halt
	]

	show-op: function [
		val
	][
		if debug = 1 [print "(show)"]
		print val
	]
]