on *:LOAD: {
  if ($readini($qt($scriptdirbongrips.ini), bongrips, totalbongrips)) {
    if ($readini($qt($scriptdirbongrips.ini), hotkey, f_key1) || $readini($qt($scriptdirbongrips.ini), hotkey, f_key2)) || ($readini($qt($scriptdirbongrips.ini), hotkey, f_keys) == off) && ($readini($qt($scriptdirbongrips.ini), hotkey, f_keys) != on) { echo -a $_brmsgs(load) }
    else { echo -a $_brmsgs(load) | .timerbrhotkey 1 1 _setbrhotkey }
  }
  else {
    if ($readini($qt($scriptdirbongrips.ini), hotkey, f_key1) || $readini($qt($scriptdirbongrips.ini), hotkey, f_key2)) || ($readini($qt($scriptdirbongrips.ini), hotkey, f_keys) == off) && ($readini($qt($scriptdirbongrips.ini), hotkey, f_keys) != on) { echo -a $_brmsgs(load) | _brupdate }
    else {
      echo -a $_brmsgs(load)
      _brupdate
      .timerbrhotkey 1 1 _setbrhotkey
    }
  }
}

on *:UNLOAD: { echo -a $_brmsgs(unload) }

on *:START: {
  if ($readini($qt($scriptdirbongrips.ini), bongrips, totalbongrips)) { .timer_brs 1 15 _brstart }
}

on *:TEXT:*:#:{
  if (%_brnick) {
    if ($nick == %_brnick) {
      if ($1 == y || $1 == yes) && ($2 == $me) {
        ; msg $chan Sending "bongrips.mrc"
        ; DCC send %_brnick " $+ $scriptdir $+ \bongrips.mrc"
        unset %_brnick
      }
    }
  }
  if ($1 == !bongrips) {
    if (!$2) {
      _brspam
      if ($readini($qt($scriptdirbongrips.ini), bongrips, totalbongrips)) && ($readini($qt($scriptdirbongrips.ini), bongrips, currentbongrips)) {
        if ($readini($qt($scriptdirbongrips.ini), bongrips, currentbongrips) == 1) {
          if ($readini($qt($scriptdirbongrips.ini), bongrips, totalbongrips) == 1) { msg $chan According to my bongbase, I have taken9 $readini($qt($scriptdirbongrips.ini), bongrips, currentbongrips) bong rip during this IRC session, and a total of9 $readini($qt($scriptdirbongrips.ini), bongrips, totalbongrips) whole bong rips since this script was loaded. }
          else { msg $chan According to my Dank-a-Base, I have taken9 $readini($qt($scriptdirbongrips.ini), bongrips, currentbongrips) bong rip during this IRC session, and9 $readini($qt($scriptdirbongrips.ini), bongrips, totalbongrips) total bong rips since this script was loaded. }
        }
        else { msg $chan According to my Dank-a-Base, I have taken9 $readini($qt($scriptdirbongrips.ini), bongrips, currentbongrips) bong rips during this IRC session, and9 $readini($qt($scriptdirbongrips.ini), bongrips, totalbongrips) total bong rips since this script was loaded. }
      }
      elseif ($readini($qt($scriptdirbongrips.ini), bongrips, totalbongrips)) && ($readini($qt($scriptdirbongrips.ini), bongrips, currentbongrips) == $null || $readini($qt($scriptdirbongrips.ini), bongrips, currentbongrips) == 0) {
        if ($readini($qt($scriptdirbongrips.ini), bongrips, totalbongrips) == 1) { msg $chan According to my Dank-a-Base, I have taken9 0 bong rips during this IRC session, and a total of9 $readini($qt($scriptdirbongrips.ini), bongrips, totalbongrips) whole bong rip since this script was loaded. }
        else { msg $chan According to my Dank-a-Base, I have taken9 0 bong rips during this IRC session, and9 $readini($qt($scriptdirbongrips.ini), bongrips, totalbongrips) total bong rips since this script was loaded. }
      }
      elseif ($readini($qt($scriptdirbongrips.ini), bongrips, currentbongrips)) && ($readini($qt($scriptdirbongrips.ini), bongrips, totalbongrips) == $null || $readini($qt($scriptdirbongrips.ini), bongrips, totalbongrips) == 0) {
        if ($readini($qt($scriptdirbongrips.ini), bongrips, currentbongrips) == 1) { msg $chan According to my Dank-a-Base, I have taken9 $readini($qt($scriptdirbongrips.ini), bongrips, currentbongrips) bong rip during this IRC session, and a total of9 0 whole bong rips since this script was loaded. What a fag. }
        else { msg $chan According to my Dank-a-Base, I have taken9 $readini($qt($scriptdirbongrips.ini), bongrips, currentbongrips) bong rips during this IRC session, and a total of9 0 whole bong rips since this script was loaded. What a fag. }
      }
      else { msg $chan According to my Dank-a-Base, I have taken9 0 bong rips during this IRC session, and a total of9 0 whole bong rips since this script was loaded. ...Wow I suck. 9<BongRip Script v $+ $_brinfo(version) $+ 9> }
    }
  }
  elseif ($1 == !bongme) {
    if (!$2) {
      _brspam
      set %_brnick $nick
      notice %_brnick %_brnick $+ , do u want a copy of BongRip Script v $+ $_brinfo(version) $+ ? (If yes, say "yes/y and my nick" in the channel within the next 2 mins.)
      .timerbrunset 1 120 unset %_brnick
    }
  }
}

