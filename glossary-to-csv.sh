#!/usr/bin/env sh

### Script: glossary-to-csv.sh
##
## 用語集を Anki デッキ用の CSV に変換する。
##
## Metadata:
##
##   id - 57836d9e-6388-4dc9-8262-ae29c8bc0d49
##   author - <qq542vev at https://purl.org/meta/me/>
##   version - 0.0.1
##   date - 2023-07-07
##   since - 2023-07-07
##   copyright - Copyright (C) 2023-2023 qq542vev. Some rights reserved.
##   license - <CC-BY at https://creativecommons.org/licenses/by/4.0/>
##   package - convert-it-passport
##
## See Also:
##
##   * <Project homepage at https://github.com/qq542vev/convert-it-passport>
##   * <Bag report at https://github.com/qq542vev/convert-it-passport/issues>
##
## Help Output:
##
## ------ Text ------
## Usage:
##   glossary-to-csv.sh [OPTION]...
##
## Options:
##   -s,     --{no-}strategy[=FILENAME]
##                               ストラテジ系の用語集を出力する
##   -m,     --{no-}management[=FILENAME]
##                               マネジメント系の用語集を出力する
##   -t,     --{no-}technology[=FILENAME]
##                               テクノロジ系の用語集を出力する
##   -w,     --wait SECONDS      ダウンロード時に待機する秒数を指定する
##   -h,     --help              このヘルプを表示して終了する
##   -v,     --version           バージョン情報を表示して終了する
##
## Exit Status:
##     0 - successful termination
##    64 - command line usage error
##    65 - data format error
##    66 - cannot open input
##    67 - addressee unknown
##    68 - host name unknown
##    69 - service unavailable
##    70 - internal software error
##    71 - system error (e.g., can't fork)
##    72 - critical OS file missing
##    73 - can't create (user) output file
##    74 - input/output error
##    75 - temp failure; user is invited to retry
##    76 - remote error in protocol
##    77 - permission denied
##    78 - configuration error
##   129 - received SIGHUP
##   130 - received SIGINT
##   131 - received SIGQUIT
##   143 - received SIGTERM
## ------------------

readonly 'VERSION=glossary-to-csv.sh 0.0.1'

set -efu
umask '0022'
readonly "LC_ALL_ORG=${LC_ALL-}"
LC_ALL='C'
IFS=$(printf ' \t\n_'); IFS="${IFS%_}"
PATH="${PATH-}${PATH:+:}$(command -p getconf 'PATH')"
UNIX_STD='2003' # HP-UX POSIX mode
XPG_SUS_ENV='ON' # AIX POSIX mode
XPG_UNIX98='OFF' # AIX UNIX 03 mode
POSIXLY_CORRECT='1' # GNU Coreutils POSIX mode
COMMAND_MODE='unix2003' # macOS UNIX 03 mode
export 'LC_ALL' 'IFS' 'PATH' 'UNIX_STD' 'XPG_SUS_ENV' 'XPG_UNIX98' 'POSIXLY_CORRECT' 'COMMAND_MODE'

readonly 'EX_OK=0'           # successful termination
readonly 'EX__BASE=64'       # base value for error messages

readonly 'EX_USAGE=64'       # command line usage error
readonly 'EX_DATAERR=65'     # data format error
readonly 'EX_NOINPUT=66'     # cannot open input
readonly 'EX_NOUSER=67'      # addressee unknown
readonly 'EX_NOHOST=68'      # host name unknown
readonly 'EX_UNAVAILABLE=69' # service unavailable
readonly 'EX_SOFTWARE=70'    # internal software error
readonly 'EX_OSERR=71'       # system error (e.g., can't fork)
readonly 'EX_OSFILE=72'      # critical OS file missing
readonly 'EX_CANTCREAT=73'   # can't create (user) output file
readonly 'EX_IOERR=74'       # input/output error
readonly 'EX_TEMPFAIL=75'    # temp failure; user is invited to retry
readonly 'EX_PROTOCOL=76'    # remote error in protocol
readonly 'EX_NOPERM=77'      # permission denied
readonly 'EX_CONFIG=78'      # configuration error

