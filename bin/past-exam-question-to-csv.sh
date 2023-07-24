#!/usr/bin/env sh

### Script: past-exam-question-to-csv.sh
##
## 過去問題集を Anki デッキ用の CSV に変換する。
##
## Metadata:
##
##   id - 69debccb-f2a7-405f-aecb-70da1a3c04be
##   author - <qq542vev at https://purl.org/meta/me/>
##   version - 1.0.0
##   date - 2023-07-25
##   since - 2023-06-20
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
##   past-exam-questions-to-csv.sh [OPTION]...
##
## Options:
##           --{no-}r5-haru[=FILENAME]
##                               令和5年度春期問題を出力する
##           --{no-}r4-haru[=FILENAME]
##                               令和4年度春期問題を出力する
##           --{no-}r3-haru[=FILENAME]
##                               令和3年度春期問題を出力する
##           --{no-}r2-aki[=FILENAME]
##                               令和2年度秋期問題を出力する
##           --{no-}r1-aki[=FILENAME]
##                               令和1年度秋期問題を出力する
##           --{no-}h31-haru[=FILENAME]
##                               平成31年度春期問題を出力する
##           --{no-}h30-aki[=FILENAME]
##                               平成30年度秋期問題を出力する
##           --{no-}h30-haru[=FILENAME]
##                               平成30年度春期問題を出力する
##           --{no-}h29-aki[=FILENAME]
##                               平成29年度秋期問題を出力する
##           --{no-}h29-haru[=FILENAME]
##                               平成29年度春期問題を出力する
##           --{no-}h28-aki[=FILENAME]
##                               平成28年度秋期問題を出力する
##           --{no-}h28-haru[=FILENAME]
##                               平成28年度春期問題を出力する
##           --{no-}h27-aki[=FILENAME]
##                               平成27年度秋期問題を出力する
##           --{no-}h27-haru[=FILENAME]
##                               平成27年度春期問題を出力する
##           --{no-}h26-aki[=FILENAME]
##                               平成26年度秋期問題を出力する
##           --{no-}h26-haru[=FILENAME]
##                               平成26年度春期問題を出力する
##           --{no-}h25-aki[=FILENAME]
##                               平成25年度秋期問題を出力する
##           --{no-}h25-haru[=FILENAME]
##                               平成25年度春期問題を出力する
##           --{no-}h24-aki[=FILENAME]
##                               平成24年度秋期問題を出力する
##           --{no-}h24-haru[=FILENAME]
##                               平成24年度春期問題を出力する
##           --{no-}h23-aki[=FILENAME]
##                               平成23年度秋期問題を出力する
##           --{no-}h23-toku[=FILENAME]
##                               平成23年度特別問題を出力する
##           --{no-}h22-aki[=FILENAME]
##                               平成22年度秋期問題を出力する
##           --{no-}h22-haru[=FILENAME]
##                               平成22年度春期問題を出力する
##           --{no-}h21-aki[=FILENAME]
##                               平成21年度秋期問題を出力する
##           --{no-}h21-haru[=FILENAME]
##                               平成21年度春期問題を出力する
##           --r5-haru-range NUMBER | NUMBER- | -NUMBER | NUMBER-NUMBER
##                               令和5年度春期問題の出題範囲を指定する
##           --r4-haru-range NUMBER | NUMBER- | -NUMBER | NUMBER-NUMBER
##                               令和4年度春期問題の出題範囲を指定する
##           --r3-haru-range NUMBER | NUMBER- | -NUMBER | NUMBER-NUMBER
##                               令和3年度春期問題の出題範囲を指定する
##           --r2-aki-range NUMBER | NUMBER- | -NUMBER | NUMBER-NUMBER
##                               令和2年度秋期問題の出題範囲を指定する
##           --r1-aki-range NUMBER | NUMBER- | -NUMBER | NUMBER-NUMBER
##                               令和1年度秋期問題の出題範囲を指定する
##           --h31-haru-range NUMBER | NUMBER- | -NUMBER | NUMBER-NUMBER
##                               平成31年度春期問題の出題範囲を指定する
##           --h30-aki-range NUMBER | NUMBER- | -NUMBER | NUMBER-NUMBER
##                               平成30年度秋期問題の出題範囲を指定する
##           --h30-haru-range NUMBER | NUMBER- | -NUMBER | NUMBER-NUMBER
##                               平成30年度春期問題の出題範囲を指定する
##           --h29-aki-range NUMBER | NUMBER- | -NUMBER | NUMBER-NUMBER
##                               平成29年度秋期問題の出題範囲を指定する
##           --h29-haru-range NUMBER | NUMBER- | -NUMBER | NUMBER-NUMBER
##                               平成29年度春期問題の出題範囲を指定する
##           --h28-aki-range NUMBER | NUMBER- | -NUMBER | NUMBER-NUMBER
##                               平成28年度秋期問題の出題範囲を指定する
##           --h28-haru-range NUMBER | NUMBER- | -NUMBER | NUMBER-NUMBER
##                               平成28年度春期問題の出題範囲を指定する
##           --h27-aki-range NUMBER | NUMBER- | -NUMBER | NUMBER-NUMBER
##                               平成27年度秋期問題の出題範囲を指定する
##           --h27-haru-range NUMBER | NUMBER- | -NUMBER | NUMBER-NUMBER
##                               平成27年度春期問題の出題範囲を指定する
##           --h26-aki-range NUMBER | NUMBER- | -NUMBER | NUMBER-NUMBER
##                               平成26年度秋期問題の出題範囲を指定する
##           --h26-haru-range NUMBER | NUMBER- | -NUMBER | NUMBER-NUMBER
##                               平成26年度春期問題の出題範囲を指定する
##           --h25-aki-range NUMBER | NUMBER- | -NUMBER | NUMBER-NUMBER
##                               平成25年度秋期問題の出題範囲を指定する
##           --h25-haru-range NUMBER | NUMBER- | -NUMBER | NUMBER-NUMBER
##                               平成25年度春期問題の出題範囲を指定する
##           --h24-aki-range NUMBER | NUMBER- | -NUMBER | NUMBER-NUMBER
##                               平成24年度秋期問題の出題範囲を指定する
##           --h24-haru-range NUMBER | NUMBER- | -NUMBER | NUMBER-NUMBER
##                               平成24年度春期問題の出題範囲を指定する
##           --h23-aki-range NUMBER | NUMBER- | -NUMBER | NUMBER-NUMBER
##                               平成23年度秋期問題の出題範囲を指定する
##           --h23-toku-range NUMBER | NUMBER- | -NUMBER | NUMBER-NUMBER
##                               平成23年度特別問題の出題範囲を指定する
##           --h22-aki-range NUMBER | NUMBER- | -NUMBER | NUMBER-NUMBER
##                               平成22年度秋期問題の出題範囲を指定する
##           --h22-haru-range NUMBER | NUMBER- | -NUMBER | NUMBER-NUMBER
##                               平成22年度春期問題の出題範囲を指定する
##           --h21-aki-range NUMBER | NUMBER- | -NUMBER | NUMBER-NUMBER
##                               平成21年度秋期問題の出題範囲を指定する
##           --h21-haru-range NUMBER | NUMBER- | -NUMBER | NUMBER-NUMBER
##                               平成21年度春期問題の出題範囲を指定する
##           --{no-}image-dir[=DIRECTORY]
##                               画像を保存するディレクトリを指定する
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

