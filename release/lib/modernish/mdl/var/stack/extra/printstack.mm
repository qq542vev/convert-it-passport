#! /module/for/moderni/sh
\command unalias printstack 2>/dev/null


use var/shellquote


printstack() {
	_Msh_pSo_Q=''
	while :; do
		case ${1-} in
		( -- )	shift; break ;;
		( --quote )
			_Msh_pSo_Q=yes ;;
		( -["$ASCIIALNUM"] | --trap=* )
			break ;;
		( -* )	die "stackempty: invalid option: $1" ;;
		( * )	break ;;
		esac
		shift
	done

	case ${#},$1 in
	( 1,--trap=* )
		use _IN/sig
		_Msh_arg2sig "${1#--trap=}" || die "printstack: invalid signal specification: ${_Msh_sig}"
		set -- "_Msh_trap${_Msh_sigv}"
		unset -v _Msh_sig _Msh_sigv ;;
	( 1,-o )
		die "printstack: -o: one long-form option expected" ;;
	( 1,-["$ASCIIALNUM"] )
		set -- "_Msh_ShellOptLtr_${1#-}" ;;
	( 1, | 1,[0123456789]* | 1,*[!"$ASCIIALNUM"_]* )
		die "printstack: invalid variable name: $1" ;;
	( 1,* )	;;
	( 2,-o )
		use _IN/opt
		_Msh_optNamToVar "$2" _Msh_pS_V || die "printstack: invalid long option name: $2"
		set -- "${_Msh_pS_V}"
		unset -v _Msh_pS_V ;;
	( * )	die "printstack: need 1 non-option argument, got $#" ;;
	esac


	if ! isset "_Msh__V${1}__SP"; then
		unset -v _Msh_pSo_Q
		return 1
	fi


	eval "_Msh_pS_i=\${_Msh__V${1}__SP}"
	case ${_Msh_pS_i} in
	( '' | *[!0123456789]* ) die "printstack: Stack pointer for $1 corrupted" ;;
	esac


	unset -v _Msh_pS_key
	while let '(_Msh_pS_i-=1) >= 0'; do

		if isset "_Msh__V${1}__K${_Msh_pS_i}"; then
			if ! eval "str eq \"\${_Msh_pS_key-}\" \"\${_Msh__V${1}__K${_Msh_pS_i}}\""; then
				eval "_Msh_pS_key=\${_Msh__V${1}__K${_Msh_pS_i}}"
				_Msh_pS_VAL=${_Msh_pS_key}
				case ${_Msh_pSo_Q:+n} in
				( n )	shellquote -f _Msh_pS_VAL ;;
				esac
				putln "--- key: ${_Msh_pS_VAL}"
			fi
		elif isset _Msh_pS_key; then
			unset -v _Msh_pS_key
			putln "--- (key off)"
		fi

		if isset "_Msh__V${1}__S${_Msh_pS_i}"; then
			eval "_Msh_pS_VAL=\${_Msh__V${1}__S${_Msh_pS_i}}"
			case ${_Msh_pSo_Q:+n} in
			( n )	shellquote -f _Msh_pS_VAL ;;
			esac
			PATH=$DEFPATH command printf '%7d: %s\n' "${_Msh_pS_i}" "${_Msh_pS_VAL}"
		else
			PATH=$DEFPATH command printf '%7d\n' "${_Msh_pS_i}"
		fi || die "printstack: 'printf' failed"
	done

	unset -v _Msh_pS_i _Msh_pSo_Q _Msh_pS_VAL _Msh_pS_key
}


if thisshellhas ROFUNC; then
	readonly -f printstack
fi
