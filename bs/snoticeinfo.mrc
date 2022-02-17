on *:LOAD: { 
  write sconnecting.txt
  write sexiting.txt
  write soper.txt
  write skill-bans.txt
  write sothers.txt
}

on ^*:snotice:*:{ 
  if (Client connecting isin $1-) { 
    write sconnecting.txt $date - $time $1- 
    $iif($dialog(sn),loadbuf -or sn 5 sconnecting.txt) 
    haltdef 
    $iif($dialog(sn),did -ra sn 25 $lines(sconnecting.txt))
    $iif($dialog(sn),did -ra sn 30 $calc($lines(sconnecting.txt)+$lines(sexiting.txt)+$lines(soper.txt)+$lines(skill-bans.txt)+$lines(sothers.txt)))
  }
  if (Client exiting isin $1-) { 
    write sexiting.txt $date - $time $1- 
    $iif($dialog(sn),loadbuf -or sn 6 sexiting.txt) 
    haltdef 
    $iif($dialog(sn),did -ra sn 26 $lines(sexiting.txt))
    $iif($dialog(sn),did -ra sn 30 $calc($lines(sconnecting.txt)+$lines(sexiting.txt)+$lines(soper.txt)+$lines(skill-bans.txt)+$lines(sothers.txt)))
  }
  if (is now a isin $1-) { 
    write soper.txt $date - $time $1- 
    $iif($dialog(sn),loadbuf -or sn 7 soper.txt) 
    haltdef 
    $iif($dialog(sn),did -ra sn 27 $lines(soper.txt))
    $iif($dialog(sn),did -ra sn 30 $calc($lines(sconnecting.txt)+$lines(sexiting.txt)+$lines(soper.txt)+$lines(skill-bans.txt)+$lines(sothers.txt)))
  }
  if (Failed isin $1-) { 
    write soper.txt $date - $time $1- 
    $iif($dialog(sn),loadbuf -or sn 7 soper.txt) 
    haltdef 
    $iif($dialog(sn),did -ra sn 27 $lines(soper.txt))
    $iif($dialog(sn),did -ra sn 30 $calc($lines(sconnecting.txt)+$lines(sexiting.txt)+$lines(soper.txt)+$lines(skill-bans.txt)+$lines(sothers.txt)))
  }
  if (Received KILL isin $1-) { 
    write skill-bans.txt $date - $time $1- 
    $iif($dialog(sn),loadbuf -or sn 8 skill-bans.txt) 
    haltdef 
    $iif($dialog(sn),did -ra sn 28 $lines(skill-bans.txt))
    $iif($dialog(sn),did -ra sn 30 $calc($lines(sconnecting.txt)+$lines(sexiting.txt)+$lines(soper.txt)+$lines(skill-bans.txt)+$lines(sothers.txt)))
  }
  if (G:Line isin $1-) { 
    write skill-bans.txt $date - $time $1- 
    $iif($dialog(sn),loadbuf -or sn 8 skill-bans.txt) 
    $iif($dialog(sn),did -ra sn 28 $lines(skill-bans.txt))
    $iif($dialog(sn),did -ra sn 30 $calc($lines(sconnecting.txt)+$lines(sexiting.txt)+$lines(soper.txt)+$lines(skill-bans.txt)+$lines(sothers.txt)))
  }
  if (Z:line isin $1-) { 
    write skill-bans.txt $date - $time $1- 
    $iif($dialog(sn),loadbuf -or sn 8 skill-bans.txt)
    $iif($dialog(sn),did -ra sn 28 $lines(skill-bans.txt))
    $iif($dialog(sn),did -ra sn 30 $calc($lines(sconnecting.txt)+$lines(sexiting.txt)+$lines(soper.txt)+$lines(skill-bans.txt)+$lines(sothers.txt))) 
  }
  if (K:line isin $1-) { 
    write skill-bans.txt $date - $time $1- 
    $iif($dialog(sn),loadbuf -or sn 8 skill-bans.txt) 
    $iif($dialog(sn),did -ra sn 28 $lines(skill-bans.txt))
    $iif($dialog(sn),did -ra sn 30 $calc($lines(sconnecting.txt)+$lines(sexiting.txt)+$lines(soper.txt)+$lines(skill-bans.txt)+$lines(sothers.txt)))
  }
  if (Q-lined isin $1-) { 
    write skill-bans.txt $date - $time $1- 
    $iif($dialog(sn),loadbuf -or sn 8 skill-bans.txt) 
    haltdef 
    $iif($dialog(sn),did -ra sn 28 $lines(skill-bans.txt))
    $iif($dialog(sn),did -ra sn 30 $calc($lines(sconnecting.txt)+$lines(sexiting.txt)+$lines(soper.txt)+$lines(skill-bans.txt)+$lines(sothers.txt)))
  }
  if (WallOps isin $1-) { 
    write sothers.txt $date - $time $1- 
    $iif($dialog(sn),loadbuf -or sn 10 sothers.txt)
    $iif($dialog(sn),did -ra sn 29 $lines(sothers.txt))
    $iif($dialog(sn),did -ra sn 30 $calc($lines(sconnecting.txt)+$lines(sexiting.txt)+$lines(soper.txt)+$lines(skill-bans.txt)+$lines(sothers.txt))) 
  }
  if (HelpOps isin $1-) { 
    write sothers.txt $date - $time $1- 
    $iif($dialog(sn),loadbuf -or sn 10 sothers.txt) 
    $iif($dialog(sn),did -ra sn 29 $lines(sothers.txt))
    $iif($dialog(sn),did -ra sn 30 $calc($lines(sconnecting.txt)+$lines(sexiting.txt)+$lines(soper.txt)+$lines(skill-bans.txt)+$lines(sothers.txt)))
  }
  if (ChatOps isin $1-) { 
    write sothers.txt $date - $time $1- 
    $iif($dialog(sn),loadbuf -or sn 10 sothers.txt) 
    $iif($dialog(sn),did -ra sn 29 $lines(sothers.txt))
    $iif($dialog(sn),did -ra sn 30 $calc($lines(sconnecting.txt)+$lines(sexiting.txt)+$lines(soper.txt)+$lines(skill-bans.txt)+$lines(sothers.txt)))
  }
  if (LocOps isin $1-) { 
    write sothers.txt $date - $time $1- 
    $iif($dialog(sn),loadbuf -or sn 10 sothers.txt) 
    $iif($dialog(sn),did -ra sn 29 $lines(sothers.txt))
    $iif($dialog(sn),did -ra sn 30 $calc($lines(sconnecting.txt)+$lines(sexiting.txt)+$lines(soper.txt)+$lines(skill-bans.txt)+$lines(sothers.txt)))
  }
  if (GlobalOps isin $1-) { 
    write sothers.txt $date - $time $1- 
    $iif($dialog(sn),loadbuf -or sn 10 sothers.txt) 
    $iif($dialog(sn),did -ra sn 29 $lines(sothers.txt))
    $iif($dialog(sn),did -ra sn 30 $calc($lines(sconnecting.txt)+$lines(sexiting.txt)+$lines(soper.txt)+$lines(skill-bans.txt)+$lines(sothers.txt)))
  }
  if (NOOP isin $1-) { 
    write sothers.txt $date - $time $1- 
    $iif($dialog(sn),loadbuf -or sn 10 sothers.txt) 
    haltdef  
    $iif($dialog(sn),did -ra sn 29 $lines(sothers.txt))
    $iif($dialog(sn),did -ra sn 30 $calc($lines(sconnecting.txt)+$lines(sexiting.txt)+$lines(soper.txt)+$lines(skill-bans.txt)+$lines(sothers.txt)))
  }
  if (Jupe isin $1-) { 
    write sothers.txt $date - $time $1- 
    $iif($dialog(sn),loadbuf -or sn 10 sothers.txt) 
    haltdef  
    $iif($dialog(sn),did -ra sn 29 $lines(sothers.txt))
    $iif($dialog(sn),did -ra sn 30 $calc($lines(sconnecting.txt)+$lines(sexiting.txt)+$lines(soper.txt)+$lines(skill-bans.txt)+$lines(sothers.txt)))
  }
  if (No response isin $1-) { 
    write sothers.txt $date - $time $1- 
    $iif($dialog(sn),loadbuf -or sn 10 sothers.txt) 
    haltdef  
    $iif($dialog(sn),did -ra sn 29 $lines(sothers.txt))
    $iif($dialog(sn),did -ra sn 30 $calc($lines(sconnecting.txt)+$lines(sexiting.txt)+$lines(soper.txt)+$lines(skill-bans.txt)+$lines(sothers.txt)))
  }
}