readonly 'VERSION=past-exam-question-to-csv.sh 0.0.1'

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
use 'var/loop'

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

### Function: imgsrc_repalase
##
## ファイル内で参照している画像をダウンロードする。
##
## Parameters:
##
##   $1 - ダウンロードした画像を保存するディレクトリ。
##   $2 - 画像を参照しているノードの XPath。
##   $3 - XML ファイルのパス。

imgsrc_repalase() {
	set -- ${@+"${@}"} "$(mktemp)" '1' "$(xml select --template --value-of "count(${2})" "${3}")"

	mkdir -p -- "${1}"

	while [ "${5}" -le "${6}" ]; do
		set -- ${@+"${@}"} "$(xml select --text --template --value-of "(${2})[${5}]" "${3}")"
		set -- ${@+"${@}"} "$(printf '%s' "${7}" | base64 | tr -d -- '\n=' | tr -- '+/' '-_')"

		until wget --no-config --output-document="${1}/${8}" -- "${7}"; do
			sleep "${WAITTIME:-20}"
		done

		xml edit --update "(${2})[${5}]" --value "${8}" "${3}" >|"${4}"
		cat -- "${4}" >|"${3}"

		set -- "${1}" "${2}" "${3}" "${4}" "$((${5} + 1))" "${6}"

		if [ "${5}" -ne "${6}" ]; then
			sleep "${WAITTIME:-20}"
		fi
	done

	rm -f -- "${4}"
}

