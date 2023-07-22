#! /module/for/moderni/sh
\command unalias yes 2>/dev/null


yes() (
	case $# in
	( 0 )	_Msh_buf=y$CCn ;;
	( * )	IFS=' '; _Msh_buf="$*$CCn" ;;
	esac
	export _Msh_buf "PATH=$DEFPATH"
	unset -f awk
	exec awk 'BEGIN {
		ORS=""
		b=ENVIRON["_Msh_buf"];
		while (length(b) < 8192)
			b=(b)(b);
		while(1)
			print(b);
	}'
)

if thisshellhas ROFUNC; then
	readonly -f yes
fi
