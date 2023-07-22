#! /helper/script/for/moderni/sh
IFS=''; set -fCu



trap 'trap - PIPE; kill -s PIPE $PPID $$' PIPE

interrupt_find() {
	kill -s PIPE $$
	kill -s TERM $PPID $$
	DIE "signals ignored"
}

DIE() {
	echo "LOOP find: $@" >&2
	kill -s KILL $PPID $$
}


case ${_loop_PATH+A}${_loop_AUX+O}${_loop_V+K}${_loop_xargs+K} in
( AOK )	;;
( * )	echo "die 'LOOP find: internal error'" >&8 || DIE "internal error"
	interrupt_find ;;
esac

PATH=${_loop_PATH}


mainstatus=0
trap 'mainstatus=1' USR1

awk -v _loop_exec=1 -v _loop_SIGCONT=$$ -f ${_loop_AUX}/find.awk -- "$@" >&8 &
kill -s STOP $$
wait $!
e=$?
case $e in
( 0 )	exit $mainstatus ;;
( 126 )	DIE "system error: awk could not be executed" ;;
( 127 )	DIE "system error: awk could not be found" ;;
( 129 | 1[3-9]? | [!1]?? | ????* )
	sig=$(kill -l $e 2>/dev/null)
	sig=${sig#[sS][iI][gG]}
	case $sig in
	( [pP][iI][pP][eE] )
		interrupt_find ;;
	( '' | [0-9]* )
		DIE "system error: awk exited with status $e" ;;
	( * )	DIE "system error: awk was killed by SIG$sig" ;;
	esac ;;
( * )
	interrupt_find ;;
esac
