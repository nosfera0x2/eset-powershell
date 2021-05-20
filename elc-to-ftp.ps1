#tested on 0520221 - works
Set-ExecutionPolicy Bypass -Scope Process
#prompt for name of company
$company = read-host 'What is your company name?'
#source of current ELC package
$source = 'https://download.eset.com/com/eset/tools/diagnosis/log_collector/latest/esetlogcollector.exe'

Set-Variable -Name destination -Value ($env:userprofile)

If((Test-Path -Path $destination\Downloads\esetlogcollector.exe -PathType Leaf) -eq 'True') {

	write-host 'ESET Log Collector Tool Found'
}

else {

	Invoke-WebRequest -uri $source -outfile $destination\downloads\esetlogcollector.exe
}

cmd /c "start /wait %USERPROFILE%\Downloads\esetlogcollector.exe /accepteula /otype:obin /profile:all %USERPROFILE%\Downloads\eset_logs_ps.zip"

Rename-item $env:userprofile\downloads\eset_logs_ps.zip -NewName $env:userprofile\downloads\"$company.zip"

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