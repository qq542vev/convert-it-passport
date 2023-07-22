#! /module/for/moderni/sh
\command unalias assign 2>/dev/null

assign() {
	case $# in
	( 0 )	die "assign: no arguments" ;;
	esac
	_Msh_a_r=
	for _Msh_a_V do
		case ${_Msh_a_V} in
		( *=* )	;;
		( -r )	_Msh_a_r=r; continue ;;
		( +r )	_Msh_a_r=; continue ;;
		( [+-]* )
			die "assign: invalid option: ${_Msh_a_V}" ;;
		( * )	die "assign: not an assignment-argument: ${_Msh_a_V}" ;;
		esac
		_Msh_a_W=${_Msh_a_V#*=}
		_Msh_a_V=${_Msh_a_V%%=*}
		case ${_Msh_a_V} in
		( [0123456789]* | *[!"$ASCIIALNUM"_]* )
			die "assign: invalid variable name: ${_Msh_a_V}" ;;
		esac
		case ${_Msh_a_r} in
		( r )	case ${_Msh_a_W} in
			( [0123456789]* | *[!"$ASCIIALNUM"_]* )
				die "assign: invalid reference variable name: ${_Msh_a_W}" ;;
			esac
			command eval "${_Msh_a_V}=\${${_Msh_a_W}}" ;;
		( * )	command eval "${_Msh_a_V}=\${_Msh_a_W}" ;;
		esac || die "assign: assignment failed"
	done
	unset -v _Msh_a_V _Msh_a_W _Msh_a_r
}

if thisshellhas ROFUNC; then
	readonly -f assign
fi
