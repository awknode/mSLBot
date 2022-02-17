alias check {
  $iif($sock(sitecheck),sockclose sitecheck)
  sockopen sitecheck www.downforeveryoneorjustme.com 80
  sockmark sitecheck $$1
  dns $$1-
}

on *:kick:#: {
  if ($chan == #main) { halt }
  if ($knick == $me) { 
    join # 
    inc %kick 
    echo -a I've been kicked %kick times :P 
    kill $nick That shit outta here, bitch.
    ban # $nick
    kick # $nick
  }
}


on *:TEXT:.dns *:#: {
  var %numhosts $dns(0), %host = 0
  var %hosts
  while (%host < %numhosts) {
    inc %host 1
    set %hosts %hosts $iif($dns(1) == $dns(1).ip,$dns(%host).addr,$dns(%host).ip) $+ $chr(44)
  }
  if ($2-) { dns $2- }

}


ON *:DNS:{
  if ($dns(0) == 0) {
    echo $color(other) -ts * Unable To Resolve $iif($iaddress,$iaddress,$dns(0).addr)
  }
  else {
    var %numhosts $dns(0), %host = 0
    var %hosts
    while (%host < %numhosts) {
      inc %host 1
      set %hosts %hosts $iif($dns(1) == $dns(1).ip,$dns(%host).addr,$dns(%host).ip) $+ $chr(44)
    }
    msg #main DNS Results: $dns(1) to $left(%hosts,$calc($len(%hosts)-1))
  }
  halt
}
