#! /module/for/moderni/sh
\command unalias which 2>/dev/null


use var/shellquote

which() {




	unset -v _Msh_WhO_a _Msh_WhO_p _Msh_WhO_q _Msh_WhO_n _Msh_WhO_s _Msh_WhO_Q _Msh_WhO_f _Msh_WhO_1 _Msh_WhO_P
	while	case ${1-} in
		( -[!-]?* )
			_Msh_WhO__o=$1
			shift
			while _Msh_WhO__o=${_Msh_WhO__o#?} && not str empty "${_Msh_WhO__o}"; do
				_Msh_WhO__a=-${_Msh_WhO__o%"${_Msh_WhO__o#?}"}
				push _Msh_WhO__a
				case ${_Msh_WhO__o} in
				( [P]* )
					_Msh_WhO__a=${_Msh_WhO__o#?}
					not str empty "${_Msh_WhO__a}" && push _Msh_WhO__a && break ;;
				esac
			done
			while pop _Msh_WhO__a; do
				set -- "${_Msh_WhO__a}" "$@"
			done
			unset -v _Msh_WhO__o _Msh_WhO__a
			continue ;;
		( -[apqnsQf1] )
			eval "_Msh_WhO_${1#-}=''" ;;
		( -[P] )
			let "$# > 1" || die "which: $1: option requires argument"
			eval "_Msh_WhO_${1#-}=\$2"
			shift ;;
		( -- )	shift; break ;;
		( --help )
			putln "modernish $MSH_VERSION sys/base/which" \
				"usage: which [ -apqsnQ1f ] [ -P NUM ] PROGRAM [ PROGRAM ... ]" \
				"   -a: List all executables found." \
				"   -p: Search in \$DEFPATH instead of \$PATH." \
				"   -q: Quiet: suppress all warnings." \
				"   -s: Silent. Only store filenames in REPLY." \
				"   -n: Do not write final newline." \
				"   -Q: Shell-quote each pathname. Separate by spaces." \
				"   -1: Output only the first result found." \
				"   -f: Fatal error if any not found, or with -1, if none found." \
				"   -P: Strip NUM pathname elements, starting from the right."
			return ;;
		( -* )	die "which: invalid option: $1" \
				"${CCn}usage:${CCt}which [ -apqsnQf1 ] [ -P NUM ] PROGRAM [ PROGRAM ... ]" \
				"${CCn}${CCt}which --help" ;;
		( * )	break ;;
		esac
	do
		shift
	done

	if isset _Msh_WhO_p; then
		_Msh_WhO_p=$DEFPATH
	else
		_Msh_WhO_p=$PATH
	fi
	if isset _Msh_WhO_P; then
		str isint "${_Msh_WhO_P}" && let "_Msh_WhO_P >= 0" ||
			die "which: -P: argument must be non-negative integer"
		let "_Msh_WhO_P > 0" || unset -v _Msh_WhO_P
	fi
	if isset _Msh_WhO_s; then
		if not isset _Msh_WhO_q && insubshell; then
			putln "which:  warning: 'which -s' was used in a subshell; \$REPLY will" \
				"${CCt}not survive the subshell. (Suppress this warning with -q)" 1>&2
		fi
		_Msh_WhO_q=''
	fi
	if isset _Msh_WhO_1; then
		_Msh_WhO_q=''
	fi
	let "$#" || die "which: at least 1 non-option argument expected" \
				"${CCn}usage:${CCt}which [ -apqsnQf1 ] [ -P NUM ] PROGRAM [ PROGRAM ... ]" \
				"${CCn}${CCt}which --help"

	push -f -u IFS
	set -f -u; IFS=''
	_Msh_Wh_allfound=y
	REPLY=''
	for _Msh_Wh_arg do
		case ${_Msh_Wh_arg} in

		( */* )	_Msh_Wh_paths=${_Msh_Wh_arg%/*}/
			_Msh_Wh_cmd=${_Msh_Wh_arg##*/} ;;

		( * )	_Msh_Wh_paths=${_Msh_WhO_p}
			_Msh_Wh_cmd=${_Msh_Wh_arg} ;;
		esac
		unset -v _Msh_Wh_found1

		IFS=':' _Msh_Wh_seen=':'
		for _Msh_Wh_dir in ${_Msh_Wh_paths}; do
			IFS=''
			str in :${_Msh_Wh_seen}: :${_Msh_Wh_dir}: && continue
			_Msh_Wh_seen=${_Msh_Wh_seen}${_Msh_Wh_dir}:
			case ${_Msh_Wh_dir} in
			( *[!/]* )
				while case ${_Msh_Wh_dir} in (*/);; (*) break;; esac; do
					_Msh_Wh_dir=${_Msh_Wh_dir%/}
				done
				_Msh_Wh_pcmd=${_Msh_Wh_dir}/${_Msh_Wh_cmd} ;;
			( * )	_Msh_Wh_pcmd=${_Msh_Wh_dir}${_Msh_Wh_cmd} ;;
			esac
			if can exec ${_Msh_Wh_pcmd}; then
				case ${_Msh_Wh_dir} in
				( [!/]* | */./* | */../* | */. | */.. | *//* )

					_Msh_Wh_dir=$(chdir -L -f -- "${_Msh_Wh_dir}" && put "${PWD}X") || continue
					_Msh_Wh_dir=${_Msh_Wh_dir%X}
					case ${_Msh_Wh_dir} in
					( *[!/] )
						_Msh_Wh_pcmd=${_Msh_Wh_dir}/${_Msh_Wh_cmd} ;;
					( * )	_Msh_Wh_pcmd=${_Msh_Wh_dir}${_Msh_Wh_cmd} ;;
					esac ;;
				esac
				_Msh_Wh_found1=${_Msh_Wh_pcmd}
				if isset _Msh_WhO_P; then
					_Msh_Wh_i=${_Msh_WhO_P}
					while let "(_Msh_Wh_i-=1) >= 0"; do
						_Msh_Wh_found1=${_Msh_Wh_found1%/*}
						if str empty "${_Msh_Wh_found1}"; then
							if let "_Msh_Wh_i > 0"; then
								if not isset _Msh_WhO_q; then
									put "which: warning: found" \
									"${_Msh_Wh_pcmd} but can't strip" \
									"$((_Msh_WhO_P)) path elements from it${CCn}" 1>&2
								fi
								unset -v _Msh_Wh_allfound
								continue 2
							else
								_Msh_Wh_found1=/
							fi
							break
						fi
					done
				fi
				if isset _Msh_WhO_Q; then
					shellquote -f _Msh_Wh_found1
					REPLY=${REPLY:+$REPLY }${_Msh_Wh_found1}
				else
					REPLY=${REPLY:+$REPLY$CCn}${_Msh_Wh_found1}
				fi
				isset _Msh_WhO_a || break
			fi
		done
		if isset _Msh_Wh_found1; then
			if isset _Msh_WhO_1; then
				_Msh_Wh_allfound=y
				if isset _Msh_WhO_f; then
					_Msh_WhO_f=''
				fi
				break
			fi
		else
			unset -v _Msh_Wh_allfound
			isset _Msh_WhO_q || putln "which: no ${_Msh_Wh_cmd} in (${_Msh_Wh_paths})" 1>&2
			if isset _Msh_WhO_f; then
				shellquote -f _Msh_Wh_arg
				_Msh_WhO_f=${_Msh_WhO_f}\ ${_Msh_Wh_arg}
			fi
		fi
	done
	pop -f -u IFS

	if not isset _Msh_WhO_s && not str empty "$REPLY"; then
		put "$REPLY${_Msh_WhO_n-$CCn}"
	fi
	if not str empty "${_Msh_WhO_f-}"; then
		die "which: not found:${_Msh_WhO_f}"
	fi
	isset _Msh_Wh_allfound
	eval "unset -v _Msh_WhO_a _Msh_WhO_p _Msh_WhO_q _Msh_WhO_n _Msh_WhO_s _Msh_WhO_Q _Msh_WhO_f _Msh_WhO_1 _Msh_WhO_P \
		_Msh_Wh_seen _Msh_Wh_allfound _Msh_Wh_found1 _Msh_Wh_pcmd \
		_Msh_Wh_arg _Msh_Wh_paths _Msh_Wh_dir _Msh_Wh_cmd _Msh_Wh_i; return $?"
}

if thisshellhas ROFUNC; then
	readonly -f which
fi
