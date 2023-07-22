#! /module/for/moderni/sh
\command unalias _loop_find_setIter _loop_find_translateDepth _loop_find_translatePath _loopgen_find 2>/dev/null


use var/loop



_loop_M=$1
shift

unset -v _loop_find_b
while	case ${1-} in
	( -[bB] )
		_loop_find_b=${1#-} ;;
	( -- )	shift; break ;;
	( -[!-]?* )
		_loop_find_o=${1#-}; shift
		while ! str empty "${_loop_find_o}"; do
			set -- "-${_loop_find_o#"${_loop_find_o%?}"}" "$@"; _loop_find_o=${_loop_find_o%?}	#"
		done; unset -v _loop_find_o; continue ;;
	( -* )	die "${_loop_M}: invalid option: $1" ;;
	( * )	break ;;
	esac
do
	shift
done

unset -v _loop_2
if let "$# == 2"; then
	if is -L dir "$2" && not str end "$2" '/'; then
		set -- "$1" "$2/"
		_loop_2=found
	elif can exec "$2" || { _loop_2=$(use sys/cmd/extern; extern -v -- "$2") && set -- "$1" "${_loop_2}"; }; then
		_loop_2=found
	fi
	if not str empty "${_loop_2-}" && _loop_2=$(chdir -f -- "${2%/*}" && putln "$PWD/${2##*/}X"); then
		set -- "$1" "${_loop_2%X}"
		unset -v _loop_2
	else
		_loop_2="${_loop_M}: warning: preferred utility name or path '$2' not found"
		set -- "$1"
	fi
elif let "$# > 2"; then
	putln "${_loop_M}: excess arguments"
	return 1
fi

push IFS -f; IFS=; set -f	### begin safe mode
unset -v _loop_find_myUtil
_loop_dirdone=:
IFS=':'; for _loop_dir in "${2:+${2%/*}}" $DEFPATH $PATH; do IFS=
	str begin "${_loop_dir}" '/' || continue
	str in "${_loop_dirdone}" ":${_loop_dir}:" && continue
	for _loop_util in "${2:+${2##*/}}" find sfind bsdfind gfind gnufind; do
		if can exec "${_loop_dir}/${_loop_util}" \
		&& _loop_err=$(set +x
			PATH=$DEFPATH POSIXLY_CORRECT=y exec 2>&1 "${_loop_dir}/${_loop_util}" /dev/null /dev/null \
			-exec "$MSH_SHELL" -c 'echo "A $@"' x {} + \
			\( -exec "$MSH_SHELL" -c 'echo "B $@"' x {} + \) \
			-o \( -path /dev/null -depth -xdev \) -print) \
		&& {
			str eq "${_loop_err}" "A /dev/null /dev/null${CCn}B /dev/null /dev/null" \
			|| str eq "${_loop_err}" "B /dev/null /dev/null${CCn}A /dev/null /dev/null"
		}
		then
			_loop_find_myUtil=${_loop_dir}/${_loop_util}
			break 2
		fi
	done
	_loop_dirdone=${_loop_dirdone}${_loop_dir}:
done
unset -v _loop_dirdone _loop_dir _loop_util _loop_err
pop IFS -f			### end safe mode
if isset _loop_2; then
	putln "${_loop_2}${_loop_find_myUtil:+; using '${_loop_find_myUtil}'}"
	unset -v _loop_2
elif let "$# == 2"; then
	if is -L dir "$2"; then
		if not is -L samefile "$2" "${_loop_find_myUtil%/*}"; then
			putln "${_loop_M}: warning: no compliant utility found in '$2'${_loop_find_myUtil:+; using '${_loop_find_myUtil}'}"
		fi
	elif not is -L samefile "$2" "${_loop_find_myUtil}"; then
		putln "${_loop_M}: warning: '$2' was found non-compliant${_loop_find_myUtil:+; using '${_loop_find_myUtil}'}"
	fi
fi

unset -v _loop_find_broken _loop_find_nopath
if not isset _loop_find_myUtil; then
	_loop_find_myUtil=$(PATH=$DEFPATH command -v find) || {
		putln "${_loop_M}: fatal: cannot find the system's standard 'find' utility"
		return 1
	}

	if not {
		 _loop_err=$(set +x
			PATH=$DEFPATH POSIXLY_CORRECT=y exec 2>&1 find /dev/null /dev/null \
			-exec "$MSH_SHELL" -c 'echo "A $@"' "$ME" {} + \
			\( -exec "$MSH_SHELL" -c 'echo "B $@"' "$ME" {} + \) ) \
		&& {
			str eq "${_loop_err}" "A /dev/null /dev/null${CCn}B /dev/null /dev/null" \
			|| str eq "${_loop_err}" "B /dev/null /dev/null${CCn}A /dev/null /dev/null"
		}
	}; then
		_loop_find_broken=''
		if not isset _loop_find_b; then
			putln "${_loop_M}: fatal: cannot find a POSIX-compliant 'find' with '-exec ... {} +'." \
				"Please put a recent 'find' such as sfind or GNU find in your \$PATH, or" \
				"if that is not possible, use the -b/-B compatibility option (see manual)."
			return 1
		elif str eq "${_loop_find_b}" 'b'; then
			putln "${_loop_M}:${CCt}Warning: using non-POSIX-compliant '${_loop_find_myUtil}'." \
				"${CCt}${CCt}Performance will degrade and breakage cannot be ruled out." \
				"${CCt}${CCt}Recommend installing sfind or GNU find somewhere in \$PATH."
		fi
	fi


	if not {
		 _loop_err=$(set +x
			PATH=$DEFPATH POSIXLY_CORRECT=y exec 2>&1 find /dev/null \
			-path '/d?v?null' -print) \
		&& str eq "${_loop_err}" '/dev/null'
	}; then
		_loop_find_nopath=''
	fi
fi
shellquote _loop_find_myUtil
readonly _loop_find_myUtil _loop_find_broken
unset -v _loop_find_b

thisshellhas KSHARRAY



_loopgen_find() {
	export POSIXLY_CORRECT=y _loop_PATH=$DEFPATH _loop_AUX=$MSH_AUX/var/loop
	_loop_status=0


	_loop_find=${_loop_find_myUtil}
	unset -v _loop_V _loop_xargs _loop_split _loop_glob _loop_base _loop_try
	while str begin ${1-} '-'; do
		case $1 in
		( --xargs )
			export _loop_xargs= ;;
		( --xargs=* )
			thisshellhas KSHARRAY || _loop_die "--xargs=<array> requires a shell with KSHARRAY"
			export _loop_xargs=${1#--xargs=}
			_loop_checkvarname ${_loop_xargs} ;;
		( --split )
			_loop_split= ;;
		( --split= )
			unset -v _loop_split ;;
		( --split=* )
			_loop_split=${1#--split=} ;;
		( --glob )
			_loop_glob= ;;
		( --fglob )
			_loop_glob=f ;;
		( --base )
			_loop_die "option requires argument: $1" ;;
		( --base=* )
			export _loop_base=${1#--base=} ;;
		( --try )
			_loop_try= ;;
		( -- )	shift; break ;;


		( -f )	_loop_die "invalid option: $1" ;;
		(-??*)	break ;;

		( * )	shellquote _loop_opt=$1
			_loop_find="${_loop_find} ${_loop_opt}" ;;
		esac
		shift
	done
	if isset _loop_base; then
		case ${_loop_glob-} in
		( f )	chdir -f -- "${_loop_base}" || { shellquote -f _loop_base; _loop_die "could not enter base dir: ${_loop_base}"; } ;;
		( * )	chdir -f -- "${_loop_base}" 2>/dev/null || { putln '! _loop_E=98' >&8; exit; } ;;
		esac
		str match ${_loop_base} [+-]* && _loop_base=./${_loop_base}
		not str end ${_loop_base} '/' && _loop_base=${_loop_base}/
	fi
	if isset _loop_split || isset _loop_glob; then
		put >&8 'if ! isset -f || ! isset IFS || ! str empty "$IFS"; then' \
				"die 'LOOP find:" \
					"${_loop_split+--split }${_loop_glob+--${_loop_glob}glob }without safe mode';" \
			'fi; ' \
		|| die "LOOP find: internal error: cannot write safe mode check"
	fi


	if not isset _loop_xargs; then
		let $# || _loop_die "variable name or --xargs expected"
		_loop_checkvarname $1
		export _loop_V=$1
		shift
	fi



	case $# in
	( 0 )	set -- . ;;
	( * )	case $1 in
		( -* | \( | ! )
			set -- . "$@" ;;
		( in )	shift ;;
		( * )	_loop_die "'in PATH ...' or expression expected" ;;
		esac ;;
	esac
	unset -v _loop_paths
	while let $# && not str begin $1 '-' && not str eq $1 '(' && not str eq $1 '!'; do
		not isset _loop_paths && _loop_paths=
		unset -v _loop_A
		case ${_loop_glob+s} in
		( s )	set +f ;;
		esac
		case ${_loop_split+s},${_loop_split-} in
		( s, )	_loop_reallyunsetIFS ;;
		( s,* )	IFS=${_loop_split} ;;
		esac
		for _loop_A in $1; do IFS=''; set -f
			if not is present ${_loop_A}; then
				str empty ${_loop_A} && _loop_die "empty path"
				case ${_loop_glob-NO} in
				( '' )	shellquote -f _loop_A
					putln "LOOP find: warning: no such path: ${_loop_A}"
					_loop_status=103
					continue ;;
				( f )	shellquote -f _loop_A
					_loop_die "no such path: ${_loop_A}" ;;
				esac
			fi
			case ${_loop_glob+G}${_loop_split+S} in
			( ?* )	case ${_loop_A} in
				( -* | +* | \( | ! )

					_loop_A=./${_loop_A} ;;
				esac ;;
			esac
			shellquote _loop_A
			_loop_paths=${_loop_paths}${_loop_paths:+ }${_loop_A}
		done
		isset _loop_A || _loop_die "empty path"
		shift
	done
	if not isset _loop_paths; then
		_loop_die "at least one path required after 'in'"
	fi








	_loop_find_setIter
	unset -v _loop_have_iter _loop_mindepth _loop_maxdepth
	_loop_prims=
	while let $#; do
		case $1 in

		( -iterate )
			_loop_prims="${_loop_prims} ${_loop_iter}"
			_loop_have_iter=y ;;
		( -ask )
			_loop_find_setIter -i
			case ${2-'-none'} in
			( -* | \( | ! )
				_loop_Q='"{}"?' ;;
			( * )	_loop_Q=$2; shift ;;
			esac
			shellquote _loop_Q
			_loop_prims=${_loop_prims}' -exec $MSH_SHELL $MSH_AUX/var/loop/find-ask.sh '${_loop_Q}' {} \;' ;;

		( -or )
			_loop_prims="${_loop_prims} -o" ;;
		( -and )
			_loop_prims="${_loop_prims} -a" ;;
		( -not )
			_loop_prims="${_loop_prims} !" ;;

		( -true )
			_loop_prims="${_loop_prims} -links +0" ;;
		( -false )
			_loop_prims="${_loop_prims} -links 0" ;;

		( -mindepth | -maxdepth )
			str isint "${2-}" && let "(_loop_${1#-} = $2) >= 0" \
			|| _loop_die "$1: ${2+'$2': }non-negative integer required"
			case ${_loop_prims} in
			( *\ -[oa] | *' !' | *' \(' )
				_loop_prims="${_loop_prims} -links +0" ;;
			esac
			shift ;;
		( -depth )
			if str isint "${2-}"; then

				case $2 in
				( -* )
					_loop_find_translateDepth $(( -($2) ))
					_loop_prims="${_loop_prims} ! $REPLY" ;;
				( +* )
					_loop_find_translateDepth $(( ($2) + 1 ))
					_loop_prims="${_loop_prims} $REPLY" ;;
				( * )
					_loop_find_translateDepth $(( $2 ))
					_loop_prims="${_loop_prims} $REPLY"
					_loop_find_translateDepth $(( ($2) + 1 ))
					_loop_prims="${_loop_prims} ! $REPLY" ;;
				esac
				shift
			else

				_loop_prims="${_loop_prims} $1"
			fi ;;

		( -exec | -execdir | -ok | -okdir )
			str begin $1 -ok && _loop_find_setIter -i
			_loop_prims="${_loop_prims} $1"
			case $1 in
			( -exec | -ok )

				_loop_prims="${_loop_prims} \$MSH_SHELL \$MSH_AUX/var/loop/find-exec.sh" ;;
			esac
			while let "$# > 1"; do
				shift
				if str eq "$1 ${2-}" '{} +'; then
					shift
					if isset _loop_find_broken; then
						putln "LOOP find: warning: obsolete 'find' in use: changing '{} +' to '{} \;'"
						_loop_prims="${_loop_prims} {} \;"
					else
						_loop_prims="${_loop_prims} {} +"
					fi
					break
				fi
				shellquote _loop_A=$1
				_loop_prims="${_loop_prims} ${_loop_A}"
				if str eq $1 ';'; then
					break
				fi
			done ;;

		( -path )
			let "$# > 1" || _loop_die "$1: requires argument"
			_loop_find_translatePath $2
			_loop_prims="${_loop_prims} $REPLY"
			shift ;;

		( -name | -perm | -type | -links | -user | -group | -size | -[acm]time | -newer )
			_loop_prims="${_loop_prims} $1"
			let "$# > 1" && shift && shellquote _loop_A=$1 && _loop_prims="${_loop_prims} ${_loop_A}" ;;

		( -o | -a | -nouser | -nogroup | -xdev | -prune | -print )
			_loop_prims="${_loop_prims} $1" ;;

		( -* )	unset -v _loop_2 _loop_3
			if shellquote _loop_1=$1 \
			&& _loop_err=$(set +x; eval "exec ${_loop_find} /dev/null -prune -o -print ${_loop_1}" 2>&1)
			then
				_loop_prims="${_loop_prims} ${_loop_1}"
			elif let "$# > 1" && shellquote _loop_2=$2 \
			&& _loop_err=$(set +x; eval "exec ${_loop_find} /dev/null -prune -o -print ${_loop_1} ${_loop_2}" 2>&1)
			then
				_loop_prims="${_loop_prims} ${_loop_1} ${_loop_2}"
				shift
			elif let "$# > 2" && shellquote _loop_3=$3 \
			&& _loop_err=$(set +x; eval "exec ${_loop_find} \
							/dev/null -prune -o -print ${_loop_1} ${_loop_2} ${_loop_3}" 2>&1)
			then
				_loop_prims="${_loop_prims} ${_loop_1} ${_loop_2} ${_loop_3}"
				shift 2
			elif isset _loop_try; then
				putln "! REPLY=${_loop_1} _loop_E=128" >&8 \
				|| die "LOOP find: internal error: cannot write status on --try failure"
				exit
			elif str empty ${_loop_err}; then
				_loop_die "unknown error from ${_loop_find_myUtil} on primary ${_loop_1}"
			else
				_loop_die ${_loop_err#*find: }
			fi ;;

		( * )	shellquote _loop_A=$1
			_loop_prims="${_loop_prims} ${_loop_A}" ;;
		esac
		shift
	done
	if not str empty ${_loop_prims}; then

		_loop_err=$(set +x; eval "exec ${_loop_find} /dev/null -prune -o -print ${_loop_prims}" 2>&1) \
		|| if str empty ${_loop_err}; then
			_loop_die "unknown error from ${_loop_find_myUtil} upon validation"
		else
			_loop_die ${_loop_err#*find: }
		fi

		_loop_prims="\\( ${_loop_prims} \\)"
	fi
	if not isset _loop_have_iter; then

		_loop_prims="${_loop_prims} ${_loop_iter}"
	fi


	if str empty ${_loop_paths}; then
		putln "! _loop_E=${_loop_status}" >&8 \
		|| die "LOOP find: internal error: cannot write exit status on no path names"
		exit
	fi


	if isset _loop_mindepth; then
		_loop_find_translateDepth ${_loop_mindepth}
		_loop_prims="$REPLY ${_loop_prims}"
	fi
	if isset _loop_maxdepth; then
		_loop_find_translateDepth $((_loop_maxdepth + 1))
		_loop_prims="$REPLY -prune -o ${_loop_prims}"
	fi



	if isset _loop_DEBUG; then

		( eval "set -- ${_loop_find} ${_loop_paths} ${_loop_prims}"
		  shellquoteparams
		  put "[DEBUG] $@ 8>&8$CCn" )
	fi
	eval "${_loop_find} ${_loop_paths} ${_loop_prims} 8>&8"
	_loop_status=$(( _loop_status > $? ? _loop_status : $? ))
	if let '_loop_status > 125'; then

		case ${_loop_status} in
		( 126 )	die "LOOP find: system error: ${_loop_find_myUtil} could not be executed" ;;
		( 127 )	die "LOOP find: system error: ${_loop_find_myUtil} was not found" ;;
		( $SIGPIPESTATUS )
			;;
		( * )	REPLY=$(command kill -l ${_loop_status} 2>/dev/null) \
			&& not str isint ${REPLY:-0} && REPLY=${REPLY#[Ss][Ii][Gg]} \
			&& case $REPLY in
			( [Tt][Ee][Rr][Mm] )
				thisshellhas WRN_NOSIGPIPE \
				|| die "LOOP find: system error: ${_loop_find_myUtil} killed by SIGTERM" ;;
			( * )	 die "LOOP find: system error: ${_loop_find_myUtil} killed by SIG$REPLY" ;;
			esac || die "LOOP find: system error: ${_loop_find_myUtil} failed with status ${_loop_status}" ;;
		esac
	fi



	if isset _loop_xargs; then
		if str empty ${_loop_xargs}; then
			put "set --; " >&8 2>/dev/null || exit
		else
			put "unset -v ${_loop_xargs}; " >&8 2>/dev/null || exit
		fi
	fi
	putln "! _loop_E=${_loop_status}" >&8 2>/dev/null
}

if isset _loop_find_broken; then

	_loop_find_setIter() {
		if str eq ${1-} -i && is onterminal stdin; then
			_loop_iter='-exec $MSH_SHELL $MSH_AUX/var/loop/find-ok.sh {} \;'
		else
			_loop_iter='-exec $MSH_SHELL $MSH_AUX/var/loop/find.sh {} \;'
		fi
	}
else

	_loop_find_setIter() {
		if str eq ${1-} -i && is onterminal stdin; then
			if isset _loop_xargs; then
				_loop_iter='-exec $MSH_SHELL $MSH_AUX/var/loop/find-ok.sh {} +'
			else
				_loop_iter='-exec $MSH_SHELL $MSH_AUX/var/loop/find-ok.sh {} \;'
			fi
		else
			_loop_iter='-exec $MSH_SHELL $MSH_AUX/var/loop/find.sh {} +'
		fi
	}
fi

_loop_find_translateDepth() {
	_loop_ptrn=''
	_loop_i=0
	while let "(_loop_i += 1) <= $1"; do
		_loop_ptrn=${_loop_ptrn}/*
	done
	eval "set -- ${_loop_paths}"
	case $# in
	( 0 )	_loop_die "internal error in _loop_find_translateDepth()" ;;
	( 1 )	_loop_find_translatePath ${1}${_loop_ptrn} ;;
	( * )	_loop_path=''
		for _loop_A do
			_loop_find_translatePath ${_loop_A}
			_loop_path=${_loop_path:+$_loop_path -o }$REPLY
		done
		REPLY="\\( ${_loop_path} \\)" ;;
	esac
}

if isset _loop_find_nopath; then

	_loop_find_translatePath() {
		shellquote _loop_A=$1
		REPLY="-exec \$MSH_SHELL \$MSH_AUX/var/loop/find-path.sh {} ${_loop_A} \\;"
	}
	unset -v _loop_find_nopath
else

	_loop_find_translatePath() {
		shellquote _loop_A=$1
		REPLY="-path ${_loop_A}"
	}
fi

if thisshellhas ROFUNC; then
	readonly -f _loopgen_find _loop_find_setIter _loop_find_translateDepth _loop_find_translatePath
fi
