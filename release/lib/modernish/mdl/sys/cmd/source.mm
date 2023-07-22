#! /module/for/moderni/sh
\command unalias source _Msh_doSource 2>/dev/null


unset -f source
command alias source='_Msh_doSource "$#" "$@"'
_Msh_doSource() {
	let "$# > ( $1 + 1 )" || die "source: need at least 1 argument, got 0"
	eval "_Msh_source_S=\${$(( $1 + 2 ))}"

	if let "$# > ( $1 + 2 )"; then


		shift "$(( $1 + 2 ))"
	else


		_Msh_source_P=''
		_Msh_source_i=1
		while let "(_Msh_source_i+=1) < $#"; do
			_Msh_source_P="${_Msh_source_P} \"\${${_Msh_source_i}}\""
		done
		eval "set -- ${_Msh_source_P}"
		unset -v _Msh_source_P _Msh_source_i
	fi


	case ${_Msh_source_S} in
	( */* ) ;;
	( * )	if is -L reg "${_Msh_source_S}"; then
			_Msh_source_S=./${_Msh_source_S}
		fi ;;
	esac


	is -L dir  "${_Msh_source_S}" && die "source: is a directory: ${_Msh_source_S}"
	can read "${_Msh_source_S}" || die "source: not found or can't read: ${_Msh_source_S}"

	. "${_Msh_source_S}"
	eval "unset -v _Msh_source_S; return $?"
}

if thisshellhas ROFUNC; then
	readonly -f _Msh_doSource
fi
