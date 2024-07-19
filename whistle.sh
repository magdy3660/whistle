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

#!/bin/bash

# Usage function
usage() {
    echo "Usage: $0 -d <domain>  [-w <wordlist>]"
    echo "  -d <domain>    Target domain"
    echo "  -w <wordlist>  Custom wordlist for subdomain enumeration"
    exit 1
}

# Parse command line arguments
while getopts ":d:faw:" opt; do
    case ${opt} in
        d ) domain=$OPTARG ;;
        w ) wordlist=$OPTARG ;;
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
          
                amass enum -d "$domain" > "$output_file"  

            ;;
        subfinder)
            if [ -n "$wordlist" ]; then
                subfinder -d "$domain" -w "$wordlist" -o "$output_file"
            else
                subfinder -d "$domain" -o "$output_file"
            fi
            ;;
    esac
}

# Run selected tools

    run_tool assetfinder
    run_tool subfinder
    echo" AMASS CAN BE SLOW HANG ON"
    run_tool amass


# Combine and clean results
combined_output="$output_dir/combined_subdomains.txt"
cat "$output_dir"/*_output.txt | sort -u > "$combined_output"

# Run httprobe
echo "Running httprobe..."
httprobe_output="$output_dir/live_subdomains.txt"
cat "$combined_output" | httprobe > "$httprobe_output"

# Run gowitness
echo "Running goWitness..."
gowitness_output="$output_dir/screenshots"
gowitness file -f "$httprobe_output" -P "$gowitness_output" 

echo "Recon complete. Results are stored in the $output_dir directory."