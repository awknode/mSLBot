on *:start:{
  hmake uno 50
  if ($isfile(uno.dat)) hload uno uno.dat
}
on *:exit: hsave uno uno.dat
on *:nick:{
  var %i = $hget(0), %c
  while (%i) {
    if ($newnick ison $hget(%i)) {
      %c = $v2
      break
    }
    dec %i
  }
  if ($hget(%c,$nick)) {
    hadd %c $newnick $v1
    hadd %c $hfind(%c,$nick).data $newnick
  }
}
on *:quit:{
  var %i = $hget(0), %c
  while (%i) {
    if ($me ison $hget(%i)) && ($hget($hget(%i),$nick)) remplayer %c $nick $nick has been removed from the current game.
    dec %i
  }
}
on *:part:#:{
  if (!$hget(#)) return
  if ($hget(#,$nick)) remplayer # $nick $nick was removed from the current game.
  elseif ($nick == $me) hfree #
}
on *:kick:#:{
  if (!$hget(#)) return
  if ($hget(#,$nick)) remplayer # $nick $nick was removed from the current game.
  elseif ($nick == $me) hfree #
}
on $*:text:/^[@!.](uno)?score/Si:#:{
  var %u = $iif($2,$2,$nick)
  $iif($left($1,1) == @,msg #,notice $nick) %u has $bytes($iif($hget(uno,%u),$v1,0),b) wins.
}
on $*:text:/^[@!.](uno)?top10$/Si:#:{
  var %x, %i = $hget(uno,0).item, %o
  while (%i) {
    %x = $instok(%x,$hget(uno,$hget(uno,%i).item),0,32)
    dec %i
  }
  %x = $sorttok(%x,32,nr)
  %i = 1
  while (%i <= 10) {
    if (!$hget(uno,%i).item) break
    %o = $addtok(%o,$ord(%i) $+ : $hfind(uno,$gettok(%x,%i,32),$calc($findtok(%o,$gettok(%x,%i,32),0,32) +1)).data - $bytes($gettok(%x,%i,32),b) |,32)
    inc %i
  }
  $iif($left($1,1) == @,msg #,notice $nick) $left(%o,-1)
}
on $*:text:/^[@!.]uno$/Si:#:{
  if ($hget(#,players)) notice $nick There is already an uno game in progress in # $+ .
  else {
    if ($hget(#)) hfree #
    hmake #
    hadd # p1 $nick
    hadd # $nick $cards(7)
    hinc # players
    msg # $nick has started 3U04N12O v2.0 by BrAndo. Type !join to join the game.
    notice $nick Type !deal to start the game.
  }
}
on $*:text:/^[@!.]?join$/Si:#:{
  if (!$hget(#,p1)) return
  elseif ($hget(#,$nick)) notice $nick You are already playing!
  else {
    hinc # players
    hadd # p $+ $hget(#,players) $nick
    hadd # $nick $cards(7)
    msg # $nick will be player $hget(#,players) $+ .
  }
}
on $*:text:/^[@!.](deal|start( ?game)?|play|begin)$/Si:#:{
  if (!$hget(#,p1)) return
  elseif (!$hget(#,$nick)) notice $nick You aren't in this game.
  elseif ($hget(#,turn)) notice $nick The game has already started.
  elseif ($nick != $hget(#,p1)) msg # Only $v2 can start the game.
  elseif ($hget(#,players) !> 1) msg # You need atleast two people to play.
  else {
    var %c = 01
    while (01* iswm %c) %c = $cards(1)
    hadd # top %c
    hadd # turn 1
    hadd # rev $true
    msg # $hget(#,p1) $+ 's turn.
    msg # Top card: $hget(#,top)
    notice $nick Your cards: $hget(#,$nick)
  }
}
on $*:text:/^[@!.](endgame|uno(stop|end))$/Si:#:{
  if (!$hget(#,p1)) return
  elseif ($nick != $hget(#,p1)) msg # Only $v2 can end the game.
  else {
    hfree #
    msg # Game ended by $nick $+ .
  }
}
on $*:text:/^[@!.]quit$/Si:#:{
  if (!$hget(#,p1)) return
  elseif (!$hget(#,$nick)) notice $nick You aren't in this game.
  else remplayer # $nick $nick has left the game.
}
on $*:text:/^[@!.]kickplayer (.+)$/Si:#:{
  if (!$hget(#,p1)) return
  elseif ($nick != $hget(#,p1)) msg # Only $v1 can kick people from the game.
  elseif (!$hget(#,$regml(1))) msg # $regml(1) is not in this game.
  else remplayer # $regml(1) $regml(1) has been kicked from the game by $nick $+ .
}
on $*:text:/^[@!.](show)?(hand|cards?)$/Si:#:{
  if (!$hget(#,p1)) return
  elseif (!$hget(#,$nick)) notice $nick You aren't in this game.
  else notice $nick Your cards: $hget(#,$nick)
}
on $*:text:/^[@!.](uno)?count$/Si:#:{
  if (!$hget(#,p1)) return
  else {
    $iif($left($1,1) == @,msg #,notice $nick) Current score: $regsubex($str(.,$hget(#,players)),/./g,$+($hget(#,p\n),:,$chr(32),$numtok($hget(#,$hget(#,p\n)),32),$chr(32))) 
    $iif($left($1,1) == @,msg #,notice $nick) Its $hget(#,p $+ $hget(#,turn)) $+ 's turn.
  }
}
on $*:text:/^[@!.]topcard$/Si:#:{
  if (!$hget(#,p1)) return
  msg # Top card: $hget(#,top)
}
on $*:text:/^[@!.]draw ?(card)?$/Si:#:{
  if (!$hget(#,p1)) return
  elseif (!$hget(#,$nick)) notice $nick You aren't in this game.
  elseif ($hget(#,p $+ $hget(#,turn)) != $nick) notice $nick It is not your turn.
  elseif ($hget(#,pass) = $nick) notice $nick You have already drew! Play or !pass
  else {
    var %c = $cards(1)
    hadd # $nick $instok($hget(#,$nick),%c,0,32)
    notice $nick You drew: %c
    hadd # pass $nick
  }
}
on $*:text:/^[@!.]pass$/Si:#:{
  if (!$hget(#,p1)) return
  elseif (!$hget(#,$nick)) notice $nick You aren't in this game.
  elseif ($hget(#,p $+ $hget(#,turn)) != $nick) notice $nick It is not your turn.
  elseif ($hget(#,pass) != $nick) notice $nick You have to draw once first.
  else {
    nextturn
    var %nnick = $hget(#,p $+ $hget(#,turn))
    msg # %nnick $+ 's turn
    msg # Top card: $hget(#,top)
    notice %nnick Your cards: $hget(#,%nnick)
    hdel # pass
  }
}
on $*:text:/^[@!.]play/Si:#:{
  if (!$hget(#,p1)) return
  elseif (!$hget(#,$nick)) notice $nick You aren't in this game.
  elseif ($hget(#,p $+ $hget(#,turn)) != $nick) notice $nick It is not your turn.
  elseif (!$iscard($2-)) notice $nick Syntax: !play <color> <card> or !play WD4/W <color>
  elseif (!$hascard($2-,$nick)) notice $nick You don't have that card.
  else {
    noop $regex($iscard($2-),/^\x03(\d{2})(\[.+?\])$/)
    var %co = $regml(1), %c = $regml(2)
    if (%co isin $hget(#,top)) || (%c == $strip($hget(#,top))) || (%c == [*]) {
      delcard $nick $2-
      hadd # top $iscard($2-)
      if (%c == [D2]) {
        nextturn
        var %snick = $hget(#,p $+ $hget(#,turn)), %nnick, %msg
        hadd # %snick $instok($hget(#,%snick),$cards(2),0,32)
        nextturn
        %nnick = $hget(#,p $+ $hget(#,turn))
        %msg = %snick draws 2 cards and is skipped! %nnick $+ 's turn.        
      }
      elseif (%c == [S]) {
        nextturn
        var %snick = $hget(#,p $+ $hget(#,turn)), %nnick, %msg
        nextturn
        %nnick = $hget(#,p $+ $hget(#,turn))
        %msg = %snick is skipped, %nnick $+ 's turn.
      }
      elseif (%c == [R]) {
        hadd # rev $iif($hget(#,rev),$false,$true)
        nextturn
        var %nnick = $hget(#,p $+ $hget(#,turn)), %msg = $nick reversed it $+ $chr(44) %nnick $+ 's turn.
      }
      elseif (%c == [*]) && (4 isin $2-) {
        nextturn
        var %snick = $hget(#,p $+ $hget(#,turn)), %nnick, %msg
        hadd # %snick $instok($hget(#,%snick),$cards(4),0,32)
        nextturn
        %nnick = $hget(#,p $+ $hget(#,turn))
        %msg = %snick draws 4 and is skipped! %nnick $+ 's turn.
      }
      elseif (%c == [*]) {
        nextturn
        var %nnick = $hget(#,p $+ $hget(#,turn)), %msg = %nnick $+ 's turn.
      }
      else {
        nextturn
        var %nnick = $hget(#,p $+ $hget(#,turn)), %msg = %nnick $+ 's turn.
      }
      if ($numtok($hget(#,$nick),32) == 1) msg # $nick has 3U04N12O!
      elseif (!$v1) {
        msg # Congratulations $nick you win!!!
        hfree #
        hinc uno $nick
        return
      }
      msg # %msg
      msg # Top card: $hget(#,top)
      notice %nnick Your cards: $hget(#,%nnick)
      hdel # pass
    }
    else notice $nick That card doesn't play.
  }
}
alias cards {
  var %c = 12blue[1] 12blue[2] 12blue[3] 12blue[4] 12blue[5] 12blue[6] 12blue[7] 12blue[8] 12blue[9] 09green[1] 09green[2] 09green[3] 09green[4] 09green[5] 09green[6] 09green[7] 09green[8] 09green[9] $&
    08yellow[1] 08yellow[2] 08yellow[3] 08yellow[4] 08yellow[5] 08yellow[6] 08yellow[7] 08yellow[8] 08yellow[9] 04red[1] 04red[2] 04red[3] 04red[4] 04red[5] 04red[6] 04red[7] 04red[8] 04red[9] 01black[WD4] $&
    01black[WD4] 01black[WD4] 01black[WD4] 12blue[D2] 12blue[D2] 09green[D2] 09green[D2] 08yellow[D2] 08yellow[D2] 04red[D2] 04red[D2] 12blue[S] 12blue[S] 09yellow[S] 09yellow[S] 08yellow[S] 08yellow[S] $&
    04red[S] 04red[S] 12blue[R] 12blue[R] 09green[R] 09green[R] 08yellow[R] 08yellow[R] 04red[R] 04red[R] 01black[W] 01black[W] 01black[W] 01black[W]
  var %i = $1, %o
  while (%i) { 
    %o = $instok(%o,$gettok(%c,$r(1,68),32),0,32)
    dec %i
  }
  return %o
}
alias iscard {
  if ($regex($1,/^([bgyr])\w* (\d)$/i)) return $+($col($regml(1)),[,$regml(2),])
  elseif ($regex($1,/^w(?:ild)? ?d?(?:raw)? ?4? ([bgyr])/i)) return $col($regml(1)) $+ [*]
  elseif ($regex($1,/^([bgyr])\w* d(?:raw)?2$/i)) return $col($regml(1)) $+ [D2]
  elseif ($regex($1,/^([bgyr])\w* ([sr])\w*$/i)) return $+($col($regml(1)),[,$upper($regml(2)),])
}
alias col {
  if ($1 == b) return 12
  elseif ($1 == g) return 09
  elseif ($1 == y) return 08
  else return 04
}
alias nextturn {
  var %c = $iif(#,#,$1)
  $iif($hget(%c,rev),hinc,hdec) %c turn
  if (!$hget(%c,p $+ $hget(%c,turn))) hadd %c turn $iif($hget(%c,rev),1,$hget(%c,players))
}
alias hascard {
  var %c = $iscard($1)
  if ($strip(%c) == [*]) {
    if (4 isin $1) return $istok($hget(#,$2),01[wd4],32)
    else return $istok($hget(#,$2),01[W],32)
  }
  else return $istok($hget(#,$2),%c,32)
}
alias delcard {
  var %c = $iscard($2-), %o
  if ($strip(%c) == [*]) %o = $iif(4 isin $2-,01[wd4],01[W])
  else %o = %c
  hadd # $1 $remtok($hget(#,$1),%o,1,32)
}
alias remplayer {
  var %p = $hfind($1,$2).data, %i = $right(%p,-1)
  hdel $1 $2
  hdel $1 %p
  hdec $1 players
  msg $1 $3-
  if ($hget($1,players) == 1) { 
    msg $1 Game ended, you need atleast two people to uno.
    hfree $1
  }
  else {
    if (!$hget($1,p $+ $hget($1,turn))) {
      if (!$hget($1,top)) return
      nextturn $1
      var %nnick = $hget($1,p $+ $hget($1,turn))
      msg $1 %nnick $+ 's turn.
      msg $1 Top card: $hget($1,top)
      notice %nnick Your cards: $hget($1,%nnick)
    }
    while (%i <= $hget($1,players)) {
      hadd $1 p $+ %i $hget($1,p $+ $calc(%i +1))
      hdel $1 p $+ $calc(%i +1)
      inc %i
    }
  }
}
