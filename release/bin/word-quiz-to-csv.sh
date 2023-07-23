#!/usr/bin/env sh

### Script: word-quiz-to-csv.sh
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

readonly 'VERSION=word-quiz-to-csv.sh 0.0.1'

set -Cefu
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

. "${0%/*}/../lib/getoptions.sh"
. "${0%/*}/../lib/sysexits.sh"
. 'modernish'

use 'safe'
use 'var/string/replacein'

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

parser_definition() {
	setup REST abbr:true error:option_error plus:true init:@no no: help:usage \
		-- 'Usage:' "  ${2##*/} [OPTION]..." \
		'' 'Options:'

	option output_strategy   -s --{no-}strategy   on:'strategy.csv'   pattern:'*[!/]' var:FILENAME -- 'ストラテジ系の用語集を出力する'
	option output_management -m --{no-}management on:'management.csv' pattern:'*[!/]' var:FILENAME -- 'マネジメント系の用語集を出力する'
	option output_technology -t --{no-}technology on:'technology.csv' pattern:'*[!/]' var:FILENAME -- 'テクノロジ系の用語集を出力する'
	param wait     -w --wait init:='20' validate:'str ematch "${OPTARG}" "^0$|^[1-9][0-9]*$"' var:'SECONDS' -- 'ダウンロード時に待機する秒数を指定する'
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

case "${#}" in '0')
	set -- --strategy --management --technology
esac

eval "$(getoptions parser_definition parse "${0}")"
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

if command xmlstarlet --help >|'/dev/null' 2>&1; then
	xml() {
		command xmlstarlet ${@+"${@}"}
	}
fi

putln "${indexes}" | while IFS=' ' read -r category index; do
	eval "output=\"\${output_${category}}\""
	dir="$(dirname -- "${output}"; put '_')"; dir="${dir%?_}"

	mkdir -p "${dir}" || exit "${EX_CANTCREAT}"

	if [ -e "${output}" ]; then
		if [ '!' -f "${output}" ]; then
 			exit "${EX_USAGE}" "'"${output}"' は通常ファイルではありません。"
		elif [ '!' -w "${output}" ]; then
			exit "${EX_CANTCREAT}" "'${output}' の作成または書き込み許可がありません。"
		fi
	elif [ '!' -w "${dir}" ]; then
		exit "${EX_CANTCREAT}" "'${dir}' の書き込み許可がありません。"
	fi
done || end_call "${?}"

putln "${indexes}" | while IFS=' ' read -r category index; do
	eval "output=\"\${output_${category}}\""

	case "${output}" in ?*)
		until wget --no-config --convert-links --output-document="${download}" -- "${index}"; do
			sleep "${wait}"
		done

		xml --quiet format --encode 'UTF-8' --html "${download}" >|"${format}"

		urls=$(xml select --text --template --match '//*[@id="mainCol"]//ul[@class="wordLink cf"]/li/a' --value-of '@href' --nl "${format}")

		sleep "${wait}"

		putln "${urls}" | while IFS='' read -r url; do
			until wget --no-config --convert-links --output-document="${download}" -- "${url}"; do
				sleep "${wait}"
			done

			sed -e '/<link /d' -- "${download}" | xml --quiet format --encode 'UTF-8' --html - >|"${format}"

			putln "${xpathes}" | while IFS='' read -r xpath; do
				field="$(xml select --template --copy-of "${xpath}" "${format}")"
				replacein -a 'field' '"' '""'

				printf '"%s",' "${field}"
			done

			printf '"%s","%s"\r\n' "${url}" "${category}"

			sleep "${wait}"
		done | case "${output}" in
			'-') cat;;
			*) cat >|"${output}";;
		esac
	esac
done
