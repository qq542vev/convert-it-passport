#! /shell/bug/test/for/moderni/sh


{ _Msh_test=$(

	insubshell -p

	unset -v _Msh_not_ignored
	for _Msh_sig in ALRM HUP INT PIPE POLL PROF TERM USR1 USR2 VTALRM; do
		command trap '_Msh_not_ignored=y' "${_Msh_sig}"
		command kill -s "${_Msh_sig}" "$REPLY"
		command trap - "${_Msh_sig}"
		isset _Msh_not_ignored && break
	done
	isset _Msh_not_ignored || \exit

	_Msh_testFn() {
		command kill -s "${_Msh_sig}" "$REPLY"
		putln "stillhere"
	}
	command trap "putln 'trap'; exit" "${_Msh_sig}"
	_Msh_testFn
); } 2>/dev/null
