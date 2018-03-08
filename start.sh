#!/bin/bash
UNAMESTR=`uname`
if [ $UNAMESTR == 'Darwin' ]; then
    ./scripts/start_osx.sh
else 
    ./scripts/start_linux.sh
fi