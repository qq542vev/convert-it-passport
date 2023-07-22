#! /module/for/moderni/sh
\command unalias mktemp _Msh_mktemp_genSuffix 2>/dev/null


case $#,${2-} in
(2,-i)	_Msh_mktemp_insecure= ;;
( 1, )	unset -v _Msh_mktemp_insecure ;;
( * )	put "$1: invalid argument(s): $@$CCn"
	return 1 ;;
esac

use var/shellquote
use var/stack/trap


if is -L present /dev/urandom && not is -L reg /dev/urandom && not is -L dir /dev/urandom \
&& not isset _Msh_mktemp_insecure; then

	_Msh_mktemp_genSuffix() {
		is -L present /dev/urandom || exit 1 "mktemp: /dev/urandom not found"
		IFS=; set -f; export PATH=$DEFPATH LC_ALL=C; unset -f tr dd



		exec dd bs=$((16 * _Msh_mT_tlen)) count=1 </dev/urandom 2>/dev/null \
			| exec tr -dc ${ASCIIALNUM}%+,.:=@_^!- \
			| exec dd bs=${_Msh_mT_tlen} count=1 2>/dev/null
	}
else







	_Msh_srand=$(unset -f awk; PATH=$DEFPATH exec awk \
		'BEGIN { srand(); printf("%d", rand() * 2^32 - 2^31); }') || return 1
	let "_Msh_srand ^= $$ ^ ${RANDOM:-0}"

	_Msh_mktemp_genSuffix() {
		IFS=; set -f; export PATH=$DEFPATH LC_ALL=C POSIXLY_CORRECT=y; unset -f awk
		insubshell -p
		exec awk -v seed2=$(((REPLY % 32768) ^ ${RANDOM:-0})) \
			 -v seed=${_Msh_srand} \
			 -v len=${_Msh_mT_tlen} \
			 -v chars=${ASCIIALNUM}%+,.:=@_^!- \
		'BEGIN {
			ORS="";
			srand(seed);
			for (i=0; i<seed2; i++)
				rand();

			numchars=length(chars);
			for (i=0; i<len; i++)
				print substr(chars, rand()*numchars+1, 1);

			printf("/%d", rand() * 2^32 - 2^31);
		}'
	}
	unset -v _Msh_mktemp_insecure
fi


