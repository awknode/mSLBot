ON @!*:JOIN:#: {
  var %nc = joined_ $+ $chan
  hadd -mu3 %nc nicks $evalnext($hget(%nc,nicks)) $nick
  hadd -mu3 %nc addr $evalnext($hget(%nc,addr)) $mask($wildsite,4)

  if ($numtok($hget(%nc,nicks),32) >= 3) && (!$timer([UMODE_ [ $+ [ $chan ] $+ ] _RM])) && (!%netsplit_ [ $+ [ $chan ] $+ _ $+ [ $network ] ]) {
    if (R !isincs $chan($chan).mode) { .raw mode $chan +RM }
    .timer[UMODE_ $+ [ $chan ] $+ _RM] 1 120 mode $chan -RM
    .timer[BAN_ $+ $chan $+ _CLONES] -h 1 1000 ban_joined_clones $chan
    .timerumodermoff 1 120 mode $chan -RM

  }
}

ON @!*:PART:#: {
  var %nc = joined_ $+ $chan
  if ($istok($hget(%nc,nicks),$nick,32)) && (R !isincs $chan($chan).mode) && (!$timer([UMODE_ [ $+ [ $chan ] $+ ] _RM])) { 
    .raw mode $chan +RM
    .timer[UMODE_ $+ $chan $+ _RM] -h 1 90000 mode $chan -RM
    if ($nick ison $chan) { kick $chan $nick 1┣▇▇4▇═── }
    .timer[BAN_ $+ $chan $+ _MSG] -h 1 10000 msg $chan [WARNING]: Channel has been locked due to a 04flood detection.
    .timermodelol 1 120 mode $chan -RM
  }
}

ON @*:RAWMODE:#: {
  if ($timer([UMODE_ [ $+ [ $chan ] $+ ] _RM])) && (R isincs $1-) || (M isincs $1-) { .timer[UMODE_ [ $+ [ $chan ] $+ ] _RM] off }
}

ON !*:QUIT: {
  var %i = 1
  while ($comchan($nick,%i)) {
    var %chan = $v1
    if (*.*.* iswm $1) && (*.*.* iswm $2) && (!%netsplit_ [ $+ [ %chan ] $+ _ $+ [ $network ] ])  { set -ez %netsplit_ [ $+ [ %chan ] $+ _ $+ [ $network ] ] 600 }
    inc %i
  }
}

alias -l ban_joined_clones {
  if (!$1) { return }
  var %nc = joined_ $+ $1
  if ($hget(%nc,addr)) { _pushmodex -t0 $1 + $+ $str(b,$numtok($v1,32)) $v1 }

  var %t = $numtok($hget(%nc,nicks),32)
  var %i = 1
  while (%i <= %t) {
    var %n = $gettok($hget(%nc,nicks),%i,32)
    if (%n ison $1) { kick $1 %n 1┣▇▇4▇═── }
    inc %i
  }

  .timer[BAN_ $+ $1 $+ _MSG] -h 1 10000 msg $1 [WARNING]: Channel has been locked due to a 04flood detection.

  if ($hget(%nc)) { hfree %nc }
}

alias -l _pushmodex {
  if (-t* iswm $1) { var %time = $mid($1,3) , %count = 0 | tokenize 32 $2- }
  else { var %time = 0 , %count = 0 }
  var %modespl = $modespl , %chan = $1 , %modes = $2 , %parms = $3- , %x = 1 , %y = $len(%modes) , %lwhich = + , %which = + , %a , %b
  tokenize 44 $chanmodes
  var %t1 = $1 , %t2 = $nickmode $+ $2 , %t3 = $3 , %t4 = $4
  tokenize 32 %parms
  while (%x <= %y) {
    var %t = $mid(%modes,%x,1)
    if (%t isin +-) { var %lwhich = %which , %which = %t }
    else {
      if (%t isincs $gettok(%t1 %t2 %t3, 1- $pos(.-+, %which),32)) {
        var %b = %b $1
        tokenize 32 $2-
      }
      var %a = $+(%a,$iif(!%a || %lwhich != %which,%which),%t) , %lwhich = %which
      if ($len($remove(%a,+,-)) = %modespl) {
        if (!%time) { mode %chan %a %b }
        else { .timer -m 1 $calc(%time * %count) mode %chan %a %b }
        var %a = "" , %b = "", %count = %count + 1
      }
    }
    inc %x
  }
  if (%a) { 
    if (!%time) { mode %chan %a %b }
    else { .timer -m 1 $calc(%time * %count) mode %chan %a %b }
  }
}

raw 441:*: { haltdef }


on *:TEXT:*connected*:#services: {
  inc -u1 %cc. [ $+ [ $address($2,2) ] $+ ]
  if (%cc. [ $+ [ $address($2,2) ] ] >= 3) {
    .gline $9 60 Clone Flood Discovered. If you're not a bot please re-connect in a few minutes.
    .mode #123456 +MR
    .timerclone_01 1 120 mode #123456 -MR
  }
}
