#!/usr/bin/env sh

case "${0}" in
	*'/'*) basedir="${0%/*}";;
	*) basedir=".";;
esac

"${basedir}/modernish/install.sh" -B -D 'release' -d '/' -s '/bin/sh' -- "${basedir}/bin/glossary-to-csv.sh" "${basedir}/bin/past-exam-questions-to-csv.sh"

find -- "${basedir}/lib" -type f -exec cp -- '{}' 'release/lib' ';'
