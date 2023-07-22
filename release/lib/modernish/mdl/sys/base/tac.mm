#! /module/for/moderni/sh
\command unalias tac _Msh_doTac 2>/dev/null


tac() {


	unset -v _Msh_tac_b _Msh_tac_B _Msh_tac_r _Msh_tac_P _Msh_tac_s
	while	case ${1-} in
		( -[!-]?* )
			_Msh_tac__o=$1
			shift
			while _Msh_tac__o=${_Msh_tac__o#?} && not str empty "${_Msh_tac__o}"; do
				_Msh_tac__a=-${_Msh_tac__o%"${_Msh_tac__o#?}"}
				push _Msh_tac__a
				case ${_Msh_tac__o} in
				( [s]* )
					_Msh_tac__a=${_Msh_tac__o#?}
					not str empty "${_Msh_tac__a}" && push _Msh_tac__a && break ;;
				esac
			done
			while pop _Msh_tac__a; do
				set -- "${_Msh_tac__a}" "$@"
			done
			unset -v _Msh_tac__o _Msh_tac__a
			continue ;;
		( -[bBrP] )
			eval "_Msh_tac_${1#-}=''" ;;
		( -s )	let "$# > 1" || die "tac: -s: option requires argument"
			_Msh_tac_s=$2
			shift ;;
		( -- )	shift; break ;;
		( -* )	die "tac: invalid option: $1" ;;
		( * )	break ;;
		esac
	do
		shift
	done



	if isset _Msh_tac_P; then
		if isset _Msh_tac_b || isset _Msh_tac_B || isset _Msh_tac_s; then
			die "tac: -P is incompatible with -b/-B/-s"
		fi
	fi
	if isset _Msh_tac_b && isset _Msh_tac_B; then
		die "tac: -b is incompatible with -B"
	fi
	if isset _Msh_tac_s; then
		if str empty "${_Msh_tac_s}"; then
			die "tac: separator cannot be empty"
		fi
	else
		_Msh_tac_s=$CCn
	fi


	if let "$#"; then
		PATH=$DEFPATH command cat -- "$@" | _Msh_doTac
	else
		_Msh_doTac
	fi


	_Msh_E=$?
	case ${_Msh_E} in
	( 0 | $SIGPIPESTATUS )
		eval "unset -v _Msh_E _Msh_tac_s _Msh_tac_b _Msh_tac_B _Msh_tac_r _Msh_tac_P; return ${_Msh_E}" ;;
	( * )	die "tac: awk failed with status ${_Msh_E}" ;;
	esac
}

_Msh_doTac()
(

	export "PATH=$DEFPATH" POSIXLY_CORRECT=y _Msh_tac_s \
		${_Msh_tac_b+_Msh_tac_b} ${_Msh_tac_B+_Msh_tac_B} ${_Msh_tac_r+_Msh_tac_r}
	unset -f awk

	if isset _Msh_tac_P; then

		exec awk '
		BEGIN {
			RS = "";
		}

		{
			p[NR] = $0;
		}

		END {
			if (NR) {
				for (i = NR; i > 1; i--) {
					print (p[i])("\n");
				}
				print p[i];
			}
		}'

	else

		exec awk -v ematch_lib=tac -f "$MSH_AUX/ematch.awk" -f "$MSH_AUX/sys/base/tac.awk"
	fi
)

if thisshellhas ROFUNC; then
	readonly -f tac _Msh_doTac
fi
