FILE="$1"

jq -s '[.[].artifacts[].size_in_bytes] | add' $FILE | hb
