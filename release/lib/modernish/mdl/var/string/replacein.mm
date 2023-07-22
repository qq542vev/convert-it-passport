#! /module/for/moderni/sh
\command unalias replacein 2>/dev/null


if thisshellhas PSREPLACE; then

	replacein() {
		case ${#},${1-},${2-} in
		( 3,,"${2-}" | 3,[0123456789]*,"${2-}" | 3,*[!"$ASCIIALNUM"_]*,"${2-}" )
			die "replacein: invalid variable name: $1" ;;
		( 4,-[ta], | 4,-[ta],[0123456789]* | 4,-[ta],*[!"$ASCIIALNUM"_]* )
			die "replacein: invalid variable name: $2" ;;
		( 3,* )	eval "$1=\${$1/\"\$2\"/\"\$3\"}" ;;
		( 4,-t,* )
			eval "if str in \"\$$2\" \"\$3\"; then
				$2=\${$2%\"\$3\"*}\$4\${$2##*\"\$3\"}
			fi" ;;
		( 4,-a,* )
			eval "$2=\${$2//\"\$3\"/\"\$4\"}" ;;
		( * )	die "replacein: invalid arguments" ;;
		esac
	}
else

	replacein() {
		case ${#},${1-},${2-} in
		( 3,,"${2-}" | 3,[0123456789]*,"${2-}" | 3,*[!"$ASCIIALNUM"_]*,"${2-}" )
			die "replacein: invalid variable name: $1" ;;
		( 4,-[ta], | 4,-[ta],[0123456789]* | 4,-[ta],*[!"$ASCIIALNUM"_]* )
			die "replacein: invalid variable name: $2" ;;
		( 3,* )	eval "if str in \"\$$1\" \"\$2\"; then
				$1=\${$1%%\"\$2\"*}\$3\${$1#*\"\$2\"}
			fi" ;;
		( 4,-t,* )
			eval "if str in \"\$$2\" \"\$3\"; then
				$2=\${$2%\"\$3\"*}\$4\${$2##*\"\$3\"}
			fi" ;;
		( 4,-a,* )
			if str in "$4" "$3"; then



				eval "_Msh_rAi=\$$2
				$2=
				while str in \"\${_Msh_rAi}\" \"\$3\"; do
					$2=\$$2\${_Msh_rAi%%\"\$3\"*}\$4
					_Msh_rAi=\${_Msh_rAi#*\"\$3\"}
				done
				$2=\$$2\${_Msh_rAi}"
				unset -v _Msh_rAi
			else

				eval "while str in \"\$$2\" \"\$3\"; do
					$2=\${$2%%\"\$3\"*}\$4\${$2#*\"\$3\"}
				done"
			fi ;;
		( * )	die "replacein: invalid arguments" ;;
		esac
	}
fi

if thisshellhas ROFUNC; then
	readonly -f replacein
fi
