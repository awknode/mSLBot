on *:text:*:#:{ 
  if (%kablock. [ $+ [ $nick ] ] == yes) { halt }
  else {
    if ($2 == $nick) { msg # can't give yourself h, faggot. | halt }
    if ($1 == +h) {
      spamprotect
      exprotect $1-
      inc %karma. [ $+ [ $2 ] ] 
    msg $chan (h) $2 $+ 's h is increased to %karma. [ $+ [ $2 ] ] $+ . }
  }

  if ($1 == -h) {
    spamprotect
    exprotect $1-
    dec %karma. [ $+ [ $2 ] ] 
  msg $chan (h) $2 $+ 's h has been decreased to %karma. [ $+ [ $2 ] ] $+ . }
}

;on *:text:.h:#:{
;  msg $chan [h] $nick You're h is 
;}
