### File: spec_helper.sh
##
## ShellSpec 用の共通ヘルパーファイル。
##
## Metadata:
##
##   id - 375430d1-9d1c-4cab-b338-2ec80299b252
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

set -efu


. 'lib/sysexits.sh'

md5checksum() {
	[ "$(printf '%s\n' "${md5checksum}" | md5sum | cut -d ' ' -f 1)" = "$(cut -d ' ' -f 1 -- "spec/checksum/${1}.md5sum")" ]
}
