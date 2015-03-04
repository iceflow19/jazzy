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
	rules/jlabel next-instruction: [(machine/label-op param)] |
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
	rules/jpush     next-instruction:[(machine/push-op param)] |
	rules/jpop      next-instruction:[(machine/pop-op)] |
	rules/jrvalue   next-instruction:[(machine/rvalue-op param)] |
	rules/jlvalue   next-instruction:[(machine/lvalue-op param)] |
	rules/jset		next-instruction:[(machine/set-op)] |
	rules/jcopy     next-instruction:[(machine/copy-op)] |
	rules/jlabel     |
	rules/jgoto     next-instruction:[(machine/goto-op param)] |
	rules/jgofalse  next-instruction:[(machine/gofalse param)] |
	rules/jgotrue   next-instruction:[(machine/gotrue-op param)] |
	rules/jhalt     next-instruction:[(machine/print-op)] |
	rules/jreturn   next-instruction:[(machine/return-op)] |
	rules/jcall     next-instruction:[(machine/call-op param)] |
	rules/jadd      next-instruction:[(machine/add-op)] |
	rules/jsub      next-instruction:[(machine/sub-op)] |
	rules/jmul      next-instruction:[(machine/mul-op)] |
	rules/jdiv      next-instruction:[(machine/div-op)] |
	rules/jmod      next-instruction:[(machine/mod-op)] |
	rules/jand      next-instruction:[(machine/and-op)] |
	rules/jnot      next-instruction:[(machine/not-op)] |
	rules/jor       next-instruction:[(machine/or-op)] |
	rules/jnot-equ  next-instruction:[(machine/not-equ-op)] |
	rules/jless-equ next-instruction:[(machine/less-equ-op)] |
	rules/jmore-equ next-instruction:[(machine/more-equ-op)] |
	rules/jless     next-instruction:[(machine/less-op)] |
	rules/jmore     next-instruction:[(machine/more-op)] |
	rules/jequ      next-instruction:[(machine/equ-op)] |
	rules/jprint    next-instruction:[(machine/print-op)] |
	rules/jshow     next-instruction:[(machine/show-op param)] |
	rules/jignore |
	rules/jnend |
	[
		rules/jbegin next-instruction:[(machine/begin-op)]
		sub-master-rule  (print "(recurse)")
		rules/jend   next-instruction:[(machine/end-op)]
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
