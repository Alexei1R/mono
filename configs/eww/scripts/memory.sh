#!/bin/bash
free | grep Mem | \
awk '{printf "%.0f", $3/$2 * 100.0}' || echo "0"
