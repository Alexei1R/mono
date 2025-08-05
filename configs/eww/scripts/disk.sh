#!/bin/bash
df -h / | awk 'NR==2{print $5}' | \
sed 's/%//' || echo "0"
