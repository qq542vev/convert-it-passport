#! fatal/bug/test/for/moderni/sh

command ulimit -t unlimited 2>/dev/null

PATH=${DEFPATH:=$(getconf PATH)} || exit

trap 'echo fatalbug' 0

case ${MSH_FTL_DEBUG+d} in
( d )	set -o xtrace ;;
( * )	exec 2>/dev/null ;;
esac || exit

command ulimit -c 0

IFS=''; set +e -fCu



eval ': || $( :
)' || exit

eval ': || for i;
do :; done' || exit

case 'foo\
bar' in
( foo\\"
"bar )	;;
( * )	exit ;;
esac

t=ok
t=bug command -@
case ${t} in
( ok )	;;
( * )	exit ;;
esac

{ ! : || ! case x in x) ;; esac; } && exit

case ${BASH_VERSION-} in
( 4.[34].* )
	(false)
	(false) && exit ;;
esac



case ${PPID-} in
( '' | 0* | *[!0123456789]* )
	exit ;;
esac

PATH=/dev/null
{	t=x
	command -v unset \
	&& command -V unset \
	&& command -v if \
	&& command unset t \
	&& case ${t+s} in ( s ) exit ;; esac
} >/dev/null || exit
PATH=$DEFPATH

readonly CC01='' CC7F='' "RO=ok"
case $CC01,$CC7F,$RO,,,ok in
( ,,ok,$CC01,$CC7F,$RO ) ;;
( * )	exit ;;
esac

RO1=1 RO2=2 RO3=3
readonly RO1 RO2 RO3 || exit

command set +o braceexpand
PATH=/dev/null command -v typeset >|/dev/null && command typeset -@ foo
command unset -v RO1 RO2 RO3

alias test=test || exit

fn() { ! :; }
alias fn=:
eval fn || exit

unalias -a || exit

echo() { :; } && unset -f echo || exit

kill -s 0 $$ || exit

(command eval '(') && exit

fn() { : ; eval "return $?"; ! : ; }
fn || exit

for _Msh_test in 1; do
	eval "command continue
		exit"
done
for _Msh_test in 1; do
	eval "command break
		exit"
done

unset -v FTL_UNSETFAIL_D7CDE27B_C03A_4B45_8050_30A9292BDE74 || exit

unset -f FTL_UNSFNFAIL_574C63CD_8D52_4DCF_AD22_00B9AC29AFF7 \
|| case ${ZSH_VERSION+s} in ( s ) ;; ( * ) exit ;; esac

command test foo '=~' bar

command test 123 -eq 1XX && exit

PATH=/dev/null command -v let >/dev/null && let --



set -- "   \on\e" "\tw'o" " \th\'re\e" " \\'fo\u\r "
IFS=''
set -- "$@"
case $# in
( 4 )	;;
( * )	exit ;;
esac

set -u -- && set -- "$@" && t=$* && for t do :; done || exit

t='1 2 3'
IFS='x '
t=${t+$t }4\ 5
IFS=''
case ${t} in
( '1 2 3 4 5' )	;;
( * ) exit ;;
esac

t='barbarfoo'
case ${t##bar*}/${t%%*} in
( / )	;;
( * )	exit ;;
esac

t='a${t2=BUG}'
unset -v t2
t=${t%"${t#a}"}
case ${t},${t2-}, in
( 'a,,' ) ;;
( * )	exit ;;
esac

t=abcdefghij
t2=efg
case ${t#*"$t2"} in
( hij ) ;;
( * )	exit ;;
esac

t=
case foo${t:-} in
( foo )	;;
( * )	exit ;;
esac

set ' foo -> bar' foo
case ${1#" $2 -> "} in
( bar ) ;;
( * ) exit ;;
esac

t=$$
case $#${t},$(($#-1+1)) in
( "${#}${$},${#}" )
	;;
( * )	exit ;;
esac

t=$RO$CC01$CC7F$RO
case ${#t} in
( 6 )	;;
( * )	exit ;;
esac

case ${LC_ALL:-${LC_CTYPE:-${LANG:-}}} in
( *.[Uu][Tt][Ff]8 | *.[Uu][Tt][Ff]-8 )
	t='bèta'
	case ${#t} in
	( 4 | 5 ) ;;
	( * )	exit ;;
	esac
esac

set +u _1_
case ${#13},${#234},${#1},OK in
( 0,0,3,OK ) ;;
( * ) exit ;;
esac
set -u


t='  ::  \on\e :\tw'\''o \th\'\''re\e :\\'\''fo\u\r:   : :  '
IFS=': '
set -- ${t}
IFS=''
t=${#},${1-U},${2-U},${3-U},${4-U},${5-U},${6-U},${7-U},${8-U},${9-U},${10-U},${11-U},${12-U}
case ${t} in
( '8,,,\on\e,\tw'\''o,\th\'\''re\e,\\'\''fo\u\r,,,U,U,U,U' \
| '9,,,\on\e,\tw'\''o,\th\'\''re\e,\\'\''fo\u\r,,,,U,U,U' )
	;;
( * ) exit ;;
esac

case ${HOME-} in
( /* ) ;;
( * ) HOME=/dev/null/n ;;
esac
IFS='/'
set -- ~
IFS=''
case ${#},${1-} in
( 1,/* ) ;;
( * ) exit ;;
esac



i=7
j=0
case $(( ((j+=6*i)==0x2A)>0 ? 014 : 015 )) in
( 12 ) ;;
( * )	exit ;;
esac
case $j in
( 42 )	;;
( * )	exit ;;
esac

case $((37-16%7+9)) in
( 44 )	;;
( * )	exit ;;
esac

unset -v t2
command -v typeset >/dev/null && typeset -i t2
t2=$((1000005))
t=foo\\bar
: "$((t = 1000005))" || exit
case "${t2},$((1000001)),$((1000005)),${t}" in
( 1000005,1000001,1000005,1000005 ) ;;
( * )	exit ;;
esac
unset -v t2

unset -v t
: $((t = 1))
t=128/32
case $t in
( '128/32' ) ;;
( * ) exit ;;
esac



eval "case 'ab${CC01}c${CC7F}d' in
( \\a\\b\\${CC01}\\c\\${CC7F}\\d ) ;;
( * )	exit ;;
esac"

_Msh_test_1234=x
case x in
( [${_Msh_test_1234}] ) ;;
( * )	exit ;;
esac

t='ab]cd'
case c in
( *["${t}"]* )
	case e in
	( *[!"${t}"]* ) ;;
	( * ) exit ;;
	esac ;;
( * )	exit ;;
esac

case e in
( [a-] | [a-d] | [-a] ) exit ;;
esac

case XaYöb in
( X*Y* )	;;
( * | XaYöb )	exit ;;
esac

case \\z in
( "\z" ) ;;
( * )	exit ;;
esac

set -- \\
case ab\\cd in
( *"$1"* ) ;;
( * ) 	exit ;;
esac

t=''
case abc in
( ["${t}"] | [!a-z]* )
	exit ;;
esac

case "a-b" in *-*-*) exit ;; esac

case "ρ" in
( "ρ" )	;;
( * )	exit ;;
esac



set -C
: >/dev/null || exit

fn() {
	command : <&5
} 5</dev/null
fn 5<&- || exit



t=0
case ${ZSH_VERSION-} in
( 5.[0123].* )

	(set -o nonexistent_@_option) ;;
esac
case $((t += 1)) in
( 2 )	echo FTL_FLOWCORR1
	trap 'echo fatalbug' 0
	exit 1 ;;
esac



trap 'echo $PPID' 0

