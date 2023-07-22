#! /module/for/moderni/sh
\command unalias harden trace _Msh_harden_traceInit 2>/dev/null


use sys/cmd/extern
use var/shellquote

unset -v _Msh_Ht_R _Msh_Ht_y _Msh_Ht_r _Msh_Ht_b
unset -v _Msh_H_C
harden() {
	_Msh_H_C=${_Msh_H_C-harden}

	unset -v _Msh_Ho_P _Msh_Ho_t _Msh_Ho_c _Msh_Ho_S _Msh_Ho_X _Msh_Ho_e _Msh_Ho_f _Msh_Ho_u _Msh_H_VA
	_Msh_Ho_p=0
	while	case ${1-} in
		( [!-]*=* )
			str isvarname "${1%%=*}" || break
			isset -r "${1%%=*}" && die "${_Msh_H_C}: read-only variable: ${1%%=*}"
			shellquote _Msh_H_QV="${1#*=}"
			_Msh_H_VA=${_Msh_H_VA:+$_Msh_H_VA }${1%%=*}=${_Msh_H_QV}
			unset -v _Msh_H_QV ;;
		( -[!-]?* )
			_Msh_Ho__o=$1
			shift
			while _Msh_Ho__o=${_Msh_Ho__o#?} && not str empty "${_Msh_Ho__o}"; do
				_Msh_Ho__a=-${_Msh_Ho__o%"${_Msh_Ho__o#?}"}
				push _Msh_Ho__a
				case ${_Msh_Ho__o} in
				( [euf]* )
					_Msh_Ho__a=${_Msh_Ho__o#?}
					not str empty "${_Msh_Ho__a}" && push _Msh_Ho__a && break ;;
				esac
			done
			while pop _Msh_Ho__a; do
				set -- "${_Msh_Ho__a}" "$@"
			done
			unset -v _Msh_Ho__o _Msh_Ho__a
			continue ;;
		( -[cSXtPE] )
			eval "_Msh_Ho_${1#-}=''" ;;
		( -p )	let "_Msh_Ho_p += 1" ;;
		( -[ef] )
			let "$# > 1" || die "${_Msh_H_C}: $1: option requires argument"
			eval "_Msh_Ho_${1#-}=\$2"
			shift ;;
		( -u )	let "$# > 1" || die "${_Msh_H_C}: $1: option requires argument"
			str isvarname "$2" || die "${_Msh_H_C} -u: invalid variable name: $2"
			_Msh_Ho_u=${_Msh_Ho_u:+$_Msh_Ho_u }$2
			shift ;;
		( -- )	shift; break ;;
		( -* )	die "${_Msh_H_C}: invalid option: $1" ;;
		( * )	break ;;
		esac
	do
		shift
	done


	case $# in
	( 0 )	die "${_Msh_H_C}: command expected${CCn}" \
			"usage: harden [ -f <funcname> ] [ -[cSpXtPE] ] [ -e <testexpr> ] \\${CCn}" \
			"${CCt}[ <var=value> ... ] [ -u <var> ... ] <cmdname/path> [ <arg> ... ]" ;;
	esac

	if isset _Msh_Ho_S && ! isset _Msh_Ho_f; then
		die "harden: -S requires -f"
	fi

	if isset _Msh_Ho_c; then
		if isset _Msh_Ho_f; then
			die "harden: -c cannot be used with -f"
		fi
		_Msh_Ho_f="_Msh_harden_tmp"
	elif ! isset _Msh_Ho_f; then
		_Msh_Ho_f=$1
	fi


	push IFS -f PATH
	let "_Msh_Ho_p > 0" && PATH=$DEFPATH
	set -f
	IFS=${_Msh_Ho_S+,}
	for _Msh_H_cmd in $1; do
		not isset _Msh_Ho_X && thisshellhas "--bi=${_Msh_H_cmd}" && break
		_Msh_H_cmd=$(extern -v -- "${_Msh_H_cmd}") && break
	done
	pop IFS -f PATH
	case ${_Msh_H_cmd} in
	( '' )	if let "_Msh_Ho_p > 0"; then
			die "${_Msh_H_C}: ${_Msh_Ho_X+external }command${_Msh_Ho_S+s} not found in system default path: '$1'"
		else
			die "${_Msh_H_C}: ${_Msh_Ho_X+external }command${_Msh_Ho_S+s} not found: '$1'"
		fi ;;
	esac
	case ${_Msh_Ho_f} in
	(\!|\{|\}|case|do|done|elif|else|\esac|fi|for|if|in|then|until|while \
	|break|:|continue|.|eval|exec|exit|export|readonly|return|set|shift|times|trap|unset)
		die "${_Msh_H_C}: can't harden POSIX reserved word or special builtin '${_Msh_Ho_f}'" ;;
	( command | getopts | read )
		die "${_Msh_H_C}: can't harden the '${_Msh_Ho_f}' builtin" ;;
	( '' | [0123456789]* | *[!"$ASCIIALNUM"_]* )
		die "${_Msh_H_C}: invalid shell function name: ${_Msh_Ho_f}"
		;;
	esac
	if thisshellhas "--rw=${_Msh_Ho_f}"; then
		die "${_Msh_H_C}: can't harden reserved word '${_Msh_Ho_f}'"
	elif command alias "${_Msh_Ho_f}" >/dev/null 2>&1; then
		die "${_Msh_H_C}: function name '${_Msh_Ho_f}' conflicts with alias '${_Msh_Ho_f}'"
	elif ! isset _Msh_Ho_c; then
		if isset -f "${_Msh_Ho_f}"; then
			die "${_Msh_H_C}: shell function already exists: ${_Msh_Ho_f}"
		fi
		if thisshellhas "--bi=${_Msh_Ho_f}"; then

			(eval "${_Msh_Ho_f}() { :; }") 2>/dev/null || die "${_Msh_H_C}: can't harden '${_Msh_Ho_f}'"
		fi
	fi



	case ${_Msh_H_cmd} in
	( */* )	case ${_Msh_H_cmd} in
		( /* )  ;;
		( * )
			_Msh_E=$(chdir -f -- "${_Msh_H_cmd%/*}" &&
				command pwd &&
				put X) || die "${_Msh_H_C}: internal error"
			_Msh_H_cmd=${_Msh_E%${CCn}X}/${_Msh_H_cmd##*/} ;;
		esac
		shellquote _Msh_H_cmd
		if isset _Msh_Ho_u || isset _Msh_Ho_E; then

			_Msh_H_cmd="exec ${_Msh_H_cmd}"
		fi

		if let "_Msh_Ho_p > 1"; then
			_Msh_H_VA=${_Msh_H_VA:+$_Msh_H_VA }PATH=\"\$DEFPATH\"
		fi ;;
	( * )	if command alias "${_Msh_H_cmd}" >/dev/null 2>&1; then

			die "${_Msh_H_C}: aliases are not supported: ${_Msh_H_cmd}"
		elif thisshellhas "--rw=${_Msh_H_cmd}"; then
			die "${_Msh_H_C}: can't harden reserved word '${_Msh_H_cmd}'"
		elif	push PATH
			let "_Msh_Ho_p > 0" && PATH=$DEFPATH
			thisshellhas "--bi=${_Msh_H_cmd}"
			pop --keepstatus PATH
		then
			_Msh_H_cmd2=$(
				unset -f "${_Msh_H_cmd}" 1>&1 &&
				let "_Msh_Ho_p > 0" && PATH=$DEFPATH
				command -v "${_Msh_H_cmd}")
			case ${_Msh_H_cmd2} in
			( '' )	die "${_Msh_H_C}: builtin not found: ${_Msh_H_cmd}" ;;
			( /* )
				_Msh_H_cmdP=${_Msh_H_cmd2%/*}
				case ${_Msh_H_cmdP} in ( '' ) _Msh_H_cmdP=/ ;; esac
				_Msh_H_cmd2=${_Msh_H_cmd2##*/}
				case ${_Msh_H_cmd2} in ( '' ) die "${_Msh_H_C}: internal error" ;; esac
				shellquote _Msh_H_cmdP
				_Msh_H_VA=${_Msh_H_VA:+$_Msh_H_VA }PATH=${_Msh_H_cmdP}
				unset -v _Msh_H_cmdP ;;
			esac
			case ${_Msh_H_cmd2} in
			( -* )	shellquote _Msh_H_cmd2; _Msh_H_cmd="command -- ${_Msh_H_cmd2}" ;;
			( * )	shellquote _Msh_H_cmd2; _Msh_H_cmd="command ${_Msh_H_cmd2}" ;;
			esac
			unset -v _Msh_H_cmd2
		elif isset -f "${_Msh_H_cmd}"; then

			if _Msh_H_cmd2=$(
				let "_Msh_Ho_p > 0" && PATH=$DEFPATH
				extern -v "${_Msh_H_cmd}")
			then
				_Msh_H_cmd=${_Msh_H_cmd2}
				unset -v _Msh_H_cmd2
			else
				die "${_Msh_H_C}: hardening shell functions is not supported: ${_Msh_H_cmd}"
			fi
		else
			die "${_Msh_H_C}: internal error"
		fi ;;
	esac


	shift
	for _Msh_E do
		shellquote _Msh_E
		_Msh_H_cmd=${_Msh_H_cmd}\ ${_Msh_E}
	done


	if isset _Msh_Ho_t; then
		_Msh_harden_traceInit
	fi


	_Msh_H_spp='_Msh_P=
		for _Msh_A in '"${_Msh_H_cmd}"' "$@"; do
			\shellquote _Msh_A
			\let "${#_Msh_P} + ${#_Msh_A} >= 512" && _Msh_P="${_Msh_P} (TRUNCATED)" && \break
			_Msh_P=${_Msh_P}${_Msh_P:+" "}${_Msh_A}
		done
		\unset -v _Msh_A'


	_Msh_H_cmd=${_Msh_H_cmd}' "$@"'


	if isset _Msh_Ho_u || isset _Msh_Ho_E; then

		_Msh_E=${_Msh_Ho_u:+unset -v $_Msh_Ho_u; }${_Msh_H_VA:+export $_Msh_H_VA; }
		if isset _Msh_Ho_E; then

			_Msh_H_cmd="{ _Msh_e=\$(set +x; ${_Msh_E}${_Msh_H_cmd} 2>&1 1>&9); } 9>&1 && case \${_Msh_e} in (?*) ! : ;; esac"
			_Msh_Ho_E="case \${_Msh_e} in (?*) die \"${_Msh_Ho_f}: command wrote error: \${_Msh_P}\${CCn}\${_Msh_e}\" ;; esac"
		else
			_Msh_H_cmd="( ${_Msh_E}${_Msh_H_cmd} )"
		fi

		shellquote _Msh_E="( ${_Msh_E}"
		_Msh_H_spp="${_Msh_H_spp} && _Msh_P=${_Msh_E}\${_Msh_P}' )'"
	elif isset _Msh_H_VA; then


		_Msh_E="${_Msh_H_VA} "
		_Msh_H_cmd="${_Msh_E}${_Msh_H_cmd}"

		shellquote _Msh_E
		_Msh_H_spp="${_Msh_H_spp} && _Msh_P=${_Msh_E}\${_Msh_P}"
	fi


	if	case ${_Msh_Ho_e='>0'} in
		( '>0' | '> 0' | '>=1' | '>= 1' | '!=0' | '!= 0' ) ;;
		( * ) ! : ;;
		esac &&
		! isset _Msh_Ho_P
	then
		if isset _Msh_Ho_t; then
			eval "${_Msh_Ho_f}() {
				${_Msh_H_spp}
				${_Msh_Ho_t}
				${_Msh_H_cmd} && unset -v _Msh_P${_Msh_Ho_E+ _Msh_e} || {
					_Msh_E=\$?
					if let \"\${_Msh_E} > 128\" && thisshellhas --sig=\"\${_Msh_E}\"; then
						_Msh_P=\"killed by SIG\$REPLY: \${_Msh_P}\"
					fi
					${_Msh_Ho_E-}
					die \"${_Msh_Ho_c-${_Msh_Ho_f}: }failed with status \${_Msh_E}: \${_Msh_P}\"
					eval \"unset -v _Msh_P _Msh_E${_Msh_Ho_E+ _Msh_e}; return \${_Msh_E}\"
				}
			}${CCn}"
		else
			eval "${_Msh_Ho_f}() {
				${_Msh_H_cmd}${_Msh_Ho_E+ && unset -v _Msh_e} || {
					_Msh_E=\$?
					${_Msh_H_spp}
					if let \"\${_Msh_E} > 128\" && thisshellhas --sig=\"\${_Msh_E}\"; then
						_Msh_P=\"killed by SIG\$REPLY: \${_Msh_P}\"
					fi
					${_Msh_Ho_E-}
					die \"${_Msh_Ho_c-${_Msh_Ho_f}: }failed with status \${_Msh_E}: \${_Msh_P}\"
					eval \"unset -v _Msh_P _Msh_E${_Msh_Ho_E+ _Msh_e}; return \${_Msh_E}\"
				}
			}${CCn}"
		fi
	else

		case ${_Msh_Ho_e} in
		( =[!=]* | *[!!\<\>=]=[!=]* | *[%*/+-]=* | *--* | *++* )
			die "${_Msh_H_C}: assignment not allowed in status expression: '${_Msh_Ho_e}'" ;;
		( *[=\<\>]* ) ;;
		( * )	die "${_Msh_H_C}: unary comparison operator required in status expression: '${_Msh_Ho_e}'" ;;
		esac
		_Msh_H_expr=${_Msh_Ho_e}
		for _Msh_H_c in '<' '>' '==' '!='; do



			_Msh_H_nwex=${_Msh_H_expr}
			_Msh_H_expr=
			while str in "${_Msh_H_nwex}" "${_Msh_H_c}"; do
				_Msh_H_expr=${_Msh_H_expr}${_Msh_H_nwex%%"${_Msh_H_c}"*}\(_Msh_E\)${_Msh_H_c}
				_Msh_H_nwex=${_Msh_H_nwex#*"${_Msh_H_c}"}
			done
			_Msh_H_expr=${_Msh_H_expr}${_Msh_H_nwex}
		done
		unset -v _Msh_H_nwex _Msh_H_c
		if isset _Msh_Ho_P; then
			_Msh_H_expr="(${_Msh_H_expr}) && _Msh_E!=$SIGPIPESTATUS"
		fi
		_Msh_E=0
		( : "$((${_Msh_H_expr}))" ) 2>/dev/null || die "${_Msh_H_C}: invalid status expression: '${_Msh_Ho_e}'"
		let "${_Msh_H_expr}" && die "${_Msh_H_C}: success means failure in status expression: ${_Msh_Ho_e}"


		isset _Msh_Ho_E && _Msh_H_expr=\(${_Msh_H_expr}') || ${#_Msh_e}>0'
		_Msh_H_expr=\"${_Msh_H_expr}\"
		if isset _Msh_Ho_t; then
			eval "${_Msh_Ho_f}() {
				${_Msh_H_spp}
				${_Msh_Ho_t}
				${_Msh_H_cmd} && unset -v _Msh_P${_Msh_Ho_E+ _Msh_e} || {
					_Msh_E=\$?
					if let ${_Msh_H_expr}; then
						if let \"\${_Msh_E} > 128\" && thisshellhas --sig=\"\${_Msh_E}\"; then
							_Msh_P=\"killed by SIG\$REPLY: \${_Msh_P}\"
						fi
						${_Msh_Ho_E-}
						die \"${_Msh_Ho_c-${_Msh_Ho_f}: }failed with status \${_Msh_E}: \${_Msh_P}\"
					fi
					eval \"unset -v _Msh_P _Msh_E${_Msh_Ho_E+ _Msh_e}; return \${_Msh_E}\"
				}
			}${CCn}"
		else
			eval "${_Msh_Ho_f}() {
				${_Msh_H_cmd}${_Msh_Ho_E+ && unset -v _Msh_e} || {
					_Msh_E=\$?
					if let ${_Msh_H_expr}; then
						${_Msh_H_spp}
						if let \"\${_Msh_E} > 128\" && thisshellhas --sig=\"\${_Msh_E}\"; then
							_Msh_P=\"killed by SIG\$REPLY: \${_Msh_P}\"
						fi
						${_Msh_Ho_E-}
						die \"${_Msh_Ho_c-${_Msh_Ho_f}: }failed with status \${_Msh_E}: \${_Msh_P}\"
					fi
					eval \"unset -v _Msh_P _Msh_E${_Msh_Ho_E+ _Msh_e}; return \${_Msh_E}\"
				}
			}${CCn}"
		fi
	fi || die "${_Msh_H_C}: fn def failed"

	eval "unset -v _Msh_Ho_c _Msh_Ho_S _Msh_Ho_X _Msh_Ho_e _Msh_Ho_f _Msh_Ho_p _Msh_Ho_t _Msh_Ho_u _Msh_Ho_E \
			_Msh_H_VA _Msh_E _Msh_H_C _Msh_H_cmd _Msh_H_expr _Msh_H_spp
		${_Msh_Ho_c+_Msh_harden_tmp}"
}

