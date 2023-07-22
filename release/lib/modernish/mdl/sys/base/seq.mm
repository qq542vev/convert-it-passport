#! /module/for/moderni/sh
\command unalias seq _Msh_seq_awk _Msh_seq_bc _Msh_seq_s _Msh_seq_unwrap _Msh_seq_w 2>/dev/null


use var/string/touplow

_Msh_seq_bc() {
	{ _Msh_e=$(set +x
		POSIXLY_CORRECT=y LC_ALL=C PATH=$DEFPATH
		export POSIXLY_CORRECT LC_ALL
		unset -f bc
		exec bc "$@" 2>&1 1>&9)
	} 9>&1 && case ${_Msh_e} in (?*) ! : ;; esac && unset -v _Msh_e || {
		_Msh_E=$?
		if let "(_Msh_E>0 && _Msh_E!=SIGPIPESTATUS) || ${#_Msh_e}>0"; then
			case ${_Msh_e} in (?*) die "seq: 'bc' wrote error:${CCn}${_Msh_e}" ;; esac
			die "seq: 'bc' failed with status ${_Msh_E}"
		fi
		eval "unset -v _Msh_E _Msh_e; return ${_Msh_E}"
	}
}

_Msh_seq_awk() {
	POSIXLY_CORRECT=y LC_ALL=C PATH=$DEFPATH command awk "$@" || {
		_Msh_E=$?
		if let "_Msh_E>0 && _Msh_E!=SIGPIPESTATUS"; then
			die "seq: 'awk' failed with status ${_Msh_E}"
		fi
		eval "unset -v _Msh_E; return ${_Msh_E}"
	}
}

_Msh_seq_s() {
	export _Msh_seqO_s
	_Msh_seq_awk '
		BEGIN {
			ORS=ENVIRON["_Msh_seqO_s"];
		}
		{
			if (NR>1)
				print prevline;
			prevline=$0;
		}
		END {
			ORS="\n";
			print prevline;
		}
	'
}

_Msh_seq_w() {
	_Msh_seq_awk -v "L=${_Msh_seq_L}" -v "R=${_Msh_seq_R}" '{
		if ((R>0) && ($0 !~ /\./)) {

			if (L==1)
				$0="";
			$0=($0)(".");
			for (i=0; i<R; i++)
				$0=($0)("0");
		}
		j=L+R-length();
		if ($0 ~ /^-/)
			for (i=0; i<j; i++)
				sub(/^-/, "-0");
		else
			for (i=0; i<j; i++)
				$0=("0")($0);
		print;
	}'
}

_Msh_seq_unwrap() {
	_Msh_seq_awk '
		/\\$/ {
			sub(/\\$/, "");
			contline=(contline)($0);
			next;
		}
		{
			print (contline)($0);
			contline="";
		}
	'
}

