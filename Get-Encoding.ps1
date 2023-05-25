# 獲取編碼
function Get-Encoding {
    [CmdletBinding(DefaultParameterSetName = "Default")]
    param (
        [Parameter(Position = 0, ParameterSetName = "")]
        [Object] $Encoding,
        [Parameter(ParameterSetName = "WebName")]
        [Switch] $WebName,
        [Parameter(ParameterSetName = "CodePage")]
        [Switch] $CodePage,
        [Parameter(ParameterSetName = "Language")]
        [Switch] $Language,
        [Parameter(ParameterSetName = "FullName")]
        [Switch] $FullName
    )
    
    # 獲取編碼
    if (!$Encoding) { # 系統語言編碼
        if (!$script:__SysEnc__) { $script:__SysEnc__ = [Text.Encoding]::GetEncoding((powershell -nop "([Text.Encoding]::Default).WebName")) }
        $Enc = $script:__SysEnc__
    } else { # 自定編碼
        if ($Encoding -is [Text.Encoding]) {
            $Enc = $Encoding
        } else { 
            switch ($Encoding) {
                'UTF8'    { $Enc = New-Object System.Text.UTF8Encoding $False; break }
                'UTF8BOM' { $Enc = New-Object System.Text.UTF8Encoding $True; break }
                'Default' { $Enc = [Text.Encoding]::Default; break } # 終端機本身的預設編碼
                default {
                    if ($Encoding -match '^\d+$') { $Encoding = [int]$Encoding }
                    try { $Enc = [Text.Encoding]::GetEncoding($Encoding) } catch { Write-Error $_ -EA Stop }
                }
            }
        }
    }
    
    # 輸出
    if ($WebName) {
        return $Enc.WebName
    } elseif($CodePage) {
        return $Enc.CodePage
    } elseif($Language) {
        ($Enc.EncodingName) -match '^(.*?) \('|Out-Null
        return $matches[1]
    } elseif($FullName) {
        ($Enc.EncodingName) -match '\((.*?)\)'|Out-Null
        return $matches[1]
    } return $Enc
} # Get-Encoding
# 各型態測試
# (Get-Encoding).EncodingName
# (Get-Encoding 'Default').EncodingName
# (Get-Encoding Default).EncodingName
# (Get-Encoding 'utf8').EncodingName
# (Get-Encoding utf8).EncodingName
# (Get-Encoding 932).EncodingName
# (Get-Encoding '932').EncodingName
# (Get-Encoding ([double]932.0)).EncodingName
# (Get-Encoding 'GB2312').EncodingName
# (Get-Encoding ([Text.Encoding]::GetEncoding(65001))).EncodingName

# 錯誤測試
# (Get-Encoding 123156).EncodingName
# (Get-Encoding 'AAAA').EncodingName
# (Get-Encoding '111').EncodingName
# 選用參數測試
# Get-Encoding 932 -WebName
# Get-Encoding 932 -CodePage
# Get-Encoding 932 -Language
# Get-Encoding 932 -FullName
#
# irm bit.ly/Import-Param|iex
# StopWatch{
#     (0..50000)|ForEach-Object{
#         Get-Encoding 932 -FullName|Out-Null
#     }
# }
# StopWatch{
#     (0..50000)|ForEach-Object{
#         Get-Encoding '932' -FullName|Out-Null
#     }
# }
