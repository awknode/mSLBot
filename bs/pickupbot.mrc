	

on *:TEXT:!pickup:#tfc.invite: {
  if (%admin) {
    msg $chan A pickup has already been started.
  }
  else {
    set %admin $nick
    set %maps 2fort,2mesa3,2morforever,aardvark,alchimy,baked,bases,blis2fort,bounce,catharsis,changeofpace,chimkeyz,congestus,crossover,dalequandary,destroy,dropdown,duality,evenflow,exchange,fiddle,flare,haste,highflag,jaybases,medieval,monkey,mortality,myth,nyx,openfire,oppose,orbit,phantom,pitfall,plasma,propinquity,r123,raiden,redgiant,reloaded,roasted,schrape,schtop,security,sd2,siden,siege,sonic,startec,stowaway,trench,well,xpress,ksour,avanti,dustbowl,napoli,cornfield,anticitizen,palermo,napoli,vertigo,fusion,impact,genesis,cz2,tiger,warpath
    set %mapname unknown
    set %maxplayers 8
    set %players 0
    set %nomval 5
    msg # $nick has started a pickup! Use !add to join!
    set %playerlist ? ? ? ? ? ? ? ?
  }
}
on *:TEXT:!add:#tfc.invite: {
  if (!%admin) {
    msg $chan Pickup has not been started. Type !pickup to start one.
  }
  else {
    if ($istok(%playerlist,$nick,32)) { msg # You are already added $nick $+ ! | halt }
    set %playerlist $reptok(%playerlist,$chr(63),$nick,32)
    tokenize 32 %playerlist
    msg $chan Current player list: $chr(91) $1- $chr(93)
    inc %players
  }
}
on *:TEXT:!remove:#tfc.invite: {
  if (!%admin) {
    msg $chan Pickup has not been started. Type !pickup to start one.
  }
  else {
    if (!$istok(%playerlist,$nick,32)) { msg # You're not added. | halt }
    set %playerlist $reptok(%playerlist,$nick,$chr(63),0,32)
    tokenize 32 %playerlist
    dec %players
    msg $chan Current player list: $chr(91) $1- $chr(93)
  }
}
on *:TEXT:!players &:#tfc.invite: {
  if (!%admin) {
    msg $chan Pickup has not been started. Type !pickup to start one.
  }
  else {
    if ($nick != %admin) { msg # Error. This command can be issued only by a pickup starter, which in this case is %admin $+ . | halt }
    if ($2 !isnum 2-20) { msg # Wrong syntax! The correct one is !players <number_from_2_to_20> | halt }
    if ($2 < %players) { msg # Currently, there are %players players assigned! You cannot do that! | halt }
    set %maxplayers $2
    msg # Max players set to $2 $+ !
    set %playerlist $gettok(%playerlist,1- $+ $2,32)
    var %i 1
    while (%i <= $numtok(%playerlist,32)) {
      if ($gettok(%playerlist,%i,32) != $chr(63)) set %templist $addtok(%templist,$gettok(%playerlist,%i,32),32)
      inc %i
    }
    set %playerlist %templist
  }
}
on *:TEXT:!status:#tfc.invite: {
  if (!%admin) { msg # No pickup started! to start one, type !pickup. | halt }
  msg $chan Pickup on $+(',%mapname,') - %players $+ $chr(47) $+ %maxplayers players - Admin : %admin $chr(91) %playerlist $chr(93)
}
on *:TEXT:!notice:#tfc.invite: {
  if (!%admin) { msg # No pickup started! to start one, type !pickup. | halt }
  notice $chan Pickup on $+(',%mapname,') - %players $+ $chr(47) $+ %maxplayers players - Type !add to join
}
on *:TEXT:!map &:#tfc.invite: {
  if (!%admin) {
    msg $chan Pickup has not been started. Type !pickup to start one.
  }
  else {
    if ($nick != %admin) { msg # Error. This command can be issued only by a pickup starter, which in this case is %admin $+ . | halt }
    if (!$istok(%maps,$2,44)) { msg # Wrong syntax! The correct one is !map existing_map_name | halt }
    set %mapname $2
    msg # Map has been set to: %mapname
  }
}
on *:TEXT:!needsub:#tfc.invite: {
  if (%needsub) { .msg # Sub has already been requested. | halt }
  if (!%admin) {
    msg $chan Pickup has not been started. Type !pickup to start one.
  }
  else {
    set %needsub 1
    notice # Substitute player needed for $nick $+ .  Use !sub to fill in.
    .timersub 100 30 notice # Substitute player needed for $nick $+ .  Use !sub to fill in.  
  }
}
on *:TEXT:!sub:#tfc.invite: {
  if (%needsub) {
    unset %needsub
    msg # Sub found. Type !sendinfo if you did not receive the info.
    msg $nick <serverinfo>
    .timersub off
  }
  else {
    msg # No subs are needed at this time.
  }
}
on *:TEXT:!cancelsub:#tfc.invite: {
  if (%needsub) {
    unset %needsub
    msg # Request cancelled.
    .timersub off
  }
}
on *:TEXT:!sendinfo:#tfc.invite: {
  if (!%admin) {
    msg $chan Pickup has not been started. Type !pickup to start one.
  }
  else {
    msg $nick <serverinfo>
  }
}
on *:TEXT:!end:#tfc.invite: {
  if (!%admin) {
    msg $chan Pickup has not been started. Type !pickup to start one.
  }
  else {
    if ($nick != %admin) { notice # The pickup will end in 15 seconds if not !veto'd by %admin $+ . }
    .timerveto 1 5 msg %admin You have 10 seconds to !veto the pickup, or it will end.
    .timerveto2 1 10 msg %admin You have 5 seconds to !veto the pickup, or it will end.
    .timerend 1 15 unsetall
    .timerendmsg 1 16 msg # %admin failed.
  }
  else {
    msg # The pickup has been cancelled by %admin $+ .
    unsetall
  }
}
on *:TEXT:!veto:#tfc.invite: {
  if (!%admin) { msg $chan Pickup has not been started. Type !pickup to start one. | halt }
  else {
    if ($nick != %admin) { msg $nick Only %admin can !veto the pickup $+ . | halt }
    msg # The pickup will no longer end.
    .timerend off
    .timerendmsg off
    .timerveto2 off
    .timerveto off
  }
}

