#! /module/for/moderni/sh
\command unalias DO DONE LOOP _Msh_loop _Msh_loop_c _Msh_loop_setE _Msh_loopgen _loop_checkvarname _loop_die _loop_reallyunsetIFS 2>/dev/null


if thisshellhas WRN_NOSIGPIPE BUG_PUTIOERR; then
	putln	"var/loop: SIGPIPE is being ignored, and this shell cannot check for output" \
		"          errors due to BUG_PUTIOERR. This would cause this module to leave" \
		"          background processes hanging in infinite loops. Try again without" \
		"          SIGPIPE ignored, or run modernish on another shell. Aborting."
	return 1
fi

use var/shellquote



alias LOOP='{ { { _Msh_loop'

if thisshellhas LINENO && not thisshellhas BUG_LNNONEG && eval "let \"\$LINENO != $LINENO\""; then

	_loop_Ln=' _loop_Ln=${LINENO-}'
else
	_loop_Ln=''
fi
alias DO="}; _Msh_loop_c && while _loop_E=0${_loop_Ln}; IFS= read -r _loop_i <&8 && eval \" \${_loop_i}\"; do { "
unset -v _loop_Ln

if thisshellhas BUG_SCLOSEDFD; then
	alias DONE='} 8<&-; done; } 8</dev/null 8<&-; _Msh_loop_setE; }'
else
	alias DONE='} 8<&-; done; } 8<&-; _Msh_loop_setE; }'


fi




_Msh_loop() {

	if ! command : 3>&2; then
		_Msh_loop "$@" 2>/dev/null
		return
	elif ! { command : 3<&0; } 2>/dev/null; then
		_Msh_loop "$@" </dev/null
		return
	fi


	case ${1-} in ( '' ) die "LOOP: type expected" ;; esac
	command unalias "_loopgen_$1" 2>/dev/null
	if ! PATH=/dev/null command -v "_loopgen_$1" >/dev/null; then
		str isvarname "x$1" || die "LOOP: invalid type: $1"

		use -e "var/loop/$1" || die "LOOP: no such loop: $1"
		use "var/loop/$1"
		PATH=/dev/null command -v "_loopgen_$1" >/dev/null \
			|| die "LOOP: internal error: var/loop/$1.mm has no _loopgen_$1 function"
	fi


	_Msh_loopgen "$@"
}
if thisshellhas PROCSUBST; then

	eval '_Msh_loopgen() {
		exec 8<&0
		exec 8< <(
			set -fCu +ax
			IFS=""
			exec 0<&8 8>&1 1>&2
			readonly _loop_type=$1
			shift
			_loopgen_${_loop_type} "$@"
		)
	}'
elif isset BASH_VERSION && isset -o posix && (
	set +o posix; (command umask 777; eval 'IFS= read -r _Msh_test < <(putln PROCSUBST)' && str eq "${_Msh_test}" PROCSUBST)
) </dev/null 2>/dev/null; then


	eval '_Msh_loopgen() {
		exec 8<&0
		set +o posix
		eval '\''exec 8< <(
			set -o posix -fCu +ax
			IFS=""
			exec 0<&8 8>&1 1>&2
			readonly _loop_type=$1
			shift
			_loopgen_${_loop_type} "$@"
		)'\''
		set -o posix
	}'
elif thisshellhas PROCREDIR; then

	eval '_Msh_loopgen() {
		exec 8<&0
		exec 8<(
			set -fCu +ax
			IFS=""
			exec 0<&8 8>&1 1>&2
			readonly _loop_type=$1
			shift
			_loopgen_${_loop_type} "$@"
		)
	}'
