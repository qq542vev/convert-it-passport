#!/usr/bin/env sh

### File: past-exam-question-to-csv_spec.sh
##
## past-exam-question-to-csv.sh の検証。
##
## Usage:
##
## ------ Text ------
## shellspec past-exam-question-to-csv_spec.sh
## ------------------
##
## Metadata:
##
##   id - a107676b-76c5-4e47-a56c-7bc468efee1f
##   author - <qq542vev at https://purl.org/meta/me/>
##   version - 1.0.0
##   date - 2023-07-25
##   since - 2023-07-12
##   copyright - Copyright (C) 2023-2023 qq542vev. Some rights reserved.
##   license - <CC-BY at https://creativecommons.org/licenses/by/4.0/>
##   package - convert-it-passport
##
## See Also:
##
##   * <Project homepage at https://github.com/qq542vev/convert-it-passport>
##   * <Bag report at https://github.com/qq542vev/convert-it-passport/issues>

eval "$(shellspec - -c) exit 1"

% TESTFILE: 'bin/past-exam-question-to-csv.sh'

Describe '書き込み不可へのアウトプットの検証'
	Parameters:dynamic
		for option in --r05-haru --r04-haru --r03-haru --r02-aki --r01-aki --h31-haru --h30-aki --h30-haru --h29-aki --h29-haru --h28-aki --h28-haru --h27-aki --h27-haru --h26-aki --h26-haru --h25-aki --h25-haru --h24-aki --h24-haru --h23-aki --h23-toku --h22-aki --h22-haru --h21-aki --h21-haru; do
			%data "${option}" ''                     "${EX_USAGE}"
			%data "${option}" 'spec'                 "${EX_USAGE}"
			%data "${option}" 'spec/unwritable-file' "${EX_CANTCREAT}"
			%data "${option}" 'spec/unwritable-directory/file' "${EX_CANTCREAT}"
			%data "${option}" 'spec/unexecutable-directory/file' "${EX_CANTCREAT}"
			%data "${option}" 'non-existent/'        "${EX_USAGE}"
		done
	End

	Example "${TESTFILE} ${1}=${2}"
		When run script "${TESTFILE}" "${1}=${2}"
		The stdout should equal ''
		The stderr should not equal ''
		The status should equal "${3}"
	End
End

Describe 'range の検証'
	Parameters:dynamic
		for option in --r05-haru --r04-haru --r03-haru --r02-aki --r01-aki --h31-haru --h30-aki --h30-haru --h29-aki --h29-haru --h28-aki --h28-haru --h27-aki --h27-haru --h26-aki --h26-haru --h25-aki --h25-haru --h24-aki --h24-haru --h23-aki --h23-toku --h22-aki --h22-haru --h21-aki --h21-haru; do
			%data "${option}" 'a'      "${EX_USAGE}"
			%data "${option}" '0'      "${EX_USAGE}"
			%data "${option}" '0.0'    "${EX_USAGE}"
			%data "${option}" '1'      "${EX_OK}"
			%data "${option}" '10'     "${EX_OK}"
			%data "${option}" '100'    "${EX_OK}"
			%data "${option}" '1000'   "${EX_OK}"
			%data "${option}" '1'      "${EX_OK}"
			%data "${option}" '1000'   "${EX_OK}"
			%data "${option}" '1-9'    "${EX_OK}"
			%data "${option}" '1-9,2,13' "${EX_OK}"
			%data "${option}" '5 7'    "${EX_USAGE}"
		done
	End

	Example "${TESTFILE} ${1}-range=${2}"
		When run script "${TESTFILE}" "${1}-range=${2}"
		The stdout should equal ''
		The status should equal "${3}"

		case "${3}" in
			"${EX_OK}")
				The stderr should equal '';;
			*)
				The stderr should not equal '';;
		esac
	End
End

Describe 'image-dir の検証'
	Parameters:block
		'' "${EX_OK}"
		'spec' "${EX_OK}"
		'spec/unwritable-directory' "${EX_CANTCREAT}"
	End

	Example "${TESTFILE} --image-dir ${1}"
		When run script "${TESTFILE}" '--image-dir' "${1}"
		The stdout should equal ''
		The status should equal "${2}"

		case "${2}" in
			"${EX_OK}")
				The stderr should equal '';;
			*)
				The stderr should not equal '';;
		esac
	End
End

xDescribe 'アウトプット内容の検証'
	Parameters:block
		'--r05-haru=-' 'r05-haru.csv'
		'--r04-haru=-' 'r04-haru.csv'
		'--r03-haru=-' 'r03-haru.csv'
		'--r02-aki=-'  'r02-aki.csv'
		'--r01-aki=-'  'r01-aki.csv'
		'--h31-haru=-' 'h31-haru.csv'
		'--h30-aki=-'  'h30-aki.csv'
		'--h30-haru=-' 'h30-haru.csv'
		'--h29-aki=-'  'h29-aki.csv'
		'--h29-haru=-' 'h29-haru.csv'
		'--h28-aki=-'  'h28-aki.csv'
		'--h28-haru=-' 'h28-haru.csv'
		'--h27-aki=-'  'h27-aki.csv'
		'--h27-haru=-' 'h27-haru.csv'
		'--h26-aki=-'  'h26-aki.csv'
		'--h26-haru=-' 'h26-haru.csv'
		'--h25-aki=-'  'h25-aki.csv'
		'--h25-haru=-' 'h25-haru.csv'
		'--h24-aki=-'  'h24-aki.csv'
		'--h24-haru=-' 'h24-haru.csv'
		'--h23-aki=-'  'h23-aki.csv'
		'--h23-toku=-' 'h23-toku.csv'
		'--h22-aki=-'  'h22-aki.csv'
		'--h22-haru=-' 'h22-haru.csv'
		'--h21-aki=-'  'h21-aki.csv'
		'--h21-haru=-' 'h21-haru.csv'
	End

	Example "${TESTFILE} ${1}"
		When run script "${TESTFILE}" "${1}"
		The stdout should satisfy md5checksum "${2}"
		The stderr should not equal ''
		The status should equal 0
	End
End
