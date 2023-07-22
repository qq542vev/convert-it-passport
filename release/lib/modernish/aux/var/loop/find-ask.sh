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

PATH=${_loop_PATH}

case $# in
( 2 )	;;
( * )	echo "die 'LOOP find: internal error'" >&8 || DIE "internal error"
	interrupt_find ;;
esac

pattern='{}'
buffer=$1
question=''
while case $buffer in (*"$pattern"*);; (*) break;; esac; do
        question=$question${buffer%%"$pattern"*}$2
        buffer=${buffer#*"$pattern"}
done
question=$question$buffer

yesexpr=$(locale yesexpr 2>/dev/null)
case $yesexpr in
( '' )	yesexpr='^[yY]' ;;
( * )	case yesexpr in
	( \"*\" ) yesexpr=${yesexpr#?}; yesexpr=${yesexpr%?} ;;
	esac ;;
esac

printf '%s ' $question
IFS=' 	' read -r answer 2>/dev/null || { echo; interrupt_find; }
printf '%s\n' $answer | grep -Eq -- $yesexpr