readonly 'EX__MAX=78'        # maximum listed value

trap 'case "${?}" in 0) end_call;; *) end_call "${EX_SOFTWARE}";; esac' 0 # EXIT
trap 'end_call 129' 1  # SIGHUP
trap 'end_call 130' 2  # SIGINT
trap 'end_call 131' 3  # SIGQUIT
trap 'end_call 143' 15 # SIGTERM

### Function: end_call
##
## 一時ディレクトリを削除しスクリプトを終了する。
##
## Parameters:
##
##   $1 - 終了ステータス。
##
## Returns:
##
##   $1 の終了ステータス。

end_call() {
	trap '' 0 # EXIT
	rm -fr -- ${tmpDir:+"${tmpDir}"}
	exit "${1:-0}"
}

### Function: option_error
##
## エラーメッセージを出力する。
##
## Parameters:
##
##   $1 - エラーメッセージ。
##
## Returns:
##
##   終了コード64。

option_error() {
	printf '%s: %s\n' "${0##*/}" "${1}" >&2
	printf "詳細については '%s' を実行してください。\\n" "${0##*/} --help" >&2

	end_call "${EX_USAGE}"
}

### Function: csv_escape
##
## 文字列内の二重引用符を CSV 形式でエスケープする。
##
## Parameters:
##
##   $1 - 結果を代入する変数名。
##   $2 - エスケープする文字列。

csv_escape() {
	set -- "${1}" "${2}" ''

	until [ "${2#*\"}" '=' "${2}" ]; do
		set -- "${1}" "${2#*\"}" "${3}${2%%\"*}\"\""
	done

	set -- "${1}" "${3}${2}"

	eval "${1}=\${2}"
}

### Function: regex_match
##
## 文字列が正規表現に一致するか検査する。
##
## Parameters:
##
##   $1 - 検査する文字列。
##   $@ - 正規表現。
##
## Returns:
##
##   0か1の真理値。

regex_match() {
	awk -- '
		BEGIN {
			for(i = 2; i < ARGC; i++) {
				if(ARGV[1] !~ ARGV[i]) {
					exit 1
				}
			}

			exit
		}
	' ${@+"${@}"} || return 1

	return 0
}

# @getoptions
parser_definition() {
	setup REST abbr:true error:option_error plus:true init:@no no: help:usage \
		-- 'Usage:' "  ${2##*/} [OPTION]..." \
		'' 'Options:'

	option output_strategy   -s --{no-}strategy   on:'strategy.csv'   pattern:'*[!/]' var:FILENAME -- 'ストラテジ系の用語集を出力する'
	option output_management -m --{no-}management on:'management.csv' pattern:'*[!/]' var:FILENAME -- 'マネジメント系の用語集を出力する'
	option output_technology -t --{no-}technology on:'technology.csv' pattern:'*[!/]' var:FILENAME -- 'テクノロジ系の用語集を出力する'
	param wait     -w --wait init:='20' validate:'regex_match "${OPTARG}" "^0$|^[1-9][0-9]*$"' var:'SECONDS' -- 'ダウンロード時に待機する秒数を指定する'
	disp   :usage  -h --help    -- 'このヘルプを表示して終了する'
	disp   VERSION -v --version -- 'バージョン情報を表示して終了する'

	msg -- '' 'Exit Status:' \
		'    0 - successful termination' \
		'   64 - command line usage error' \
		'   65 - data format error' \
		'   66 - cannot open input' \
		'   67 - addressee unknown' \
		'   68 - host name unknown' \
		'   69 - service unavailable' \
		'   70 - internal software error' \
		"   71 - system error (e.g., can't fork)" \
		'   72 - critical OS file missing' \
		"   73 - can't create (user) output file" \
		'   74 - input/output error' \
		'   75 - temp failure; user is invited to retry' \
		'   76 - remote error in protocol' \
		'   77 - permission denied' \
		'   78 - configuration error' \
		'  129 - received SIGHUP' \
		'  130 - received SIGINT' \
		'  131 - received SIGQUIT' \
		'  143 - received SIGTERM'
}
# @end

