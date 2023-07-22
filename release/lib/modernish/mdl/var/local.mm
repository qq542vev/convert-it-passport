#! /module/for/moderni/sh
\command unalias BEGIN END LOCAL _Msh_sL_END _Msh_sL_LOCAL _Msh_sL_die _Msh_sL_genPPs_base _Msh_sL_reallyunsetIFS _Msh_sL_setPPs _Msh_sL_temp 2>/dev/null

if not thisshellhas LINENO || thisshellhas BUG_LNNONEG; then
	_Msh_sL_LINENO="''"
else
	_Msh_sL_LINENO='"${LINENO-}"'
fi

if thisshellhas BUG_FNSUBSH; then
	_Msh_sL_ksh93='command ulimit -t unlimited 2>/dev/null; '
else
	_Msh_sL_ksh93=''
fi

if thisshellhas KSHARRAY; then
	_Msh_sL_setPPs='eval ${_Msh_PPs+"set --"} ${_Msh_PPv+'\''"${_Msh_PPv[@]}"'\''} ${_Msh_PPs+"; unset -v _Msh_PPs _Msh_PPv"}'
else
	_Msh_sL_setPPs='eval ${_Msh_PPs+"set -- ${_Msh_PPs}; unset -v _Msh_PPs _Msh_PPv ${_Msh_PPv}"}'
fi


alias LOCAL="{ ${_Msh_sL_ksh93}unset -v _Msh_sL; { _Msh_sL_LOCAL ${_Msh_sL_LINENO}"
alias BEGIN="}; isset _Msh_sL && _Msh_sL_temp() { ${_Msh_sL_setPPs}; "
alias END="} || die 'LOCAL: init lost'; _Msh_sL_temp \"\$@\"; _Msh_sL_END \"\$?\" ${_Msh_sL_LINENO}; }"

unset -v _Msh_sL_LINENO _Msh_sL_ksh93 _Msh_sL_setPPs



