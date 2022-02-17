;On *:JOIN:#fightclub: {
;  if ($array(luv,$nick) != $false) && ($array(luv,$nick) >= -1) { 
;    msg $chan $+([,$nick,]) has joined with the dope rating of $+([12,$array(luv,$nick),]) What a fucking loser, I wouldn't touch this bint if me life depended on it. | halt
;  }
;  if ($array(luv,$nick) != $false) { 
;    msg $chan $+([,$nick,]) has joined with the dope rating of $+([12,$array(luv,$nick),])
;  } 
;  else { msg $chan Nobody cares about you $nick $+ , in fact everyone in here thinks u gay. Try getting some +dope $xr2(fuccboi) haha what a faggot.. }
;}

On $*:TEXT:+dope *:#: {
  spamprotect
  exprotect $1-
  if (!%yluv && !$($+(%, yluv., $nick), 2)) {
    set -u3 %yluv On
    set -u420 %yluv. $+ $nick On
    var %luv = $calc($array(luv, $2) +1)
    if ($2 == $me) { msg $chan Why would you do dope with a bot? $xr2(loser) $+ . | halt }
    if ($2 == $nick) { msg $chan You shouldn't do dope by yourself, its a violation of ToS capital $xr2(Faggot) $+ . | halt }
    if (!$2) { msg $chan 12No second input. Try +dope [nick] | halt }
    if ($nick ison $chan ) { 
      spamprotect 
      exprotect $1- 
      $array(luv, $2, %luv).set 
      msg $chan 9 $+ $nick has increased $+($xr2($2),'s) 09dope rating to: 80_68\56!44/32_ $+(9[,12) $+ $iif($array(luv, $2) == $false,0,%luv) $+ $+(,9],.) 32_44\56!68/80_ Give dope back with 09+dope 
      halt
    }
    else { msg $chan I don't see that user in the channel. }
  }
  else { msg $chan You can only show 04-dope/06+dope every 09420 seconds. }
}

On $*:TEXT:-dope *:#: {  
  spamprotect
  exprotect $1-
  if (!%nluv && !$($+(%, nluv., $nick), 2)) {
    set -u3 %nluv On
    set -u420 %nluv. $+ $nick On
    var %noluv = $calc($array(luv, $2) -1)
    if ($2 == $me) { msg $chan You're going to jail and you're going to die of cancer soon. $xr2(Bitch) $+ . | halt }
    if ($2 == $nick) { msg $chan Go walk into incoming traffic $xr2(nigger) $+ . | halt }
    if ($2 == $null) { msg $chan 12No second input. Try +dope [nick] | halt }
    if ($nick ison $chan ) { 
      spamprotect 
      exprotect $1- 
      $array(luv, $2, %noluv).set 
      msg $chan 9 $+ $nick has decreased $+($xr2($2),'s) 09dope rating to: 5🔥 $+(9[,12) $+ $iif($array(luv, $2) == $false,0,%noluv) $+ $+(,9],.) 5🔥 Show them how much of a 04faggot they are with 04-dope, but in all honestly you're probably just a bint. 
      halt
    }
    else { msg $chan I don't see that user in the channel. }
  }
  else { msg $chan You can only show 04-dope/06+dope every 09420 seconds. }
}

On $*:TEXT:!dope *:#: {  
  spamprotect
  exprotect $1-
  if (!%chkluv && !$($+(%, chkluv., $nick), 2)) {
    set -u3 %chkluv On
    set -u10 %chkluv. $+ $nick On
    if ($2 == $null) { msg $chan 12No second input. Try !dope [nick] | halt }
    if ($array(luv,$2) != $false) { 
      msg $chan $+([,$2,]) has the 09dope rating: 80_68\56!44/32_14 $+(9[12,$iif($array(luv, $2) == $false,0,$array(luv, $2)),9]) 32_44\56!68/80_
      halt 
    }
    else { msg $chan [ $+ $2 $+ ] is not in my 09dope db. | halt }
  }
  else { msg $chan Slow down, you can only check stats every 10 seconds. }
} ;;written by rebel 2018
