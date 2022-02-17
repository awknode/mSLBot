on *:text:!lagchk:*: {
  ctcp $nick ping
  set %room $chan
}
on *:ctcpreply:ping*: {
  if ( $nick != $me ) {
    %ping = $ctime - $2
    msg %room [ $nick ] Your lag time on $server is $duration($calc(%ping))
  }
  unset %ping
  unset %room
}
