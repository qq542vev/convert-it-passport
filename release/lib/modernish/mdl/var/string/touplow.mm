#! /module/for/moderni/sh
\command unalias tolower toupper _Msh_tmp_getWorkingTr _Msh_tmp_utf8pathSearch 2>/dev/null


unset -v MSH_2UP2LOW_NOUTF8

if thisshellhas KSH93FUNC; then


	_Msh_toupper_fn='function toupper {'
	_Msh_tolower_fn='function tolower {'
else
	_Msh_toupper_fn='toupper() {'
	_Msh_tolower_fn='tolower() {'
fi

_Msh_tmp_utf8pathSearch() {
	push IFS -f; IFS=; set -f
	_Msh_tul_arg=$1; shift
	for _Msh_tul_u do
		isset _Msh_tul_arg && eval "set -- ${_Msh_tul_arg}" && unset -v _Msh_tul_arg
		_Msh_tul_done=:
		IFS=':'; for _Msh_tul_dir in $DEFPATH $PATH; do IFS=
			str begin ${_Msh_tul_dir} '/' || continue
			str in ${_Msh_tul_done} :${_Msh_tul_dir}: && continue
			_Msh_tul_U=${_Msh_tul_dir}/${_Msh_tul_u}
			if can exec ${_Msh_tul_U} \
			&& str eq 'MĲN ΔÉJÀ_ВЮ' $(putln 'mĳn δéjà_вю' | "${_Msh_tul_U}" "$@" 2>/dev/null)
			then
				break 2
			fi
			_Msh_tul_done=${_Msh_tul_done}${_Msh_tul_dir}:
			unset -v _Msh_tul_U
		done
	done
	unset -v _Msh_tul_done _Msh_tul_dir _Msh_tul_u
	pop IFS -f
	isset _Msh_tul_U
}


_Msh_tmp_getWorkingTr() {
	_Msh_a1='${1}=\$(putln \"\${${1}}X\" | '
	_Msh_a2=' failed\"; ${1}=\${${1}%?}'

	case ${LC_ALL:-${LC_CTYPE:-${LANG:-}}} in
	( *[Uu][Tt][Ff]8* | *[Uu][Tt][Ff]-8* )

		if _Msh_tmp_utf8pathSearch "'[:lower:]' '[:upper:]'" tr gtr; then
			_Msh_tr1="${_Msh_a1}${_Msh_tul_U} "
			_Msh_tr2=": 'tr'${_Msh_a2}"
			_Msh_toupper_tr="${_Msh_tr1}'[:lower:]' '[:upper:]') || die \\\"toupper${_Msh_tr2}"
			_Msh_tolower_tr="${_Msh_tr1}'[:upper:]' '[:lower:]') || die \\\"tolower${_Msh_tr2}"
		elif _Msh_tmp_utf8pathSearch \''{print toupper($0)}'\' awk gawk; then
			_Msh_tr1="${_Msh_a1}${_Msh_tul_U} "
			_Msh_tr2=": 'awk'${_Msh_a2}"
			_Msh_toupper_tr="${_Msh_tr1}'{print toupper(\\\$0)}') || die \\\"toupper${_Msh_tr2}"
			_Msh_tolower_tr="${_Msh_tr1}'{print tolower(\\\$0)}') || die \\\"tolower${_Msh_tr2}"
		elif _Msh_tmp_utf8pathSearch \''s/\(.*\)/\U\1/'\' gnused gsed sed; then
			_Msh_tr1="${_Msh_a1}${_Msh_tul_U} "
			_Msh_tr2=": GNU 'sed'${_Msh_a2}"
			_Msh_toupper_tr="${_Msh_tr1}'s/\\(.*\\)/\\U\\1/') || die \\\"toupper${_Msh_tr2}"
			_Msh_tolower_tr="${_Msh_tr1}'s/\\(.*\\)/\\L\\1/') || die \\\"tolower${_Msh_tr2}"
		else

			_Msh_tr1="${_Msh_a1}LC_ALL=C PATH=\\\$DEFPATH command tr "
			_Msh_tr2=": 'tr'${_Msh_a2}"
			_Msh_toupper_tr="${_Msh_tr1}a-z A-Z) || die \\\"toupper${_Msh_tr2}"
			_Msh_tolower_tr="${_Msh_tr1}A-Z a-z) || die \\\"tolower${_Msh_tr2}"

			unset -v _Msh_a1 _Msh_a2 _Msh_tr1 _Msh_tr2
			putln "var/string/touplow: warning: cannot convert case in UTF-8 characters" >&2
			MSH_2UP2LOW_NOUTF8=y
			return 1
		fi
		unset -v _Msh_tul_U ;;
	( * )
		_Msh_test=$(putln 'abcxyz' | PATH=$DEFPATH exec tr '[:lower:]' '[:upper:]')
		_Msh_tr1="${_Msh_a1}PATH=\\\$DEFPATH command tr "
		_Msh_tr2=": 'tr'${_Msh_a2}"
		case ${_Msh_test} in
		(ABCXYZ)_Msh_toupper_tr="${_Msh_tr1}'[:lower:]' '[:upper:]') || die \\\"toupper${_Msh_tr2}"
			_Msh_tolower_tr="${_Msh_tr1}'[:upper:]' '[:lower:]') || die \\\"tolower${_Msh_tr2}" ;;
		( * )	_Msh_toupper_tr="${_Msh_tr1}'[a-z]' '[A-Z]') || die \\\"toupper${_Msh_tr2}"
			_Msh_tolower_tr="${_Msh_tr1}'[A-Z]' '[a-z]') || die \\\"tolower${_Msh_tr2}" ;;
		esac
	esac
	unset -v _Msh_a1 _Msh_a2 _Msh_tr1 _Msh_tr2
}

