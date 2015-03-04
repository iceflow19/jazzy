REBOL [
    Title: "Jazzy Interpreter"
    Authors: ["Thomas Royko" "Jayde Carney"]
]

;import the other modules
do %rules.r3
do %machine.r3

sub-firstpass-rule: [
	any [ 1 [
		(instruction: [])
		instruction-start:	
		[
			rules/jlabel (instruction: [ machine/label-op param]) |
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
			rules/jnend 	| rules/jpush		|
			rules/jpop		| rules/jreturn		|
			[
				rules/jbegin sub-firstpass-rule rules/jend
			]
		]
		instruction-end:
	]
	(
		if debug = 1 [
			print [
						"S:" offset? program-start instruction-start 
						"E:" offset? program-start instruction-end
						"->"
						mold copy/part instruction-start instruction-end
			]
		]
		next-instruction: instruction-end
		repend instruction [offset? program-start instruction-end]
		do instruction
		remove back tail instruction
	)
	:next-instruction
	]
]

firstpass-rule: [ 
	program-start:
	[sub-firstpass-rule]
]

instruction: []

sub-master-rule: [
any [ 1 [
		(instruction: [])
		instruction-start:
		[
			rules/jpush     (instruction: [machine/push-op param]) |
			rules/jpop      (instruction: [machine/pop-op]) |
			rules/jrvalue   (instruction: [machine/rvalue-op param]) |
			rules/jlvalue   (instruction: [machine/lvalue-op param]) |
			rules/jset		(instruction: [machine/set-op]) |
			rules/jcopy     (instruction: [machine/copy-op]) |
			rules/jlabel    (instruction: [])|
			rules/jgoto     (instruction: [machine/goto-op param]) |
			rules/jgofalse  (instruction: [machine/gofalse param]) |
			rules/jgotrue   (instruction: [machine/gotrue-op param]) |
			rules/jhalt     (instruction: [machine/halt-op]) |
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
			rules/jignore   (instruction: []) |
			rules/jnend		(instruction: []) |
			[
				rules/jbegin (instruction: [machine/begin-op])
				sub-master-rule
				rules/jend   (instruction: [machine/end-op])
			]
		]
		instruction-end:
	]	
	(
		if debug = 1 [
			print [
				"S:" offset? program-start instruction-start 
				"E:" offset? program-start instruction-end
				"->"
				mold copy/part instruction-start instruction-end
			]
		]
		;trace on
		next-instruction: instruction-end			
		either 'halt-op == (second to-block first instruction) [
			next-instruction: tail program-start
		] [
			result: none? do instruction
			if result [
				next-instruction: skip program-start machine/jump-location
			]
		]
		;trace off
	)
	:next-instruction
	]
]

master-rule: [ 
	program-start:
	[sub-master-rule]	
]
