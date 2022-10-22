獲取編碼
===

## 快速使用
```PS1
irm bit.ly/Get-Encoding|iex; Get-Encoding
```

## 常用編碼
```ps1
# 獲取UTF-8編碼
irm bit.ly/Get-Encoding|iex; Get-Encoding 'UTF-8'
irm bit.ly/Get-Encoding|iex; Get-Encoding utf8
irm bit.ly/Get-Encoding|iex; Get-Encoding 65535
# 獲取中文編
irm bit.ly/Get-Encoding|iex; Get-Encoding 'Big5'
irm bit.ly/Get-Encoding|iex; Get-Encoding 950
# 獲取日文編
irm bit.ly/Get-Encoding|iex; Get-Encoding 'Shift-JIS'
irm bit.ly/Get-Encoding|iex; Get-Encoding 932
# 獲取簡體編
irm bit.ly/Get-Encoding|iex; Get-Encoding 'GB2312'
irm bit.ly/Get-Encoding|iex; Get-Encoding 936
```


<br><br><br>

## 詳細說明
```ps1
# 載入函式
irm bit.ly/Get-Encoding|iex

# 查詢pwershell當前編碼
(Get-Encoding).EncodingName
# 查詢作業系統編碼
(Get-Encoding -System).EncodingName
# 獲取特定編碼
(Get-Encoding utf8).EncodingName

# 獲取編碼的數字編號
Get-Encoding -CodePage
# 獲取編碼的語言名稱
Get-Encoding -Language
# 獲取編碼的標準名稱
Get-Encoding -FullName

# 查詢系統語言(正好組合出這個功能)
Get-Encoding -System -Language
```


<br><br><br>

## 說明
相比於 C# 標準函式 `[Text.Encoding]::GetEncoding()` 解決的問題

1. 可查詢系統編碼 （`[Text.Encoding]::Default` 返回的是powershell編碼，而不是作業系統的）
2. powershell 內定函式使用的編碼名稱是 utf8 而不是 C# 標準名稱的 utf-8。增加這個容錯兩者都可輸入
3. 可接受字串型態的數字 [string]'65001' 當作輸入項
