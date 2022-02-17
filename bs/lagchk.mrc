on *:text:!lagchk:*: {
  ctcp $nick ping
  set %room $chan
}
on *:ctcpreply:ping*: {
  if ( $nick != $me ) {
    %ping = $calc($ctime - $2)
    msg %room [ $nick ] Your lag time on $network is $duration($calc(%ping))
  }
  unset %ping
  unset %room
}
