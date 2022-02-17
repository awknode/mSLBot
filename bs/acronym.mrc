on *:SOCKOPEN:*: {
  elseif ($sockname == acronym) {
    sockwrite -nt $sockname GET %acrget HTTP/1.1
    sockwrite -nt $sockname Host: www.acronymfinder.com
    sockwrite $sockname $crlf
  }
}
;---

on *:SOCKREAD:*: {
  if ($sockname == acronym) {
    if ($sockerr) { msg %acrchan Error.. | sockclose $sockname }
    var %acread
    sockread %acread
    if (*Your abbreviation search returned* iswm %acread) {
      set %acres $gettok(%acread,6,32)
      if (%acres) {
        .timer 1 1 msg %acrchan 15Your abbreviation search returned $gettok(%acread,6,32) meanings. $iif(%acres > 5, Showing the 5 First., Showing them all!)
      }
      if (!%acres) {
        .timer 1 1 msg %acrchan 15Your abbreviation search returned $gettok(%acread,6,32) meanings. Sorry :(
        sockclose $sockname
      }
    }
    if (*"result-list__body__rank">* iswm %acread) {
      inc -u20 %acrnum 1
      if (%acrnum < 6) {
        inc -u10 %acrtimer 1
        ;.timer 1 %acrtimer msg %acrchan %acread
        .timer 1 %acrtimer msg %acrchan 12 $gettok($iif($gettok(%acread,8,62) != $+($chr(60),td), $v1, $gettok(%acread,7,62)),1,60)
      }
      elseif (%acrnum > 5) {
        sockclose $sockname 
        .timer 1 7 msg %acrchan 7For The Rest3 $calc(%acres - 5) Results Visit $iif(%acronym, $+(www.acronymfinder.com,/,$v1,.html), [Error WhiLe Figuring Out The Link])
      }
    }
  }
}
;----
on *:text:*:#: {
  if ($1 == .acro) {
    if (!$($+(%,acronyms,~,$network,~,$chan),2)) {
      set -u10 $+(%,acronyms,~,$network,~,$chan) 1
      sockopen acronym www.acronymfinder.com 80 | set %acrchan $chan | set %acronym $strip($2) | set %acrget $+(/,$strip($2),.html) | msg $chan 3Searching Results For14:7 $strip($2)
    }
  }
}
