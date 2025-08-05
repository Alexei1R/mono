#!/bin/bash
top -bn1 | grep "Cpu(s)" | \
awk '{print $2 + $4}' | \
awk '{printf "%.0f", $1}' || echo "0"
