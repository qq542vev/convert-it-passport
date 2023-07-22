#! /module/for/moderni/sh
\command unalias % _Msh_procsubst 2>/dev/null


command alias %='_Msh_procsubst'
_Msh_procsubst() {

	unset -v _Msh_pSo_o
	while	case ${1-} in
		( -i )	unset -v _Msh_pSo_o ;;
		( -o )	_Msh_pSo_o= ;;
		( -- )	shift; break ;;
		( -* )	die "%: invalid option: $1" ;;
		( * )	break ;;
		esac
	do
		shift
	done
	case $# in
	( 0 )	die "%: no command given" ;;
	esac
	case $1 in
	( '' )	die "%: empty command" ;;
	esac


	_Msh_FIFO=${XDG_RUNTIME_DIR:-${TMPDIR:-/tmp}}/_Msh_FIFO_${$}_${BASHPID:-$( : & put "$!" )}
	until (	command umask 077
		PATH=$DEFPATH
		unset -f mkfifo
		exec mkfifo "${_Msh_FIFO}" ) 2>/dev/null
	do
		_Msh_E=$?
		case ${_Msh_E} in
		( ? | ?? | 1[01]? | 12[012345] )
			is -L dir "${_Msh_FIFO%/*}" || die "%: system error: temp dir '${_Msh_FIFO%/*}' not found"
			can write "${_Msh_FIFO%/*}" || die "%: system error: temp dir '${_Msh_FIFO%/*}' not writable"

			_Msh_FIFO=${_Msh_FIFO%/*}/_Msh_FIFO_${$}_${RANDOM:-$(( ${_Msh_FIFO##*FIFO_${$}_} + 1 ))}
			continue ;;
		( 126 ) die "%: system error: could not invoke 'mkfifo'" ;;
		( 127 ) die "%: system error: 'mkfifo' not found" ;;
		( * )	use -q var/stack/trap && thisshellhas "--sig=${_Msh_E}" && die "%: 'mkfifo' killed by SIG$REPLY"
			die "%: system error: 'mkfifo' failed" ;;
		esac
	done


	putln "${_Msh_FIFO}"


	command : >&2 && exec >&2 || exec >&-


	(

		isset _Msh_pSo_o && exec <"${_Msh_FIFO}" || exec >"${_Msh_FIFO}"
		PATH=$DEFPATH command rm -f "${_Msh_FIFO}" &


		case ${1-} in
		( command )
			shift
			command "$@" ;;
		( * )
			"$@" ;;
		esac
	) &

}

if thisshellhas ROFUNC; then
	readonly -f _Msh_procsubst
fi
