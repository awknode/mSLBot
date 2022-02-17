on $owner:text:!av on*:#: {
  if (% [ $+ autovoice. $+ [ $chan ] ] == on) { msg $chan Auto-voice is currently activated in $chan $+.  | .halt }
  .set % [ $+ autovoice. $+ [ $chan ] ] on
  msg $chan Auto-voice is now activated for $chan $+ .
}

on $owner:text:!av off*:#: {
  if (% [ $+ autovoice. $+ [ $chan ] ] == off) { msg $chan Auto-voice is currently de-activated in $chan $+ . | .halt }
  .set % [ $+ autovoice. $+ [ $chan ] ] off
  msg $chan Auto-voice is now de-activated for $chan $+ .
}

on $owner:text:!av status:#: {
  if (% [ $+ autovoice. $+ [ $chan ] ] == on) { msg $chan Auto-voice is currently activated in $chan $+ . | .halt }
  if (% [ $+ autovoice. $+ [ $chan ] ] == off) { msg $chan Auto-voice is currently de-activated in $chan $+ . | .halt }
  if (% [ $+ autovoice. $+ [ $chan ] ] == $null) { msg $chan Auto-voice is not set for $chan $+ . | .halt }
}

on *:join:#: {
  if ($me isop $chan) {
    if (% [ $+ autovoice. $+ [ $chan ] ] == on) {
      .mode $chan +v $nick
    }
  }
}
