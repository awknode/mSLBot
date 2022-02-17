on *:text:*:#redarmy:{
  var %t $ticks
  sockopen alice. $+ %t www.pandorabots.com 80
  sockmark alice. $+ %t $mid($md5($address($chan,2)),16) $chan $regsubex($1-,/([^\w])/Sg,$+(%,$base($asc(\1),10,16,2)))
}

on *:sockopen:alice.*:{
  tokenize 32 $sock($sockname).mark
  var %u $+(&botcust2=,$1&input=,$3)
  sockwrite -n $sockname POST /pandora/talk?botid=f5d922d97e345aa1&skin=custom_input HTTP/1.1
  sockwrite -n $sockname Host: www.pandorabots.com
  sockwrite -n $sockname Content-Type: application/x-www-form-urlencoded
  sockwrite -n $sockname Content-Length: $len(%u .)
  sockwrite -n $sockname $crlf %u
}

on *:sockread:alice.*:{
  if (!$sockerr) {
    var %s
    $event %s
    if $regex(%s,^.*<em>(.*?)<\/em><\/b>$) {
      timer 1 7 msg $gettok($sock($sockname).mark,2,32) $regml(1)
      sockclose $sockname
    }
  }
}