mktemp() {




	unset -v _Msh_mTo_d _Msh_mTo_F _Msh_mTo_s _Msh_mTo_Q _Msh_mTo_t
	_Msh_mTo_C=0
	while	case ${1-} in
		( -[!-]?* )
			_Msh_mTo__o=${1#-}
			shift
			while not str empty "${_Msh_mTo__o}"; do
				set -- "-${_Msh_mTo__o#"${_Msh_mTo__o%?}"}" "$@"	#"
				_Msh_mTo__o=${_Msh_mTo__o%?}
			done
			unset -v _Msh_mTo__o
			continue ;;
		( -[dFsQt] )
			eval "_Msh_mTo_${1#-}=''" ;;
		( -C )  let "_Msh_mTo_C += 1" ;;
		( -- )	shift; break ;;
		( --help )
			putln "modernish $MSH_VERSION sys/base/mktemp" \
				"usage: mktemp [ -dFsQCt ] [ TEMPLATE ... ]" \
				"   -d: Create directories instead of regular files." \
				"   -F: Create FIFOs (named pipes) instead of a regular files." \
				"   -s: Silent. Only store filenames in REPLY." \
				"   -Q: Shell-quote each pathname. Separate by spaces." \
				"   -C: Push trap to remove created files on exit." \
				"   -t: Prefix one temporary files directory to the templates."
			return ;;
		( -* )	die "mktemp: invalid option: $1" \
				"${CCn}usage:${CCt}mktemp [ -dFsQCt ] [ TEMPLATE ... ]" \
				"${CCn}${CCt}mktemp --help" ;;
		( * )	break ;;
		esac
	do
		shift
	done

	if isset _Msh_mTo_d && isset _Msh_mTo_F; then
		die "mktemp: options -d and -F are incompatible"
	fi
	if let "_Msh_mTo_C > 0" && not isset _Msh_mTo_s && insubshell; then
		die "mktemp: -C: auto-cleanup can't be set from a subshell${CCn}" \
			"(e.g. can't do v=\$(mktemp -C); instead do mktemp -sC; v=\$REPLY)"
	fi
	if isset _Msh_mTo_t; then
		if isset XDG_RUNTIME_DIR \
		&& str begin "$XDG_RUNTIME_DIR" '/' \
		&& is -L dir "$XDG_RUNTIME_DIR" \
		&& can write "$XDG_RUNTIME_DIR"
		then
			_Msh_mTo_t=$XDG_RUNTIME_DIR
		elif isset TMPDIR \
		&& str begin "$TMPDIR" '/' \
		&& is -L dir "$TMPDIR" \
		&& can write "$TMPDIR"
		then
			_Msh_mTo_t=$TMPDIR
		else
			_Msh_mTo_t=/tmp
		fi
		for _Msh_mT_t do
			case ${_Msh_mT_t} in
			( */* )	die "mktemp: -t: template must not contain directory separators" ;;
			( *X | *. ) ;;
			( * )	_Msh_mT_t=${_Msh_mT_t}. ;;
			esac
			set -- "$@" "${_Msh_mTo_t}/${_Msh_mT_t}"
			shift
		done
	fi
	if let "${#}>1" && not isset _Msh_mTo_Q; then
		for _Msh_mT_t do
			case ${_Msh_mT_t} in
			( *["$WHITESPACE"]* )
				die "mktemp: multiple templates and at least 1 has whitespace: use -Q" ;;
			esac
		done
	fi
	if let "${#}<1"; then

		set -- ${_Msh_mTo_t:-/tmp}/temp.
	fi

	REPLY=''
	for _Msh_mT_t do
		_Msh_mT_tlen=0
		while str end "${_Msh_mT_t}" X; do
			_Msh_mT_t=${_Msh_mT_t%X}
			let "_Msh_mT_tlen+=1"
		done
		let "_Msh_mT_tlen<10" && _Msh_mT_tlen=10


		case ${_Msh_mT_t} in
		( */* )	_Msh_mT_td=$(chdir -f -- "${_Msh_mT_t%/*}" && command pwd && put x) ;;
		( * )	_Msh_mT_td=$(command pwd -P && put x) ;;
		esac || die "mktemp: directory not accessible: ${_Msh_mT_t%/*}"
		_Msh_mT_td=${_Msh_mT_td%${CCn}x}
		case ${_Msh_mT_td} in
		( / )	_Msh_mT_t=/${_Msh_mT_t##*/} ;;
		( * )	_Msh_mT_t=${_Msh_mT_td}/${_Msh_mT_t##*/} ;;
		esac


		forever do
			_Msh_mT_tsuf=$(_Msh_mktemp_genSuffix) || die "mktemp: could not generate suffix"
			if str match "${_Msh_mT_tsuf}" '?*/?*'; then
				let "_Msh_srand = ${_Msh_mT_tsuf##*/} ^ ${RANDOM:-0}"
				_Msh_mT_tsuf=${_Msh_mT_tsuf%/*}
			fi
			str match "${_Msh_mT_tsuf}" '??????????*' || die "mktemp: failed to generate min. 10 char. suffix"

			REPLY=$REPLY$(
				IFS=''; set -f -u -C
				command umask 0077
				export PATH=$DEFPATH LC_ALL=C
				unset -f getconf





				_Msh_file=${_Msh_mT_t}${_Msh_mT_tsuf}


				case ${_Msh_mTo_d+d}${_Msh_mTo_F+F} in
				( d )	command mkdir ${_Msh_file} 2>/dev/null ;;
				( F )	command mkfifo ${_Msh_file} 2>/dev/null ;;
				( '' )




					not is present ${_Msh_file} &&
					{ >${_Msh_file} is reg ${_Msh_file}; } 2>/dev/null &&
					can write ${_Msh_file} &&
					putln foo >|${_Msh_file} &&
					can read ${_Msh_file} &&
					read _Msh_f <${_Msh_file} &&
					str eq ${_Msh_f} foo >|${_Msh_file} ;;
				( * )	exit 1 'mktemp: internal error' ;;
				esac



				_Msh_e=$?
				case ${_Msh_e} in
				( 0 )
					case ${_Msh_mTo_Q+y} in
					( y )	shellquote -f _Msh_file && put "${_Msh_file} " ;;
					( * )	putln ${_Msh_file} ;;
					esac ;;
				( ? | ?? | 1[01]? | 12[012345] )
					is -L dir ${_Msh_mT_t%/*} || exit 1 "mktemp: not a directory: ${_Msh_mT_t%/*}"
					can write ${_Msh_mT_t%/*} || exit 1 "mktemp: directory not writable: ${_Msh_mT_t%/*}"
					_Msh_max=$(exec getconf NAME_MAX ${_Msh_file%/*} 2>/dev/null); _Msh_name=${_Msh_file##*/}
					let "${#_Msh_name} > ${_Msh_max:-255}" && exit 1 "mktemp: filename too long: ${_Msh_name}"
					_Msh_max=$(exec getconf PATH_MAX ${_Msh_file%/*} 2>/dev/null)
					let "${#_Msh_file} > ${_Msh_max:-1024}" && exit 1 "mktemp: path too long: ${_Msh_file}"

					exit 147 ;;
				( 126 )	exit 1 "mktemp: system error: could not invoke command" ;;
				( 127 ) exit 1 "mktemp: system error: command not found" ;;
				( * )	if thisshellhas --sig=${_Msh_e}; then
						exit 1 "mktemp: system error: command killed by SIG$REPLY"
					fi
					exit 1 "mktemp: system error: command failed" ;;
				esac
			)

			case $? in
			( 0 )	break ;;
			( 147 )	continue ;;
			( * )	die ;;
			esac
		done
	done

	isset _Msh_mTo_Q && REPLY=${REPLY% }
	isset _Msh_mTo_s && unset -v _Msh_mTo_s || putln "$REPLY"
	if let "_Msh_mTo_C > 0"; then
		unset -v _Msh_mT_qnames

		if isset _Msh_mTo_Q; then

			_Msh_mT_qnames=$REPLY
		elif let "${#}==1"; then

			shellquote _Msh_mT_qnames="$REPLY"
		else

			push IFS -f; IFS=$CCn; set -f
			for _Msh_mT_f in $REPLY; do
				shellquote _Msh_mT_f
				_Msh_mT_qnames=${_Msh_mT_qnames:+$_Msh_mT_qnames }${_Msh_mT_f}
			done
			pop IFS -f
		fi
		if thisshellhas QRK_EXECFNBI; then
			_Msh_mT_cmd='unset -f rm; '
		else
			_Msh_mT_cmd=''
		fi
		_Msh_mT_cmd="${_Msh_mT_cmd}PATH=\$DEFPATH exec rm -${_Msh_mTo_d+r}f ${_Msh_mT_qnames}"
		if let "_Msh_mTo_C > 2"; then
			pushtrap "${_Msh_mT_cmd}" INT PIPE TERM EXIT DIE
		elif let "_Msh_mTo_C > 1"; then
			pushtrap "${_Msh_mT_cmd}" INT PIPE TERM EXIT
			shellquote _Msh_mT_qnames="mktemp: Leaving temp item(s): ${_Msh_mT_qnames}"
			pushtrap "putln \"\" ${_Msh_mT_qnames} 1>&2" DIE
		else
			pushtrap "${_Msh_mT_cmd}" PIPE TERM EXIT
			shellquote _Msh_mT_qnames="mktemp: Leaving temp item(s): ${_Msh_mT_qnames}"
			pushtrap "putln \"\" ${_Msh_mT_qnames} 1>&2" INT DIE
		fi
		unset -v _Msh_mT_qnames
	fi
	unset -v _Msh_mT_t _Msh_mT_td _Msh_mT_tlen _Msh_mT_tsuf _Msh_mT_cmd \
		_Msh_mTo_d _Msh_mTo_F _Msh_mTo_s _Msh_mTo_Q _Msh_mTo_t _Msh_mTo_C
}

if thisshellhas ROFUNC; then
	readonly -f mktemp _Msh_mktemp_genSuffix
fi
