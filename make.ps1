if($args[0] -eq "clean"){
  rm src/maps/*.lua
  return
}elseif($args[0] -eq "reset"){
  rm $env:AppData\LOVE\Hawkthorne\*.json
  rm src/maps/*.lua
  rm bin/
  return
}

Write-Host "Running make.ps1..."

$check = Test-Path -PathType Container bin
if($check -eq $false){
  New-Item 'bin' -type Directory
}

$webclient = New-Object System.Net.WebClient
$lovedir = "bin\love-11.5-win64\"
$check = Test-Path "bin\love-11.5-win64\love.exe"

#add love to the path if necessary
$foundlove = $env:Path.Contains($lovedir)
if($foundlove -eq $false){
  $env:Path += ";"+$lovedir
}

if($check -eq $false){

  $filename = (Get-Location).Path + "\bin\love-11.5-win64.zip"

  $check = Test-Path $filename

  if($check -eq $false){
    Write-Host "Downloading love2d..."
    $url = "https://github.com/love2d/love/releases/download/11.5/love-11.5-win64.zip"
    try {
      $webclient.DownloadFile($url,$filename)
    } catch {
      Write-Error "Failed to download love2d..."
      Write-Error $_
      Exit
    }
  }

  $shell_app=new-object -com shell.application
  $zip_file = $shell_app.namespace($filename)
  $destination = $shell_app.namespace((Get-Location).Path + "\bin\")
  $destination.Copyhere($zip_file.items())
}

if($args[0] -eq "run"){
  Write-Host "Running Playground..."
  if($args.Length -ne 1){
    .\bin\love-11.5-win64\love.exe src $args[1..($args.Length-1)]
  }else{
    .\bin\love-11.5-win64\love.exe src
  }
}