# @gengetoptions parser -i parser_definition parse "${1}"
# Generated by getoptions (BEGIN)
# URL: https://github.com/ko1nksm/getoptions (v3.3.0)
output_strategy=''
output_management=''
output_technology=''
wait='20'
REST=''
parse() {
  OPTIND=$(($#+1))
  while OPTARG= && [ $# -gt 0 ]; do
    set -- "${1%%\=*}" "${1#*\=}" "$@"
    while [ ${#1} -gt 2 ]; do
      case $1 in (*[!a-zA-Z0-9_-]*) break; esac
      case '--strategy' in
        "$1") OPTARG=; break ;;
        $1*) OPTARG="$OPTARG --strategy"
      esac
      case '--no-strategy' in
        "$1") OPTARG=; break ;;
        $1*) OPTARG="$OPTARG --no-strategy"
      esac
      case '--management' in
        "$1") OPTARG=; break ;;
        $1*) OPTARG="$OPTARG --management"
      esac
      case '--no-management' in
        "$1") OPTARG=; break ;;
        $1*) OPTARG="$OPTARG --no-management"
      esac
      case '--technology' in
        "$1") OPTARG=; break ;;
        $1*) OPTARG="$OPTARG --technology"
      esac
      case '--no-technology' in
        "$1") OPTARG=; break ;;
        $1*) OPTARG="$OPTARG --no-technology"
      esac
      case '--wait' in
        "$1") OPTARG=; break ;;
        $1*) OPTARG="$OPTARG --wait"
      esac
      case '--help' in
        "$1") OPTARG=; break ;;
        $1*) OPTARG="$OPTARG --help"
      esac
      case '--version' in
        "$1") OPTARG=; break ;;
        $1*) OPTARG="$OPTARG --version"
      esac
      break
    done
    case ${OPTARG# } in
      *\ *)
        eval "set -- $OPTARG $1 $OPTARG"
        OPTIND=$((($#+1)/2)) OPTARG=$1; shift
        while [ $# -gt "$OPTIND" ]; do OPTARG="$OPTARG, $1"; shift; done
        set "Ambiguous option: $1 (could be $OPTARG)" ambiguous "$@"
        option_error "$@" >&2 || exit $?
        echo "$1" >&2
        exit 1 ;;
      ?*)
        [ "$2" = "$3" ] || OPTARG="$OPTARG=$2"
        shift 3; eval 'set -- "${OPTARG# }"' ${1+'"$@"'}; OPTARG= ;;
      *) shift 2
    esac
    case $1 in
      --?*=*) OPTARG=$1; shift
        eval 'set -- "${OPTARG%%\=*}" "${OPTARG#*\=}"' ${1+'"$@"'}
        ;;
      --no-*|--without-*) unset OPTARG ;;
      -[smtw]?*) OPTARG=$1; shift
        eval 'set -- "${OPTARG%"${OPTARG#??}"}" "${OPTARG#??}"' ${1+'"$@"'}
        ;;
      -[hv]?*) OPTARG=$1; shift
        eval 'set -- "${OPTARG%"${OPTARG#??}"}" -"${OPTARG#??}"' ${1+'"$@"'}
        OPTARG= ;;
      +*) unset OPTARG ;;
    esac
    case $1 in
      '-s'|'--strategy'|'--no-strategy')
        set -- "$1" "$@"
        [ ${OPTARG+x} ] && {
          case $1 in --no-*|--without-*) set "noarg" "${1%%\=*}"; break; esac
          [ "${OPTARG:-}" ] && { shift; OPTARG=$2; } || OPTARG='strategy.csv'
        } || OPTARG=''
        case $OPTARG in *[!/]) ;;
          *) set "pattern:*[!/]" "$1"; break
        esac
        output_strategy="$OPTARG"
        shift ;;
      '-m'|'--management'|'--no-management')
        set -- "$1" "$@"
        [ ${OPTARG+x} ] && {
          case $1 in --no-*|--without-*) set "noarg" "${1%%\=*}"; break; esac
          [ "${OPTARG:-}" ] && { shift; OPTARG=$2; } || OPTARG='management.csv'
        } || OPTARG=''
        case $OPTARG in *[!/]) ;;
          *) set "pattern:*[!/]" "$1"; break
        esac
        output_management="$OPTARG"
        shift ;;
      '-t'|'--technology'|'--no-technology')
        set -- "$1" "$@"
        [ ${OPTARG+x} ] && {
          case $1 in --no-*|--without-*) set "noarg" "${1%%\=*}"; break; esac
          [ "${OPTARG:-}" ] && { shift; OPTARG=$2; } || OPTARG='technology.csv'
        } || OPTARG=''
        case $OPTARG in *[!/]) ;;
          *) set "pattern:*[!/]" "$1"; break
        esac
        output_technology="$OPTARG"
        shift ;;
      '-w'|'--wait')
        [ $# -le 1 ] && set "required" "$1" && break
        OPTARG=$2
        regex_match "${OPTARG}" "^0$|^[1-9][0-9]*$" || { set -- regex_match:$? "$1" regex_match "${OPTARG}" "^0$|^[1-9][0-9]*$"; break; }
        wait="$OPTARG"
        shift ;;
      '-h'|'--help')
        usage
        exit 0 ;;
      '-v'|'--version')
        echo "${VERSION}"
        exit 0 ;;
      --)
        shift
        while [ $# -gt 0 ]; do
          REST="${REST} \"\${$(($OPTIND-$#))}\""
          shift
        done
        break ;;
      [-+]?*) set "unknown" "$1"; break ;;
      *)
        REST="${REST} \"\${$(($OPTIND-$#))}\""
    esac
    shift
  done
  [ $# -eq 0 ] && { OPTIND=1; unset OPTARG; return 0; }
  case $1 in
    unknown) set "Unrecognized option: $2" "$@" ;;
    noarg) set "Does not allow an argument: $2" "$@" ;;
    required) set "Requires an argument: $2" "$@" ;;
    pattern:*) set "Does not match the pattern (${1#*:}): $2" "$@" ;;
    notcmd) set "Not a command: $2" "$@" ;;
    *) set "Validation error ($1): $2" "$@"
  esac
  option_error "$@" >&2 || exit $?
  echo "$1" >&2
  exit 1
}
usage() {
cat<<'GETOPTIONSHERE'
Usage:
  glossary-to-csv.sh [OPTION]...

Options:
  -s,     --{no-}strategy[=FILENAME] 
                              ストラテジ系の用語集を出力する
  -m,     --{no-}management[=FILENAME] 
                              マネジメント系の用語集を出力する
  -t,     --{no-}technology[=FILENAME] 
                              テクノロジ系の用語集を出力する
  -w,     --wait SECONDS      ダウンロード時に待機する秒数を指定する
  -h,     --help              このヘルプを表示して終了する
  -v,     --version           バージョン情報を表示して終了する

Exit Status:
    0 - successful termination
   64 - command line usage error
   65 - data format error
   66 - cannot open input
   67 - addressee unknown
   68 - host name unknown
   69 - service unavailable
   70 - internal software error
   71 - system error (e.g., can't fork)
   72 - critical OS file missing
   73 - can't create (user) output file
   74 - input/output error
   75 - temp failure; user is invited to retry
   76 - remote error in protocol
   77 - permission denied
   78 - configuration error
  129 - received SIGHUP
  130 - received SIGINT
  131 - received SIGQUIT
  143 - received SIGTERM
GETOPTIONSHERE
}
# Generated by getoptions (END)
# @end

case "${#}" in '0')
	set -- --strategy --management --technology
esac

parse ${@+"${@}"}
eval "set -- ${REST}"

readonly "indexes=$(
	cat <<-'__EOF__'
	strategy https://web.archive.org/web/20230707000000/https://www.itpassportsiken.com/word/index_st.html
	management https://web.archive.org/web/20230707000000/https://www.itpassportsiken.com/word/index_ma.html
	technology https://web.archive.org/web/20230707000000/https://www.itpassportsiken.com/word/index_te.html
	__EOF__
)"
readonly "xpathes=$(
	cat <<-'__EOF__'
	//*[@id="quizAWrap"]/*[@class="quizAText"]/text()[1]
	//*[@id="quizAWrap"]/*[@class="quizAText"]/node()[self::* or self::text()]
	//*[@id="quizQWrap"]/*[@class="quizQKaisetsu"]/node()[self::* or self::text()]
	//*[@id="quizAWrap"]//dl[@class="fieldList"]//dt[.="別名："]/following-sibling::dd[1]/node()[self::* or self::text()]
	//*[@id="quizAWrap"]//dl[@class="fieldList"]//dt[.="分野："]/following-sibling::dd[1]/node()[self::* or self::text()]
	__EOF__
)"
readonly "tmpDir=$(mktemp -d)"
readonly "download=${tmpDir}/download"
readonly "format=${tmpDir}/format"