; !hold - Puts the game on hold. This means that if the pickup fills up, it won't start until it is taken off of hold.
on *:TEXT:!hold:#tfc.invite: {
  if (!%admin) { msg $chan Pickup has not been started. Type !pickup to start one. | halt }
  else {
    if ($nick != %admin) { msg $nick Only %admin can !hold the pickup $+ . | halt }
    else {
      msg # The pickup has been put on hold.
      set %hold 1
    }
  }
}  
on *:TEXT:!unhold:#tfc.invite: {
  if (!%admin) { msg $chan Pickup has not been started. Type !pickup to start one. | halt }
  else {
    if ($nick != %admin) { msg $nick Only %admin can !unhold the pickup $+ . | halt }
    else {
      set %hold = 0
    }
    else {
      if (%players != %maxplayers)
      msg # Pickup taken off hold.  Voting will begin when full.
    }
    else {
      msg # Vote for a map. You have 60 seconds. 1. $+ %nom1 2. $+ %nom2 3. $+ %nom3 4. $+ %nom4
      timervote1 1 30 msg # 30 seconds remaining
      timervote2 1 60 msg # <vote results>
    }
  }
}    
on *:TEXT:!nominate &:#tfc.invite: {
  if (!%admin) { msg $chan Pickup has not been started. Type !pickup to start one. | halt }
  if ($nick isin %nominated) msg # stop bitch, you voted already
  if (!$istok(%playerlist,$nick,32)) { msg $chan Only people who want to play a pickup can !nominate a map. | halt }
  if (!$istok(%maps,$2,44)) { msg $chan Please nominate from the !mapslist $+ . | halt }
  if (%mapname != unknown) { msg $chan The map has already been chosen by the admin. | halt }
  if ($2 == %nom1) || ($2 == %nom2) || ($2 == %nom3) || ($2 == %nom4) { msg $chan That map is already nominated. | halt }
  if (%nomval > 4) { msg $nick Nominations have already been picked. | halt }
  set %nom [ $+ [ %nomval ] ] $2
  inc %nomval
  msg $chan $nick has nominated $2 in position %nomval of 4.
  set %nominated %nominated $nick
}
