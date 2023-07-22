#! /module/for/moderni/sh
\command unalias dec div inc mod mult ndiv 2>/dev/null


inc()  { : "$((${1?inc: needs 1 or 2 arguments}+=(${2-1})${3+${ERROR:?inc: excess arguments}}))"; }
dec()  { : "$((${1?dec: needs 1 or 2 arguments}-=(${2-1})${3+${ERROR:?dec: excess arguments}}))"; }
mult() { : "$((${1?mult: needs 1 or 2 arguments}*=(${2-2})${3+${ERROR:?mult: excess arguments}}))"; }
div()  { : "$((${1?div: needs 1 or 2 arguments}/=(${2-2})${3+${ERROR:?div: excess arguments}}))"; }
mod()  { : "$((${1?mod: needs 1 or 2 arguments}%=(${2-256})${3+${ERROR:?mod: excess arguments}}))"; }

ndiv() {
	set -- "${1?ndiv: needs 1 or 2 arguments}" "$(((${2-2})${3+${ERROR:?ndiv: excess arguments}}))"
	: "$(($1 = (($1/$2)*$2 > $1) ? $1/$2-1 : $1/$2))"
}

if thisshellhas ROFUNC; then
	readonly -f inc dec mult div mod ndiv
fi
