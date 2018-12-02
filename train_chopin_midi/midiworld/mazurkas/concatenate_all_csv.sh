#!/bin/bash

set -eu
set -o pipefail

output_file_name=$1

last_time_value=0
for file in *.csv; do
    awk   -F',' 'BEGIN { OFS = FS } { $2 = $2 +  "'"$last_time_value"'"; print }' "$file" >> "$output_file_name"
    last_time_value=$(tail -n 1 "$file"  |  cut -d ',' -f2)
done