### Function: normalize_range
##
## 範囲の数値を正規化する。
##
## Parameters:
##
##   $1 - 結果を代入する変数名。
##   $2 - 正規化する範囲の数値。

normalize_range() {
	set -- "${1}" "$(awk -v "min=${3-1}" -v "max=${4-100}" -- '
		BEGIN {
			count = split(ARGV[1], ranges, ",");

			for(i = 1; i <= count; i++) {
				start = min;
				end = max;

				if(ranges[i] ~ /^[0-9]+$/) {
					start = end = int(ranges[i])
				} else {
					if(ranges[i] ~ /^[0-9]+-[0-9]*$/) {
						start = int(substr(ranges[i], 1, index(ranges[i], "-") - 1))
					}

					if(ranges[i] ~ /^[0-9]*-[0-9]+$/) {
						end = int(substr(ranges[i], index(ranges[i], "-") + 1))
					}
				}

				if(end < start) {
					tmp = start
					start = end
					end = tmp
				}

				if(start < min) {
					start = min
				}

				if(max < end) {
					end = max
				}

				printf("%d-%d%s", start, end, (i < count) ? "," : "")
			}
		}
	' "${2}")"

	eval "${1}=\"\${2}\""
}

parser_definition() {
	print_option() {
		case "${1}" in
			'r') set -- ${@+"${@}"} '令和';;
			'h') set -- ${@+"${@}"} '平成';;
		esac

		case "${3}" in
			'haru') set -- ${@+"${@}"} '春期';;
			'aki') set -- ${@+"${@}"} '秋期';;
			'toku') set -- ${@+"${@}"} '特別';;
		esac

		option "output_${1}${2}_${3}" "--{no-}${1}${2}-${3}" on:"${1}${2}-${3}.csv" pattern:'*[!/]' var:FILENAME -- "${4}${2}年度${5}問題を出力する"
	}

	print_param() {
		case "${1}" in
			'r') set -- ${@+"${@}"} '令和';;
			'h') set -- ${@+"${@}"} '平成';;
		esac

		case "${3}" in
			'haru') set -- ${@+"${@}"} '春期';;
			'aki') set -- ${@+"${@}"} '秋期';;
			'toku') set -- ${@+"${@}"} '特別';;
		esac

		param ":normalize_range range_${1}${2}_${3} \"\${OPTARG}\"" "range_${2}_${3}" "--${1}${2}-${3}-range" init:='1-100' validate:'str ematch "${OPTARG}" "^([1-9][0-9]*(-([1-9][0-9]*)?)?|-[1-9][0-9]*)(,[1-9][0-9]*(-([1-9][0-9]*)?)?|,-[1-9][0-9]*)*$"' var:'NUMBER | START- | -END | START-END' -- "${4}${2}年度${5}問題の出題範囲を指定する"
	}

	setup REST abbr:true error:option_error plus:true init:@no no: help:usage \
		-- 'Usage:' "  ${2##*/} [OPTION]..." \
		'' 'Options:'

	for param in '05-haru' '04-haru' '03-haru' '02-aki' '01-aki'; do
		print_option 'r' "${param%%-*}" "${param##*-}"
	done

	for param in \
		'31-haru' '30-aki' '30-haru' '29-aki' '29-haru' \
		'28-aki' '28-haru' '27-aki' '27-haru' '26-aki' '26-haru' '25-aki' '25-haru' \
		'24-aki' '24-haru' '23-aki' '23-toku' '22-aki' '22-haru' '21-aki' '21-haru'
	do
		print_option 'h' "${param%%-*}" "${param##*-}"
	done

	for param in '05-haru' '04-haru' '03-haru' '02-aki' '01-aki'; do
		print_param 'r' "${param%%-*}" "${param##*-}"
	done

	for param in \
		'31-haru' '30-aki' '30-haru' '29-aki' '29-haru' \
		'28-aki' '28-haru' '27-aki' '27-haru' '26-aki' '26-haru' '25-aki' '25-haru' \
		'24-aki' '24-haru' '23-aki' '23-toku' '22-aki' '22-haru' '21-aki' '21-haru'
	do
		print_param 'h' "${param%%-*}" "${param##*-}"
	done

	param imageDir --{no-}image-dir init:='collection.media' var:DIRECTORY -- '画像を保存するディレクトリを指定する'
	param wait     -w --wait init:='20' validate:'str ematch "${OPTARG}" "^0$|^[1-9][0-9]*$"' var:'SECONDS' -- 'ダウンロード時に待機する秒数を指定する'
	disp   :usage   -h --help    -- 'このヘルプを表示して終了する'
	disp   VERSION  -v --version -- 'バージョン情報を表示して終了する'

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
	set -- --r5-haru --r4-haru --r3-haru --r2-aki --r1-aki --h31-haru --h30-aki --h30-haru --h29-aki --h29-haru --h28-aki --h28-haru --h27-aki --h27-haru --h26-aki --h26-haru --h25-aki --h25-haru --h24-aki --h24-haru --h23-aki --h23-toku --h22-aki --h22-haru --h21-aki --h21-haru
