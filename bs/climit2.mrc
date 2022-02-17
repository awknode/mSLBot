;================================================
; Channel Limiter (Bot Version)
; Version 1.2 
; Written by: xDaeMoN
; Email: xdaemon@xdaemon.us
; Usage: !climit <on/off/offset/update>  
; Usage: <offset/update> [settings(Must be a number)]
; Note: This is for a bot script & should be configured remotely. 
;================================================

on *:LOAD: {
  if ($version >= 6.16) {
    echo -a 9,1 » »8,1 Channel Limiter (Bot Version) v $+ $cl_version Successfully Loaded. 
    echo -a 9,1 » »8,1 Copyright © 200415,1 xDaeMoN.us 
    echo -a 9,1 » »8,1 Written by: 10,1xDaeMoN 8,1Email: 10,1xdaemon@xdaemon.us 
  }
  else { 
    echo -a 4» » Sorry, this addon requires mIRC 6.16. Please get the latest version from www.mirc.com
    .unload -rs " $+ $script $+ "
  }
}

on *:UNLOAD: {
  .timerclimit* off 
  if ($exists($cldb_file)) .remove $cldb_file 
  echo -a 8,1 » »7,1 Channel Limiter (Bot Version) v $+ $cl_version Unloaded. 
}

alias -l cldb_file { return $+(",$scriptdir,cldb.ini,") }

alias -l cl_version { return 1.2 }

alias -l climit {
  if ($readini($cldb_file,$1,limit) == 1) && ($1 ischan) {
    var %cl = $calc($nick($1,0) + $readini($cldb_file,$1,offset))
    if ($chan($1).limit != %cl) && ($me isop $1) mode $1 +l %cl
  }
}

ON *:JOIN:#: {
  if ($nick == $me) && ($readini($cldb_file,#,limit) == 1) {
    if (!$timer(climit. [ $+ [ # ] ])) .timerclimit. [ $+ [ # ] ] 0 $readini($cldb_file,#,update) climit #
  }
}

ON @!*:MODE:#: {
  if ($readini($cldb_file,#,limit) == 1) {
    if (l isincs $chan(#).mode) && ($2 <= $nick(#,0)) { 
      mode # +l $calc($nick(#,0) + $readini($cldb_file,#,offset))
      ; .notice $nick Do not try to set limits which would endanger the channel. 
    }
  }
}

ON $owner:TEXT:!climit*:#: {
  if ($nick isop $chan) { 
    if ($2) {
      if ($2 == on) { 
        if ($readini($cldb_file,#,limit) != 1) {
          if (!$readini($cldb_file,#,offset)) || (!$readini($cldb_file,#,update)) {
            .notice $nick !climit $iif(!$readini($cldb_file,#,offset),Offset,Update) [settings(Must be a number)] 
            .notice $nick You must fill in the limit $iif(!$readini($cldb_file,#,offset),Offset,Update) before you enable the channel limiter for # $+ .
          }
          else { 
            if ($me isop #) mode $chan +l $calc($nick(#,0) + $readini($cldb_file,#,offset))
            .writeini $cldb_file # limit 1
            .timerclimit. [ $+ [ # ] ] 0 $readini($cldb_file,#,update) climit # 
            .notice $nick ENABLED Channel Limit for $chan $+ .
          }
        }
        else .notice $nick Channel Limit is already ENABLED for # $+ .
      }
      elseif ($2 == off) {
        if ($readini($cldb_file,#,limit) != 0) || ($readini($cldb_file,#,limit)) {
          if ($me isop #)  mode # -l 
          writeini $cldb_file # limit 0 
          .notice $nick DISABLED Channel Limit for $chan $+ .
        }
        else .notice $nick Channel Limit is NOT ENABLED for $chan $+ . 
      }
      elseif ($2 == offset) {
        if ($3) || ($3 isnum) || ($3 > 0) { 
          .writeini $cldb_file # offset $3
          .notice $nick Limit Offset for # set to $+(',$3,',.) 
        }
        else .notice $nick Usage: !climit offset [settings(Must be a number higher than Zero)]
      }
      elseif ($2 == update) {
        if ($3) && ($3 isnum 0-200) { 
          .writeini $cldb_file # update $3
          .notice $nick Limit Update set to $+(',$3,') seconds
          if ($readini($cldb_file,#,limit) == 1) .timerclimit. [ $+ [ # ] ] 0 $3 climit # 
        }
        else .notice $nick Usage: !climit update [seconds(Must be a number from Zero to 200)]
      }
    }
    else { 
      .notice $nick !limit on/off/value/length 
      .notice $nick value/length [settings(Must be a number)] 
    }
  }
}
