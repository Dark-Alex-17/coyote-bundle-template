#!/usr/bin/env bash
set -e

# @describe Greet a person by name. Example bash tool shipped with coyote-config-template.
# @option --name!  Name of the person to greet.

# @env LLM_OUTPUT=/dev/stdout The output path

# shellcheck disable=SC2154
main() {
    printf 'Hello, %s!\n' "${argc_name}" >> "$LLM_OUTPUT"
}