esac

eval "$(getoptions parser_definition parse "${0}")"
parse ${@+"${@}"}
eval "set -- ${REST}"

EXAMS="$(
	cat <<-'__EOF__'
	r05_haru https://web.archive.org/web/20230620000000/https://www.itpassportsiken.com/kakomon/05_haru/q%d.html
	r04_haru https://web.archive.org/web/20230620000000/https://www.itpassportsiken.com/kakomon/04_haru/q%d.html
	r03_haru https://web.archive.org/web/20230620000000/https://www.itpassportsiken.com/kakomon/03_haru/q%d.html
	r02_aki https://web.archive.org/web/20230620000000/https://www.itpassportsiken.com/kakomon/02_aki/q%d.html
	r01_aki https://web.archive.org/web/20230620000000/https://www.itpassportsiken.com/kakomon/01_aki/q%d.html
	h31_haru https://web.archive.org/web/20230620000000/https://www.itpassportsiken.com/kakomon/31_haru/q%d.html
	h30_aki https://web.archive.org/web/20230620000000/https://www.itpassportsiken.com/kakomon/30_aki/q%d.html
	h30_haru https://web.archive.org/web/20230620000000/https://www.itpassportsiken.com/kakomon/30_haru/q%d.html
	h29_aki https://web.archive.org/web/20230620000000/https://www.itpassportsiken.com/kakomon/29_aki/q%d.html
	h29_haru https://web.archive.org/web/20230620000000/https://www.itpassportsiken.com/kakomon/29_haru/q%d.html
	h28_aki https://web.archive.org/web/20230620000000/https://www.itpassportsiken.com/kakomon/28_aki/q%d.html
	h28_haru https://web.archive.org/web/20230620000000/https://www.itpassportsiken.com/kakomon/28_haru/q%d.html
	h27_aki https://web.archive.org/web/20230620000000/https://www.itpassportsiken.com/kakomon/27_aki/q%d.html
	h27_haru https://web.archive.org/web/20230620000000/https://www.itpassportsiken.com/kakomon/27_haru/q%d.html
	h26_aki https://web.archive.org/web/20230620000000/https://www.itpassportsiken.com/kakomon/26_aki/q%d.html
	h26_haru https://web.archive.org/web/20230620000000/https://www.itpassportsiken.com/kakomon/26_haru/q%d.html
	h25_aki https://web.archive.org/web/20230620000000/https://www.itpassportsiken.com/kakomon/25_aki/q%d.html
	h25_haru https://web.archive.org/web/20230620000000/https://www.itpassportsiken.com/kakomon/25_haru/q%d.html
	h24_aki https://web.archive.org/web/20230620000000/https://www.itpassportsiken.com/kakomon/24_aki/q%d.html
	h24_haru https://web.archive.org/web/20230620000000/https://www.itpassportsiken.com/kakomon/24_haru/q%d.html
	h23_aki https://web.archive.org/web/20230620000000/https://www.itpassportsiken.com/kakomon/23_aki/q%d.html
	h23_toku https://web.archive.org/web/20230620000000/https://www.itpassportsiken.com/kakomon/23_toku/q%d.html
	h22_aki https://web.archive.org/web/20230620000000/https://www.itpassportsiken.com/kakomon/22_aki/q%d.html
	h22_haru https://web.archive.org/web/20230620000000/https://www.itpassportsiken.com/kakomon/22_haru/q%d.html
	h21_aki https://web.archive.org/web/20230620000000/https://www.itpassportsiken.com/kakomon/21_aki/q%d.html
	h21_haru https://web.archive.org/web/20230620000000/https://www.itpassportsiken.com/kakomon/21_haru/q%d.html
	__EOF__
)"
XPATHES="$(
	cat <<-'__EOF__'
	//main//h2//text()
	//*[@id="mondai"]/node()
	//main//*[@class="ansbg"][1]/node()[self::* or self::text()]
	//*[@id="answerChar"]//text()
	//main//*[@class="ansbg"][2]/node()[self::* or self::text()]
	//main//h3[.="分類"]/following-sibling::p[1]//text()
	__EOF__
)"
IMGSRC_XPATH='(//*[@id="mondai"] | //main//*[@class="ansbg"][1] | //main//*[@class="ansbg"][2])//img[@src]/@src'
AWK_RANGE_PRINT="$(
	cat <<-'__EOF__'
	BEGIN {
		count = split(ARGV[1], ranges, ",");

		for(i = 1; i <= count; i++) {
			start = int(substr(ranges[i], 1, index(ranges[i], "-") - 1))
			end = int(substr(ranges[i], index(ranges[i], "-") + 1))

			for(n = start; n <= end; n++) {
				print(n);
			}
		}
	}
	__EOF__
)"
tmpDir="$(mktemp -d)"
download="${tmpDir}/download"
format="${tmpDir}/format"

