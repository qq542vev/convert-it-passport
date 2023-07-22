#! /module/for/moderni/sh
\command unalias _loopgen_repeat 2>/dev/null

use var/loop

_loopgen_repeat() {
	let "$# == 1" || _loop_die "expected 1 argument, got $#"
	case +$1 in
	( *[!_$ASCIIALNUM]_loop_* | *[!_$ASCIIALNUM]_Msh_* )
		_loop_die "cannot use _Msh_* or _loop_* internal namespace" ;;
	esac
	_loop_expr=$1



	command trap '_loop_die "invalid arithmetic expression: ${_loop_expr}"' 0
	let "_loop_R = (${_loop_expr})" "1" || exit
	command trap - 0

	{

		shellquote _loop_expr
		if let "_loop_R <= 0"; then
			putln "let ${_loop_expr} 0"
			exit
		fi
		put "let ${_loop_expr}"



		_Msh_i=0
		while let "(_Msh_i += 1) <= _loop_R"; do
			putln || exit
		done
	} >&8 2>/dev/null || die "LOOP ${_loop_type}: can't write iterations"
}

if thisshellhas ROFUNC; then
	readonly -f _loopgen_repeat
fi
