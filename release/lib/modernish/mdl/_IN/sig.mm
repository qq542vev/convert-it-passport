#! /module/for/moderni/sh
\command unalias _Msh_arg2sig _Msh_arg2sig_sanitise 2>/dev/null



_Msh_psigCache=
_Msh_arg2sig() {
	unset -v _Msh_sigv
	case ${1:+n} in
	( n )	_Msh_sig=$1 ;;
	esac
	case ${_Msh_sig} in
	( 0 )	_Msh_sig=EXIT; _Msh_sigv=EXIT ;;
	( *[!0123456789]* )

		_Msh_arg2sig_sanitise || return 1
		case ${_Msh_sig} in
		( DIE ) use -q var/stack/trap || return 1
			_Msh_sigv=DIE
			return ;;
		( EXIT )_Msh_sigv=EXIT
			return ;;
		( ERR )	if thisshellhas TRAPZERR; then
				_Msh_sigv=ZERR
				return
			fi ;;
		esac

		case ${_Msh_sigCache} in
		( *\|${_Msh_sig}${CCn}* )

			_Msh_sigv=${_Msh_sigCache%\|${_Msh_sig}${CCn}*}
			_Msh_sigv=${_Msh_sigv##*${CCn}} ;;
		( * )
			case ${_Msh_sig} in
			( *[!${ASCIIALNUM}_]* )
				return 1 ;;
			esac

			case "|${_Msh_psigCache}|" in
			( *"|${_Msh_sig}|"* )
				_Msh_sigv=${_Msh_sig} ;;
			( *"|!${_Msh_sig}|"* )
				return 1 ;;
			( * )	if (command trap - "${_Msh_sig}") 2>/dev/null; then
					_Msh_sigv=${_Msh_sig}
					_Msh_psigCache=${_Msh_psigCache}${_Msh_psigCache:+\|}${_Msh_sig}
				else
					_Msh_psigCache=${_Msh_psigCache}${_Msh_psigCache:+\|}!${_Msh_sig}
					return 1
				fi ;;
			esac ;;
		esac ;;
	( * )
		case ${_Msh_sigCache} in
		( *${CCn}$((_Msh_sig % 128))\|[!${CCn}]* )
			_Msh_sigv=$((_Msh_sig % 128))
			_Msh_sig=${_Msh_sigCache#*${CCn}${_Msh_sigv}\|}
			_Msh_sig=${_Msh_sig%%${CCn}*} ;;
		( * )	return 1 ;;
		esac ;;
	esac
}
_Msh_arg2sig_sanitise() {
	case ${_Msh_sig} in
	( '' | *[!"$SHELLSAFECHARS"]* )
		return 1 ;;
	( [Ss][Ii][Gg][Nn][Aa][Ll][123456789]* )

		_Msh_sig=${_Msh_sig#[Ss][Ii][Gg][Nn][Aa][Ll]} ;;
	( *[abcdefghijklmnopqrstuvwxyz]* )
		_Msh_sig=$(unset -f tr
			putln "${_Msh_sig}" | PATH=$DEFPATH LC_ALL=C exec tr a-z A-Z) \
			|| die "trap stack: system error: 'tr' failed" ;;
	( *[!0123456789]* )
		;;
	( * )
		return 1 ;;
	esac
	_Msh_sig=${_Msh_sig#SIG}
}


_Msh_sigCache=
push IFS -f _Msh_sig _Msh_num
IFS=\|; set -f
for _Msh_sig in $(
	: 1>&1
	_Msh_i=0 PATH=$DEFPATH
	while let "(_Msh_i+=1)<128"; do
		command kill -l "${_Msh_i}" && put "${_Msh_i}|"
	done 2>/dev/null)
do
	_Msh_num=${_Msh_sig##*$CCn}
	_Msh_sig=${_Msh_sig%$CCn*}
	_Msh_arg2sig_sanitise || continue
	_Msh_sigCache=${_Msh_sigCache:-${CCn}}${_Msh_num}\|${_Msh_sig}${CCn}
done
pop IFS -f _Msh_sig _Msh_num
readonly _Msh_sigCache


if thisshellhas ROFUNC; then
	readonly -f _Msh_arg2sig _Msh_arg2sig_sanitise
fi
