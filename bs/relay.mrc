alias -l relay.networks { return internetz internetz }
;
;   Relay.channels, this is a list, seperated by a 
;     space, of the channel names that we are going 
;     to be relaying, the channel names corrispond to 
;     the relay.networks above.
alias -l relay.channels { return #testees #rest }
;
;   Relay.fmt.text, this is the format of normal 
;     relayed text.
;     $1  = Nick
;     $2  = Channel
;     $3  = Network
;     $4- = Text
alias -l relay.fmt.text { return $+(<14,$1,12,@,,$3,>) $4- }
;;alias -l relay.fmt.text { if ($network == freenode ) { halt } 
;;  if (Binance-Mvmt == $nick ) || (raccoon == $nick ) { return $4- }
;; }
;
;   Relay.fmt.action, this is the format of /me 
;     relayed text.
;     $1  = Nick
;     $2  = Channel
;     $3  = Network
;     $4- = Text
alias -l relay.fmt.action { return »  $+($1,/,$2,@,$3,) $4- }
;
;   Relay.fmt.quit, this is the format of relayed
;     quits.
;     $1  = Nick
;     $2  = Channel
;     $3  = Network
;     $4- = Quit Message
;
alias -l relay.fmt.quit { return » $+($1,@,$3) Quit $4- }
;
;   Relay.fmt.join, this is the format of relayed 
;     joins.
;     $1  = Nick
;     $2  = Channel
;     $3  = Network
alias -l relay.fmt.join { return » $+($1,@,$3) has joined $2 $+ . }
;
;   Relay.fmt.part, this is the format of relayed
;     parts.
;     $1  = Nick
;     $2  = Channel
;     $3  = Network
;     $4- = Part Message (if available)
alias -l relay.fmt.part { return » $+($1,@,$3) has parted $2 ( $+ $4- $+ ) $+ . }
;
;   Relay.fmt.kick, this is the format of relayed
;     parts.
;     $1  = Nick
;     $2  = Channel
;     $3  = Network
;     $4  = Kicker
;     $5- = Kick Message
alias -l relay.fmt.kick { return » $+($4,@,$3) has kicked $+($1,@,$3) out of $2 ( $+ $5- $+ ) }
;
;   Relay.fmt.mode, this is the format of relayed 
;     modes.
;     $1  = Nick
;     $2  = Channel
;     $3  = Network
;     $4- = Modes
alias -l relay.fmt.mode { return » $+($1,@,$3) sets mode: $4- }
;
;   Relay.fmt.topic, this is the format of relayed 
;     topics.
;     $1  = Nick
;     $2  = Channel
;     $3  = Network
;     $4- = Topic
alias -l relay.fmt.topic { return » $+($1,@,$3) Sets topic: $4- }


on *:text:*:#:{ 
  var %tok = $findtok($relay.networks,$network,1,32) 
  if ($chan == $gettok($relay.channels,%tok,32)) { 
    var %lcv = 1 
    var %tot = $gettok($relay.networks,0,32) 
    while (%lcv <= %tot) { 
      var %cid = $cid 
      var %ncid = $getcidfromnet($gettok($relay.networks,%lcv,32)) 
      if (%ncid != %cid) { 
        var %net = $network 
        scid %ncid 
        msg $gettok($relay.channels,%lcv,32) $relay.fmt.text($nick,$chan,%net,$1-) 
        scid %cid 
      } 
      inc %lcv 
    } 
  } 
} 
on *:action:*:#: { 
  var %tok = $findtok($relay.networks,$network,1,32) 
  if ($chan == $gettok($relay.channels,%tok,32)) { 
    var %lcv = 1 
    var %tot = $gettok($relay.networks,0,32) 
    while (%lcv <= %tot) { 
      var %cid = $cid 
      var %ncid = $getcidfromnet($gettok($relay.networks,%lcv,32)) 
      if (%ncid != %cid) { 
        var %net = $network 
        scid %ncid 
        msg $gettok($relay.channels,%lcv,32) $relay.fmt.action($nick,$chan,%net,$1-)
        scid %cid 
      } 
      inc %lcv 
    } 
  } 
} 
on *:quit: { 
  var %tok = $findtok($relay.networks,$network,1,32) 
  if ($nick ison $gettok($relay.channels,%tok,32)) { 
    var %lcv = 1 
    var %tot = $gettok($relay.networks,0,32) 
    while (%lcv <= %tot) { 
      var %cid = $cid 
      var %ncid = $getcidfromnet($gettok($relay.networks,%lcv,32)) 
      if (%ncid != %cid) { 
        var %net = $network 
        scid %ncid 
        msg $gettok($relay.channels,%lcv,32) $relay.fmt.quit($nick,$gettok($relay.channels,%tok,32),%net,$1-)
        scid %cid 
      } 
      inc %lcv 
    } 
  } 
} 
on *:join:#: { 
  if ($nick != $me) { 
    var %tok = $findtok($relay.networks,$network,1,32) 
    if ($chan == $gettok($relay.channels,%tok,32)) { 
      var %lcv = 1 
      var %tot = $gettok($relay.networks,0,32) 
      while (%lcv <= %tot) { 
        var %cid = $cid 
        var %ncid = $getcidfromnet($gettok($relay.networks,%lcv,32)) 
        if (%ncid != %cid) { 
          var %net = $network 
          scid %ncid 
          msg $gettok($relay.channels,%lcv,32) $relay.fmt.join($nick,$chan,%net)
          scid %cid 
        } 
        inc %lcv 
      } 
    } 
  } 
} 
on *:part:#: { 
  if ($nick != $me) { 
    var %tok = $findtok($relay.networks,$network,1,32) 
    if ($chan == $gettok($relay.channels,%tok,32)) { 
      var %lcv = 1 
      var %tot = $gettok($relay.networks,0,32) 
      while (%lcv <= %tot) { 
        var %cid = $cid 
        var %ncid = $getcidfromnet($gettok($relay.networks,%lcv,32)) 
        if (%ncid != %cid) { 
          var %net = $network 
          scid %ncid 
          msg $gettok($relay.channels,%lcv,32) $relay.fmt.part($nick,$chan,%net,$1-) 
          scid %cid 
        } 
        inc %lcv 
      } 
    } 
  } 
} 
on *:KICK:#: { 
  var %tok = $findtok($relay.networks,$network,1,32) 
  if ($chan == $gettok($relay.channels,%tok,32)) { 
    var %lcv = 1 
    var %tot = $gettok($relay.networks,0,32) 
    while (%lcv <= %tot) { 
      var %cid = $cid 
      var %ncid = $getcidfromnet($gettok($relay.networks,%lcv,32)) 
      if (%ncid != %cid) { 
        var %net = $network 
        scid %ncid 
        msg $gettok($relay.channels,%lcv,32) $relay.fmt.kick($knick,$chan,%net,$nick,$1-) 
        scid %cid 
      } 
      inc %lcv 
    } 
  } 
} 
on *:rawmode:#: { 
  var %tok = $findtok($relay.networks,$network,1,32) 
  if ($chan == $gettok($relay.channels,%tok,32)) { 
    var %lcv = 1 
    var %tot = $gettok($relay.networks,0,32) 
    while (%lcv <= %tot) { 
      var %cid = $cid 
      var %ncid = $getcidfromnet($gettok($relay.networks,%lcv,32)) 
      if (%ncid != %cid) { 
        var %net = $network 
        scid %ncid 
        msg $gettok($relay.channels,%lcv,32) $relay.fmt.mode($nick,$chan,%net,$1-)
        scid %cid 
      } 
      inc %lcv 
    } 
  } 
} 
on *:topic:#: { 
  var %tok = $findtok($relay.networks,$network,1,32) 
  if ($chan == $gettok($relay.channels,%tok,32)) { 
    var %lcv = 1 
    var %tot = $gettok($relay.networks,0,32) 
    while (%lcv <= %tot) { 
      var %cid = $cid 
      var %ncid = $getcidfromnet($gettok($relay.networks,%lcv,32)) 
      if (%ncid != %cid) { 
        var %net = $network 
        scid %ncid 
        msg $gettok($relay.channels,%lcv,32) $relay.fmt.topic($nick,$chan,%net,$1-) 
        scid %cid 
      } 
      inc %lcv 
    } 
  } 
} 
alias -l getcidfromnet { 
  var %lcv = 1 
  var %tot = $scon(0) 
  while (%lcv <= %tot) { 
    if ($scon(%lcv).network == $1) { return $scon(%lcv).cid } 
    inc %lcv 
  } 
} 
