#shellcheck shell=sh

# set -eu

# shellspec_spec_helper_configure() {
#   shellspec_import 'support/custom_matcher'
# }

md5checksum() {
	[ "$(printf '%s\n' "${md5checksum}" | md5sum | cut -d ' ' -f 1)" = "$(cut -d ' ' -f 1 -- "spec/checksum/${1}.md5sum")" ]
}
