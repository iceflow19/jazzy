REBOL [
    Title: "Jazzy Core"
    Authors: ["Thomas Royko" "Jayde Carney"]
]

;Init flags
debug: false
verbose: false

;Import the other modules
do %rules.r3
do %machine.r3

;First pass rule, used to find label locations
sub-firstpass-rule: [
	;Match one rule any number of times
	any [ 1 [
		;Defualt in case no match
		(command: [])
		;Get start of command
		command-start:	
		[
			;Rules to match and cooresponding commands to execute
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
		;Get end of command
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
		;Set to the next command
		next-command: command-end
		;Reduce and append label location to command
		repend command [offset? program-start command-end]
		;Execute command
		do command
		;Revent location build up
		remove back tail command
	)

	:next-command
	]
]

firstpass-rule: [
	;Get start of program
	program-start:
	[sub-firstpass-rule]
]

sub-master-rule: [
	;Match one rule any number of times
	any [ 1 [
		;Defualt in case no match
		(command: [])
		;Get start of command
		command-start:
		[
			;Rules to match and cooresponding commands to execute
			rules/jignore   (command: [machine/dummy-op]) |
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
				;Rule is ignored by machine.  Since it isn't
				;position dependent, always execute when encountered
				rules/jbegin (command: [machine/dummy-op] machine/begin-op)
				sub-master-rule
				rules/jend   (command: [machine/dummy-op] machine/end-op)
			]
		]
		;Get end of command
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

		;Set to the next command
		next-command: command-end
		;Detect if on a halt
		either 'halt-op == (second to-block first command) [
			;If halt, jump to end
			next-command: tail program-start
		][
			;Detect if call command
			either 'call-op == (second to-block first command) [
				;If so append the return location to the command
				repend command [offset? program-start command-end]
				result: do command
				remove back tail command
			][
				;If not call execute command as usual
				result: do command
			]
			;If the command returns a location, jump there 
			if not none? result [
					next-command: skip program-start result
			]
		]
	)
	;Set parser to beginning of next command
	:next-command
	]
]

master-rule: [
	;Get start of program
	program-start:
	[sub-master-rule]	
]