readonly 'EXAMS' 'XPATHES' 'IMGSRC_XPATH' 'AWK_RANGE_PRINT'
export "TMPDIR=${tmpDir}"

if command xmlstarlet --help >'/dev/null' 2>&1; then
	xml() {
		command xmlstarlet ${@+"${@}"}
	}
fi

case "${imageDir}" in ?*)
	mkdir -p "${imageDir}" || exit "${EX_CANTCREAT}"

	if ! [ -w "${imageDir}" ]; then
		printf "%s: '%s' の書き込み許可がありません。\\n" "${0##*/}" "${imageDir}" >&2

		end_call "${EX_CANTCREAT}"
	fi
esac

putln "${EXAMS}" | while IFS=' ' read -r name pattarn; do
	eval "output=\"\${output_${name}}\""
	dir="$(dirname -- "${output}"; put '_')"; dir="${dir%?_}"

	mkdir -p "${dir}" || exit "${EX_CANTCREAT}"

	if [ -e "${output}" ]; then
		if ! [ -f "${output}" ]; then
 			exit "${EX_USAGE}" "'${output}' は通常ファイルではありません。"
		elif ! [ -w "${output}" ]; then
			exit "${EX_CANTCREAT}" "'${output}' の作成または書き込み許可がありません。"
		fi
	elif ! [ -w "${dir}" ]; then
		exit "${EX_CANTCREAT}" "'${dir}' の書き込み許可がありません。"
	fi
done || end_call "${?}"

putln "${EXAMS}" | while IFS=' ' read -r name pattarn; do
	eval "output=\"\${output_${name}}\""
	eval "range=\"\${range_${name}}\""

	case "${output}" in ?*)
		awk -- "${AWK_RANGE_PRINT}" "${range}" | while IFS='' read -r n; do
			url=$(printf "${pattarn}" "${n}")

			until wget --no-config --convert-links --output-document="${download}" -- "${url}"; do
				sleep "${wait}"
			done

			sed -e 's/charset="Shift_JIS"/charset="CP932"/' -- "${download}" | xml --quiet format --encode 'UTF-8' --html - >|"${format}"

			case "${imageDir}" in ?*)
				WAITTIME="${wait}" imgsrc_repalase "${imageDir}" "${IMGSRC_XPATH}" "${format}";;
			esac

			printf '"%s:%03d",' "${name}" "${n}"

			printf '%s\n' "${XPATHES}" | while IFS='' read -r xpath; do
				field=$(xml select --template --copy-of "${xpath}" "${format}")
				replacein -a 'field' '"' '""'

				printf '"%s",' "${field}"
			done

			printf '"%s"\r\n' "${url}"

			sleep "${wait}"
		done | case "${output}" in
			'-') cat;;
			*) cat >|"${output}";;
		esac
	esac
done
