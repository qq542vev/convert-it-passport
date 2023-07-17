#!/usr/bin/env sh

### Script: past-exam-questions-to-csv.sh
##
## 過去問題集を Anki デッキ用の CSV に変換する。
##
## Metadata:
##
##   id - 69debccb-f2a7-405f-aecb-70da1a3c04be
##   author - <qq542vev at https://purl.org/meta/me/>
##   version - 0.0.1
##   date - 2023-06-20
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

readonly 'VERSION=past-exam-questions-to-csv.sh 0.0.1'

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

		xml edit --update "(${2})[${5}]" --value "${8}" "${3}" >"${4}"
		cat -- "${4}" >"${3}"

		set -- "${1}" "${2}" "${3}" "${4}" "$((${5} + 1))" "${6}"

		if [ "${5}" -ne "${6}" ]; then
			sleep "${WAITTIME:-20}"
		fi
	done

	rm -f -- "${4}"
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

# @getoptions
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

		option "$(printf 'output_%s%02d_%s' "${1}" "${2}" "${3}")" "--{no-}${1}${2}-${3}" on:"$(printf '%s%02d-%s.csv' "${1}" "${2}" "${3}")" pattern:'*[!/]' var:FILENAME -- "${4}${2}年度${5}問題を出力する"
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

		param "$(printf ':normalize_range range_%s%02d_%s "${OPTARG}"' "${1}" "${2}" "${3}")" "$(printf 'range_%02d_%s' "${2}" "${3}")" "--${1}${2}-${3}-range" init:='1-100' validate:'regex_match "${OPTARG}" "^([1-9][0-9]*(-([1-9][0-9]*)?)?|-[1-9][0-9]*)(,[1-9][0-9]*(-([1-9][0-9]*)?)?|,-[1-9][0-9]*)*$"' var:'NUMBER | START- | -END | START-END' -- "${4}${2}年度${5}問題の出題範囲を指定する"
	}

	setup REST abbr:true error:option_error plus:true init:@no no: help:usage \
		-- 'Usage:' "  ${2##*/} [OPTION]..." \
		'' 'Options:'

	for param in '5-haru' '4-haru' '3-haru' '2-aki' '1-aki'; do
		print_option 'r' "${param%%-*}" "${param##*-}"
	done

	for param in \
		'31-haru' '30-aki' '30-haru' '29-aki' '29-haru' \
		'28-aki' '28-haru' '27-aki' '27-haru' '26-aki' '26-haru' '25-aki' '25-haru' \
		'24-aki' '24-haru' '23-aki' '23-toku' '22-aki' '22-haru' '21-aki' '21-haru'
	do
		print_option 'h' "${param%%-*}" "${param##*-}"
	done

	for param in '5-haru' '4-haru' '3-haru' '2-aki' '1-aki'; do
		print_param 'r' "${param%%-*}" "${param##*-}"
	done

	for param in \
		'31-haru' '30-aki' '30-haru' '29-aki' '29-haru' \
		'28-aki' '28-haru' '27-aki' '27-haru' '26-aki' '26-haru' '25-aki' '25-haru' \
		'24-aki' '24-haru' '23-aki' '23-toku' '22-aki' '22-haru' '21-aki' '21-haru'
	do
		print_param 'h' "${param%%-*}" "${param##*-}"
	done

	option imageDir --{no-}image-dir init:='collection.media' var:DIRECTORY -- '画像を保存するディレクトリを指定する'
	param wait      -w --wait init:='20' validate:'regex_match "${OPTARG}" "^0$|^[1-9][0-9]*$"' var:'SECONDS' -- 'ダウンロード時に待機する秒数を指定する'
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
# @end

