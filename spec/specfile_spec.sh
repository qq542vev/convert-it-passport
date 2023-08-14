#!/usr/bin/env sh

### File: specfile_spec.sh
##
## Spec File を検証する。
##
## Usage:
##
## ------ Text ------
## shellspec specfile_spec.sh
## ------------------
##
## Metadata:
##
##   id - d46f79bf-85e0-419f-912d-78c71b2f5075
##   author - <qq542vev at https://purl.org/meta/me/>
##   version - 1.0.1
##   date - 2023-08-15
##   since - 2023-07-25
##   copyright - Copyright (C) 2023-2023 qq542vev. Some rights reserved.
##   license - <CC-BY at https://creativecommons.org/licenses/by/4.0/>
##   package - convert-it-passport
##
## See Also:
##
##   * <Project homepage at https://github.com/qq542vev/convert-it-passport>
##   * <Bag report at https://github.com/qq542vev/convert-it-passport/issues>

eval "$(shellspec - -c) exit 1"

Describe 'Spec File の検証'
	Example 'shellspec --syntax-check'
		When call shellspec --syntax-check
		The stdout should not equal ''
		The stderr should equal ''
		The status should equal 0
	End
End
