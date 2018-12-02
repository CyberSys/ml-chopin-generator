#!/bin/bash

set -eu
set -o pipefail

output_file_name=$1
touch "$output_file_name"
temp_file=$(mktemp  -t tmp.XXXXXXXXXX)
function finish {
    rm -rf "$temp_file"
}
trap finish EXIT


last_time_value=0
for file in mazrka*.csv; do

    before=$(tail -n 1 "$file"  |  cut -d ',' -f2)
    awk   -F',' 'BEGIN { OFS = FS } { $2 = $2 +  "'"$last_time_value"'"; print }' "$file" > "$temp_file"
    after=$(tail -n 1 "$temp_file"  |  cut -d ',' -f2)
    last_time_value=$(tail -n 1 "$temp_file"  |  cut -d ',' -f2)
    echo -r "$file\t$last_time_value\t$before\t$after"
    cat "$temp_file" >> "$output_file_name"
done


if $(cut -d "," -f2 "$output_file_name" | sort -cn); then
    echo "Sorted properly"
    cut -d ',' -f2,3,5,6 "$output_file_name" | sponge  "$output_file_name"
else
    echo "Sorted improperly"
    exit 1
fi

sed -i -e 's/Program_c/D/g' "$output_file_name"
sed -i -e 's/Note_on_c/C/g' "$output_file_name"
sed -i -e 's/Note_off_c/F/g' "$output_file_name"
sed -i -e 's/Control_c/E/g' "$output_file_name"
