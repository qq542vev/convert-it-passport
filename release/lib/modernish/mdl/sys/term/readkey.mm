#! /module/for/moderni/sh
\command unalias readkey _Msh_readkey_getBufChar _Msh_readkey_restoreTerminalState _Msh_readkey_setTerminalState 2>/dev/null


use var/stack/trap

unset -v _Msh_rK_buf
readkey() {


	unset -v _Msh_rKo_r _Msh_rKo_t _Msh_rKo_E
	while	case ${1-} in
		( -[!-]?* )
			_Msh_rKo__o=$1
			shift
			while _Msh_rKo__o=${_Msh_rKo__o#?} && not str empty "${_Msh_rKo__o}"; do
				_Msh_rKo__a=-${_Msh_rKo__o%"${_Msh_rKo__o#?}"}
				push _Msh_rKo__a
				case ${_Msh_rKo__o} in
				( [tE]* )
					_Msh_rKo__a=${_Msh_rKo__o#?}
					not str empty "${_Msh_rKo__a}" && push _Msh_rKo__a && break ;;
				esac
			done
			while pop _Msh_rKo__a; do
				set -- "${_Msh_rKo__a}" "$@"
			done
			unset -v _Msh_rKo__o _Msh_rKo__a
			continue ;;
		( -[r] )
			eval "_Msh_rKo_${1#-}=''" ;;
		( -[tE] )
			let "$# > 1" || die "readkey: $1: option requires argument"
			eval "_Msh_rKo_${1#-}=\$2"
			shift ;;
		( -- )	shift; break ;;
		( -* )	die "readkey: invalid option: $1" ;;
		( * )	break ;;
		esac
	do
		shift
	done



	if isset _Msh_rKo_t; then
		case ${_Msh_rKo_t} in
		( '' | *[!0123456789.]* | *. | *.*.* )
			die "readkey: -t: invalid timeout value: ${_Msh_rKo_t}" ;;
		( *.* )

			str match "${_Msh_rKo_t}" "*.??*" && _Msh_rKo_t=${_Msh_rKo_t%${_Msh_rKo_t##*.?}}
			_Msh_rKo_t=${_Msh_rKo_t%.?}${_Msh_rKo_t##*.} ;;
		( * )
			_Msh_rKo_t=${_Msh_rKo_t}0 ;;
		esac
	fi

	case $# in
	( 0 )	set REPLY ;;
	( 1 )	str isvarname "$1" || die "readkey: invalid variable name: $1" ;;
	( * )	die "readkey: excess arguments (expected 1)" ;;
	esac


	while not str empty "${_Msh_rK_buf-}"; do
		_Msh_readkey_getBufChar
		if not isset _Msh_rKo_E || str ematch "${_Msh_rK_c}" "${_Msh_rKo_E}"; then
			eval "$1=\${_Msh_rK_c}"
			unset -v _Msh_rKo_r _Msh_rKo_t _Msh_rKo_E_Msh_rK_s _Msh_rK_c
			return
		fi
	done


	is onterminal stdin || return 2
	_Msh_rK_s=$(unset -f stty; PATH=$DEFPATH exec stty -g) || die "readkey: save terminal state: stty failed"
	pushtrap '_Msh_readkey_setTerminalState' CONT
	pushtrap '_Msh_readkey_restoreTerminalState' DIE
	pushtrap '_Msh_readkey_restoreTerminalState' INT
	_Msh_readkey_setTerminalState
	forever do
		forever do
			_Msh_rK_buf=$(PATH=$DEFPATH command dd count=1 2>/dev/null && put X) \
				&& _Msh_rK_buf=${_Msh_rK_buf%X} && break
			let "$? <= 125" || die "readkey: 'dd' failed"
		done
		_Msh_readkey_getBufChar
		if not isset _Msh_rKo_E || str empty "${_Msh_rK_c}" || str ematch "${_Msh_rK_c}" "${_Msh_rKo_E}"; then
			break
		fi
	done
	_Msh_readkey_restoreTerminalState
	poptrap CONT DIE INT


	eval "$1=\${_Msh_rK_c}"
	unset -v _Msh_rKo_r _Msh_rKo_t _Msh_rKo_E_Msh_rK_s _Msh_rK_c
	eval "not str empty \"\${$1}\""
}

_Msh_readkey_setTerminalState() {
	set -- -icanon -echo -echonl -istrip -ixon -ixoff -iexten
	if isset _Msh_rKo_r; then
		set -- "$@" -isig nl
	fi
	if isset _Msh_rKo_t; then
		set -- "$@" min 0 time "${_Msh_rKo_t}"
	else
		set -- "$@" min 1
	fi
	PATH=$DEFPATH command stty "$@" || die "readkey: set terminal state: stty failed"
}

_Msh_readkey_restoreTerminalState() {
	PATH=$DEFPATH command stty "${_Msh_rK_s}" || die "readkey: restore terminal state: stty failed"
}

if thisshellhas WRN_MULTIBYTE; then


	_Msh_readkey_getBufChar() {
		if str match "${_Msh_rK_buf}" "[!$ASCIICHARS]*"; then
			_Msh_rK_c=$(unset -f sed; putln "${_Msh_rK_buf}X" | PATH=$DEFPATH exec sed '1 s/.//; ') \
			|| die "readkey: internal error: 'sed' failed"
			_Msh_rK_c=${_Msh_rK_c%X}
			_Msh_rK_c=${_Msh_rK_buf%"${_Msh_rK_c}"}
			_Msh_rK_buf=${_Msh_rK_buf#"${_Msh_rK_c}"}
		else
			_Msh_rK_c=${_Msh_rK_buf%"${_Msh_rK_buf#?}"}
			_Msh_rK_buf=${_Msh_rK_buf#?}
		fi
	}
else

	_Msh_readkey_getBufChar() {
		_Msh_rK_c=${_Msh_rK_buf%"${_Msh_rK_buf#?}"}
		_Msh_rK_buf=${_Msh_rK_buf#?}
	}
fi

if thisshellhas ROFUNC; then
	readonly -f readkey \
		_Msh_readkey_setTerminalState \
		_Msh_readkey_restoreTerminalState \
		_Msh_readkey_getBufChar
fi