;-------------;
;   Aliases   ;
;-------------;

alias rip {
  if ($1-) {
    if ($readini($qt($scriptdirbongrips.ini), bongrips, currentbongrips)) {
      writeini $qt($scriptdirbongrips.ini) bongrips currentbongrips $calc($readini($qt($scriptdirbongrips.ini), bongrips, currentbongrips) + 1)
      writeini $qt($scriptdirbongrips.ini) bongrips totalbongrips $calc($readini($qt($scriptdirbongrips.ini), bongrips, totalbongrips) + 1)
      writeini $qt($scriptdirbongrips.ini) strains $replace($1-,$chr(32),$chr(46)) $calc($readini($qt($scriptdirbongrips.ini), strains, $replace($1-,$chr(32),$chr(46))) + 1)
      describe $active takes a nice fat bong rip of $1- $+ . That makes it9 $readini($qt($scriptdirbongrips.ini), bongrips, currentbongrips) times I have ripped my bong during this IRC session.
    }
    else {
      writeini $qt($scriptdirbongrips.ini) bongrips currentbongrips $calc($readini($qt($scriptdirbongrips.ini), bongrips, currentbongrips) + 1)
      writeini $qt($scriptdirbongrips.ini) bongrips totalbongrips $calc($readini($qt($scriptdirbongrips.ini), bongrips, totalbongrips) + 1)
      writeini $qt($scriptdirbongrips.ini) strains $replace($1-,$chr(32),$chr(46)) $calc($readini($qt($scriptdirbongrips.ini), strains, $replace($1-,$chr(32),$chr(46))) + 1)
      describe $active takes a nice fat bong rip of $1- $+ . That makes it9 $readini($qt($scriptdirbongrips.ini), bongrips, currentbongrips) time I have ripped my bong during this IRC session.
    }
  }
  else {
    if ($readini($qt($scriptdirbongrips.ini), bongrips, currentbongrips)) {
      writeini $qt($scriptdirbongrips.ini) bongrips currentbongrips $calc($readini($qt($scriptdirbongrips.ini), bongrips, currentbongrips) + 1)
      writeini $qt($scriptdirbongrips.ini) bongrips totalbongrips $calc($readini($qt($scriptdirbongrips.ini), bongrips, totalbongrips) + 1)
      writeini $qt($scriptdirbongrips.ini) strains regular.hit $calc($readini($qt($scriptdirbongrips.ini), strains, regular.hit) + 1)
      describe $active takes a nice fat bong rip. That makes it9 $readini($qt($scriptdirbongrips.ini), bongrips, currentbongrips) times I have ripped my bong during this IRC session.
    }
    else {
      writeini $qt($scriptdirbongrips.ini) bongrips currentbongrips $calc($readini($qt($scriptdirbongrips.ini), bongrips, currentbongrips) + 1)
      writeini $qt($scriptdirbongrips.ini) bongrips totalbongrips $calc($readini($qt($scriptdirbongrips.ini), bongrips, totalbongrips) + 1)
      writeini $qt($scriptdirbongrips.ini) strains regular.hit $calc($readini($qt($scriptdirbongrips.ini), strains, regular.hit) + 1)
      describe $active takes a nice fat bong rip. That makes it9 $readini($qt($scriptdirbongrips.ini), bongrips, currentbongrips) time I have ripped my bong during this IRC session.
    }
  }
}