seq() {




	unset -v _Msh_seqO_w _Msh_seqO_L _Msh_seqO_s _Msh_seqO_f _Msh_seqO_B _Msh_seqO_b _Msh_seqO_S
	while	case ${1-} in
		( -[!-]?* )
			_Msh_seqO__o=$1
			shift
			while _Msh_seqO__o=${_Msh_seqO__o#?} && not str empty "${_Msh_seqO__o}"; do
				_Msh_seqO__a=-${_Msh_seqO__o%"${_Msh_seqO__o#?}"}
				push _Msh_seqO__a
				case ${_Msh_seqO__o} in
				( [sfBbS]* )
					_Msh_seqO__a=${_Msh_seqO__o#?}
					not str empty "${_Msh_seqO__a}" && push _Msh_seqO__a && break ;;
				esac
			done
			while pop _Msh_seqO__a; do
				set -- "${_Msh_seqO__a}" "$@"
			done
			unset -v _Msh_seqO__o _Msh_seqO__a
			continue ;;
		( -[wL] )
			eval "_Msh_seqO_${1#-}=''" ;;
		( -[sfBbS] )
			let "$# > 1" || die "seq: $1: option requires argument"
			eval "_Msh_seqO_${1#-}=\$2"
			shift ;;
		( -- )	shift; break ;;
		( --help )
			putln "modernish $MSH_VERSION sys/base/seq" \
				"usage: seq [-wL] [-f FORMAT] [-s STRING] [-S N] [-B N] [-b N] [FIRST [INCR]] LAST" \
				"   -w: Equalise width by padding with leading zeros." \
				"   -L: Use current locale's radix point in output instead of '.'." \
				"   -f: printf-style floating-point formatting." \
				"   -s: Use STRING to separate numbers." \
				"   -S: Set number of digits after radix point." \
				"   -B: Set input and output base from 1 to 16 (default: 10)." \
				"   -b: Set any output base from 1."
			return ;;
		( -* )	die "seq: invalid option: $1"
				"${CCn}usage:${CCt}seq [-w] [-f FORMAT] [-s STRING] [-S N] [-B N] [-b N] [FIRST [INCR]] LAST" \
				"${CCn}${CCt}seq --help" ;;
		( * )	break ;;
		esac
	do
		shift
	done



	if not str isint "${_Msh_seqO_B=10}" || let "(_Msh_seqO_B < 2) || (_Msh_seqO_B > 16)"; then
		die "seq: invalid input base: ${_Msh_seqO_B}"
	fi
	case $((_Msh_seqO_B)) in
	( 2 )	_Msh_seq_digits=01 ;;
	( 3 )	_Msh_seq_digits=012 ;;
	( 4 )	_Msh_seq_digits=0123 ;;
	( 5 )	_Msh_seq_digits=01234 ;;
	( 6 )	_Msh_seq_digits=012345 ;;
	( 7 )	_Msh_seq_digits=0123456 ;;
	( 8 )	_Msh_seq_digits=01234567 ;;
	( 9 )	_Msh_seq_digits=012345678 ;;
	( 10 )	_Msh_seq_digits=0123456789 ;;
	( 11 )	_Msh_seq_digits=0123456789Aa ;;
	( 12 )	_Msh_seq_digits=0123456789ABab ;;
	( 13 )	_Msh_seq_digits=0123456789ABCabc ;;
	( 14 )	_Msh_seq_digits=0123456789ABCDabcd ;;
	( 15 )	_Msh_seq_digits=0123456789ABCDEabcde ;;
	( 16 )	_Msh_seq_digits=0123456789ABCDEFabcdef ;;
	esac


	if not str isint "${_Msh_seqO_b=${_Msh_seqO_B}}" || let "_Msh_seqO_b < 2"; then
		die "seq: invalid output base: ${_Msh_seqO_b}"
	fi



	if isset _Msh_seqO_S && { not str isint "${_Msh_seqO_S}" || let "_Msh_seqO_S < 1"; }; then
		die "seq: invalid scale: ${_Msh_seqO_S}"
	fi


	unset -v _Msh_seq_incr
	case $# in
	( 1 )	_Msh_seq_first=1; _Msh_seq_last=$1 ;;
	( 2 )	_Msh_seq_first=$1; _Msh_seq_last=$2 ;;
	( 3 )	_Msh_seq_first=$1; _Msh_seq_incr=$2; _Msh_seq_last=$3 ;;
	( * )	die "seq: need 1 to 3 floating point numbers." \
		"${CCn}usage:${CCt}seq [-w] [-f FORMAT] [-s STRING] [-S N] [-B N] [-b N] [FIRST [INCR]] LAST" \
		"${CCn}${CCt}seq --help" ;;
	esac


	case ${_Msh_seq_incr-u} in
	( u )	_Msh_seq_incr=0 ;;
	( [+-]*[!0]* | *[!0+-]* ) ;;
	( * )	die "seq: zero increment" ;;
	esac


	for _Msh_seq_n in "${_Msh_seq_first}" "${_Msh_seq_incr}" "${_Msh_seq_last}"; do
		case ${_Msh_seq_n} in
		( '' | [+-] | ?*[+-]* | *.*.* | *[!"${_Msh_seq_digits}.+-"]* )
			die "seq: invalid base ${_Msh_seqO_B} floating point number: ${_Msh_seq_n}" ;;
		esac
	done


	let "_Msh_seqO_B > 10" && toupper _Msh_seq_first _Msh_seq_incr _Msh_seq_last


	_Msh_seq_L=0
	_Msh_seq_R=0
	for _Msh_seq_S in "${_Msh_seq_first#+}" "${_Msh_seq_incr#+}" "${_Msh_seq_last#+}"; do
		_Msh_seq_S=${_Msh_seq_S%.*}
		let "_Msh_seq_L < ${#_Msh_seq_S}" && _Msh_seq_L=${#_Msh_seq_S}
	done
	if isset _Msh_seqO_S; then
		_Msh_seq_R=${_Msh_seqO_S}
	else
		for _Msh_seq_S in "${_Msh_seq_first}" "${_Msh_seq_incr}" "${_Msh_seq_last}"; do
			str eq "${_Msh_seq_S}" "${_Msh_seq_S#*.}" && continue
			_Msh_seq_S=${_Msh_seq_S#*.}
			let "_Msh_seq_R < ${#_Msh_seq_S}" && _Msh_seq_R=${#_Msh_seq_S}
		done
	fi
	str in "${_Msh_seq_first}${_Msh_seq_incr}${_Msh_seq_last}" '.' && let "_Msh_seq_L += 1"
	unset -v  _Msh_seq_S


	if let "_Msh_seq_L + _Msh_seq_R > 69"; then

		_Msh_seq_cmd="_Msh_seq_bc | _Msh_seq_unwrap"
	else
		_Msh_seq_cmd="_Msh_seq_bc"
	fi
	if isset _Msh_seqO_f; then
		let "_Msh_seqO_b == 10" || die "seq: '-f' can only be used with output base 10 (is ${_Msh_seqO_b})"
		_Msh_seq_cmd="${_Msh_seq_cmd} | _Msh_seq_awk -v \"f=\${_Msh_seqO_f}\" '{ printf( (f)(\"\\n\"), \$0); }'"
	elif isset _Msh_seqO_w; then
		_Msh_seq_cmd="${_Msh_seq_cmd} | _Msh_seq_w"
	fi
	if isset _Msh_seqO_s && not str eq "${_Msh_seqO_s}" "$CCn"; then
		_Msh_seq_cmd="${_Msh_seq_cmd} | _Msh_seq_s"
	fi
	if isset _Msh_seqO_L; then
		case ${LC_ALL:-${LC_NUMERIC:-${LANG:-}}} in
		( C | POSIX | '' )
			;;
		( * )	{  _Msh_seqO_L=$(unset -f locale
				PATH=$DEFPATH exec locale decimal_point)
			} 2>/dev/null \
			&& str ne "${_Msh_seqO_L}" '.' \
			&& _Msh_seq_cmd="${_Msh_seq_cmd} | _Msh_seq_awk -v \"p=\${_Msh_seqO_L}\" '{ sub(/\\./, p); print; }'" ;;
		esac
	fi


	not isset _Msh_seqO_S && _Msh_seqO_noS='' || unset -v _Msh_seqO_noS







	eval "put \"
		${_Msh_seqO_S+scale = $((_Msh_seqO_S))}
		obase = $((_Msh_seqO_b))
		ibase = $((_Msh_seqO_B))

		f = ${_Msh_seq_first#+}
		i = ${_Msh_seq_incr#+}
		l = ${_Msh_seq_last#+}

		/* as in BSD 'seq', the default incr is -1 if first > last */
		if (i == 0) {
			if (f <= l) i = 1
			if (f > l) i = -1
		}

		/* do the seq */
		if (i < 0) {
			for (n = f${_Msh_seqO_noS++i+l-i-l}; n >= l; n += i) {
				n${_Msh_seqO_S+/1}
			}
		}
		if (i > 0) {
			for (n = f${_Msh_seqO_noS++i+l-i-l}; n <= l; n += i) {
				n${_Msh_seqO_S+/1}
			}
		}
	\" | ${_Msh_seq_cmd}"
	unset -v _Msh_seq_first _Msh_seq_incr _Msh_seq_last _Msh_seq_n _Msh_seq_digits _Msh_seq_cmd \
		_Msh_seq_L _Msh_seq_R _Msh_seq_S \
		_Msh_seqO_w _Msh_seqO_L _Msh_seqO_s _Msh_seqO_f _Msh_seqO_B _Msh_seqO_b _Msh_seqO_S _Msh_seqO_noS
}

if thisshellhas ROFUNC; then
	readonly -f _Msh_seq_bc _Msh_seq_awk _Msh_seq_s _Msh_seq_w _Msh_seq_unwrap seq
fi
