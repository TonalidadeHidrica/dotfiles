Import-Module $env:ChocolateyInstall\helpers\chocolateyProfile.psm1
refreshenv

Set-Alias -Name vim -Value nvim

Remove-Alias -Force -Name cd
function cd {
    param (
        [string]$Path
    )

    # Check if $Path is empty, if so, assign $USERPROFILE
    if ([string]::IsNullOrEmpty($Path)) {
        $Path = $env:USERPROFILE
    }

    # Get the WSL2 PID
    $wsl2_pid = $env:WSL2_CURRENT_PID

    # Check if the WSL2 PID environment variable is set
    if ($wsl2_pid -ne $null) {
        # Define the path to the file
        $file_path = Join-Path -Path $env:USERPROFILE -ChildPath ".powershell-cd\$wsl2_pid"

        # Check if the directory exists, if not, create it
        if (!(Test-Path -Path $file_path)) {
            New-Item -Path $file_path -ItemType File -Force > $null
        }

        # Convert $Path to absolute path
        $absolute_path = Convert-Path -Path $Path

        # Append the destination to the file
        Set-Content -Path $file_path -Value $absolute_path
    }

    # Call the original cd command to change directory
    Set-Location $Path
}

# cd to current directory to store current path
cd .

function Init-Wsl-Cd-Sync {
    # When started from WSL2, cd to home directory
    if ($env:WSL2_CURRENT_PID -ne $null) {
        $directoryToCd = $env:USERPROFILE
    }
    # However, when spawned from powershell ran by tmux, cd to that directory
    if ($env:WSL2_PARENT_PID -ne $null) {
        $directoryFile = "$env:USERPROFILE\.powershell-cd\$env:WSL2_PARENT_PID"
        if (Test-Path $directoryFile) {
            $directoryToCd = Get-Content $directoryFile
        }
    }
    # Actual cd
    if ($directoryToCd -ne $null) {
        cd $directoryToCd
    }
}

# vcpkg
$Env:VCPKGHOME="$env:USERPROFILE\dev\git\com\github\microsoft\vcpkg"
$Env:PATH="$Env:PATH;$Env:VCPKGHOME\installed\x64-windows\bin"
$Env:INCLUDE="$Env:INCLUDE;$Env:VCPKGHOME\installed\x64-windows\include"
$Env:LIB="$Env:LIB;$Env:VCPKGHOME\installed\x64-windows\lib"

# Vim mode
Set-PSReadLineOption -EditMode Vi
Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete

Remove-PSReadLineKeyHandler -Chord "Ctrl+d"

function git-autoclone {
    param (
        [string]$url
    )

    if (-not $url) {
        Write-Host "Please specify the repository url."
        return
    }

    $protocol = ""
    $domain = ""
    $user = ""
    $name = ""

    if ($url -match '^https://(github|gitlab).com/([\w.-]+)/([\w.-]+)/?$') {
        $protocol = "https"
        $domain = $matches[1] + ".com"
        $user = $matches[2]
        $name = $matches[3]
    }
    elseif ($url -match '^git@(github|gitlab).com:([\w.-]+)/([\w.-]+).git$') {
        $protocol = "ssh"
        $domain = $matches[1] + ".com"
        $user = $matches[2]
        $name = $matches[3]
    }
    else {
        Write-Host "The URL could not be parsed."
        return
    }

    if (Test-Path "$env:USERPROFILE\.config\powershell\git-autoclone-config.txt") {
        $configLines = Get-Content "$env:USERPROFILE\.config\powershell\git-autoclone-config.txt"
        foreach ($line in $configLines) {
            $args = $line -split '\t'
            if ($args.Count -ne 3) {
                Write-Host "There is a line in git-autoclone-config.txt that doesn't have exactly 3 items"
                return
            }
            if ($protocol -eq "ssh" -and $domain -eq $args[0] -and $user -eq $args[1]) {
                $url = "git@$($args[2]):$user/$name"
                break
            }
        }
    }

    Write-Host "Domain:     $domain"
    Write-Host "Username:   $user"
    Write-Host "Repository: $name"
    Write-Host "Url:        $url"

    $dir = "$env:USERPROFILE\dev\git\com\github\$user"
    New-Item -ItemType Directory -Force -Path $dir | Out-Null
    Set-Location -Path $dir
    git clone $url
    Set-Location -Path $name
}
