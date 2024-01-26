Import-Module $env:ChocolateyInstall\helpers\chocolateyProfile.psm1
refreshenv

Set-Alias -Name vim -Value nvim

Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete
