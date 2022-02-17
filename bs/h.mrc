on *:text:*:#:{ 
  if (%kablock. [ $+ [ $nick ] ] == yes) { halt }
  else {
    if ($1 == +h) {
      if (%flood. [ $+ [ $chan ] ] == on) {
        inc -u600 %flood. [ $+ [ $nick ] ] 1
        if (%flood. [ $+ [ $nick ] ] >= 2) && ($nick != int) {
          ;  /ignore $address($nick,0)
          notice $nick $nick There is such a thing as too much h, bitch. 
          halt
          ; .timer 1 600 /ignore -r $address($nick,0)
        }
      }
      set %flood. [ $+ [ $chan ] ] on
      if ($2 == $nick) { msg # can't give h for yourself, faggot. You wouldn't give yourself a nickname would you? Fkn squid. | halt }
      if (!$2) { msg # have to h someone tard, try adding a nick. | halt }
      spamprotect
      exprotect $1-
      inc %karma. [ $+ [ $2 ] ] 
    msg $chan (h) $2 $+ 's h is increased to %karma. [ $+ [ $2 ] ] $+ . }
  }
  if ($1 == -h) {
    if (%flood. [ $+ [ $chan ] ] == on) {
      inc -u600 %flood. [ $+ [ $nick ] ] 1
      if (%flood. [ $+ [ $nick ] ] >= 2) && ($nick != int) {
        ;   /ignore $address($nick,0)
        notice $nick $nick There is such a thing as too much h, bitch. 
        ;   .timer 1 600 /ignore -r $address($nick,0)
      }
    }
    set %flood. [ $+ [ $chan ] ] on
    spamprotect
    exprotect $1-
    if ($2 == $nick) { msg # can't take h for yourself, faggot. You wouldn't give yourself a nickname would you? Fkn squid. | halt }
    if (!$2) { msg # have to h someone tard, try adding a nick. | halt }
    dec %karma. [ $+ [ $2 ] ] 
  msg $chan (h) $2 $+ 's h has been decreased to %karma. [ $+ [ $2 ] ] $+ . }
  if ($1 == .h) {
    set %flood. [ $+ [ $chan ] ] on
    spamprotect 
    exprotect $1-
    if (!$2) { msg $chan (h) $nick $+ 's h is 12@ %karma. [ $+ [ $nick ] ] $+ . | halt }
    if (%karma. [ $+ [ $2 ] ] == $null) { msg $chan (h) $2 doesn't have any h, that's why nobody likes you faggot. | halt }
    else { msg $chan (h) $2 $+ 's h is 12@ %karma. [ $+ [ $2 ] ] $+ . | halt }
    unset %karma.by %karma.is %karma.h %karma.not %karma.ok %karma.test %flood. [ $+ [ $chan ] ]
  }
}

;on *:text:.h:#:{
;  msg $chan (h) $nick You're h is 12@ $+(%karma.,$nick)
;}
