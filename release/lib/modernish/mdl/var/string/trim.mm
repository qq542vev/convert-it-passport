#! /module/for/moderni/sh
\command unalias trim 2>/dev/null


if thisshellhas BUG_NOCHCLASS; then



	_Msh_trim_whitespace=\'$WHITESPACE\'
else
	_Msh_trim_whitespace=[:space:]
fi
if thisshellhas BUG_BRACQUOT; then











	_Msh_trim_handleCustomChars='_Msh_trim_P=$2
			while str in "${_Msh_trim_P}" "-"; do
				_Msh_trim_P=${_Msh_trim_P%%-*}${_Msh_trim_P#*-}
			done
			eval "$1=\${$1#\"\${$1%%[!\"\$_Msh_trim_P\"-]*}\"}; $1=\${$1%\"\${$1##*[!\"\$_Msh_trim_P\"-]}\"}"
			unset -v _Msh_trim_P'
else
	_Msh_trim_handleCustomChars='eval "$1=\${$1#\"\${$1%%[!\"\$2\"]*}\"}; $1=\${$1%\"\${$1##*[!\"\$2\"]}\"}"'
fi
eval 'trim() {
	case ${#},${1-} in
	( [12], | [12],[0123456789]* | [12],*[!"$ASCIIALNUM"_]* )
		die "trim: invalid variable name: $1" ;;
	( 1,* )	eval "$1=\${$1#\"\${$1%%[!'"${_Msh_trim_whitespace}"']*}\"}; $1=\${$1%\"\${$1##*[!'"${_Msh_trim_whitespace}"']}\"}" ;;
	( 2,* )	'"${_Msh_trim_handleCustomChars}"' ;;
	( * )	die "trim: incorrect number of arguments (was $#, should be 1 or 2)" ;;
	esac
}'
unset -v _Msh_trim_whitespace _Msh_trim_handleCustomChars

if thisshellhas ROFUNC; then
	readonly -f trim
fi
