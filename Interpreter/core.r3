REBOL [
    Title: "Jazzy Interpreter"
    Authors: ["Thomas Royko" "Jayde Carney"]
]

;import the other modules
do %rules.r3
do %machine.r3

firstpass-rule: [ 
	program-start:
	any [ 1 
		instruction-start:	
		[sub-firstpass-rule]
		instruction-end:
		(
			repend instruction [offset? program-start instruction-end]
			do instruction
		)
		:next-instruction
	]
]

sub-firstpass-rule: [
	rules/jlabel (machine/label-op param) |
	rules/jrvalue	| rules/jlvalue		|
	rules/jset		| rules/jcopy      	|
	rules/jgoto     | rules/jgofalse   	|
	rules/jgotrue   | rules/jhalt      	|
	rules/jcall     | rules/jadd       	|
	rules/jsub      | rules/jmul       	|
	rules/jdiv      | rules/jmod       	|
	rules/jand      | rules/jnot       	|
	rules/jor       | rules/jnot-equ   	|
	rules/jless-equ | rules/jmore-equ  	|
	rules/jless     | rules/jmore      	|
	rules/jequ      | rules/jprint     	|
	rules/jshow     | rules/jignore 	|
	rules/jnend 	| 
	[
		rules/jbegin sub-firstpass-rule rules/jend 
	]
]

sub-master-rule: [
	rules/jpush     (machine/push-op param) |
	rules/jpop      (machine/pop-op) |
	rules/jrvalue   (machine/rvalue-op param) |
	rules/jlvalue   (machine/lvalue-op param) |
	rules/jset		(machine/set-op) |
	rules/jcopy     (machine/copy-op) |
	rules/jlabel     |
	rules/jgoto     (machine/goto-op param) |
	rules/jgofalse  (machine/gofalse param) |
	rules/jgotrue   (machine/gotrue-op param) |
	rules/jhalt     (machine/print-op) |
	rules/jreturn   (machine/return-op) |
	rules/jcall     (machine/call-op param) |
	rules/jadd      (machine/add-op) |
	rules/jsub      (machine/sub-op) |
	rules/jmul      (machine/mul-op) |
	rules/jdiv      (machine/div-op) |
	rules/jmod      (machine/mod-op) |
	rules/jand      (machine/and-op) |
	rules/jnot      (machine/not-op) |
	rules/jor       (machine/or-op) |
	rules/jnot-equ  (machine/not-equ-op) |
	rules/jless-equ (machine/less-equ-op) |
	rules/jmore-equ (machine/more-equ-op) |
	rules/jless     (machine/less-op) |
	rules/jmore     (machine/more-op) |
	rules/jequ      (machine/equ-op) |
	rules/jprint    (machine/print-op) |
	rules/jshow     (machine/show-op param) |
	rules/jignore |
	rules/jnend |
	[
		rules/jbegin (machine/begin-op)
		sub-master-rule  (print "(recurse)")
		rules/jend   (machine/end-op)
	]
]

master-rule: [ 
	program-start:
	any [ 1 
		instruction-start:
		[sub-master-rule]	
		instruction-end:	
		(
			next-instruction: instruction-end			
			either 'end-program == first instruction [
				next-instruction: tail program-start
			] [
				result: do instruction

				if not none? result [
					next-instruction: skip program-start result
				]
			]
		)
		:next-instruction
	]
]