trace() {
	case $# in
	( 0 )	die "trace: command expected${CCn}" \
			"usage: trace [ -f <funcname> ] [ -[cSpXE] ] \\${CCn}" \
			"${CCt}[ <var=value> ... ] [ -u <var> ... ] <cmdname/path> [ <arg> ... ]" ;;
	esac
	if let "$# == 2" && str eq "$1" '-f'; then

		not command alias "$2" >/dev/null 2>&1 || die "trace: alias '$2' already exists"
		unset -v _Msh_Ho_c
		_Msh_Ho_f="$2()"
		_Msh_harden_traceInit

		eval '_Msh_trace_'"$2"'() {
			_Msh_P='"$2"'
			for _Msh_A do
				\shellquote _Msh_A
				\let "${#_Msh_P} + ${#_Msh_A} >= 512" && _Msh_P="${_Msh_P} (TRUNCATED)" && \break
				_Msh_P=${_Msh_P}${_Msh_P:+" "}${_Msh_A}
			done
			'"${_Msh_Ho_t}"'
			\unset -v _Msh_A _Msh_P
			\isset -f '"$2"' || \die "trace: function not found: '"$2"'" || \return
			\'"$2"' "$@"
		}' || die "trace: fn def failed"
		unset -v _Msh_Ho_t _Msh_Ho_f
		command alias "$2=_Msh_trace_$2" || die "trace: alias failed"
	else

		_Msh_H_C=trace
		harden -t -P -e '>125 && !=128 && !=255' "$@"
	fi
}


