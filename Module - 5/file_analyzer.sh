#!/bin/bash

ERROR_LOG="errors_log.txt"   

show_help() {
cat << EOF
Usage: $0 [OPTIONS]

Options:
  -d <directory>    Directory to search recursively
  -k <keyword>      Keyword to search for
  -f <file>         File to search directly
  --help            Display this help menu

Examples:
  $0 -d logs -k error
  $0 -f script.sh -k TODO
  $0 --help
EOF
}

error() {
    echo "ERROR: $1" >&2
    echo "ERROR: $1" >> "$ERROR_LOG"
}

valid_keyword() {
    [[ "$1" =~ [^[:space:]] ]]
}

search_recursive() {
    local dir="$1"
    local keyword="$2"

    for item in "$dir"/*; do
        [[ ! -e "$item" ]] && continue

        if [[ -d "$item" ]]; then
            search_recursive "$item" "$keyword"
        elif [[ -f "$item" ]]; then
            if grep -q "$keyword" "$item" 2>>"$ERROR_LOG"; then
                echo "Found in: $item"
            fi
        fi
    done
}

while getopts ":d:k:f:-:" opt; do
    case "$opt" in
        d) DIRECTORY="$OPTARG" ;;
        k) KEYWORD="$OPTARG" ;;
        f) FILE="$OPTARG" ;;
        -)
            [[ "$OPTARG" == "help" ]] && show_help && exit 0
            ;;
        *)
            error "Invalid option"
            show_help
            exit 1
            ;;
    esac
done

if [[ $# -eq 0 ]]; then
    error "No arguments provided"
    show_help
    exit 1
fi

if ! valid_keyword "$KEYWORD"; then
    error "Invalid or empty keyword"
    exit 1
fi


if [[ -n "$DIRECTORY" ]]; then
    if [[ ! -d "$DIRECTORY" ]]; then
        error "Directory does not exist: $DIRECTORY"
        exit 1
    fi
    search_recursive "$DIRECTORY" "$KEYWORD"
fi

if [[ -n "$FILE" ]]; then
    if [[ ! -f "$FILE" ]]; then
        error "File does not exist: $FILE"
        exit 1
    fi

    if grep -q "$KEYWORD" <<< "$(cat "$FILE")"; then
        echo "Keyword found in file: $FILE"
    else
        echo "Keyword not found in file: $FILE"
    fi
fi

echo "Script Name : $0"
echo "Arguments Count : $#"
echo "Arguments Provided : $@"
echo "Last Exit Status : $?"