if thisshellhas typeset &&
	command typeset -u _Msh_test 2>/dev/null && _Msh_test=gr@lDru1S && str eq "${_Msh_test}" GR@LDRU1S && unset -v _Msh_test &&
	command typeset -l _Msh_test 2>/dev/null && _Msh_test=gr@lDru1S && str eq "${_Msh_test}" gr@ldru1s && unset -v _Msh_test &&

	_Msh_toupper_ts='command typeset -u mystring; mystring=\$${1}; ${1}=\$mystring' &&
	_Msh_tolower_ts='command typeset -l mystring; mystring=\$${1}; ${1}=\$mystring' &&



	case ${LC_ALL:-${LC_CTYPE:-${LANG:-}}} in
	( *[Uu][Tt][Ff]8* | *[Uu][Tt][Ff]-8* )
		command typeset -u _Msh_test
		_Msh_test='mĳn δéjà_вю'
		case ${_Msh_test} in
		( 'MĲN ΔÉJÀ_ВЮ' )

			unset -v _Msh_test
			_Msh_toupper_tr=${_Msh_toupper_ts}
			_Msh_tolower_tr=${_Msh_tolower_ts} ;;
		( M*N\ *J*_* )

			unset -v _Msh_test
			if _Msh_tmp_getWorkingTr; then
				_Msh_case_nonascii='case \$${1} in ( *[!\"\$ASCIICHARS\"]* )'
				_Msh_toupper_tr="${_Msh_case_nonascii} ${_Msh_toupper_tr} ;; ( * ) ${_Msh_toupper_ts} ;; esac"
				_Msh_tolower_tr="${_Msh_case_nonascii} ${_Msh_tolower_tr} ;; ( * ) ${_Msh_tolower_ts} ;; esac"
				unset -v _Msh_case_nonascii
			else
				_Msh_toupper_tr=${_Msh_toupper_ts}
				_Msh_tolower_tr=${_Msh_tolower_ts}
			fi ;;
		( * )
			unset -v _Msh_test
			! : ;;
		esac ;;
	( * )
		_Msh_toupper_tr=${_Msh_toupper_ts}
		_Msh_tolower_tr=${_Msh_tolower_ts} ;;
	esac
then
	:
elif thisshellhas BUG_NOCHCLASS; then




	if _Msh_tmp_getWorkingTr; then
		_Msh_toupper_tr='case \$${1} in ( *[!\"\$ASCIICHARS\"]* | *[\"\$ASCIILOWER\"]* ) '"${_Msh_toupper_tr} ;; esac"
		_Msh_tolower_tr='case \$${1} in ( *[!\"\$ASCIICHARS\"]* | *[\"\$ASCIIUPPER\"]* ) '"${_Msh_tolower_tr} ;; esac"
	else
		_Msh_toupper_tr='case \$${1} in ( *[\"\$ASCIILOWER\"]* ) '"${_Msh_toupper_tr} ;; esac"
		_Msh_tolower_tr='case \$${1} in ( *[\"\$ASCIIUPPER\"]* ) '"${_Msh_tolower_tr} ;; esac"
	fi
elif thisshellhas WRN_MULTIBYTE; then



	if _Msh_tmp_getWorkingTr; then
		_Msh_toupper_tr='case \$${1} in ( *[!\"\$ASCIICHARS\"]* | *[[:lower:]]* ) '"${_Msh_toupper_tr} ;; esac"
		_Msh_tolower_tr='case \$${1} in ( *[!\"\$ASCIICHARS\"]* | *[[:upper:]]* ) '"${_Msh_tolower_tr} ;; esac"
	else
		_Msh_toupper_tr='case \$${1} in ( *[[:lower:]]* ) '"${_Msh_toupper_tr} ;; esac"
		_Msh_tolower_tr='case \$${1} in ( *[[:upper:]]* ) '"${_Msh_tolower_tr} ;; esac"
	fi
else

	_Msh_tmp_getWorkingTr
	_Msh_toupper_tr='case \$${1} in ( *[[:lower:]]* ) '"${_Msh_toupper_tr} ;; esac"
	_Msh_tolower_tr='case \$${1} in ( *[[:upper:]]* ) '"${_Msh_tolower_tr} ;; esac"
fi

eval "${_Msh_toupper_fn}"'
	let "$#" || die "toupper: need at least 1 argument, got $#"
	while	str isvarname "$1" || die "toupper: invalid variable name: $1"
		eval "'"${_Msh_toupper_tr}"'"
		shift
		let "$#"
	do :; done
}
'"${_Msh_tolower_fn}"'
	let "$#" || die "tolower: need at least 1 argument, got $#"
	while	str isvarname "$1" || die "tolower: invalid variable name: $1"
		eval "'"${_Msh_tolower_tr}"'"
		shift
		let "$#"
	do :; done
}'

unset -v _Msh_toupper_fn _Msh_tolower_fn _Msh_toupper_tr _Msh_tolower_tr _Msh_toupper_TR _Msh_tolower_TR \
	_Msh_toupper_ts _Msh_tolower_ts _Msh_test
unset -f _Msh_tmp_getWorkingTr _Msh_tmp_utf8pathSearch
readonly MSH_2UP2LOW_NOUTF8

if thisshellhas ROFUNC; then
	readonly -f toupper tolower
fi
