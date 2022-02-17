;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; IAL-UPDATE ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;info:
;
;  by wiebe @ QuakeNet
;  version 1.0  (written and tested on mIRC 6.15)
;
;  last edit: Sun Jun 06 2004
;
;
;What does this script do?
;
;  updates the IAL by doing /who chan1,chan2,chan3 etc
;  if a channel is too big, /who nick1,nick2,nick3 etc is done untill the IAL for the channel is   updated 
;  script updates from smallest to the biggest channel
;
;
;How to use this script?
;
;  config the options below
;  /ialupdate can be used to make the script update the IAL without waiting for the timer to  trigger it
;
;
;Why is this script good?
;
;  sending /who chan for every channel is not needed and goes slow (lag)
;  sending /who chan on join may cause Excess Flood or Max sendQ exceeded
;  sending /who chan1,chan2,chan3 can be much faster, but only if there are not too many results  (Max sendQ exceeded) 
;
;
;  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; ALIAS MAX.WHO ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
alias -l max.who {
  ; maximum number of replies in a WHO, too big may cause 'Max sendQ exceeded' disconnection
  ; too low may take the script a long time to update the IAL, 500 or 400 should be fine for most situations
  !return 700
}
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; ALIAS LEN.WHO ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
alias -l len.who {
  ; maximum length of the /who <string>, too long may cause the server to ignore the command
  ; too low may slow things down, 400 should be fine in most cases
  !return 400
}
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; ALIAS DELAY.WHO ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
alias -l delay.who {
  ; N seconds after the first join, the script starts to update the IAL
  !return 120
}
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; ALIAS REPEAT.WHO ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
alias -l repeat.who {
  ; wait N seconds after doing /who to do the next check and /who
  !return 30
}
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; ALIAS SHOW ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
alias -l show.who {
  ; set this to 1 if you want the script to echo when the IAL is updated
  ; shows number of opers, number of users that are away, number of users that are deaf (+d),
  ; number of users that have fake host (+x)
  ; may slow things down, needs some checks / loops etc
  ; only shows when a whole channel is being who'd
  !return 1
}
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; JOIN EVENT ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
on *:join:#:{
  ; we join, IAL not updated, timer does not run, start a timer
  if ($nick == $me) && (!$timer($+($cid,.ial-update.update))) {
    .!timer $+ $cid $+ .ial-update.update 1 $$delay.who ial-update.update
  }
}
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; LOAD EVENT ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
on *:load:{ !scon -at1 .!timer $!+ $!cid $!+ .ial-update.update 1 $$delay.who ial-update.update }
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; ALIAS IALUPDATE ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
alias ialupdate { !echo -a IAL-update: $ial-update.update }
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; ALIAS IAL-UPDATE.UPDATE   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
alias -l ial-update.update {
  !var %c, %n
  ; IAL is set on
  if ($ial) {
    ; hash table does not exist, set a var with the channels we need to who
    if (!$hget($+(ial-update.,$cid))) { !var %c = $ial-update.chan($max.who,$len.who)
      ; something is in there, send it to the hash alias, send the who request
      if (%c) { ial-update.hash %c | .!quote WHO %c }
      ; else no channels to who, set a var with the nicks we need to who
      else { !var %n = $ial-update.nick($max.who,$len.who)
        ; something is in there, send it to the hash alias, send the who request
        if (%n) { ial-update.hash %n | .!quote WHO %n  }
      }
    }
    ; we did a who or the hash table was not empty, start a timer to run this alias again
    if (%c) || (%n) || ($hget($+(ial-update.,$cid))) {
      .!timer $+ $cid $+ .ial-update.update 1 $$repeat.who ial-update.update
    }
    ; return some info
    if (%c) || (%n) { !return updating }
    elseif ($hget($+(ial-update.,$cid))) { !return already in progress }
    else { !return nothing to update }
  }
  ; ial is off return some info
  else { !return ERROR, IAL is turned off, /IAL on to enable }
}
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; ALIAS IAL-UPDATE.SORT  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; $ial-update.sort
; sorts channels where the IAL is not updated
; <number of nicks>.<channel number>
; 127.1 <= means 127 users on channel 1
alias -l ial-update.sort {
  !var %x = 1, %c
  ; loop through all common channels that we have with ourself
  ; $chan(0) returns the number of open channel windows,
  ; which does not mean you are on it ("keep channels open" option)
  while (%x <= $comchan($me,0)) {
    ; check if the ial is not updated or busy, add it to a var
    if ($chan($comchan($me,%x)).ial == $false) { !var %c =  $addtok(%c,$+($nick($comchan($me,%x),0),.,%x),32) }
    !inc %x
  }
  ; return it sorted
  !return $sorttok(%c,32,n)
}
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; ALIAS IAL-UPDATE.MAX ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; $ial-update.max(N)
; N maximum number of nicks to request at once
; this alias returns the channels to ial based on the info provided by $ial-update.sort
; #chan1,#chan2,#chan3
alias -l ial-update.max {
  !var %x = 1, %t = 0, %c = $ial-update.sort, %w
  ; loop through the channels and as long as %t smaller then $1, increase %t
  while (%x <= $numtok(%c,32)) && (%t < $1) {
    !inc %t $gettok($gettok(%c,%x,32),1,46)
    ; if %t is greater then $1, stop the loop
    if (%t > $1) { !break }
    ; add it to a var
    !var %w = $addtok(%w,$gettok($gettok(%c,%x,32),2,46),32)
    !inc %x
  }
  !return %w
}
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; ALIAS IAL-UPDATE.CHAN ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; $ial-update.chan(N,L)
; N maximum number of nicks to request at once
; L maximum length of the WHO request
; this alias is used to WHO channels
alias -l ial-update.chan {
  !var %x = 1, %l = 0, %c = $ial-update.max($1), %w
  ; loop through the channels, as long as %l smaller then $2, increase %l for the length of the  channel
  while (%x <= $numtok(%c,32)) && (%l < $2) {
    !inc %l $len($comchan($me,$gettok(%c,%x,32)))
    ; %l greater then $2, stop the loop
    if (%l > $2) { !break }
    ; add it to the var
    !var %w = $addtok(%w,$comchan($me,$gettok(%c,%x,32)),44)
    !inc %x
  }
  !return %w
}
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; ALIAS IAL-UPDATE.NICK ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; $ial-update.nick(N,L)
; N maximum number of nicks to request at once
; L maximum length of the WHO request
; this alias is used to WHO nicks
alias -l ial-update.nick {
  !var %x = 1
  ; loop through the channels untill we found one where the IAL isnt updated
  while ($chan($comchan($me,%x)).ial != $false) && (%x <= $comchan($me,0)) {
    !inc %x
  }
  ; ial is not updated, set vars
  if ($chan($comchan($me,%x)).ial == $false) { !var %y = 1, %t = 0, %l = 0, %w
    ; loop 
    while (%t <= $1) && (%l < $2) && (%y <= $nick($comchan($me,%x),0)) {
      ; ial for that nick isnt updated, increase %l
      if (!$ial($nick($comchan($me,%x),%y))) {
        !inc %l $len($nick($comchan($me,%x),%y))
        ; if greater then $2, stop the loop
        if (%l > $2) { !break }
        ; add it to the var
        !var %w = $addtok(%w,$nick($comchan($me,%x),%y),44)
      }
      !inc %y
    }
    !return %w
  }
}
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; ALIAS IAL-UPDATE.HASH ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; /ial-update.hash <things> -remove
alias -l ial-update.hash {
  ; $2 is not there, set a var
  if ($2 == $null) { !var %x = $numtok($1,44)
    ; loop through each part seperated with a comma, add it to a hash table
    while (%x) { !hadd -m $+(ial-update.,$cid) $gettok($1,%x,44) 1 | !dec %x }
    ; add mask
    !hadd -m $+(ial-update.,$cid) -mask $1
  }
  ; $2 is -remove, set a var
  elseif ($2 == -remove) { !var %x = $numtok($1,44)
    ; loop through each part seperated with a comma, remove it from the hash table
    while (%x) { if ($hget($+(ial-update.,$cid))) { !hdel $+(ial-update.,$cid) $gettok($1,%x,44) } | !dec %x }
    ; del mask
    !hdel $+(ial-update.,$cid) -mask
    ; check hash table, free hash table
    if ($hget($+(ial-update.,$cid),0).item == 0) && ($hget($+(ial-update.,$cid))) { !hfree $+(ial-update.,$cid) }
  }
}
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; RAW 352 WHO ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; 352 <you> <channel> <user> <host> <server> <nick> <flags> :<distance> <realname>
raw 352:& & & & & & & & *: {
  ; chan or nick are in the hash table
  if ($hget($+(ial-update.,$cid),$2)) || ($hget($+(ial-update.,$cid),$6)) {
    ; check setting, set a var
    if ($show.who == 1) && ($hget($+(ial-update.,$cid),$2)) && ($comchan($6,0)) { !var %x = $comchan($6,0)
      ; loop, set a var
      while (%x) { !var %c = $comchan($6,%x)
        ; check has table
        if ($hget($+(ial-update.,$cid),%c)) {
          ; * meaning oper isin $7, increase
          if (* isin $7) { !hinc $+(ial-update.,$cid) $+(%c,$chr(44),oper) }
          ; G meaning Gone isin $7, increase
          if (G isincs $7) { !hinc $+(ial-update.,$cid) $+(%c,$chr(44),away) }
          ; d meaning deaf isin $7, increase
          if (d isincs $7) { !hinc $+(ial-update.,$cid) $+(%c,$chr(44),deaf) }
          ; x meaning fake host isin $7, increase
          if (x isincs $7) { !hinc $+(ial-update.,$cid) $+(%c,$chr(44),xhost) }
        }
        !dec %x
      }
    }
    ; stop mirc from showing this raw
    !haltdef
  }
}
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; RAW 315 WHO END ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; raw 315 <you> <requested> :End of /who list.
raw 315:& & end of /WHO list.: {
  ; check -mask in hash table
  if ($hget($+(ial-update.,$cid),-mask) == $2) {
    ; check setting, set a var
    if ($show.who == 1) { !var %x = $numtok($2,44)
      ; loop, we are on the channel, set var
      while (%x) { if ($me ison $gettok($2,%x,44)) { !var %c = $gettok($2,%x,44)
          ; oper info
          !var %oper = $iif($hget($+(ial-update.,$cid),$+(%c,$chr(44),oper)),$ifmatch,0)
          !var %oper = %oper / $round($calc(%oper / $nick(%c,0) * 100),1) $+ % Oper
          ; away info
          !var %away = $iif($hget($+(ial-update.,$cid),$+(%c,$chr(44),away)),$ifmatch,0)
          !var %away = %away / $round($calc(%away / $nick(%c,0) * 100),1) $+ % Away
          ; deaf info
          !var %deaf = $iif($hget($+(ial-update.,$cid),$+(%c,$chr(44),deaf)),$ifmatch,0)
          !var %deaf = %deaf / $round($calc(%deaf / $nick(%c,0) * 100),1) $+ % deaf
          ; xhost info
          !var %xhost = $iif($hget($+(ial-update.,$cid),$+(%c,$chr(44),xhost)),$ifmatch,0)
          !var %xhost = %xhost / $round($calc(%xhost / $nick(%c,0) * 100),1) $+ % x-host
          ; echo
          !echo -t $gettok($2,%x,44) * IAL updated ( $+ %oper ---- %away ---- %deaf ---- %xhost $+ )
        }
        ; remove from hash table
        !hdel $+(ial-update.,$cid) $+(%c,$chr(44),oper) | !hdel $+(ial-update.,$cid) $+(%c,$chr(44),away)
        !hdel $+(ial-update.,$cid) $+(%c,$chr(44),deaf) | !hdel $+(ial-update.,$cid) $+(%c,$chr(44),xhost)
        !dec %x
      }
    }
    ; remove the items from the hash table
    ial-update.hash $2 -remove
    !haltdef
  }
}
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; DISCONNECT EVENT ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
on *:disconnect:{ if ($hget($+(ial-update.,$cid))) { !hfree $+(ial-update.,$cid) } }
