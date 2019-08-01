#!/bin/bash
UNAMESTR=`uname`

if [ -f "/mnt/c/WINDOWS/explorer.exe" ]; then
    chmod +x ./scripts/start_wsl.sh
    ./scripts/start_wsl.sh
elif [ $UNAMESTR == 'Darwin' ]; then
    chmod +x ./scripts/start_osx.sh
    ./scripts/start_osx.sh
else 
    chmod +x ./scripts/start_linux.sh
    ./scripts/start_linux.sh
fi