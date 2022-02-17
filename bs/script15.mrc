
menu channel,menubar,nicklist {
  Nick/Address Tracking
  .$iif($group(#Addtrack) == on,$style(1)) Show used nicks on join (*@host): {
    var %status = $iif($group(#Addtrack) == on,Disable,Enable)
    $+(.,%status) #Addtrack
    echo 7 -at * Users previous nicks will $iif(%status == Disable,no longer,now) be shown when they join.
  }
  .-
  .$iif($1,Check nicks for $1):CheckNicks $1
  .Check nicks for an address: {
    CheckNicks $+(*!,$$?="Enter the hostmask you want to check in the format NICK!IDENT@HOST*")
  }
}

on *:start: {
  hmake addtrack 100
  if ($isfile(addtrack.hsh)) hload addtrack addtrack.hsh
}

on *:exit: {
  if ($hget(addtrack)) hsave -o addtrack addtrack.hsh
}

#Addtrack on
on *:join:#: {
  if ($wildsite iswm $address($me,5)) return
  var %mask = $mask($fulladdress,2)
  if ($hget(addtrack,%mask)) {
    var %usednicks = $ifmatch
    if (%usednicks != $nick) && ($group(#Addtrack) == on) msg #main $nick has also used the nick[s] on this IP: $+ $remtok(%usednicks,$nick,1,44)
    if (!$istok(%usednicks,$nick,44)) hadd -m addtrack %mask $addtok(%usednicks,$nick,44)
    if ($numtok(%usednicks,44) > 10) hadd -m addtrack %mask $deltok(%usednicks,1,44)
  }
  else {
    hadd -m addtrack %mask $nick
  }
}

on *:nick: {
  if ($wildsite iswm $address($me,5)) return
  var %mask = $mask($fulladdress,2)
  if ($hget(addtrack,%mask)) {
    var %usednicks = $ifmatch
    if (!$istok(%usednicks,$newnick,44)) hadd -m addtrack %mask $addtok(%usednicks,$newnick,44)
    if ($numtok(%usednicks,44) > 10) hadd -m addtrack %mask $deltok(%usednicks,1,44)
  }
  else {
    hadd -m addtrack %mask $newnick
  }
}
#Addtrack end

alias CheckNicks {
  if (*!*@* iswm $1) {
    var %mask = $mask($1,2)
    if (!$hget(addtrack,%mask)) echo 4 -ta [Nick Tracking (*@host)] No entry found for $1
    else echo 10 -ta Address $1 has used the nick[s]: 7 $+ $hget(addtrack,$1)
  }
  elseif (!$hget(addtrack,$address($1,2))) echo 4 -ta [Nick Tracking (*@host)] No entry found for $1
  elseif ($hget(addtrack,$address($1,2)) != $1) {
    var %usednicks = $ifmatch
    echo 10 -ta [Nick Tracking (*@host)] $1 has also used the nick[s]: 7 $+ $remtok(%usednicks,$1,1,43) | @Nicks [Nick Tracking (*@host)] $1- has also used the nick[s]: 7 $+ $remtok(%usednicks,$1,1,43) | halt
  }
  else echo 10 -ta [Nick Tracking (*@host)] $1 has not been seen using any other nicks. | @Nicks [Nick Tracking (*@host)] $1- has not been seen using any other nicks. | halt
