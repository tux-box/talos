#this file will get someone setup for using talos linux.
#create a place to store our binaries.
New-Item -ItemType Directory -Force -Path $HOME\.apps
#add the folder to our enviroument path
#todo: check to make sure our apps folder isn't already in the Environment path.
$oldpath = (Get-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment' -Name PATH).path
$newpath = "$oldpath;$HOME\.apps"
Set-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment' -Name PATH -Value $newpath

#download and add what we need to .apps
# version v1.30.2
Set-Location -Path $HOME\.apps

#todo: create a funtion to verify downloads with online sha256 outputs.

#get kubectl
curl.exe -LO "https://dl.k8s.io/release/v1.30.0/bin/windows/amd64/kubectl.exe" -O $HOME\.apps\kubectl.exe
curl.exe -LO "https://dl.k8s.io/v1.30.0/bin/windows/amd64/kubectl.exe.sha256" -O $HOME\Downloads\kubectl.exe.sha256
CertUtil -hashfile kubectl.exe SHA256 type kubectl.exe.sha256
$(Get-FileHash -Algorithm SHA256 $HOME\.apps\kubectl.exe).Hash -eq $(Get-Content $HOME\Downloads\kubectl.exe.sha25)

#get helm
curl.exe -LO "https://get.helm.sh/helm-v3.15.3-windows-amd64.zip" -O $HOME\Downloads\helm.zip
curl.exe -LO "https://get.helm.sh/helm-v3.15.3-windows-amd64.zip.sha256sum" -O $HOME\Downloads\helm.zip.sha256sum
CertUtil -hashfile helm.zip SHA256 type helm.zip.sha256
$(Get-FileHash -Algorithm SHA256 $HOME\Downloads\helm.zip).Hash -eq $(Get-Content $HOME\Downloads\helm.zip.sha256sum)


#get talosctl
curl.exe -LO "https://github.com/siderolabs/talos/releases/download/v1.7.5/talosctl-windows-amd64.exe" -O $HOME\.apps\talosctl.exe
curl.exe -LO "https://github.com/siderolabs/talos/releases/download/v1.7.5/sha256sum.txt" -O $HOME\Downloads\sha256sum.txt
CertUtil -hashfile talosctl.exe SHA256 type talosctl.exe.sha256
$(Get-FileHash -Algorithm SHA256 $HOME\.apps\talosctl.exe).Hash -eq $(Get-Content .\talosctl.exe.sha256)
move-item -path $HOME\.apps\talosctl-windows-amd64.exe -destination $HOME\.apps\talosctl.exe

#get talos iso.
New-Item -ItemType Directory -Force -Path $HOME\talos
Set-Location -Path $HOME\Downloads
curl.exe -LO "https://github.com/siderolabs/talos/releases/download/v1.7.5/metal-amd64.iso" -O $HOME\Downloads
