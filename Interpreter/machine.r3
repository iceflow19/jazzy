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
	]

	sub-op: function [

	][
		print "(sub)"
	]

	mul-op: function [

	][
		print "(mul)"
	]

	div-op: function [

	][
		print "(div)"
	]

	mod-op: function [

	][
		print "(mod)"
	]

	and-op: function [

	][
		print "(and)"
	]

	not-op: function [

	][
		print "(not)"
	]

	or-op: function [

	][
		print "(or)"
	]

	not-equ-op: function [

	][
		print "(!=)"
	]

	less-equ-op: function [

	][
		print "(<=)"
	]

	more-equ-op: function [

	][
		print "(>=)"
	]

	less-op: function [

	][
		print "(<)"
	]

	more-op: function [

	][
		print "(>)"
	]

	equ-op: function [

	][
		print "(=)"
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