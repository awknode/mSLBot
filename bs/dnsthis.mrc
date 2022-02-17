On $owner:text:/^[!%.@](check)(\s|$)/Si:#: { 
  if ($2 == $null) { msg $chan Improper syntax. [Ex: !check <ip>] | halt }
  spamprotect
  exprotect $1-
  $check $2- 
}

alias check { 
  set %site.target $1-
  if ($sock(sitecheck)) { sockclose sitecheck }
  sockopen sitecheck www.downforeveryoneorjustme.com 80
  sockmark sitecheck $$1
}
on *:sockopen:sitecheck: {
  sockwrite -n $sockname GET $+(/,$sock(sitecheck).mark) HTTP/1.1
  sockwrite -n $sockname Host: www.downforeveryoneorjustme.com
  sockwrite -n $sockname Connection: close
  sockwrite -n $sockname $crlf
}

on *:sockread:sitecheck: {
  set %dns 1 
  var %x | sockread %x
  if (*It's just you* iswm %x) { 
    set %sitestatus 3Online | dns %site.target
  line.dns | echo 3 -at * Status: %sitestatus }
  else {
    if (*It's not just you!* iswm %x) {
      set %sitestatus 4Offline | dns %site.target
    line.dns | echo 3 -at * Status: %sitestatus }

  } 
}
on *:DNS:{ 
  if (%dns == 1) {
    var #
    set %site.target $naddress
    set %site.ip $iaddress
    msg #DMT * Host: $naddress
    msg #DMT * IP: $iaddress
    msg #DMT * Resolved: $raddress
    line.dns
    unset %dns 
  }
}
alias line.dns {
  echo 3 -at --------------------------------------------------------------
}
