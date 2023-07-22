#! helper/script/for/moderni/sh

case ${DEFPATH+s} in
( '' )	. "${MSH_PREFIX:-$PWD}/lib/modernish/aux/defpath.sh" ;;
esac

_Msh_Gsh_testFn() {
	case ${IFS:+n} in
	( '' )	set -- "a b c"
		set -- $1
		case $# in
		( 1 )	;;
		( * )	! : ;;
		esac ;;
	esac
}
_Msh_Gsh_testFn && _Msh_IFS=$IFS || unset -v _Msh_IFS

case $- in
( *f* )	unset -v _Msh_glob ;;
( * )	_Msh_glob=y ;;
esac

_Msh_Gsh_doTestShell() {
	export DEFPATH
	exec "$1" -c \
		'. "$1" && unset -v MSH_FTL_DEBUG && command . "$2" || echo BUG' \
		"$1" \
		"${MSH_PREFIX:-$PWD}/lib/modernish/aux/std.sh" \
		"${MSH_PREFIX:-$PWD}/lib/modernish/aux/fatal.sh" \
		2>|/dev/null
}

_Msh_Gsh_testFn() {
set -- zsh ksh93 yash bash ksh lksh mksh ash gwsh dash sh

case ${MSH_SHELL:+s} in
( s )	case $MSH_SHELL in
	( /* )	;;
	( */* )
		if _Msh_test=$(CDPATH= cd -- "${MSH_SHELL%/*}" && echo "$PWD/${MSH_SHELL##*/}"); then
			MSH_SHELL=${_Msh_test}
		fi ;;
	esac
	case ${MSH_SHELL##*/} in
	( [!0123456789-]*[0123456789-]* )

		_Msh_test=${MSH_SHELL##*/}
		set -- "${_Msh_test%%[0123456789-]*}" "$@" ;;
	esac

	set -- "$MSH_SHELL" "${MSH_SHELL##*/}" "$@" ;;
esac
unset -v MSH_SHELL

IFS=:
set -f
for _Msh_test do
	case ${_Msh_test} in
	( /* )	command -v "${_Msh_test}" >/dev/null 2>&1 || continue
		case $(_Msh_Gsh_doTestShell "${_Msh_test}") in
		( $$ )	MSH_SHELL=${_Msh_test}
			break ;;
		esac ;;
	( * )	for _Msh_P in $DEFPATH $PATH; do
			case ${_Msh_P} in
			( /* )	command -v "${_Msh_P}/${_Msh_test}" >/dev/null 2>&1 || continue
				case $(_Msh_Gsh_doTestShell "${_Msh_P}/${_Msh_test}") in
				( $$ )	MSH_SHELL=${_Msh_P}/${_Msh_test}
					break 2 ;;
				esac ;;
			esac
		done ;;
	esac
done
unset -v _Msh_test _Msh_P
}
_Msh_Gsh_testFn

unset -f _Msh_Gsh_doTestShell _Msh_Gsh_testFn

case ${_Msh_IFS+s} in
( '' )	unset -v IFS ;;
( * )	IFS=${_Msh_IFS}
	unset -v _Msh_IFS ;;
esac

case ${_Msh_glob+s} in
( '' )	set -f ;;
( * )	set +f
	unset -v _Msh_glob ;;
esac

case ${MSH_SHELL:+s} in
( '' )	if PATH=/dev/null command -v _Msh_initExit >/dev/null 2>&1; then
		_Msh_initExit "Can't find any suitable POSIX-compliant shell!"
	fi
	echo "Fatal: can't find any suitable POSIX-compliant shell!" 1>&2
	exit 128 ;;
esac
export MSH_SHELL