_Msh_harden_traceInit() {
	{ command : >&9; } 2>/dev/null || exec 9>&2
	if ! isset _Msh_Ht_R && is onterminal 9; then
		if _Msh_Ht_R=$(PATH=$DEFPATH command tput sgr0); then
			_Msh_Ht_y=${_Msh_Ht_R}$(PATH=$DEFPATH; command tput setaf 3 || command tput dim)
			_Msh_Ht_r=${_Msh_Ht_R}$(PATH=$DEFPATH; command tput setaf 1 || command tput smul)
			_Msh_Ht_b=${_Msh_Ht_R}$(PATH=$DEFPATH; command tput setaf 4; command tput bold)
		else
			_Msh_Ht_R=''
		fi
	fi 2>/dev/null
	if is onterminal 9 && ! str empty "${_Msh_Ht_R}"; then

		_Msh_Ho_t="\\putln \"\${_Msh_Ht_y}[\${_Msh_Ht_r}"
		isset _Msh_Ho_c && _Msh_Ho_t=${_Msh_Ho_t}${_Msh_H_C} || _Msh_Ho_t=${_Msh_Ho_t}${_Msh_Ho_f}
		_Msh_Ho_t="${_Msh_Ho_t}\${_Msh_Ht_y}]> \${_Msh_Ht_b}\${_Msh_P}\${_Msh_Ht_R}\" 1>&9"
	else
		_Msh_Ho_t="\\putln \"["
		isset _Msh_Ho_c && _Msh_Ho_t=${_Msh_Ho_t}${_Msh_H_C} || _Msh_Ho_t=${_Msh_Ho_t}${_Msh_Ho_f}
		_Msh_Ho_t="${_Msh_Ho_t}]> \${_Msh_P}\" 1>&9"
	fi
}


if thisshellhas ROFUNC; then
	readonly -f harden trace _Msh_harden_traceInit
fi
