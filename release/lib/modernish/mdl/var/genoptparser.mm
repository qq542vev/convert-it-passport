#! /module/for/moderni/sh
\command unalias generateoptionparser 2>/dev/null

generateoptionparser() {




	#

	unset -v _Msh_gOPo_o _Msh_gOPo_f _Msh_gOPo_v _Msh_gOPo_n _Msh_gOPo_a
	while	case ${1-} in
		( -[!-]?* )
			_Msh_gOPo__o=$1
			shift
			while _Msh_gOPo__o=${_Msh_gOPo__o#?} && not str empty "${_Msh_gOPo__o}"; do
				_Msh_gOPo__a=-${_Msh_gOPo__o%"${_Msh_gOPo__o#?}"}
				push _Msh_gOPo__a
				case ${_Msh_gOPo__o} in
				( [fvna]* )
					_Msh_gOPo__a=${_Msh_gOPo__o#?}
					not str empty "${_Msh_gOPo__a}" && push _Msh_gOPo__a && break ;;
				esac
			done
			while pop _Msh_gOPo__a; do
				set -- "${_Msh_gOPo__a}" "$@"
			done
			unset -v _Msh_gOPo__o _Msh_gOPo__a
			continue ;;
		( -[o] )
			eval "_Msh_gOPo_${1#-}=''" ;;
		( -[fvna] )
			let "$# > 1" || die "generateoptionparser: $1: option requires argument"
			eval "_Msh_gOPo_${1#-}=\$2"
			shift ;;
		( -- )	shift; break ;;
		( -* )	die "generateoptionparser: invalid option: $1" ;;
		( * )	break ;;
		esac
	do
		shift
	done


	if isset _Msh_gOPo_v; then
		str isvarname "${_Msh_gOPo_v}" || die "generateoptionparser: invalid variable prefix: $2"
	else
		_Msh_gOPo_v=opt_
	fi
	if ! isset _Msh_gOPo_n && ! isset _Msh_gOPo_a; then
		die "generateoptionparser: at least one of -n and -a is required"
	fi
	case ${_Msh_gOPo_n-}${_Msh_gOPo_a-} in
	( *[!"$ASCIIALNUM"_]* )
		die "generateoptionparser: invalid options string(s): ${_Msh_gOPo_n-} ${_Msh_gOPo_a-}"
	esac
	case $# in
	( 0 )	_Msh_gOP_var=REPLY ;;
	( 1 )	str isvarname "$1" || die "generateoptionparser: invalid variable name: $1"
		_Msh_gOP_var=$1 ;;
	( * )	die "generateoptionparser: only 1 non-option argument allowed" ;;
	esac


	_Msh_gOP_code="${CCt}unset -v"
	_Msh_gOPo_oLs=${_Msh_gOPo_n-}${_Msh_gOPo_a-}
	while :; do
		case ${_Msh_gOPo_oLs} in
		( '' )	break ;;
		( * )	_Msh_gOPo_oL=${_Msh_gOPo_oLs%"${_Msh_gOPo_oLs#?}"}
			_Msh_gOP_code=${_Msh_gOP_code}\ ${_Msh_gOPo_v}${_Msh_gOPo_oL}
			_Msh_gOPo_oLs=${_Msh_gOPo_oLs#?}
			case ${_Msh_gOPo_oLs} in
			( *"${_Msh_gOPo_oL}"* )
				die "generateoptionparser: repeated option letter: ${_Msh_gOPo_oL}" ;;
			esac ;;
		esac
	done


	if isset _Msh_gOPo_a; then



		_Msh_gOP_code="${_Msh_gOP_code}
	while	case \${1-} in
		( -[!-]?* )
			${_Msh_gOPo_v}_o=\$1
			shift
			while ${_Msh_gOPo_v}_o=\${${_Msh_gOPo_v}_o#?} && not str empty \"\${${_Msh_gOPo_v}_o}\"; do
				${_Msh_gOPo_v}_a=-\${${_Msh_gOPo_v}_o%\"\${${_Msh_gOPo_v}_o#?}\"}
				push ${_Msh_gOPo_v}_a
				case \${${_Msh_gOPo_v}_o} in
				( [${_Msh_gOPo_a}]* )
					${_Msh_gOPo_v}_a=\${${_Msh_gOPo_v}_o#?}
					not str empty \"\${${_Msh_gOPo_v}_a}\" && push ${_Msh_gOPo_v}_a && break ;;
				esac
			done
			while pop ${_Msh_gOPo_v}_a; do
				set -- \"\${${_Msh_gOPo_v}_a}\" \"\$@\"
			done
			unset -v ${_Msh_gOPo_v}_o ${_Msh_gOPo_v}_a
			continue ;;"
	else


		_Msh_gOP_code="${_Msh_gOP_code}
	while	case \${1-} in
		( -[!-]?* )
			${_Msh_gOPo_v}_o=\${1#-}
			shift
			while not str empty \"\${${_Msh_gOPo_v}_o}\"; do
				set -- \"-\${${_Msh_gOPo_v}_o#\"\${${_Msh_gOPo_v}_o%?}\"}\" \"\$@\"	#\"
				${_Msh_gOPo_v}_o=\${${_Msh_gOPo_v}_o%?}
			done
			unset -v ${_Msh_gOPo_v}_o
			continue ;;"
	fi

	if isset _Msh_gOPo_n; then
		_Msh_gOP_code="${_Msh_gOP_code}
		( -[${_Msh_gOPo_n}] )
			eval \"${_Msh_gOPo_v}\${1#-}=''\" ;;"
	fi

	if isset _Msh_gOPo_a; then
		_Msh_gOP_code="${_Msh_gOP_code}
		( -[${_Msh_gOPo_a}] )
			let \"\$# > 1\" || die \"${_Msh_gOPo_f+$_Msh_gOPo_f: }\$1: option requires argument\"
			eval \"${_Msh_gOPo_v}\${1#-}=\\\$2\"
			shift ;;"
	fi

	_Msh_gOP_code="${_Msh_gOP_code}
		( -- )	shift; break ;;
		( -* )	die \"${_Msh_gOPo_f+$_Msh_gOPo_f: }invalid option: \$1\" ;;
		( * )	break ;;
		esac
	do
		shift
	done"

	eval "${_Msh_gOP_var}=\${_Msh_gOP_code}\${CCn}"
	if isset _Msh_gOPo_o; then
		putln "${_Msh_gOP_code}"
		unset -v _Msh_gOPo_o
	fi
	unset -v _Msh_gOPo_oLs _Msh_gOPo_oL _Msh_gOP_var \
		_Msh_gOP_code _Msh_gOPo_f _Msh_gOPo_n _Msh_gOPo_v _Msh_gOPo_a
}

if thisshellhas ROFUNC; then
	readonly -f generateoptionparser
fi
