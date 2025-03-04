FinderBash 

Finderbash uses a Bash scirpt to filter and extractr system logs from a specfic log file. It also allows users to search for specfic log levels (ERROR, WARNING, INFO), filter logs via keywords, and save results for later analysis. 

Features: 
Extractions and filtering of logs from any specified log file 
Log Searches via keywords
Log filtering through serverity levels (ERROR, WARNING, INFO, etc)
Output directories
Saving of output files 

Usage: 
./FinderBash.sh -f <logfile> [-k <keyword>] [-l <log level>] [-o <output_dir> ] [-n <output_file>]

Examples: 
1. Searching for ERROR logs within /var
./FinderBash.sh -f /var/log/syslog -l ERROR (CAUTION: log files might be located elsewhere within your system)

2. Search for logs containing the keyword "disk" 
./FinderBash.sh -f /var/log/syslog -k disk

3. Filter logs with level WARNING and containing "network" 
./FinderBash.sh -f /var/log/syslog -l WARNING -k network 

4. Save filtered logs to a directory
./FinderBash.sh -f /var/log/syslog -l ERROR -o /home/user/logs 

5. Save logs with custom file names
./FinderBash.sh -f /var/log/syslog -l ERROR -o /home/user/logs -n my_log.txt 

Requirments: 
Bash Shell 
grep command 
sufficent permissions to read the log file. 

Licenses: 
This script is open-source and can be modified as needed 

Author
Andrew Johns