on *:TEXT:!price*:#:{ 
  msg $chan 
  sockopen cryptsy dnbradio.com 80
  var %market = $1
}   
on *:SockOpen:cryptsy:{
  sockwrite -n cryptsy GET /testing/crapi/?symbol=UNO/BTC HTTP/1.1
  sockwrite -n cryptsy Host: dnbradio.com 80
  sockwrite -n cryptsy $crlf
  sockwrite cryptsy $crlf
}
on *:SOCKREAD:cryptsy:{
  :nextread
  sockread -f %cryptsy
  if ($sockbr == 0) return
  if (Current isin %cryptsy) { msg #x-coin %cryptsy }
  if (Current isin %cryptsy) { msg #x-coin %cryptsy }
  goto nextread
}
on *:SOCKCLOSE:cryptsy*:{
  echo price bot just closed
} 
on *:TEXT:!help:#:{ 
  msg $chan $nick Use !price
}
