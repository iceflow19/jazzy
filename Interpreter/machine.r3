REBOL [
    Title: "Jazzy Interpreter"
    Authors: ["Thomas Royko" "Jayde Carney"]
]



machine: context [

	memory: make map! []
	labels: make map! []
	stack: []
	call-stack: []
	jump-location: 0

	push-op: function [
		val
	][

		if debug [print ["(push" val ")"]] 
		append stack to-integer trim val
		return none
	]
	
	pop-op: function [

	][
		if debug [print "(pop)"]
		remove back tail stack
		return none
	]

	rvalue-op: function [
		key
	][
		if debug [print ["(rvalue" key ")"]]
		either found? value: memory/(key) [
			append stack value
		][
			append stack 0
		]
		return none
	]

	lvalue-op: function [
		key
	][
		if debug [print ["(lvalue" key ")"]]
		append stack trim key
		return none
	]

	set-op: function [

	][
		if debug [print "(set)"]
		frame: back back tail stack
		key: first frame
		either string? key [
			memory/(key): second frame
			remove remove back back tail stack
		][
			make error! "not a valid memory location!"
		]
		return none
	]

	copy-op: function [

	][
		if debug =1 [print "(copy)"]
		append stack last stack
		return none
	]

	label-op: function [
		label
		loc-after
	][
		if debug [print ["(label" label ")"]]
		key: trim label
		labels/(key): loc-after
		return none
	]

	goto-op: function [
		key
	][
		if debug [print ["(goto" location ")"]]
		return labels/(key)
	]

	gofalse-op: function [
		key
	][
		if debug [print ["(gofalse" location ")"]]
		temp: (last stack) = 0
		remove back tail stack
		either temp [
			return labels/(key)
		][
			return none
		]
	]

	gotrue-op: function [
		key
	][
		if debug [print ["(gotrue" location ")"]]
		temp: not ((last stack) = 0)
		remove back tail stack
		either temp [
			return labels/(key)
		][
			return none
		]
	]

	begin-op: function [

	][
		if debug [print "(begin)"]
		return none
	]

	end-op: function [

	][
		if debug [print "(end)"]
		return none
	]

	call-op: function [
		label
	][
		if debug [print ["(call" label ")"]]
		return none
	]

	return-op: function [

	][
		if debug [print "(return)"]
		return none
	]

	add-op: function [

	][
		if debug [print "(add)"]
		frame: back back tail stack
		ret: (first frame) + (second frame)
		remove remove back back tail stack
		append stack ret
		return none
	]

	sub-op: function [

	][
		if debug [print "(sub)"]
		frame: back back tail stack
		ret: (first frame) - (second frame)
		remove remove back back tail stack
		append stack ret
		return none
	]

	mul-op: function [

	][
		if debug [print "(mul)"]
		frame: back back tail stack
		ret: (first frame) * (second frame)
		remove remove back back tail stack
		append stack ret
		return none
	]

	div-op: function [

	][
		if debug [print "(div)"]
		frame: back back tail stack
		ret: to-integer (first frame) / (second frame)
		remove remove back back tail stack
		append stack ret
		return none
	]

	mod-op: function [

	][
		if debug [print "(mod)"]
		frame: back back tail stack
		ret: (first frame) // (second frame)
		remove remove back back tail stack
		append stack ret
		return none
	]

	and-op: function [

	][
		if debug [print "(and)"]
		frame: back back tail stack
		ret: (first frame) and (second frame)
		remove remove back back tail stack
		append stack ret
		return none
	]

	not-op: function [

	][
		if debug [print "(not)"]
		ret: either (last stack) = 0 [1][0]
		remove back tail stack
		append stack ret
		return none
	]

	or-op: function [

	][
		if debug [print "(or)"]
		frame: back back tail stack
		ret: (first frame) or (second frame)
		remove remove back back tail stack
		append stack ret
		return none
	]

	not-equ-op: function [

	][
		if debug [print "(!=)"]
		frame:  back back tail stack
		ret: either (first frame) = (second frame) [0][1]
		remove remove back back tail stack
		append stack ret
		return none
	]

	less-equ-op: function [

	][
		if debug [print "(<=)"]
		frame:  back back tail stack
		ret: either (first frame) <= (second frame) [1][0]
		remove remove back back tail stack
		append stack ret
		return none
	]

	more-equ-op: function [

	][
		if debug [print "(>=)"]
		frame:  back back tail stack
		ret: either (first frame) >= (second frame) [1][0]
		remove remove back back tail stack
		append stack ret
		return none
	]

	less-op: function [

	][
		if debug [print "(<)"]
		frame:  back back tail stack
		ret: either (first frame) < (second frame) [1][0]
		remove remove back back tail stack
		append stack ret
		return none
	]

	more-op: function [

	][
		if debug [print "(>)"]
		frame:  back back tail stack
		ret: either (first frame) > (second frame) [1][0]
		remove remove back back tail stack
		append stack ret
		return none
	]

	equ-op: function [

	][	
		if debug [print "(=)"]
		frame:  back back tail stack
		ret: either (first frame) = (second frame) [1][0]
		remove remove back back tail stack
		append stack ret
		return none
	]

	print-op: function [

	][
		if debug [print "(print)"]
		print last stack
		return none
	]

	halt-op: function [

	][
		if debug [print "(halt)"]
		halt
		return none
	]

	show-op: function [
		val
	][
		if debug [print "(show)"]
		print val
		return none
	]
]