# @gengetoptions parser -i parser_definition parse "${1}"
# Generated by getoptions (BEGIN)
# URL: https://github.com/ko1nksm/getoptions (v3.3.0)
output_r05_haru=''
output_r04_haru=''
output_r03_haru=''
output_r02_aki=''
output_r01_aki=''
output_h31_haru=''
output_h30_aki=''
output_h30_haru=''
output_h29_aki=''
output_h29_haru=''
output_h28_aki=''
output_h28_haru=''
output_h27_aki=''
output_h27_haru=''
output_h26_aki=''
output_h26_haru=''
output_h25_aki=''
output_h25_haru=''
output_h24_aki=''
output_h24_haru=''
output_h23_aki=''
output_h23_toku=''
output_h22_aki=''
output_h22_haru=''
output_h21_aki=''
output_h21_haru=''
OPTARG='1-100'; normalize_range range_r05_haru "${OPTARG}"
OPTARG='1-100'; normalize_range range_r04_haru "${OPTARG}"
OPTARG='1-100'; normalize_range range_r03_haru "${OPTARG}"
OPTARG='1-100'; normalize_range range_r02_aki "${OPTARG}"
OPTARG='1-100'; normalize_range range_r01_aki "${OPTARG}"
OPTARG='1-100'; normalize_range range_h31_haru "${OPTARG}"
OPTARG='1-100'; normalize_range range_h30_aki "${OPTARG}"
OPTARG='1-100'; normalize_range range_h30_haru "${OPTARG}"
OPTARG='1-100'; normalize_range range_h29_aki "${OPTARG}"
OPTARG='1-100'; normalize_range range_h29_haru "${OPTARG}"
OPTARG='1-100'; normalize_range range_h28_aki "${OPTARG}"
OPTARG='1-100'; normalize_range range_h28_haru "${OPTARG}"
OPTARG='1-100'; normalize_range range_h27_aki "${OPTARG}"
OPTARG='1-100'; normalize_range range_h27_haru "${OPTARG}"
OPTARG='1-100'; normalize_range range_h26_aki "${OPTARG}"
OPTARG='1-100'; normalize_range range_h26_haru "${OPTARG}"
OPTARG='1-100'; normalize_range range_h25_aki "${OPTARG}"
OPTARG='1-100'; normalize_range range_h25_haru "${OPTARG}"
OPTARG='1-100'; normalize_range range_h24_aki "${OPTARG}"
OPTARG='1-100'; normalize_range range_h24_haru "${OPTARG}"
OPTARG='1-100'; normalize_range range_h23_aki "${OPTARG}"
OPTARG='1-100'; normalize_range range_h23_toku "${OPTARG}"
OPTARG='1-100'; normalize_range range_h22_aki "${OPTARG}"
OPTARG='1-100'; normalize_range range_h22_haru "${OPTARG}"
OPTARG='1-100'; normalize_range range_h21_aki "${OPTARG}"
OPTARG='1-100'; normalize_range range_h21_haru "${OPTARG}"
imageDir='collection.media'
wait='20'
REST=''
parse() {
  OPTIND=$(($#+1))
  while OPTARG= && [ $# -gt 0 ]; do
    set -- "${1%%\=*}" "${1#*\=}" "$@"
    while [ ${#1} -gt 2 ]; do
      case $1 in (*[!a-zA-Z0-9_-]*) break; esac
      case '--r5-haru' in
        "$1") OPTARG=; break ;;
        $1*) OPTARG="$OPTARG --r5-haru"
      esac
      case '--no-r5-haru' in
        "$1") OPTARG=; break ;;
        $1*) OPTARG="$OPTARG --no-r5-haru"
      esac
      case '--r4-haru' in
        "$1") OPTARG=; break ;;
        $1*) OPTARG="$OPTARG --r4-haru"
      esac
      case '--no-r4-haru' in
        "$1") OPTARG=; break ;;
        $1*) OPTARG="$OPTARG --no-r4-haru"
      esac
      case '--r3-haru' in
        "$1") OPTARG=; break ;;
        $1*) OPTARG="$OPTARG --r3-haru"
      esac
      case '--no-r3-haru' in
        "$1") OPTARG=; break ;;
        $1*) OPTARG="$OPTARG --no-r3-haru"
      esac
      case '--r2-aki' in
        "$1") OPTARG=; break ;;
        $1*) OPTARG="$OPTARG --r2-aki"
      esac
      case '--no-r2-aki' in
        "$1") OPTARG=; break ;;
        $1*) OPTARG="$OPTARG --no-r2-aki"
      esac
      case '--r1-aki' in
        "$1") OPTARG=; break ;;
        $1*) OPTARG="$OPTARG --r1-aki"
      esac
      case '--no-r1-aki' in
        "$1") OPTARG=; break ;;
        $1*) OPTARG="$OPTARG --no-r1-aki"
      esac
      case '--h31-haru' in
        "$1") OPTARG=; break ;;
        $1*) OPTARG="$OPTARG --h31-haru"
      esac
      case '--no-h31-haru' in
        "$1") OPTARG=; break ;;
        $1*) OPTARG="$OPTARG --no-h31-haru"
      esac
      case '--h30-aki' in
        "$1") OPTARG=; break ;;
        $1*) OPTARG="$OPTARG --h30-aki"
      esac
      case '--no-h30-aki' in
        "$1") OPTARG=; break ;;
        $1*) OPTARG="$OPTARG --no-h30-aki"
      esac
      case '--h30-haru' in
        "$1") OPTARG=; break ;;
        $1*) OPTARG="$OPTARG --h30-haru"
      esac
      case '--no-h30-haru' in
        "$1") OPTARG=; break ;;
        $1*) OPTARG="$OPTARG --no-h30-haru"
      esac
      case '--h29-aki' in
        "$1") OPTARG=; break ;;
        $1*) OPTARG="$OPTARG --h29-aki"
      esac
      case '--no-h29-aki' in
        "$1") OPTARG=; break ;;
        $1*) OPTARG="$OPTARG --no-h29-aki"
      esac
      case '--h29-haru' in
        "$1") OPTARG=; break ;;
        $1*) OPTARG="$OPTARG --h29-haru"
      esac
      case '--no-h29-haru' in
        "$1") OPTARG=; break ;;
        $1*) OPTARG="$OPTARG --no-h29-haru"
      esac
      case '--h28-aki' in
        "$1") OPTARG=; break ;;
        $1*) OPTARG="$OPTARG --h28-aki"
      esac
      case '--no-h28-aki' in
        "$1") OPTARG=; break ;;
        $1*) OPTARG="$OPTARG --no-h28-aki"
      esac
      case '--h28-haru' in
        "$1") OPTARG=; break ;;
        $1*) OPTARG="$OPTARG --h28-haru"
      esac
      case '--no-h28-haru' in
        "$1") OPTARG=; break ;;
        $1*) OPTARG="$OPTARG --no-h28-haru"
      esac
      case '--h27-aki' in
        "$1") OPTARG=; break ;;
        $1*) OPTARG="$OPTARG --h27-aki"
      esac
      case '--no-h27-aki' in
        "$1") OPTARG=; break ;;
        $1*) OPTARG="$OPTARG --no-h27-aki"
      esac
      case '--h27-haru' in
        "$1") OPTARG=; break ;;
        $1*) OPTARG="$OPTARG --h27-haru"
      esac
      case '--no-h27-haru' in
        "$1") OPTARG=; break ;;
        $1*) OPTARG="$OPTARG --no-h27-haru"
      esac
      case '--h26-aki' in
        "$1") OPTARG=; break ;;
        $1*) OPTARG="$OPTARG --h26-aki"
      esac
      case '--no-h26-aki' in
        "$1") OPTARG=; break ;;
        $1*) OPTARG="$OPTARG --no-h26-aki"
      esac
      case '--h26-haru' in
        "$1") OPTARG=; break ;;
        $1*) OPTARG="$OPTARG --h26-haru"
      esac
      case '--no-h26-haru' in
        "$1") OPTARG=; break ;;
        $1*) OPTARG="$OPTARG --no-h26-haru"
      esac
      case '--h25-aki' in
        "$1") OPTARG=; break ;;
        $1*) OPTARG="$OPTARG --h25-aki"
      esac
      case '--no-h25-aki' in
        "$1") OPTARG=; break ;;
        $1*) OPTARG="$OPTARG --no-h25-aki"
      esac
      case '--h25-haru' in
        "$1") OPTARG=; break ;;
        $1*) OPTARG="$OPTARG --h25-haru"
      esac
      case '--no-h25-haru' in
        "$1") OPTARG=; break ;;
        $1*) OPTARG="$OPTARG --no-h25-haru"
      esac
      case '--h24-aki' in
        "$1") OPTARG=; break ;;
        $1*) OPTARG="$OPTARG --h24-aki"
      esac
      case '--no-h24-aki' in
        "$1") OPTARG=; break ;;
        $1*) OPTARG="$OPTARG --no-h24-aki"
      esac
      case '--h24-haru' in
        "$1") OPTARG=; break ;;
        $1*) OPTARG="$OPTARG --h24-haru"
      esac
      case '--no-h24-haru' in
        "$1") OPTARG=; break ;;
        $1*) OPTARG="$OPTARG --no-h24-haru"
      esac
      case '--h23-aki' in
        "$1") OPTARG=; break ;;
        $1*) OPTARG="$OPTARG --h23-aki"
      esac
      case '--no-h23-aki' in
        "$1") OPTARG=; break ;;
        $1*) OPTARG="$OPTARG --no-h23-aki"
      esac
      case '--h23-toku' in
        "$1") OPTARG=; break ;;
        $1*) OPTARG="$OPTARG --h23-toku"
      esac
      case '--no-h23-toku' in
        "$1") OPTARG=; break ;;
        $1*) OPTARG="$OPTARG --no-h23-toku"
      esac
      case '--h22-aki' in
        "$1") OPTARG=; break ;;
        $1*) OPTARG="$OPTARG --h22-aki"
      esac
      case '--no-h22-aki' in
        "$1") OPTARG=; break ;;
        $1*) OPTARG="$OPTARG --no-h22-aki"
      esac
      case '--h22-haru' in
        "$1") OPTARG=; break ;;
        $1*) OPTARG="$OPTARG --h22-haru"
      esac
      case '--no-h22-haru' in
        "$1") OPTARG=; break ;;
        $1*) OPTARG="$OPTARG --no-h22-haru"
      esac
      case '--h21-aki' in
        "$1") OPTARG=; break ;;
        $1*) OPTARG="$OPTARG --h21-aki"
      esac
      case '--no-h21-aki' in
        "$1") OPTARG=; break ;;
        $1*) OPTARG="$OPTARG --no-h21-aki"
      esac
      case '--h21-haru' in
        "$1") OPTARG=; break ;;
        $1*) OPTARG="$OPTARG --h21-haru"
      esac
      case '--no-h21-haru' in
        "$1") OPTARG=; break ;;
        $1*) OPTARG="$OPTARG --no-h21-haru"
      esac
      case '--r5-haru-range' in
        "$1") OPTARG=; break ;;
        $1*) OPTARG="$OPTARG --r5-haru-range"
      esac
      case '--r4-haru-range' in
        "$1") OPTARG=; break ;;
        $1*) OPTARG="$OPTARG --r4-haru-range"
      esac
      case '--r3-haru-range' in
        "$1") OPTARG=; break ;;
        $1*) OPTARG="$OPTARG --r3-haru-range"
      esac
      case '--r2-aki-range' in
        "$1") OPTARG=; break ;;
        $1*) OPTARG="$OPTARG --r2-aki-range"
      esac
      case '--r1-aki-range' in
        "$1") OPTARG=; break ;;
        $1*) OPTARG="$OPTARG --r1-aki-range"
      esac
      case '--h31-haru-range' in
        "$1") OPTARG=; break ;;
        $1*) OPTARG="$OPTARG --h31-haru-range"
      esac
      case '--h30-aki-range' in
        "$1") OPTARG=; break ;;
        $1*) OPTARG="$OPTARG --h30-aki-range"
      esac
      case '--h30-haru-range' in
        "$1") OPTARG=; break ;;
        $1*) OPTARG="$OPTARG --h30-haru-range"
      esac
      case '--h29-aki-range' in
        "$1") OPTARG=; break ;;
        $1*) OPTARG="$OPTARG --h29-aki-range"
      esac
      case '--h29-haru-range' in
        "$1") OPTARG=; break ;;
        $1*) OPTARG="$OPTARG --h29-haru-range"
      esac
      case '--h28-aki-range' in
        "$1") OPTARG=; break ;;
        $1*) OPTARG="$OPTARG --h28-aki-range"
      esac
      case '--h28-haru-range' in
        "$1") OPTARG=; break ;;
        $1*) OPTARG="$OPTARG --h28-haru-range"
      esac
      case '--h27-aki-range' in
        "$1") OPTARG=; break ;;
        $1*) OPTARG="$OPTARG --h27-aki-range"
      esac
      case '--h27-haru-range' in
        "$1") OPTARG=; break ;;
        $1*) OPTARG="$OPTARG --h27-haru-range"
      esac
      case '--h26-aki-range' in
        "$1") OPTARG=; break ;;
        $1*) OPTARG="$OPTARG --h26-aki-range"
      esac
      case '--h26-haru-range' in
        "$1") OPTARG=; break ;;
        $1*) OPTARG="$OPTARG --h26-haru-range"
      esac
      case '--h25-aki-range' in
        "$1") OPTARG=; break ;;
        $1*) OPTARG="$OPTARG --h25-aki-range"
      esac
      case '--h25-haru-range' in
        "$1") OPTARG=; break ;;
        $1*) OPTARG="$OPTARG --h25-haru-range"
      esac
      case '--h24-aki-range' in
        "$1") OPTARG=; break ;;
        $1*) OPTARG="$OPTARG --h24-aki-range"
      esac
      case '--h24-haru-range' in
        "$1") OPTARG=; break ;;
        $1*) OPTARG="$OPTARG --h24-haru-range"
      esac
      case '--h23-aki-range' in
        "$1") OPTARG=; break ;;
        $1*) OPTARG="$OPTARG --h23-aki-range"
      esac
      case '--h23-toku-range' in
        "$1") OPTARG=; break ;;
        $1*) OPTARG="$OPTARG --h23-toku-range"
      esac
      case '--h22-aki-range' in
        "$1") OPTARG=; break ;;
        $1*) OPTARG="$OPTARG --h22-aki-range"
      esac
      case '--h22-haru-range' in
        "$1") OPTARG=; break ;;
        $1*) OPTARG="$OPTARG --h22-haru-range"
      esac
      case '--h21-aki-range' in
        "$1") OPTARG=; break ;;
        $1*) OPTARG="$OPTARG --h21-aki-range"
      esac
      case '--h21-haru-range' in
        "$1") OPTARG=; break ;;
        $1*) OPTARG="$OPTARG --h21-haru-range"
      esac
      case '--image-dir' in
        "$1") OPTARG=; break ;;
        $1*) OPTARG="$OPTARG --image-dir"
      esac
      case '--no-image-dir' in
        "$1") OPTARG=; break ;;
        $1*) OPTARG="$OPTARG --no-image-dir"
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
      -[w]?*) OPTARG=$1; shift
        eval 'set -- "${OPTARG%"${OPTARG#??}"}" "${OPTARG#??}"' ${1+'"$@"'}
        ;;
      -[hv]?*) OPTARG=$1; shift
        eval 'set -- "${OPTARG%"${OPTARG#??}"}" -"${OPTARG#??}"' ${1+'"$@"'}
        OPTARG= ;;
      +*) unset OPTARG ;;
    esac
    case $1 in
      '--r5-haru'|'--no-r5-haru')
        set -- "$1" "$@"
        [ ${OPTARG+x} ] && {
          case $1 in --no-*|--without-*) set "noarg" "${1%%\=*}"; break; esac
          [ "${OPTARG:-}" ] && { shift; OPTARG=$2; } || OPTARG='r05-haru.csv'
        } || OPTARG=''
        case $OPTARG in *[!/]) ;;
          *) set "pattern:*[!/]" "$1"; break
        esac
        output_r05_haru="$OPTARG"
        shift ;;
      '--r4-haru'|'--no-r4-haru')
        set -- "$1" "$@"
        [ ${OPTARG+x} ] && {
          case $1 in --no-*|--without-*) set "noarg" "${1%%\=*}"; break; esac
          [ "${OPTARG:-}" ] && { shift; OPTARG=$2; } || OPTARG='r04-haru.csv'
        } || OPTARG=''
        case $OPTARG in *[!/]) ;;
          *) set "pattern:*[!/]" "$1"; break
        esac
        output_r04_haru="$OPTARG"
        shift ;;
      '--r3-haru'|'--no-r3-haru')
        set -- "$1" "$@"
        [ ${OPTARG+x} ] && {
          case $1 in --no-*|--without-*) set "noarg" "${1%%\=*}"; break; esac
          [ "${OPTARG:-}" ] && { shift; OPTARG=$2; } || OPTARG='r03-haru.csv'
        } || OPTARG=''
        case $OPTARG in *[!/]) ;;
          *) set "pattern:*[!/]" "$1"; break
        esac
        output_r03_haru="$OPTARG"
        shift ;;
      '--r2-aki'|'--no-r2-aki')
        set -- "$1" "$@"
        [ ${OPTARG+x} ] && {
          case $1 in --no-*|--without-*) set "noarg" "${1%%\=*}"; break; esac
          [ "${OPTARG:-}" ] && { shift; OPTARG=$2; } || OPTARG='r02-aki.csv'
        } || OPTARG=''
        case $OPTARG in *[!/]) ;;
          *) set "pattern:*[!/]" "$1"; break
        esac
        output_r02_aki="$OPTARG"
        shift ;;
      '--r1-aki'|'--no-r1-aki')
        set -- "$1" "$@"
        [ ${OPTARG+x} ] && {
          case $1 in --no-*|--without-*) set "noarg" "${1%%\=*}"; break; esac
          [ "${OPTARG:-}" ] && { shift; OPTARG=$2; } || OPTARG='r01-aki.csv'
        } || OPTARG=''
        case $OPTARG in *[!/]) ;;
          *) set "pattern:*[!/]" "$1"; break
        esac
        output_r01_aki="$OPTARG"
        shift ;;
      '--h31-haru'|'--no-h31-haru')
        set -- "$1" "$@"
        [ ${OPTARG+x} ] && {
          case $1 in --no-*|--without-*) set "noarg" "${1%%\=*}"; break; esac
          [ "${OPTARG:-}" ] && { shift; OPTARG=$2; } || OPTARG='h31-haru.csv'
        } || OPTARG=''
        case $OPTARG in *[!/]) ;;
          *) set "pattern:*[!/]" "$1"; break
        esac
        output_h31_haru="$OPTARG"
        shift ;;
      '--h30-aki'|'--no-h30-aki')
        set -- "$1" "$@"
        [ ${OPTARG+x} ] && {
          case $1 in --no-*|--without-*) set "noarg" "${1%%\=*}"; break; esac
          [ "${OPTARG:-}" ] && { shift; OPTARG=$2; } || OPTARG='h30-aki.csv'
        } || OPTARG=''
        case $OPTARG in *[!/]) ;;
          *) set "pattern:*[!/]" "$1"; break
        esac
        output_h30_aki="$OPTARG"
        shift ;;
      '--h30-haru'|'--no-h30-haru')
        set -- "$1" "$@"
        [ ${OPTARG+x} ] && {
          case $1 in --no-*|--without-*) set "noarg" "${1%%\=*}"; break; esac
          [ "${OPTARG:-}" ] && { shift; OPTARG=$2; } || OPTARG='h30-haru.csv'
        } || OPTARG=''
        case $OPTARG in *[!/]) ;;
          *) set "pattern:*[!/]" "$1"; break
        esac
        output_h30_haru="$OPTARG"
        shift ;;
      '--h29-aki'|'--no-h29-aki')
        set -- "$1" "$@"
        [ ${OPTARG+x} ] && {
          case $1 in --no-*|--without-*) set "noarg" "${1%%\=*}"; break; esac
          [ "${OPTARG:-}" ] && { shift; OPTARG=$2; } || OPTARG='h29-aki.csv'
        } || OPTARG=''
        case $OPTARG in *[!/]) ;;
          *) set "pattern:*[!/]" "$1"; break
        esac
        output_h29_aki="$OPTARG"
        shift ;;
      '--h29-haru'|'--no-h29-haru')
        set -- "$1" "$@"
        [ ${OPTARG+x} ] && {
          case $1 in --no-*|--without-*) set "noarg" "${1%%\=*}"; break; esac
          [ "${OPTARG:-}" ] && { shift; OPTARG=$2; } || OPTARG='h29-haru.csv'
        } || OPTARG=''
        case $OPTARG in *[!/]) ;;
          *) set "pattern:*[!/]" "$1"; break
        esac
        output_h29_haru="$OPTARG"
        shift ;;
      '--h28-aki'|'--no-h28-aki')
        set -- "$1" "$@"
        [ ${OPTARG+x} ] && {
          case $1 in --no-*|--without-*) set "noarg" "${1%%\=*}"; break; esac
          [ "${OPTARG:-}" ] && { shift; OPTARG=$2; } || OPTARG='h28-aki.csv'
        } || OPTARG=''
        case $OPTARG in *[!/]) ;;
          *) set "pattern:*[!/]" "$1"; break
        esac
        output_h28_aki="$OPTARG"
        shift ;;
      '--h28-haru'|'--no-h28-haru')
        set -- "$1" "$@"
        [ ${OPTARG+x} ] && {
          case $1 in --no-*|--without-*) set "noarg" "${1%%\=*}"; break; esac
          [ "${OPTARG:-}" ] && { shift; OPTARG=$2; } || OPTARG='h28-haru.csv'
        } || OPTARG=''
        case $OPTARG in *[!/]) ;;
          *) set "pattern:*[!/]" "$1"; break
        esac
        output_h28_haru="$OPTARG"
        shift ;;
      '--h27-aki'|'--no-h27-aki')
        set -- "$1" "$@"
        [ ${OPTARG+x} ] && {
          case $1 in --no-*|--without-*) set "noarg" "${1%%\=*}"; break; esac
          [ "${OPTARG:-}" ] && { shift; OPTARG=$2; } || OPTARG='h27-aki.csv'
        } || OPTARG=''
        case $OPTARG in *[!/]) ;;
          *) set "pattern:*[!/]" "$1"; break
        esac
        output_h27_aki="$OPTARG"
        shift ;;
      '--h27-haru'|'--no-h27-haru')
        set -- "$1" "$@"
        [ ${OPTARG+x} ] && {
          case $1 in --no-*|--without-*) set "noarg" "${1%%\=*}"; break; esac
          [ "${OPTARG:-}" ] && { shift; OPTARG=$2; } || OPTARG='h27-haru.csv'
        } || OPTARG=''
        case $OPTARG in *[!/]) ;;
          *) set "pattern:*[!/]" "$1"; break
        esac
        output_h27_haru="$OPTARG"
        shift ;;
      '--h26-aki'|'--no-h26-aki')
        set -- "$1" "$@"
        [ ${OPTARG+x} ] && {
          case $1 in --no-*|--without-*) set "noarg" "${1%%\=*}"; break; esac
          [ "${OPTARG:-}" ] && { shift; OPTARG=$2; } || OPTARG='h26-aki.csv'
        } || OPTARG=''
        case $OPTARG in *[!/]) ;;
          *) set "pattern:*[!/]" "$1"; break
        esac
        output_h26_aki="$OPTARG"
        shift ;;
      '--h26-haru'|'--no-h26-haru')
        set -- "$1" "$@"
        [ ${OPTARG+x} ] && {
          case $1 in --no-*|--without-*) set "noarg" "${1%%\=*}"; break; esac
          [ "${OPTARG:-}" ] && { shift; OPTARG=$2; } || OPTARG='h26-haru.csv'
        } || OPTARG=''
        case $OPTARG in *[!/]) ;;
          *) set "pattern:*[!/]" "$1"; break
        esac
        output_h26_haru="$OPTARG"
        shift ;;
      '--h25-aki'|'--no-h25-aki')
        set -- "$1" "$@"
        [ ${OPTARG+x} ] && {
          case $1 in --no-*|--without-*) set "noarg" "${1%%\=*}"; break; esac
          [ "${OPTARG:-}" ] && { shift; OPTARG=$2; } || OPTARG='h25-aki.csv'
        } || OPTARG=''
        case $OPTARG in *[!/]) ;;
          *) set "pattern:*[!/]" "$1"; break
        esac
        output_h25_aki="$OPTARG"
        shift ;;
      '--h25-haru'|'--no-h25-haru')
        set -- "$1" "$@"
        [ ${OPTARG+x} ] && {
          case $1 in --no-*|--without-*) set "noarg" "${1%%\=*}"; break; esac
          [ "${OPTARG:-}" ] && { shift; OPTARG=$2; } || OPTARG='h25-haru.csv'
        } || OPTARG=''
        case $OPTARG in *[!/]) ;;
          *) set "pattern:*[!/]" "$1"; break
        esac
        output_h25_haru="$OPTARG"
        shift ;;
      '--h24-aki'|'--no-h24-aki')
        set -- "$1" "$@"
        [ ${OPTARG+x} ] && {
          case $1 in --no-*|--without-*) set "noarg" "${1%%\=*}"; break; esac
          [ "${OPTARG:-}" ] && { shift; OPTARG=$2; } || OPTARG='h24-aki.csv'
        } || OPTARG=''
        case $OPTARG in *[!/]) ;;
          *) set "pattern:*[!/]" "$1"; break
        esac
        output_h24_aki="$OPTARG"
        shift ;;
      '--h24-haru'|'--no-h24-haru')
        set -- "$1" "$@"
        [ ${OPTARG+x} ] && {
          case $1 in --no-*|--without-*) set "noarg" "${1%%\=*}"; break; esac
          [ "${OPTARG:-}" ] && { shift; OPTARG=$2; } || OPTARG='h24-haru.csv'
        } || OPTARG=''
        case $OPTARG in *[!/]) ;;
          *) set "pattern:*[!/]" "$1"; break
        esac
        output_h24_haru="$OPTARG"
        shift ;;
      '--h23-aki'|'--no-h23-aki')
        set -- "$1" "$@"
        [ ${OPTARG+x} ] && {
          case $1 in --no-*|--without-*) set "noarg" "${1%%\=*}"; break; esac
          [ "${OPTARG:-}" ] && { shift; OPTARG=$2; } || OPTARG='h23-aki.csv'
        } || OPTARG=''
        case $OPTARG in *[!/]) ;;
          *) set "pattern:*[!/]" "$1"; break
        esac
        output_h23_aki="$OPTARG"
        shift ;;
      '--h23-toku'|'--no-h23-toku')
        set -- "$1" "$@"
        [ ${OPTARG+x} ] && {
          case $1 in --no-*|--without-*) set "noarg" "${1%%\=*}"; break; esac
          [ "${OPTARG:-}" ] && { shift; OPTARG=$2; } || OPTARG='h23-toku.csv'
        } || OPTARG=''
        case $OPTARG in *[!/]) ;;
          *) set "pattern:*[!/]" "$1"; break
        esac
        output_h23_toku="$OPTARG"
        shift ;;
      '--h22-aki'|'--no-h22-aki')
        set -- "$1" "$@"
        [ ${OPTARG+x} ] && {
          case $1 in --no-*|--without-*) set "noarg" "${1%%\=*}"; break; esac
          [ "${OPTARG:-}" ] && { shift; OPTARG=$2; } || OPTARG='h22-aki.csv'
        } || OPTARG=''
        case $OPTARG in *[!/]) ;;
          *) set "pattern:*[!/]" "$1"; break
        esac
        output_h22_aki="$OPTARG"
        shift ;;
      '--h22-haru'|'--no-h22-haru')
        set -- "$1" "$@"
        [ ${OPTARG+x} ] && {
          case $1 in --no-*|--without-*) set "noarg" "${1%%\=*}"; break; esac
          [ "${OPTARG:-}" ] && { shift; OPTARG=$2; } || OPTARG='h22-haru.csv'
        } || OPTARG=''
        case $OPTARG in *[!/]) ;;
          *) set "pattern:*[!/]" "$1"; break
        esac
        output_h22_haru="$OPTARG"
        shift ;;
      '--h21-aki'|'--no-h21-aki')
        set -- "$1" "$@"
        [ ${OPTARG+x} ] && {
          case $1 in --no-*|--without-*) set "noarg" "${1%%\=*}"; break; esac
          [ "${OPTARG:-}" ] && { shift; OPTARG=$2; } || OPTARG='h21-aki.csv'
        } || OPTARG=''
        case $OPTARG in *[!/]) ;;
          *) set "pattern:*[!/]" "$1"; break
        esac
        output_h21_aki="$OPTARG"
        shift ;;
      '--h21-haru'|'--no-h21-haru')
        set -- "$1" "$@"
        [ ${OPTARG+x} ] && {
          case $1 in --no-*|--without-*) set "noarg" "${1%%\=*}"; break; esac
          [ "${OPTARG:-}" ] && { shift; OPTARG=$2; } || OPTARG='h21-haru.csv'
        } || OPTARG=''
        case $OPTARG in *[!/]) ;;
          *) set "pattern:*[!/]" "$1"; break
        esac
        output_h21_haru="$OPTARG"
        shift ;;
      '--r5-haru-range')
        [ $# -le 1 ] && set "required" "$1" && break
        OPTARG=$2
        regex_match "${OPTARG}" "^([1-9][0-9]*(-([1-9][0-9]*)?)?|-[1-9][0-9]*)(,[1-9][0-9]*(-([1-9][0-9]*)?)?|,-[1-9][0-9]*)*$" || { set -- regex_match:$? "$1" regex_match "${OPTARG}" "^([1-9][0-9]*(-([1-9][0-9]*)?)?|-[1-9][0-9]*)(,[1-9][0-9]*(-([1-9][0-9]*)?)?|,-[1-9][0-9]*)*$"; break; }
        normalize_range range_r05_haru "${OPTARG}"
        shift ;;
      '--r4-haru-range')
        [ $# -le 1 ] && set "required" "$1" && break
        OPTARG=$2
        regex_match "${OPTARG}" "^([1-9][0-9]*(-([1-9][0-9]*)?)?|-[1-9][0-9]*)(,[1-9][0-9]*(-([1-9][0-9]*)?)?|,-[1-9][0-9]*)*$" || { set -- regex_match:$? "$1" regex_match "${OPTARG}" "^([1-9][0-9]*(-([1-9][0-9]*)?)?|-[1-9][0-9]*)(,[1-9][0-9]*(-([1-9][0-9]*)?)?|,-[1-9][0-9]*)*$"; break; }
        normalize_range range_r04_haru "${OPTARG}"
        shift ;;
      '--r3-haru-range')
        [ $# -le 1 ] && set "required" "$1" && break
        OPTARG=$2
        regex_match "${OPTARG}" "^([1-9][0-9]*(-([1-9][0-9]*)?)?|-[1-9][0-9]*)(,[1-9][0-9]*(-([1-9][0-9]*)?)?|,-[1-9][0-9]*)*$" || { set -- regex_match:$? "$1" regex_match "${OPTARG}" "^([1-9][0-9]*(-([1-9][0-9]*)?)?|-[1-9][0-9]*)(,[1-9][0-9]*(-([1-9][0-9]*)?)?|,-[1-9][0-9]*)*$"; break; }
        normalize_range range_r03_haru "${OPTARG}"
        shift ;;
      '--r2-aki-range')
        [ $# -le 1 ] && set "required" "$1" && break
        OPTARG=$2
        regex_match "${OPTARG}" "^([1-9][0-9]*(-([1-9][0-9]*)?)?|-[1-9][0-9]*)(,[1-9][0-9]*(-([1-9][0-9]*)?)?|,-[1-9][0-9]*)*$" || { set -- regex_match:$? "$1" regex_match "${OPTARG}" "^([1-9][0-9]*(-([1-9][0-9]*)?)?|-[1-9][0-9]*)(,[1-9][0-9]*(-([1-9][0-9]*)?)?|,-[1-9][0-9]*)*$"; break; }
        normalize_range range_r02_aki "${OPTARG}"
        shift ;;
      '--r1-aki-range')
        [ $# -le 1 ] && set "required" "$1" && break
        OPTARG=$2
        regex_match "${OPTARG}" "^([1-9][0-9]*(-([1-9][0-9]*)?)?|-[1-9][0-9]*)(,[1-9][0-9]*(-([1-9][0-9]*)?)?|,-[1-9][0-9]*)*$" || { set -- regex_match:$? "$1" regex_match "${OPTARG}" "^([1-9][0-9]*(-([1-9][0-9]*)?)?|-[1-9][0-9]*)(,[1-9][0-9]*(-([1-9][0-9]*)?)?|,-[1-9][0-9]*)*$"; break; }
        normalize_range range_r01_aki "${OPTARG}"
        shift ;;
      '--h31-haru-range')
        [ $# -le 1 ] && set "required" "$1" && break
        OPTARG=$2
        regex_match "${OPTARG}" "^([1-9][0-9]*(-([1-9][0-9]*)?)?|-[1-9][0-9]*)(,[1-9][0-9]*(-([1-9][0-9]*)?)?|,-[1-9][0-9]*)*$" || { set -- regex_match:$? "$1" regex_match "${OPTARG}" "^([1-9][0-9]*(-([1-9][0-9]*)?)?|-[1-9][0-9]*)(,[1-9][0-9]*(-([1-9][0-9]*)?)?|,-[1-9][0-9]*)*$"; break; }
        normalize_range range_h31_haru "${OPTARG}"
        shift ;;
      '--h30-aki-range')
        [ $# -le 1 ] && set "required" "$1" && break
        OPTARG=$2
        regex_match "${OPTARG}" "^([1-9][0-9]*(-([1-9][0-9]*)?)?|-[1-9][0-9]*)(,[1-9][0-9]*(-([1-9][0-9]*)?)?|,-[1-9][0-9]*)*$" || { set -- regex_match:$? "$1" regex_match "${OPTARG}" "^([1-9][0-9]*(-([1-9][0-9]*)?)?|-[1-9][0-9]*)(,[1-9][0-9]*(-([1-9][0-9]*)?)?|,-[1-9][0-9]*)*$"; break; }
        normalize_range range_h30_aki "${OPTARG}"
        shift ;;
      '--h30-haru-range')
        [ $# -le 1 ] && set "required" "$1" && break
        OPTARG=$2
        regex_match "${OPTARG}" "^([1-9][0-9]*(-([1-9][0-9]*)?)?|-[1-9][0-9]*)(,[1-9][0-9]*(-([1-9][0-9]*)?)?|,-[1-9][0-9]*)*$" || { set -- regex_match:$? "$1" regex_match "${OPTARG}" "^([1-9][0-9]*(-([1-9][0-9]*)?)?|-[1-9][0-9]*)(,[1-9][0-9]*(-([1-9][0-9]*)?)?|,-[1-9][0-9]*)*$"; break; }
        normalize_range range_h30_haru "${OPTARG}"
        shift ;;
      '--h29-aki-range')
        [ $# -le 1 ] && set "required" "$1" && break
        OPTARG=$2
        regex_match "${OPTARG}" "^([1-9][0-9]*(-([1-9][0-9]*)?)?|-[1-9][0-9]*)(,[1-9][0-9]*(-([1-9][0-9]*)?)?|,-[1-9][0-9]*)*$" || { set -- regex_match:$? "$1" regex_match "${OPTARG}" "^([1-9][0-9]*(-([1-9][0-9]*)?)?|-[1-9][0-9]*)(,[1-9][0-9]*(-([1-9][0-9]*)?)?|,-[1-9][0-9]*)*$"; break; }
        normalize_range range_h29_aki "${OPTARG}"
        shift ;;
      '--h29-haru-range')
        [ $# -le 1 ] && set "required" "$1" && break
        OPTARG=$2
        regex_match "${OPTARG}" "^([1-9][0-9]*(-([1-9][0-9]*)?)?|-[1-9][0-9]*)(,[1-9][0-9]*(-([1-9][0-9]*)?)?|,-[1-9][0-9]*)*$" || { set -- regex_match:$? "$1" regex_match "${OPTARG}" "^([1-9][0-9]*(-([1-9][0-9]*)?)?|-[1-9][0-9]*)(,[1-9][0-9]*(-([1-9][0-9]*)?)?|,-[1-9][0-9]*)*$"; break; }
        normalize_range range_h29_haru "${OPTARG}"
        shift ;;
      '--h28-aki-range')
        [ $# -le 1 ] && set "required" "$1" && break
        OPTARG=$2
        regex_match "${OPTARG}" "^([1-9][0-9]*(-([1-9][0-9]*)?)?|-[1-9][0-9]*)(,[1-9][0-9]*(-([1-9][0-9]*)?)?|,-[1-9][0-9]*)*$" || { set -- regex_match:$? "$1" regex_match "${OPTARG}" "^([1-9][0-9]*(-([1-9][0-9]*)?)?|-[1-9][0-9]*)(,[1-9][0-9]*(-([1-9][0-9]*)?)?|,-[1-9][0-9]*)*$"; break; }
        normalize_range range_h28_aki "${OPTARG}"
        shift ;;
      '--h28-haru-range')
        [ $# -le 1 ] && set "required" "$1" && break
        OPTARG=$2
        regex_match "${OPTARG}" "^([1-9][0-9]*(-([1-9][0-9]*)?)?|-[1-9][0-9]*)(,[1-9][0-9]*(-([1-9][0-9]*)?)?|,-[1-9][0-9]*)*$" || { set -- regex_match:$? "$1" regex_match "${OPTARG}" "^([1-9][0-9]*(-([1-9][0-9]*)?)?|-[1-9][0-9]*)(,[1-9][0-9]*(-([1-9][0-9]*)?)?|,-[1-9][0-9]*)*$"; break; }
        normalize_range range_h28_haru "${OPTARG}"
        shift ;;
      '--h27-aki-range')
        [ $# -le 1 ] && set "required" "$1" && break
        OPTARG=$2
        regex_match "${OPTARG}" "^([1-9][0-9]*(-([1-9][0-9]*)?)?|-[1-9][0-9]*)(,[1-9][0-9]*(-([1-9][0-9]*)?)?|,-[1-9][0-9]*)*$" || { set -- regex_match:$? "$1" regex_match "${OPTARG}" "^([1-9][0-9]*(-([1-9][0-9]*)?)?|-[1-9][0-9]*)(,[1-9][0-9]*(-([1-9][0-9]*)?)?|,-[1-9][0-9]*)*$"; break; }
        normalize_range range_h27_aki "${OPTARG}"
        shift ;;
      '--h27-haru-range')
        [ $# -le 1 ] && set "required" "$1" && break
        OPTARG=$2
        regex_match "${OPTARG}" "^([1-9][0-9]*(-([1-9][0-9]*)?)?|-[1-9][0-9]*)(,[1-9][0-9]*(-([1-9][0-9]*)?)?|,-[1-9][0-9]*)*$" || { set -- regex_match:$? "$1" regex_match "${OPTARG}" "^([1-9][0-9]*(-([1-9][0-9]*)?)?|-[1-9][0-9]*)(,[1-9][0-9]*(-([1-9][0-9]*)?)?|,-[1-9][0-9]*)*$"; break; }
        normalize_range range_h27_haru "${OPTARG}"
        shift ;;
      '--h26-aki-range')
        [ $# -le 1 ] && set "required" "$1" && break
        OPTARG=$2
        regex_match "${OPTARG}" "^([1-9][0-9]*(-([1-9][0-9]*)?)?|-[1-9][0-9]*)(,[1-9][0-9]*(-([1-9][0-9]*)?)?|,-[1-9][0-9]*)*$" || { set -- regex_match:$? "$1" regex_match "${OPTARG}" "^([1-9][0-9]*(-([1-9][0-9]*)?)?|-[1-9][0-9]*)(,[1-9][0-9]*(-([1-9][0-9]*)?)?|,-[1-9][0-9]*)*$"; break; }
        normalize_range range_h26_aki "${OPTARG}"
        shift ;;
      '--h26-haru-range')
        [ $# -le 1 ] && set "required" "$1" && break
        OPTARG=$2
        regex_match "${OPTARG}" "^([1-9][0-9]*(-([1-9][0-9]*)?)?|-[1-9][0-9]*)(,[1-9][0-9]*(-([1-9][0-9]*)?)?|,-[1-9][0-9]*)*$" || { set -- regex_match:$? "$1" regex_match "${OPTARG}" "^([1-9][0-9]*(-([1-9][0-9]*)?)?|-[1-9][0-9]*)(,[1-9][0-9]*(-([1-9][0-9]*)?)?|,-[1-9][0-9]*)*$"; break; }
        normalize_range range_h26_haru "${OPTARG}"
        shift ;;
      '--h25-aki-range')
        [ $# -le 1 ] && set "required" "$1" && break
        OPTARG=$2
        regex_match "${OPTARG}" "^([1-9][0-9]*(-([1-9][0-9]*)?)?|-[1-9][0-9]*)(,[1-9][0-9]*(-([1-9][0-9]*)?)?|,-[1-9][0-9]*)*$" || { set -- regex_match:$? "$1" regex_match "${OPTARG}" "^([1-9][0-9]*(-([1-9][0-9]*)?)?|-[1-9][0-9]*)(,[1-9][0-9]*(-([1-9][0-9]*)?)?|,-[1-9][0-9]*)*$"; break; }
        normalize_range range_h25_aki "${OPTARG}"
        shift ;;
      '--h25-haru-range')
        [ $# -le 1 ] && set "required" "$1" && break
        OPTARG=$2
        regex_match "${OPTARG}" "^([1-9][0-9]*(-([1-9][0-9]*)?)?|-[1-9][0-9]*)(,[1-9][0-9]*(-([1-9][0-9]*)?)?|,-[1-9][0-9]*)*$" || { set -- regex_match:$? "$1" regex_match "${OPTARG}" "^([1-9][0-9]*(-([1-9][0-9]*)?)?|-[1-9][0-9]*)(,[1-9][0-9]*(-([1-9][0-9]*)?)?|,-[1-9][0-9]*)*$"; break; }
        normalize_range range_h25_haru "${OPTARG}"
        shift ;;
      '--h24-aki-range')
        [ $# -le 1 ] && set "required" "$1" && break
        OPTARG=$2
        regex_match "${OPTARG}" "^([1-9][0-9]*(-([1-9][0-9]*)?)?|-[1-9][0-9]*)(,[1-9][0-9]*(-([1-9][0-9]*)?)?|,-[1-9][0-9]*)*$" || { set -- regex_match:$? "$1" regex_match "${OPTARG}" "^([1-9][0-9]*(-([1-9][0-9]*)?)?|-[1-9][0-9]*)(,[1-9][0-9]*(-([1-9][0-9]*)?)?|,-[1-9][0-9]*)*$"; break; }
        normalize_range range_h24_aki "${OPTARG}"
        shift ;;
      '--h24-haru-range')
        [ $# -le 1 ] && set "required" "$1" && break
        OPTARG=$2
        regex_match "${OPTARG}" "^([1-9][0-9]*(-([1-9][0-9]*)?)?|-[1-9][0-9]*)(,[1-9][0-9]*(-([1-9][0-9]*)?)?|,-[1-9][0-9]*)*$" || { set -- regex_match:$? "$1" regex_match "${OPTARG}" "^([1-9][0-9]*(-([1-9][0-9]*)?)?|-[1-9][0-9]*)(,[1-9][0-9]*(-([1-9][0-9]*)?)?|,-[1-9][0-9]*)*$"; break; }
        normalize_range range_h24_haru "${OPTARG}"
        shift ;;
      '--h23-aki-range')
        [ $# -le 1 ] && set "required" "$1" && break
        OPTARG=$2
        regex_match "${OPTARG}" "^([1-9][0-9]*(-([1-9][0-9]*)?)?|-[1-9][0-9]*)(,[1-9][0-9]*(-([1-9][0-9]*)?)?|,-[1-9][0-9]*)*$" || { set -- regex_match:$? "$1" regex_match "${OPTARG}" "^([1-9][0-9]*(-([1-9][0-9]*)?)?|-[1-9][0-9]*)(,[1-9][0-9]*(-([1-9][0-9]*)?)?|,-[1-9][0-9]*)*$"; break; }
        normalize_range range_h23_aki "${OPTARG}"
        shift ;;
      '--h23-toku-range')
        [ $# -le 1 ] && set "required" "$1" && break
        OPTARG=$2
        regex_match "${OPTARG}" "^([1-9][0-9]*(-([1-9][0-9]*)?)?|-[1-9][0-9]*)(,[1-9][0-9]*(-([1-9][0-9]*)?)?|,-[1-9][0-9]*)*$" || { set -- regex_match:$? "$1" regex_match "${OPTARG}" "^([1-9][0-9]*(-([1-9][0-9]*)?)?|-[1-9][0-9]*)(,[1-9][0-9]*(-([1-9][0-9]*)?)?|,-[1-9][0-9]*)*$"; break; }
        normalize_range range_h23_toku "${OPTARG}"
        shift ;;
      '--h22-aki-range')
        [ $# -le 1 ] && set "required" "$1" && break
        OPTARG=$2
        regex_match "${OPTARG}" "^([1-9][0-9]*(-([1-9][0-9]*)?)?|-[1-9][0-9]*)(,[1-9][0-9]*(-([1-9][0-9]*)?)?|,-[1-9][0-9]*)*$" || { set -- regex_match:$? "$1" regex_match "${OPTARG}" "^([1-9][0-9]*(-([1-9][0-9]*)?)?|-[1-9][0-9]*)(,[1-9][0-9]*(-([1-9][0-9]*)?)?|,-[1-9][0-9]*)*$"; break; }
        normalize_range range_h22_aki "${OPTARG}"
        shift ;;
      '--h22-haru-range')
        [ $# -le 1 ] && set "required" "$1" && break
        OPTARG=$2
        regex_match "${OPTARG}" "^([1-9][0-9]*(-([1-9][0-9]*)?)?|-[1-9][0-9]*)(,[1-9][0-9]*(-([1-9][0-9]*)?)?|,-[1-9][0-9]*)*$" || { set -- regex_match:$? "$1" regex_match "${OPTARG}" "^([1-9][0-9]*(-([1-9][0-9]*)?)?|-[1-9][0-9]*)(,[1-9][0-9]*(-([1-9][0-9]*)?)?|,-[1-9][0-9]*)*$"; break; }
        normalize_range range_h22_haru "${OPTARG}"
        shift ;;
      '--h21-aki-range')
        [ $# -le 1 ] && set "required" "$1" && break
        OPTARG=$2
        regex_match "${OPTARG}" "^([1-9][0-9]*(-([1-9][0-9]*)?)?|-[1-9][0-9]*)(,[1-9][0-9]*(-([1-9][0-9]*)?)?|,-[1-9][0-9]*)*$" || { set -- regex_match:$? "$1" regex_match "${OPTARG}" "^([1-9][0-9]*(-([1-9][0-9]*)?)?|-[1-9][0-9]*)(,[1-9][0-9]*(-([1-9][0-9]*)?)?|,-[1-9][0-9]*)*$"; break; }
        normalize_range range_h21_aki "${OPTARG}"
        shift ;;
      '--h21-haru-range')
        [ $# -le 1 ] && set "required" "$1" && break
        OPTARG=$2
        regex_match "${OPTARG}" "^([1-9][0-9]*(-([1-9][0-9]*)?)?|-[1-9][0-9]*)(,[1-9][0-9]*(-([1-9][0-9]*)?)?|,-[1-9][0-9]*)*$" || { set -- regex_match:$? "$1" regex_match "${OPTARG}" "^([1-9][0-9]*(-([1-9][0-9]*)?)?|-[1-9][0-9]*)(,[1-9][0-9]*(-([1-9][0-9]*)?)?|,-[1-9][0-9]*)*$"; break; }
        normalize_range range_h21_haru "${OPTARG}"
        shift ;;
      '--image-dir'|'--no-image-dir')
        set -- "$1" "$@"
        [ ${OPTARG+x} ] && {
          case $1 in --no-*|--without-*) set "noarg" "${1%%\=*}"; break; esac
          [ "${OPTARG:-}" ] && { shift; OPTARG=$2; } || OPTARG='1'
        } || OPTARG=''
        imageDir="$OPTARG"
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
  past-exam-questions-to-csv.sh [OPTION]...

