#!/bin/bash
set -euo pipefail

SCRIPT_ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd -P )"

cd "$SCRIPT_ROOT"
uvx esphome compile generic.yaml

BUILD_ROOT="$SCRIPT_ROOT/.esphome/build/feit-dimwifi2/.pioenvs/feit-dimwifi2/"
cp "$BUILD_ROOT/firmware.bin" "$SCRIPT_ROOT/generic-firmware.bin"
cat "$SCRIPT_ROOT/generic-firmware.bin" | gzip > "$SCRIPT_ROOT/generic-firmware.bin.gz"
