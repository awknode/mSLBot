On $owner:TEXT:.ssl *:#: {
  if ($botmaster($network,$nick)) {
    spamprotect
    exprotect $1-
    if (!$2) { msg # Try turning it on or off dipshit. | halt }
    if ($2 == on) { cs SET # MLOCK +z | msg # SSL is now enabled for $chan $+ . | halt }
    if ($2 == off) { /cs set # MLOCK -z | msg # SSL is now disabled for $chan $+ . | halt }
    else { msg # Access denied. }
  }
}

On *:PART:#SSL: {  
  whois $nick 
}

on *:text:?ssltest*:#:{
  writeini settings.ini settings lastchan $chan
  if ($2 == $NULL) {
    whois $nick
  }
  else {
    whois $2
  }
}
on *:connect:{
  localinfo -h
}

on *:text:*connected*:#services: {
  if (*connected*to*the*network* iswm $1- ) {
    writeini settings.ini settings lastchan $chan
    whois $gettok($2, 1, 33)
    ctcp $gettok($2, 1, 33) version 
  }
}

On *:CTCPREPLY:VERSION*: { if ($network == sudo ) { msg #services $+(,$nick,) 8 $+ $1 -> $2- | msg #priv8 $+(,$nick,) 8 $+ $1 -> $2- } }

on *:join:#ssl: {
  writeini settings.ini settings lastchan $chan
  whois $nick
}
on *:text:!sslhelp*:#: {
  msg $chan on mIRC /server irc.jmprax.com +6697 - if this doesnt work try //echo -a $chr(36) $+ sslready if you have the required downloads.
  msg $chan on IRSSI: /connect -ssl irc.jmprax.com 6697
  msg $chan if you use a bouncer make sure the connecting client -> bnc AND bnc -> server both use ssl
}

raw *:*: {
  if ($numeric == 311) {
    .timercheck_ [ $+ [ $2 ] ] 1 2 msg $readini(settings.ini,settings,lastchan) $2 is not using ssl - !sslhelp
    .timercheck2_ [ $+ [ $2 ] ] 1 5 sajoin $2 #SSL 
    halt 
  }
  ;  pushmode -n #main -q $2
  ;  pushmode -n #main -a $2
  ;  pushmode -n #main -o $2
  ;  pushmode -n #main -h $2
  ;  pushmode -n #main -v $2
  ;
  if ($numeric == 312) && ($3- == ddos.coming HardChats) { 
    .timercheck2_ [ $+ [ $2 ] ] off 
  }
  if ($numeric == 671) {
    .timercheck_ [ $+ [ $2 ] ] off
    .timercheck2_ [ $+ [ $2 ] ] off
  }
} 
