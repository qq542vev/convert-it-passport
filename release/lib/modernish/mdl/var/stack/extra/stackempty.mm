#! /module/for/moderni/sh
\command unalias stackempty 2>/dev/null



stackempty() {
	unset -v _Msh_stkE_K _Msh_stkE_f
	while :; do
		case ${1-} in
		( -- )	shift; break ;;
		( --key=* )
			_Msh_stkE_K=${1#--key=} ;;
		( --force )
			_Msh_stkE_f=y ;;
		( -["$ASCIIALNUM"] | --trap=* )
			break ;;
		( -* )	die "stackempty: invalid option: $1" ;;
		( * )	break ;;
		esac
		shift
	done
	case ${#},${1-} in
	( 1,--trap=* )
		use _IN/sig
		_Msh_arg2sig "${1#--trap=}" || die "stackempty: no such signal: ${_Msh_sig}"
		_Msh_stkE_V=_Msh_trap${_Msh_sigv}
		unset -v _Msh_sig _Msh_sigv ;;
	( 1,-o )
		die "stackempty: -o: one long-form option expected" ;;
	( 1,-["$ASCIIALNUM"] )
		_Msh_stkE_V=_Msh_ShellOptLtr_${1#-} ;;
	( 1, | 1,[0123456789]* | 1,*[!"$ASCIIALNUM"_]* )
		die "stackempty: invalid variable name or shell option: $1" ;;
	( 1,* )	_Msh_stkE_V=$1 ;;
	( 2,-o )
		use _IN/opt
		_Msh_optNamToVar "$2" _Msh_stkE_V || die "stackempty: invalid long option name: $2" ;;
	( * )	die "stackempty: needs exactly 1 non-option argument" ;;
	esac
	case ${_Msh_stkE_f+f} in
	( f )	! isset "_Msh__V${_Msh_stkE_V}__SP" ;;
	( "" )	! isset "_Msh__V${_Msh_stkE_V}__SP" \
		|| ! eval "str eq \"\${_Msh_stkE_K+s},\${_Msh_stkE_K-}\" \
\"\${_Msh__V${_Msh_stkE_V}__K$((_Msh__V${_Msh_stkE_V}__SP-1))+s},\${_Msh__V${_Msh_stkE_V}__K$((_Msh__V${_Msh_stkE_V}__SP-1))-}\"" ;;
	esac
	eval "unset -v _Msh_stkE_V _Msh_stkE_K _Msh_stkE_f; return $?"
}


if thisshellhas ROFUNC; then
	readonly -f stackempty
fi
