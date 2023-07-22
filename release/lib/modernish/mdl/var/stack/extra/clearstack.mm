#! /module/for/moderni/sh
\command unalias clearstack 2>/dev/null


clearstack() {
	unset -v _Msh_cS_key _Msh_cS_f
	while :; do
		case ${1-} in
		( -- )	shift; break ;;
		( --key=* )
			_Msh_cS_key=${1#--key=} ;;
		( --force )
			_Msh_cS_f=y ;;
		( --trap=* | -o )
			break ;;
		( -* )	die "clearstack: invalid option: $1" ;;
		( * )	break ;;
		esac
		shift
	done
	case $# in
	( 0 )	die "clearstack: needs at least 1 non-option argument" ;;
	esac
	case ${_Msh_cS_key+k}${_Msh_cS_f+f} in
	( kf )	die "clearstack: options --key= and --force are mutually exclusive" ;;
	esac


	_Msh_cS_err=0
	unset -v _Msh_cS_o
	for _Msh_cS_V do
		case ${_Msh_cS_o-} in
		( y )	_Msh_optNamToVar "${_Msh_cS_V}" _Msh_cS_V \
			|| die "clearstack: invalid long option name: ${_Msh_cS_V}"
			unset -v _Msh_cS_o ;;
		( * )	case ${_Msh_cS_V} in
			( --trap=* )
				use _IN/sig
				_Msh_arg2sig "${_Msh_cS_V#--trap=}" \
				|| die "clearstack --trap: no such signal: ${_Msh_sig}"
				_Msh_clearAllTrapsIfFirstInSubshell
				_Msh_cS_V=_Msh_trap${_Msh_sigv} ;;
			( -o )	_Msh_cS_o=y
				use _IN/opt
				continue ;;
			( -["$ASCIIALNUM"] )
				_Msh_cS_V="_Msh_ShellOptLtr_${_Msh_cS_V#-}" ;;
			( '' | [0123456789]* | *[!"$ASCIIALNUM"_]* )
				die "clearstack: invalid variable name or shell option: $_Msh_cS_V" ;;
			esac ;;
		esac


		eval "_Msh_cS_SP=\${_Msh__V${_Msh_cS_V}__SP+s},\${_Msh__V${_Msh_cS_V}__SP-}"
		case ${_Msh_cS_SP} in
		( , )	_Msh_cS_err=$((_Msh_cS_err<1 ? 1 : _Msh_cS_err)); continue ;;
		( s, | s,0* | s,*[!0123456789]* )
			die "clearstack: Stack pointer for ${_Msh_cS_V} corrupted" ;;
		esac


		case ${_Msh_cS_f+s} in
		( "" )	_Msh_cS_SP=$((_Msh__V${_Msh_cS_V}__SP - 1))
			eval "case \${_Msh_cS_key+k},\${_Msh_cS_key-},\${_Msh__V${_Msh_cS_V}__K${_Msh_cS_SP}+s} in
			( ,, | k,\"\${_Msh__V${_Msh_cS_V}__K${_Msh_cS_SP}-}\",s )
				;;
			( * )	_Msh_cS_err=2 ;;
			esac" ;;
		esac
	done


	case ${_Msh_cS_err} in
	( 0 ) for _Msh_cS_V do
		unset -v _Msh_cS_sST
		case ${_Msh_cS_o-} in
		( y )	_Msh_optNamToVar "${_Msh_cS_V}" _Msh_cS_V || die "clearstack: internal error"
			unset -v _Msh_cS_o ;;
		esac
		case ${_Msh_cS_V} in
		( --trap=* )
			_Msh_arg2sig "${_Msh_cS_V#--trap=}"
			push _Msh_cS_key _Msh_cS_f _Msh_cS_err
			clearstack ${_Msh_cS_f+"--force"} ${_Msh_cS_key+"--key=$_Msh_cS_key"} \
				"_Msh_trap${_Msh_sigv}_opt" "_Msh_trap${_Msh_sigv}_ifs" "_Msh_trap${_Msh_sigv}_noSub"
			pop _Msh_cS_key _Msh_cS_f _Msh_cS_err
			_Msh_cS_sST=
			_Msh_cS_V=_Msh_trap${_Msh_sigv} ;;
		( -o )	_Msh_cS_o=y
			continue ;;
		( -? )	_Msh_cS_V="_Msh_ShellOptLtr_${_Msh_cS_V#-}" ;;
		esac
		eval "_Msh_cS_SP=\${_Msh__V${_Msh_cS_V}__SP}"
		while let "(_Msh_cS_SP-=1) >= 0" &&

			case ${_Msh_cS_f+s} in
			( "" )	eval "case \${_Msh_cS_key+k},\${_Msh_cS_key-},\${_Msh__V${_Msh_cS_V}__K${_Msh_cS_SP}+s} in
				( ,, | k,\"\${_Msh__V${_Msh_cS_V}__K${_Msh_cS_SP}-}\",s )
					;;
				( * )	! : ;;
				esac" ;;
			esac
		do
			unset -v "_Msh__V${_Msh_cS_V}__S${_Msh_cS_SP}" "_Msh__V${_Msh_cS_V}__K${_Msh_cS_SP}"
		done
		if let "_Msh_cS_SP >= 0"; then
			let "_Msh__V${_Msh_cS_V}__SP = _Msh_cS_SP + 1"
		else
			unset -v "_Msh__V${_Msh_cS_V}__SP"
		fi
		if isset _Msh_cS_sST; then
			use -q var/stack/trap && _Msh_setSysTrap "${_Msh_sig}" "${_Msh_sigv}"
			unset -v _Msh_sig _Msh_sigv
		fi
	done;; esac
	eval "unset -v _Msh_cS_V _Msh_cS_SP _Msh_cS_key _Msh_cS_f _Msh_cS_err _Msh_cS_sST; return ${_Msh_cS_err}"
}



if thisshellhas ROFUNC; then
	readonly -f clearstack
fi
