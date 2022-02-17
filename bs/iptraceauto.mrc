menu nicklist {
  IP Tracker:dns $$1
}

on *:JOIN:# {
  haltdef
  set %tracknick $nick
  set %trackip  $iaddress
  if ($iaddress == $null) set %trackip $naddress
  set %Body  IP= $+ %trackip $+ &button=Search  ; prepare the body for the POST
  sockopen ip-tracker clientn.free-hideip.com 80
}

on *:SOCKOPEN:ip-tracker: {
  if ($sockerr) {
    echo -a Error: $sock(tracert).wsmsg  
  }
  else {
    sockwrite -n $sockname POST /map/whatismyip.php HTTP/1.1
    sockwrite -n $sockname Host: clientn.free-hideip.com
    sockwrite -n $sockname User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:26.0) Gecko/20100101 Firefox/26.0
    sockwrite -n $sockname Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8
    sockwrite -n $sockname Accept-Language: en-US,en;q=0.5
    sockwrite -n $sockname Accept-Encoding: gzip, deflate
    sockwrite -n $sockname Referer: http://clientn.free-hideip.com/map/whatismyip.php
    sockwrite -n $sockname Connection: keep-alive
    sockwrite -n $sockname Content-Type: application/x-www-form-urlencoded
    sockwrite -n $sockname Content-Length: $len(%Body)
    sockwrite -n $sockname $crlf
    sockwrite -n $sockname %Body
  }
}

on *:SOCKREAD:ip-tracker: {
  if ($sockerr > 0) return
  sockread %ip-tracker
  if $regex(%ip-tracker,/<td><div align="left">Country:([^<>]+)/)   { set %country $regml(1) }
  if $regex(%ip-tracker,/<td><div align="left">Region:([^<>]+)/)    { set %region $regml(1) }
  if $regex(%ip-tracker,/<td><div align="left">City:([^<>]+)/)      { set %city $regml(1) }
  if $regex(%ip-tracker,/<td><div align="left">Latitude:([^<>]+)/)  { set %lat $regml(1) }
  if $regex(%ip-tracker,/<td><div align="left">Longitude:([^<>]+)/) { set %lon $regml(1)
    ; We have collected all that we need
    sockclose ip-tracker
    msg #testees [*] %tracknick IP:  %trackip IP: $gettok($address(%tracknick,2),2,64) Country: %country Region: %region City: %city Latitude: %lat Longitude: %lon Map: http://maps.google.com/maps?ll= $+ $remove(%lat,$chr(32)) $+ , $+ $remove(%lon,$chr(32))
    echo -a [*] LongIP: $longip(%trackip)  
    echo -a  [*] Country: %country  
    echo -a [*] Region: %region 14-4 City: 2 %city
    echo -a [*] Latitude: %lat 14-4 Longitude: 2 %lon
    echo -a [*] Map: http://maps.google.com/maps?ll= $+ $remove(%lat,$chr(32)) $+ , $+ $remove(%lon,$chr(32))
    return
  }
}
