#! /module/for/moderni/sh
\command unalias rev 2>/dev/null



_Msh_rev_sedscript='
		G
		:rev
		s/\(.\)\(\n.*\)/\2\1/
		t rev
		s/.//
	'

case ${LC_ALL:-${LC_CTYPE:-${LANG:-}}} in
( *[Uu][Tt][Ff]8* | *[Uu][Tt][Ff]-8* )

	push IFS -f; IFS=; set -f
	unset -v _Msh_rev_sed
	for _Msh_rev_u in sed bsdsed gsed gnused; do
		_Msh_rev_done=:
		IFS=':'; for _Msh_rev_dir in $DEFPATH $PATH; do IFS=
			str begin ${_Msh_rev_dir} '/' || continue
			str in ${_Msh_rev_done} :${_Msh_rev_dir}: && continue
			if can exec ${_Msh_rev_dir}/${_Msh_rev_u} \
			&& str eq $(putln 'mĳn δéjà_вю' | ${_Msh_rev_dir}/${_Msh_rev_u} ${_Msh_rev_sedscript}) 'юв_àjéδ nĳm'
			then
				_Msh_rev_sed=${_Msh_rev_dir}/${_Msh_rev_u}
				break 2
			fi
			_Msh_rev_done=${_Msh_rev_done}${_Msh_rev_dir}:
		done
	done
	unset -v _Msh_rev_done _Msh_rev_dir _Msh_rev_u
	pop IFS -f
	if not isset _Msh_rev_sed; then
		putln "sys/base/rev: WARNING: cannot find a UTF-8 capable 'sed';" \
		      "              reversing UTF-8 text is broken." >&2
		_Msh_rev_sed=$(PATH=$DEFPATH; command -v sed)
	fi ;;
( * )
	_Msh_rev_sed=$(PATH=$DEFPATH; command -v sed) ;;
esac
if	! case ${_Msh_rev_sed} in
	( /* )	can exec "${_Msh_rev_sed}" ;;
	( * )	thisshellhas "--bi=${_Msh_rev_sed}" && _Msh_rev_sed="PATH=\$DEFPATH command ${_Msh_rev_sed}" ;;
	esac
then
	putln "sys/base/rev: Can't find a functioning 'sed'" >&2
	return 1
fi

case ${_Msh_rev_sed} in
( /*[!$SHELLSAFECHARS]* )

	_Msh_rev_sed=$(putln "${_Msh_rev_sed}" | "${_Msh_rev_sed}" "s/'/'\\\\''/g; 1 s/^/'/; \$ s/\$/'/") ;;
esac

eval 'rev() {
	case ${1-} in
	( -- )	shift ;;
	( -?* )	die "rev: invalid option: $1" ;;
	esac
	for _Msh_A do
		case ${_Msh_A} in
		( - )	set -- "$@" "./-" ;;
		( * )	set -- "$@" "${_Msh_A}" ;;
		esac
		shift
	done
	unset -v _Msh_A
	'"${_Msh_rev_sed} '${_Msh_rev_sedscript}'"' "$@"
}'

unset -v _Msh_rev_sed _Msh_rev_sedscript

if thisshellhas ROFUNC; then
	readonly -f rev
fi
