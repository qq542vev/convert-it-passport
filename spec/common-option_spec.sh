#!/usr/bin/env sh

### File: common-option_spec.sh
##
## Shell ファイルの共通オプションの検証。
##
## Usage:
##
## ------ Text ------
## shellspec common-option_spec.sh
## ------------------
##
## Metadata:
##
##   id - 764ca0db-bda8-499f-a94c-fcba6d0b6506
##   author - <qq542vev at https://purl.org/meta/me/>
##   version - 1.0.0
##   date - 2023-07-25
##   since - 2023-07-14
##   copyright - Copyright (C) 2023-2023 qq542vev. Some rights reserved.
##   license - <CC-BY at https://creativecommons.org/licenses/by/4.0/>
##   package - convert-it-passport
##
## See Also:
##
##   * <Project homepage at https://github.com/qq542vev/convert-it-passport>
##   * <Bag report at https://github.com/qq542vev/convert-it-passport/issues>

eval "$(shellspec - -c) exit 1"

% TESTFILES: 'bin/past-exam-question-to-csv.sh bin/word-quiz-to-csv.sh'

version_check() {
	awk -- '
		BEGIN {
			count = split(ARGV[1], array, " ")

			exit !(count == 2 && array[1] == ARGV[2] && array[2] ~ /(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)/)
		}
	' "${version_check}" "${1}"
}

Describe 'ShellCheck による検証'
	Parameters:value ${TESTFILES}

	Example "shellcheck --severity=error -- ${1}"
		When call shellcheck --severity=error "${1}"
		The length of stdout should equal 0
		The length of stderr should equal 0
		The status should equal 0
	End
End

Describe '-h, --help の検証'
	Parameters:matrix
		${TESTFILES}
		-h --help
	End

	Example "${1} ${2}"
		When run script "${1}" "${2}"
		The length of stdout should not equal 0
		The length of stderr should equal 0
		The status should equal 0
	End
End

Describe '-v, --version の検証'
	Parameters:matrix
		${TESTFILES}
		-v --version
	End

	Example "${1} ${2}"
		When run script "${1}" "${2}"
		The stdout should satisfy version_check "${1##*/}"
		The length of stderr should equal 0
		The status should equal 0
	End
End

Describe '-w, --wait の検証'
	Parameters:dynamic
	  for file in ${TESTFILES}; do
		  for option in -w --wait; do
				%data "${file}" "${option}" ''    "${EX_USAGE}"
				%data "${file}" "${option}" 'a'   "${EX_USAGE}"
				%data "${file}" "${option}" '-1'  "${EX_USAGE}"
				%data "${file}" "${option}" '0'   "${EX_OK}"
				%data "${file}" "${option}" '00'  "${EX_USAGE}"
				%data "${file}" "${option}" '.0'  "${EX_USAGE}"
				%data "${file}" "${option}" '1'   "${EX_OK}"
				%data "${file}" "${option}" '01'  "${EX_USAGE}"
				%data "${file}" "${option}" '1.0' "${EX_USAGE}"
				%data "${file}" "${option}" '10'  "${EX_OK}"
				%data "${file}" "${option}" '100' "${EX_OK}"
		  done
	  done
	End

	Example "${1} ${2} ${3}"
		When run script "${1}" "${2}" "${3}"
		The length of stdout should equal 0
		The status should equal "${4}"

		case "${4}" in
			"${EX_OK}")
				The length of stderr should equal 0;;
			*)
				The length of stderr should not equal 0;;
		esac
	End
End
