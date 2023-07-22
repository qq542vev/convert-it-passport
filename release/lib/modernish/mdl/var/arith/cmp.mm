#! /module/for/moderni/sh
\command unalias eq ge gt le lt ne 2>/dev/null




if thisshellhas ARITHCMD; then
	eval '
	eq() { (((${1?eq: needs 2 arguments})==(${2?eq: needs 2 arguments})${3+${ERROR:?eq: excess arguments}})); }
	ne() { (((${1?ne: needs 2 arguments})!=(${2?ne: needs 2 arguments})${3+${ERROR:?ne: excess arguments}})); }
	lt() { (((${1?lt: needs 2 arguments})<(${2?lt: needs 2 arguments})${3+${ERROR:?lt: excess arguments}})); }
	le() { (((${1?le: needs 2 arguments})<=(${2?le: needs 2 arguments})${3+${ERROR:?le: excess arguments}})); }
	gt() { (((${1?gt: needs 2 arguments})>(${2?gt: needs 2 arguments})${3+${ERROR:?gt: excess arguments}})); }
	ge() { (((${1?ge: needs 2 arguments})>=(${2?ge: needs 2 arguments})${3+${ERROR:?ge: excess arguments}})); }
	'
else




	eq() { return "$(((${1?eq: needs 2 arguments})!=(${2?eq: needs 2 arguments})${3+${ERROR:?eq: excess arguments}}))"; }
	ne() { return "$(((${1?ne: needs 2 arguments})==(${2?ne: needs 2 arguments})${3+${ERROR:?ne: excess arguments}}))"; }
	lt() { return "$(((${1?lt: needs 2 arguments})>=(${2?lt: needs 2 arguments})${3+${ERROR:?lt: excess arguments}}))"; }
	le() { return "$(((${1?le: needs 2 arguments})>(${2?le: needs 2 arguments})${3+${ERROR:?le: excess arguments}}))"; }
	gt() { return "$(((${1?gt: needs 2 arguments})<=(${2?gt: needs 2 arguments})${3+${ERROR:?gt: excess arguments}}))"; }
	ge() { return "$(((${1?ge: needs 2 arguments})<(${2?ge: needs 2 arguments})${3+${ERROR:?ge: excess arguments}}))"; }
fi

if thisshellhas ROFUNC; then
	readonly -f eq ne lt le gt ge
fi
