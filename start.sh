#!/bin/bash
UNAMESTR=`uname`

if [ -f "/mnt/c/WINDOWS/explorer.exe" ]; then
    ./scripts/start_wsl.sh
elif [ $UNAMESTR == 'Darwin' ]; then
    ./scripts/start_osx.sh
else 
    ./scripts/start_linux.sh
fi