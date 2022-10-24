// Goes in js-common.code-snippets. Applies to both js and ts

   "Print to console - data": {
		"scope": "javascript,typescript",
		"prefix": "lg",
		"body": [
			"console.log('%c $1: ', 'background: #222; color: white', $1);",
			"$2"
		],
		"description": "Log output with variable name"
	},
	"Print to console - text": {
		"scope": "javascript,typescript",
		"prefix": "lgg",
		"body": [
			"console.log('$1');",
			"$2"
		],
		"description": "Log output"
	}
