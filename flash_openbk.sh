#!/bin/bash
set -euo pipefail

SCRIPT_ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd -P )"

if [ ! -e "$SCRIPT_ROOT/download/OpenBK7231N_QIO_1.17.308.bin" ]; then
    mkdir -p "$SCRIPT_ROOT/download"
    wget -P "$SCRIPT_ROOT" https://github.com/openshwprojects/OpenBK7231T_App/releases/download/1.17.308/OpenBK7231N_QIO_1.17.308.bin
fi

cd "$SCRIPT_ROOT"
[ ! -e "$SCRIPT_ROOT/.venv" ] && uv venv --prompt venv

if [ ! -e "$SCRIPT_ROOT/hid_download_py" ]; then
    git clone https://github.com/OpenBekenIOT/hid_download_py "$SCRIPT_ROOT/hid_download_py"
fi
uv pip install -U -r hid_download_py/requirements.txt

exec "$SCRIPT_ROOT/venv/bin/python3" "$SCRIPT_ROOT/hid_download_py/uartprogram" "$SCRIPT_ROOT/download/OpenBK7231N_QIO_1.17.308.bin" -d /dev/cu.usb* -w -u -s 0x0
