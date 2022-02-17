	

on *:TEXT:*:*:{
  if ($1 == !vhost) && ($chan == #vhost ) {
    if (*undernix* iswm $2-) { msg $chan Sorry, you may not have a vhost of this nature. Please choose another. | halt }
    if (!$2) { msg $chan Improper syntax. [Ex. !vhost my.vhost.here] | halt }
    set %whois_check_ [ $+ [ $nick ] ] 1
    whois $nick
  }
}
raw 307:*:{
  if (%whois_check_ [ $+ [ $2 ] ] == 1 ) {
    set %whois_check_ [ $+ [ $2 ] ] 2
  }
}
raw 318:*:{
  if (%whois_check_ [ $+ [ $2 ] ] == 1 ) {
    msg #vhost cannot change your host $2 you are not identified with nickserv
  }
  if (%whois_check_ [ $+ [ $2 ] ] == 2 ) {
    msg hostserv set $nick $2
    msg #vhost Your vhost has now been activated. Type "/msg hostserv ON" to activate it now.
  }
}
