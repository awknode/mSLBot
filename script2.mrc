On $*:Text:*:#: { 
  if (!%fud && !$($+(%, fud., $nick), 2)) {
    set -u3 %fud On
    set -u10 %fud. $+ $nick On
    if ($network == internetz ) && ($2 == .asskey ) { play $chan $scriptdir/art/ $+ $3 $+ .txt 0 | halt }  
    ; if ($botmaster($network,$nick)) {
    if ($1 == .asskey ) && ($2 != $null) { play $chan $scriptdir/art/ $+ $2 $+ .txt 0 | halt }
    spamprotect
    exprotect $1-
    else { msg $chan 6Invalid format. 6[ i.e. $asskey bigmatix 6]
    }
    ; else { msg # 06Invalid permissions. }
  }
}
