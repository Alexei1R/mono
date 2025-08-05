#!/bin/bash

case "$1" in
    "temp")
        curl -s 'wttr.in/?format=%t' 2>/dev/null | \
        sed 's/°C//g;s/+//g' || echo "20"
        ;;
    "desc")
        curl -s 'wttr.in/?format=%C' 2>/dev/null || echo "Clear"
        ;;
    "icon")
        curl -s 'wttr.in/?format=%c' 2>/dev/null || echo "☀"
        ;;
    *)
        echo "Usage: $0 {temp|desc|icon}"
        exit 1
        ;;
esac
