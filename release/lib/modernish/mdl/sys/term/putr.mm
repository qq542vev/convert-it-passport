#! /module/for/moderni/sh
\command unalias putr putrln 2>/dev/null


unset -v _Msh_putr_ln

putr() {
	let "$# == 2" || die "putr${_Msh_putr_ln-}: need 2 arguments, got $#"
	case $1 in
	( - )
		_Msh_putr_n=${COLUMNS:=$(PATH=$DEFPATH command tput cols)}
		str isint "${_Msh_putr_n}" && let "_Msh_putr_n >= 0" || _Msh_putr_n=80

		if thisshellhas WRN_MULTIBYTE && str match "$2" "*[!$ASCIICHARS]*"; then
			_Msh_putr_n=$(( _Msh_putr_n / $(put "$2" | PATH=$DEFPATH command wc -m \
				|| die "putr${_Msh_putr_ln-}: 'wc' failed") ))
		else
			_Msh_putr_n=$(( _Msh_putr_n / ${#2} ))
		fi
		set -- "${_Msh_putr_n}" "$2"
		unset -v _Msh_putr_n ;;
	( * )	str isint "$1" && let "$1 >= 0" || die "putr${_Msh_putr_ln-}: invalid number: $1" ;;
	esac
	PATH=$DEFPATH _Msh_putr_s=$2 command awk -v "n=$(( $1 ))" \
		'BEGIN {
			ORS="";
			for (i = 1; i <= n; i++) print ENVIRON["_Msh_putr_s"];
			if ("_Msh_putr_ln" in ENVIRON) print "\n";
		}' \
	|| { let "$? > 125 && $? != SIGPIPESTATUS" && die "putr${_Msh_putr_ln-}: awk failed"; }
}

putrln() {
	export _Msh_putr_ln='ln'
	putr "$@"
	unset -v _Msh_putr_ln
}

if thisshellhas ROFUNC; then
	readonly -f putr putrln
fi
