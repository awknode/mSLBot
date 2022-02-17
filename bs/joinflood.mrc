	
on *:JOIN:#: {
  inc -u3 %hrj.flood
  set -u5 %hrj.nick $addtok(%hrj.nick, $nick,32)
  if (%hrj.flood > 4) && (!%netsplit) {
    ; mode # +MRl 50
    hrj.flood
    ; .timer 1 50 mode # -MRl | halt
  }
}

alias hrj.flood {
  if ($nick != $me) {
    %hrj = 1
    while (%hrj <= $numtok(%hrj.nick,32)) {
      mode $chan +b $address($gettok(%hrj.nick,%hrj,32),0)
    kick $chan $gettok(%hrj.nick,%hrj,32) [ Flood detected.] }
    ;msg #opers [9Join flood detected.] in $chan $+ . Threat has been 7eliminated At: $time On: $date $+ .
    inc %hrj
  }
}


on *:SNOTICE:*: {
  if ($network == HardChats) {
    if ($1- == Link) && ($1- == established) {
      set -u20 %netsplit on
      msg #opers 15(14 $+ $gettok($5,1,91) has re-established a connection, disabling flood control for the moment.  [7Time]15: 14 $+ $time(hh:nntt) $+ 15]
    }
    if ($1- == Link) && ($1- == established)  {
      if (services.voidptr.cz isin $8) {
        msg #opers 15(14 $+ $gettok($8,1,91) has re-established a connection, disabling flood control for the moment. Turning Logchan On. [7Time]15: 14 $+ $time(hh:nntt) $+ 15]
        timerlogchan 1 2 os set logchan on
        set -u20 %netsplit on
      }
      else {
        msg #opers 15[14 $+ $gettok($8,1,91) has re-established a connection, disabling flood control for the moment. [7Time]15: 14 $+ $time(hh:nntt) $+ 15]
        set -u20 %netsplit on
      }
    }
  }
}
