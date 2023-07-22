#! /helper/script/for/moderni/sh


case ${ZSH_VERSION+z} in
( z )
	emulate sh ;;
esac

case $# in
( 2 )	;;
( * )	echo "die 'LOOP find: internal error'" >&8
	exit 128 ;;
esac

CCn='
'

case $2 in
(*\\*)


	Q=
	P=$2
	while :; do
		case $P in
		( "" )	break ;;

		($CCn*)	Q=$Q\${CCn}
			P=${P#?} ;;

		(\\$CCn*)Q=$Q\${CCn}
			P=${P#??} ;;

		(\\?*)	Q=$Q${P%"${P#??}"}
			P=${P#??} ;;

		([][?*]* | [0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz%+,./:=@_^!-]*)
			Q=$Q${P%"${P#?}"}
			P=${P#?} ;;

		( * )	Q=$Q\\${P%"${P#?}"}
			P=${P#?} ;;
		esac
	done
	eval "case \$1 in
	( $Q )	;;
	( * )	exit 1 ;;
	esac" ;;
( * )
	case $1 in
	( $2 )	;;
	( * )	exit 1 ;;
	esac ;;
esac
