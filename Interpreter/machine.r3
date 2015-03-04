REBOL [
    Title: "Jazzy Interpreter"
    Authors: ["Thomas Royko" "Jayde Carney"]
]



machine: context [

	memory: make map! []
	labels: make map! []
	stack: []
	call-stack: []

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
		ret: (first frame) - (second frame)
		remove back tail stack
		remove back tail stack
		append stack ret
	]

	mul-op: function [

	][
		if debug = 1 [print "(mul)"]
		frame: back back tail stack
		ret: (first frame) * (second frame)
		remove back tail stack
		remove back tail stack
		append stack ret
	]

	div-op: function [

	][
		if debug = 1 [print "(div)"]
		frame: back back tail stack
		ret: (first frame) / (second frame)
		remove back tail stack
		remove back tail stack
		append stack ret
	]

	mod-op: function [

	][
		if debug = 1 [print "(mod)"]
		frame: back back tail stack
		ret: (first frame) // (second frame)
		remove back tail stack
		remove back tail stack
		append stack ret
	]

	and-op: function [

	][
		if debug = 1 [print "(and)"]
		frame: back back tail stack
		ret: (first frame) and (second frame)
		remove back tail stack
		remove back tail stack
		append stack ret
	]

	not-op: function [

	][
		if debug = 1 [print "(not)"]
		frame: back tail stack
		ret: not (first frame)
		remove back tail stack
		append stack ret
	]

	or-op: function [

	][
		if debug = 1 [print "(or)"]
		frame: back back tail stack
		ret: (first frame) or (second frame)
		remove back tail stack
		remove back tail stack
		append stack ret
	]

	not-equ-op: function [

	][
		if debug = 1 [print "(!=)"]
		frame:  back back tail stack
		ret: either (first frame) = (second frame) [0][1]
		remove back tail stack
		remove back tail stack
		append stack ret
	]

	less-equ-op: function [

	][
		if debug = 1 [print "(<=)"]
		frame:  back back tail stack
		ret: either (first frame) <= (second frame) [1][0]
		remove back tail stack
		remove back tail stack
		append stack ret
	]

	more-equ-op: function [

	][
		if debug = 1 [print "(>=)"]
		frame:  back back tail stack
		ret: either (first frame) >= (second frame) [1][0]
		remove back tail stack
		remove back tail stack
		append stack ret
	]

	less-op: function [

	][
		if debug = 1 [print "(<)"]
		frame:  back back tail stack
		ret: either (first frame) < (second frame) [1][0]
		remove back tail stack
		remove back tail stack
		append stack ret
	]

	more-op: function [

	][
		if debug = 1 [print "(>)"]
		frame:  back back tail stack
		ret: either (first frame) > (second frame) [1][0]
		remove back tail stack
		remove back tail stack
		append stack ret 
	]

	equ-op: function [

	][	
		if debug = 1 [print "(=)"]
		frame:  back back tail stack
		ret: either (first frame) = (second frame) [1][0]
		remove back tail stack
		remove back tail stack
		append stack ret 
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