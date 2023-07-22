#! /module/for/moderni/sh
\command unalias _loopgen_for 2>/dev/null

use var/loop


_loopgen_for() {
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
	case ${#},${2-},${4-} in
	( 1,, | 3,to, | 5,to,step )
		case ${_loop_split+s}${_loop_glob+s}${_loop_base+s}${_loop_slice+s} in
		( ?* )	_loop_die \
			"${_loop_split+--split }${_loop_glob+--glob }${_loop_base+--base }${_loop_slice+--slice }not" \
			"applicable to arithmetic loop" ;;
		esac ;;
	esac

	case ${#},${2-},${4-} in


	( *,in,* )
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
			'fi; ' || die "LOOP ${_loop_type}: can't put init"
		fi
		_loop_V=$1
		shift 2
		unset -v _loop_globmatch

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
				( '' )	is present "${_loop_AA}" || continue
					_loop_globmatch= ;;
				( f )	if not is present "${_loop_AA}"; then
						shellquote -f _loop_AA
						_loop_die "--fglob: no match: ${_loop_AA}"
					fi
					_loop_globmatch= ;;
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
						shellquote _loop_A=${_loop_AA%"$_loop_rest"}
						putln ${_loop_V}=${_loop_A} || exit
						_loop_AA=${_loop_rest}
					done ;;
				esac
				shellquote _loop_A=${_loop_AA}
				putln ${_loop_V}=${_loop_A} || exit
			done
			if let "$# == 0" && not str empty "${_loop_glob-NO}"; then


				str eq "${_loop_glob-NO}" f && _loop_die "--fglob: empty pattern"
				putln ${_loop_V}= || exit
			fi
		done >&8 2>/dev/null || die "LOOP for: can't write iterations"
		case ${_loop_glob-N},${_loop_globmatch-N} in
		( ,N )	putln '! _loop_E=103' >&8; exit ;;
		( f,N )	_loop_die "--fglob: no patterns" ;;
		esac ;;


	( 1,, )
		case +$1 in
		( *[!_$ASCIIALNUM]_loop_* | *[!_$ASCIIALNUM]_Msh_* )
				_loop_die "cannot use _Msh_* or _loop_* internal namespace" ;;
		( *\;*\;*\;* )	_loop_die "arithmetic: too many expressions (3 expected in 1 argument)" ;;
		( *\;*\;* )	;;
		( * )		_loop_die "arithmetic: too few expressions (3 expected in 1 argument)" ;;
		esac

		_loop_1=$1\;
		IFS=\;
		set -- ${_loop_1}
		IFS=


		command trap '_loop_die "invalid arithmetic expression"' 0
		case $1 in (*[!$WHITESPACE]*) let "$1" "1" || exit; shellquote _loop_1=$1 ;; ( * ) _loop_1= ;; esac
		case $2 in (*[!$WHITESPACE]*) let "$2" "1" || exit; shellquote _loop_2=$2 ;; ( * ) _loop_2='1' ;; esac
		case $3 in (*[!$WHITESPACE]*) let "$3" "1" || exit; shellquote _loop_3=$3 ;; ( * ) _loop_3= ;; esac
		command trap - 0
		{

			putln "let ${_loop_1} ${_loop_2}"

			forever do
				putln "let ${_loop_3} ${_loop_2}" || exit
			done
		} >&8 2>/dev/null || die "LOOP for: can't write iterations" ;;


	( 3,to, | 5,to,step )

		case +$1+$3+${5-} in
		( *[!_$ASCIIALNUM]_loop_* | *[!_$ASCIIALNUM]_Msh_* )
			_loop_die "cannot use _Msh_* or _loop_* internal namespace" ;;
		esac
		str match $1 '?*=?*' || _loop_die "syntax error: invalid assignment argument"
		_loop_var=${1%%=*}
		_loop_ini="${_loop_var} = (${1#*=})"


		command trap '_loop_die "invalid arithmetic expression"' 0
		if let "$# == 5"; then
			let "${_loop_ini}" "_loop_fin = ($3)" "_loop_inc = ($5)" "1" || exit
		else
			let "${_loop_ini}" "_loop_fin = ($3)" "_loop_inc = (${_loop_var} > _loop_fin ? -1 : 1)" || exit
		fi
		command trap - 0
		let "_loop_inc >= 0" && _loop_cmp='<=' || _loop_cmp='>='
		{

			shellquote _loop_expr="(${_loop_ini}) ${_loop_cmp} ($3)"
			putln "let ${_loop_expr}"

			shellquote _loop_expr="(${_loop_var} += ${_loop_inc}) ${_loop_cmp} ($3)"
			forever do
				putln "let ${_loop_expr}" || exit
			done
		} >&8 2>/dev/null || die "LOOP for: can't write iterations" ;;


	( * )	_loop_die "syntax error" ;;
	esac
}

if thisshellhas ROFUNC; then
	readonly -f _loopgen_for
fi
