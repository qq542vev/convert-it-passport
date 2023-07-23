#!/usr/bin/env sh

case "${0}" in
	*'/'*) basedir="${0%/*}";;
	*) basedir=".";;
esac

find -- "${basedir}/bin" -type f -exec "${basedir}/modernish/install.sh" -B -D 'release' -d '/' -s '/bin/sh' -- "{}" '+'

find -- "${basedir}/lib" -type f -exec cp -- '{}' 'release/lib' ';'
