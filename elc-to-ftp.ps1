<#
May 2021 - ESET Technical Support

This script was designed to help streamline the process of ESET log collection.
In the 'cmd /c' part of the script, values can be changed as needed using details from the ESET help article:
https://help.eset.com/log_collector/3.2/en-US/?elc_cli.html

For ease of use, the $company variable can be set by altering the script as well.
#>

Set-ExecutionPolicy Bypass -Scope Process

#prompt for name of company, later used as name of archive.

$company = read-host 'What is your company name?'

#source of current ELC package

$source = 'https://download.eset.com/com/eset/tools/diagnosis/log_collector/latest/esetlogcollector.exe'

Set-Variable -Name destination -Value ($env:userprofile)

#Tests to see if esetlogcollector.exe is already in the user's downloads folder.

If((Test-Path -Path $destination\Downloads\esetlogcollector.exe -PathType Leaf) -eq 'True') {

	write-host 'ESET Log Collector Tool Found'
}

else {

	Invoke-WebRequest -uri $source -outfile $destination\downloads\esetlogcollector.exe
}
#runs the ESET Log Collector with profile set to all

cmd /c "start /wait %USERPROFILE%\Downloads\esetlogcollector.exe /accepteula /otype:obin /profile:all %USERPROFILE%\Downloads\eset_logs_ps.zip"

#renames the eset_logs_ps file to an archive with name of the company

Rename-item $env:userprofile\downloads\eset_logs_ps.zip -NewName $env:userprofile\downloads\"$company.zip"

#this defines a function which allows for anonymous uploads to the ESET FTP server. 

function SendByFTP {
    param (
        $userFTP = "anonymous",
        $passFTP = "anonymous",
        [Parameter(Mandatory=$True)]$serverFTP,
        [Parameter(Mandatory=$True)]$localFile,
        [Parameter(Mandatory=$True)]$remotePath
    )
    if(Test-Path $localFile){
        $remoteFile = $localFile.Split("\")[-1]
        $remotePath = Join-Path -Path $remotePath -ChildPath $remoteFile
        $ftpAddr = "ftp://${userFTP}:${passFTP}@${serverFTP}/$remotePath"
        $browser = New-Object System.Net.WebClient
        $url = New-Object System.Uri($ftpAddr)
        $browser.UploadFile($url, $localFile)    
    }
    else{
        Return "Unable to find $localFile"
    }
}

SendByFTP -serverFTP 38.90.227.40 -localfile $env:userprofile\downloads\"$company.zip" -remotepath "/support/"
