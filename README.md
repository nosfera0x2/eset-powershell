# eset-powershell

Disclaimer: This tool has not been officially endorsed by ESET.
-> Always ensure there is a good back up, and have fun with the script!

# ESET Log Collector to FTP

This script:
1) Prompts user for name of their company.
2) Checks to see if a file named esetlogcollector.exe exists in the users download folder.
3) Downloads esetlogcollector.exe if need be.
4) Runs ELC with profile all and original binary to disk
5) Renames the file to <name of company.zip>
6) Send the archive to the ESET FTP server.
