#! /shell/capability/test/for/moderni/sh


unset -v _Msh_test
case "$#,${1-},${2-}" in
( 2,one,two )	return 0 ;;
( 0,, )		return 1 ;;
( * )		putln "DOTARG: internal error ($#,${1-}.${2-})"
		return 2 ;;
esac