Options:
          --{no-}r5-haru[=FILENAME] 
                              令和5年度春期問題を出力する
          --{no-}r4-haru[=FILENAME] 
                              令和4年度春期問題を出力する
          --{no-}r3-haru[=FILENAME] 
                              令和3年度春期問題を出力する
          --{no-}r2-aki[=FILENAME] 
                              令和2年度秋期問題を出力する
          --{no-}r1-aki[=FILENAME] 
                              令和1年度秋期問題を出力する
          --{no-}h31-haru[=FILENAME] 
                              平成31年度春期問題を出力する
          --{no-}h30-aki[=FILENAME] 
                              平成30年度秋期問題を出力する
          --{no-}h30-haru[=FILENAME] 
                              平成30年度春期問題を出力する
          --{no-}h29-aki[=FILENAME] 
                              平成29年度秋期問題を出力する
          --{no-}h29-haru[=FILENAME] 
                              平成29年度春期問題を出力する
          --{no-}h28-aki[=FILENAME] 
                              平成28年度秋期問題を出力する
          --{no-}h28-haru[=FILENAME] 
                              平成28年度春期問題を出力する
          --{no-}h27-aki[=FILENAME] 
                              平成27年度秋期問題を出力する
          --{no-}h27-haru[=FILENAME] 
                              平成27年度春期問題を出力する
          --{no-}h26-aki[=FILENAME] 
                              平成26年度秋期問題を出力する
          --{no-}h26-haru[=FILENAME] 
                              平成26年度春期問題を出力する
          --{no-}h25-aki[=FILENAME] 
                              平成25年度秋期問題を出力する
          --{no-}h25-haru[=FILENAME] 
                              平成25年度春期問題を出力する
          --{no-}h24-aki[=FILENAME] 
                              平成24年度秋期問題を出力する
          --{no-}h24-haru[=FILENAME] 
                              平成24年度春期問題を出力する
          --{no-}h23-aki[=FILENAME] 
                              平成23年度秋期問題を出力する
          --{no-}h23-toku[=FILENAME] 
                              平成23年度特別問題を出力する
          --{no-}h22-aki[=FILENAME] 
                              平成22年度秋期問題を出力する
          --{no-}h22-haru[=FILENAME] 
                              平成22年度春期問題を出力する
          --{no-}h21-aki[=FILENAME] 
                              平成21年度秋期問題を出力する
          --{no-}h21-haru[=FILENAME] 
                              平成21年度春期問題を出力する
          --r5-haru-range NUMBER | NUMBER- | -NUMBER | NUMBER-NUMBER 
                              令和5年度春期問題の出題範囲を指定する
          --r4-haru-range NUMBER | NUMBER- | -NUMBER | NUMBER-NUMBER 
                              令和4年度春期問題の出題範囲を指定する
          --r3-haru-range NUMBER | NUMBER- | -NUMBER | NUMBER-NUMBER 
                              令和3年度春期問題の出題範囲を指定する
          --r2-aki-range NUMBER | NUMBER- | -NUMBER | NUMBER-NUMBER 
                              令和2年度秋期問題の出題範囲を指定する
          --r1-aki-range NUMBER | NUMBER- | -NUMBER | NUMBER-NUMBER 
                              令和1年度秋期問題の出題範囲を指定する
          --h31-haru-range NUMBER | NUMBER- | -NUMBER | NUMBER-NUMBER 
                              平成31年度春期問題の出題範囲を指定する
          --h30-aki-range NUMBER | NUMBER- | -NUMBER | NUMBER-NUMBER 
                              平成30年度秋期問題の出題範囲を指定する
          --h30-haru-range NUMBER | NUMBER- | -NUMBER | NUMBER-NUMBER 
                              平成30年度春期問題の出題範囲を指定する
          --h29-aki-range NUMBER | NUMBER- | -NUMBER | NUMBER-NUMBER 
                              平成29年度秋期問題の出題範囲を指定する
          --h29-haru-range NUMBER | NUMBER- | -NUMBER | NUMBER-NUMBER 
                              平成29年度春期問題の出題範囲を指定する
          --h28-aki-range NUMBER | NUMBER- | -NUMBER | NUMBER-NUMBER 
                              平成28年度秋期問題の出題範囲を指定する
          --h28-haru-range NUMBER | NUMBER- | -NUMBER | NUMBER-NUMBER 
                              平成28年度春期問題の出題範囲を指定する
          --h27-aki-range NUMBER | NUMBER- | -NUMBER | NUMBER-NUMBER 
                              平成27年度秋期問題の出題範囲を指定する
          --h27-haru-range NUMBER | NUMBER- | -NUMBER | NUMBER-NUMBER 
                              平成27年度春期問題の出題範囲を指定する
          --h26-aki-range NUMBER | NUMBER- | -NUMBER | NUMBER-NUMBER 
                              平成26年度秋期問題の出題範囲を指定する
          --h26-haru-range NUMBER | NUMBER- | -NUMBER | NUMBER-NUMBER 
                              平成26年度春期問題の出題範囲を指定する
          --h25-aki-range NUMBER | NUMBER- | -NUMBER | NUMBER-NUMBER 
                              平成25年度秋期問題の出題範囲を指定する
          --h25-haru-range NUMBER | NUMBER- | -NUMBER | NUMBER-NUMBER 
                              平成25年度春期問題の出題範囲を指定する
          --h24-aki-range NUMBER | NUMBER- | -NUMBER | NUMBER-NUMBER 
                              平成24年度秋期問題の出題範囲を指定する
          --h24-haru-range NUMBER | NUMBER- | -NUMBER | NUMBER-NUMBER 
                              平成24年度春期問題の出題範囲を指定する
          --h23-aki-range NUMBER | NUMBER- | -NUMBER | NUMBER-NUMBER 
                              平成23年度秋期問題の出題範囲を指定する
          --h23-toku-range NUMBER | NUMBER- | -NUMBER | NUMBER-NUMBER 
                              平成23年度特別問題の出題範囲を指定する
          --h22-aki-range NUMBER | NUMBER- | -NUMBER | NUMBER-NUMBER 
                              平成22年度秋期問題の出題範囲を指定する
          --h22-haru-range NUMBER | NUMBER- | -NUMBER | NUMBER-NUMBER 
                              平成22年度春期問題の出題範囲を指定する
          --h21-aki-range NUMBER | NUMBER- | -NUMBER | NUMBER-NUMBER 
                              平成21年度秋期問題の出題範囲を指定する
          --h21-haru-range NUMBER | NUMBER- | -NUMBER | NUMBER-NUMBER 
                              平成21年度春期問題の出題範囲を指定する
          --{no-}image-dir[=DIRECTORY] 
                              画像を保存するディレクトリを指定する
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
	set -- --r5-haru --r4-haru --r3-haru --r2-aki --r1-aki --h31-haru --h30-aki --h30-haru --h29-aki --h29-haru --h28-aki --h28-haru --h27-aki --h27-haru --h26-aki --h26-haru --h25-aki --h25-haru --h24-aki --h24-haru --h23-aki --h23-toku --h22-aki --h22-haru --h21-aki --h21-haru
