#! /module/for/moderni/sh
\command unalias append prepend 2>/dev/null


use var/shellquote

if thisshellhas ADDASSIGN ARITHCMD ARITHPP; then


	append() {
		_Msh_aS_Q=n
		_Msh_aS_s=' '
		while	case ${1-} in
			( --sep=* )
				_Msh_aS_s=${1#--sep=} ;;
			( -Q )	_Msh_aS_Q=y ;;
			( -- )	! shift ;;
			( -* )	die "append: invalid option: $1" ;;
			( * )	! : ;;
			esac
		do
			shift
		done
		case ${_Msh_aS_Q},${#},${1-},${_Msh_aS_s} in
		( ?,0,,"${_Msh_aS_s}" )
			die "append: variable name expected" ;;
		( ?,"$#",,"${_Msh_aS_s}" | ?,"$#",[0123456789]*,"${_Msh_aS_s}" | ?,"$#",*[!"$ASCIIALNUM"_]*,"${_Msh_aS_s}" )
			die "append: invalid variable name: $1" ;;


		( ?,1,* ) ;;


		( n,2,* )
			eval "$1+=\${$1:+\${_Msh_aS_s}}\$2" ;;



		( n,*,"${1-}", | n,*,"${1-}",? )
			isset IFS && _Msh_aS_IFS=$IFS || unset -v _Msh_aS_IFS
			IFS=${_Msh_aS_s}
			eval "shift; $1+=\${$1:+\$IFS}\$*"
			isset _Msh_aS_IFS && IFS=${_Msh_aS_IFS} && unset -v _Msh_aS_IFS || unset -v IFS ;;


		( n,* )	_Msh_aS_i=2
			while ((++_Msh_aS_i < $#)); do
				eval "$1+=\${$1:+\${_Msh_aS_s}}\${${_Msh_aS_i}}"
			done
			unset -v _Msh_aS_i ;;


		( y,2,* )
			shellquote -f _Msh_aS_V="$2"
			eval "$1+=\${$1:+\${_Msh_aS_s}}\${_Msh_aS_V}"
			unset -v _Msh_aS_V ;;


		( y,* )	_Msh_aS_i=2
			while ((++_Msh_aS_i < $#)); do
				eval "shellquote -f _Msh_aS_V=\"\${${_Msh_aS_i}}\"
					$1+=\${$1:+\${_Msh_aS_s}}\${_Msh_aS_V}"
			done
			unset -v _Msh_aS_i _Msh_aS_V ;;
		esac

		unset -v _Msh_aS_s _Msh_aS_Q
	}
else
	append() {
		_Msh_aS_Q=n
		_Msh_aS_s=' '
		while	case ${1-} in
			( --sep=* )
				_Msh_aS_s=${1#--sep=} ;;
			( -Q )	_Msh_aS_Q=y ;;
			( -- )	! shift ;;
			( -* )	die "append: invalid option: $1" ;;
			( * )	! : ;;
			esac
		do
			shift
		done
		case ${_Msh_aS_Q},${#},${1-},${_Msh_aS_s} in
		( ?,0,,"${_Msh_aS_s}" )
			die "append: variable name expected" ;;
		( ?,"$#",,"${_Msh_aS_s}" | ?,"$#",[0123456789]*,"${_Msh_aS_s}" | ?,"$#",*[!"$ASCIIALNUM"_]*,"${_Msh_aS_s}" )
			die "append: invalid variable name: $1" ;;


		( ?,1,* ) ;;


		( n,2,* )
			eval "$1=\${$1:+\$$1\${_Msh_aS_s}}\$2" ;;



		( n,*,"${1-}", | n,*,"${1-}",? )
			isset IFS && _Msh_aS_IFS=$IFS || unset -v _Msh_aS_IFS
			IFS=${_Msh_aS_s}
			eval "shift; $1=\${$1:+\$$1\$IFS}\$*"
			isset _Msh_aS_IFS && IFS=${_Msh_aS_IFS} && unset -v _Msh_aS_IFS || unset -v IFS ;;


		( n,* )	_Msh_aS_i=1
			while let "(_Msh_aS_i+=1) <= $#"; do
				eval "$1=\${$1:+\$$1\${_Msh_aS_s}}\${${_Msh_aS_i}}"
			done
			unset -v _Msh_aS_i ;;


		( y,2,* )
			shellquote -f _Msh_aS_V="$2"
			eval "$1=\${$1:+\$$1\${_Msh_aS_s}}\${_Msh_aS_V}"
			unset -v _Msh_aS_V ;;


		( y,* )	_Msh_aS_i=1
			while let "(_Msh_aS_i+=1) <= $#"; do
				eval "shellquote -f _Msh_aS_V=\"\${${_Msh_aS_i}}\"
					$1=\${$1:+\$$1\${_Msh_aS_s}}\${_Msh_aS_V}"
			done
			unset -v _Msh_aS_i _Msh_aS_V ;;
		esac

		unset -v _Msh_aS_s _Msh_aS_Q
	}
fi

prepend() {
	_Msh_pS_Q=n
	_Msh_pS_s=' '
	while	case ${1-} in
		( --sep=* )
			_Msh_pS_s=${1#--sep=} ;;
		( -Q )	_Msh_pS_Q=y ;;
		( -- )	! shift ;;
		( -* )	die "prepend: invalid option: $1" ;;
		( * )	! : ;;
		esac
	do
		shift
	done
	case ${_Msh_pS_Q},${#},${1-},${_Msh_pS_s} in
	( ?,0,,"${_Msh_pS_s}" )
		die "prepend: variable name expected" ;;
	( ?,"$#",,"${_Msh_pS_s}" | ?,"$#",[0123456789]*,"${_Msh_pS_s}" | ?,"$#",*[!"$ASCIIALNUM"_]*,"${_Msh_pS_s}" )
		die "prepend: invalid variable name: $1" ;;


	( ?,1,* ) ;;


	( n,2,* )
		eval "$1=\$2\${$1:+\${_Msh_pS_s}\$$1}" ;;



	( n,*,"${1-}", | n,*,"${1-}",? )
		isset IFS && _Msh_pS_IFS=$IFS || unset -v _Msh_pS_IFS
		IFS=${_Msh_pS_s}
		eval "shift; $1=\$*\${$1:+\$IFS\$$1}"
		isset _Msh_pS_IFS && IFS=${_Msh_pS_IFS} && unset -v _Msh_pS_IFS || unset -v IFS ;;


	( n,* )	let "_Msh_pS_i=${#}+1"
		while let "(_Msh_pS_i-=1) >= 2"; do
			eval "$1=\${${_Msh_pS_i}}\${$1:+\${_Msh_pS_s}\$$1}"
		done
		unset -v _Msh_pS_i ;;


	( y,2,* )
		shellquote -f _Msh_pS_V="$2"
		eval "$1=\${_Msh_pS_V}\${$1:+\${_Msh_pS_s}\$$1}"
		unset -v _Msh_pS_V ;;


	( y,* )	let "_Msh_pS_i=${#}+1"
		while let "(_Msh_pS_i-=1) >= 2"; do
			eval "shellquote -f _Msh_pS_V=\"\${${_Msh_pS_i}}\"
				$1=\${_Msh_pS_V}\${$1:+\${_Msh_pS_s}\$$1}"
		done
		unset -v _Msh_pS_i _Msh_pS_V ;;
	esac

	unset -v _Msh_pS_s _Msh_pS_Q
}

if thisshellhas ROFUNC; then
	readonly -f append prepend
fi
