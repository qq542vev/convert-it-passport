#! /module/for/moderni/sh
\command unalias poptrap pushtrap trap _Msh_POSIXtrap _Msh_clearAllTrapsIfFirstInSubshell _Msh_doINTtrap _Msh_doOneStackTrap _Msh_doOneStackTrap_noSub _Msh_doTraps _Msh_printSysTrap _Msh_setSysTrap 2>/dev/null


use _IN/sig
use var/shellquote
use var/stack/extra/stackempty


pushtrap() {
	unset -v _Msh_pushtrap_key _Msh_pushtrap_noSub
	while :; do
		case ${1-} in
		( -- )	shift; break ;;
		( --key=* )
			_Msh_pushtrap_key=${1#--key=} ;;
		( --nosubshell )
			_Msh_pushtrap_noSub= ;;
		( -* )	die "pushtrap: invalid option: $1" ;;
		( * )	break ;;
		esac
		shift
	done
	case $# in
	( 0|1 )	die "pushtrap: needs at least 2 non-option arguments" ;;
	esac
	case $1 in
	( *[!$WHITESPACE]* ) ;;
	( * )	die "pushtrap: empty command not supported" ;;
	esac
	case $1 in
	( *_Msh_doTraps\ * )
		die "pushtrap: cannot use internal modernish trap handler" ;;
	esac
	_Msh_pushtrapCMD=$1
	shift
	_Msh_sigs=''
	for _Msh_sig do
		_Msh_arg2sig || die "pushtrap: no such signal: ${_Msh_sig}"
		if isset _Msh_pushtrap_noSub && str eq "${_Msh_sig}" DIE; then
			die "pushtrap: --nosubshell cannot be used with DIE traps"
		fi
		_Msh_sigs=${_Msh_sigs}\ ${_Msh_sig}:${_Msh_sigv}
	done
	eval "set --${_Msh_sigs}"
	_Msh_clearAllTrapsIfFirstInSubshell
	for _Msh_sig do
		_Msh_sigv=${_Msh_sig##*:}
		_Msh_sig=${_Msh_sig%:*}
		unset -v "_Msh_trap${_Msh_sigv}_opt" "_Msh_trap${_Msh_sigv}_ifs" "_Msh_trap${_Msh_sigv}_noSub"
		eval "_Msh_trap${_Msh_sigv}=\${_Msh_pushtrapCMD}"
		if isset _Msh_pushtrap_noSub; then
			eval "_Msh_trap${_Msh_sigv}_noSub=''"
		else
			eval "_Msh_trap${_Msh_sigv}_opt=\$-"
			isset IFS && eval "_Msh_trap${_Msh_sigv}_ifs=\$IFS" || unset -v "_Msh_trap${_Msh_sigv}_ifs"
		fi
		push ${_Msh_pushtrap_key+"--key=$_Msh_pushtrap_key"} "_Msh_trap${_Msh_sigv}" \
			"_Msh_trap${_Msh_sigv}_opt" "_Msh_trap${_Msh_sigv}_ifs" "_Msh_trap${_Msh_sigv}_noSub"
		_Msh_setSysTrap "${_Msh_sig}" "${_Msh_sigv}"
		unset -v "_Msh_trap${_Msh_sigv}" "_Msh_trap${_Msh_sigv}_ifs" \
			"_Msh_trap${_Msh_sigv}_opt" "_Msh_trap${_Msh_sigv}_noSub"
	done
	unset -v _Msh_pushtrapCMD _Msh_pushtrap_key _Msh_pushtrap_noSub _Msh_sig _Msh_sigv _Msh_sigs
}


poptrap() {
	unset -v _Msh_poptrap_key _Msh_poptrap_R
	while :; do
		case ${1-} in
		( -- )	shift; break ;;
		( -R )	_Msh_poptrap_R='' ;;
		( --key=* )
			_Msh_poptrap_key=${1#--key=} ;;
		( -* )	die "poptrap: invalid option: $1" ;;
		( * )	break ;;
		esac
		shift
	done
	case $# in
	( 0 )	die "poptrap: needs at least 1 non-option argument" ;;
	esac
	_Msh_clearAllTrapsIfFirstInSubshell
	_Msh_sigs=''
	for _Msh_sig do
		_Msh_arg2sig || die "poptrap: no such signal: ${_Msh_sig}"
		if stackempty ${_Msh_poptrap_key+"--key=$_Msh_poptrap_key"} "_Msh_trap${_Msh_sigv}"; then
			unset -v _Msh_sig _Msh_sigv _Msh_sigs
			return 1
		fi
		_Msh_sigs=${_Msh_sigs}\ ${_Msh_sig}:${_Msh_sigv}
	done
	eval "set --${_Msh_sigs}"
	isset _Msh_poptrap_R && unset -v REPLY
	for _Msh_sig do
		_Msh_sigv=${_Msh_sig##*:}
		_Msh_sig=${_Msh_sig%:*}

		pop ${_Msh_poptrap_key+"--key=$_Msh_poptrap_key"} "_Msh_trap${_Msh_sigv}" \
			"_Msh_trap${_Msh_sigv}_opt" "_Msh_trap${_Msh_sigv}_ifs" "_Msh_trap${_Msh_sigv}_noSub" \
			|| die "poptrap: stack corrupted: ${_Msh_sig}"
		if isset _Msh_poptrap_R; then
			shellquote -f "_Msh_trap${_Msh_sigv}"
			eval "REPLY=\"\${REPLY+\$REPLY\$CCn}pushtrap" \
				"\${_Msh_poptrap_key+--key=\$_Msh_poptrap_key" \
				"}\${_Msh_trap${_Msh_sigv}_noSub+--nosubshell" \
				"}-- \${_Msh_trap${_Msh_sigv}} ${_Msh_sig}\""
		fi
		unset -v "_Msh_trap${_Msh_sigv}" "_Msh_trap${_Msh_sigv}_opt" \
			"_Msh_trap${_Msh_sigv}_ifs" "_Msh_trap${_Msh_sigv}_noSub"
		_Msh_setSysTrap "${_Msh_sig}" "${_Msh_sigv}"
	done
	unset -v _Msh_sig _Msh_sigv _Msh_sigs _Msh_poptrap_key _Msh_poptrap_R
}


_Msh_doTraps() {

	set -- "$1" "$2" "$?"

	case $1 in
	( CHLD ) command trap : CHLD ;;
	esac

	if ! stackempty --force "_Msh_trap${2}"; then
		_Msh_doTraps_i=$((_Msh__V_Msh_trap${2}__SP))
		while let '(_Msh_doTraps_i-=1) >= 0'; do
			if isset "_Msh__V_Msh_trap${2}_noSub__S${_Msh_doTraps_i}"; then
				_Msh_doOneStackTrap_noSub "${2}" "${_Msh_doTraps_i}" "${3}"
			else


				(_Msh_doOneStackTrap "${2}" "${_Msh_doTraps_i}" "${3}")
			fi
		done
		unset -v _Msh_doTraps_i
	fi
	case $1 in
	( CHLD ) _Msh_setSysTrap "$1" "$2" ;;
	esac

	if isset "_Msh_POSIXtrap${2}"; then
		eval "_Msh_PT=\${_Msh_POSIXtrap${2}}"
		return "$3"
	fi




	case $1 in
	( "$2" | ERR | ZERR ) return "$3" ;;
	( CHLD | CONT | URG ) return "$3" ;;
	( INFO | IO | PWR | WINCH ) return "$3" ;;
	( THR ) return "$3" ;;
	( CANCEL | FREEZE | JVM1 | JVM2 | LWP | THAW | WAITING | XRES )
		return "$3" ;;
	esac

	push REPLY
	insubshell -p && _Msh_sPID=$REPLY || unset -v _Msh_sPID
	pop REPLY


	case $1 in
	( TSTP | TTIN | TTOU )
		command kill -s STOP "${_Msh_sPID:-$$}"
		return "$3" ;;
	esac


	command trap - 0

	command trap - "$1"
	case $1 in
	( *[!0123456789]* )
		command kill -s "$1" "${_Msh_sPID:-$$}" ;;
	( * )	command kill "-$1" "${_Msh_sPID:-$$}" ;;
	esac


	thisshellhas BUG_TRAPUNSRE && return "$3"

	_Msh_setSysTrap "$1" "$2"
	_Msh_setSysTrap EXIT EXIT
	unset -v _Msh_sPID
	return "$3"
}

_Msh_fork=''
_Msh_reallyunsetIFS='unset -v IFS'
thisshellhas NONFORKSUBSH && _Msh_fork='command ulimit -t unlimited 2>/dev/null'
{ thisshellhas QRK_LOCALUNS || thisshellhas QRK_LOCALUNS2; } && _Msh_reallyunsetIFS='while isset IFS; do unset -v IFS; done'
eval '_Msh_doOneStackTrap() {
	'"${_Msh_fork}"'

	eval "_Msh_doTraps_o=\${_Msh__V_Msh_trap${1}_opt__S${2}}"
	case ${-},${_Msh_doTraps_o} in (*f*,*f*) ;; (*f*,*) set +f;; (*,*f*) set -f;; esac
	case ${-},${_Msh_doTraps_o} in (*u*,*u*) ;; (*u*,*) set +u;; (*,*u*) set -u;; esac
	case ${-},${_Msh_doTraps_o} in (*C*,*C*) ;; (*C*,*) set +C;; (*,*C*) set -C;; esac

	if isset "_Msh__V_Msh_trap${1}_ifs__S${2}"; then
		eval "IFS=\${_Msh__V_Msh_trap${1}_ifs__S${2}}"
	else
		'"${_Msh_reallyunsetIFS}"'
	fi

	eval "shift 3; setstatus $3; eval \" \${_Msh__V_Msh_trap${1}__S${2}}\"" && :
}'
unset -v _Msh_fork _Msh_reallyunsetIFS

_Msh_doOneStackTrap_noSub() {
	eval "shift 3; setstatus $3; eval \" \${_Msh__V_Msh_trap${1}__S${2}}\""
}


alias trap='_Msh_POSIXtrap'
_Msh_POSIXtrap() {
	if let "$# == 0" || str eq "${#},$1" '1,--' || str eq "$1" '-p' || str eq "$1" '--print'; then

		_Msh_pT_E=0
		unset -v _Msh_pT_s2p
		let "$#" && shift && while let "$#"; do
			if _Msh_arg2sig "$1"; then
				_Msh_pT_s2p="${_Msh_pT_s2p-} ${_Msh_sig}"
			else
				putln "trap (print): no such signal: ${_Msh_sig}" >&2
				_Msh_pT_E=1
			fi
			shift
		done


		unset -v _Msh_pT_done
		if thisshellhas TRAPPRSUBSH \
		&& ! { push REPLY; insubshell -u && ! str eq "$REPLY" "${_Msh_trap_subshID-}"; pop --keepstatus REPLY; }; then

			_Msh_trap=$(command trap) || die "trap: system error: builtin failed"
			command alias trap='_Msh_printSysTrap' \
			&& eval "${_Msh_trap}" \
			&& command alias trap='_Msh_POSIXtrap' || die "trap: internal error"
			unset -v _Msh_trap
		else

			_Msh_trapd=$(unset -v _Msh_D _Msh_i
				command umask 077
				until	_Msh_D=/tmp/_Msh_trapd.$$.${_Msh_i=${RANDOM:-0}}
					PATH=$DEFPATH command mkdir "${_Msh_D}" 2>/dev/null
				do	let "$? > 125" && _Msh_doExit 1 "trap: system error: 'mkdir' failed"
					is -L dir /tmp && can write /tmp \
						|| _Msh_doExit 1 "trap: system error: /tmp directory not writable"
					_Msh_i=$(( ${RANDOM:-_Msh_i + 1} ))
				done
				: > "${_Msh_D}/systraps" || exit 1
				put "${_Msh_D}"
			) || die "trap: internal error: can't create temporary directory"

			{	command trap || die "trap: system error: builtin failed"
			} >| "${_Msh_trapd}/systraps" || die "trap: system error: can't write to temp file"

			command alias trap='_Msh_printSysTrap' \
			&& . "${_Msh_trapd}/systraps" \
			&& command alias trap='_Msh_POSIXtrap' || die "trap: internal error"

			PATH=$DEFPATH command rm -rf "${_Msh_trapd}" &
			unset -v _Msh_trapd
		fi
		push REPLY
		if ! thisshellhas TRAPPRSUBSH && insubshell -u && ! str eq "$REPLY" "${_Msh_trap_subshID-}"; then

			_Msh_signum=-1
			while let "(_Msh_signum+=1)<128"; do
				_Msh_arg2sig "${_Msh_signum}" || continue
				case "|${_Msh_pT_done-}|" in (*"|${_Msh_sigv}|"*) continue;; esac
				_Msh_printSysTrap -- "_Msh_doTraps ${_Msh_sig} ${_Msh_sigv}" "${_Msh_sig}"
			done
		fi
		pop REPLY

		if _Msh_arg2sig ERR \
		&& { isset "_Msh_POSIXtrap${_Msh_sigv}" || ! stackempty --force "_Msh_trap${_Msh_sigv}"; } \
		&& ! str in "|${_Msh_pT_done-}|" "|${_Msh_sigv}|"; then
			_Msh_printSysTrap -- "_Msh_doTraps ERR ${_Msh_sigv}" ERR
		fi

		if isset _Msh_POSIXtrapDIE || ! stackempty --force _Msh_trapDIE; then
			_Msh_printSysTrap -- '_Msh_doTraps DIE DIE' DIE
		fi
		eval "unset -v _Msh_sig _Msh_sigv _Msh_signum _Msh_pT_done _Msh_pT_s2p _Msh_pT_E
		      return ${_Msh_pT_E}"
	elif let "$# == 1" && { str match "$1" '-[!-]*' || str match "$1" '--?*'; }; then

		command trap "$@"
		return
	fi

	_Msh_clearAllTrapsIfFirstInSubshell

	case $1 in
	( -- )	shift ;;
	esac

	case ${1-} in
	( '' | *[!0123456789]* ) ;;
	( * )
		set -- - "$@" ;;
	esac

	_Msh_trap_E=0
	if let "$# == 1" || str eq "$1" '-'; then

		if str eq "$1" '-'; then
			shift
			let "$#" || die 'trap (unset): at least one signal expected'
		fi
		for _Msh_sig do
			if _Msh_arg2sig; then
				unset -v "_Msh_POSIXtrap${_Msh_sigv}"
				_Msh_setSysTrap "${_Msh_sig}" "${_Msh_sigv}"
			else
				putln "trap (unset): no such signal: ${_Msh_sig}" >&2
				_Msh_trap_E=1
			fi
		done
	else

		let "$# > 1" || die "trap (set): at least one signal expected"
		not str in "$1" '_Msh_doTraps ' || die "trap (set): cannot use internal modernish trap handler"
		_Msh_trap_CMD=$1
		shift
		for _Msh_sig do
			if _Msh_arg2sig; then
				eval "_Msh_POSIXtrap${_Msh_sigv}=\${_Msh_trap_CMD}"
				_Msh_setSysTrap "${_Msh_sig}" "${_Msh_sigv}"
			else
				putln "trap (set): no such signal: ${_Msh_sig}" >&2
				_Msh_trap_E=1
			fi
		done
	fi
	eval "unset -v _Msh_sig _Msh_sigv _Msh_trap_CMD _Msh_trap_E; return ${_Msh_trap_E}"
}


_Msh_printSysTrap() {
	case ${#},${1-} in
	(2,--)	if thisshellhas BUG_TRAPEMPT "--sig=$2"; then

			set -- "$1" "" "$2"
		fi ;;
	esac
	case ${#},${1-} in
	( 3,-- ) ;;
	( * )	die "trap: internal error: unexpected output of system 'trap' command" ;;
	esac
	case "${_Msh_pT_s2p+s}, ${_Msh_pT_s2p-} " in
	( ,* | s,*" $3 "* ) ;;
	( * )	return ;;
	esac
	case $2 in
	( "_Msh_doTraps "* )

		_Msh_sig=${2#_Msh_doTraps }
		_Msh_sigv=${_Msh_sig#* }
		_Msh_sigv=${_Msh_sigv%%[ ;${CCn}]*}
		_Msh_sig=${_Msh_sig%% *}
		if isset "_Msh__V_Msh_trap${_Msh_sigv}__SP"; then

			_Msh_pT_i=-1
			while let "(_Msh_pT_i+=1) < _Msh__V_Msh_trap${_Msh_sigv}__SP"; do
				eval "_Msh_pT_cmd=\${_Msh__V_Msh_trap${_Msh_sigv}__S${_Msh_pT_i}}"
				shellquote -f _Msh_pT_cmd
				if isset "_Msh__V_Msh_trap${_Msh_sigv}__K${_Msh_pT_i}"; then
					eval "_Msh_pT_key=\${_Msh__V_Msh_trap${_Msh_sigv}__K${_Msh_pT_i}}"
					shellquote _Msh_pT_key
				else
					unset -v _Msh_pT_key
				fi
				if isset "_Msh__V_Msh_trap${_Msh_sigv}_noSub__S${_Msh_pT_i}"; then
					_Msh_pT_noSub=
				else
					unset -v _Msh_pT_noSub
				fi
				put 'pushtrap' \
					${_Msh_pT_key+"--key=$_Msh_pT_key"} \
					${_Msh_pT_noSub+"--nosubshell"} \
					"-- ${_Msh_pT_cmd} ${_Msh_sig}${CCn}"
			done
			unset -v _Msh_pT_i
		fi
		if isset "_Msh_POSIXtrap${_Msh_sigv}"; then

			eval "_Msh_pT_cmd=\${_Msh_POSIXtrap${_Msh_sigv}}"
			shellquote -f _Msh_pT_cmd
			putln "trap -- ${_Msh_pT_cmd} ${_Msh_sig}"
		fi ;;
	( '' )
		_Msh_arg2sig "$3" || die "trap: internal error: invalid trap name: ${_Msh_sig}"
		eval "_Msh_POSIXtrap${_Msh_sigv}="
		putln "trap -- '' ${_Msh_sig}" ;;
	( * )
		_Msh_arg2sig "$3" || die "trap: internal error: invalid trap name: ${_Msh_sig}"

		eval "_Msh_POSIXtrap${_Msh_sigv}=\$2"
		_Msh_setSysTrap "${_Msh_sig}" "${_Msh_sigv}"
		shellquote -f _Msh_pT_cmd="$2"
		putln "trap -- ${_Msh_pT_cmd} ${_Msh_sig}" ;;
	esac
	_Msh_pT_done=${_Msh_pT_done-}${_Msh_pT_done:+\|}${_Msh_sigv}
	unset -v _Msh_pT_cmd _Msh_pT_key _Msh_pT_noSub _Msh_sig _Msh_sigv
}


_Msh_setSysTrap() {
	case $1 in
	(DIE)	return ;;
	esac
	if ! isset "_Msh_POSIXtrap$2" && stackempty --force "_Msh_trap$2"; then
		_Msh_sST_A='-'
	elif eval "str empty \"\${_Msh_POSIXtrap$2-U}\"" && stackempty --force "_Msh_trap$2"; then
		_Msh_sST_A=''
	else
		case $1 in
		(ERR | ZERR)

			_Msh_sST_A="_Msh_doTraps $1 $2 && :; eval \"\${_Msh_PT+unset _Msh_PT;\${_Msh_PT}}\" && :"
			if isset BASH_VERSION; then

				_Msh_sST_A="${_Msh_sST_A}; case \${_Msh_POSIXtrapERR+s}\${_Msh__V_Msh_trapERR__SP+s} in "
				_Msh_sST_A="${_Msh_sST_A}('') command trap - ERR;; esac"
			fi ;;
		( * )	_Msh_sST_A="_Msh_doTraps $1 $2; eval \"\${_Msh_PT+unset _Msh_PT;\${_Msh_PT}}\"" ;;
		esac
		case $1 in
		( RETURN )
			thisshellhas BUG_TRAPRETIR && set +o functrace ;;
		esac
	fi
	case $1 in
	(EXIT)	command trap "${_Msh_sST_A}" 0 ;;
	( * )	command trap "${_Msh_sST_A}" "$1" ;;
	esac || die "internal error: the 'trap' builtin failed"
	unset -v _Msh_sST_A
}


unset -v _Msh_trap_subshID
if thisshellhas VARPREFIX; then
	_Msh_unset='for _Msh_trap_v in "${!_Msh_POSIXtrap@}" "${!_Msh__V_Msh_trap@}"; do
		case ${_Msh_trap_v} in
			( _Msh_POSIXtrapDIE | _Msh__V_Msh_trapDIE_* )
				;;
			( * )	command unset -v "${_Msh_trap_v}" || die "internal error: clear all traps: unset failed" ;;
			esac
		done'
else
	if thisshellhas BUG_SETOUTVAR && (set +o posix && command typeset -g) >/dev/null 2>&1; then

		_Msh_set='(command set +o posix; command typeset -g | exec sed "s/^typeset -[a-z][a-z]* //; s/^typeset //")'
	else
		_Msh_set='set'
	fi
	_Msh_unset='# The "sed" incantation below could yield false positives due to newlines in variable values, but only

		_Msh_trap=$(
			export PATH=$DEFPATH LC_ALL=C
			unset -f sed
			'"${_Msh_set}"' | exec sed -n "\
				/^_Msh_POSIXtrapDIE=/ d
				/^_Msh__V_Msh_trapDIE_[a-zA-Z0-9_]*=/ d
				/^_Msh_POSIXtrap[A-Z0-9_][A-Z0-9_]*=/ s/=.*//p
				/^_Msh__V_Msh_trap[A-Z0-9_][a-zA-Z0-9_]*=/ s/=.*//p"
		) || die "internal error: clear all traps: sed failed"
		push IFS
		IFS=$CCn
		command unset -v ${_Msh_trap} _Msh_trap
		pop --keepstatus IFS || die "internal error: clear all traps: unset failed"'
	unset -v _Msh_set
fi
eval '_Msh_clearAllTrapsIfFirstInSubshell() {
	push REPLY
	insubshell -u
	if str ne "$REPLY" "${_Msh_trap_subshID-}"; then

		_Msh_trap_subshID=$REPLY
		pop REPLY

		'"${_Msh_unset}"'
	else
		pop REPLY
	fi
}'
unset -v _Msh_unset



_Msh_clearAllTrapsIfFirstInSubshell

eval 'trap >/dev/null'


if thisshellhas ROFUNC; then
	readonly -f poptrap pushtrap \
		_Msh_POSIXtrap _Msh_clearAllTrapsIfFirstInSubshell \
		_Msh_doOneStackTrap _Msh_doOneStackTrap_noSub _Msh_doTraps \
		_Msh_printSysTrap _Msh_setSysTrap
fi
