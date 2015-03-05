REBOL [
    Title: "Jazzy Interpreter"
    Authors: ["Thomas Royko" "Jayde Carney"]
]

param: ""

rules: [
	;Throw-away tokens
	jignore: [["/*" thru "*/"] | newline | tab | space]
	jnend: [newline | end]

	;stack operations
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

	;arithmetic operations
	jadd: ["+"]
	jsub: ["-"]
	jmul: ["*"]
	jdiv: ["/"]
	jmod: ["div"]

	;logic operations
	jand: ["&"]
	jnot: ["!"]
	jor:  ["|"]

	;relation operators
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