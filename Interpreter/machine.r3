REBOL [
    Title: "Jazzy Interpreter"
    Authors: ["Thomas Royko" "Jayde Carney"]
]

machine: context [


	memory: make object! [
		
		scopes: []
		lscope: rscope: first append scopes make map! []

		rprev-lnext: does [
			append scopes lscope: make map! []
			rscope: first back back tail scopes
		]

		rlnext: does [
			lscope: rscope: last scopes
		]

		rlprev: does [
			lscope: rscope: last remove back tail scopes
		]

		rnext-lprev: does [
			rscope: last scopes
			lscope: first back back tail scopes
		]
	]
	
	labels: make map! []
	stack: []
	call-stack: []

	push-op: function [
		val
	][

		if verbose [print ["(push" val ")"]]
		append stack to-integer trim val
		return none
	]
	
	pop-op: function [

	][
		if verbose [print "(pop)"]
		remove back tail stack
		return none
	]

	rvalue-op: function [
		key
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
		key
	][
		if verbose [print ["(lvalue" key ")"]]
		append stack trim key
		return none
	]

	set-op: function [

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

	][
		if verbose =1 [print "(copy)"]
		append stack last stack
		return none
	]

	label-op: function [
		label
		loc-after
	][
		if verbose [print ["(label" label ")"]]
		key: trim label
		insert labels reduce [key loc-after]
		return none
	]

	goto-op: function [
		key
	][
		if verbose [print ["(goto" key ")"]]
		return select labels trim key
	]

	gofalse-op: function [
		key
	][
		if verbose [print ["(gofalse" key ")"]]
		temp: (last stack) = 0
		remove back tail stack
		either temp [
			return select labels trim key
		][
			return none
		]
	]

	gotrue-op: function [
		key
	][
		if verbose [print ["(gotrue" key ")"]]
		temp: not ((last stack) = 0)
		remove back tail stack
		either temp [
			return select labels trim key
		][
			return none
		]
	]

	begin-op: function [

	][
		if verbose [print "(begin)"]
		memory/rprev-lnext
		return none
	]

	end-op: function [

	][
		if verbose [print "(end)"]
		memory/rlprev
		return none
	]

	call-op: function [
		label ret-loc
	][
		if verbose [print ["(call" label ")"]]
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

	][
		if verbose [print "(return)"]
		memory/rnext-lprev
		location: last call-stack
		remove back tail call-stack
		return location
	]

	add-op: function [

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

	][
		frame: back back tail stack
		ret: (first frame) - (second frame)
		if verbose [
			print ["(" (first frame) "-" (second frame) "->" ret]
		]
		remove/part (back back tail stack) 2
		append stack ret
		return none
	]

	mul-op: function [

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

	][
		if verbose [prin "(print) "]
		print last stack
		return none
	]

	halt-op: function [

	][
		if verbose [print "(halt)"]
		halt
		return none
	]

	show-op: function [
		val
	][
		if verbose [prin "(show) "]
		print val
		return none
	]

	dummy-op: does [
		return none
	]
]