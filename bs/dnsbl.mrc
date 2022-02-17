on *:TEXT:!dnsbl*:#: {
  proxycheck $2 $chan $nick
}
alias proxycheck { 
  if ($1 == $null) { msg $chan 3* Missing parameters: !dnsbl <ip> }

  elseif ($1 == callback) {
    msg $hget(dbl,chan) 3* The IP has been detected in $+($hget(dbl,found),/,$hget(dbl,num)) BL zones.
    if ($hget(dbl,found) > 0) {
      var %i = 1
      var %s
      while (%i <= $hget(dbl,num)) {
        var %dbl = $gettok($hget(dbl,list),%i,44)
        if ($hget(dbl,%dbl)) { 
          %s = $+(%s,$chr(32),%dbl)
        }
        inc %i
      }
      msg $hget(dbl,chan) $3 Detected BL zones: %s
    }
    .disable #dbl
    hfree dbl
  }
  else {
    if ($1 == localhost) {
      tokenize 32 $ip $2 $3
    }
    if ($longip($1)) {
      msg $2 3* Checking IP address ( $+ $1 $+ ), hold.
      if ($hget(dbl)) { hfree dbl }
      hmake dbl
      hadd -m dbl list dnsbl.dronebl.org,dnsbl.proxybl.org,tor.dnsbl.sectoor.de,tor.dan.me.uk,dnsbl.njabl.org,rbl.efnet.org,virbl.dnsbl.bit.nl,dnsbl.ahbl.org,rbl.faynticrbl.org,dnsbl.ipocalypse.net,dnsbl.rizon.net,dnsbl.swiftbl.org,dnsbl.libirc.so,dnsbl.bnc4free.in,dnsbl.sorbs.net
      hadd -m dbl num $numtok($hget(dbl,list),44)
      hadd -m dbl ip $1
      hadd -m dbl found 0
      hadd -m dbl chan $2
      hadd -m dbl nick $3
      .enable #dbl
      var %i = 1
      while (%i <= $hget(dbl,num)) {
        .dns $+($revip($1),.,$gettok($hget(dbl,list),%i,44))
        inc %i
      }
    }
    else { msg $chan 3* Invalid IP Address. }
  }
}
#dbl off
on *:DNS:{
  var %dbl = $gettok($dns(1),5-,46)
  hadd -m dbl count $calc($hget(dbl,count) + 1) 
  if ($dns(0).ip) { hadd -m dbl %dbl 1 | hadd -m dbl found $calc($hget(dbl,found) + 1) }
  if ($hget(dbl,count) == $hget(dbl,num)) { proxycheck callback }
}
#dbl end

;-RevIP script by Patje from SwiftIRC.
alias revip { tokenize 46 $1 | return $+($4, ., $3, ., $2, ., $1) }
