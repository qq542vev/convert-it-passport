#! /bin/sh
# Wrapper script to run glossary-to-csv.sh with bundled modernish

min_posix='cd -P -- / && ! { ! case x in ( x ) : ${0##*/} || : $( : ) ;; esac; }'
if (eval "$min_posix") 2>/dev/null; then
 	unset -v min_posix
else
 	# this is an ancient Bourne shell (e.g. Solaris 10)
 	sh -c "$min_posix" 2>/dev/null && exec sh -- "$0" ${1+"$@"}
 	DEFPATH=`getconf PATH` 2>/dev/null || DEFPATH=/usr/xpg4/bin:/bin:/usr/bin:/sbin:/usr/sbin
 	PATH=$DEFPATH:$PATH
 	export PATH
 	sh -c "$min_posix" 2>/dev/null && exec sh -- "$0" ${1+"$@"}
 	echo "$0: Can't escape from obsolete shell. Run me with a POSIX shell." >&2
 	exit 128
fi

unset -v CDPATH DEFPATH IFS MSH_PREFIX MSH_SHELL	# avoid these being inherited/exported
CCn='
'

# Find bundled modernish.
# ... First, if $0 is a symlink, resolve the symlink chain.
case $0 in
( */* )	linkdir=${0%/*} ;;
( * )	linkdir=. ;;
esac
me=$0
while test -L "$me"; do
 	newme=$(command ls -ld -- "$me" && echo X)
 	case $newme in
 	( *" $me -> "*${CCn}X ) ;;
 	( * )	echo "$0: resolve symlink: 'ls -ld' failed" >&2
 		exit 128 ;;
 	esac
 	newme=${newme#*" $me -> "}
 	newme=${newme%${CCn}X}
 	case $newme in
 	( /* )	me=$newme ;;
 	( * )	me=$linkdir/$newme ;;
 	esac
 	linkdir=${me%/*}
done
# ... Find my absolute and physical directory path.
case $me in
( */* )	MSH_PREFIX=${me%/*} ;;
( * )	MSH_PREFIX=. ;;
esac
case $MSH_PREFIX in
( */* | [!+-]* | *[!0123456789]* )
 	MSH_PREFIX=$(cd -P -- "$PWD" && cd -- "$MSH_PREFIX" && pwd -P && echo X) ;;
( * )	MSH_PREFIX=$(cd -P -- "$PWD" && cd "./$MSH_PREFIX" && pwd -P && echo X) ;;
esac || exit
MSH_PREFIX="${MSH_PREFIX%?X}"

# Get the system's default path.
. "$MSH_PREFIX/lib/modernish/aux/defpath.sh" || exit

# Verify preferred shell. Try this path first, then a shell by this name, then others.
MSH_SHELL=/bin/sh
. "$MSH_PREFIX/lib/modernish/aux/goodsh.sh" || exit
case $MSH_SHELL in
( */sh )	;;
( * )	echo glossary-to-csv.sh: "warning: sh shell not usable; running on $MSH_SHELL" >&2 ;;
esac

# Prefix launch arguments.
set -- "$MSH_PREFIX"/bin/glossary-to-csv.sh "$@"
PATH=$MSH_PREFIX/bin:$PATH	# make '. modernish' work

# Run bundled script.
export "_Msh_PREFIX=$MSH_PREFIX" "_Msh_SHELL=$MSH_SHELL" "_Msh_DEFPATH=$DEFPATH"
unset -v MSH_PREFIX MSH_SHELL DEFPATH	# avoid exporting these
test -d "${XDG_RUNTIME_DIR-}" && case $XDG_RUNTIME_DIR in (/*) ;; (*) ! : ;; esac || unset -v XDG_RUNTIME_DIR
test -d "${TMPDIR-}" && case $TMPDIR in (/*) ;; (*) ! : ;; esac || unset -v TMPDIR
case ${_Msh_SHELL##*/} in
(zsh*)	# Invoke zsh as sh from the get-go. Switching to emulation from within a script would be inadequate: this won't
 	# remove common lowercase variable names as special -- e.g., "$path" would still change "$PATH" when used.
 	# The '--emulate sh' cmdline option won't do either, as helper scripts invoked like '$MSH_SHELL -c ...' would
 	# find themselves in native zsh mode again. The only way is to use a 'sh' symlink for the duration of the script.
 	user_path=$PATH
 	PATH=${_Msh_DEFPATH}
 	unset -v zshdir
 	trap 'rm -rf "${zshdir-}" &' 0	# BUG_TRAPEXIT compat
 	for sig in INT PIPE TERM; do
 		trap 'rm -rf "${zshdir-}"; trap - '"$sig"' 0; kill -s '"$sig"' $$' "$sig"
 	done
 	zshdir=${XDG_RUNTIME_DIR:-${TMPDIR:-/tmp}}/_Msh_zsh.$$.$(date +%Y%m%d.%H%M%S).${RANDOM:-0}
 	mkdir -m700 "$zshdir" || exit
 	ln -s "${_Msh_SHELL}" "$zshdir/sh" || exit
 	_Msh_SHELL=$zshdir/sh
 	PATH=$user_path
 	"${_Msh_SHELL}" "$@"	# no 'exec', or the trap won't run
 	exit ;;
(bash*)	# Avoid inheriting exported functions.
 	exec "${_Msh_SHELL}" -p "$@" ;;
( * )	# Default: just run.
 	exec "${_Msh_SHELL}" "$@" ;;
esac
