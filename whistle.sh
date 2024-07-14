#!/bin/bash

# Usage function

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored text
print_color() {
    printf "${1}${2}${NC}\n"
}
banner="

██╗    ██╗██╗  ██╗██╗███████╗████████╗██╗     ███████╗
██║    ██║██║  ██║██║██╔════╝╚══██╔══╝██║     ██╔════╝
██║ █╗ ██║███████║██║███████╗   ██║   ██║     █████╗  
██║███╗██║██╔══██║██║╚════██║   ██║   ██║     ██╔══╝  
╚███╔███╔╝██║  ██║██║███████║   ██║   ███████╗███████╗
 ╚══╝╚══╝ ╚═╝  ╚═╝╚═╝╚══════╝   ╚═╝   ╚══════╝╚══════╝

"
# Print the banner in color
print_color $RED "$banner"

# Print the tool name
print_color  " version 0.1 by intr0sp3ct"
usage() {
    echo "-----------------------------------------------------------------------------"
    echo "Usage: $0 -d <domain> -flags  -o <out_folder>"
    echo "example: ./recondog.sh -d target.com -a -s -o <output_folder> "
    echo "  -d <domain>    Target domain"
    echo "  -f             Run fast tools only (assetfinder, subfinder, sublister)"
    echo "  -a             Run all tools"
    echo "  -w <wordlist>  Custom wordlist"
    echo "  -s             Screenshot live domains with gowitness"
    echo "  -o <filename>  Save output to a file"
    echo "-----------------------------------------------------------------------------"

    exit 1
}


# Parse command line arguments
while getopts ":d:faw:so:" opt; do
    case ${opt} in
        d ) domain=$OPTARG ;;
        f ) fast_mode=true ;;
        a ) all_tools=true ;;
        w ) wordlist=$OPTARG ;;
        s ) screenshot=true ;;
        o ) output_file=$OPTARG ;;
        \? ) usage ;;
    esac
done

# Check if domain is provided
if [ -z "$domain" ]; then
    usage
fi

# Create output directory
output_dir="${domain}_recon"
mkdir -p "$output_dir"

# Function to run tools and process output
run_tool() {
    tool=$1
    output_file="$output_dir/${tool}_output.txt"
    
    echo "Running $tool..."
    case $tool in
        assetfinder)
            assetfinder --subs-only "$domain" > "$output_file"
            ;;
        amass)
            if [ "$fast_mode" = true ]; then
                amass enum -passive -d "$domain" > "$output_file"
            else
                amass enum -active -d "$domain" -w "$wordlist" > "$output_file"
            fi
            ;;
        subfinder)
            if [ -n "$wordlist" ]; then
                subfinder -d "$domain" -w "$wordlist" -o "$output_file"
            else
                subfinder -d "$domain" -o "$output_file"
            fi
            ;;
        sublist3r)
            sublist3r -d "$domain" -o "$output_file"
            ;;
    esac
}

# Run selected tools concurrently
run_tools_concurrently() {
    for tool in "$@"; do
        run_tool "$tool" &
    done
    wait
}

# Determine which tools to run
if [ "$fast_mode" = true ]; then
    tools_to_run="assetfinder subfinder sublist3r"
elif [ "$all_tools" = true ]; then
    tools_to_run="assetfinder amass subfinder sublist3r"
else
    tools_to_run="assetfinder subfinder"
fi

# Run tools
run_tools_concurrently $tools_to_run

# Combine and clean results
combined_output="$output_dir/combined_subdomains.txt"
cat "$output_dir"/*_output.txt | sort -u > "$combined_output"

# Run httprobe
echo "Running httprobe..."
httprobe_output="$output_dir/live_subdomains.txt"
cat "$combined_output" | httprobe  > "$httprobe_output"

# Run gowitness if screenshot option is enabled
if [ "$screenshot" = true ]; then
    echo "Running gowitness..."
    gowitness_output="$output_dir/screenshots/"
    mkdir -p "$gowitness_output"
    gowitness file -f "$httprobe_output" -P "$gowitness_output" --no-http
fi

# Save output to file if specified
if [ -n "$output_file" ]; then
    cp "$combined_output" "$output_file"
    echo "Output saved to $output_file"
fi


echo "Recon complete. Results are stored in the $output_dir directory."
encryption relies on 2 keys, a public and private
- user requests an ssh session with a public key of the server
- server responds with a user's public key that can only be decrypted by a user's private key
- user submits it , server checks if it scorrect