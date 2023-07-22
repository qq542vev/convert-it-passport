#! helper/script/for/moderni/sh

case \
${BASH_VERSION+s}\
${KSH_VERSION+s}\
${NETBSD_SHELL+s}\
${POSH_VERSION+s}\
${SH_VERSION+s}\
${YASH_VERSION+s}\
${ZSH_VERSION+s}\
 in
( s )	;;
( '' )	command set -o posix 2>/dev/null ;;
( * )	_Msh_m="sanity check failed: more than one shell version identifier variable found"
	if PATH=/dev/null command -v _Msh_initExit >/dev/null; then
		_Msh_initExit "${_Msh_m}"
	fi
	echo "${_Msh_m}" 1>&2
	exit 128 ;;
esac

case ${ZSH_VERSION+z} in
( z )	case $- in
	( *x* )	emulate -R sh; set -x ;;
	( * )	emulate -R sh ;;
	esac

	setopt POSIX_ARGZERO
	if ! unset -f _Msh_nonexistent_fn 2>/dev/null; then



		eval 'function unset {
			case $1 in
			( -f )  builtin unset "$@" 2>/dev/null || : ;;
			( * )	builtin unset "$@" ;;
			esac
		}'
	fi

	case $0 in
	( modernish | */modernish )

		disable -r end foreach nocorrect repeat 2>/dev/null

		disable -r declare export float integer local readonly typeset 2>/dev/null

		setopt EVAL_LINENO
		;;
	esac
	;;
esac

case ${KSH_VERSION:-${SH_VERSION:-}} in
( '@(#)'* )
	set -o posix




	case ${KSH_VERSION:-} in
	( '@(#)MIRBSD KSH '* | '@(#)LEGACY KSH '* )
		case ${LC_ALL:-${LC_CTYPE:-${LANG:-}}} in
		( *[Uu][Tt][Ff]8* | *[Uu][Tt][Ff]-8* )
			set -U ;;
		( * )	set +U ;;
		esac ;;
	esac

	PATH=/dev/null command -v hash >/dev/null || alias hash='\command alias -t'
	PATH=/dev/null command -v type >/dev/null || alias type='\command -V'
	;;
( 'Version '* )

	test -o \?posix && set -o posix
	;;
esac

case ${YASH_VERSION+s} in
( s )	#set -o posix

	command set +o forlocal 2>/dev/null ;;
esac

case ${NETBSD_SHELL+n} in
( n )	set -o posix ;;
esac

case ${BASH_VERSION-} in
( '' | [012].* | 3.[01].* )
	;;
( * )	command shopt -s expand_aliases localvar_unset 2>/dev/null



	POSIXLY_CORRECT=y command :

	command alias _Msh_test='! '
	PATH=/dev/null command eval '_Msh_test { _Msh_test :; }' 2>/dev/null || set -o posix
	command unalias _Msh_test
	;;
esac

:
