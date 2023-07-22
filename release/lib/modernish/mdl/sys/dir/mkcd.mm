#! /module/for/moderni/sh
\command unalias mkcd 2>/dev/null


mkcd() {
	PATH=$DEFPATH command mkdir "$@" || die "mkcd: mkdir failed"
	shift "$(( $# - 1 ))"


	case $1 in
	( */* | [!+-]* | [+-]*[!0123456789]* )
		;;
	( * )	set -- "./$1" ;;
	esac

	CDPATH='' command cd -P -- "$1" || die "mkcd: cd failed"
}

if thisshellhas ROFUNC; then
	readonly -f mkcd
fi
