#!/usr/bin/env bash

UNAME=$(uname -s)

if [[ "$UNAME" == *Linux* ]]; then
    echo 'Linux'
elif [[ "$UNAME" == Darwin ]]; then
    echo 'Darwin'
else
    echo 'unknown'
fi
