#!/bin/bash

# Finder extracts and counts error messages within your systems from your var files located within /var/log/syslog. 
# You'll be able to search keywords, date ranges, and log levels (e.g ERROR, WARNING, Ect.)
# Finally if you need to save files you can specify the -o [output_dir] to save output to directories for further analysis. 
# This will reduce time it takes for sys admins to find errors within logs. 

# Function to display script usage/help information 
function usage_display()
{
    echo "Usage: FinderBash.sh -f <logfile.txt> [-k <keywords>] [-l <log level>] [-o <output_dir>]" 
    echo "Example: ./FinderBash.sh -f /var/log/syslog -l ERROR"
    echo "Example: ./FinderBash.sh -f /var/log/syslog -l WARNING -k disk "
    echo "Example (Saving Logs): ./FinderBash.sh -f /var/log/syslog -l ERROR -o /home/user/logs"
    echo "Options" 
    echo "  -f <logfile> Specify the log file to analyze (must specify path e.g, /var/log/syslog)"
    echo "  -k <keyword> Filter logs containing given keywords"
    echo "  -l <loglevel> Filter logs by level (ERROR, WARNING, INFO, etc.)" 
    echo "  -o <output_dir> Allows you so save output to directories for later analysis"
    echo "  -n <output_file> Allows you to specify output file names"
    echo "  -h Displays this help message" 
    echo "  Have Fun "
    exit 1

}


# Checking if no arguments were supoplied
if [[ $# -eq 0 || "$1" == "-h" ]]; then 
    usage_display
    exit 0 # <-- Allows condition to end
fi 

# Intialiing Varibles
logfile="" 
keyword="" 
loglevel="" 
output_dir=""
output_file=""
timestamp=$(date +"%Y-%m-%d_%H-%M-%S") # <-- Used to attach time stamps to new output files. 



while getopts ":f:k:l:o:n:h" opt; do
    case $opt in
        # option f
        f)
            logfile=$OPTARG
            ;;
        # option k
        k)
            keyword=$OPTARG
            ;;
        # option l
        l)
            loglevel=$OPTARG
            ;; 
        # option o
        o)
            output_dir=$OPTARG
            ;;
        n) 
            output_file=$OPTARG 
        ;;
        

        # option h
        h)
            usage_display
            exit 0
            ;;
#   Display usage and exit
#   any other option
\?)
    echo "Sorry Invalid Option: $OPTARG" 

    echo "Usage: FinderBash.sh -f <logfile.txt> [-k <keywords>] [-l <log level>] [-o <output_dir>]" 
    echo "Options" 
    echo "  -f <logfile> Specify the log file to analyze (must specify path e.g, /var/log/syslog)"
    echo "  -k <keyword> Filter logs containing given keywords"
    echo "  -l <loglevel> Filter logs by level (ERROR, WARNING, INFO, etc.)" 
    echo "  -o <output_dir> Allows you so save output to directories for later analysis"
    echo "  -n <output_file> Allows you to specify output file names"
    echo "  -h Displays this help message" 
    echo "  Have Fun "
    exit 1
    ;; 

# Missing arguments 
:) 
echo "Option $OPTARG needs an argument." 
# Display usage and exit 

    echo "Usage: FinderBash.sh -f <logfile.txt> [-k <keywords>] [-l <log level>] [-o <output_dir>]" 
    echo "Options" 
    echo "  -f <logfile> Specify the log file to analyze (must specify path e.g, /var/log/syslog)"
    echo "  -k <keyword> Filter logs containing given keywords"
    echo "  -l <loglevel> Filter logs by level (ERROR, WARNING, INFO, etc.)" 
    echo "  -o <output_dir> Allows you so save output to directories for later analysis"
    echo "  -n <output_file> Allows you to specify output file names"
    echo "  -h Displays this help message" 
    echo "  Have Fun "
    exit 1
;; 

    esac
done 

# Checking if all required switches are provided. 

if [[ -z $logfile || -z $keyword || -z $loglevel ]]; then 
echo "ERROR: Missing required options. "

    echo "Usage: FinderBash.sh -f <logfile.txt> [-k <keywords>] [-l <log level>] [-o <output_dir>]" 
    echo "Options" 
    echo "  -f <logfile> Specify the log file to analyze (must specify path e.g, /var/log/syslog)"
    echo "  -k <keyword> Filter logs containing given keywords"
    echo "  -l <loglevel> Filter logs by level (ERROR, WARNING, INFO, etc.)" 
    echo "  -o <output_dir> Allows you so save output to directories for later analysis"
    echo "  -n <output_file> Allows you to specify output file names"
    echo "  -h Displays this help message" 
    echo "  Have Fun "
    exit 1
fi 
# Exits 

# Checking if logfile exists and is a regular file
if [[ ! -f $logfile ]]; then 
echo "Error: Input file '$logfile' does not exits or is not a regular file." 
exit 1 
fi # Exits 

if [[ ! -n $output_dir && ! -d $output_dir ]]; then 
    echo "Error: Output directory '$output_dir' does not exists." >&2
    exit 1
fi # Exits 

# Set default file name if not provided 
if [[ -z $output_file ]]; then 
    output_file="log_output_$timestamp.txt" 
fi 

# Applying regex filtering 
FILTER="grep -E '' $logfile" 

# Regexing for keyword seaches (e.g, ERROR, WARNING)
# \\b ONLY allows keywords to be found within sys logs
if [[ -n $loglevel ]]; then 
    FILTER="$FILTER | grep -E '\\b$loglevel\\b'"
fi 

# Regex filter for keyword searches 
if [[ -n $keyword ]]; then 
    FILTER="$FILTER | grep -iE '$keyword'"
fi 

# Executing filtering command

echo "Processing logs from: $logfile..." 
filtered_logs=$(eval "$FILTER")

# Display output 
if [[ -n "$filtered_logs" ]]; then 
    echo "$filtered_logs" 
    else 
    echo "No matching log entries found"
    fi 

# Save output if directory is specified
if [[ -n $output_dir ]]; then 
    output_path ="$output_dir/$output_file" 
    echo "$filtered_logs" > "$output_path" 
    echo "Results saved to: $output_path" 
fi 

exit 0




