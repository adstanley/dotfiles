#!/usr/bin/env bash

# Read the contents of .bashrc into an array
mapfile -t bashrc_contents < "$HOME"/.bashrc

# Initialize variables
in_function=false
current_doc=""
current_function=""
declare -a functions_to_print=()
declare -A function_docs=()

# First pass: collect all function info
while IFS= read -r line; do
    if [[ "$line" == *"#@begin_function"* ]]; then
        in_function=true
        current_doc=""
        continue
    fi
    
    if [[ "$in_function" == true ]]; then
        if [[ "$line" == "function"* ]]; then
            # Extract function name
            current_function=$(echo "$line" | sed -n 's/function \([^(]*\).*/\1/p')
            functions_to_print+=("$current_function")
        elif [[ "$line" == *"#@end_function"* ]]; then
            in_function=false
            function_docs["$current_function"]=$current_doc
        elif [[ "$line" == "#"* ]]; then
            # Collect documentation lines
            current_doc+="${line#"# "}"$'\n'
        fi
    fi
done <<< "$(printf '%s\n' "${bashrc_contents[@]}")"


# Print all functions
for func in "${functions_to_print[@]}"; do
    # Print documentation
    echo "${function_docs[$func]}"
    
    # Print function definition
    declare -f "$func"
    echo "" # Add blank line between functions
done