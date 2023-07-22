#! /module/for/moderni/sh
\command unalias countfiles 2>/dev/null


countfiles() {
	unset -v _Msh_cF_s
	while str begin "${1-}" '-'; do
		case $1 in
		( -s )	_Msh_cF_s=y ;;
		( -- )	shift; break ;;
		( * )	die "countfiles: invalid option: $1" ;;
		esac
		shift
	done
	case $# in
	( 0 )	die "countfiles: at least one non-option argument expected" ;;
	( 1 )	set -- "$1" '.[!.]*' '..?*' '*' ;;
	esac

	if not is -L dir "$1"; then
		die "countfiles: not a directory: $1"
	fi

	REPLY=0

	push IFS -f
	IFS=''
	set +f
	_Msh_cF_dir=$1
	shift
	str in "$*" / && { pop IFS -f; die "countfiles: directories in patterns not supported"; }
	for _Msh_cF_pat do
		set -- "${_Msh_cF_dir}"/${_Msh_cF_pat}
		if is present "$1"; then
			let REPLY+=$#
		fi
	done
	unset -v _Msh_cF_pat _Msh_cF_dir
	pop IFS -f
	isset _Msh_cF_s && unset -v _Msh_cF_s || putln "$REPLY"
}

if thisshellhas ROFUNC; then
	readonly -f countfiles
fi
