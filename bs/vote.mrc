	

ON !*:TEXT:*:#: {
  tokenize 32 $strip($1-,burci)
  var %commands = !voteadd - !votestop - !vote - !votestats - !voteallstats - !votelast - !myvote - !delmyvote - !voteleft
  if ($1 == !addvote) || ($1 == !newvote) || ($1 == !voteadd) {
    if (%vote) { .notice $nick [ $+ $nick $+ ]: Error, There is already an vote poll on the channel! - (Started on:  $+ %vote_on $+ ) - (By:  $+ %vote_by $+ ) | return }
    if (!$2) && (!$3-) { .msg $chan [ $+ $nick $+ ]: Error, Not enough paramters, try again and enter the text correctly! - (E.g: $1 One or Two?) | return }
    if (!$2) { var %s = 300 }
    if ($2) && ($2 !isnum) { var %s = 300 }
    if ($2) && ($2 isnum) { var %s = $2 | var %s_m = 1 }
    var %tmp = $iif(%s_m,$3-,$2-)
    if (%s > 604800) { .msg $chan [ $+ $nick $+ ]: Error, Time too long, try again and use less seconds than 1 week! - (Max seconds: 604800 [1 week]) | return }
    if ($len(%tmp) > 200) { .msg $chan [ $+ $nick $+ ]: Error, Vote too long, try again and use an shorter vote message! - (Max chars: 200) | return }
    set -e %vote %tmp
    set -e %vote_by $nick
    set -e %vote_on $ctime
    set -e %vote_sec %s
    set -e %vote_expire $calc($ctime + %s)
    .timer[VOTE_END] 1 %s vote_end $chan
    .msg $chan [NEW VOTE]:  $+ %vote $+  - By:  $+ %vote_by $+ 
    .msg $chan [ $+ $nick $+ ]: Your vote poll has been successfully added. - (Expires on:  $+ $asctime(%vote_expire) $+ )
  }
  if ($1 == !stopvote) || ($1 == !votestop) {
    if (!%vote) { .msg $chan [ $+ $nick $+ ]: Error, There is NOT any vote poll running at the moment! | return }
    if ($nick !isop $chan) && ($nick !== %vote_by) { .msg $chan [ $+ $nick $+ ]: You must be an channel operator or the vote poll owner to stop the vote! | return }
    .timer[VOTE_END] off
    .msg $chan [ $+ $nick $+ ]: The vote poll has been successfully stopped.
    vote_end $chan stop
  }
  if ($1 == !vote) {
    if (!%vote) { .msg $chan [ $+ $nick $+ ]: Error, There is NOT any vote poll running at the moment! | return }
    if (!$2) { .msg $chan [ $+ $nick $+ ]: The vote poll is. - (Vote:  $+ %vote $+ ) | return }
    if ($2 !== yes) && ($2 !== no) { .msg $chan [ $+ $nick $+ ]: Error, Incorrect parameters, try again and enter only YES or NO and NOT any others! | return }
    if ($2 == yes) {
      if ($istok(%vote_yes,$nick,32)) { .msg $chan [ $+ $nick $+ ]: Error, Already voted, You have already vote for this poll! | return }
      if ($istok(%vote_yes,$nick,32)) {
        set -e %vote_no $remtok(%vote_no,$nick,1,32)
        set -e %vote_yes $addtok(%vote_yes,$nick,32)
        .msg $chan [ $+ $nick $+ ]: Your vote has been successfully changed! - Thank you!
        return
      }
      set -e %vote_yes $addtok(%vote_yes,$nick,32)
      .msg $chan [ $+ $nick $+ ]: Your vote has been successfully saved. - Thank you!
    }
    if ($2 == no) {
      if ($istok(%vote_no,$nick,32)) { .msg $chan [ $+ $nick $+ ]: Error, Already voted, You have already vote for this poll! | return }
      if ($istok(%vote_yes,$nick,32)) {
        set -e %vote_yes $remtok(%vote_yes,$nick,1,32)
        set -e %vote_no $addtok(%vote_no,$nick,32)
        .msg $chan [ $+ $nick $+ ]: Your vote has been successfully changed! - Thank you!
        return
      }
      set -e %vote_no $addtok(%vote_no,$nick,32)
      .msg $chan [ $+ $nick $+ ]: Your vote has been successfully added. - Thank you!
    }
  }
  if ($1 == !votestats) || ($1 == !statsvote) {
    if (!%vote) { .msg $chan [ $+ $nick $+ ]: Error, There is NOT any vote poll available at this time! | return }
    var %yes = $iif(%vote_yes,$v1,0)
    if (%yes == 0) { var %y = 0 }
    elseif (%yes !== 0) { var %y = $numtok(%yes,32) }
    var %no = $iif(%vote_no,$v1,0)
    if (%no == 0) { var %n = 0 }
    elseif (%no !== 0) { var %n = $numtok(%no,32) }
    var %t = $calc(%y + %n)
    .msg $chan [ $+ $nick $+ ]: The vote poll status are. - (Yes:  $+ %y $+ ) - (No:  $+ %n $+ ) - (Total Votes:  $+ $iif(%t,%t,0) $+ )
  }
  if ($1 == !voteallstats) {
    if (!%vote) { .msg $chan [ $+ $nick $+ ]: Error, There is NOT any vote poll available at this time! | return }
    if (!%vote_yes) && (!%vote_no) { .msg $chan [ $+ $nick $+ ]: There is NOT any vote available since now! | return }
    var %t = %vote_yes
    var %i = 1
    while (%i <= $numtok(%t,32)) {
      var %n = $gettok(%t,%i,32)
      .msg $chan [# $+ %i $+ ]:  $+ %n $+  - Vote: Yes
      if (%i == $numtok(%t,32)) {
        .msg $chan End list of possitive votes. - (Total Possitive Votes:  $+ $numtok(%t,32) $+ )
        var %tot = %vote_no
        var %z = 1
        while (%z <= $numtok(%tot,32)) {
          var %nn = $gettok(%tot,%z,32)
          .msg $chan [# $+ %i $+ ]:  $+ %nn $+  - Vote: No
          if (%z == $numtok(%tot,32)) { .msg $chan End list of negative votes. - (Total Negative Votes:  $+ $numtok(%tot,32) $+ ) }
          inc %z
        }
      }
      inc %i
    }
  }
  if ($1 == !lastvote) || ($1 == !votelast) {
    var %yes = $iif(%vote_last_yes,$v1,0)
    if (%yes == 0) { var %y = 0 }
    elseif (%yes !== 0) { var %y = $numtok(%yes,32) }
    var %no = $iif(%vote_last_no,$v1,0)
    if (%no == 0) { var %n = 0 }
    elseif (%no !== 0) { var %n = $numtok(%no,32) }
    var %t = $calc(%y + %n)
    if (%vote_last) { .msg $chan [ $+ $nick $+ ]: The last vote was. (Yes:  $+ %y $+ ) - (No:  $+ %n $+ ) - (Total Votes:  $+ $iif(%t,$v1,0) $+ ) - (Vote:  $+ %vote_last $+ ) }
    elseif (!%vote_last) { .msg $chan [ $+ $nick $+ ]: There has been NOT any vote made on this channel yet! }
  }
  if ($1 == !myvote) {
    if (!%vote) { .msg $chan [ $+ $nick $+ ]: Error, There is NOT any vote poll available at this time! | return }
    if ($istok(%vote_yes,$nick,32)) { .msg $chan [ $+ $nick $+ ]: You have vote with YES on this vote poll. }
    elseif ($istok(%vote_no,$nick,32)) { .msg $chan [ $+ $nick $+ ]: You have vote with NO on this vote poll. }
    else { .msg $chan [ $+ $nick $+ ]: You have NOT vote for this vote poll until now! }
  }
  if ($1 == !delmyvote) || ($1 == !myvotedel) {
    if (!%vote) { .msg $chan [ $+ $nick $+ ]: Error, There is NOT any vote poll available at this time! | return }
    if ($istok(%vote_yes,$nick,32)) { set -e %vote_yes $remtok(%vote_yes,$nick,1,32) | .msg $chan [ $+ $nick $+ ]: Your vote has been removed from the poll. }
    elseif ($istok(%vote_no,$nick,32)) { set -e %vote_no $remtok(%vote_no,$nick,1,32) | .msg $chan [ $+ $nick $+ ]: Your vote has been removed from this poll. }
    else { .msg $chan [ $+ $nick $+ ]: You have NOT vote for this vote poll until now! }
  }
  if ($1 == !voteleft) {
    if (!%vote) { .msg $chan [ $+ $nick $+ ]: Error, There is NOT any vote poll available at this time! | return }
    var %s = $timer([VOTE_END]).secs
    if (!%s) { .msg $chan [ $+ $nick $+ ]: The vote poll cannot be founded! | return }
    .msg $chan [ $+ $nick $+ ]: The vote poll will expire on  $+ $duration(%s) $+  - (Started on:  $+ $asctime(%vote_on) $+ ) - (By:  $+ %vote_by $+ )
  }
  if ($1 == !votehelp) { .msg $chan [ $+ $nick $+ ]: Vote module channel commands are:  $+ %commands $+  }
}

alias vote_end {
  if (!$1) { return }
  if (!%vote) && (!%vote_by) && (!%vote_on) { return }
  set %vote_last $iif(%vote,%vote,N/A)
  set %vote_last_by $iif(%vote_by,%vote_by,N/A)
  set %vote_last_on $iif(%vote_on,%vote_on,N/A)
  set %vote_last_yes $iif(%vote_yes,%vote_yes,0)
  set %vote_last_no $iif(%vote_no,%vote_no,0)  
  var %yes = $iif(%vote_yes,$v1,0)
  if (%yes == 0) { var %y = 0 }
  elseif (%yes !== 0) { var %y = $numtok(%yes,32) }
  var %no = $iif(%vote_no,$v1,0)
  if (%no == 0) { var %n = 0 }
  elseif (%no !== 0) { var %n = $numtok(%no,32) }
  var %t = $calc(%y + %n)
  if (%n == %y) { var %win Nobody }
  elseif (%y > %n) { var %win = Yes }
  elseif (%n > %y) { var %win = No }
  .msg $1 [VOTE POLL]: The vote poll has been $iif($2 == stop,stopped!,expired!) - (Winner is:  $+ %win $+ )
  .msg $1 [VOTE POLL]: %vote - (Vote Poll Started on:  $+ $asctime(%vote_on) $+ ) - (Vote Poll Started By:  $+ %vote_by $+ )
  .msg $1 [VOTE POLL]: Yes:  $+ %y $+  - No:  $+ %n $+  - Total Votes:  $+ %t $+ 
  unset %vote %vote_by %vote_on %vote_yes %vote_no %vote_sec %vote_expire
}
