#!/bin/bash

# Function to print usage/help
print_help() {
    echo "Usage: $0 [options] search_string filename"
    echo "Options:"
    echo "  -n    Show line numbers"
    echo "  -v    Invert match (show non-matching lines)"
    echo "  --help  Show this help message"
    exit 0
}

# Check if no arguments
if [ $# -eq 0 ]; then
    echo "Error: No arguments provided."
    print_help
    exit 1
fi

# Initialize option flags
show_line_numbers=false
invert_match=false

# Option parsing
while [[ "$1" == -* ]]; do
    case "$1" in
        -n) show_line_numbers=true ;;
        -v) invert_match=true ;;
        --help) print_help ;;
        -*) 
            echo "Error: Unknown option: $1"
            print_help
            exit 1
            ;;
    esac
    shift
done

# After options, $1 should be the search string
search_string="$1"
shift

# Then $1 should be the filename
filename="$1"

# Validate search string and filename
if [ -z "$search_string" ]; then
    echo "Error: Missing search string."
    print_help
    exit 1
fi

if [ -z "$filename" ]; then
    echo "Error: Missing filename."
    print_help
    exit 1
fi

if [ ! -f "$filename" ]; then
    echo "Error: File '$filename' does not exist."
    exit 1
fi

# Actual search logic
line_number=0
while IFS= read -r line; do
    line_number=$((line_number + 1))
    
    # Case insensitive matching
    if echo "$line" | grep -i -q -- "$search_string"; then
        match=true
    else
        match=false
    fi

    # Invert match if needed
    if [ "$invert_match" = true ]; then
        match=$([ "$match" = false ] && echo true || echo false)
    fi

    if [ "$match" = true ]; then
        if [ "$show_line_numbers" = true ]; then
            echo "${line_number}:$line"
        else
            echo "$line"
        fi
    fi

done < "$filename"

