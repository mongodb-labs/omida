#!/usr/bin/env bash

# Parameter check
if [[ "$#" -lt 3 ]]; then
    echo "Invalid call: 'replace_prop.sh $*'"
    echo "Usage: replace_prop.sh FILENAME PROPERTY VALUE"
    echo
    exit 1
fi

# Set the new property
temp_file="$(mktemp)"
grep -vE "^\\s*${2}\\s*=" "${1}" > "${temp_file}" # Export contents minus any lines containing the specified property
echo "${2}=${3}" >> "${temp_file}"                # Set the new property value
cat "${temp_file}" > "${1}"                       # Replace the contents of the original file, while preserving any permissions
rm "${temp_file}"
echo "Updated property in ${1}: ${2}=${3}"
