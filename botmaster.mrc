alias -l bm.file { return $scriptdirbotmaster.ini }

alias botmaster {
  var %network = $1, %nick = $2, %host = $address(%nick,0), %bm_host = $+(%network,$chr(44),%host)
  var %hosts = $readini($bm.file,%nick,hosts)
  if (%hosts) { 
    if ($istok(%hosts,%bm_host,32)) { return $true }
    else { return $false }
  }
  else { return $false }
}

alias chkstat { var %x = $nick($1,$2).pnick | var %i = 0 | while (%i < $gettok(~*&*@*%,0,42)) { inc %i | if ($gettok(~*&*@*%,%i,42) == $left(%x,1)) { return $gettok(~*&*@*%,%i,42) | halt } } }
; if ($chkstat($chan,$nick)) { blah }
