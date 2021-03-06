$releases = 'https://github.com/zhongyang219/TrafficMonitor/releases'

function global:au_GetLatest{
	$download_page = Invoke-WebRequest -Uri $releases -UseBasicParsing
	
    $regex = 'x86.7z$'
    $regex64 = 'x64.7z$'
    $url = -Join('https://github.com', ($download_page.links | ? href -match $regex | select -First 1 -expand href))
    $url64 = -Join('https://github.com', ($download_page.links | ? href -match $regex64 | select -First 1 -expand href))
	
	$url -match 'TrafficMonitor_V([\d.]+)_' | Out-Null
    $version = $matches[1]
	
    return @{ Version = $version; URL = $url; URL64 = $url64 }
}

function global:au_SearchReplace {
    @{
        "tools\chocolateyInstall.ps1" = @{
            "(^[$]url\s*=\s*)('.*')"      = "`$1'$($Latest.URL)'"
            "(^[$]url64\s*=\s*)('.*')"      = "`$1'$($Latest.URL64)'"
            "(^[$]checksum\s*=\s*)('.*')" = "`$1'$($Latest.Checksum32)'"
            "(^[$]checksum64\s*=\s*)('.*')" = "`$1'$($Latest.Checksum64)'"
        }
    }
}

update