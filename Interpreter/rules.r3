REBOL [
    Title: "Jazzy Rules"
    Authors: ["Thomas Royko" "Jayde Carney"]
]

;Init param
param: ""

;This module contains the terminals and captures
;for the parser.  They are utilized by both the first pass
;rule and the master rule.

rules: [
	;Throw-away tokens
	jignore: [["/*" thru "*/"] | "//" | newline | tab | space]
	jnend: [newline | end]

	;Stack operations
	jpush: ["push" space copy param to rules/jnend]
	jpop: ["pop"]
	jrvalue: ["rvalue" space copy param to rules/jnend]
	jlvalue: ["lvalue" space copy param to rules/jnend]
	jset: [":="]
	jcopy: ["copy"]

	;Control operations
	jlabel: ["label" space copy param to rules/jnend]
	jgoto: ["goto" space copy param to rules/jnend]
	jgofalse: ["gofalse" space copy param to rules/jnend]
	jgotrue: ["gotrue" space copy param to rules/jnend]
	jhalt: ["halt"]

	;Procedure operations
	jbegin: ["begin"]
	jend: ["end"]
	jreturn: ["return"]
	jcall: ["call" space copy param to rules/jnend]

	;Arithmetic operations
	jadd: ["+"]
	jsub: ["-"]
	jmul: ["*"]
	jdiv: ["/"]
	jmod: ["div"]

	;Logic operations
	jand: ["&"]
	jnot: ["!"]
	jor:  ["|"]

	;Relational operators
	jnot-equ:  ["<>"]
	jless-equ: ["<="]
	jmore-equ: [">="]
	jless: ["<"]
	jmore: [">"]
	jequ: ["="]

	;Output
	jprint: ["print"]
	jshow: ["show" space copy param to rules/jnend]
]