esac

parse ${@+"${@}"}
eval "set -- ${REST}"

readonly "exams=$(
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
readonly "xpathes=$(
	cat <<-'__EOF__'
	//main//h2//text()
	//*[@id="mondai"]/node()
	//main//*[@class="ansbg"][1]/node()[self::* or self::text()]
	//*[@id="answerChar"]//text()
	//main//*[@class="ansbg"][2]/node()[self::* or self::text()]
	//main//h3[.="分類"]/following-sibling::p[1]//text()
	__EOF__
)"
readonly 'imgsrcXpath=(//*[@id="mondai"] | //main//*[@class="ansbg"][1] | //main//*[@class="ansbg"][2])//img[@src]/@src'
readonly "tmpDir=$(mktemp -d)"
readonly "download=${tmpDir}/download"
readonly "format=${tmpDir}/format"
readonly "awkRangePrint=$(
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

export "TMPDIR=${tmpDir}"

if command xmlstarlet --help >'/dev/null' 2>&1; then
	xml() {
		command xmlstarlet ${@+"${@}"}
	}
fi

printf '%s\n' "${exams}" | while IFS=' ' read -r name pattarn; do
	eval "output=\"\${output_${name}}\""

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

printf "%s\n" "${exams}" | while IFS=' ' read -r name pattarn; do
	eval "output=\"\${output_${name}}\""
	eval "range=\"\${range_${name}}\""

	case "${output}" in ?*)
		for n in $(awk -- "${awkRangePrint}" "${range}"); do
			url=$(printf "${pattarn}" "${n}")

			until wget --no-config --convert-links --output-document="${download}" -- "${url}"; do
				sleep "${wait}"
			done

			sed -e 's/charset="Shift_JIS"/charset="CP932"/' -- "${download}" | xmlstarlet --quiet format --encode 'UTF-8' --html - >"${format}"

			case "${imageDir}" in ?*)
				WAITTIME="${wait}" imgsrc_repalase "${imageDir}" "${imgsrcXpath}" "${format}"
			esac

			printf '"%s:%03d",' "${name}" "${n}"

			printf '%s\n' "${xpathes}" | while IFS='' read -r xpath; do
				csv_escape 'field' "$(xml select --template --copy-of "${xpath}" "${format}")"

				printf '"%s",' "${field}"
			done

			printf '"%s"\r\n' "${url}"

			sleep "${wait}"
		done | case "${output}" in
			'-') cat;;
			*) cat >"${output}";;
		esac
	esac
done