on *:DIALOG:sn:init:0: {
  loadbuf -o sn 5 sconnecting.txt
  loadbuf -o sn 6 sexiting.txt
  loadbuf -o sn 7 soper.txt
  loadbuf -o sn 8 skill-bans.txt
  loadbuf -o sn 10 sothers.txt
  did -ra sn 25 $lines(sconnecting.txt)
  did -ra sn 26 $lines(sexiting.txt)
  did -ra sn 27 $lines(soper.txt)
  did -ra sn 28 $lines(skill-bans.txt)
  did -ra sn 29 $lines(sothers.txt)
  did -ra sn 30 $calc($lines(sconnecting.txt)+$lines(sexiting.txt)+$lines(soper.txt)+$lines(skill-bans.txt)+$lines(sothers.txt))
  did -z sn 5-8,10
}

dialog sn {
  title "SNotices"
  size -1 -1 290 238
  option dbu
  tab "Connecting", 1, 8 4 272 144
  list 5, 16 23 257 120, tab 1 size hsbar vsbar
  tab "Exiting", 2
  list 6, 16 23 257 120, tab 2 size hsbar vsbar
  tab "Oper Notices", 3
  list 7, 16 23 257 120, tab 3 size hsbar vsbar
  tab "Kills/Bans", 4
  list 8, 16 23 257 120, tab 4 size hsbar vsbar
  tab "Others", 9
  list 10, 16 23 257 120, tab 9 size hsbar vsbar
  button "Connecting", 11, 26 160 37 10
  button "Exiting", 12, 66 160 37 10
  button "Oper Notices", 13, 106 160 37 10
  button "Kills/Bans", 14, 146 160 37 10
  button "Others", 15, 186 160 37 10
  button "All", 16, 226 160 37 10
  box "Clear", 17, 8 149 273 28
  box "Stats- Line count", 18, 8 176 273 46
  text "Conneting:", 19, 16 184 50 8, right
  text "Exiting:", 20, 16 194 50 8, right
  text "Oper Notices:", 21, 104 184 50 8, right
  text "Kills/Bans:", 22, 104 194 50 8, right
  text "Others:", 23, 192 184 50 8, right
  text "Total:", 24, 192 194 50 8, right
  edit "", 25, 72 183 25 10, read
  edit "", 26, 72 193 25 10, read
  edit "", 27, 160 183 25 10, read
  edit "", 28, 160 193 25 10, read
  edit "", 29, 248 183 25 10, read
  edit "", 30, 248 193 25 10, read
  button "Say Stats", 31, 106 208 37 10
  button "Echo Stats", 32, 146 208 37 10
  button "Done", 33, 126 224 37 10, ok
}