alias rips {
  if ($readini($qt($scriptdirbongrips.ini), bongrips, totalbongrips)) && ($readini($qt($scriptdirbongrips.ini), bongrips, currentbongrips)) {
    if ($readini($qt($scriptdirbongrips.ini), bongrips, currentbongrips) == 1) {
      if ($readini($qt($scriptdirbongrips.ini), bongrips, totalbongrips) == 1) { msg $active According to my Dank-a-Base, I have taken9 $readini($qt($scriptdirbongrips.ini), bongrips, currentbongrips) bong rip during this IRC session, and a total of9 $readini($qt($scriptdirbongrips.ini), bongrips, totalbongrips) whole bong rip since this script was loaded. }
      else { msg $active According to my Dank-a-Base, I have taken9 $readini($qt($scriptdirbongrips.ini), bongrips, currentbongrips) bong rip during this IRC session, and9 $readini($qt($scriptdirbongrips.ini), bongrips, totalbongrips) total bong rips since this script was loaded. }
    }
    else { msg $active According to my Dank-a-Base, I have taken9 $readini($qt($scriptdirbongrips.ini), bongrips, currentbongrips) bong rips during this IRC session, and9 $readini($qt($scriptdirbongrips.ini), bongrips, totalbongrips) total bong rips since this script was loaded. }
  }
  elseif ($readini($qt($scriptdirbongrips.ini), bongrips, totalbongrips)) && ($readini($qt($scriptdirbongrips.ini), bongrips, currentbongrips) == $null || $readini($qt($scriptdirbongrips.ini), bongrips, currentbongrips) == 0) {
    if ($readini($qt($scriptdirbongrips.ini), bongrips, totalbongrips) == 1) { msg $active According to my Dank-a-Base, I have taken9 0 bong rips during this IRC session, and a total of9 $readini($qt($scriptdirbongrips.ini), bongrips, totalbongrips) whole bong rip since this script was loaded. }
    else { msg $active According to my Dank-a-Base, I have taken9 0 bong rips during this IRC session, and9 $readini($qt($scriptdirbongrips.ini), bongrips, totalbongrips) total bong rips since this script was loaded. }
  }
  elseif ($readini($qt($scriptdirbongrips.ini), bongrips, currentbongrips)) && ($readini($qt($scriptdirbongrips.ini), bongrips, totalbongrips) == $null || $readini($qt($scriptdirbongrips.ini), bongrips, totalbongrips) == 0) {
    if ($readini($qt($scriptdirbongrips.ini), bongrips, currentbongrips) == 1) { msg $active According to my Dank-a-Base, I have taken9 $readini($qt($scriptdirbongrips.ini), bongrips, currentbongrips) bong rip during this IRC session, and a total of9 0 whole bong rips since this script was loaded. ...Wait wtf?! }
    else { msg $active According to my Dank-a-Base, I have taken9 $readini($qt($scriptdirbongrips.ini), bongrips, currentbongrips) bong rips during this IRC session, and a total of9 0 whole bong rips since this script was loaded. ...Wait wtf?! }
  }
  else { msg $active According to my Dank-a-Base, I have taken9 0 bong rips during this IRC session, and a total of9 0 whole bong rips since this script was loaded. ...Wow I suck. }
}

alias strains { echo -a $readini($qt($scriptdirbongrips.ini),strains,0) }

