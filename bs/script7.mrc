alias -l NBA.team.colors return 0
alias -l NBA.scorealert.enable return 1
;
;######################################################
;
;
alias -l set.correct.network {
  if ($1) {
    var %loop 0
    while ($scon(0) > %loop) {
      inc %loop
      if ($scon(%loop).network == $1) {
        scon %loop
        break
      }
    }
  }
}
on 1:PART:#:{
  if ($hget(NBA.get.scores.NBA.alert,$+($nick,.,$network,.,$chan))) {
    hdel NBA.get.scores.NBA.alert $+($nick,.,$network,.,$chan)
    msg $nick Your NBA ScoreAlert has been deleted for parting.
  }
}
on 1:JOIN:#:if ($timer(NBA.get.scores.NBA.remove.alert. $+ $+($nick,.,$network,.,$chan))) .timerNBA.get.scores.NBA.remove.alert. $+ $+($nick,.,$network,.,$chan) off
on 1:KICK:#:if ($hget(NBA.get.scores.NBA.alert,$+($nick,.,$network,.,$chan))) .timerNBA.get.scores.NBA.remove.alert. $+ $+($nick,.,$network,.,$chan) 1 120 hdel NBA.get.scores.NBA.alert $+($nick,.,$network,.,$chan)
on 1:QUIT:if ($hget(NBA.get.scores.NBA.alert)) hdel -w NBA.get.scores.NBA.alert $nick $+ .*
on 1:NICK:{
  if ($hget(NBA.get.scores.NBA.alert,$+($nick,.,$network,.,$chan))) {
    hadd NBA.get.scores.NBA.alert $newnick $+ . $+ $chan $hget(NBA.get.scores.NBA.alert,$+($nick,.,$network,.,$chan))
    hdel NBA.get.scores.NBA.alert $+($nick,.,$network,.,$chan)
  }
}
on 1:TEXT:?scorealert*:#:{
  if (!$NBA.scorealert.enable) return
  if ($2 != NBA) {
    .timerscorealertNBA 1 2 .notice $nick For NBA scorealerts, Type !scorealert NBA <team>
    halt
  }  
  if ($3 == off) {
    if ($hget(NBA.get.scores.NBA.alert $+($nick,.,$network,.,$chan))) hdel NBA.get.scores.NBA.alert $+($nick,.,$network,.,$chan)
    .notice $nick Deleted your ScoreAlert.
    return
  }
  if ($4 == off) {
    if ($hget(NBA.get.scores.NBA.alert,$+($nick,.,$network,.,$chan))) || ($nick isop $chan) {
      if ($team.lookup($3)) {
        if ($hget(NBA.get.scores.NBA.alert,$+($nick,.,$network,.,$chan))) {
          hdel NBA.get.scores.NBA.alert $+($nick,.,$network,.,$chan)
          .notice $nick Deleted your ScoreAlert for $3
          return
        }
        if ($nick isop $chan) {
          var %a = 0
          while (%a < $hfind(NBA.get.scores.NBA.alert,* $+ $team.lookup($3) $+ *,0,w).data) {
            inc %a
            if ($gettok($hfind(NBA.get.scores.NBA.alert,* $+ $team.lookup($3) $+ *,%a,w).data,2,46) == $chan) {
              hdel NBA.get.scores.NBA.alert $hfind(NBA.get.scores.NBA.alert,* $+ $team.lookup($3) $+ *,%a,w).data
              .notice $nick Deleted ScoreAlert for $3
              return
            }
          }
        }
      }
      else .notice $nick Invalid team name.
    }
    return
  }
  else {
    if (%NBA.get.scores.NBA.ON) || ($hget(NBA.get.scores)) {
      .timerNBA. $+ $nick 1 3 .notice $nick Please try again in 1 minute.
      if (!$timer(NBA.get.scores.NBA.Timeout)) .timerNBA.get.scores.NBA.Timeout 1 15 NBA.get.scores.NBA.Timeout 1
      halt
    }
    if ($3) {
      if ($team.lookup($3)) {
        if ($hget(NBA.get.scores.NBA.alert,$+($nick,.,$network,.,$chan))) .notice $nick Your current scorealert $paren($gettok($v1,1,187)) will be overwritten.
        set %NBA.get.scores.NBA.TEMP.info scorealert
        set %NBA.get.scores.NBA.TEMP.search $team.lookup($3)
        set %NBA.get.scores.NBA.TEMP.chan $chan
        set %NBA.get.scores.NBA.TEMP.nick $nick

        NBA.get.scores
      }
      else .notice $nick Invalid team name.
    }
    else .notice $nick Please specify a team.
  }
}
on 1:TEXT:?NBA*:#:{
  set %NBA.get.scores.NBA.TEMP.chan $chan
  set %NBA.get.scores.NBA.TEMP.nick $nick
  if (%NBA.get.scores.NBA.ON) || ($hget(NBA.get.scores)) {
    .timerNBA.spam. $+ nick 1 3 .notice %NBA.get.scores.NBA.TEMP.nick Please try again in 1 minute.
    if (!$timer(NBA.get.scores.NBA.Timeout)) .timerNBA.get.scores.NBA.Timeout 1 15 NBA.get.scores.NBA.Timeout 1
  }
  else {
    if ($2 == all) || ($2 == final) || ($2 == current) || ($2 == upcoming) || ($2 == now) set %NBA.get.scores.NBA.TEMP.info $iif($2 == now,current,$2)
    elseif ($2 == Sunday) || ($2 == Monday) || ($2 == Tuesday) || ($2 == Wednesday) || ($2 == Thursday) || ($2 == Friday) || ($2 == Saturday) || ($2 == Today) || ($2 == Tomorrow) || ($2 == Yesterday) {
      set %NBA.get.scores.NBA.TEMP.info search
      if ($2 == today) set %NBA.get.scores.NBA.TEMP.search $asctime($ctime,dddd)
      elseif ($2 == tomorrow) set %NBA.get.scores.NBA.TEMP.search $asctime($calc(86400 + $ctime),dddd)
      elseif ($2 == yesterday) set %NBA.get.scores.NBA.TEMP.search $asctime($calc($ctime - 86400),dddd)
      else set %NBA.get.scores.NBA.TEMP.search $2
    }
    elseif ($team.lookup($2)) {
      set %NBA.get.scores.NBA.TEMP.info search
      set %NBA.get.scores.NBA.TEMP.search $ifmatch
    }
    elseif (search isin $2) {
      if ($3) {
        if ($3 == today) {
          ;if ($3 == Sunday) || ($3 == Monday) || ($3 == Tuesday) || ($3 == Wednesday) || ($3 == Thursday) || ($3 == Friday) || ($3 == Saturday) || ($3 == Today) || ($3 == Tomorrow) || ($3 == Yesterday) {
          set %NBA.get.scores.NBA.TEMP.info search
          if ($3 == today) set %NBA.get.scores.NBA.TEMP.search $asctime($ctime,dddd)
          elseif ($3 == tomorrow) set %NBA.get.scores.NBA.TEMP.search $asctime($calc(86400 + $ctime),dddd)
          elseif ($3 == yesterday) set %NBA.get.scores.NBA.TEMP.search $asctime($calc($ctime - 86400),dddd)
          else set %NBA.get.scores.NBA.TEMP.search $3
        }
        elseif ($team.lookup($3)) {
          set %NBA.get.scores.NBA.TEMP.info search
          set %NBA.get.scores.NBA.TEMP.search $team.lookup($3)
        }
        else { .notice $nick Invalid search item. Use a team name or city. | halt }
      }
    }
    elseif ($2) { .notice $nick Invalid option or team name. Try $1 Search <team> or $1 Current or $1 Final or $1 Upcoming | halt }
    if (!$2) {
      .timer 1 3 .notice $nick You can also use the following options: Current, Final, or Search <team>. Example: $1 Search Bulls
      .timer 1 3 .notice $nick Or you can have scores messaged to the channel by using: !ScoreAlert NBA <team>
    }
    if (!%NBA.get.scores.NBA.TEMP.info) set %NBA.get.scores.NBA.TEMP.info $iif($2,$2,all)
    set %NBA.get.scores.NBA.TEMP.chan $chan
    set %NBA.get.scores.NBA.TEMP.nick $nick
    NBA.get.scores
  }
}
alias NBA.get.scores.NBA.msg {
  if (%NBA.get.scores.NBA.TEMP.chan) msg %NBA.get.scores.NBA.TEMP.chan $1-
}
alias NBA.get.scores {
  if (%NBA.get.scores.NBA.TEMP.nick) .notice %NBA.get.scores.NBA.TEMP.nick !NBA by mruno gathering data, please wait...
  if ($sock(NBA.get.scores)) sockclose NBA.get.scores
  set -u45 %NBA.get.scores.NBA.ON 1
  if (!$hget(NBA.get.scores)) hmake NBA.get.scores
  sockopen NBA.get.scores scores.covers.com 80
  .timerNBA.get.scores.NBA.Timeout 1 30 NBA.get.scores.NBA.Timeout
}
alias NBA.get.scores.NBA.Timeout {
  if (%NBA.get.scores.NBA.TEMP.info != alert.check) && (!$1) NBA.get.scores.NBA.msg     Error: The NBA request timed out. Please try again later. :(
  NBA.get.scores.NBA.Close
}
alias NBA.get.scores.NBA.alert.check {
  if (!$hget(NBA.get.scores.NBA.options)) hmake NBA.get.scores.NBA.options
  if (!$hget(NBA.get.scores.NBA.options,alert.check)) hadd NBA.get.scores.NBA.options alert.check 1
  else {
    if ($hget(NBA.get.scores.NBA.options,alert.check) > 2) && (!%NBA.get.scores.NBA.ON) {
      ;check for updated scores
      set %NBA.get.scores.NBA.TEMP.info alert.check
      hadd NBA.get.scores.NBA.options alert.check 0
      NBA.get.scores
    }
    else hinc NBA.get.scores.NBA.options alert.check
  }
  if (!$hget(NBA.get.scores.NBA.alert,0).item) {
    .timerNBA.get.scores.NBA.alert off
    hfree NBA.get.scores.NBA.alert
    hfree NBA.get.scores.NBA.options
  }
}
alias NBA.get.scores.NBA.scorealert {
  if (!$1) return
  if (!$hget(NBA.get.scores.NBA.alert)) hmake NBA.get.scores.NBA.alert
  if ($hget(NBA.get.scores.NBA.alert,%NBA.get.scores.NBA.TEMP.nick)) NBA.get.scores.NBA.msg  %NBA.get.scores.NBA.TEMP.nick $+ $chr(44) You can only can track one NBA team at a time.
  else {
    ;team»Current»Today»Now»Oakland at Denver»Pre-game »null:null
    hadd NBA.get.scores.NBA.alert %NBA.get.scores.NBA.TEMP.nick $+ . $+ %NBA.get.scores.NBA.TEMP.chan $+($gettok($1-,1,187),$chr(187),$gettok($1-,7,187))
    NBA.get.scores.NBA.msg 4,12 NBA   Now monitoring:12 $gettok($1-,5,187)   Score:12  $replace( $+ $gettok($1-,7,187),:,$chr(32) to $chr(32),null,0)
    ;.notice %NBA.get.scores.NBA.TEMP.nick If you leave this channel, score alerts will be disabled.
    if (!$timer(NBA.get.scores.NBA.alert)) .timerNBA.get.scores.NBA.alert 0 60 NBA.get.scores.NBA.alert.check
  }
}
alias NBA.get.scores.NBA.End {
  var %a = 0, %item, %items, %team1, %team2, %data

  ;scorealert
  if ($hget(NBA.get.scores.NBA.alert)) {
    while ($hget(NBA.get.scores.NBA.alert,0).item > %a) {
      inc %a
      set %item $hget(NBA.get.scores.NBA.alert,%a).item
      set %data $hget(NBA.get.scores.NBA.alert,%a).data
      var %newdata $hget(NBA.get.scores,$hfind(NBA.get.scores,* $+ $gettok(%data,1,187) $+ *,1,w).data)
      if (%newdata) {
        if ($gettok(%newdata,1,187) == final) {
          ;msg final score here
          ;check and see if score alert is still needed
          ;Current»Today»Now»Oakland at Denver»Pre-game »null:null

          var %sep $iif(vs isin $gettok(%newdata,4,187),vs,at)
          var %team1 $NBA.get.scores.NBA.teamcolors($gettok($gettok(%newdata,4,187),1- $+ $calc($findtok($gettok(%newdata,4,187),%sep,1,32) - 1),32))
          var %team2 $NBA.get.scores.NBA.teamcolors($gettok($gettok(%newdata,4,187),$calc($findtok($gettok(%newdata,4,187),%sep,1,32) + 1) $+ -,32))
          if (%team isin %team1) var %team0 %team1
          else var %team0 %team2
          set %team1 $remove($strip(%team1),[,],)
          set %team2 $remove($strip(%team2),[,],)
          var %teams, %winner
          if ($gettok($replace($gettok(%newdata,5,187),null,0),1,58) > $gettok($replace($gettok(%newdata,5,187),null,0),2,58)) {
            set %teams  $+ %team1 $+  at %team2 $+ 
            set %winner $strip(%team1)
          }
          elseif ($gettok($replace($gettok(%newdata,5,187),null,0),1,58) < $gettok($replace($gettok(%newdata,5,187),null,0),2,58)) {
            set %teams %team1 at %team2 $+ 
            set %winner $strip(%team2)
          }
          else set %teams %team1 at %team2
          var %rand $rand(1,15)
          .timerScoreAlert. $+ $gettok(%item,2,46) $+ . $+ $replace(%Teams,$chr(32),.) 1 %rand msg $gettok(%item,2,46)   4,12 NBA    4Final: %teams 12Score:2 $replace( $+ $gettok(%newdata,5,187),:,$chr(32) to $chr(32),null,0) 
          .msg $gettok(%item,1,46) 4,12 NBA   4Final: %teams 12Score:2 $replace( $+ $gettok(%newdata,5,187),:,$chr(32) to $chr(32),null,0) 
          hdel NBA.get.scores.NBA.alert %item
        }
        else {
          if ($gettok(%newdata,6,187) != $gettok(%data,2,187)) {
            var %sep $iif(vs isin $gettok(%newdata,4,187),vs,at)
            var %team1 $NBA.get.scores.NBA.teamcolors($gettok($gettok(%newdata,4,187),1- $+ $calc($findtok($gettok(%newdata,4,187),%sep,1,32) - 1),32))
            var %team2 $NBA.get.scores.NBA.teamcolors($gettok($gettok(%newdata,4,187),$calc($findtok($gettok(%newdata,4,187),%sep,1,32) + 1) $+ -,32))
            if (%team isin %team1) var %team0 %team1
            else var %team0 %team2
            set %team1 $remove($strip(%team1),[,],)
            set %team2 $remove($strip(%team2),[,],)
            var %teams
            if ($gettok($replace($gettok(%newdata,6,187),null,0),1,58) > $gettok($replace($gettok(%newdata,6,187),null,0),2,58)) set %teams  $+ %team1 $+  at %team2 $+ 
            elseif ($gettok($replace($gettok(%newdata,6,187),null,0),1,58) < $gettok($replace($gettok(%newdata,6,187),null,0),2,58)) set %teams %team1 at  $+ %team2 $+ 
            else set %teams %team1 at %team2

            .timerScoreAlert. $+ $gettok(%item,2,46) $+ . $+ $replace(%Teams,$chr(32),.) 1 $rand(1,10) msg $gettok(%item,2,46)   4[!ScoreAlert] 4,12 NBA   %teams  12 New Score:2 $replace( $+ $gettok(%newdata,6,187),:,$chr(32) to $chr(32),null,0)  14 Status:3 $gettok(%newdata,5,187) 
            hadd NBA.get.scores.NBA.alert %item $gettok(%data,1,187) $+ $chr(187) $+ $gettok(%newdata,6,187)
          }
        }
      }
    }
  }
  if (%NBA.get.scores.NBA.TEMP.info == alert.check) {
    if ($hget(NBA.get.scores)) hfree NBA.get.scores
    unset %NBA.get.scores*
    sockclose NBA.get.scores
    return
  }

  if (%NBA.get.scores.NBA.TEMP.info == scorealert) && (%NBA.get.scores.NBA.TEMP.search) {
    if ($hget(NBA.get.scores,$hfind(NBA.get.scores,*current* $+ %NBA.get.scores.NBA.TEMP.search $+ *,1,w).data)) {
      NBA.get.scores.NBA.scorealert %NBA.get.scores.NBA.TEMP.search $+ $chr(187) $+ $ifmatch
      .notice %NBA.get.scores.NBA.TEMP.nick Your ScoreAlert will be disabled if you leave %NBA.get.scores.NBA.TEMP.chan or by typing 12!ScoreAlert NBA off 
    }
    else NBA.get.scores.NBA.msg %NBA.get.scores.NBA.TEMP.nick $+ $chr(44) please choose an NBA game that is currently playing. $iif($hfind(NBA.get.scores,*upcoming* $+ %NBA.get.scores.NBA.TEMP.search $+ *,1,w).data,%NBA.get.scores.NBA.TEMP.search plays on12 $gettok($hget(NBA.get.scores,$ifmatch),2,187) at $gettok($hget(NBA.get.scores,$ifmatch),3,187)) 
  }
  ;team search
  if (%NBA.get.scores.NBA.TEMP.info == search) && (%NBA.get.scores.NBA.TEMP.search) {
    var %a = 0, %item, %items, %team0, %team1, %team2, %team = %NBA.get.scores.NBA.TEMP.search
    set %item $hget(NBA.get.scores,$hfind(NBA.get.scores,* $+ %team $+ *,1,w).data)
    if (!%item) set %item $hget(NBA.get.scores,$hfind(NBA.get.scores,* $+ $left(%team,3) $+ *,1,w).data)
    if (!%item) {
      NBA.get.scores.NBA.msg   Sorry, there are no NBA games found for: %team :(
      NBA.get.scores.NBA.Close
      return
    }
    if (%team == Sun) || (%team == Sunday) || (%team == Mon) || (%team == Monday) || (%team == Tue) || (%team == Tuesday) || (%team == Wed) || (%team == Wednesday) || (%team == Thu) || (%team == Thursday) || (%team == Fri) || (%team == Friday) || (%team == Sat) || (%team == Saturday) || (%team == Today) || (%team == Tomorrow) || (%team == Yesterday) {
      ;Day Search
      set %abbr $left(%team,3)
      var %a = 0, %games, %temp

      while ($hfind(NBA.get.scores,* $+ %abbr $+ *,0,w).data > %a) {
        inc %a
        if (%a == 1) NBA.get.scores.NBA.msg 4,12 NBA  $gettok(%item,2,187) $+ :
        set %temp $gettok($hfind(NBA.get.scores,* $+ %abbr $+ *,%a,w).data,2,46)
        if ($len(%temp) == 1) set %temp 0 $+ %temp
        set %games $addtok(%temp,%games,32)
      }
      set %games $sorttok(%games,32)
      set %a 0
      var %game
      while ($gettok(%games,0,32) > %a) {
        inc %a
        set %game NBA. $+ $iif($left($gettok(%games,%a,32),1) == 0,$right($gettok(%games,%a,32),1),$gettok(%games,%a,32))
        set %item $hget(NBA.get.scores,%game)
        if ($gettok(%item,1,187) == Upcoming) NBA.get.scores.NBA.upcoming %item
        elseif ($gettok(%item,1,187) == Final) {
          NBA.get.scores.NBA.final %item
        }
        elseif ($gettok(%item,1,187) == Current) {
          NBA.get.scores.NBA.current %item
        }
      }

      ;end of loop
    }
    elseif ($gettok(%item,1,187) == upcoming) {
      set %team %NBA.get.scores.NBA.TEMP.search
      var %sep $iif(vs isin $gettok(%item,4,187),vs,at)
      set %team1 $NBA.get.scores.NBA.teamcolors($gettok($gettok(%item,4,187),1- $+ $calc($findtok($gettok(%item,4,187),%sep,1,32) - 1),32))
      set %team2 $NBA.get.scores.NBA.teamcolors($gettok($gettok(%item,4,187),$calc($findtok($gettok(%item,4,187),%sep,1,32) + 1) $+ -,32))
      if (%team isin %team1) set %team0 %team1
      else set %team0 %team2
      var %consensus
      if ($chr(37) isin $remove($gettok(%item,7,187),$chr(32))) {
        if ($remove($gettok(%item,7,187),$chr(32)) == $remove($gettok(%item,9,187),$chr(32))) set %consensus Dead Even
        elseif ($remove($gettok(%item,7,187),$chr(37)) > $remove($gettok(%item,9,187),$chr(37))) set %consensus  $+ $remove($gettok($strip(%team1),$iif(!$team.colors,-1,-2),32),]) $+  $paren($remove($gettok(%item,7,187),$chr(32))) 14over $remove($gettok($strip(%team2),$iif(!$team.colors,-1,-2),32),]) $paren($remove($gettok(%item,9,187),$chr(32)))
        elseif ($remove($gettok(%item,7,187),$chr(37)) < $remove($gettok(%item,9,187),$chr(37))) set %consensus  $+ $remove($gettok($strip(%team2),$iif(!$team.colors,-1,-2),32),]) $+  $paren($remove($gettok(%item,9,187),$chr(32))) 14over $remove($gettok($strip(%team1),$iif(!$team.colors,-1,-2),32),]) $paren($remove($gettok(%item,7,187),$chr(32)))
      }
      NBA.get.scores.NBA.msg  4,12 NBA    %team0 14Record:12 $iif($gettok($gettok(%item,$iif($gettok(%team,0,32) == 1,4,4-5),187),1,32) isin $strip(%team0),$gettok(%item,6,187),$gettok(%item,$iif(%consensus,8,7),187))
      NBA.get.scores.NBA.msg     14Next game:12 $gettok(%item,4,187) 14 $paren( $+ $gettok(%item,2,187) @ $gettok(%item,3,187) $+ 14) $iif(%consensus,14Consensus: %consensus)
    }
    elseif ($gettok(%item,1,187) == final) {
      var %sep $iif(vs isin $gettok(%item,4,187),vs,at)
      set %team1 $NBA.get.scores.NBA.teamcolors($gettok($gettok(%item,4,187),1- $+ $calc($findtok($gettok(%item,4,187),%sep,1,32) - 1),32))
      set %team2 $NBA.get.scores.NBA.teamcolors($gettok($gettok(%item,4,187),$calc($findtok($gettok(%item,4,187),%sep,1,32) + 1) $+ -,32))
      if (%team isin %team1) set %team0 %team1
      else set %team0 %team2
      set %team1 $remove($strip(%team1),[,],)
      set %team2 $remove($strip(%team2),[,],)
      var %teams
      if ($gettok($replace($gettok(%item,5,187),null,0),1,58) > $gettok($replace($gettok(%item,5,187),null,0),2,58)) set %teams  $+ %team1 $+  at %team2 $+ 
      elseif ($gettok($replace($gettok(%item,5,187),null,0),1,58) < $gettok($replace($gettok(%item,5,187),null,0),2,58)) set %teams %team1 at %team2 $+ 
      else set %teams %team1 at %team2
      NBA.get.scores.NBA.msg  4,12 NBA    %team0 Last game:12 $gettok(%item,2,187)
      NBA.get.scores.NBA.msg         %teams  - Score: $replace($gettok(%item,5,187),null,0,:,$chr(32) to $chr(32)) - $paren(12FINAL) 
    }
    elseif ($gettok(%item,1,187) == current) {
      set %team1 $NBA.get.scores.NBA.teamcolors($gettok($gettok(%item,4,187),1- $+ $calc($findtok($gettok(%item,4,187),%sep,1,32) - 1),32))
      set %team2 $NBA.get.scores.NBA.teamcolors($gettok($gettok(%item,4,187),$calc($findtok($gettok(%item,4,187),%sep,1,32) + 1) $+ -,32))
      if (%team isin %team1) set %team0 %team1
      else set %team0 %team2
      set %team1 $remove($strip(%team1),[,],)
      set %team2 $remove($strip(%team2),[,],)
      var %teams
      if ($gettok($replace($gettok(%item,5,187),null,0),1,58) > $gettok($replace($gettok(%item,5,187),null,0),2,58)) set %teams  $+ %team1 $+  at %team2 $+ 
      elseif ($gettok($replace($gettok(%item,5,187),null,0),1,58) < $gettok($replace($gettok(%item,5,187),null,0),2,58)) set %teams %team1 at %team2 $+ 
      else set %teams %team1 at %team2

      NBA.get.scores.NBA.msg  4,12 NBA    %team0 14Currently playing: $replace($gettok(%item,4,187),at,14@)
      NBA.get.scores.NBA.msg      14Score:12 $replace($gettok(%item,6,187),null,0,:,$chr(32) to $chr(32))  14Status:12 $gettok(%item,5,187) $iif(%NBA.get.scores.NBA.TEMP.GameStatus,- %NBA.get.scores.NBA.TEMP.GameStatus)
    }
  }

  if (%NBA.get.scores.NBA.TEMP.info == all) || (%NBA.get.scores.NBA.TEMP.info == current) {
    ;gathers all the CURRENT games
    while (%a < $hget(NBA.get.scores,0).item) {
      inc %a
      set %item $hget(NBA.get.scores,%a).item
      if ($gettok($hget(NBA.get.scores,%item),1,187) == Current) set %items $addtok(%items,%item,44)
    }
    ;echoes all the CURRENT games
    ;Current»Today»Now»Oakland at Denver»Pre-game »null:null

    set %a 0
    set %item
    if (%items) {
      NBA.get.scores.NBA.msg 4,12 NBA   Games 12currently playing:
      while (%a < $gettok(%items,0,44)) {
        inc %a
        ;if (%a == 1) NBA.get.scores.NBA.msg  4,12 NBA 
        set %item $hget(NBA.get.scores,$gettok(%items,%a,44))
        NBA.get.scores.NBA.current %item
      }
    }
    else {
      if (%NBA.get.scores.NBA.TEMP.info == current) NBA.get.scores.NBA.msg There are currently no NBA games being played.
    }
  }

  if (%NBA.get.scores.NBA.TEMP.info == all) || (%NBA.get.scores.NBA.TEMP.info == final) {
    ;gathers all the FINAL games

    ;Final»Thursday September 19 2013»0»Kansas City at Philadelphia »26:16

    set %a 0
    set %item
    set %items
    while (%a < $hget(NBA.get.scores,0).item) {
      inc %a
      set %item $hget(NBA.get.scores,%a).item
      if ($gettok($hget(NBA.get.scores,%item),1,187) == FINAL) set %items $addtok(%items,%item,44)
    }
    ;echoes all the FINAL games
    set %a 0
    set %item
    if (%items) {
      while (%a < $gettok(%items,0,44)) {
        inc %a
        set %item $hget(NBA.get.scores,$gettok(%items,%a,44))
        ;if (%a == 1) NBA.get.scores.NBA.msg  4,12 NBA 
        NBA.get.scores.NBA.final %item
      }
    }
    else {
      if (%NBA.get.scores.NBA.TEMP.info == final) NBA.get.scores.NBA.msg There are currently no NBA final games for this week.
    }
  }
  if (%NBA.get.scores.NBA.TEMP.info == all) || (%NBA.get.scores.NBA.TEMP.info == upcoming) {
    ;    Upcoming»Monday September 23 2013»8:40p ET»Oakland at Denver» »1-1 (0-1 V) »36% »2-0 (1-0 H) »64%
    var %a = 1, %data, %last, %item, %total = 0
    while ($hget(NBA.get.scores,NBA. $+ %a)) {
      set %data $hget(NBA.get.scores,NBA. $+ %a)
      if (upcoming isin $gettok(%data,1,187)) {
        if (%last != $gettok(%data,2,187)) NBA.get.scores.NBA.msg 4,12 NBA   $gettok(%data,2,187) $+ :
        inc %total
        NBA.get.scores.NBA.upcoming %data
      }
      set %last $gettok(%data,2,187)
      inc %a
    }
    if (!%total) && (%NBA.get.scores.NBA.TEMP.info == upcoming) NBA.get.scores.NBA.msg There are no more NBA upcoming games for this week.
  }
  .timerNBA.get.scores.NBA.Close 1 15 NBA.get.scores.NBA.Close
}
alias NBA.get.scores.NBA.final {
  if (!$1) return
  var %item = $1-, %team1, %team2
  var %sep $iif(vs isin $gettok(%item,4,187),vs,at)
  set %team1 $NBA.get.scores.NBA.teamcolors($gettok($gettok(%item,4,187),1- $+ $calc($findtok($gettok(%item,4,187),%sep,1,32) - 1),32))
  set %team2 $NBA.get.scores.NBA.teamcolors($gettok($gettok(%item,4,187),$calc($findtok($gettok(%item,4,187),%sep,1,32) + 1) $+ -,32))

  var %teams
  if ($gettok($replace($gettok(%item,5,187),null,0),1,58) > $gettok($replace($gettok(%item,5,187),null,0),2,58)) set %teams  $+ %team1 $+  14@ %team2 $+ 
  elseif ($gettok($replace($gettok(%item,5,187),null,0),1,58) < $gettok($replace($gettok(%item,5,187),null,0),2,58)) set %teams %team1 14@  $+ %team2 $+ 
  else set %teams %team1 14@ %team2

  NBA.get.scores.NBA.msg       %teams  14 Score:12 $replace($gettok(%item,5,187),null,0,:,$chr(32) 14to12 $chr(32))  14 Status:4 FINAL 
}
alias NBA.get.scores.NBA.upcoming {
  if (!$1) return
  var %item $1-
  var %sep $iif(vs isin $gettok(%item,4,187),vs,at)
  var %team1 $NBA.get.scores.NBA.teamcolors($gettok($gettok(%item,4,187),1- $+ $calc($findtok($gettok(%item,4,187),%sep,1,32) - 1),32))
  var %team2 $NBA.get.scores.NBA.teamcolors($gettok($gettok(%item,4,187),$calc($findtok($gettok(%item,4,187),%sep,1,32) + 1) $+ -,32))

  var %consensus
  if ($chr(37) isin $remove($gettok(%item,7,187),$chr(32))) {
    if ($remove($gettok(%item,7,187),$chr(32)) == $remove($gettok(%item,9,187),$chr(32))) set %consensus Dead Even
    elseif ($remove($gettok(%item,7,187),$chr(37)) > $remove($gettok(%item,9,187),$chr(37))) set %consensus  $+ $remove($gettok($strip(%team1),$iif(!$team.colors,-1,-2),32),]) $+  $paren($remove($gettok(%item,7,187),$chr(32))) $+  14over $remove($gettok($strip(%team2),$iif(!$team.colors,-1,-2),32),]) $paren($remove($gettok(%item,9,187),$chr(32))) 
    elseif ($remove($gettok(%item,7,187),$chr(37)) < $remove($gettok(%item,9,187),$chr(37))) set %consensus  $+ $remove($gettok($strip(%team2),$iif(!$team.colors,-1,-2),32),]) $+  $paren($remove($gettok(%item,9,187),$chr(32))) $+  14over $remove($gettok($strip(%team1),$iif(!$team.colors,-1,-2),32),]) $paren($remove($gettok(%item,7,187),$chr(32))) 
  }
  NBA.get.scores.NBA.msg       $gettok(%item,3,187)  %team1 $paren($gettok($gettok(%item,6,187),1,32)) 14@ %team2 $paren($gettok($gettok(%item,$iif(%consensus,8,7),187),1,32)) $iif(%consensus,14 Consensus: %consensus)
}
alias NBA.get.scores.NBA.current {
  if (!$1) return
  var %item = $1-, %team1, %team2
  var %sep $iif(vs isin $gettok(%item,4,187),vs,at)
  set %team1 $NBA.get.scores.NBA.teamcolors($gettok($gettok(%item,4,187),1- $+ $calc($findtok($gettok(%item,4,187),%sep,1,32) - 1),32))
  set %team2 $NBA.get.scores.NBA.teamcolors($gettok($gettok(%item,4,187),$calc($findtok($gettok(%item,4,187),%sep,1,32) + 1) $+ -,32))
  var %teams
  var %team1score $gettok($replace($gettok(%item,6,187),null,0),1,58)
  var %team2score $gettok($replace($gettok(%item,6,187),null,0),2,58)
  if (%team1score > %team2score) set %teams  $+ %team1 14@ %team2 
  elseif (%team1score < %team2score) set %teams %team1 14@  $+ %team2 
  else set %teams %team1 14@ %team2
  NBA.get.scores.NBA.msg       %teams 14 14Score: $replace($gettok(%item,6,187),null,0,:,$chr(32) to $chr(32))  14 Status:3 $gettok(%item,5,187) $iif($gettok(%item,7,187),- $gettok(%item,7,187)) 
}
alias NBA.get.scores.NBA.Sorted {
  if ($1) {
    ;sorts items by putting all the dates in hash tables
    var %z = 0, %new
    while ($hget(NBA.get.scores,0).item > %z) {
      inc %z
      if (NBA. isin $hget(NBA.get.scores,%z).item) set %new $addtok(%new,$v2,44)
    }
    set %z 0
    var %data, %time, %data2, %all, %item
    while ($gettok(%items,0,44) > %z) {
      inc %z
      set %item $gettok(%items,%z,44)
      set %data $hget(NBA.get.scores,%item)
      set %new $gettok(%data,2,187) $+ . $+ $gettok(%data,3,187)
      set %data2 %new
      set %time $remove($gettok(%data2,2,46),p,a,et)
      set %time $calc($calc($gettok(%time,1,58) * 360) + $calc($gettok(%time,2,58) * 60))
      set %time $calc($ctime($gettok(%data2,1,46)) + %time)
      hadd NBA.get.scores %time $addtok($hget(NBA.get.scores,%time),%item,44)
    }

    var %z = 0
    set %new
    while ($hget(NBA.get.scores,0).item > %z) {
      inc %z
      if (NBA. !isin $hget(NBA.get.scores,%z).item) set %new $addtok(%new,$v2,44)
    }
    return $sorttok(%new,44,n)
  }
}
alias NBA.get.scores.NBA.Close {
  sockclose NBA.get.scores
  unset %NBA.get.scores.NBA.TEMP.*
  .timerhfree.NBA.get.scores 1 30 if ($hget(NBA.get.scores)) hfree NBA.get.scores
}
alias -l useragent {
  var %r $rand(1,11)
  if (%r == 1) return User-Agent: Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; Trident/5.0)
  elseif (%r == 2) return User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-GB; rv:1.8.1.6) Gecko/20070725 Firefox/2.0.0.6
  elseif (%r == 3) return User-Agent: Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 5.1)
  elseif (%r == 4) return User-Agent: Opera/9.20 (Windows NT 6.0; U; en)
  elseif (%r == 5) return User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.7.5) Gecko/20060127 Netscape/8.1
  elseif (%r == 6) return User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_6_8) AppleWebKit/537.13+ (KHTML, like Gecko) Version/5.1.7 Safari/534.57.2
  elseif (%r == 7) return User-Agent: Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_6_7; da-dk) AppleWebKit/533.21.1 (KHTML, like Gecko) Version/5.0.5 Safari/533.21.1
  elseif (%r == 8) return User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.2; WOW64; rv:1.8.0.7) Gecko/20110321 MultiZilla/4.33.2.6a SeaMonkey/8.6.55
  elseif (%r == 9) return User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/37.0.2049.0 Safari/537.36
  elseif (%r == 10) return User-Agent: Mozilla/5.0 (Windows NT 5.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/36.0.1985.67 Safari/537.36
  elseif (%r == 11) return User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:31.0) Gecko/20100101 Firefox/31.0
}
on *:sockopen:NBA.get.scores: {
  sockwrite -nt $sockname GET /basketball-scores-matchups.aspx HTTP/1.1
  sockwrite -nt $sockname $useragent
  sockwrite -nt $sockname Host: scores.covers.com
  sockwrite -nt $sockname Accept-Language: en-us
  sockwrite -nt $sockname Accept: */*
  sockwrite -nt $sockname $crlf
}
on *:sockread:NBA.get.scores: {
  var %temp, %date, %item, %data
  if ($sockerr) {
    var %error
    if ($sockerr == 3) set %error Connection refused by remote host
    elseif ($sockerr == 4) set %error DNS lookup for hostname failed
    elseif ($sockerr > 0) set %error Unknown socket error ( $+ $sockerr $+ )
    echo -s NBA.get.scores:     4Socket Error: %error
    .timerNBA.get.scores.NBA.error 1 10 NBA.get.scores.NBA.msg     4,12 NBA   Socket Error. Please try again later. :(
    .timerNBA.get.scores.NBA.close 1 15 NBA.get.scores.NBA.close
    halt
  }
  else {
    .timerNBA.get.scores.NBA.Timeout off
    sockread %temp

    ;STATUS»DATE»TIME»TEAMS»STATUS»SCORE(Away:Home)»Game Status

    ;new date for NBA games
    ;<h2><div ID="DayNav" class="date-nav"><a href="javascript:void(0);" onclick="javascript:ClientUpdateCalAndNav(9,&#39;2014-2015&#39;,2014,11,7);">Fri, Nov 7</a>&nbsp;&nbsp;&#8226;&nbsp;<a><b>Sat, Nov 8</b></a>&nbsp;&nbsp;&#8226;&nbsp;<a href="javascript:void(0);" onclick="javascript:ClientUpdateCalAndNav(9,&#39;2014-2015&#39;,2014,11,9);">Sun, Nov 9</a></div></h2>
    ;$wildtok(%test,nbsp;<a><b>*</b></a>,1,38)
    if (<h2><div ID="DayNav" class="date-nav"><a href="javascript:void(0);" onclick="javascript:ClientUpdateCalAndNav isin %temp) && (%date != $striphtml(%temp)) {
      set %NBA.get.scores.NBA.TEMP.DATE $remove($striphtml($wildtok(%test,nbsp;<a><b>*</b></a>,1,38)),nbsp;)
    }
    elseif (*<span class="activetab" id="In_Game_Status_9_*">Final</span>* iswm %temp) set %NBA.get.scores.NBA.TEMP.DATE Final
    else set %NBA.get.scores.NBA.TEMP.DATE Today


    ;if (<td colspan="2" class="scoreboard-left"><h2> isin %temp) && (%date != $striphtml(%temp)) set %NBA.get.scores.NBA.TEMP.DATE $remove($striphtml(%temp),$chr(44))

    if (*<td class="scoreboard-*">* iswm %temp) {
      if ($striphtml(%temp)) {
        if (!$hget(NBA.get.scores)) hmake NBA.get.scores
        ;In_Game_Status_9_
        unset %NBA.get.scores.NBA.TEMP.GameStatus
        set %item $striphtml(%temp)

        set %NBA.get.scores.NBA.TEMP.title $gettok($wildtok(%temp,*Title_9_*,1,60),2,62)

        if (Final isin %item) {
          ;Game Over
          set %NBA.get.scores.NBA.TEMP.STATUS Final
          hadd NBA.get.scores NBA. $+ $calc($hget(NBA.get.scores,0).item + 1) $+(Final,$chr(187),%NBA.get.scores.NBA.TEMP.DATE,$chr(187),0,$chr(187),$gettok($wildtok(%temp,*Title_9_*,1,60),2,62))
        }
        elseif (*AM ET* iswm %item) || (*PM ET* iswm %item) {
          ;Game Upcoming
          set %NBA.get.scores.NBA.TEMP.STATUS Upcoming
          hadd NBA.get.scores NBA. $+ $calc($hget(NBA.get.scores,0).item + 1) $+(Upcoming,$chr(187),%NBA.get.scores.NBA.TEMP.DATE,$chr(187),$replace($remove($gettok($wildtok(%temp,*span class="pretab">*,1,60),2,62),$chr(32)),pmET,p ET,amET,a ET),$chr(187),$gettok($wildtok(%temp,*Title_9_*,1,60),2,62),$chr(187))
        }
        else {
          ;Game is ON!
          set %NBA.get.scores.NBA.TEMP.STATUS Current
          hadd NBA.get.scores NBA. $+ $calc($hget(NBA.get.scores,0).item + 1) $+(Current,$chr(187),$asctime($ctime,dddd),$chr(187),Now,$chr(187),$gettok($wildtok(%temp,*Title_9_*,1,60),2,62),$chr(187),$gettok($wildtok(%temp,*In_Game_Status_9_*,1,60),2,62))

        }
      }
    }
  }
  ;if (*<td class="datac" id="*Score_9* iswm %temp) {
  if (<td class="datarcb isin %temp) {
    if (%NBA.get.scores.NBA.TEMP.STATUS == Current) || (%NBA.get.scores.NBA.TEMP.STATUS == Final) {
      var %i $hfind(NBA.get.scores,* $+ %NBA.get.scores.NBA.TEMP.title $+ *,1,w).data

      if (VisitScore isin %temp) {
        hadd NBA.get.scores %i $hget(NBA.get.scores,%i) $+($chr(187),$iif(!$striphtml(%temp),null,$remove($striphtml(%temp),$chr(32))),:)
      }
      elseif (HomeScore isin %temp) {
        hadd NBA.get.scores %i $hget(NBA.get.scores,%i) $+ $iif(!$striphtml(%temp),null,$remove($striphtml(%temp),$chr(32)))
      }
    }
  }
  if (%NBA.get.scores.NBA.TEMP.STATUS == Upcoming) && ($striphtml(%temp)) {
    var %i $hfind(NBA.get.scores,* $+ %NBA.get.scores.NBA.TEMP.title $+ *,1,w).data
    ;if (*<td class="data">*-* (*-* ?)</td>* iswm %temp) hadd NBA.get.scores %i $hget(NBA.get.scores,%i) $+($chr(187),$striphtml(%temp))
    if (*<td class="data">*(*)*</td>* iswm %temp) {
      hadd NBA.get.scores %i $hget(NBA.get.scores,%i) $+($chr(187),$striphtml(%temp))
    }

    if (*<td class="datac">*%</td>* iswm %temp) {
      ;consensus
      ;<td class="datac">68%</td>
      hadd NBA.get.scores %i $hget(NBA.get.scores,%i) $+($chr(187),$striphtml(%temp))
    }
  }
  .timerNBA.get.scores.NBA.End 1 3 NBA.get.scores.NBA.End
}

alias NBA.get.scores.NBA.teamcolors {
  if (!$1) return
  var %a
  if ($1- == Boston) set %a 0,3[ $v1 Celtics ]
  elseif (Brooklyn isin $1-) set %a 1,0[ $v1 Nets ]
  elseif (New York isin $1-) set %a 7,12[ $v1 Knicks ]
  elseif (Philadelphia isin $1-) set %a 12,0[ $v1 76ers ]
  elseif (Toronto isin $1-) set %a 4,1[ $v1 Raptors ]
  elseif (Chicago isin $1-) set %a 1,4[ $v1 Bulls ]
  elseif (Cleveland isin $1-) set %a 7,12[ $v1 Cavaliers ]
  elseif (Detroit isin $1-) set %a 0,7[ $v1 Pistons ]
  elseif (Indiana isin $1-) set %a 8,12[ $v1 Pacers ]
  elseif (Milwaukee isin $1-) set %a 7,3[ $v1 Bucks ]
  elseif (Atlanta isin $1-) set %a 7,12[ $v1 Hawks ]
  elseif (Charlotte isin $1-) set %a 1,11[ $v1 Hornets ]
  elseif (Miami isin $1-) set %a 1,7[ $v1 Heat ]
  elseif (Orlando isin $1-) set %a 1,11[ $v1 Magic ]
  elseif (Washington isin $1-) set %a 7,2[ $v1 Wizards ]
  elseif (Dallas isin $1-) set %a 0,2[ $v1 Mavericks ]
  elseif (Houston isin $1-) set %a 4,0[ $v1 Rockets ]
  elseif (Memphis isin $1-) set %a 10,1[ $v1 Grizzlies ]
  elseif (New Orleans isin $1-) set %a 8,2[ $v1 Pelicans ]
  elseif (San Antonio isin $1-) set %a 15,1[ $v1 Spurs ]
  elseif (Denver isin $1-) set %a 7,10[ $v1 Nuggets ]
  elseif (Minnesota isin $1-) set %a 11,14[ $v1 Timberwolves ]
  elseif (Oklahoma City isin $1-) set %a 11,7[ $v1 Thunder ]
  elseif (Portland isin $1-) set %a 7,1[ $v1 Trail Blazers ]
  elseif (Utah isin $1-) set %a 8,2[ $v1 Jazz ]
  elseif (Golden State isin $1-) set %a 8,12[ $v1 Warriors ]
  elseif (Los Angeles Clippers isin $1-) || (L.A. Clippers isin $1-) || (LA Clippers isin $1-) set %a 2,4[ $v1 ]
  elseif (Los Angeles Lakers isin $1-) || (L.A. Lakers isin $1-) || (LA Lakers isin $1-) set %a 6,8[ $v1 ]
  elseif (Phoenix isin $1-) set %a 7,1[ $v1 Suns ]
  elseif (Sacramento isin $1-) set %a 6,15[ $v1 Kings ]
  else {
    iecho 4ERROR UNKNOWN NBA TEAM: $1-
    return
  }

  if (!$team.colors) return 12 $+ $remove($strip(%a),[,]) $+ 
  else return %a
}

alias -l team.lookup {
  if (!$1) return
  var %a
  if (Boston isin $1-) set %a $v1
  elseif (Brooklyn isin $1-) set %a $v1
  elseif (New York isin $1-) set %a $v1
  elseif (Philadelphia isin $1-) set %a $v1
  elseif (Tortonto isin $1-) set %a $v1
  elseif (Denver isin $1-) set %a $v1
  elseif (Minnesota isin $1-) set %a $v1
  elseif (Oklahoma City isin $1-) set %a $v1
  elseif (Portland isin $1-) set %a $v1
  elseif (Utah isin $1-) set %a $v1
  elseif (Golden State isin $1-) set %a $v1
  elseif (L.A. Clippers isin $1-) || (LA Clippers isin $1-) || (L. A. Clippers isin $1-) set %a L.A. Clippers
  elseif (L.A. Lakers isin $1-) || (LA Lakers isin $1-) || (L. A. Lakers isin $1-) set %a L.A. Lakers
  elseif (Phoenix isin $1-) set %a $v1
  elseif (Sacramento isin $1-) set %a $v1
  elseif (Chicago isin $1-) set %a $v1
  elseif (Cleveland isin $1-) set %a $v1
  elseif (Detroit isin $1-) set %a $v1
  elseif (Indiana isin $1-) set %a $v1
  elseif (Milwaukee isin $1-) set %a $v1
  elseif (Atlanta isin $1-) set %a $v1
  elseif (Charlotte isin $1-) set %a $v1
  elseif (Miami isin $1-) set %a $v1
  elseif (Orlando isin $1-) set %a $v1
  elseif (Washington isin $1-) set %a $v1
  elseif (Dallas isin $1-) set %a $v1
  elseif (Houston isin $1-) set %a $v1
  elseif (Memphis isin $1-) set %a $v1
  elseif (New Orleans isin $1-) set %a $v1
  elseif (San Antonio isin $1-) set %a $v1

  elseif (Celtics isin $1-) set %a Boston
  elseif (Nets isin $1-) set %a Brooklyn
  elseif (Knicks isin $1-) set %a New York
  elseif (76ers isin $1-) set %a Philadelphia
  elseif (Raptors isin $1-) set %a Toronto
  elseif (Bulls isin $1-) set %a Chicago
  elseif (Cavaliers isin $1-) set %a Cleveland
  elseif (Pistons isin $1-) set %a Detroit
  elseif (Pacers isin $1-) set %a Indiana
  elseif (Bucks isin $1-) set %a Milwaukee
  elseif (Hawks isin $1-) set %a Atlanta
  elseif (Hornets isin $1-) set %a Charlotte
  elseif (Heat isin $1-) set %a Miami
  elseif (Magic isin $1-) set %a Orlando
  elseif (Wizards isin $1-) set %a Washington
  elseif (Mavericks isin $1-) set %a Dallas
  elseif (Rockets isin $1-) set %a Houston
  elseif (Grizzlies isin $1-) set %a Memphis
  elseif (Pelicans isin $1-) set %a New Orleans
  elseif (Spurs isin $1-) set %a San Antonio
  elseif (Nuggets isin $1-) set %a Denver
  elseif (Timberwolves isin $1-) set %a Minnesota
  elseif (Thunder isin $1-) set %a Oklahoma City
  elseif (Trail Blazers isin $1-) set %a Portland
  elseif (Jazz isin $1-) set %a Utah
  elseif (Warriors isin $1-) set %a Golden State
  elseif (Clippers isin $1-) set %a L.A. Clippers
  elseif (Lakers isin $1-) set %a L.A. Lakers
  elseif (Suns isin $1-) set %a Phoenix
  elseif (Kings isin $1-) set %a Sacramento

  else {
    iecho 4NBA Unknown team: $1-
    return
  }

  return %a
}
alias -l paren if ($1) return ( $+ $1- $+ )

;==================================================================================
;Author  : fubar
;Function: $striphtml identifier
;          This identifier strips html code from a string of text.
;                 Good for using when retrieving webpages within mirc.  
;==================================================================================
;
;This identifier strips html code from a string of text. Good for using when retrieving webpages within mirc.
;
;Usage: $striphtml(html code)
alias -l Xchr {
  var %return $regsubex($regsubex($1-,/&#x([A-F0-9]{1,2});/g,$chr($base($regml(\n),16,10))),/&#([0-9]{2});/g,$chr(\1))
  return $replacecs(%return,&ndash;,,&middot;,·,&raquo;,»,&laquo;,«,&Uuml;,Ü,&uuml;,ü,&Aacute;,Á,&aacute;,á,&Eacute;,$&
    É,&eacute;,é,&Iacute;,Í,&iacute;,í,&Oacute;,Ó,&oacute;,ó,&Ntilde;,Ñ,&ntilde;,ñ,&Uacute;,Ú,&uacute;,ú,&nbsp;,$chr(32),$&
    &aelig;,æ,&quot;,")
}
alias -l striphtml {
  ; making sure there are parameters to work with
  IF ($1) {
    ; Setting my variables. The %opt is set kind of funky
    ; all it does is combine <two><brackets> into 1 <twobrackets>, fewer loops this way
    ; also stripped tab spaces
    VAR %strip
    var %opt <> $remove($1-,> <,><,$chr(9)) <>
    var %n 2
    ; using $gettok() I checked the text in front of '>' (chr 62)
    ; then the second $gettok checks the text behind '<' (chr 60)
    ; so I'm extracting anything between >text<
    WHILE ($gettok($gettok(%opt,%n,62),1,60)) {
      ; take each peice of text and add it to the same variable
      %strip = %strip $ifmatch
      %strip = $replace(%strip,&quot;,")
      ; increase the variable so the while statement can check the next part
      INC %n
    }
    ; now that the loop has finished we can return the stripped html code
    RETURN $xchr(%strip)
  }
}
