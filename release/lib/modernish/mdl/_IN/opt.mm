#! /module/for/moderni/sh
\command unalias _Msh_optNamCanon _Msh_optNamToLtr _Msh_optNamToVar 2>/dev/null



_Msh_optNamCanon() {
	_Msh_opt=$1
	case $1 in
	( "" | *[!"$ASCIIALNUM"_-]* )
		return 2 ;;
	esac
	if thisshellhas QRK_OPTCASE && str match "${_Msh_opt}" '*[A-Z]*'; then
		_Msh_opt=$(unset -f tr
			putln "${_Msh_opt}" | PATH=$DEFPATH LC_ALL=C exec tr A-Z a-z) \
		|| die 'internal error in _Msh_optNamCanon()'
	fi
	if thisshellhas QRK_OPTULINE; then
		while str in "${_Msh_opt}" '_'; do
			_Msh_opt=${_Msh_opt%%_*}${_Msh_opt#*_}
		done
	fi
	if thisshellhas QRK_OPTDASH; then
		while str in "${_Msh_opt}" '-'; do
			_Msh_opt=${_Msh_opt%%-*}${_Msh_opt#*-}
		done
	fi
	if thisshellhas QRK_OPTNOPRFX && str begin "${_Msh_opt}" "no"; then
		if thisshellhas QRK_OPTABBR; then


			str in "${_Msh_allMyLongOpts}" ":${_Msh_opt#no}" && _Msh_opt=${_Msh_opt#no}
		else
			_Msh_opt=${_Msh_opt#no}
		fi
	fi

	case ${_Msh_allMyLongOpts} in
	( *:"${_Msh_opt}":* )

		;;
	( *:"${_Msh_opt}"* )

		thisshellhas QRK_OPTABBR || return 1
		case ${_Msh_allMyLongOpts#*:"$_Msh_opt"} in
		( *:"${_Msh_opt}"* )

			return 1 ;;
		esac

		_Msh_opt=${_Msh_opt}${_Msh_allMyLongOpts#*:"$_Msh_opt"}
		_Msh_opt=${_Msh_opt%%:*} ;;
	( * )
		return 1 ;;
	esac
	if thisshellhas QRK_OPTNOPRFX; then

		case ${_Msh_opt} in
		( clobber | exec | glob | log | unset )
			_Msh_opt="no${_Msh_opt}" ;;
		esac
	fi
}

unset -v _Msh_optLtrCache
_Msh_optNamToLtr() {
	case $1 in
	( nolog )	thisshellhas BUG_OPTNOLOG && unset -v _Msh_opt && return 1 ;;
	esac
	case $1 in

	( interactive )	_Msh_opt=i ;;
	( allexport )	_Msh_opt=a ;;
	( errexit )	_Msh_opt=e ;;
	( noclobber )	_Msh_opt=C ;;
	( noglob )	_Msh_opt=f ;;
	( noexec )	_Msh_opt=n ;;
	( nounset )	_Msh_opt=u ;;
	( verbose )	_Msh_opt=v ;;
	( xtrace )	_Msh_opt=x ;;

	( * )	case ${_Msh_optLtrCache-}: in
		( *:"$1"=?:* )
			_Msh_opt=${_Msh_optLtrCache#*:"$1"=}
			_Msh_opt=${_Msh_opt%%:*} ;;
		( *:!"$1":* )
			unset -v _Msh_opt
			return 1 ;;
		( * )
			_Msh_opt=$(
				: 1>&1
				PATH=$DEFPATH
				case $1 in
				( restricted )
					set -o restricted && command echo 'r'
					\exit ;;
				( shoptionletters )

					\exit 1 ;;
				esac
				set -o "$1" 2>/dev/null
				_Msh_o1=$-
				set +o "$1" 2>/dev/null
				_Msh_o2=$-
				case $(( ${#_Msh_o1} - ${#_Msh_o2} )) in
				( 0 )
					\exit 1 ;;
				( 1 )	;;
				( -1 )
					_Msh_o=${_Msh_o1}
					_Msh_o1=${_Msh_o2}
					_Msh_o2=${_Msh_o} ;;
				( * )	die "internal error 1 in _Msh_optNamToLtr()" ;;
				esac


				while ! str empty "${_Msh_o1}"; do
					_Msh_o=${_Msh_o1%${_Msh_o1#?}}
					if ! str in "${_Msh_o2}" "${_Msh_o}"; then
						! str match "${_Msh_o}" "*[!$SHELLSAFECHARS]*" && put "${_Msh_o}"
						\exit
					fi
					_Msh_o1=${_Msh_o1#?}
				done
				die "internal error 2 in _Msh_optNamToLtr()"
			) || {
				_Msh_optLtrCache=${_Msh_optLtrCache-}:!$1
				unset -v _Msh_opt
				return 1
			}
			_Msh_optLtrCache=${_Msh_optLtrCache-}:$1=${_Msh_opt} ;;
		esac
	esac
}

_Msh_optNamToVar() {
	_Msh_optNamCanon "$1" || let "$? < 2" || { unset -v _Msh_opt; return 2; }
	_Msh_V=${_Msh_opt}
	if _Msh_optNamToLtr "${_Msh_V}"; then
		eval "$2=_Msh_ShellOptLtr_\${_Msh_opt}"
	else
		while str in "${_Msh_V}" '-'; do
			_Msh_V=${_Msh_V%%-*}_${_Msh_V#*-}
		done
		eval "$2=_Msh_ShellOpt_\${_Msh_V}"
	fi
	unset -v _Msh_opt _Msh_V
}



unset -v _Msh_allMyLongOpts
thisshellhas QRK_OPTNOPRFX
_Msh_allMyLongOpts=$(
	: 1>&1
	IFS=$WHITESPACE; set -fu
	set -- $(set -o)

	while let "$# >= 2" && str ne "$2" 'on' && str ne "$2" 'off'; do
		shift
	done
	let "$# > 0 && $# % 2 == 0" || exit 1 'internal error in _IN/opt.mm'

	_Msh_even=0
	for _Msh_opt do
		if let "(_Msh_even = !_Msh_even) == 1"; then
			if thisshellhas QRK_OPTNOPRFX \
			&& str begin "${_Msh_opt}" 'no' \
			&& (set -o "${_Msh_opt}" +o "${_Msh_opt#no}") 2>/dev/null; then
				_Msh_opt=${_Msh_opt#no}
			fi
			set -- "$@" "${_Msh_opt}"
		fi
		shift
	done

	IFS=':'; putln ":$*:"
) || return 1
readonly _Msh_allMyLongOpts

if thisshellhas ROFUNC; then
	readonly -f _Msh_optNamCanon _Msh_optNamToLtr _Msh_optNamToVar
fi
