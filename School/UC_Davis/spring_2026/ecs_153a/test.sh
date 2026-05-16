#!/bin/bash

REF=/home/bishop/access
MY=./access
REF_OUT=ref_output.txt
MY_OUT=my_output.txt

run_test() {
    local desc="$1"
    shift
    echo "=== $desc ===" >> "$REF_OUT"
    "$REF" "$@" >> "$REF_OUT" 2>&1
    echo "=== $desc ===" >> "$MY_OUT"
    "$MY" "$@" >> "$MY_OUT" 2>&1
}

# clear output files
> "$REF_OUT"
> "$MY_OUT"

# basic user tests
run_test "valid user, existing file" $USER /home/bishop/access
run_test "no arguments"
run_test "nonexistent file" $USER fakefile.txt
run_test "nonexistent user" bishopric /home/bishop/access
run_test "numeric UID" 40 /home/bishop/access
run_test "root UID" 0 /home/bishop/access

# group tests
run_test "group flag with name" -g $USER /home/bishop/access
run_test "nonexistent group" -g unknowngroup /home/bishop/access
run_test "numeric GID" -g 40 /home/bishop/access
run_test "numeric GID with name" -g 0 /home/bishop/access

# directory tests
run_test "valid user, directory" $USER /home
run_test "group flag, directory" -g $USER /home
run_test "no access directory" $USER /root

# multiple files
run_test "multiple files" $USER /home/bishop/access /home

echo "Reference output saved to $REF_OUT"
echo "Your output saved to $MY_OUT"
echo ""
echo "=== DIFF (empty means perfect match) ==="
diff "$REF_OUT" "$MY_OUT"