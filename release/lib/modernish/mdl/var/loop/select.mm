#! /module/for/moderni/sh
\command unalias _loop_select_getReply _loop_select_printMenu _loopgen_select 2>/dev/null

use var/loop

_loopgen_select() {
	unset -v _loop_split _loop_glob _loop_base _loop_slice
	while	case ${1-} in
		( -- )		shift; break ;;
		( --split )	_loop_split= ;;
		( --split= )	unset -v _loop_split ;;
		( --split=* )	_loop_split=${1#--split=} ;;
		( --glob )	_loop_glob= ;;
		( --fglob )	_loop_glob=f ;;
		( --base )	_loop_die "option requires argument: $1" ;;
		( --base=* )	_loop_base=${1#--base=} ;;
		( --slice )	_loop_slice=1 ;;
		( --slice=* )	_loop_slice=${1#--slice=} ;;
		( -* )		_loop_die "unknown option: $1" ;;
		( * )		break ;;
		esac
	do
		shift
	done
	if isset _loop_slice; then
		if not str isint ${_loop_slice} || let "_loop_slice <= 0"; then
			_loop_die "--slice: invalid number of characters: ${_loop_slice}"
		fi
		_loop_pat=''
		while let "${#_loop_pat} < _loop_slice"; do
			_loop_pat=${_loop_pat}\?
		done
	fi
	if isset _loop_base; then
		case ${_loop_glob-UNS} in
		( UNS )	;;
		( f )	chdir -f -- "${_loop_base}" || { shellquote -f _loop_base; _loop_die "could not enter base dir: ${_loop_base}"; }
			not str end ${_loop_base} '/' && _loop_base=${_loop_base}/ ;;
		( * )	chdir -f -- "${_loop_base}" 2>/dev/null || { putln '! _loop_E=98' >&8; exit; }
			not str end ${_loop_base} '/' && _loop_base=${_loop_base}/ ;;
		esac
	fi
	_loop_checkvarname $1
	if isset _loop_split || isset _loop_glob; then
		put >&8 'if ! isset -f || ! isset IFS || ! str empty "$IFS"; then' \
				"die 'LOOP ${_loop_type}:" \
					"${_loop_split+--split }${_loop_glob+--${_loop_glob}glob }without safe mode';" \
			'fi; '
	fi
	_loop_V=$1
	shift 2
	_loop_args=''
	_loop_i=0
	for _loop_A do
		case ${_loop_glob+s} in
		( s )	set +f ;;
		esac
		case ${_loop_split+s},${_loop_split-} in
		( s, )	_loop_reallyunsetIFS ;;
		( s,* )	IFS=${_loop_split} ;;
		esac

		set -- ${_loop_A}


		IFS=''
		set -f

		for _loop_AA do
			case ${_loop_glob-NO} in
			( '' )	is present "${_loop_AA}" || continue ;;
			( f )	if not is present "${_loop_AA}"; then
					shellquote -f _loop_AA
					_loop_die "--fglob: no match: ${_loop_AA}"
				fi ;;
			esac
			case ${_loop_base+B} in
			( B )	_loop_AA=${_loop_base}${_loop_AA} ;;
			esac
			case ${_loop_glob+G},${_loop_AA} in
			( G,-* | G,+* | G,\( | G,\! )

				_loop_AA=./${_loop_AA} ;;
			esac
			case ${_loop_slice+S} in
			( S )	while let "${#_loop_AA} > _loop_slice"; do
					_loop_rest=${_loop_AA#$_loop_pat}
					shellquote _loop_A=${_loop_AA%"${_loop_rest}"}
					_loop_args="${_loop_args} ${_loop_A}"
					_loop_AA=${_loop_rest}
				done ;;
			esac
			shellquote _loop_A=${_loop_AA}
			_loop_args="${_loop_args} ${_loop_A}"
		done
		if let "$# == 0" && not str empty "${_loop_glob-NO}"; then


			str eq "${_loop_glob-NO}" f && _loop_die "--fglob: empty pattern"
			_loop_args="${_loop_args} ''"
		fi
	done
	case ${_loop_args},${_loop_glob-NO} in
	( , )	putln '! _loop_E=103' >&8; exit ;;
	( ,f )	_loop_die "--fglob: no patterns" ;;
	( ,* )	exit ;;
	esac


	put "REPLY=''; " >&8 || die "LOOP select: can't put init"
	insubshell -p && _loop_mypid=$REPLY || die "LOOP select: failed to get my PID"
	forever do
		put "_loop_select_getReply ${_loop_V} ${_loop_mypid} ${_loop_args} || ! _loop_E=1${CCn}" || exit
		command kill -s STOP ${_loop_mypid} || die "LOOP select: SIGSTOP failed"
	done >&8 || die "LOOP select: can't write iterations"
}


_loop_select_getReply() {
	let "$# > 2" || return
	_loop_V=$1
	_loop_pid=$2
	shift 2

	if str empty "${REPLY-}"; then
		_loop_select_printMenu "$@"
	fi
	put "${PS3-#? }"
	IFS=$WHITESPACE read -r REPLY 2>/dev/null || { unset -v _loop_V _loop_pid; return 1; }


	while str empty "$REPLY"; do
		_loop_select_printMenu "$@"
		put "${PS3-#? }"
		IFS=$WHITESPACE read -r REPLY || { unset -v _loop_V _loop_pid; return 1; }
	done

	if thisshellhas BUG_READWHSP; then
		REPLY=${REPLY%"${REPLY##*[!"$WHITESPACE"]}"}
	fi

	if str isint "$REPLY" && let "REPLY > 0 && REPLY <= $#"; then
		eval "${_loop_V}=\${$((REPLY))}"
	else
		eval "${_loop_V}=''"
	fi

	command kill -s CONT "${_loop_pid}" || die "LOOP select: SIGCONT failed"
	unset -v _loop_V _loop_pid
} >&2


if not thisshellhas WRN_MULTIBYTE \
|| not {


	_Msh_ctest=$(PATH=$DEFPATH
		unset -f printf wc
		exec printf 'mis\303\250ri\303\253n' | exec wc -m)
	if str isint "${_Msh_ctest}" && let "_Msh_ctest == 8"; then
		unset -v _Msh_ctest; true
	else
		unset -v _Msh_ctest; false
	fi
}; then


	_loop_select_printMenu() (
		PATH=$DEFPATH
		_loop_max=0

		for _loop_V do
			if let "${#_loop_V} > _loop_max"; then
				_loop_max=${#_loop_V}
			fi
		done
		let "_loop_max += (${##}+2)"
		_loop_col=$(( ${COLUMNS:-80} / (_loop_max + 2) ))
		if let "_loop_col < 1"; then _loop_col=1; fi
		_loop_d=$(( $# / _loop_col ))
		until let "_loop_col * _loop_d >= $#"; do
			let "_loop_d += 1"
		done

		_loop_i=1
		while let "_loop_i <= _loop_d"; do
			_loop_j=${_loop_i}
			while let "_loop_j <= $#"; do
				eval "_loop_V=\${${_loop_j}}"
				command printf \
					"%${##}d) %s%$((_loop_max - ${#_loop_V} - ${##}))c" \
					"${_loop_j}" "${_loop_V}" ' ' \
					|| die "LOOP select: print menu: output error"
				let "_loop_j += _loop_d"
			done
			putln
			let "_loop_i += 1"
		done
	)

else


	_loop_select_printMenu() (
		PATH=$DEFPATH
		unset -f wc
		_loop_max=0

		_loop_i=0
		for _loop_V do

			case ${_loop_V} in
			( *[!"$ASCIICHARS"]* )
				_loop_L=$(put "${_loop_V}" | exec wc -m)
				str isint "${_loop_L}" || die "LOOP select: internal error: 'wc' failed" ;;
			( * )	_loop_L=${#_loop_V} ;;
			esac

			if let "(_loop_L_$((_loop_i += 1)) = _loop_L) > _loop_max"; then
				_loop_max=${_loop_L}
			fi
		done
		let "_loop_max += (${##}+2)"
		_loop_col=$(( ${COLUMNS:-80} / (_loop_max + 2) ))
		if let "_loop_col < 1"; then _loop_col=1; fi
		_loop_d=$(( $# / _loop_col ))
		until let "_loop_col * _loop_d >= $#"; do
			let "_loop_d += 1"
		done

		_loop_i=1
		while let "_loop_i <= _loop_d"; do
			_loop_j=${_loop_i}
			while let "_loop_j <= $#"; do
				eval "_loop_V=\${${_loop_j}} _loop_L=\${_loop_L_${_loop_j}}"
				command printf \
					"%${##}d) %s%$((_loop_max - _loop_L - ${##}))c" \
					"${_loop_j}" "${_loop_V}" ' ' \
					|| die "LOOP select: print menu: output error"
				let "_loop_j += _loop_d"
			done
			putln
			let "_loop_i += 1"
		done
	)

fi

if thisshellhas ROFUNC; then
	readonly -f _loopgen_select _loop_select_getReply _loop_select_printMenu
fi
