#!/usr/bin/env sh

### File: word-quiz-to-csv_spec.sh
##
## word-quiz-to-csv.sh の検証。
##
## Usage:
##
## ------ Text ------
## shellspec word-quiz-to-csv_spec.sh
## ------------------
##
## Metadata:
##
##   id - 2ecc3ff1-e241-41a5-ba2f-941e334c0462
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

% TESTFILE: 'bin/word-quiz-to-csv.sh'

Describe '書き込み不可へのアウトプットの検証'
	Parameters:dynamic
		for option in --strategy --management --technology; do
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
		The length of stdout should equal 0
		The length of stderr should not equal 0
		The status should equal "${3}"
	End
End

xDescribe 'アウトプット内容の検証'
	Parameters:block
		'-s-'            'strategy.csv'
		'--strategy=-'   'strategy.csv'
		'-m-'            'management.csv'
		'--management=-' 'management.csv'
		'-t-'            'technology.csv'
		'--technology=-' 'technology.csv'
	End

	Example "${TESTFILE} ${1}"
		When run script "${TESTFILE}" "${1}"
		The stdout should satisfy md5checksum "${2}"
		The length of stderr should not equal 0
		The status should equal 0
	End
End