_Msh_sL_LOCAL() {
	not isset _Msh_sL || _Msh_sL_die "spurious re-init"


	_Msh_sL_LN=$1
	shift

	unset -v _Msh_sL _Msh_sL_A _Msh_sL_o _Msh_sL_split _Msh_sL_glob _Msh_sL_slice _Msh_sL_base


	for _Msh_sL_A do
		case ${_Msh_sL_o-} in
		( y )	if not thisshellhas -o "${_Msh_sL_A}"; then
				_Msh_sL_die "no such shell option: -o ${_Msh_sL_A}"
			fi
			_Msh_sL="${_Msh_sL+${_Msh_sL} }-o ${_Msh_sL_A}"
			unset -v _Msh_sL_o
			continue ;;
		esac
		case "${_Msh_sL_A}" in
		( -- )		break ;;
		( --split )	_Msh_sL_split= ; continue ;;
		( --split= )	unset -v _Msh_sL_split; continue ;;
		( --split=* )	_Msh_sL_split=${_Msh_sL_A#--split=}; continue ;;
		( --glob )	_Msh_sL_glob= ; continue ;;
		( --fglob )	_Msh_sL_glob=f; continue ;;
		( --base )	_Msh_sL_die "option requires argument: ${_Msh_sL_A}" ;;
		( --base=* )	_Msh_sL_base=${_Msh_sL_A#--base=}; continue ;;
		( --slice )	_Msh_sL_slice=1; continue ;;
		( --slice=* )	_Msh_sL_slice=${_Msh_sL_A#--slice=}; continue ;;
		( [-+]o )	_Msh_sL_o=y; continue ;;
		( [-+]["$ASCIIALNUM"] )
				thisshellhas "-${_Msh_sL_A#?}" || _Msh_sL_die "no such shell option: ${_Msh_sL_A}"
				_Msh_sL_V="-${_Msh_sL_A#[-+]}" ;;
		( *=* )		_Msh_sL_V=${_Msh_sL_A%%=*} ;;
		( * )		_Msh_sL_V=${_Msh_sL_A} ;;
		esac
		case "${_Msh_sL_V}" in
		( -["$ASCIIALNUM"] )
			;;
		( '' | [0123456789]* | *[!"$ASCIIALNUM"_]* )
			_Msh_sL_die "invalid variable name, shell option or operator: ${_Msh_sL_V}" ;;
		esac
		_Msh_sL="${_Msh_sL+${_Msh_sL} }${_Msh_sL_V}"
	done
	case ${_Msh_sL_o-} in
	( y )	_Msh_sL_die "${_Msh_sL_A}: option requires argument" ;;
	esac
	case ${_Msh_sL_A-} in
	( -- )	;;
	( * )	case ${_Msh_sL_split+s}${_Msh_sL_glob+g} in
		( ?* )	_Msh_sL_die "--split or --*glob require '--'" ;;
		esac ;;
	esac
	if not isset -f || not isset IFS || not str empty "$IFS"; then
		isset _Msh_sL_split && isset _Msh_sL_glob && _Msh_sL_die "--split & --${_Msh_sL_glob}glob without safe mode"
		isset _Msh_sL_split && _Msh_sL_die "--split without safe mode"
		isset _Msh_sL_glob && _Msh_sL_die "--${_Msh_sL_glob}glob without safe mode"
	fi
	if isset _Msh_sL_base && isset _Msh_sL_glob; then
		not str end ${_Msh_sL_base} '/' && _Msh_sL_base=${_Msh_sL_base}/
	fi
	if isset _Msh_sL_slice; then
		if not str isint ${_Msh_sL_slice} || let "_Msh_sL_slice <= 0"; then
			_Msh_sL_die "--slice: invalid number of characters: ${_Msh_sL_slice}"
		fi
		_Msh_sL_pat=''
		while let "${#_Msh_sL_pat} < _Msh_sL_slice"; do
			_Msh_sL_pat=${_Msh_sL_pat}\?
		done
	fi




	eval "push --key=_Msh_setlocal ${_Msh_sL-} _Msh_sL"


	unset -v _Msh_E _Msh_PPs _Msh_PPv
	while	case ${1-} in
		( '' )		break ;;
		( -- )		_Msh_PPs=''
				shift
				break ;;
		( --* )		;;
		( [+-]o )	command set "$1" "$2" || _Msh_E="${_Msh_E:+$_Msh_E; }'set $1 $2' failed"
				shift ;;
		( [-+]["$ASCIIALNUM"] )
				command set "$1" || _Msh_E="${_Msh_E:+$_Msh_E; }'set $1' failed" ;;
		( *=* )		eval "${1%%=*}=\${1#*=}" ;;
		( * )		unset -v "$1" ;;
		esac
	do
		shift
	done


	if isset _Msh_E; then
		_Msh_sL_die "${_Msh_E}"
	fi


	if isset _Msh_PPs; then
		push --key=_Msh_setlocal IFS -f -a
		IFS=''
		set -f +a
		_Msh_sL_setPPs "$@"
		pop --key=_Msh_setlocal IFS -f -a
	fi

	unset -v _Msh_sL_split _Msh_sL_glob _Msh_sL_slice \
		_Msh_sL_pat _Msh_sL_rest \
		_Msh_sL_V _Msh_sL_A _Msh_sL_AA _Msh_sL_o _Msh_sL_i _Msh_sL_LN
	_Msh_sL=y
}

if thisshellhas KSHARRAY; then

	_Msh_sL_setPPs() {
		_Msh_sL_i=-1
		for _Msh_sL_A do
			case ${_Msh_sL_glob+s} in
			( s )	set +f ;;
			esac
			case ${_Msh_sL_glob+G}${_Msh_sL_base+B} in
			( GB )	_Msh_sL_expArgs=$(_Msh_sL_genPPs_base "$@") \
				|| case $? in
				( 100 )	_Msh_sL_die "could not enter base dir: ${_Msh_sL_base}" ;;
				( * )	_Msh_sL_die "internal error" ;;
				esac
				eval "set -- ${_Msh_sL_expArgs}"
				unset -v _Msh_sL_expArgs ;;
			( * )	case ${_Msh_sL_split+s},${_Msh_sL_split-} in
				( s, )	_Msh_sL_reallyunsetIFS ;;
				( s,* )	IFS=${_Msh_sL_split} ;;
				esac

				set -- ${_Msh_sL_A}


				IFS=''
				set -f ;;
			esac


			for _Msh_sL_AA do
				case ${_Msh_sL_base+B} in
				( B )	_Msh_sL_AA=${_Msh_sL_base}${_Msh_sL_AA} ;;
				esac
				case ${_Msh_sL_glob-NO} in
				( '' )	is present "${_Msh_sL_AA}" || continue ;;
				( f )	is present "${_Msh_sL_AA}" || _Msh_sL_die "--fglob: no match: ${_Msh_sL_AA}" ;;
				esac
				case ${_Msh_sL_glob+G},${_Msh_sL_AA} in
				( G,-* | G,+* | G,\( | G,\! )

					_Msh_sL_AA=./${_Msh_sL_AA} ;;
				esac
				case ${_Msh_sL_slice+S} in
				( S )	while let "${#_Msh_sL_AA} > _Msh_sL_slice"; do
						_Msh_sL_rest=${_Msh_sL_AA#$_Msh_sL_pat}
						_Msh_PPv[$(( _Msh_sL_i += 1 ))]=${_Msh_sL_AA%"$_Msh_sL_rest"}
						_Msh_sL_AA=${_Msh_sL_rest}
					done ;;
				esac
				_Msh_PPv[$(( _Msh_sL_i += 1 ))]=${_Msh_sL_AA}
			done
			if let "$# == 0" && not str empty "${_Msh_sL_glob-NO}"; then


				str eq "${_Msh_sL_glob-NO}" f && _Msh_sL_die "--fglob: empty pattern"
				_Msh_PPv[$(( _Msh_sL_i += 1 ))]=''
			fi
		done
		case ${_Msh_PPv+s},${_Msh_sL_glob-} in
		( ,f )	_Msh_sL_die "--fglob: no patterns"
		esac
	}
else

	_Msh_sL_setPPs() {
		_Msh_PPv=''
		_Msh_sL_i=0
		for _Msh_sL_A do
			case ${_Msh_sL_glob+s} in
			( s )	set +f ;;
			esac
			case ${_Msh_sL_glob+G}${_Msh_sL_base+B} in
			( GB )	_Msh_sL_expArgs=$(_Msh_sL_genPPs_base "$@") \
				|| case $? in
				( 100 )	_Msh_sL_die "could not enter base dir: ${_Msh_sL_base}" ;;
				( * )	_Msh_sL_die "internal error" ;;
				esac
				eval "set -- ${_Msh_sL_expArgs}"
				unset -v _Msh_sL_expArgs ;;
			( * )	case ${_Msh_sL_split+s},${_Msh_sL_split-} in
				( s, )	_Msh_sL_reallyunsetIFS ;;
				( s,* )	IFS=${_Msh_sL_split} ;;
				esac

				set -- ${_Msh_sL_A}


				IFS=''
				set -f ;;
			esac


			for _Msh_sL_AA do
				case ${_Msh_sL_base+B} in
				( B )	_Msh_sL_AA=${_Msh_sL_base}${_Msh_sL_AA} ;;
				esac
				case ${_Msh_sL_glob-NO} in
				( '' )	is present "${_Msh_sL_AA}" || continue ;;
				( f )	is present "${_Msh_sL_AA}" || _Msh_sL_die "--fglob: no match: ${_Msh_sL_AA}" ;;
				esac
				case ${_Msh_sL_glob+G},${_Msh_sL_AA} in
				( G,-* | G,+* | G,\( | G,\! )

					_Msh_sL_AA=./${_Msh_sL_AA} ;;
				esac
				case ${_Msh_sL_slice+S} in
				( S )	while let "${#_Msh_sL_AA} > _Msh_sL_slice"; do
						_Msh_sL_rest=${_Msh_sL_AA#$_Msh_sL_pat}
						eval "_Msh_$(( _Msh_sL_i += 1 ))=\${_Msh_sL_AA%\"\${_Msh_sL_rest}\"}"
						_Msh_PPs="${_Msh_PPs} \"\$_Msh_${_Msh_sL_i}\""
						_Msh_PPv="${_Msh_PPv} _Msh_${_Msh_sL_i}"
						_Msh_sL_AA=${_Msh_sL_rest}
					done ;;
				esac
				eval "_Msh_$(( _Msh_sL_i += 1 ))=\${_Msh_sL_AA}"
				_Msh_PPs="${_Msh_PPs} \"\$_Msh_${_Msh_sL_i}\""
				_Msh_PPv="${_Msh_PPv} _Msh_${_Msh_sL_i}"
			done
			if let "$# == 0" && not str empty "${_Msh_sL_glob-NO}"; then


				str eq "${_Msh_sL_glob-NO}" f && _Msh_sL_die "--fglob: empty pattern"
				_Msh_PPs="${_Msh_PPs} ''"
			fi
		done
		case ${_Msh_PPs},${_Msh_sL_glob-} in
		( ,f )	_Msh_sL_die "--fglob: no patterns"
		esac
	}
fi

_Msh_sL_genPPs_base() {
	thisshellhas BUG_FNSUBSH && command ulimit -t unlimited 2>/dev/null
	case ${_Msh_sL_glob} in
	( f )	chdir -f -- "${_Msh_sL_base}" || exit 100 ;;
	( * )	chdir -f -- "${_Msh_sL_base}" 2>/dev/null || exit 0 ;;
	esac
	case ${_Msh_sL_split+s},${_Msh_sL_split-} in
	( s, )	while isset IFS; do unset -v IFS; done ;;
	( s,* )	IFS=${_Msh_sL_split} ;;
	esac

	set -- ${_Msh_sL_A}


	IFS=''
	use var/shellquote
	for _Msh_sL_A do
		shellquote _Msh_sL_A
		put " ${_Msh_sL_A}"
	done
}

_Msh_sL_die() {

	pop --key=_Msh_setlocal IFS -f -a
	die "LOCAL${_Msh_sL_LN:+ (line $_Msh_sL_LN)}: $@"
}

_Msh_sL_END() {




	#unset -f _Msh_sL_temp

	pop --key=_Msh_setlocal _Msh_sL \
	|| die "END${2:+ (line $2)}: stack corrupted (failed to pop arguments)"
	if isset _Msh_sL; then
		eval "pop --key=_Msh_setlocal ${_Msh_sL}" \
		|| die "END${2:+ (line $2)}: stack corrupted (failed to pop globals)"
		unset -v _Msh_sL
	fi
	return "$1"
}

_Msh_sL_reallyunsetIFS() {
	unset -v IFS
	if isset -v IFS; then
		_Msh_sL_msg="LOCAL --split: unsetting IFS failed"
		thisshellhas QRK_LOCALUNS && _Msh_sL_msg="${_Msh_sL_msg} (QRK_LOCALUNS)"
		thisshellhas QRK_LOCALUNS2 && _Msh_sL_msg="${_Msh_sL_msg} (QRK_LOCALUNS2)"
		die "${_Msh_sL_msg}"
	fi
}

if thisshellhas ROFUNC; then
	readonly -f _Msh_sL_END _Msh_sL_LOCAL _Msh_sL_die _Msh_sL_genPPs_base _Msh_sL_reallyunsetIFS _Msh_sL_setPPs
fi