else _Msh_loopgen() {






	until

		_Msh_FIFO=${XDG_RUNTIME_DIR:-${TMPDIR:-/tmp}}/_loopFIFO_${$}_${RANDOM:-0} &&
		until (	command umask 077
			PATH=$DEFPATH
			unset -f mkfifo
			exec mkfifo "${_Msh_FIFO}" ) 2>/dev/null
		do
			_Msh_E=$?
			case ${_Msh_E} in
			( ? | ?? | 1[01]? | 12[012345] )
				is -L dir "${_Msh_FIFO%/*}" || die "LOOP: system error: temp dir '${_Msh_FIFO%/*}' not found"
				can write "${_Msh_FIFO%/*}" || die "LOOP: system error: temp dir '${_Msh_FIFO%/*}' not writable"

				_Msh_FIFO=${_Msh_FIFO%/*}/_loopFIFO_${$}_${RANDOM:-$(( ${_Msh_FIFO##*FIFO_${$}_} + 1 ))}
				continue ;;
			( 126 ) die "LOOP: system error: could not invoke 'mkfifo'" ;;
			( 127 ) die "LOOP: system error: 'mkfifo' not found" ;;
			( * )	die "LOOP: system error: 'mkfifo' failed with status ${_Msh_E}" ;;
			esac
		done &&



		{
			( set -fCu +ax
			  IFS=''
			  exec 0<&8 8>${_Msh_FIFO}
			  unset -v _Msh_FIFO _Msh_E
			  readonly _loop_type=$1
			  shift
			  putln LOOPOK$$ >&8
			  _loopgen_${_loop_type} "$@"
			) &
		} 1>&2 8<&0 &&

		{ thisshellhas BUG_CMDEXEC && exec 8<"${_Msh_FIFO}" || command exec 8<"${_Msh_FIFO}"
		} 2>/dev/null &&
		IFS= read -r _Msh_E <&8 &&
		str eq "${_Msh_E}" "LOOPOK$$"
	do




		exec 8<&-
			PATH=$DEFPATH command kill -s PIPE "$!" 2>/dev/null
			PATH=$DEFPATH command kill -s TERM "$!" 2>/dev/null
			PATH=$DEFPATH command kill -s KILL "$!" 2>/dev/null
		is fifo "${_Msh_FIFO}" || die "LOOP: internal error: the FIFO disappeared"
		can read "${_Msh_FIFO}" || die "LOOP: internal error: no read permission on the FIFO"
		PATH=$DEFPATH command rm "${_Msh_FIFO}" || die "LOOP: internal error: can't remove failed FIFO"
		if isset _loop_DEBUG; then putln "[DEBUG] LOOP $1: RACE CONDITION CAUGHT! Cleanup done. Retrying." >&2; fi
	done




		(PATH=$DEFPATH
		unset -f rm
		exec rm -f "${_Msh_FIFO}") &
	unset -v _Msh_FIFO _Msh_E
}; fi


_Msh_loop_c() {
	command : <&8 || die "LOOP: lost connection to iteration generator"
}


_Msh_loop_setE() {

	eval "unset -v _loop_i _loop_E _loop_Ln; return ${_loop_E}"
}




if thisshellhas LINENO && not thisshellhas BUG_LNNONEG; then
	if eval "let \"\$LINENO != $LINENO\""; then
		_loop_die() {
			eval shellquoteparams
			put "die \"LOOP ${_loop_type-} (line \${_loop_Ln-}):\" $@$CCn" >&8 || eval "die LOOP ${_loop_type}: $@"
			exit 128
		}
	else
		_loop_die() {
			eval shellquoteparams
			put "die \"LOOP ${_loop_type-} (line \${LINENO-}):\" $@$CCn" >&8 || eval "die LOOP ${_loop_type}: $@"
			exit 128
		}
	fi
else
	_loop_die() {
		eval shellquoteparams
		put "die \"LOOP ${_loop_type-}:\" $@$CCn" >&8 || eval "die LOOP ${_loop_type}: $@"
		exit 128
	}
fi


_loop_checkvarname() {
	case $# in
	( [!1] | ??* )
		die "_loop_checkvarname: expected 1 argument, got $#" ;;
	esac
	str isvarname "$1" || _loop_die "invalid variable name: $1"
	case $1 in
	( _Msh_* | _loop_* )
		_loop_die "variable name is in internal namespace: $1" ;;
	esac
}


if thisshellhas QRK_LOCALUNS || thisshellhas QRK_LOCALUNS2; then

	_loop_reallyunsetIFS() {
		while isset IFS; do
			unset -v IFS
		done
	}
else
	_loop_reallyunsetIFS() {
		unset -v IFS
	}
fi


if thisshellhas ROFUNC; then
	readonly -f _Msh_loop _Msh_loopgen _Msh_loop_c _Msh_loop_setE _loop_die _loop_checkvarname _loop_reallyunsetIFS
fi