export "TMPDIR=${tmpDir}"

if command xmlstarlet --help >'/dev/null' 2>&1; then
	xml() {
		command xmlstarlet ${@+"${@}"}
	}
fi

printf '%s\n' "${indexes}" | while IFS=' ' read -r category index; do
	eval "output=\"\${output_${category}}\""

	if [ -e "${output}" ]; then
		if [ '!' -f "${output}" ]; then
			printf "'%s' は通常ファイルではありません。\\n" "${output}" >&2

 			exit "${EX_USAGE}"
		elif [ '!' -w "${output}" ]; then
			printf "'%s' の作成または書き込み許可がありません。\\n" "${output}" >&2

			exit "${EX_CANTCREAT}"
		fi
	elif dir="$(dirname -- "${output}"; printf '_')" && [ '!' -w "${dir%?_}" ]; then
		printf "'%s' が存在しないか、または書き込み許可がありません。\\n" "${dir%?_}" >&2

		exit "${EX_CANTCREAT}"
	fi
done || end_call "${?}"

printf '%s\n' "${indexes}" | while IFS=' ' read -r category index; do
	eval "output=\"\${output_${category}}\""

	case "${output}" in ?*)
		until wget --no-config --convert-links --output-document="${download}" -- "${index}"; do
			sleep "${wait}"
		done

		xml --quiet format --encode 'UTF-8' --html "${download}" >"${format}"

		urls=$(xml select --text --template --match '//*[@id="mainCol"]//ul[@class="wordLink cf"]/li/a' --value-of '@href' --nl "${format}")

		sleep "${wait}"

		printf '%s\n' "${urls}" | while IFS='' read -r url; do
			until wget --no-config --convert-links --output-document="${download}" -- "${url}"; do
				sleep "${wait}"
			done

			sed -e '/<link /d' -- "${download}" | xml --quiet format --encode 'UTF-8' --html - >"${format}"

			printf '%s\n' "${xpathes}" | while IFS='' read -r xpath; do
				csv_escape 'field' "$(xml select --template --copy-of "${xpath}" "${format}")"

				printf '"%s",' "${field}"
			done

			printf '"%s","%s"\r\n' "${url}" "${category}"

			sleep "${wait}"
		done | case "${output}" in
			'-') cat;;
			*) cat >"${output}";;
		esac
	esac
done