alias bong {
  msg $active 0,0_______________15,14}}0,0______________
  msg $active 0,0______________15,14}}}0,0______________
  msg $active 0,0_____________15,14}}}0,0_______________
  msg $active 0,0____________15,14{{{{{{0,0_____________
  msg $active 0,0__________2,12OOOOOOO0,0___________
  msg $active 0,0__________2,12OOOOOOO0,0___________
  msg $active 0,0__________2,12OOOOOOO0,0___________
  msg $active 0,0__________2,12OOOOOOO0,0___________
  msg $active 0,0__________2,12OOOOOOO0,0___________
  msg $active 0,0__________2,12OOOOOOO0,0___________
  msg $active 0,0__________2,12OOOOOOO0,0___________
  msg $active 0,0__________2,12OOOOOOO0,0___________
  msg $active 0,0__________2,12OOOOOOO0,0___________
  msg $active 0,0__________2,12OOOOOOO0,0___________
  msg $active 0,0__________2,12OOOOOOO0,0___________
  msg $active 0,0__________2,12OOOOOOO0,0______15,14}0,0____
  msg $active 0,0__________2,12OOOOOOO0,0_____15,14{{0,0____
  msg $active 0,0__________2,12OOOOOOO0,0_____9,3(..)0,0___
  msg $active 0,0__________2,12OOOOOOO0,0_____2,12%0,0____
  msg $active 0,0__________2,12OOOOOOO0,0____2,12%0,0_____
  msg $active 0,0__________2,12OOOOOOO0,0___2,12%0,0______
  msg $active 0,0________2,12OOOOOOOOOO%0,0_______
  msg $active 0,0_______2,12OOOOOOOOOOOO0,0_______
  msg $active 0,0______2,12OOOOOOOOOOOOOO0,0______
  msg $active 0,0_____2,12OOOOOOOOOOOOOOO0,0______
  msg $active 0,0_____2,12OOOOOOOOOOOOOOO0,0______
  msg $active 0,0______2,12OOOOOOOOOOOOOO0,0______
  msg $active 0,0_______2,12OOOOOOOOOOOO0,0_______
  msg $active 0,0________2,12OOOOOOOOOO0,0________
}

alias -l _brinfo {
  if ($1 == status) return 3<9BongRipStatus3>
  if ($1 == version) return 3.2
}

alias -l _brmsgs {
  if ($1 == load) return $_brinfo(status) bongrips loaded.
  if ($1 == unload) return $_brinfo(status) bongrips unloaded.
}

alias -l _brmenuhit {
  if (%_brstrain) {
    rip %_brstrain
    unset %_brstrain
  }
  else {
    rip
    unset %_brstrain
  }
}

alias -l _brupdate {
  if (%totalbongrips) {
    echo -a $_brinfo(status) Past sessions found from last version9! $_brinfo(status)
    writeini $qt($scriptdirbongrips.ini) bongrips currentbongrips %bongrips
    writeini $qt($scriptdirbongrips.ini) bongrips totalbongrips %totalbongrips
    unset %bongrips
    unset %totalbongrips      
  }
}

alias -l _brstart {
  if ($readini($qt($scriptdirbongrips.ini), bongrips, currentbongrips)) {
    echo -a $_brinfo(status) BongRip Script Updating9! $_brinfo(status)
    .timerbrstart1 1 1 echo -s Total BongRips =9 $readini($qt($scriptdirbongrips.ini), bongrips, totalbongrips) 
    .timerbrstart2 1 2 echo -s Last Session's BongRips =9 $readini($qt($scriptdirbongrips.ini), bongrips, currentbongrips) 
    .timerbrstart3 1 3 echo -s Reseting Current Bongrips to9 0.
    remini $qt($scriptdirbongrips.ini) bongrips currentbongrips
    writeini $qt($scriptdirbongrips.ini) bongrips currentbongrips 0
    .timerbrstart4 1 4 echo -s Done.
  }
  else {
    echo -a $_brinfo(status) BongRip Script Updating9! $_brinfo(status)
    .timerbrstart1 1 1 echo -s Total BongRips =9 $readini($qt($scriptdirbongrips.ini), bongrips, totalbongrips) 
    .timerbrstart2 1 2 echo -s Last Session's BongRips  = 9No session found.
    .timerbrstart3 1 3 echo -s Setting Current Bongrips to9 0.
    remini $qt($scriptdirbongrips.ini) bongrips currentbongrips
    writeini $qt($scriptdirbongrips.ini) bongrips currentbongrips 0
    .timerbrstart4 1 4 echo -s Done.
  }
}

alias -l _setbrhotkey {
  if ($input(Do you want to set a Function Key(f1-f9,f0) for taking rips?,y,BongRip Script v $+ $_brinfo(version))) {
    set %_setbrhotkey $$?="Enter your Function Key (Example: f8) $crlf $+ Warning: Won't work if entered different then Example!"
    writeini $qt($scriptdirbongrips.ini) hotkey f_key1 %_setbrhotkey
    alias %_setbrhotkey /rip
    unset %_setbrhotkey
  }
  if ($input(Do you want to set a Function Key(f1-f9,f0) for showing rips taken?,y,BongRip Script v $+ $_brinfo(version))) {
    set %_setbrhotkey2 $$?="Enter your Function Key (Example: f9) $crlf $+ Warning: Won't work if entered different then Example!"
    writeini $qt($scriptdirbongrips.ini) hotkey f_key2 %_setbrhotkey2
    alias %_setbrhotkey2 /rips
    unset %_setbrhotkey2
  }
  else {
    if ($input(Do you want these Questions asked again?,y,BongRip Script v $+ $_brinfo(version))) { writeini $qt($scriptdirbongrips.ini) hotkey f_keys on }
    else { writeini $qt($scriptdirbongrips.ini) hotkey f_keys off }
  }
}

alias -l _brdelcurrent {
  if ($readini($qt($scriptdirbongrips.ini), bongrips, currentbongrips)) {
    if ($input(Are you sure?,y,BongRip Script v $+ $_brinfo(version))) {
      remini $qt($scriptdirbongrips.ini) bongrips currentbongrips
      writeini $qt($scriptdirbongrips.ini) bongrips currentbongrips 0
      echo -a $_brinfo(status) Current BongRips Cleared9. $_brinfo(status)
    }
    else { echo -a $_brinfo(status) Current BongRips Unchanged9. $_brinfo(status) }
  }
  else { echo -a You have 9NO Current BongRips to clear. }
}

alias -l _brdeltotal {
  if ($readini($qt($scriptdirbongrips.ini), bongrips, totalbongrips)) {
    if ($input(Are you sure?,y,BongRip Script v $+ $_brinfo(version))) {
      remini $qt($scriptdirbongrips.ini) bongrips totalbongrips
      writeini $qt($scriptdirbongrips.ini) bongrips totalbongrips 0
      echo -a $_brinfo(status) Total BongRips Cleared9. $_brinfo(status)
    }
    else { echo -a $_brinfo(status) Total BongRips Unchanged9. $_brinfo(status) }
  }
  else { echo -a You have 9NO Total BongRips to clear. }
}

alias -l _brdelall {
  if ($input(Are you sure?,y,BongRip Script v $+ $_brinfo(version))) {
    if ($readini($qt($scriptdirbongrips.ini), bongrips, currentbongrips)) {
      remini $qt($scriptdirbongrips.ini) bongrips currentbongrips
      writeini $qt($scriptdirbongrips.ini) bongrips currentbongrips 0
      echo -a $_brinfo(status) Current BongRips Cleared9. $_brinfo(status)
    }
    else {
      echo -a You have 9NO Current BongRips to clear.
    }
    if ($readini($qt($scriptdirbongrips.ini), bongrips, totalbongrips)) {
      remini $qt($scriptdirbongrips.ini) bongrips totalbongrips
      writeini $qt($scriptdirbongrips.ini) bongrips totalbongrips 0
      echo -a $_brinfo(status) Total BongRips Cleared9. $_brinfo(status)
    }
    else {
      echo -a You have 9NO Total BongRips to clear.
    }
  }
  else { echo -a $_brinfo(status) All BongRips Unchanged9. $_brinfo(status) }
}

alias -l _brchangekey1 {
  if ($readini($qt($scriptdirbongrips.ini), hotkey, f_key1)) {
    if ($readini($qt($scriptdirbongrips.ini), hotkey, f_key1) != off) {
      if ($readini($qt($scriptdirbongrips.ini), hotkey, f_key1) != on) {
        set %newf_key1 $$?="Enter New ''Take Hit'' Hotkey. (Example: f8) $crlf $+ Warning: Won't work if entered different then Example!"
        set %oldf_key1 $readini($qt($scriptdirbongrips.ini), hotkey, f_key1)
        writeini $qt($scriptdirbongrips.ini) hotkey f_key1 %newf_key1
        alias %oldf_key1
        alias %newf_key1 /rip
        echo -a $_brinfo(status) Hotkey1 Is Now Changed To %newf_key1 $+ 9. $_brinfo(status)
        unset %oldf_key1
        unset %newf_key1
      }
      else {
        set %newf_key1 $$?="Enter ''Take Hit'' Hotkey. (Example: f8) $crlf $+ Warning: Won't work if entered different then Example!"
        writeini $qt($scriptdirbongrips.ini) hotkey f_key1 %newf_key1
        alias %newf_key1 /rip
        echo -a $_brinfo(status) Hotkey1 Is Now Set To %newf_key1 $+ 9. $_brinfo(status)
        unset %newf_key1
      }
    }
    else {
      if ($input(This Hotkey is turned off. Turn it on?,y,BongRip Script v $+ $_brinfo(version))) {
        writeini $qt($scriptdirbongrips.ini) hotkey f_key1 on
        echo -a $_brinfo(status) Hotkey1 Is Now On9. $_brinfo(status)
      }
    }
  }
  else {
    set %newf_key1 $$?="Enter ''Take Hit'' Hotkey. (Example: f8) $crlf $+ Warning: Won't work if entered different then Example!"
    writeini $qt($scriptdirbongrips.ini) hotkey f_key1 %newf_key1
    alias %newf_key1 /rip
    echo -a $_brinfo(status) Hotkey1 Is Now Set To %newf_key1 $+ 9. $_brinfo(status)
    unset %newf_key1
  }
}

alias -l _brchangekey2 {
  if ($readini($qt($scriptdirbongrips.ini), hotkey, f_key2)) {
    if ($readini($qt($scriptdirbongrips.ini), hotkey, f_key2) != off) {
      if ($readini($qt($scriptdirbongrips.ini), hotkey, f_key2) != on) {
        set %newf_key2 $$?="Enter New ''Show Hits'' Hotkey. (Example: f9) $crlf $+ Warning: Won't work if entered different then Example!"
        set %oldf_key2 $readini($qt($scriptdirbongrips.ini), hotkey, f_key2)
        writeini $qt($scriptdirbongrips.ini) hotkey f_key2 %newf_key2
        alias %oldf_key2
        alias %newf_key2 /rips
        echo -a $_brinfo(status) Hotkey2 Is Now Changed To %newf_key2 $+ 9. $_brinfo(status)
        unset %oldf_key2
        unset %newf_key2
      }
      else {
        set %newf_key2 $$?="Enter ''Show Hits'' Hotkey. (Example: f9) $crlf $+ Warning: Won't work if entered different then Example!"
        writeini $qt($scriptdirbongrips.ini) hotkey f_key2 %newf_key2
        alias %newf_key2 /rips
        echo -a $_brinfo(status) Hotkey2 Is Now Set To %newf_key2 $+ 9. $_brinfo(status)
        unset %newf_key2
      }
    }
    else {
      if ($input(This Hotkey is turned off. Turn it on?,y,BongRip Script v $+ $_brinfo(version))) {
        writeini $qt($scriptdirbongrips.ini) hotkey f_key2 on
        echo -a $_brinfo(status) Hotkey2 Is Now On9. $_brinfo(status)
      }
    }
  }
  else {
    set %newf_key2 $$?="Enter ''Show Hits'' Hotkey. (Example: f9) $crlf $+ Warning: Won't work if entered different then Example!"
    writeini $qt($scriptdirbongrips.ini) hotkey f_key2 %newf_key2
    alias %newf_key2 /rips
    echo -a $_brinfo(status) Hotkey2 Is Now Set To %newf_key2 $+ 9. $_brinfo(status)
    unset %newf_key2
  }
}

alias -l _brdelkey1 {
  if ($readini($qt($scriptdirbongrips.ini), hotkey, f_key1)) {
    if ($readini($qt($scriptdirbongrips.ini), hotkey, f_key1) != off) {
      if ($readini($qt($scriptdirbongrips.ini), hotkey, f_key1) != on) {
        set %oldf_key1 $readini($qt($scriptdirbongrips.ini), hotkey, f_key1)
        writeini $qt($scriptdirbongrips.ini) hotkey f_key1 on
        alias %oldf_key1
        unset %oldf_key1
        echo -a $_brinfo(status) Hotkey1 Is Now Removed9. $_brinfo(status)
      }
      else { echo -a $_brinfo(status) Hotkey1 Is Not Set9. $_brinfo(status) }
    }
    else { echo -a $_brinfo(status) Hotkey1 Is Currently Off9. $_brinfo(status) }
  }
  else { echo -a $_brinfo(status) Hotkey1 Is Not Set9. $_brinfo(status) }
}

alias -l _brdelkey2 {
  if ($readini($qt($scriptdirbongrips.ini), hotkey, f_key2)) {
    if ($readini($qt($scriptdirbongrips.ini), hotkey, f_key2) != off) {
      if ($readini($qt($scriptdirbongrips.ini), hotkey, f_key2) != on) {
        set %oldf_key2 $readini($qt($scriptdirbongrips.ini), hotkey, f_key2)
        writeini $qt($scriptdirbongrips.ini) hotkey f_key2 on
        alias %oldf_key2
        unset %oldf_key2
        echo -a $_brinfo(status) Hotkey2 Is Now Removed9. $_brinfo(status)
      }
      else { echo -a $_brinfo(status) Hotkey2 Is Not Set9. $_brinfo(status) }
    }
    else { echo -a $_brinfo(status) Hotkey2 Is Currently Off9. $_brinfo(status) }
  }
  else { echo -a $_brinfo(status) Hotkey2 Is Not Set9. $_brinfo(status) }
}

alias -l _brhkon {
  if ($readini($qt($scriptdirbongrips.ini), hotkey, f_key1)) {
    if ($readini($qt($scriptdirbongrips.ini), hotkey, f_key1) != off) {
      if ($readini($qt($scriptdirbongrips.ini), hotkey, f_key1) != on) {
        echo -a $_brinfo(status) Hotkey1 Is Already On & Set9. $_brinfo(status)
      }
      else { echo -a $_brinfo(status) Hotkey1 Is Already On9. $_brinfo(status) }
    }
    else {
      writeini $qt($scriptdirbongrips.ini) hotkey f_key1 on
      echo -a $_brinfo(status) Hotkey1 Is Now On9. $_brinfo(status)
    }
  }
  else {
    writeini $qt($scriptdirbongrips.ini) hotkey f_key1 on
    echo -a $_brinfo(status) Hotkey1 Is Now On9. $_brinfo(status)
  }
  if ($readini($qt($scriptdirbongrips.ini), hotkey, f_key2)) {
    if ($readini($qt($scriptdirbongrips.ini), hotkey, f_key2) != off) {
      if ($readini($qt($scriptdirbongrips.ini), hotkey, f_key2) != on) {
        echo -a $_brinfo(status) Hotkey2 Is Already On & Set9. $_brinfo(status)
      }
      else { echo -a $_brinfo(status) Hotkey2 Is Already On9. $_brinfo(status) }
    }
    else {
      writeini $qt($scriptdirbongrips.ini) hotkey f_key2 on
      echo -a $_brinfo(status) Hotkey2 Is Now On9. $_brinfo(status)
    }
  }
  else {
    writeini $qt($scriptdirbongrips.ini) hotkey f_key2 on
    echo -a $_brinfo(status) Hotkey2 Is Now On9. $_brinfo(status)
  }
}

alias -l _brhkoff {
  if ($readini($qt($scriptdirbongrips.ini), hotkey, f_key1)) {
    if ($readini($qt($scriptdirbongrips.ini), hotkey, f_key1) != off) {
      if ($readini($qt($scriptdirbongrips.ini), hotkey, f_key1) != on) {
        set %oldf_key1 $readini($qt($scriptdirbongrips.ini), hotkey, f_key1)
        writeini $qt($scriptdirbongrips.ini) hotkey f_key1 off
        alias %oldf_key1
        unset %oldf_key1
        echo -a $_brinfo(status) Hotkey1 Is Now Off9. $_brinfo(status)
      }
      else {
        set %oldf_key1 $readini($qt($scriptdirbongrips.ini), hotkey, f_key1)
        writeini $qt($scriptdirbongrips.ini) hotkey f_key1 off
        alias %oldf_key1
        unset %oldf_key1
        echo -a $_brinfo(status) Hotkey1 Is Now Off9. $_brinfo(status)
      }
    }
    else { echo -a $_brinfo(status) Hotkey1 Is Already Off9. $_brinfo(status) }
  }
  else {
    writeini $qt($scriptdirbongrips.ini) hotkey f_key1 off
    echo -a $_brinfo(status) Hotkey1 Is Now On9. $_brinfo(status)
  }
  if ($readini($qt($scriptdirbongrips.ini), hotkey, f_key2)) {
    if ($readini($qt($scriptdirbongrips.ini), hotkey, f_key2) != off) {
      if ($readini($qt($scriptdirbongrips.ini), hotkey, f_key2) != on) {
        set %oldf_key2 $readini($qt($scriptdirbongrips.ini), hotkey, f_key2)
        writeini $qt($scriptdirbongrips.ini) hotkey f_key2 off
        alias %oldf_key2
        unset %oldf_key2
        echo -a $_brinfo(status) Hotkey2 Is Now Off9. $_brinfo(status)
      }
      else {
        set %oldf_key2 $readini($qt($scriptdirbongrips.ini), hotkey, f_key2)
        writeini $qt($scriptdirbongrips.ini) hotkey f_key2 off
        alias %oldf_key2
        unset %oldf_key2
        echo -a $_brinfo(status) Hotkey2 Is Now Off9. $_brinfo(status)
      }
    }
    else { echo -a $_brinfo(status) Hotkey2 Is Already Off9. $_brinfo(status) }
  }
  else {
    writeini $qt($scriptdirbongrips.ini) hotkey f_key2 off
    echo -a $_brinfo(status) Hotkey2 Is Now On9. $_brinfo(status)
  }
}

alias -l _brmenucount {
  if ($readini($qt($scriptdirbongrips.ini), bongrips, currentbongrips) == $null) && ($readini($qt($scriptdirbongrips.ini), bongrips, totalbongrips) == $null) { return 0]/t[0 }
  if ($readini($qt($scriptdirbongrips.ini), bongrips, currentbongrips) == $null) { return 0]/t[ $+ $readini($qt($scriptdirbongrips.ini), bongrips, totalbongrips) }
  if ($readini($qt($scriptdirbongrips.ini), bongrips, totalbongrips) == $null) { return $readini($qt($scriptdirbongrips.ini), bongrips, currentbongrips) $+ ]/t[0 }
  else { return $readini($qt($scriptdirbongrips.ini), bongrips, currentbongrips) $+ ]/t[ $+ $readini($qt($scriptdirbongrips.ini), bongrips, totalbongrips) }
}

alias -l _brhkrip {
  if ($readini($qt($scriptdirbongrips.ini), hotkey, f_key1) == $null) || ($readini($qt($scriptdirbongrips.ini), hotkey, f_key1) == on) { return Unset }
  if ($readini($qt($scriptdirbongrips.ini), hotkey, f_key1) == off) { return Off }
  else { return $readini($qt($scriptdirbongrips.ini), hotkey, f_key1) }
}

alias -l _brhkrips {
  if ($readini($qt($scriptdirbongrips.ini), hotkey, f_key2) == $null) || ($readini($qt($scriptdirbongrips.ini), hotkey, f_key2) == on) { return Unset }
  if ($readini($qt($scriptdirbongrips.ini), hotkey, f_key2) == off) { return Off }
  else { return $readini($qt($scriptdirbongrips.ini), hotkey, f_key2) }
}

alias -l _brspam {
  if ($($+(%,_brspam.,$nick),2) == $null) set -u5 $($+(%,_brspam.,$nick)) 0
  inc $($+(%,_brspam.,$nick))
  if ($($+(%,_brspam.,$nick),2) >= 3) {
    if ($me isop $chan) {
      ban -ku20 $chan $nick 3 Don't Abuse The Trigger <20sec Timeout>
      timerbrspam 1 1 msg $chan  $+ $nick $+  has been put on a 20 second timeout.
      halt
    }
    else {
      msg $chan Stop Spamming Dick.
      halt
    }
  }
}

;------------------;
;   Channel Menu   ;
;------------------;

menu channel {
  BongRips
  .Take A Nice Fat BongRip:set %_brstrain $?="Enter strain/kind of hit or click Cancel to take Regular Hit." | _brmenuhit
  .Show BongRips Taken c[ $+ $_brmenucount $+ ]:rips
  .Show Teh Nice Big Blue Bong:bong
  .Edit Hot Keys
  ..Change/Set "Take Hit" Hotkey[ $+ $_brhkrip $+ ]:_brchangekey1
  ..Change/Set "Show Hits" Hotkey[ $+ $_brhkrips $+ ]:_brchangekey2
  ..Remove "Take Hit" Hotkey[ $+ $_brhkrip $+ ]:_brdelkey1
  ..Remove "Show Hits" Hotkey[ $+ $_brhkrips $+ ]:_brdelkey2
  ..Remove Both Hotkeys[ $+ $_brhkrip $+ / $+ $_brhkrips $+ ]:_brdelkey1 | _brdelkey2
  ..Turn On Hotkeys:_brhkon
  ..Turn Off Hotkeys:_brhkoff
  .Clear Your BongRips
  ..Clear Current BongRips:_brdelcurrent
  ..Clear Total BongRips:_brdeltotal
  ..Clear All BongRips:_brdelall
  .About:describe $active is using: $_brmsgs(about)
}
