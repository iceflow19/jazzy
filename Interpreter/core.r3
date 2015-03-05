REBOL [
    Title: "Jazzy Interpreter"
    Authors: ["Thomas Royko" "Jayde Carney"]
]

debug: false
verbose: false

;import the other modules
do %rules.r3
do %machine.r3

sub-firstpass-rule: [
	any [ 1 [
		(command: [])
		command-start:	
		[
			rules/jlabel (command: [ machine/label-op param]) |
			rules/jignore 	| rules/jreturn		|
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
			rules/jshow     | rules/jpop		|
			rules/jnend 	| rules/jpush		|
			[
				rules/jbegin sub-firstpass-rule rules/jend
			]
		]
		command-end:
	]
	(
		if debug [
			print [
				"S:" offset? program-start command-start 
				"E:" offset? program-start command-end
				"->"
				mold copy/part command-start command-end
			]
		]
		next-command: command-end
		repend command [offset? program-start command-end]
		do command
		remove back tail command
	)
	:next-command
	]
]

firstpass-rule: [ 
	program-start:
	[sub-firstpass-rule]
]

command: []

sub-master-rule: [
	any [ 1 [
		(command: [])
		command-start:
		[
			rules/jignore   (command: [does [return none]]) |
			rules/jpush     (command: [machine/push-op param]) |
			rules/jpop      (command: [machine/pop-op]) |
			rules/jrvalue   (command: [machine/rvalue-op param]) |
			rules/jlvalue   (command: [machine/lvalue-op param]) |
			rules/jset		(command: [machine/set-op]) |
			rules/jcopy     (command: [machine/copy-op]) |
			rules/jlabel    (command: [machine/dummy-op])|
			rules/jgoto     (command: [machine/goto-op param]) |
			rules/jgofalse  (command: [machine/gofalse-op param]) |
			rules/jgotrue   (command: [machine/gotrue-op param]) |
			rules/jhalt     (command: [machine/halt-op]) |
			rules/jreturn   (command: [machine/return-op]) |
			rules/jcall     (command: [machine/call-op param]) |
			rules/jadd      (command: [machine/add-op]) |
			rules/jsub      (command: [machine/sub-op]) |
			rules/jmul      (command: [machine/mul-op]) |
			rules/jdiv      (command: [machine/div-op]) |
			rules/jmod      (command: [machine/mod-op]) |
			rules/jand      (command: [machine/and-op]) |
			rules/jnot      (command: [machine/not-op]) |
			rules/jor       (command: [machine/or-op]) |
			rules/jnot-equ  (command: [machine/not-equ-op]) |
			rules/jless-equ (command: [machine/less-equ-op]) |
			rules/jmore-equ (command: [machine/more-equ-op]) |
			rules/jless     (command: [machine/less-op]) |
			rules/jmore     (command: [machine/more-op]) |
			rules/jequ      (command: [machine/equ-op]) |
			rules/jprint    (command: [machine/print-op]) |
			rules/jshow     (command: [machine/show-op param]) |
			rules/jnend		(command: [machine/dummy-op]) |
			[
				rules/jbegin (command: [machine/dummy-op] machine/begin-op)
				sub-master-rule
				rules/jend   (command: [machine/dummy-op] machine/end-op)
			]
		]
		command-end:
	]	
	(
		if debug [
			print [
				"S:" offset? program-start command-start 
				"E:" offset? program-start command-end
				"->"
				mold copy/part command-start command-end
			]
		]
		next-command: command-end			
		either 'halt-op == (second to-block first command) [
			next-command: tail program-start
		][
			either 'call-op == (second to-block first command) [
				repend command [offset? program-start command-end]
				result: do command
				remove back tail command
			][
				result: do command
			]

			if not none? result [
					next-command: skip program-start result
			]
		]
	)
	:next-command
	]
]

master-rule: [ 
	program-start:
	[sub-master-rule]	
]
