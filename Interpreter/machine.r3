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
		print ["(push" val ")"]
		append stack to-integer trim val
	]
	
	pop-op: function [

	][
		print "(pop)"
		remove back tail stack
	]

	rvalue-op: function [
		key
	][
		print ["(rvalue" key ")"]
		either found? value: memory/(key) [
			append stack value
		][
			make error! "rvalue key does not exist in memory!"
		]
	]

	lvalue-op: function [
		key
	][
		print ["(lvalue" key ")"]
		append stack trim key
	]

	set-op: function [

	][
		print "(set)"
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
		print "(copy)"
		append stack last stack
	]

	label-op: function [
		label
	][
		print ["(label" label ")"]
	]

	goto-op: function [
		location
	][
		print ["(goto" location ")"]
	]

	gofalse-op: function [
		location
	][
		print ["(gofalse" location ")"]
	]

	gotrue-op: function [
		location
	][
		print ["(gotrue" location ")"]
	]

	begin-op: function [

	][
		print "(begin)"
	]

	end-op: function [

	][
		print "(end)"
	]

	call-op: function [
		label
	][
		print ["(call" label ")"]
	]

	return-op: function [

	][
		print "(return)"
	]

	add-op: function [

	][
		print "(add)"
		frame: back back tail stack
		var: first frame
		var2: second frame
		append stack var + var2
	]

	sub-op: function [

	][
		print "(sub)"
		frame: back back tail stack
		var: first frame
		var2: second frame
		append stack var - var2
	]

	mul-op: function [

	][
		print "(mul)"
		frame: back back tail stack
		var: first frame
		var2: second frame
		append stack var * var2
	]

	div-op: function [

	][
		print "(div)"
		frame: back back tail stack
		var: first frame
		var2: second frame
		append stack var / var2
	]

	mod-op: function [

	][
		print "(mod)"
		frame: back back tail stack
		var: first frame
		var2: second frame
		append stack var // var2
	]

	and-op: function [

	][
		print "(and)"
		frame: back back tail stack
		var: first frame
		var2: second frame
		append stack var and var2
	]

	not-op: function [

	][
		print "(not)"
		frame: back tail stack
		var: first frame
		append stack not var
	]

	or-op: function [

	][
		print "(or)"
		frame: back back tail stack
		var: first frame
		var2: second frame
		append stack var or var2
	]

	not-equ-op: function [

	][
		print "(!=)"
		frame:  back back tail stack
		var: first frame
		var2: second frame
		append stack either var = var2 [0][1] 
	]

	less-equ-op: function [

	][
		print "(<=)"
		frame:  back back tail stack
		var: first frame
		var2: second frame
		append stack either var <= var2 [1][0] 
	]

	more-equ-op: function [

	][
		print "(>=)"
		frame:  back back tail stack
		var: first frame
		var2: second frame
		append stack either var >= var2 [1][0] 
	]

	less-op: function [

	][
		print "(<)"
		frame:  back back tail stack
		var: first frame
		var2: second frame
		append stack either var < var2 [1][0] 
	]

	more-op: function [

	][
		print "(>)"
		frame:  back back tail stack
		var: first frame
		var2: second frame
		append stack either var > var2 [1][0] 
	]

	equ-op: function [

	][	
		print "(=)"
		frame:  back back tail stack
		var: first frame
		var2: second frame
		append stack either var = var2 [1][0] 
	]

	print-op: function [

	][
		print last stack
	]

	halt-op: function [
		val
	][
		print "(halt)"
		halt
	]

	show-op: function [
		val
	][
		print val
	]
]