#! /module/for/moderni/sh
\command unalias shellquote shellquoteparams _Msh_qV_PP _Msh_qV_R _Msh_qV_dblQuote _Msh_qV_sngQuote _Msh_qV_sngQuote_do1fld 2>/dev/null


if thisshellhas ADDASSIGN; then
	_Msh_qV_sngQuote_do1fld() {


		case ${_Msh_qV_f},${_Msh_qV_C} in
		( , | f, )
			_Msh_qV+=\\\' ;;
		( ,[!$CCn$SHELLSAFECHARS]* )


			case ${_Msh_qV_C#?} in
			( *[!$SHELLSAFECHARS]* )
				_Msh_qV+=\'${_Msh_qV_C}\'\\\' ;;
			( * )	_Msh_qV+=\\${_Msh_qV_C}\\\' ;;
			esac ;;
		( ,*[!$SHELLSAFECHARS]* | f,* )

			_Msh_qV+=\'${_Msh_qV_C}\'\\\' ;;
		( * )
			_Msh_qV+=${_Msh_qV_C}\\\' ;;
		esac
	}
else
	_Msh_qV_sngQuote_do1fld() {


		case ${_Msh_qV_f},${_Msh_qV_C} in
		( , | f, )
			_Msh_qV=${_Msh_qV}\\\' ;;
		( ,[!$CCn$SHELLSAFECHARS]* )


			case ${_Msh_qV_C#?} in
			( *[!$SHELLSAFECHARS]* )
				_Msh_qV=${_Msh_qV}\'${_Msh_qV_C}\'\\\' ;;
			( * )	_Msh_qV=${_Msh_qV}\\${_Msh_qV_C}\\\' ;;
			esac ;;
		( ,*[!$SHELLSAFECHARS]* | f,* )

			_Msh_qV=${_Msh_qV}\'${_Msh_qV_C}\'\\\' ;;
		( * )
			_Msh_qV=${_Msh_qV}${_Msh_qV_C}\\\' ;;
		esac
	}
fi

_Msh_qV_sngQuote() {

	case ${_Msh_qV_VAL} in
	( *\' )
		thisshellhas QRK_IFSFINAL || _Msh_qV_VAL=${_Msh_qV_VAL}\' ;;
	esac
	_Msh_qV=
	push IFS -f; set -f
	IFS="'"; for _Msh_qV_C in ${_Msh_qV_VAL}; do IFS=

		_Msh_qV_sngQuote_do1fld
	done
	pop IFS -f

	_Msh_qV_VAL=${_Msh_qV%\\\'}
}

if thisshellhas PSREPLACE; then
	eval '_Msh_qV_dblQuote() {
		_Msh_qV=${_Msh_qV_VAL//\\/\\\\}
		_Msh_qV=${_Msh_qV//\$/\\\$}
		_Msh_qV=${_Msh_qV//\`/\\\`}
		case ${_Msh_qV_P},${_Msh_qV} in
		( P,* )
			;;
		( *[$CONTROLCHARS]* )
			_Msh_qV=${_Msh_qV//$CC01/'\''${CC01}'\''}
			_Msh_qV=${_Msh_qV//$CC02/'\''${CC02}'\''}
			_Msh_qV=${_Msh_qV//$CC03/'\''${CC03}'\''}
			_Msh_qV=${_Msh_qV//$CC04/'\''${CC04}'\''}
			_Msh_qV=${_Msh_qV//$CC05/'\''${CC05}'\''}
			_Msh_qV=${_Msh_qV//$CC06/'\''${CC06}'\''}
			_Msh_qV=${_Msh_qV//$CC07/'\''${CCa}'\''}
			_Msh_qV=${_Msh_qV//$CC08/'\''${CCb}'\''}
			_Msh_qV=${_Msh_qV//$CC09/'\''${CCt}'\''}
			_Msh_qV=${_Msh_qV//$CC0A/'\''${CCn}'\''}
			_Msh_qV=${_Msh_qV//$CC0B/'\''${CCv}'\''}
			_Msh_qV=${_Msh_qV//$CC0C/'\''${CCf}'\''}
			_Msh_qV=${_Msh_qV//$CC0D/'\''${CCr}'\''}
			_Msh_qV=${_Msh_qV//$CC0E/'\''${CC0E}'\''}
			_Msh_qV=${_Msh_qV//$CC0F/'\''${CC0F}'\''}
			_Msh_qV=${_Msh_qV//$CC10/'\''${CC10}'\''}
			_Msh_qV=${_Msh_qV//$CC11/'\''${CC11}'\''}
			_Msh_qV=${_Msh_qV//$CC12/'\''${CC12}'\''}
			_Msh_qV=${_Msh_qV//$CC13/'\''${CC13}'\''}
			_Msh_qV=${_Msh_qV//$CC14/'\''${CC14}'\''}
			_Msh_qV=${_Msh_qV//$CC15/'\''${CC15}'\''}
			_Msh_qV=${_Msh_qV//$CC16/'\''${CC16}'\''}
			_Msh_qV=${_Msh_qV//$CC17/'\''${CC17}'\''}
			_Msh_qV=${_Msh_qV//$CC18/'\''${CC18}'\''}
			_Msh_qV=${_Msh_qV//$CC19/'\''${CC19}'\''}
			_Msh_qV=${_Msh_qV//$CC1A/'\''${CC1A}'\''}
			_Msh_qV=${_Msh_qV//$CC1B/'\''${CCe}'\''}
			_Msh_qV=${_Msh_qV//$CC1C/'\''${CC1C}'\''}
			_Msh_qV=${_Msh_qV//$CC1D/'\''${CC1D}'\''}
			_Msh_qV=${_Msh_qV//$CC1E/'\''${CC1E}'\''}
			_Msh_qV=${_Msh_qV//$CC1F/'\''${CC1F}'\''}
			_Msh_qV=${_Msh_qV//$CC7F/'\''${CC7F}'\''} ;;
		esac
		_Msh_qV_VAL=\"${_Msh_qV//\"/\\\"}\"
	}'
else


	_Msh_qV_R() {
		case ${_Msh_qV} in
		( *"$1"* )
			_Msh_qV_VAL=
			while case ${_Msh_qV} in ( *"$1"* ) ;; ( * ) ! : ;; esac; do
				_Msh_qV_VAL=${_Msh_qV_VAL}${_Msh_qV%%"$1"*}$2
				_Msh_qV=${_Msh_qV#*"$1"}
			done
			_Msh_qV=${_Msh_qV_VAL}${_Msh_qV} ;;
		esac
	}
	if thisshellhas ROFUNC; then
		readonly -f _Msh_qV_R
	fi
	_Msh_qV_dblQuote() {
		_Msh_qV=${_Msh_qV_VAL}
		_Msh_qV_R \\ \\\\
		_Msh_qV_R \" \\\"
		_Msh_qV_R \$ \\\$
		_Msh_qV_R \` \\\`
		case ${_Msh_qV_P},${_Msh_qV} in
		( P,* )
			;;
		( *[$CONTROLCHARS]* )
			_Msh_qV_R "$CC01" \${CC01}
			_Msh_qV_R "$CC02" \${CC02}
			_Msh_qV_R "$CC03" \${CC03}
			_Msh_qV_R "$CC04" \${CC04}
			_Msh_qV_R "$CC05" \${CC05}
			_Msh_qV_R "$CC06" \${CC06}
			_Msh_qV_R "$CC07" \${CCa}
			_Msh_qV_R "$CC08" \${CCb}
			_Msh_qV_R "$CC09" \${CCt}
			_Msh_qV_R "$CC0A" \${CCn}
			_Msh_qV_R "$CC0B" \${CCv}
			_Msh_qV_R "$CC0C" \${CCf}
			_Msh_qV_R "$CC0D" \${CCr}
			_Msh_qV_R "$CC0E" \${CC0E}
			_Msh_qV_R "$CC0F" \${CC0F}
			_Msh_qV_R "$CC10" \${CC10}
			_Msh_qV_R "$CC11" \${CC11}
			_Msh_qV_R "$CC12" \${CC12}
			_Msh_qV_R "$CC13" \${CC13}
			_Msh_qV_R "$CC14" \${CC14}
			_Msh_qV_R "$CC15" \${CC15}
			_Msh_qV_R "$CC16" \${CC16}
			_Msh_qV_R "$CC17" \${CC17}
			_Msh_qV_R "$CC18" \${CC18}
			_Msh_qV_R "$CC19" \${CC19}
			_Msh_qV_R "$CC1A" \${CC1A}
			_Msh_qV_R "$CC1B" \${CCe}
			_Msh_qV_R "$CC1C" \${CC1C}
			_Msh_qV_R "$CC1D" \${CC1D}
			_Msh_qV_R "$CC1E" \${CC1E}
			_Msh_qV_R "$CC1F" \${CC1F}
			_Msh_qV_R "$CC7F" \${CC7F} ;;
		esac
		_Msh_qV_VAL=\"${_Msh_qV}\"
	}
fi

shellquote() {
	_Msh_qV_ERR=4
	_Msh_qV_f=
	_Msh_qV_P=
	for _Msh_qV_N do
		case ${_Msh_qV_N} in
		([+-]*)	_Msh_qV_ERR=4
			case ${_Msh_qV_N} in
			( -f )		_Msh_qV_f=f ;;
			( +f )		_Msh_qV_f= ;;
			( -P )		_Msh_qV_P=P ;;
			( +P )		_Msh_qV_P= ;;
			( -fP | -Pf )	_Msh_qV_f=f; _Msh_qV_P=P ;;
			( +fP | +Pf )	_Msh_qV_f=; _Msh_qV_P= ;;
			( * )		_Msh_qV_ERR=3; break ;;
			esac
			continue ;;
		( *=* )
			_Msh_qV_VAL=${_Msh_qV_N#*=}
			_Msh_qV_N=${_Msh_qV_N%%=*}
			case ${_Msh_qV_N} in
			( "" | [0123456789]* | *[!"$ASCIIALNUM"_]* )
				_Msh_qV_ERR=2
				break ;;
			esac ;;
		( "" | [0123456789]* | *[!"$ASCIIALNUM"_]* )
			_Msh_qV_ERR=2
			break ;;
		( * )	! isset "${_Msh_qV_N}" && _Msh_qV_ERR=1 && break
			eval "_Msh_qV_VAL=\${${_Msh_qV_N}}" ;;
		esac
		_Msh_qV_ERR=0


		case ${_Msh_qV_VAL} in
		( '' )	eval "${_Msh_qV_N}=\'\'"
			continue ;;
		esac




		case ${_Msh_qV_f:+" "}${_Msh_qV_VAL} in

		( '[' | ']' | '[[' | ']]' | '{' | '}' | '{}' )


			;;

		( [!$CONTROLCHARS$SHELLSAFECHARS] )

			_Msh_qV_VAL=\\${_Msh_qV_VAL} ;;

		( \\[!$CONTROLCHARS$SHELLSAFECHARS] )

			_Msh_qV_VAL=\\\\${_Msh_qV_VAL} ;;

		( *[!$SHELLSAFECHARS]* )

			case ${_Msh_qV_P},${_Msh_qV_VAL} in
			( ,*[$CONTROLCHARS]* )

				_Msh_qV_dblQuote ;;
			( *\'* )
				case ${_Msh_qV_VAL} in
				( *[\"\$\`\\]* )

					_Msh_qV_VAL_save=${_Msh_qV_VAL}
					_Msh_qV_dblQuote
					_Msh_qV_VAL2=${_Msh_qV_VAL}
					_Msh_qV_VAL=${_Msh_qV_VAL_save}
					_Msh_qV_sngQuote
					let "${#_Msh_qV_VAL2} < ${#_Msh_qV_VAL}" && _Msh_qV_VAL=${_Msh_qV_VAL2}
					unset -v _Msh_qV_VAL2 _Msh_qV_VAL_save ;;
				( * )
					_Msh_qV_VAL=\"${_Msh_qV_VAL}\" ;;
				esac ;;
			( * )
				_Msh_qV_VAL=\'${_Msh_qV_VAL}\' ;;
			esac ;;
		esac

		eval "${_Msh_qV_N}=\${_Msh_qV_VAL}"
	done

	case ${_Msh_qV_ERR} in
	( 0 )	unset -v _Msh_qV _Msh_qV_C _Msh_qV_VAL _Msh_qV_f _Msh_qV_P _Msh_qV_N _Msh_qV_ERR ;;
	( 1 )	die "shellquote: unset variable: ${_Msh_qV_N}" ;;
	( 2 )	die "shellquote: invalid variable name: ${_Msh_qV_N}" ;;
	( 3 )	die "shellquote: invalid option: ${_Msh_qV_N}" ;;
	( 4 )	die "shellquote: expected variable(s) to quote" ;;
	( * )	die "shellquote: internal error (${_Msh_qV_ERR})" ;;
	esac
}

alias shellquoteparams='{ _Msh_qV_PP "$@" && eval "set -- ${_Msh_QP}" && unset -v _Msh_QP; }'
_Msh_qV_PP() {
	unset -v _Msh_QP
	for _Msh_Q do
		shellquote _Msh_Q _Msh_Q
		_Msh_QP=${_Msh_QP-}\ ${_Msh_Q}
	done
	unset -v _Msh_Q
	isset _Msh_QP
}

if thisshellhas ROFUNC; then
	readonly -f shellquote _Msh_qV_dblQuote _Msh_qV_sngQuote _Msh_qV_sngQuote_do1fld _Msh_qV_PP
fi
