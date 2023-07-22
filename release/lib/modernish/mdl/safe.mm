#! /module/for/moderni/sh
\command unalias command_not_found_handle command_not_found_handler g s _Msh_g_help _Msh_g_show _Msh_s_help _Msh_s_show 2>/dev/null

unset -v _Msh_safe_k
shift
while let "$#"; do
	case $1 in
	( -k )	_Msh_safe_k=y ;;
	( -K )	_Msh_safe_k=Y ;;
	( -[!-]?* )
		_Msh__o=${1#-}; shift
		while not str empty "${_Msh__o}"; do
			set -- "-${_Msh__o#"${_Msh__o%?}"}" "$@"; _Msh__o=${_Msh__o%?}	#"
		done; unset -v _Msh__o; continue ;;
	( * )	putln "safe.mm: invalid option: $1"
		return 1 ;;
	esac
	shift
done


IFS=''

set -o noglob


set -o nounset

set -o noclobber

if isset _Msh_safe_k; then
	unset -v MSH_NOT_FOUND_OK

	command_not_found_handler() { return 42; }
	command_not_found_handle()  { return 43; }
	COMMAND_NOT_FOUND_HANDLER='HANDLED=y; setstatus 44';
	PATH=/dev/null A09BB171-7AD4-4866-BED3-85D6E6A62288 2>/dev/null
	case $? in
	( 42 )	command_not_found_handler() { isset MSH_NOT_FOUND_OK && return 127 || die "command not found: $1"; }
		thisshellhas ROFUNC && readonly -f command_not_found_handler
		unset -f command_not_found_handle
		unset -v _Msh_safe_k COMMAND_NOT_FOUND_HANDLER
		;;
	( 43 )	command_not_found_handle() { isset MSH_NOT_FOUND_OK && return 127 || die "command not found: $1"; }
		thisshellhas ROFUNC && readonly -f command_not_found_handle
		unset -f command_not_found_handler
		unset -v _Msh_safe_k COMMAND_NOT_FOUND_HANDLER
		;;
	( 44 )	COMMAND_NOT_FOUND_HANDLER='HANDLED=y; if isset MSH_NOT_FOUND_OK; then setstatus 127; '
		COMMAND_NOT_FOUND_HANDLER=${COMMAND_NOT_FOUND_HANDLER}'else die "command not found: $1"; fi'
		readonly COMMAND_NOT_FOUND_HANDLER
		unset -f command_not_found_handler command_not_found_handle
		unset -v _Msh_safe_k
		;;
	( * )	unset -f command_not_found_handle command_not_found_handler
		unset -v COMMAND_NOT_FOUND_HANDLER
		if str eq ${_Msh_safe_k} Y; then
			putln "safe.mm: -K given, but shell does not support intercepting command not found"
			unset -v _Msh_safe_k
			return 1
		fi
		unset -v _Msh_safe_k ;;
	esac
fi
