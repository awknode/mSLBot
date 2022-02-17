alias GetIdent {
  var %nick-ident = $remove($gettok($address($1,3),1,$asc(@)),*!*)
  return %nick-ident
}
alias BadIdentCheck {
  if ($1- == queermodo*) {
    return $true
  }
  elseif ($1 == mibbit) {
    return $true
  }
  else {
    return $false
  }
}
ON *:JOIN:#: {
  if ($nick != $me) && ($me isop $chan) {
    if ($BadIdentCheck($GetIdent($nick)) == $true) {
      whois $nick
      msg # $nick $+ , that harry potter mixtape was a bad idea faggot. 
      mode # +b $+(*!,$GetIdent($nick),@*)
    }
  }
}

on *:RAWMODE:#: { if ($1- == user) { whois $nick | msg # fag } }

RAW 311:*: { 
  if ($3- == user) { 
    var $chan = %chan, $nick = %nick, $3- = %3-
    whois %nick | halt
    msg %chan %nick is listening to Harry Potter mixtape atm. | halt
  }
  unset %chan %nick
}
