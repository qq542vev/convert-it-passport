#! helper/script/for/moderni/sh

_Msh_testFn() {

case ${DEFPATH+s} in
( '' )	DEFPATH=$(
		PATH=/run/current-system/sw/bin:/usr/xpg7/bin:/usr/xpg6/bin:/usr/xpg4/bin:/bin:/usr/bin:$PATH
		exec getconf PATH 2>/dev/null
	) || DEFPATH=/bin:/usr/bin:/sbin:/usr/sbin






	if test -e /etc/NIXOS && test -d /nix/var/nix/profiles/default/bin; then
		case :$DEFPATH: in
		( *:/nix/var/nix/profiles/default/bin:* )

			;;
		( * )
			case $DEFPATH in
			( *:* )	DEFPATH=${DEFPATH%%:*}:/nix/var/nix/profiles/default/bin:${DEFPATH#*:} ;;
			( * )	DEFPATH=$DEFPATH:/nix/var/nix/profiles/default/bin ;;
			esac
		esac
	fi




	if test -d /opt/freeware/bin; then
		case $(PATH=$DEFPATH command uname) in
		( AIX )	DEFPATH=/opt/freeware/bin:$DEFPATH ;;
		esac
	fi
	;;
esac

DEFPATH=$(
	PATH=$DEFPATH
	DEFPATH=
	set -f
	IFS=':'
	for _Msh_test in $PATH; do
		case ${_Msh_test} in ( '' ) continue;; esac
		case :$DEFPATH: in ( *:"${_Msh_test}":* ) continue;; esac
		DEFPATH=${DEFPATH:+$DEFPATH:}${_Msh_test}
	done
	printf '%s\nX' "$DEFPATH"
)
DEFPATH=${DEFPATH%?X}

case $DEFPATH in
( '' | [!/]* | *:[!/]* | *: )
	echo 'fatal: non-absolute path in DEFPATH' >&2
	return 128 ;;
esac
for _Msh_test in awk cat kill ls mkdir printf ps sed uname; do
	if ! PATH=$DEFPATH command -v "${_Msh_test}" >/dev/null 2>&1; then
		echo 'fatal: cannot find standard utilities in DEFPATH' >&2
		return 128
	fi
done

}
_Msh_testFn
