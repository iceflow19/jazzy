REBOL [
    Title: "Jazzy Interpreter"
    Authors: ["Thomas Royko" "Jayde Carney"]
]

;import the other modules
do %rules.r3
do %machine.r3

sub-firstpass-rule: [
	rules/jlabel (instruction: [machine/label-op param]) |
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

firstpass-rule: [ 
	program-start:
	any [ 1 [
		instruction-start:	
		[sub-firstpass-rule]
		instruction-end:
	]
	(
		repend instruction [offset? program-start instruction-end]
		do instruction
	)
	:next-instruction
	]
]

sub-master-rule: [
	rules/jpush     (instruction: [machine/push-op param]) |
	rules/jpop      (instruction: [machine/pop-op]) |
	rules/jrvalue   (instruction: [machine/rvalue-op param]) |
	rules/jlvalue   (instruction: [machine/lvalue-op param]) |
	rules/jset		(next-instruction: [machine/set-op]) |
	rules/jcopy     (next-instruction: [machine/copy-op]) |
	rules/jlabel     |
	rules/jgoto     (instruction: [machine/goto-op param]) |
	rules/jgofalse  (instruction: [machine/gofalse param]) |
	rules/jgotrue   (instruction: [machine/gotrue-op param]) |
	rules/jhalt     (instruction: [machine/print-op]) |
	rules/jreturn   (instruction: [machine/return-op]) |
	rules/jcall     (instruction: [machine/call-op param]) |
	rules/jadd      (instruction: [machine/add-op]) |
	rules/jsub      (instruction: [machine/sub-op]) |
	rules/jmul      (instruction: [machine/mul-op]) |
	rules/jdiv      (instruction: [machine/div-op]) |
	rules/jmod      (instruction: [machine/mod-op]) |
	rules/jand      (instruction: [machine/and-op]) |
	rules/jnot      (instruction: [machine/not-op]) |
	rules/jor       (instruction: [machine/or-op]) |
	rules/jnot-equ  (instruction: [machine/not-equ-op]) |
	rules/jless-equ (instruction: [machine/less-equ-op]) |
	rules/jmore-equ (instruction: [machine/more-equ-op]) |
	rules/jless     (instruction: [machine/less-op]) |
	rules/jmore     (instruction: [machine/more-op]) |
	rules/jequ      (instruction: [machine/equ-op]) |
	rules/jprint    (instruction: [machine/print-op]) |
	rules/jshow     (instruction: [machine/show-op param]) |
	rules/jignore |
	rules/jnend |
	[
		rules/jbegin (instruction: [machine/begin-op])
		sub-master-rule
		rules/jend   (instruction: [machine/end-op])
	]
]

master-rule: [ 
	program-start:
	any [ 1 [
		instruction-start:
		[sub-master-rule]	
		instruction-end:
	]	
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
