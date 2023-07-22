#! /module/for/moderni/sh
\command unalias readlink _Msh_doReadLink _Msh_doReadLink_canon _Msh_doReadLink_canon_nonexist 2>/dev/null


use var/shellquote

_Msh_doReadLink() {
	is sym "$1" || return 1


	str begin "$1" / && _Msh_rL_F2=$1 || _Msh_rL_F2=$PWD/$1
	str in "/$CC01/${_Msh_rL_seen}/$CC01/" "/$CC01/${_Msh_rL_F2}/$CC01/" && return 1
	_Msh_rL_seen=${_Msh_rL_seen:+$_Msh_rL_seen/$CC01/}${_Msh_rL_F2}

	_Msh_rL_F=$(PATH=$DEFPATH command ls -ld -- "$1" 2>/dev/null && put X) \
	|| die "readlink: system command 'ls -ld' failed"


	_Msh_rL_F2=${_Msh_rL_F%"$CCn"X}
	str eq "${_Msh_rL_F2}" "${_Msh_rL_F}" && die "readlink: internal error 1"



	_Msh_rL_F=${_Msh_rL_F2#*" $1 -> "}
	if str eq "${_Msh_rL_F}" "${_Msh_rL_F2}"; then
		if str end "${_Msh_rL_F}" " $1" && not str in "${_Msh_rL_F%" $1"}" ' -> '; then

			_Msh_rL_F=$1
			unset -v _Msh_rL_F2
			return 1
		fi
		die "readlink: internal error 2"
	fi
	unset -v _Msh_rL_F2
}

_Msh_doReadLink_canon() {


	case $1 in
	( *[!/]*/ )
		_Msh_tmp=$1
		while str end "${_Msh_tmp}" '/'; do
			_Msh_tmp=${_Msh_tmp%/}
		done
		not is -L present "${_Msh_tmp}" && set -- "${_Msh_tmp}" ;;
	esac


	if str match "$1" '//[!/]*/*[!/]*/*[!/]*'; then

		_Msh_D=${1#//[!/]*/*[!/]*/}
		chdir -f -- "${1%/"$_Msh_D"}" 2>/dev/null && set -- "${_Msh_D}" || chdir //
	elif str match "$1" '//[!/]*' || str eq "$1" '//'; then

		chdir -f -- "$1" 2>/dev/null && set -- '' || chdir //
	elif str begin "$1" '/'; then

		chdir /
	fi



	str in "$1" '/' || set -- "./$1"
	str begin "$1" './' && { str ne "${PWD:-.}" '.' && is -L dir "$PWD" && chdir -f -- "$PWD" || \exit 0; }
	{ str end "$1" '/.' || str end "$1" '/..'; } && set -- "$1/"
	unset -v _Msh_nonexist
	IFS='/'
	for _Msh_D in ${1%/*}; do
		if str empty "${_Msh_D}" || str eq "${_Msh_D}" '.'; then
			continue
		elif isset _Msh_nonexist; then
			_Msh_doReadLink_canon_nonexist "${_Msh_D}"
		elif chdir -f -- "${_Msh_D}" 2>/dev/null; then
			:
		elif str eq "${_Msh_rL_canon}" 'm'; then
			while _Msh_doReadLink "${_Msh_D}"; do
				if str in "${_Msh_rL_F}" '/'; then
					_Msh_doReadLink_canon "${_Msh_rL_F}"
					return
				else
					_Msh_D=${_Msh_rL_F}
				fi
			done
			_Msh_nonexist=
			_Msh_doReadLink_canon_nonexist "${_Msh_D}"
		else
			\exit 0
		fi
	done
	IFS=
	_Msh_rL_F=${1##*/}
}

_Msh_doReadLink_canon_nonexist() {
	case $1 in
	( .. )	PWD=${PWD%/*}
		case $PWD in
		( *[!/] ) ;;
		( * )	  PWD=$PWD/ ;;
		esac ;;
	( * )	case $PWD in
		( *[!/] ) PWD=$PWD/$1 ;;
		( * )	  PWD=$PWD$1 ;;
		esac ;;
	esac
	if chdir -f -- "$PWD" 2>/dev/null; then
		unset -v _Msh_nonexist
	fi
}

readlink() {

	unset -v _Msh_rL_n _Msh_rL_s _Msh_rL_Q _Msh_rL_canon
	while	case ${1-} in
		( -[!-]?* )
			_Msh_rL__o=${1#-}
			shift
			while not str empty "${_Msh_rL__o}"; do
				set -- "-${_Msh_rL__o#"${_Msh_rL__o%?}"}" "$@"	#"
				_Msh_rL__o=${_Msh_rL__o%?}
			done
			unset -v _Msh_rL__o
			continue ;;
		( -[efm] )
			_Msh_rL_canon=${1#-} ;;
		( -[nsQ] )
			eval "_Msh_rL_${1#-}=''" ;;
		( -- )	shift; break ;;
		( --help )
			putln "modernish $MSH_VERSION sys/base/readlink" \
				"usage: readlink [ -nsefmQ ] [ FILE ... ]" \
				"   -n: Don't output trailing newline." \
				"   -s: Don't output anything (still store in REPLY)." \
				"   -e: Canonicalise path and follow all symlinks encountered." \
				"       All pathname components must exist." \
				"   -f: Like -e, but the last component does not need to exist." \
				"   -m: Like -e, but no component needs to exist." \
				"   -Q: Shell-quote each pathname. Separate by spaces."
			return ;;
		( -* )	die "readlink: invalid option: $1" \
				"${CCn}usage:${CCt}readlink [ -nsfQ ] [ FILE ... ]" \
				"${CCn}${CCt}readlink --help" ;;
		( * )	break ;;
		esac
	do
		shift
	done

	_Msh_rL_err=0
	isset _Msh_rL_n || _Msh_rL_n=$CCn
	let "$#" || die "readlink: at least one non-option argument expected" \
				"${CCn}usage:${CCt}readlink [ -nsefmQ ] [ FILE ... ]" \
				"${CCn}${CCt}readlink --help"

	REPLY=''
	for _Msh_rL_F do
		_Msh_rL_seen=
		if isset _Msh_rL_canon; then

			_Msh_rL_F=$(
				set -f 1>&1
				IFS=''
				_Msh_doReadLink_canon "${_Msh_rL_F}"
				while _Msh_doReadLink "${_Msh_rL_F}"; do
					_Msh_doReadLink_canon "${_Msh_rL_F}"
				done
				case $PWD in
				( *[!/] )
					case ${_Msh_rL_F} in
					( '' )	_Msh_rL_F=$PWD ;;
					( * )	_Msh_rL_F=$PWD/${_Msh_rL_F} ;;
					esac ;;
				( * )	_Msh_rL_F=$PWD${_Msh_rL_F} ;;
				esac
				case ${_Msh_rL_canon} in
				( e )	is -L present "${_Msh_rL_F}" || \exit 0 ;;
				esac
				put "${_Msh_rL_F}X"
			) || die "readlink -f: internal error"
			if str empty "${_Msh_rL_F}"; then
				_Msh_rL_err=1
				continue
			fi
			_Msh_rL_F=${_Msh_rL_F%X}
		else

			_Msh_doReadLink "${_Msh_rL_F}" || {
				_Msh_rL_err=1
				continue
			}
		fi
		if isset _Msh_rL_Q; then
			shellquote -f _Msh_rL_F
			REPLY=${REPLY:+$REPLY }${_Msh_rL_F}
		else
			REPLY=${REPLY:+$REPLY$CCn}${_Msh_rL_F}
		fi
	done
	if not str empty "$REPLY" && not isset _Msh_rL_s; then
		put "${REPLY}${_Msh_rL_n}"
	fi
	eval "unset -v _Msh_rL_n _Msh_rL_s _Msh_rL_Q _Msh_rL_canon _Msh_rL_F _Msh_rL_err _Msh_rL_seen; return ${_Msh_rL_err}"
}

if thisshellhas ROFUNC; then
	readonly -f readlink _Msh_doReadLink _Msh_doReadLink_canon _Msh_doReadLink_canon_nonexist
fi
