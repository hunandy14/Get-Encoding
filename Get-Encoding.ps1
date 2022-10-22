# 獲取編碼
function Get-Encoding {
    [CmdletBinding(DefaultParameterSetName = "Default")]
    param (
        [Parameter(Position = 0, ParameterSetName = "")]
        [Object] $Encoding,
        [Parameter(ParameterSetName = "")]
        [Switch] $SystemEncoding,
        [Parameter(ParameterSetName = "A")]
        [Switch] $WebName,
        [Parameter(ParameterSetName = "B")]
        [Switch] $CodePage,
        [Parameter(ParameterSetName = "C")]
        [Switch] $Language,
        [Parameter(ParameterSetName = "C")]
        [Switch] $FullName
    )
    # 轉換編碼
    if ($Encoding) {
        if ('UTF8' -eq $Encoding) { $Encoding = 'UTF-8' }
        try { $Enc = [Text.Encoding]::GetEncoding($Encoding) } catch {
            Write-Error "Encoding `"$Encoding`" is not a supported encoding name."; return $null
        }
    # 預設編碼
    } else { 
        if ($SystemEncoding) {
            if (!$__SysEnc__) { $Script:__SysEnc__ = [Text.Encoding]::GetEncoding((powershell -nop "([Text.Encoding]::Default).WebName")) }
            $Enc = $__SysEnc__
        } else {
            $Enc = [Text.Encoding]::Default
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

# (Get-Encoding).EncodingName
# (Get-Encoding -SystemEncoding).EncodingName
# (Get-Encoding 'utf8').EncodingName
# (Get-Encoding 932).EncodingName
# (Get-Encoding 'GB2312').EncodingName
# 
# (Get-Encoding 123156).EncodingName
# (Get-Encoding 'AAAA').EncodingName
# (Get-Encoding '111' -SystemEncoding).EncodingName
# 
# Get-Encoding 932 -SystemEncoding
# Get-Encoding 932 -CodePage
# Get-Encoding 932 -Language
# Get-Encoding 932 -FullName