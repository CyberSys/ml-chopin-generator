#!/bin/bash

set -eu
set -o pipefail

input_file=$1
out_file=$2

sed -i -e 's/D/Program_c/g' "$input_file"
sed -i -e 's/C/Note_on_c/g' "$input_file"
sed -i -e 's/F/Note_off_c/g' "$input_file"
sed -i -e 's/E/Control_c/g' "$input_file"

echo "
0, 0, Header, 1, 7, 240
1, 0, Start_track
1, 0, Time_signature, 4, 2, 24, 8
1, 0, Tempo, 500000
1, 0, Marker_t, "ML MUsic"
1, 0, End_track
2, 0, Start_track
2, 0, Title_t, "Ml Music"
2, 0, Program_c, 0, 0" > "$out_file"

awk '{print "2,",$1,$2,"0,",$3,$4}' "$input_file" >> "$out_file"
last_value=$(tail -n 1 "$out_file"  |  cut -d ',' -f2)

echo "
2, $((last_value +1)), End_track
3, 0, Start_track
3, 0, Title_t, "Played by Dr. ML"
3, 0, End_track
4, 0, Start_track
4, 0, Title_t, "FUTURE"
4, 0, End_track
5, 0, Start_track
5, 0, Title_t, "ML"
5, 0, End_track
6, 0, Start_track
6, 0, Title_t, "Copyright 2018"
6, 0, End_track
7, 0, Start_track
7, 0, Title_t, "All Rights Reserved"
7, 0, End_track
0, 0, End_of_file" >> "$out_file"
