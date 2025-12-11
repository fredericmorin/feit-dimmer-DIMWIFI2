#!/bin/bash
set -euo pipefail

SCRIPT_ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd -P )"

cd "$SCRIPT_ROOT"
[ ! -e "$SCRIPT_ROOT/.venv" ] && uv venv --prompt venv
[ ! -e "$SCRIPT_ROOT/.venv/bin/esphome" ] && uv pip install esphome

exec uv run esphome "$@"
