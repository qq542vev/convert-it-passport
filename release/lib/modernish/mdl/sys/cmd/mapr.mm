#! /module/for/moderni/sh
\command unalias mapr _Msh_mapr_ckE _Msh_mapr_doAwk 2>/dev/null


use sys/cmd/procsubst

_Msh_mapr_max=$(MSH_NOT_FOUND_OK=y; PATH=$DEFPATH command getconf ARG_MAX 2>/dev/null || putln 262144)
if not str isint "${_Msh_mapr_max}" || let "_Msh_mapr_max < 4096"; then
	putln "sys/cmd/mapr: failed to get ARG_MAX" >&2
	return 1
fi
let "_Msh_mapr_max -= (_Msh_mapr_max/8 > 2048 ? _Msh_mapr_max/8 : 2048)"
readonly _Msh_mapr_max

mapr() {


	unset -v _Msh_Mo_P _Msh_Mo_d _Msh_Mo_n _Msh_Mo_s _Msh_Mo_c _Msh_Mo_m
	while	case ${1-} in
		( -[!-]?* )
			_Msh_Mo__o=$1
			shift
			while _Msh_Mo__o=${_Msh_Mo__o#?} && not str empty "${_Msh_Mo__o}"; do
				_Msh_Mo__a=-${_Msh_Mo__o%"${_Msh_Mo__o#?}"}
				push _Msh_Mo__a
				case ${_Msh_Mo__o} in
				( [dnscm]* )
					_Msh_Mo__a=${_Msh_Mo__o#?}
					not str empty "${_Msh_Mo__a}" && push _Msh_Mo__a && break ;;
				esac
			done
			while pop _Msh_Mo__a; do
				set -- "${_Msh_Mo__a}" "$@"
			done
			unset -v _Msh_Mo__o _Msh_Mo__a
			continue ;;
		( -[P] )
			eval "_Msh_Mo_${1#-}=''" ;;
		( -[dnscm] )
			let "$# > 1" || die "mapr: $1: option requires argument"
			eval "_Msh_Mo_${1#-}=\$2"
			shift ;;
		( -- )	shift; break ;;
		( -* )	die "mapr: invalid option: $1" ;;
		( * )	break ;;
		esac
	do
		shift
	done




	if isset _Msh_Mo_P; then
		if isset _Msh_Mo_d; then
			die "mapr: -d and -P cannot be used together"
		fi

		_Msh_Mo_d=''
	elif isset _Msh_Mo_d; then
		if thisshellhas WRN_MULTIBYTE; then
			_Msh_M_dL=$( put "${_Msh_Mo_d}" | {
				PATH=$DEFPATH command wc -m || die "mapr: system error: 'wc' failed"
			} )
		else
			_Msh_M_dL=${#_Msh_Mo_d}
		fi
		if let "${_Msh_M_dL} != 1"; then
			die "mapr: -d: input record separator must be one character"
		fi
		unset -v _Msh_M_dL
	else
		_Msh_Mo_d=$CCn
	fi

	if isset _Msh_Mo_n; then
		if not str isint "${_Msh_Mo_n}" || let "_Msh_Mo_n < 0"; then
			die "mapr: -n: invalid number of records: ${_Msh_Mo_n}"
		fi
		_Msh_Mo_n=$((_Msh_Mo_n))
	else
		_Msh_Mo_n=0
	fi

	if isset _Msh_Mo_s; then
		if not str isint "${_Msh_Mo_s}" || let "_Msh_Mo_s < 0"; then
			die "mapr: -s: invalid number of records: ${_Msh_Mo_s}"
		fi
		_Msh_Mo_s=$((_Msh_Mo_s))
	else
		_Msh_Mo_s=0
	fi

	if isset _Msh_Mo_c; then
		if not str isint "${_Msh_Mo_c}" || let "_Msh_Mo_c < 0"; then
			die "mapr: -c: invalid number of records: ${_Msh_Mo_c}"
		fi
		_Msh_Mo_c=$((_Msh_Mo_c))
	else
		_Msh_Mo_c=0
	fi

	if isset _Msh_Mo_m; then
		if not str isint "${_Msh_Mo_m}" || let "_Msh_Mo_m < 0"; then
			die "mapr: -m: invalid number of bytes: ${_Msh_Mo_m}"
		fi
		_Msh_Mo_m=$((_Msh_Mo_m))
	else
		_Msh_Mo_m=0
	fi

	let "$# > 0" || die "mapr: callback command expected"
	not str begin "$1" _Msh_ || die "mapr: modernish internal namespace not supported for callback"



	unset -v _Msh_M_status
	while IFS= read -r _Msh_M_cmd <&8; do
		while str end "${_Msh_M_cmd}" '\'; do

			IFS= read -r _Msh_M_cmd2 <&8 || die "mapr: internal error: line continuation failure"
			_Msh_M_cmd=${_Msh_M_cmd}${CCn}${_Msh_M_cmd2}
			unset -v _Msh_M_cmd2
		done
		eval "${_Msh_M_cmd}" 8<&- || break
	done 8<$(% _Msh_mapr_doAwk "$@" 8<&0)


	isset _Msh_M_status || die "mapr: internal error: no exit status"
	eval "unset -v _Msh_Mo_P _Msh_Mo_d _Msh_Mo_n _Msh_Mo_s _Msh_Mo_c _Msh_Mo_m \
			_Msh_M_ifQuantum _Msh_M_checkMax _Msh_M_status _Msh_M_FIFO _Msh_M_i _Msh_M_cmd
		return ${_Msh_M_status}"
}

_Msh_mapr_doAwk() {
	export _Msh_Mo_d _Msh_Mo_s _Msh_Mo_n _Msh_Mo_c _Msh_Mo_m

	PATH=$DEFPATH POSIXLY_CORRECT=y LC_ALL=C _Msh_ARG_MAX=${_Msh_mapr_max} \
		command awk -f "$MSH_AUX/sys/cmd/mapr.awk" "$@" <&8 \
		|| let "$? < 126 || $? == SIGPIPESTATUS" || die "mapr: 'awk' failed"
}

_Msh_mapr_ckE() {
	_Msh_M_status=$?
	case ${_Msh_M_status} in
	( ? | ?? | 1[01]? | 12[012345] )
		;;
	( "$SIGPIPESTATUS" | 255 )
		return 1 ;;
	( * )	thisshellhas --sig=${_Msh_M_status} && die "mapr: callback killed by SIG$REPLY: $@"
		die "mapr: callback failed with status ${_Msh_M_status}: $@" ;;
	esac
}

if thisshellhas ROFUNC; then
	readonly -f mapr _Msh_mapr_ckE
fi
