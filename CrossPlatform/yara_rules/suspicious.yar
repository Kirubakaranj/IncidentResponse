rule suspicious {
    meta:
        author = "Incident Response Team"
        description = "Detects suspicious patterns"
    
    strings:
        $execve = "execve" 
        $xor_key = { 31 ?? 25 ?? 31 }  // Common XOR patterns
        $powershell_cradle = "DownloadString" nocase
        $iex = "Invoke-Expression" nocase
        $obfuscated_js = /eval\(function\(p,a,c,k,e,d\)/ 
        $long_hex = { [0-9a-f]{128} }  // Long hex strings
        
    condition:
        any of them
}
