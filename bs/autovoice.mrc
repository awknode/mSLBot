on $owner:text:.autovoice on*:#: {
  if (% [ $+ autovoice. $+ [ $chan ] ] == on) { msg $chan 12Activated auto-voice for $chan $+ .  | .halt }
  .set % [ $+ autovoice. $+ [ $chan ] ] on
  msg $chan 12Activated auto-voice for $chan $+ .
}

on $owner:text:.autovoice off*:#: {
  if (% [ $+ autovoice. $+ [ $chan ] ] == off) { msg $chan 12De-activated auto-voice for $chan $+ . | .halt }
  .set % [ $+ autovoice. $+ [ $chan ] ] off
  msg $chan 12De-activated auto-voice for $chan $+ .
}

on $owner:text:.autovoice status:#: {
  if (% [ $+ autovoice. $+ [ $chan ] ] == on) { msg $chan 12Activated auto-voice for $chan $+ . | .halt }
  if (% [ $+ autovoice. $+ [ $chan ] ] == off) { msg $chan 12De-activated auto-voice for $chan $+ . | .halt }
  if (% [ $+ autovoice. $+ [ $chan ] ] == $null) { msg $chan Auto-voice is 12Not set for $chan $+ . | .halt }
}

;on *:join:#: {
;  if ($me isop $chan) {
;    if (% [ $+ autovoice. $+ [ $chan ] ] == on) {
;      .mode $chan +v $nick
;    }
;  }
;}
