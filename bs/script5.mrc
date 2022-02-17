alias twitch {
  %ttwitch1 = $remove($1,http://,www.,twitch,.tv)
  sockopen twitch www.twitch.tv 80
  sockopen -e twitchprofile api.twitch.tv 443
  %ttwitch11 = /kraken/streams $+ %ttwitch1
}
on *:SOCKOPEN:twitch: {
  sockwrite -n $sockname GET %ttwitch1 HTTP/1.1
  sockwrite -n $sockname Host: www.twitch.tv
  sockwrite -n $sockname Connection: Keep-Alive
  sockwrite -n $sockname Content-Type: text/html
  sockwrite -n $sockname $crlf
}
on *:SOCKOPEN:twitchprofile: {
  sockwrite -n $sockname GET %ttwitch11 HTTP/1.1
  sockwrite -n $sockname Host: api.twitch.tv
  sockwrite -n $sockname Connection: close
  sockwrite -n $sockname $crlf
}
on *:sockread:twitchprofile:{
  if ($sockerr > 0) return
  :nextread
  sockread -f %temp
  if ($sockbr == 0) return
  if (%temp == $null) %temp = -
  if (_id isin %temp) {
    %twoffline = 1
  }
  goto nextread
}
on *:SOCKCLOSE:twitchprofile: {
  if (%twoffline == 1) {
    msg %ttwitch3 %ymoon 6,0 LIVE
  }
}


on *:SOCKREAD:twitch: {
  sockread %ttwitch2
  if (%ttwitch2 == $null) && (%lgsr == $null) {
    msg %ttwitch3 0,6 TWITCH15,1 Error receiving information.
    set %lgsr 1
  }
  elseif (%ttwitch2 == $null) && (#sockread != $null) { noop }
  elseif ( %endtitle2 = $pos(%ttwitch2,/>,1)
  %starttitle2 = $pos(%ttwitch2, %starttitle3 = $pos(%ttwitch2,",1)
  %inbetween3 = $calc(%endtitle3 - %starttitle3)
  msg %ttwitch3 %ymoon 6,0 Game: $mid(%ttwitch2,$calc(%starttitle3 + 1),$calc(%inbetween3 - 1)) 
}

on *:TEXT:*twitch.tv*:#: {
  %ttwitch3 = $chan
  %ttwitch4 = 1
  %ymoon = 0,6 TWITCH
  while ([ $chr(36) $+ [ %ttwitch4 ] ]) {
    if (twitch.tv/ isin [ $chr(36) $+ [ %ttwitch4 ] ]) {
      sockclose twitch
      sockclose twitchprofile
      %twoffline = 0
      twitch [ $chr(36) $+ [ %ttwitch4 ] ]
    }
    inc %ttwitch4
  }
}
