	

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;script !nfl Script
;version 25SEP2014
;author mruno
;email mruno@ircN.org
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;
;to disable team colors type /set %nocolor 1
;
;
;
on 1:PART:#:{
  if ($hget(get.scores.nfl.alert,$nick $+ . $+ $chan)) {
    hdel get.scores.nfl.alert $nick $+ . $+ $chan
    msg $nick Your ScoreAlert has been deleted for parting.
  }
}
on 1:JOIN:#:if ($timer(get.scores.nfl.remove.alert. $+ $nick $+ . $+ $chan)) .timerget.scores.nfl.remove.alert. $+ $nick $+ . $+ $chan off
on 1:KICK:#:if ($hget(get.scores.nfl.alert,$nick $+ . $+ $chan)) .timerget.scores.nfl.remove.alert. $+ $nick $+ . $+ $chan 1 120 hdel get.scores.nfl.alert $nick $+ . $+ $chan
on 1:QUIT:if ($hget(get.scores.nfl.alert)) hdel -w get.scores.nfl.alert $nick $+ .*
on 1:NICK:{
  if ($hget(get.scores.nfl.alert,$nick $+ . $+ $chan)) {
    hadd get.scores.nfl.alert $newnick $+ . $+ $chan $hget(get.scores.nfl.alert,$nick $+ . $+ $chan)
    hdel get.scores.nfl.alert $nick $+ . $+ $chan
  }
}
on *:TEXT:?scorealert*:#:{
  if ($2 == off) {
    hdel get.scores.nfl.alert $nick $+ . $+ $chan
    .notice $nick Deleted your ScoreAlert.
    return
  }
  if ($3 == off) {
    if ($hget(get.scores.nfl.alert,$nick $+ . $+ $chan)) || ($nick isop $chan) {
      if ($team.lookup($2)) {
        if ($hget(get.scores.nfl.alert,$nick $+ . $+ $chan)) {
          hdel get.scores.nfl.alert $nick $+ . $+ $chan
          .notice $nick Deleted your ScoreAlert for $2
          return
        }
        if ($nick isop $chan) {
          var %a = 0
          while (%a < $hfind(get.scores.nfl.alert,* $+ $team.lookup($2) $+ *,0,w).data) {
            inc %a
            if ($gettok($hfind(get.scores.nfl.alert,* $+ $team.lookup($2) $+ *,%a,w).data,2,46) == $chan) {
              hdel get.scores.nfl.alert $hfind(get.scores.nfl.alert,* $+ $team.lookup($2) $+ *,%a,w).data
              .notice $nick Deleted ScoreAlert for $2
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
    if (%get.scores.nfl.ON) || ($hget(Get.Scores)) {
      .notice $nick Please don't flood the NFL script.
      if (!$timer(get.scores.nfl.Timeout)) .timerget.scores.nfl.Timeout 1 15 get.scores.nfl.Timeout 1
      halt
    }
    if ($2) {
      if ($team.lookup($2)) {
        if ($hget(get.scores.nfl.alert,$nick $+ . $+ $chan)) .notice $nick Your current scorealert $paren($gettok($v1,1,187)) will be overwritten.
        set %get.scores.nfl.TEMP.info scorealert
        set %get.scores.nfl.TEMP.search $team.lookup($2)
        set %get.scores.nfl.TEMP.chan $chan
        set %get.scores.nfl.TEMP.nick $nick
        get.scores
      }
      else .notice $nick Invalid team name.
    }
    else .notice $nick Please specify a team.
  }
}
on *:TEXT:?nfl*:#:{
  set %get.scores.nfl.TEMP.chan $chan
  set %get.scores.nfl.TEMP.nick $nick
  if (%get.scores.nfl.ON) || ($hget(Get.Scores)) {
    .timerNFL.spam. $+ nick 1 3 .notice %get.scores.nfl.TEMP.nick Please try again in 1 minute.
    if (!$timer(get.scores.nfl.Timeout)) .timerget.scores.nfl.Timeout 1 15 get.scores.nfl.Timeout 1
  }
  else {
    if ($2 == all) || ($2 == final) || ($2 == current) || ($2 == upcoming) || ($2 == now) set %get.scores.nfl.TEMP.info $iif($2 == now,current,$2)
    elseif ($2 == Sunday) || ($2 == Monday) || ($2 == Tuesday) || ($2 == Wednesday) || ($2 == Thursday) || ($2 == Friday) || ($2 == Saturday) || ($2 == Today) || ($2 == Tomorrow) || ($2 == Yesterday) {
      set %get.scores.nfl.TEMP.info search
      if ($2 == today) set %get.scores.nfl.TEMP.search $asctime($ctime,dddd)
      elseif ($2 == tomorrow) set %get.scores.nfl.TEMP.search $asctime($calc(86400 + $ctime),dddd)
      elseif ($2 == yesterday) set %get.scores.nfl.TEMP.search $asctime($calc($ctime - 86400),dddd)
      else set %get.scores.nfl.TEMP.search $2
    }
    elseif ($team.lookup($2)) {
      set %get.scores.nfl.TEMP.info search
      set %get.scores.nfl.TEMP.search $ifmatch
    }
    elseif (search isin $2) {
      if ($3) {
        if ($3 == Sunday) || ($3 == Monday) || ($3 == Tuesday) || ($3 == Wednesday) || ($3 == Thursday) || ($3 == Friday) || ($3 == Saturday) || ($3 == Today) || ($3 == Tomorrow) || ($3 == Yesterday) {
          set %get.scores.nfl.TEMP.info search
          if ($3 == today) set %get.scores.nfl.TEMP.search $asctime($ctime,dddd)
          elseif ($3 == tomorrow) set %get.scores.nfl.TEMP.search $asctime($calc(86400 + $ctime),dddd)
          elseif ($3 == yesterday) set %get.scores.nfl.TEMP.search $asctime($calc($ctime - 86400),dddd)
          else set %get.scores.nfl.TEMP.search $3
        }
        elseif ($team.lookup($3)) {
          set %get.scores.nfl.TEMP.info search
          set %get.scores.nfl.TEMP.search $team.lookup($3)
        }
        else { .notice $nick Invalid search item. Try a team name or the day of the week. | halt }
      }
    }
    elseif ($2) { .notice $nick Invalid option, team name, or day of the week. Try $1 Current or $1 Final or $1 Search <team> or $1 Search <day> or $1 Upcoming | halt }
    if (!$2) {
      .timer 1 3 .notice $nick You can also use the following options: Current, Final, Search <team>, and Upcoming. Example: $1 Search 49ers
      .timer 1 3 .notice $nick Or you can have scores messaged to the channel by using: !ScoreAlert <team>
    }
    if (!%get.scores.nfl.TEMP.info) set %get.scores.nfl.TEMP.info $iif($2,$2,all)
    set %get.scores.nfl.TEMP.chan $chan
    set %get.scores.nfl.TEMP.nick $nick
    get.scores
  }
}
alias get.scores.nfl.msg if (%get.scores.nfl.TEMP.chan) msg %get.scores.nfl.TEMP.chan $1-
alias Get.Scores {
  if (%get.scores.nfl.TEMP.nick) .notice %get.scores.nfl.TEMP.nick Gathering NFL data, please wait...
  if ($sock(Get.Scores)) sockclose Get.Scores
  set -u45 %get.scores.nfl.ON 1
  if (!$hget(get.scores)) hmake get.scores
  sockopen Get.Scores scores.covers.com 80
  .timerget.scores.nfl.Timeout 1 30 get.scores.nfl.Timeout
}
alias get.scores.nfl.Timeout {
  if (%get.scores.nfl.TEMP.info != alert.check) && (!$1) get.scores.nfl.msg     Error: The request timed out. Please try again later. :(
  get.scores.nfl.Close
}
alias get.scores.nfl.alert.check {
  if (!$hget(get.scores.nfl.options)) hmake get.scores.nfl.options
  if (!$hget(get.scores.nfl.options,alert.check)) hadd get.scores.nfl.options alert.check 1
  else {
    if ($hget(get.scores.nfl.options,alert.check) > 2) && (!%get.scores.nfl.ON) {
      ;check for updated scores
      set %get.scores.nfl.TEMP.info alert.check
      hadd get.scores.nfl.options alert.check 0
      get.scores
    }
    else hinc get.scores.nfl.options alert.check
  }
}
alias get.scores.nfl.scorealert {
  if (!$1) return
  if (!$hget(get.scores.nfl.alert)) hmake get.scores.nfl.alert
  if ($hget(get.scores.nfl.alert,%get.scores.nfl.TEMP.nick)) get.scores.nfl.msg  %get.scores.nfl.TEMP.nick $+ $chr(44) You can only can track one team at a time.
  else {
    ;team»Current»Today»Now»Oakland at Denver»Pre-game »null:null
    hadd get.scores.nfl.alert %get.scores.nfl.TEMP.nick $+ . $+ %get.scores.nfl.TEMP.chan $+($gettok($1-,1,187),$chr(187),$gettok($1-,7,187))
    get.scores.nfl.msg Now monitoring:12 $gettok($1-,5,187)   Score:12  $replace( $+ $gettok($1-,7,187),:,$chr(32) to $chr(32),null,0)
    ;.notice %get.scores.nfl.TEMP.nick If you leave this channel, score alerts will be disabled.
    if (!$timer(get.scores.nfl.alert)) .timerget.scores.nfl.alert 0 60 get.scores.nfl.alert.check
  }
}
alias get.scores.nfl.End {
  var %a = 0, %item, %items, %team1, %team2, %data

  ;scorealert
  if ($hget(get.scores.nfl.alert)) {
    while ($hget(get.scores.nfl.alert,0).item > %a) {
      inc %a
      set %item $hget(get.scores.nfl.alert,%a).item
      set %data $hget(get.scores.nfl.alert,%a).data
      var %newdata = $hget(get.scores,$hfind(get.scores,* $+ $gettok(%data,1,187) $+ *,1,w).data)
      if (%newdata) {
        if ($gettok(%newdata,1,187) == final) {
          ;msg final score here
          ;check and see if score alert is still needed
          ;Current»Today»Now»Oakland at Denver»Pre-game »null:null

          var %sep $iif(vs isin $gettok(%newdata,4,187),vs,at)
          var %team1 $get.scores.nfl.teamcolors($gettok($gettok(%newdata,4,187),1- $+ $calc($findtok($gettok(%newdata,4,187),%sep,1,32) - 1),32))
          var %team2 $get.scores.nfl.teamcolors($gettok($gettok(%newdata,4,187),$calc($findtok($gettok(%newdata,4,187),%sep,1,32) + 1) $+ -,32))
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
          var %rand $rand(1,10)
          .timerScoreAlert. $+ $gettok(%item,2,46) $+ . $+ $replace(%Teams,$chr(32),.) 1 %rand msg $gettok(%item,2,46)     4Final: %teams 12Score:2 $replace( $+ $gettok(%newdata,5,187),:,$chr(32) to $chr(32),null,0) 
          .msg $gettok(%item,1,46) 4Final: %teams 12Score:2 $replace( $+ $gettok(%newdata,5,187),:,$chr(32) to $chr(32),null,0) 
          ;if (%winner !isin $remove($strip($get.scores.nfl.teamcolors($gettok(%data,1,187))),[,])) .timer 1 $calc(3 + %rand) msg $gettok(%item,2,46) Sorry $gettok(%item,1,46) $+ $chr(44) your team lost :(
          ;else .timer 1 $calc(3 + %rand) if ($gettok(%item,1,46) ison $gettok(%item,2,46)) msg $gettok(%item,2,46) Congrats $gettok(%item,1,46) $+ $chr(44) your team won!
          hdel get.scores.nfl.alert %item
        }
        else {
          if ($gettok(%newdata,6,187) != $gettok(%data,2,187)) {
            var %sep $iif(vs isin $gettok(%newdata,4,187),vs,at)
            var %team1 $get.scores.nfl.teamcolors($gettok($gettok(%newdata,4,187),1- $+ $calc($findtok($gettok(%newdata,4,187),%sep,1,32) - 1),32))
            var %team2 $get.scores.nfl.teamcolors($gettok($gettok(%newdata,4,187),$calc($findtok($gettok(%newdata,4,187),%sep,1,32) + 1) $+ -,32))
            if (%team isin %team1) var %team0 %team1
            else var %team0 %team2
            set %team1 $remove($strip(%team1),[,],)
            set %team2 $remove($strip(%team2),[,],)
            var %teams
            if ($gettok($replace($gettok(%newdata,6,187),null,0),1,58) > $gettok($replace($gettok(%newdata,6,187),null,0),2,58)) set %teams  $+ %team1 $+  at %team2 $+ 
            elseif ($gettok($replace($gettok(%newdata,6,187),null,0),1,58) < $gettok($replace($gettok(%newdata,6,187),null,0),2,58)) set %teams %team1 at  $+ %team2 $+ 
            else set %teams %team1 at %team2

            .timerScoreAlert. $+ $gettok(%item,2,46) $+ . $+ $replace(%Teams,$chr(32),.) 1 $rand(1,10) msg $gettok(%item,2,46)   4[!ScoreAlert] %teams  12 New Score:2 $replace( $+ $gettok(%newdata,6,187),:,$chr(32) to $chr(32),null,0)  14 Status:3 $gettok(%newdata,5,187) 
            hadd get.scores.nfl.alert %item $gettok(%data,1,187) $+ $chr(187) $+ $gettok(%newdata,6,187)
          }
        }
      }
    }
  }
  if (%get.scores.nfl.TEMP.info == alert.check) {
    if ($hget(get.scores)) hfree get.scores
    unset %get.scores*
    sockclose get.scores
    return
  }

  if (%get.scores.nfl.TEMP.info == scorealert) && (%get.scores.nfl.TEMP.search) {
    if ($hget(get.scores,$hfind(get.scores,*current* $+ %get.scores.nfl.TEMP.search $+ *,1,w).data)) {
      get.scores.nfl.scorealert %get.scores.nfl.TEMP.search $+ $chr(187) $+ $ifmatch
      .notice %get.scores.nfl.TEMP.nick Your ScoreAlert will be disabled if you leave %get.scores.nfl.TEMP.chan or by typing 12!ScoreAlert off 
    }
    else get.scores.nfl.msg %get.scores.nfl.TEMP.nick $+ $chr(44) please choose a game that is currently playing. $iif($hfind(get.scores,*upcoming* $+ %get.scores.nfl.TEMP.search $+ *,1,w).data,%get.scores.nfl.TEMP.search plays on12 $gettok($hget(get.scores,$ifmatch),2,187) at $gettok($hget(get.scores,$ifmatch),3,187)) 
  }
  ;team search
  if (%get.scores.nfl.TEMP.info == search) && (%get.scores.nfl.TEMP.search) {
    var %a = 0, %item, %items, %team0, %team1, %team2, %team = %get.scores.nfl.TEMP.search
    set %item $hget(get.scores,$hfind(get.scores,* $+ %team $+ *,1,w).data)
    if (!%item) {
      get.scores.nfl.msg   Sorry, no games found for: %team
      get.scores.nfl.Close
      return
    }
    if (%team == Sunday) || (%team == Monday) || (%team == Tuesday) || (%team == Wednesday) || (%team == Thursday) || (%team == Friday) || (%team == Saturday) || (%team == Today) || (%team == Tomorrow) || (%team == Yesterday) {
      ;Day Search
      var %a = 0, %games, %temp
      while ($hfind(get.scores,* $+ %team $+ *,0,w).data > %a) {
        inc %a
        ;if (%a == 1) get.scores.nfl.msg   Games for:12 $gettok(%item,2,187)
        if (%a == 1) get.scores.nfl.msg  $gettok(%item,2,187) $+ :
        set %temp $gettok($hfind(get.scores,* $+ %team $+ *,%a,w).data,2,46)
        if ($len(%temp) == 1) set %temp 0 $+ %temp
        set %games $addtok(%temp,%games,32)
      }
      set %games $sorttok(%games,32)
      set %a 0
      var %game
      while ($gettok(%games,0,32) > %a) {
        inc %a
        set %game NFL. $+ $iif($left($gettok(%games,%a,32),1) == 0,$right($gettok(%games,%a,32),1),$gettok(%games,%a,32))
        set %item $hget(get.scores,%game)
        if ($gettok(%item,1,187) == Upcoming) get.scores.nfl.upcoming %item
        elseif ($gettok(%item,1,187) == Final) get.scores.nfl.final %item
        elseif ($gettok(%item,1,187) == Current) get.scores.nfl.current %item
      }

      ;end of loop
    }
    elseif ($gettok(%item,1,187) == upcoming) {
      set %team %get.scores.nfl.TEMP.search
      var %sep $iif(vs isin $gettok(%item,4,187),vs,at)
      set %team1 $get.scores.nfl.teamcolors($gettok($gettok(%item,4,187),1- $+ $calc($findtok($gettok(%item,4,187),%sep,1,32) - 1),32))
      set %team2 $get.scores.nfl.teamcolors($gettok($gettok(%item,4,187),$calc($findtok($gettok(%item,4,187),%sep,1,32) + 1) $+ -,32))
      if (%team isin %team1) set %team0 %team1
      else set %team0 %team2
      var %consensus
      if ($chr(37) isin $remove($gettok(%item,7,187),$chr(32))) {
        if ($remove($gettok(%item,7,187),$chr(32)) == $remove($gettok(%item,9,187),$chr(32))) set %consensus Dead Even
        elseif ($remove($gettok(%item,7,187),$chr(37)) > $remove($gettok(%item,9,187),$chr(37))) set %consensus  $+ $remove($gettok($strip(%team1),$iif(%nocolor,-1,-2),32),]) $+  $paren($remove($gettok(%item,7,187),$chr(32))) 14over $remove($gettok($strip(%team2),$iif(%nocolor,-1,-2),32),]) $paren($remove($gettok(%item,9,187),$chr(32)))
        elseif ($remove($gettok(%item,7,187),$chr(37)) < $remove($gettok(%item,9,187),$chr(37))) set %consensus  $+ $remove($gettok($strip(%team2),$iif(%nocolor,-1,-2),32),]) $+  $paren($remove($gettok(%item,9,187),$chr(32))) 14over $remove($gettok($strip(%team1),$iif(%nocolor,-1,-2),32),]) $paren($remove($gettok(%item,7,187),$chr(32)))
      }
      get.scores.nfl.msg   %team0 14Record:12 $iif($gettok($gettok(%item,$iif($gettok(%team,0,32) == 1,4,4-5),187),1,32) isin $strip(%team0),$gettok(%item,6,187),$gettok(%item,$iif(%consensus,8,7),187))
      get.scores.nfl.msg     14Next game:12 $gettok(%item,4,187) 14 $paren( $+ $gettok(%item,2,187) @ $gettok(%item,3,187) $+ 14) $iif(%consensus,14Consensus: %consensus)
    }
    elseif ($gettok(%item,1,187) == final) {
      var %sep $iif(vs isin $gettok(%item,4,187),vs,at)
      set %team1 $get.scores.nfl.teamcolors($gettok($gettok(%item,4,187),1- $+ $calc($findtok($gettok(%item,4,187),%sep,1,32) - 1),32))
      set %team2 $get.scores.nfl.teamcolors($gettok($gettok(%item,4,187),$calc($findtok($gettok(%item,4,187),%sep,1,32) + 1) $+ -,32))
      if (%team isin %team1) set %team0 %team1
      else set %team0 %team2
      set %team1 $remove($strip(%team1),[,],)
      set %team2 $remove($strip(%team2),[,],)
      var %teams
      if ($gettok($replace($gettok(%item,5,187),null,0),1,58) > $gettok($replace($gettok(%item,5,187),null,0),2,58)) set %teams  $+ %team1 $+  at %team2 $+ 
      elseif ($gettok($replace($gettok(%item,5,187),null,0),1,58) < $gettok($replace($gettok(%item,5,187),null,0),2,58)) set %teams %team1 at %team2 $+ 
      else set %teams %team1 at %team2
      get.scores.nfl.msg   %team0 Last game:12 $gettok(%item,2,187)
      get.scores.nfl.msg       %teams  - Score: $replace($gettok(%item,5,187),null,0,:,$chr(32) to $chr(32)) - $paren(12FINAL) 
    }
    elseif ($gettok(%item,1,187) == current) {
      set %team1 $get.scores.nfl.teamcolors($gettok($gettok(%item,4,187),1- $+ $calc($findtok($gettok(%item,4,187),%sep,1,32) - 1),32))
      set %team2 $get.scores.nfl.teamcolors($gettok($gettok(%item,4,187),$calc($findtok($gettok(%item,4,187),%sep,1,32) + 1) $+ -,32))
      if (%team isin %team1) set %team0 %team1
      else set %team0 %team2
      set %team1 $remove($strip(%team1),[,],)
      set %team2 $remove($strip(%team2),[,],)
      var %teams
      if ($gettok($replace($gettok(%item,5,187),null,0),1,58) > $gettok($replace($gettok(%item,5,187),null,0),2,58)) set %teams  $+ %team1 $+  at %team2 $+ 
      elseif ($gettok($replace($gettok(%item,5,187),null,0),1,58) < $gettok($replace($gettok(%item,5,187),null,0),2,58)) set %teams %team1 at %team2 $+ 
      else set %teams %team1 at %team2

      get.scores.nfl.msg   %team0 14Currently playing: $replace($gettok(%item,4,187),at,14@)
      get.scores.nfl.msg     14Score:12 $replace($gettok(%item,6,187),null,0,:,$chr(32) to $chr(32))  14Status:12 $gettok(%item,5,187) $iif(%get.scores.nfl.TEMP.GameStatus,- %get.scores.nfl.TEMP.GameStatus)
    }
  }

  if (%get.scores.nfl.TEMP.info == all) || (%get.scores.nfl.TEMP.info == current) {
    ;gathers all the CURRENT games
    while (%a < $hget(Get.Scores,0).item) {
      inc %a
      set %item $hget(Get.Scores,%a).item
      if ($gettok($hget(get.scores,%item),1,187) == Current) set %items $addtok(%items,%item,44)
    }
    ;echoes all the CURRENT games
    ;Current»Today»Now»Oakland at Denver»Pre-game »null:null

    set %a 0
    set %item
    if (%items) {
      get.scores.nfl.msg Games 12currently playing:
      while (%a < $gettok(%items,0,44)) {
        inc %a
        set %item $hget(get.scores,$gettok(%items,%a,44))
        get.scores.nfl.current %item
      }
    }
    else {
      if (%get.scores.nfl.TEMP.info == current) get.scores.nfl.msg There are currently no games being played.
    }
  }

  if (%get.scores.nfl.TEMP.info == all) || (%get.scores.nfl.TEMP.info == final) {
    ;gathers all the FINAL games

    ;Final»Thursday September 19 2013»0»Kansas City at Philadelphia »26:16

    set %a 0
    set %item
    set %items
    while (%a < $hget(Get.Scores,0).item) {
      inc %a
      set %item $hget(Get.Scores,%a).item
      if ($gettok($hget(get.scores,%item),1,187) == FINAL) set %items $addtok(%items,%item,44)
    }
    ;echoes all the FINAL games
    set %a 0
    set %item
    if (%items) {
      while (%a < $gettok(%items,0,44)) {
        inc %a
        set %item $hget(get.scores,$gettok(%items,%a,44))
        get.scores.nfl.final %item
      }
    }
    else {
      if (%get.scores.nfl.TEMP.info == final) get.scores.nfl.msg There are currently no final games for this week.
    }
  }
  if (%get.scores.nfl.TEMP.info == all) || (%get.scores.nfl.TEMP.info == upcoming) {
    ;    Upcoming»Monday September 23 2013»8:40p ET»Oakland at Denver» »1-1 (0-1 V) »36% »2-0 (1-0 H) »64%
    var %a = 1, %data, %last, %item, %total = 0
    while ($hget(Get.Scores,NFL. $+ %a)) {
      set %data $hget(Get.Scores,NFL. $+ %a)
      if (upcoming isin $gettok(%data,1,187)) {
        ;if (%last != $gettok(%data,2,187)) get.scores.nfl.msg Games for12 $gettok(%data,2,187) $+ :
        if (%last != $gettok(%data,2,187)) get.scores.nfl.msg  $gettok(%data,2,187) $+ :
        inc %total
        get.scores.nfl.upcoming %data
      }
      set %last $gettok(%data,2,187)
      inc %a
    }
    if (!%total) && (%get.scores.nfl.TEMP.info == upcoming) get.scores.nfl.msg There are no more upcoming games for this week.
  }
  .timerget.scores.nfl.Close 1 15 get.scores.nfl.Close
}
alias get.scores.nfl.final {
  if (!$1) return
  var %item = $1-, %team1, %team2
  var %sep $iif(vs isin $gettok(%item,4,187),vs,at)
  set %team1 $get.scores.nfl.teamcolors($gettok($gettok(%item,4,187),1- $+ $calc($findtok($gettok(%item,4,187),%sep,1,32) - 1),32))
  set %team2 $get.scores.nfl.teamcolors($gettok($gettok(%item,4,187),$calc($findtok($gettok(%item,4,187),%sep,1,32) + 1) $+ -,32))

  var %teams
  if ($gettok($replace($gettok(%item,5,187),null,0),1,58) > $gettok($replace($gettok(%item,5,187),null,0),2,58)) set %teams  $+ %team1 $+  14@ %team2 $+ 
  elseif ($gettok($replace($gettok(%item,5,187),null,0),1,58) < $gettok($replace($gettok(%item,5,187),null,0),2,58)) set %teams %team1 14@  $+ %team2 $+ 
  else set %teams %team1 14@ %team2

  get.scores.nfl.msg       %teams  14 Score:12 $replace($gettok(%item,5,187),null,0,:,$chr(32) 14to12 $chr(32))  14 Status:4 FINAL 
}
alias get.scores.nfl.upcoming {
  if (!$1) return
  var %item = $1-
  var %sep $iif(vs isin $gettok(%item,4,187),vs,at)
  var %team1 $get.scores.nfl.teamcolors($gettok($gettok(%item,4,187),1- $+ $calc($findtok($gettok(%item,4,187),%sep,1,32) - 1),32))
  var %team2 $get.scores.nfl.teamcolors($gettok($gettok(%item,4,187),$calc($findtok($gettok(%item,4,187),%sep,1,32) + 1) $+ -,32))

  var %consensus
  if ($chr(37) isin $remove($gettok(%item,7,187),$chr(32))) {
    if ($remove($gettok(%item,7,187),$chr(32)) == $remove($gettok(%item,9,187),$chr(32))) set %consensus Dead Even
    elseif ($remove($gettok(%item,7,187),$chr(37)) > $remove($gettok(%item,9,187),$chr(37))) set %consensus  $+ $remove($gettok($strip(%team1),$iif(%nocolor,-1,-2),32),]) $+  $paren($remove($gettok(%item,7,187),$chr(32))) $+  14over $remove($gettok($strip(%team2),$iif(%nocolor,-1,-2),32),]) $paren($remove($gettok(%item,9,187),$chr(32))) 
    elseif ($remove($gettok(%item,7,187),$chr(37)) < $remove($gettok(%item,9,187),$chr(37))) set %consensus  $+ $remove($gettok($strip(%team2),$iif(%nocolor,-1,-2),32),]) $+  $paren($remove($gettok(%item,9,187),$chr(32))) $+  14over $remove($gettok($strip(%team1),$iif(%nocolor,-1,-2),32),]) $paren($remove($gettok(%item,7,187),$chr(32))) 
  }
  get.scores.nfl.msg       $gettok(%item,3,187)  %team1 $paren($gettok($gettok(%item,6,187),1,32)) 14@ %team2 $paren($gettok($gettok(%item,$iif(%consensus,8,7),187),1,32)) $iif(%consensus,14 Consensus: %consensus)
}
alias get.scores.nfl.current {
  if (!$1) return
  var %item = $1-, %team1, %team2
  var %sep $iif(vs isin $gettok(%item,4,187),vs,at)
  set %team1 $get.scores.nfl.teamcolors($gettok($gettok(%item,4,187),1- $+ $calc($findtok($gettok(%item,4,187),%sep,1,32) - 1),32))
  set %team2 $get.scores.nfl.teamcolors($gettok($gettok(%item,4,187),$calc($findtok($gettok(%item,4,187),%sep,1,32) + 1) $+ -,32))
  var %teams
  var %team1score $gettok($replace($gettok(%item,6,187),null,0),1,58)
  var %team2score $gettok($replace($gettok(%item,6,187),null,0),2,58)
  if (%team1score > %team2score) set %teams  $+ %team1 14@ %team2 
  elseif (%team1score < %team2score) set %teams %team1 14@  $+ %team2 
  else set %teams %team1 14@ %team2
  get.scores.nfl.msg       %teams 14 14Score: $replace($gettok(%item,6,187),null,0,:,$chr(32) to $chr(32))  14 Status:3 $gettok(%item,5,187) $iif($gettok(%item,7,187),- $gettok(%item,7,187)) 
}
alias get.scores.nfl.Sorted {
  if ($1) {
    ;sorts items by putting all the dates in hash tables
    var %z = 0, %new
    while ($hget(get.scores,0).item > %z) {
      inc %z
      if (NFL. isin $hget(get.scores,%z).item) set %new $addtok(%new,$v2,44)
    }
    set %z 0
    var %data, %time, %data2, %all, %item
    while ($gettok(%items,0,44) > %z) {
      inc %z
      set %item $gettok(%items,%z,44)
      set %data $hget(get.scores,%item)
      set %new $gettok(%data,2,187) $+ . $+ $gettok(%data,3,187)
      set %data2 %new
      set %time $remove($gettok(%data2,2,46),p,a,et)
      set %time $calc($calc($gettok(%time,1,58) * 360) + $calc($gettok(%time,2,58) * 60))
      set %time $calc($ctime($gettok(%data2,1,46)) + %time)
      hadd get.scores %time $addtok($hget(get.scores,%time),%item,44)
    }

    var %z = 0
    set %new
    while ($hget(get.scores,0).item > %z) {
      inc %z
      if (NFL. !isin $hget(get.scores,%z).item) set %new $addtok(%new,$v2,44)
    }
    return $sorttok(%new,44,n)
  }
}
alias get.scores.nfl.Close {
  sockclose Get.Scores
  unset %get.scores.nfl.TEMP.*
  .timerhfree.get.scores 1 30 if ($hget(Get.Scores)) hfree Get.Scores
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
on *:sockopen:Get.Scores: {
  sockwrite -nt $sockname GET /football-scores-matchups.aspx HTTP/1.1
  sockwrite -nt $sockname $useragent
  sockwrite -nt $sockname Host: scores.covers.com
  sockwrite -nt $sockname Accept-Language: en-us
  sockwrite -nt $sockname Accept: */*
  sockwrite -nt $sockname $crlf
}
on *:sockread:Get.Scores: {
  var %temp, %date, %item, %data
  if ($sockerr) {
    var %error
    if ($sockerr == 3) set %error Connection refused by remote host
    elseif ($sockerr == 4) set %error DNS lookup for hostname failed
    elseif ($sockerr > 0) set %error Unknown socket error ( $+ $sockerr $+ )
    echo -s get.scores:     4Socket Error: %error
    .timerget.scores.nfl.error 1 10 get.scores.nfl.msg       Socket Error. Please try again later. :(
    .timerget.scores.nfl.close 1 15 get.scores.nfl.close
    halt
  }
  else {
    .timerget.scores.nfl.Timeout off
    sockread %temp

    ;STATUS»DATE»TIME»TEAMS»STATUS»SCORE(Away:Home)»Game Status

    if (<td colspan="2" class="scoreboard-left"><h2> isin %temp) && (%date != $striphtml(%temp)) set %get.scores.nfl.TEMP.DATE $remove($striphtml(%temp),$chr(44))

    ;if (<b>Game Status: </b> isin %temp) {
    ;  ;echo -st NFL1: $wildtok(%temp,*game status:*,1,59)
    ;  var %a $striphtml($wildtok(%temp,*game status:*,1,59))
    ;  echo -st NFL: $gettok(%a,0,58) - $gettok($gettok(%a,1- $+ $calc($gettok(%a,0,58) - $iif($gettok(%a,0,58) > 1,1,0)),58),1 - $calc($gettok($gettok(%a,1- $+ $calc($gettok(%a,0,58) - 1),58),0,32) - 1),32)
    ;  echo -st NFL2: %a
    ;}

    if (*<td class="scoreboard-*">* iswm %temp) {
      if ($striphtml(%temp)) {
        if (!$hget(get.scores)) hmake get.scores
        ;In_Game_Status_1_
        unset %get.scores.nfl.TEMP.GameStatus
        set %item $striphtml(%temp)

        set %get.scores.nfl.TEMP.title $gettok($wildtok(%temp,*Title_1_*,1,60),2,62)

        if (Final isin %item) {
          ;Game Over
          set %get.scores.nfl.TEMP.STATUS Final
          hadd Get.Scores NFL. $+ $calc($hget(Get.Scores,0).item + 1) $+(Final,$chr(187),%get.scores.nfl.TEMP.DATE,$chr(187),0,$chr(187),$gettok($wildtok(%temp,*Title_1_*,1,60),2,62))
        }
        elseif (*AM ET* iswm %item) || (*PM ET* iswm %item) {
          ;Game Upcoming
          set %get.scores.nfl.TEMP.STATUS Upcoming
          hadd Get.Scores NFL. $+ $calc($hget(Get.Scores,0).item + 1) $+(Upcoming,$chr(187),%get.scores.nfl.TEMP.DATE,$chr(187),$replace($remove($gettok($wildtok(%temp,*span class="pretab">*,1,60),2,62),$chr(32)),pmET,p ET,amET,a ET),$chr(187),$gettok($wildtok(%temp,*Title_1_*,1,60),2,62),$chr(187))
        }
        else {
          ;Game is ON!
          set %get.scores.nfl.TEMP.STATUS Current
          hadd Get.Scores NFL. $+ $calc($hget(Get.Scores,0).item + 1) $+(Current,$chr(187),$asctime($ctime,dddd),$chr(187),Now,$chr(187),$gettok($wildtok(%temp,*Title_1_*,1,60),2,62),$chr(187),$gettok($wildtok(%temp,*In_Game_Status_1_*,1,60),2,62))

        }
      }
    }
  }
  if (*<td class="datac" id="*Score_1* iswm %temp) {
    if (%get.scores.nfl.TEMP.STATUS == Current) || (%get.scores.nfl.TEMP.STATUS == Final) {
      var %i  $hfind(get.scores,* $+ %get.scores.nfl.TEMP.title $+ *,1,w).data
      if (<td class="datac" id="VisitScore_1 isin %temp) hadd get.scores %i $hget(get.scores,%i) $+($chr(187),$iif(!$striphtml(%temp),null,$remove($striphtml(%temp),$chr(32))),:)
      if (<td class="datac" id="HomeScore_1_ isin %temp) hadd get.scores %i $hget(get.scores,%i) $+ $iif(!$striphtml(%temp),null,$remove($striphtml(%temp),$chr(32)))
    }
  }
  if (%get.scores.nfl.TEMP.STATUS == Upcoming) && ($striphtml(%temp)) {
    var %i = $hfind(get.scores,* $+ %get.scores.nfl.TEMP.title $+ *,1,w).data
    if (*<td class="data">*-* (*-* ?)</td>* iswm %temp) hadd get.scores %i $hget(get.scores,%i) $+($chr(187),$striphtml(%temp))
    if (*<td class="datac">*%</td>* iswm %temp) hadd get.scores %i $hget(get.scores,%i) $+($chr(187),$striphtml(%temp))
  }
  .timerget.scores.nfl.End 1 3 get.scores.nfl.End
}

alias get.scores.nfl.teamcolors {
  var %a
  if ($1- == Arizona) set %a 4[ Arizona Cardinals ]
  elseif (Atlanta isin $1-) set %a 1[ Atlanta Falcons ]
  elseif (Baltimore isin $1-) set %a 2[ Baltimore Ravens ]
  elseif (Buffalo isin $1-) set %a 2[ Buffalo Bills ]
  elseif (Carolina isin $1-) set %a 1[ Carolina Panthers ]
  elseif (Chicago isin $1-) set %a 2[ Chicago Bears ]
  elseif (CINCINNATI isin $1-) set %a 7[ Cincinnati Bengals ]
  elseif (CLEVELAND isin $1-) set %a 15[ Cleveland Browns ]
  elseif (DALLAS isin $1-) set %a 15[ Dallas Cowboys ]
  elseif (DENVER isin $1-) set %a 2[ Denver Broncos ]
  elseif (DETROIT isin $1-) set %a 15[ Detroit Lions ]
  elseif (GREEN BAY isin $1-) set %a 3[ Green Bay Packers ]
  elseif (HOUSTON isin $1-) set %a 4[ Houston Texans ]
  elseif (INDIANAPOLIS isin $1-) set %a 15[ Indianapolis Colts ]
  elseif (JACKSONVILLE isin $1-) set %a 8[ Jacksonville Jaguars ]
  elseif (KANSAS CITY isin $1-) set %a 4[ Kansas City Chiefs ]
  elseif (MIAMI isin $1-) set %a 11[ Miami Dolphins ]
  elseif (MINNESOTA isin $1-) set %a 6[ Minnesota Vikings ]
  elseif (NEW ENGLAND isin $1-) set %a 15[ New England Patriots ]
  elseif (NEW ORLEANS isin $1-) set %a 1[ New Orleans Saints ]
  elseif (NY GIANTS isin $1-) || (N.Y. GIANTS isin $1-) set %a 2[ New York Giants ]
  elseif (NY Jets isin $1-) || (N.Y. JETS isin $1-) set %a 3[ New York Jets ]
  elseif (OAKLAND isin $1-) set %a 1[ Oakland Raiders ]
  elseif (PHILADELPHIA isin $1-) set %a 10[ Philadelphia Eagles ]
  elseif (PITTSBURGH isin $1-) set %a 0[ Pittsburgh Steelers ]
  elseif (SAN DIEGO isin $1-) set %a 2[ San Diego Chargers ]
  elseif (SEATTLE isin $1-) set %a 2[ Seattle Seahawks ]
  elseif (SAN FRANCISCO isin $1-) set %a 4[ San Francisco 49ers ]
  elseif (ST. LOUIS isin $1-) set %a 2[ St. Louis Rams ]
  elseif (TAMPA BAY isin $1-) set %a 4[ Tampa Bay Buccaneers ]
  elseif (TENNESSEE isin $1-) set %a 2[ Tennessee Titans ]
  elseif (WASHINGTON isin $1-) set %a 5[ Washington Redskins ]

  elseif (rice isin $1-) set %a Team Rice
  elseif (sanders isin $1-) set %a Team Sanders
  elseif (jr isin $1-) set %a Team Rice
  elseif (ds isin $1-) set %a Team Sanders

  if (%nocolor) return 12 $+ $remove($strip(%a),[,]) $+ 
  else return %a
}

alias -l team.lookup {
  var %a
  if (Arizona isin $1-) set %a $v1
  elseif (Atlanta isin $1-) set %a $v1
  elseif (Baltimore isin $1-) set %a $v1
  elseif (Buffalo isin $1-) set %a $v1
  elseif (Carolina isin $1-) set %a $v1
  elseif (Chicago isin $1-) set %a $v1
  elseif (CINCINNATI isin $1-) set %a $v1
  elseif (CLEVELAND isin $1-) set %a $v1
  elseif (DALLAS isin $1-) set %a $v1
  elseif (DENVER isin $1-) set %a $v1
  elseif (DETROIT isin $1-) set %a $v1
  elseif (GREEN BAY isin $1-) set %a $v1
  elseif (HOUSTON isin $1-) set %a $v1
  elseif (INDIANAPOLIS isin $1-) set %a $v1
  elseif (JACKSONVILLE isin $1-) set %a $v1
  elseif (KANSAS CITY isin $1-) set %a $v1
  elseif (MIAMI isin $1-) set %a $v1
  elseif (MINNESOTA isin $1-) set %a $v1
  elseif (NEW ENGLAND isin $1-) set %a $v1
  elseif (NEW ORLEANS isin $1-) set %a $v1
  elseif (NY GIANTS isin $1-) || (N. Y. GIANTS isin $1-) set %a N. Y. GIANTS
  elseif (NY JETS isin $1-) || (N. Y. JETS isin $1-) set %a N. Y. Jets
  elseif (OAKLAND isin $1-) set %a $v1
  elseif (PHILADELPHIA isin $1-) set %a $v1
  elseif (PITTSBURGH isin $1-) set %a $v1
  elseif (SAN DIEGO isin $1-) set %a $v1
  elseif (SEATTLE isin $1-) set %a $v1
  elseif (SAN FRANCISCO isin $1-) set %a $v1
  elseif (ST. LOUIS isin $1-) set %a $v1
  elseif (TAMPA BAY isin $1-) set %a $v1
  elseif (TENNESSEE isin $1-) set %a $v1
  elseif (WASHINGTON isin $1-) set %a $v1

  elseif (Cardinals isin $1-) set %a Arizona
  elseif (Falcons isin $1-) set %a Atlanta
  elseif (Ravens isin $1-) set %a Baltimore
  elseif (Bills isin $1-) set %a Buffalo
  elseif (Panthers isin $1-) set %a Carolina
  elseif (Bears isin $1-) set %a Chicago
  elseif (Bengals isin $1-) set %a Cincinnati
  elseif (Browns isin $1-) set %a Cleveland
  elseif (Cowboys isin $1-) set %a Dallas
  elseif (Broncos isin $1-) set %a Denver
  elseif (Lions isin $1-) set %a Detroit
  elseif (Packers isin $1-) set %a Green Bay
  elseif (Texans isin $1-) set %a Houston
  elseif (Colts isin $1-) set %a Indianapolis
  elseif (Jaguars isin $1-) set %a Jacksonville
  elseif (Chiefs isin $1-) set %a Kansas City
  elseif (Dolphins isin $1-) set %a Miami
  elseif (Vikings isin $1-) set %a Minnesota
  elseif (Patriots isin $1-) set %a New England
  elseif (Saints isin $1-) set %a New Orleans
  elseif (GIANTS isin $1-) set %a N.Y. Giants
  elseif (JETS isin $1-) set %a N.Y. Jets
  elseif (Raiders isin $1-) set %a Oakland
  elseif (Eagles isin $1-) set %a Philadelphia
  elseif (Steelers isin $1-) set %a Pittsburgh
  elseif (Chargers isin $1-) set %a San Diego
  elseif (Seahawks isin $1-) set %a Seattle
  elseif (49ers isin $1-) set %a San Francisco
  elseif (Rams isin $1-) set %a ST. Louis
  elseif (Buccaneers isin $1-) set %a Tampa Bay
  elseif (Titans isin $1-) set %a Tennessee
  elseif (Redskins isin $1-) set %a Washington

  elseif (rice isin $1-) set %a Team Rice
  elseif (sanders isin $1-) set %a Team Sanders
  elseif (jr isin $1-) set %a Team Rice
  elseif (ds isin $1-) set %a Team Sanders

  else return $1-

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
    VAR %strip,%opt = <> $remove($1-,> <,><,$chr(9)) <>,%n = 2
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