on *:DIALOG:sn:sclick:11:{ 
  Write -c sconnecting.txt 
  loadbuf -or sn 5 sconnecting.txt
  did -ra sn 25 $lines(sconnecting.txt)
  did -ra sn 30 $calc($lines(sconnecting.txt)+$lines(sexiting.txt)+$lines(soper.txt)+$lines(skill-bans.txt)+$lines(sothers.txt))
}
on *:DIALOG:sn:sclick:12:{ 
  Write -c sexiting.txt 
  loadbuf -or sn 6 sexiting.txt
  did -ra sn 26 $lines(sexiting.txt)
  did -ra sn 30 $calc($lines(sconnecting.txt)+$lines(sexiting.txt)+$lines(soper.txt)+$lines(skill-bans.txt)+$lines(sothers.txt))
}
on *:DIALOG:sn:sclick:13:{ 
  Write -c soper.txt 
  loadbuf -or sn 7 soper.txt
  did -ra sn 27 $lines(soper.txt)
  did -ra sn 30 $calc($lines(sconnecting.txt)+$lines(sexiting.txt)+$lines(soper.txt)+$lines(skill-bans.txt)+$lines(sothers.txt))
}
on *:DIALOG:sn:sclick:14:{ 
  Write -c skill-bans.txt 
  loadbuf -or sn 8 skill-bans.txt
  did -ra sn 28 $lines(skill-bans.txt)
  did -ra sn 30 $calc($lines(sconnecting.txt)+$lines(sexiting.txt)+$lines(soper.txt)+$lines(skill-bans.txt)+$lines(sothers.txt))
}
on *:DIALOG:sn:sclick:15:{ 
  Write -c sothers.txt 
  loadbuf -or sn 10 sothers.txt
  did -ra sn 29 $lines(sothers.txt)
  did -ra sn 30 $calc($lines(sconnecting.txt)+$lines(sexiting.txt)+$lines(soper.txt)+$lines(skill-bans.txt)+$lines(sothers.txt))
}
on *:DIALOG:sn:sclick:16:{ 
  Write -c sconnecting.txt | Write -c sexiting.txt | Write -c soper.txt | Write -c skill-bans.txt | Write -c sothers.txt 
  loadbuf -or sn 5 sconnecting.txt
  loadbuf -or sn 6 sexiting.txt
  loadbuf -or sn 7 soper.txt
  loadbuf -or sn 8 skill-bans.txt
  loadbuf -or sn 10 sothers.txt
  did -ra sn 25 $lines(sconnecting.txt)
  did -ra sn 26 $lines(sexiting.txt)
  did -ra sn 27 $lines(soper.txt)
  did -ra sn 28 $lines(skill-bans.txt)
  did -ra sn 29 $lines(sothers.txt)
  did -ra sn 30 $calc($lines(sconnecting.txt)+$lines(sexiting.txt)+$lines(soper.txt)+$lines(skill-bans.txt)+$lines(sothers.txt))
}
on *:DIALOG:sn:sclick:31:{ 
  msg $active 4*** 12My snotices logs stats 4*** 
  msg $active Connecting Logs: $lines(sconnecting.txt) lines.
  msg $active Exiting Logs: $lines(sexiting.txt) lines.
  msg $active Oper Notice Logs: $lines(soper.txt) lines.
  msg $active Kills/Bans Logs: $lines(skill-bans.txt) lines.
  msg $active Other SNotice Logs: $lines(sothers.txt) lines.
  msg $active All SNotice Logs: $calc($lines(sconnecting.txt)+$lines(sexiting.txt)+$lines(soper.txt)+$lines(skill-bans.txt)+$lines(sothers.txt)) lines.
}
on *:DIALOG:sn:sclick:32:{
  echo -a 4*** 12My snotices logs stats 4*** 
  echo -a Connecting Logs: $lines(sconnecting.txt) lines.
  echo -a Exiting Logs: $lines(sexiting.txt) lines.
  echo -a Oper Notice Logs: $lines(soper.txt) lines.
  echo -a Kills/Bans Logs: $lines(skill-bans.txt) lines.
  echo -a Other SNotice Logs: $lines(sothers.txt) lines.
  echo -a All SNotice Logs: $calc($lines(sconnecting.txt)+$lines(sexiting.txt)+$lines(soper.txt)+$lines(skill-bans.txt)+$lines(sothers.txt)) lines.
}

menu channel,menubar,query,status {
  $iif(o isin $usermode,IRCOP Snotices):/Dialog -md sn sn
}
