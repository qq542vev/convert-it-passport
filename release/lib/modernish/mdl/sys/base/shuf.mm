#! /module/for/moderni/sh
\command unalias shuf _Msh_shuf_do_e _Msh_shuf_do_i 2>/dev/null


use sys/cmd/procsubst
\command unalias awk sed sort 2>/dev/null

shuf() (

	IFS=''
	set -fCu


	export PATH=$DEFPATH LC_ALL=C
	unset -f awk sed sort


	unset -v _Msh_shuf_e _Msh_shuf_i _Msh_shuf_n _Msh_shuf_r
	while	case ${1-} in
		( -[!-]?* )
			_Msh_shuf__o=$1
			shift
			while _Msh_shuf__o=${_Msh_shuf__o#?} && not str empty "${_Msh_shuf__o}"; do
				_Msh_shuf__a=-${_Msh_shuf__o%"${_Msh_shuf__o#?}"}
				push _Msh_shuf__a
				case ${_Msh_shuf__o} in
				( [inr]* )
					_Msh_shuf__a=${_Msh_shuf__o#?}
					not str empty "${_Msh_shuf__a}" && push _Msh_shuf__a && break ;;
				esac
			done
			while pop _Msh_shuf__a; do
				set -- "${_Msh_shuf__a}" "$@"
			done
			unset -v _Msh_shuf__o _Msh_shuf__a
			continue ;;
		( -[e] )
			eval "_Msh_shuf_${1#-}=''" ;;
		( -[inr] )
			let "$# > 1" || die "shuf: $1: option requires argument"
			eval "_Msh_shuf_${1#-}=\$2"
			shift ;;
		( -- )	shift; break ;;
		( -* )	die "shuf: invalid option: $1" ;;
		( * )	break ;;
		esac
	do
		shift
	done


	if isset _Msh_shuf_e; then
		if isset _Msh_shuf_i; then
			die "shuf: -e and -i are incompatible"
		fi
		let $# || exit 0
		command exec < $(% _Msh_shuf_do_e "$@") || die "shuf -e: internal error: failed to redirect"
	elif let "$# == 1" && not str eq $1 '-'; then
		command exec < $1 || die "shuf: not accessible: $1"
	elif let $#; then
		die "shuf: excess arguments"
	fi

	if isset _Msh_shuf_i; then
		str match ${_Msh_shuf_i} ?*-?* \
		&& _Msh_n=${_Msh_shuf_i%%-*} && str isint ${_Msh_n} \
		&& _Msh_m=${_Msh_shuf_i#*-}  && str isint ${_Msh_m} \
		&& let "_Msh_n >= 0 && _Msh_m >= _Msh_n" \
		|| die "shuf -i: invalid range: ${_Msh_shuf_i}"
		command exec < $(% _Msh_shuf_do_i ${_Msh_n} ${_Msh_m}) || die "shuf -i: internal error: failed to redirect"
	fi

	if isset _Msh_shuf_n; then
		str isint ${_Msh_shuf_n} && let "_Msh_shuf_n >= 0" || die "shuf: invalid number: ${_Msh_shuf_n}"
		let "(_Msh_shuf_n = _Msh_shuf_n) == 0" && exit
	fi

	if isset _Msh_shuf_r; then
		export _Msh_shuf_r
	fi


	(


		awk 'BEGIN {
			od = "echo \"$$\"; exec od -v -A n -t uI \"${_Msh_shuf_r:-/dev/urandom}\"";
			od | getline;
			if (NF != 1) exit 1;
			od_pid = $1;
			for (;;) {
				od | getline;
				if (! NF) exit 1;
				for (i = 1; i <= NF; i++) {
					if ($i + 0 != $i) exit 1;
					if (! getline L) {
						system(("kill -9 ")(od_pid));
						exit 0;
					}
					print $i ":" L;
				}
			}
		}' || let "$? == SIGPIPESTATUS" || die "shuf: failed to obtain randomness"
	) | (

		sort -n || let "$? == SIGPIPESTATUS" || die "shuf: internal error: 'sort' failed"
	) | (

		exec sed "
			s/^[0-9]*://
			${_Msh_shuf_e+s/@n/\\$CCn/g; s/@@/@/g}
			${_Msh_shuf_n:+$_Msh_shuf_n q}
		"
	) || let "$? == SIGPIPESTATUS" || die "shuf: internal error: 'sed' failed"
)

_Msh_shuf_do_e() {


	awk 'BEGIN {
		for (i = 1; i < ARGC; i++) {
			s = ARGV[i];
			gsub(/@/, "@@", s);
			gsub(/\n/, "@n", s);
			print s;
		}
	}' "$@" || let "$? == SIGPIPESTATUS" || die "shuf -e: internal error: 'awk' failed"
}

_Msh_shuf_do_i() {
	awk -v n=$(($1)) -v m=$(($2)) 'BEGIN {
		for (i = n; i <= m; i++) print i;
	}' || let "$? == SIGPIPESTATUS" || die "shuf -i: internal error: 'awk' failed"
}

if thisshellhas ROFUNC; then
	readonly -f shuf _Msh_shuf_do_e _Msh_shuf_do_i
fi
