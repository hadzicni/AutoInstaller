$softwarePackages = @{
    "Firefox" = "C:\Installers\FirefoxSetup.exe"
    "Chrome"  = "C:\Installers\ChromeSetup.exe"
}

function IsSoftwareInstalled {
    param (
        [string]$packageName
    )
    $installed = Get-WmiObject -Class Win32_Product | Where-Object { $_.Name -eq $packageName }
    return [bool]$installed
}

function InstallSoftware {
    param (
        [string]$packageName,
        [string]$installerPath
    )
    Write-Host "Installiere $packageName..."
    Start-Process -FilePath $installerPath -ArgumentList "/S" -Wait
    Write-Host "$packageName wurde erfolgreich installiert."
}

foreach ($package in $softwarePackages.GetEnumerator()) {
    $packageName = $package.Key
    $installerPath = $package.Value

    if (-not (IsSoftwareInstalled -packageName $packageName)) {
        InstallSoftware -packageName $packageName -installerPath $installerPath
    }
    else {
        Write-Host "$packageName ist bereits installiert."
    }
}
