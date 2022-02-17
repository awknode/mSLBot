alias isurl return $iif($regex($1-,/\b(\^@\S+|www\.\S+|http|https://\S+|irc\.\S+|irc://\S+|\w+(?:[\.-]\w+)?@\w+(?:[\.-]\w+)?\.[a-z]{2,4})\b/gi),$iif($prop,$regml($v1),$true))
alias tiny {
  if ($1) && ($isurl($1)) {
    set %p 0
    sockclose Tinyurl
    set %TinyurlURL /create.php?source=indexpage&url= $+ $1- $+ &submit=Make+TinyURL%21&alias=
    sockopen Tinyurl tinyurl.com 80
  }
  elseif ( !$isurl($1) ) { 
    if (# isin %nick) { msg %nick 12URL invalid. }
    else { notice %nick 12URL invalid. }
  }
} 
on *:TEXT:.tiny*:#: {
  spamprotect
  exprotect $1-
  set %nick $chan
  tiny $2-
}

alias shorten { 
  set %nick $me
  tiny $1-
}

on *:TEXT:.tiny*:?:{
  spamprotect
  exprotect $1-
  set %nick $nick
  tiny $2-
}

on *:SOCKOPEN:Tinyurl: {
  sockwrite -n Tinyurl GET %TinyurlURL HTTP/1.1
  sockwrite -n Tinyurl Host: tinyurl.com
  sockwrite Tinyurl $crlf
}
on *:SOCKREAD:Tinyurl: {
  sockread %Tinyurl
  while ($sockbr) {
    if (<div class="indent"><b> isin %Tinyurl) && (%p == 0) { 
      if ($chr(35) isin %nick ) { msg %nick .12TinyURL. $gettok($right(%Tinyurl,-31),1,60) }
      else { notice %nick .12TinyURL. $gettok($right(%Tinyurl,-31),1,60) }
      unset %p
    }
    sockread %Tinyurl
  }
}
