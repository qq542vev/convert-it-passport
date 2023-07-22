#! /module/for/moderni/sh
\command unalias unexport 2>/dev/null

if thisshellhas typeset && _Msh_test=no && command typeset --global --unexport _Msh_test=ok && str eq "${_Msh_test}" ok; then




	unexport() {
		case $# in
		( 0 )	die "unexport: need at least 1 argument, got $#" ;;
		esac
		typeset _Msh_V
		for _Msh_V do
			str isvarname "${_Msh_V%%=*}" || die "unexport: invalid variable name: ${_Msh_V%%=*}"
		done
		command typeset --global --unexport "$@" || die "unexport: 'typeset' failed"
	}
elif thisshellhas typeset KSH93FUNC && _Msh_test=no && command typeset +x _Msh_test=ok && str eq "${_Msh_test}" ok; then


	unexport() {
		case $# in
		( 0 )	die "unexport: need at least 1 argument, got $#" ;;
		esac
		for _Msh_nE_V do
			str isvarname "${_Msh_nE_V%%=*}" || die "unexport: invalid variable name: ${_Msh_nE_V%%=*}"
		done
		unset -v _Msh_nE_V
		command typeset +x "$@" || die "unexport: 'typeset' failed"
	}
elif thisshellhas typeset global && _Msh_test=no && command global +x _Msh_test=ok && str eq "${_Msh_test}" ok; then



	unexport() {
		case $# in
		( 0 )	die "unexport: need at least 1 argument, got $#" ;;
		esac
		typeset _Msh_V
		for _Msh_V do
			str isvarname "${_Msh_V%%=*}" || die "unexport: invalid variable name: ${_Msh_V%%=*}"
		done
		command global +x "$@" || die "unexport: 'global' failed"
	}
elif thisshellhas typeset && _Msh_test=no && command typeset -g +x _Msh_test=ok && str eq "${_Msh_test}" ok; then


	unexport() {
		case $# in
		( 0 )	die "unexport: need at least 1 argument, got $#" ;;
		esac
		typeset _Msh_V
		for _Msh_V do
			str isvarname "${_Msh_V%%=*}" || die "unexport: invalid variable name: ${_Msh_V%%=*}"
		done
		for _Msh_V do
			if isset "${_Msh_V%%=*}" || ! str eq "${_Msh_V%%=*}" "${_Msh_V}"; then
				command typeset -g +x "${_Msh_V}" || die "unexport: 'typeset' failed"
			else
				unset -v "${_Msh_V}"
			fi
		done
	}
else



	unexport() {
		case $# in
		( 0 )	die "unexport: need at least 1 argument, got $#" ;;
		esac
		for _Msh_nE_V do
			str isvarname "${_Msh_nE_V%%=*}" || die "unexport: invalid variable name: ${_Msh_nE_V%%=*}"
		done
		_Msh_nE_err=''
		case $- in
		( *a* ) _Msh_nE_a=y; set +a ;;
		( * )   _Msh_nE_a='' ;;
		esac
		for _Msh_nE_V do
			case ${_Msh_nE_V} in
			( *=* ) unset -v "${_Msh_nE_V%%=*}"
				command eval "${_Msh_nE_V%%=*}=\${_Msh_nE_V#*=}" ;;
			( * )   if isset "${_Msh_nE_V}"; then
					command eval "	_Msh_nE_val=\${${_Msh_nE_V}} &&
							unset -v ${_Msh_nE_V} &&
							${_Msh_nE_V}=\${_Msh_nE_val}"
				else
					command eval "${_Msh_nE_V}=" &&
					unset -v "${_Msh_nE_V}"
				fi || { _Msh_nE_err=y; break; }
			esac
		done
		case ${_Msh_nE_a} in
		( y )   set -a ;;
		esac
		case ${_Msh_nE_err} in
		( y )	die "unexport: assignment failed" ;;
		esac
		unset -v _Msh_nE_V _Msh_nE_val _Msh_nE_a _Msh_nE_err
	}
fi 2>/dev/null
unset -v _Msh_test

if thisshellhas ROFUNC; then
	readonly -f unexport
fi
