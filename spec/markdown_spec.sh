#!/usr/bin/env sh

### File: markdown_spec.sh
##
## Shell ファイルの共通オプションの検証。
##
## Usage:
##
## ------ Text ------
## shellspec markdown_spec.sh
## ------------------
##
## Metadata:
##
##   id - f41a651c-f50b-4775-9d77-09e60508bdb4
##   author - <qq542vev at https://purl.org/meta/me/>
##   version - 1.0.0
##   date - 2023-07-26
##   since - 2023-07-26
##   copyright - Copyright (C) 2023-2023 qq542vev. Some rights reserved.
##   license - <CC-BY at https://creativecommons.org/licenses/by/4.0/>
##   package - convert-it-passport
##
## See Also:
##
##   * <Project homepage at https://github.com/qq542vev/convert-it-passport>
##   * <Bag report at https://github.com/qq542vev/convert-it-passport/issues>

eval "$(shellspec - -c) exit 1"

% TESTFILES: 'readme.md'

Describe 'markdownlint による検証'
	Parameters:value ${TESTFILES}

	Example "markdownlint -- ${1}"
		When call markdownlint -- "${1}"
		The length of stdout should equal 0
		The length of stderr should equal 0
		The status should equal 0
	End
End
