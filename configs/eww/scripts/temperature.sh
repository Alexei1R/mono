#!/bin/bash
sensors 2>/dev/null | \
grep -E 'Core 0|Tctl|Package' | \
head -1 | \
awk '{print $3}' | \
sed 's/+//;s/°C.*//' || echo "0"
