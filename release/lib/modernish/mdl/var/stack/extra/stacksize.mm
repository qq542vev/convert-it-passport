#! /module/for/moderni/sh
\command unalias stacksize 2>/dev/null



stacksize() {
	unset -v _Msh_stacksize_s
	while :; do
		case ${1-} in
		( -- )	shift; break ;;
		( --silent | --quiet )
			_Msh_stacksize_s='' ;;
		( -["$ASCIIALNUM"] | --trap=* )
			break ;;
		( -* )	die "stacksize: invalid option: $1" ;;
		( * )	break ;;
		esac
		shift
	done
	case ${#},${1-} in
	( 1,--trap=* )
		use _IN/sig
		_Msh_arg2sig "${1#--trap=}" || die "stacksize: invalid signal specification: ${_Msh_sig}"
		eval "REPLY=\${_Msh__V_Msh_trap${_Msh_sigv}__SP:-0}"
		unset -v _Msh_sig _Msh_sigv ;;
	( 1,-o )
		die "stacksize: -o: long-form option name expected" ;;
	( 2,-o )
		use _IN/opt
		_Msh_optNamToVar "$2" _Msh_stacksize_V || die "stacksize: -o: invalid long-form option: $2"
		eval "REPLY=\${_Msh__V${_Msh_stacksize_V}__SP:-0}"
		unset -v _Msh_stacksize_V ;;
	( 1,-["$ASCIIALNUM"] )
		eval "REPLY=\${_Msh__V_Msh_ShellOptLtr_${1#-}__SP:-0}" ;;
	( 1,'' | 1,[0123456789]* | 1,*[!"$ASCIIALNUM"_]* )
		die "stacksize: invalid variable name or shell option: $1" ;;
	( 1,* )	eval "REPLY=\${_Msh__V${1}__SP:-0}" ;;
	( * )	die "stacksize: need 1 non-option argument, got $#" ;;
	esac
	if isset _Msh_stacksize_s; then
		unset -v _Msh_stacksize_s
	else
		putln "$REPLY"
	fi
}


if thisshellhas ROFUNC; then
	readonly -f stacksize
fi
