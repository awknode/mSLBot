on 1:start: {
  if (!$hget(protection)) { hmake protection 20 }
  if ($exists(protection.hsh)) { hload protection protection.hsh } 
}
on *:exit: { 
  if ($hget(protection)) { hsave -o protection protection.hsh }
}
on *:disconnect: { 
  if ($hget(protection)) { hsave -o protection protection.hsh }
}

menu * {
  SassIRC Flood Protection V 1.7:dialog $iif($dialog(jpf2),-v,-dm) jpf2 jpf2
}
dialog -l jpf2 {
  title "SassIRC Flood Protection V 1.7"
  option dbu
  size -1 -1 205 268
  ;
  box "Mass Join Flood", 200, 5 5 95 33
  text "Number of Joins:" , 300, 10 15 45 8
  text "In Seconds:" , 301, 10 25 40 8
  edit "" , 302, 65 14 30 10
  edit "" , 303, 65 24 30 10
  ;
  box "Join/Part Flood (Fly-Bys)", 201, 5 38 95 33
  text "Number of Join/Parts:" , 1, 10 49 60 8
  text "In Seconds:" , 2, 10 58 40 8
  edit "" , 3, 65 47 30 10
  edit "" , 4, 65 57 30 10
  ;
  box "Part/Quit Long Message Flood", 215, 5 71 95 24
  text "Message Length:" , 216, 10 82 50 8
  edit "" , 217, 65 81 30 10
  ;
  box "Long Message Flood (Channel)", 202, 5 95 95 45
  text "Number of Long Msgs:" , 5, 10 106 60 8
  edit "" , 7, 65 105 30 10
  text "In Seconds:" , 6, 10 126 40 8
  edit "" , 8, 65 125 30 10
  text "Message Length:" , 9, 10 116 50 8
  edit "" , 10, 65 115 30 10
  ;
  box "Mass Message Flood (Channel)", 203, 5 140 95 35
  text "Number of Messages:" , 11, 10 151 60 8
  edit "" , 12, 65 150 30 10
  text "In Seconds:" , 13, 10 161 40 8
  edit "" , 14, 65 160 30 10
  ;
  box "Long Message Flood (Private)", 220, 5 175 95 45
  text "Number of Long Msgs:" , 221, 10 186 60 8
  edit "" , 222, 65 185 30 10
  text "In Seconds:" , 223, 10 206 40 8
  edit "" , 224, 65 205 30 10
  text "Message Length:" , 225, 10 196 50 8
  edit "" , 226, 65 195 30 10
  ;
  box "Mass Message Flood (Private)", 230, 5 220 95 35
  text "Number of Messages:" , 231, 10 231 60 8
  edit "" , 232, 65 230 30 10
  text "In Seconds:" , 233, 10 241 40 8
  edit "" , 234, 65 240 30 10
  ;
  box "Channels list", 211, 105 5 95 114
  list 102, 110 14 85 70, autohs, hsbar, sort
  edit "", 103, 110 77 85 10, autohs
  button "--[ Add Chan ]--" , 104, 110 90 40 10
  button "--[ Del Chan ]--" , 105, 155 90 40 10
  button "", 15, 110 103 85 10
  ;
  box "Lockdown Modes", 205, 105 119 95 34
  text "Phaze 1:", 206, 110 130 25 8
  text "Phaze 2:", 207, 110 140 25 8
  edit "" , 208, 140 129 30 10
  edit "" , 209, 140 139 30 10
  button "Help", 212, 173 135 20 10
  ;
  box "Lockdown For", 204, 105 153 95 22
  edit "", 18, 145 160 20 10, autohs
  text "Minutes", 19, 170 161 20 8
  ;
  box "Immunity", 240, 105 175 95 27
  check "Ops", 241, 115 182 50 10, left
  check "HalfOps", 242, 115 190 50 10, left
  ;
  button "---[ Save Settings ]---" , 100, 105 238 95 10
  text "SassIRC Flood Protection Coded By PuNkTuReD", 210, 44 258 200 8
  ;
  box "Kick/Kick-Ban", 60, 105 202 95 30
  check "Kick", 61, 110 210 40 10
  check "Kick/Ban", 62, 110 220 40 10
  text "Ban for:", 63, 160 205 20 8
  edit "", 64, 160 213 20 10
  text "Minutes", 65, 160 223 20 8
}
on *:dialog:jpf2:*:*: {
  var %a = $dname, %b = $devent, %c = $did, %d = did -a jpf2
  if (%b == sclick) {
    if (%c == 61) { 
      if (!$did(jpf2,102).seltext) { echo -a ***** Please select a channel to set this setting for. } 
      else {
        $iif($+(%,fpkb,$did(jpf2,102).seltext),unset $+(%,fpkb,$did(jpf2,102).seltext)) 
        did -b jpf2 64  
      }
    }
    if (%c == 62) { 
      did -e jpf2 64 
      if (!$did(jpf2,102).seltext) { echo -a ***** Please select a channel to set this setting for. } 
      elseif (!$did(jpf2,64).edited) { echo -a ***** Please specify a ban length. }
      else { did -ku jpf2 61 | hadd -m protection $+(fpkb,$did(jpf2,102).seltext) on }
    }
    if (%c == 212) { dialog $iif($dialog(jpf2help),-v,-dm) jpf2help jpf2help }
    if (%c == 15) {
      if (!$did(jpf2,102).seltext) { echo -a ***** Please select a channel to protect/deprotect. } 
      else {
        $iif($($+(%,protect,$did(jpf2,102).seltext),2) == on,set $+(%,protect,$did(jpf2,102).seltext) off,set $+(%,protect,$did(jpf2,102).seltext) on) 
        $iif($($+(%,protect,$did(jpf2,102).seltext),2) == on,%d 15 --[ Protected ]--,%d 15 --[ Unprotected ]--)
      }
    }
    if (%c == 100) {
      if (!$did(jpf2,102).seltext) { echo -a ***** Please select a channel to save these protection settings for. }
      else {
        if ($did(jpf2,302).edited) { hadd -m protection $+($did(jpf2,102).seltext,noj) $did(jpf2,302) }
        if ($did(jpf2,303).edited) { hadd -m protection $+($did(jpf2,102).seltext,nojs) $did(jpf2,303) }
        if ($did(jpf2,3).edited) { hadd -m protection $+($did(jpf2,102).seltext,nopj) $did(jpf2,3) }
        if ($did(jpf2,4).edited) { hadd -m protection $+($did(jpf2,102).seltext,nopjs) $did(jpf2,4) }
        if ($did(jpf2,7).edited) { hadd -m protection $+($did(jpf2,102).seltext,nolm) $did(jpf2,7) }
        if ($did(jpf2,8).edited) { hadd -m protection $+($did(jpf2,102).seltext,nolms) $did(jpf2,8) }
        if ($did(jpf2,10).edited) { hadd -m protection $+($did(jpf2,102).seltext,nolml) $did(jpf2,10) }
        if ($did(jpf2,12).edited) { hadd -m protection $+($did(jpf2,102).seltext,noam) $did(jpf2,12) }
        if ($did(jpf2,14).edited) { hadd -m protection $+($did(jpf2,102).seltext,noams) $did(jpf2,14) }
        if ($did(jpf2,18).edited) { hadd -m protection $+($did(jpf2,102).seltext,ldf) $calc($did(jpf2,18) * 60) }
        if ($did(jpf2,208).edited) { hadd -m protection $+($did(jpf2,102).seltext,ldp1) $did(jpf2,208) }
        if ($did(jpf2,209).edited) { hadd -m protection $+($did(jpf2,102).seltext,ldp2) $did(jpf2,209) }
        if ($did(jpf2,217).edited) { hadd -m protection $+($did(jpf2,102).seltext,pqlm) $did(jpf2,217) }
        if ($did(jpf2,222).edited) { hadd -m protection $+($did(jpf2,102).seltext,nolmp) $did(jpf2,222) }
        if ($did(jpf2,226).edited) { hadd -m protection $+($did(jpf2,102).seltext,nolmlp) $did(jpf2,226) }
        if ($did(jpf2,224).edited) { hadd -m protection $+($did(jpf2,102).seltext,nolmsp) $did(jpf2,224) }
        if ($did(jpf2,232).edited) { hadd -m protection $+($did(jpf2,102).seltext,noamp) $did(jpf2,232) }
        if ($did(jpf2,234).edited) { hadd -m protection $+($did(jpf2,102).seltext,noamsp) $did(jpf2,234) }
        if ($did(jpf2,64).edited) { hadd -m protection $+(fpkbl,$did(jpf2,102).seltext) $did(jpf2,64) }  
        echo -a ***** Flood Protection Settings Updated for $+(,$did(jpf2,102).seltext,)
      }
    }
    if (%c == 102) { 
      $iif($($+(%,protect,$did(jpf2,102).seltext),2) == on,%d 15 --[ Protected ]--,%d 15 --[ Unprotected ]--)  
      did -ra jpf2 3 $hget(protection,$+($did(jpf2,102).seltext,nopj))
      did -ra jpf2 4 $hget(protection,$+($did(jpf2,102).seltext,nopjs))
      did -ra jpf2 217 $hget(protection,$+($did(jpf2,102).seltext,pqlm))
      did -ra jpf2 302 $hget(protection,$+($did(jpf2,102).seltext,noj))
      did -ra jpf2 303 $hget(protection,$+($did(jpf2,102).seltext,nojs))
      did -ra jpf2 18 $calc($hget(protection,$+($did(jpf2,102).seltext,ldf)) / 60)
      did -ra jpf2 208 $hget(protection,$+($did(jpf2,102).seltext,ldp1))
      did -ra jpf2 209 $hget(protection,$+($did(jpf2,102).seltext,ldp2))      
      did -ra jpf2 7 $hget(protection,$+($did(jpf2,102).seltext,nolm))
      did -ra jpf2 8 $hget(protection,$+($did(jpf2,102).seltext,nolms))
      did -ra jpf2 10 $hget(protection,$+($did(jpf2,102).seltext,nolml))
      did -ra jpf2 12 $hget(protection,$+($did(jpf2,102).seltext,noam))     
      did -ra jpf2 14 $hget(protection,$+($did(jpf2,102).seltext,noams))
      did -ra jpf2 232 $hget(protection,$+($did(jpf2,102).seltext,noamp))
      did -ra jpf2 234 $hget(protection,$+($did(jpf2,102).seltext,noamsp))
      did -ra jpf2 222 $hget(protection,$+($did(jpf2,102).seltext,nolmp))
      did -ra jpf2 226 $hget(protection,$+($did(jpf2,102).seltext,nolmlp))
      did -ra jpf2 224 $hget(protection,$+($did(jpf2,102).seltext,nolmsp))
      if ($hget(protection,$+(fpkb,$did(jpf2,102).seltext)) == on) { did -e jpf2 64 | did -ku jpf2 61 | did -kc jpf2 62 }
      elseif ($hget(protection,$+(fpkb,$did(jpf2,102).seltext)) != on) { did -ku jpf2 62 | did -kc jpf2 61 | did -b jpf2 64 } 
      $iif(($hget(protection,$+(fpkb,$did(jpf2,102).seltext)) == on),did -ra jpf2 64 $hget(protection,$+(fpkbl,$did(jpf2,102).seltext)) , did -r jpf2 64)
      $iif(($hget(protection,$+($did(jpf2,102).seltext,opimmun)) == on),did -ck jpf2 241 , did -uk jpf2 241)
      $iif(($hget(protection,$+($did(jpf2,102).seltext,hopimmun)) == on),did -ck jpf2 242 , did -uk jpf2 242)
    }
    if (%c == 104) { 
      if ($did(jpf2,103).edited) { write protectchans.txt $did(jpf2,103) | did -r jpf2 103 | .timer 1 1 fillprotectchans2 } 
      else { echo -a ***** Please enter a channel to add to the list. }
    }
    if (%c == 105) { 
      if (!$did(jpf2,102).seltext) { echo -a ***** Please select a channel to remove from the list. }
      else { did -r jpf2 15 | write $+(,-ds",$did(jpf2,102).seltext,") protectchans.txt | did -d jpf2 102 $did(jpf2,102).sel | .timer 1 1 fillprotectchans2 }
    }
    if (%c == 241) { 
      $iif(($hget(protection,$+($did(jpf2,102).seltext,opimmun)) == on),opoff,opon) 
    }
    if (%c == 242) { 
      $iif(($hget(protection,$+($did(jpf2,102).seltext,hopimmun)) == on),hopoff,hopon) 
    }
  }
  if (%b == init) { fillprotectchans2 }
}
alias -l opon {  hadd -m protection $+($did(jpf2,102).seltext,opimmun) on | did -kc jpf2 241 }
alias -l opoff { hdel protection $+($did(jpf2,102).seltext,opimmun) | did -ku jpf2 241 }
alias -l hopon { hadd -m protection $+($did(jpf2,102).seltext,hopimmun) on | did -kc jpf2 242 }
alias -l hopoff { hdel protection $+($did(jpf2,102).seltext,hopimmun) | did -ku jpf2 242 }
alias -l checktextfloodchan {
  if ($len($strip($1-)) >= $hget(protection,$+($1,nolml))) { 
    $iif($($+(%,$2,bflood),2),inc $+(%,$2,bflood) 1,set -u $+ $hget(protection,$+($1,nolms)) $+(%,$2,bflood) 1)
    if ($($+(%,$2,bflood),2) == $hget(protection,$+($1,nolm))) { ignore -u180 $address($2,2) | unset $($+(%,$2,bflood),1) | chanlockdown $1 $2 Long message flood detected, $+(,$hget(protection,$+($1,nolm)),) channel messages over $+(,$hget(protection,$+($1,nolml)),) characters long in $+(,$hget(protection,$+($1,nolms)),) seconds }
  } 
  $iif($($+(%,$2,flood),2),inc $+(%,$2,flood) 1,set -u $+ $hget(protection,$+($1,noams)) $+(%,$2,flood) 1) 
  if ($($+(%,$2,flood),2) == $hget(protection,$+($1,noam))) { ignore -u180 $address($2,2) | unset $($+(%,$2,flood),1) | chanlockdown $1 $2 Flood detected, $+(,$hget(protection,$+($1,noam)),) channel messages in $+(,$hget(protection,$+($1,noams)),) seconds }
}
alias -l checktextfloodpriv {
  var %x = $comchan($2,0)
  while (%x) {
    if ($($+(%,protect,$comchan($2, %x)),2) == on) {
      if ($len($strip($1-)) >= $hget(protection,$+($1,nolmlp))) { 
        $iif($($+(%,$2,bflood),2),inc $+(%,$2,bflood) 1,set -u $+ $hget(protection,$+($1,nolmsp)) $+(%,$2,bflood) 1) 
        if ($($+(%,$2,bflood),2) >= $hget(protection,$+($1,nolmp))) { ignore -u180 $address($2,2) | unset $($+(%,$2,bflood),1) | chanlockdown $comchan($2, %x) $2 Private-Long message flood detected, $+(,$hget(protection,$+($1,nolmp)),) private messages over $+(,$hget(protection,$+($1,nolmlp)),) characters long in $+(,$hget(protection,$+($1,nolmsp)),) seconds | haltdef }
      }
      $iif($($+(%,$2,flood),2),inc $+(%,$2,flood) 1,set -u $+ $hget(protection,$+($comchan($2, %x),noamsp)) $+(%,$2,flood) 1) 
      if ($($+(%,$2,flood),2) >= $hget(protection,$+($comchan($2, %x),noamp))) { ignore -u180 $address($2,2) | unset $($+(%,$2,flood),1) | chanlockdown $comchan($2, %x) $2 Private-Flood detected, $+(,$hget(protection,$+($comchan($2, %x),noamp)),) private messages in $+(,$hget(protection,$+($comchan($2, %x),noamsp)),) seconds | haltdef } 
      dec %x 
    }
    else { dec %x }
  }
}
alias fillprotectchans2 {
  did -r jpf2 102
  var %a = $lines(protectchans.txt)
  while (%a) { did -a jpf2 102 $read(protectchans.txt, %a) | dec %a }
  did -z jpf2 102
}
dialog -l jpf2help {
  title "Lockdown Help"
  option dbu
  size -1 -1 100 100
  box "Modes Help", 1, 5 5 90 90
  list 2, 10 15 80 80 , autohs, hsbar
}
on *:dialog:jpf2help:*:*: {
  var %a = $dname, %b = $devent, %c = $did, %d = did -a jpf2help 2
  if (%b == init) { 
    did -r jpf2help 2
    %d --[ Channel Modes ]--
    %d A = Only Administrators may join
    %d c = No ANSI color can be sent to the channel
    %d C = No CTCP's allowed in the channel
    %d i = Invite required
    %d j = <joins:seconds> Throttles joins per-user to joins per seconds seconds
    %d K = /knock is not allowed
    %d k = <key> Sets a key needed to join
    %d l = <##> Sets max number of users
    %d M = A registered nickname (+r) is required to talk
    %d m = Moderated channel. Only +v/o/h users may speak
    %d N = No nick name changes permitted
    %d n = No messages from outside channels
    %d O = Only IRCops may join
    %d p = Makes channel private
    %d Q = Only U:Lined servers can kick users
    %d R = Requires a registered nickname to join
    %d S = Strips all incoming colors
    %d s = Makes channel secret
    %d t = Only chanops can set topic
    %d T = No NOTICE's allowed in the channel
    %d u = Auditorium – Makes /names and /who #channel only show channel ops
    %d V = /invite is not allowed
    %d z = Only clients on a Secure (SSL) Connection may join
    did -z jpf2help 2 
  }
}
on *:text:*:*: { 
  if ($nick isop $chan) && ($hget(protection,$+($chan,opimmun)) == on) { halt }
  if ($nick ishop $chan) && ($hget(protection,$+($chan,hopimmun)) == on) { halt }
  else {
    if ($target == $chan) {
      if ($($+(%,protect,$chan),2) == on) { checktextfloodchan $target $nick }  
    }
    if ($target == $me) { checktextfloodpriv $target $nick }  
  } 
}
on *:action:*:*: { 
  if ($nick isop $chan) && ($hget(protection,$+($chan,opimmun)) == on) { halt }
  if ($nick ishop $chan) && ($hget(protection,$+($chan,hopimmun)) == on) { halt }
  else {
    if ($target == $chan) {
      if ($($+(%,protect,$chan),2) == on) { checktextfloodchan $target $nick }  
    }
    if ($target == $me) { checktextfloodpriv $target $nick }  
  }
}
on *:notice:*:*: { 
  if ($nick isop $chan) && ($hget(protection,$+($chan,opimmun)) == on) { halt }
  if ($nick ishop $chan) && ($hget(protection,$+($chan,hopimmun)) == on) { halt }
  else {
    if ($target == $chan) {
      if ($($+(%,protect,$chan),2) == on) { checktextfloodchan $target $nick }  
    }
    if ($target == $me) { checktextfloodpriv $target $nick }  
  } 
}
alias -l chanlockdown {
  if (!$($+(%,chanlocked,$1),2)) {
    set -u $+ $hget(protection,$+($1,ldf)) $+(%,chanlocked,$1) on
    mode $1 $+($chr(43),$hget(protection,$+($1,ldp1)),$hget(protection,$+($1,ldp2)) )
    msg $1 ***** $3- $+ . The channel has now gone into lockdown mode for a total of $+(,$calc($hget(protection,$+($1,ldf)) / 60),) minute(s). Triggered By $+(,$2,,$chr(46)) 
    .timer 1 $calc($hget(protection,$+($1,ldf)) / 2) mode $1 - $+ $hget(protection,$+($1,ldp1))
    .timer 1 $hget(protection,$+($1,ldf)) mode $1 - $+ $hget(protection,$+($1,ldp2))
    .timer 1 $calc($hget(protection,$+($1,ldf)) + 1) msg $1 ***** Channel lockdown over.
    if ($2 ison $1) { 
      if ($hget(protection,$+(fpkb,$1)) == on) { ban -u $+ $calc($hget(protection,$+(fpkbl,$1)) * 60) $1 $address($2,2) Flooder | kick $1 $2 }
      else { raw -q kick $1 $2 Flooder }
    }
  }
  else { 
    if ($hget(protection,$+(fpkb,$1)) == on) { ban -u $+ $calc($hget(protection,$+(fpkbl,$1)) * 60) $1 $address($2,2) Flooder | kick $1 $2 }
    else { raw -q kick $1 $2 Flooder }  
  }
}
on 1:quit: { 
  var %a = $comchan($nick,0)
  while (%a) {
    if ($($+(%,protect,$chan($comchan($nick,%a))),2) == on) { 
      if ($($+(%,join,$chan($comchan($nick,%a)),$nick),2) > $hget(protection,$+($chan($comchan($nick,%a)),nopj))) { unset $($+(%,join,$chan($comchan($nick,%a)),$nick),1) | chanlockdown $chan($comchan($nick,%a))) $nick Join/Part flood detected, $+(,$($+(%,nopj,$chan($comchan($nick,%a)))),2),) joins/parts in $+(,$($+(%,nopjs,$chan($comchan($nick,%a)))),2),) seconds } 
      if ($len($strip($1-)) >= $hget(protection,$+($chan($comchan($nick,%a)),pqlm))) { chanlockdown $chan($comchan($nick,%a)) $nick Long Quit Message flood detected, message over $+(,$hget(protection,$+($chan($comchan($nick,%a)),pqlm),) characters long }
      dec %a
    }
    else { dec %a }
  }
}
on *:part:#: { 
  if ($($+(%,protect,$chan),2) == on) { 
    if ($($+(%,join,$chan,$nick),2) >= $hget(protection,$+($chan,nopj))) { unset $($+(%,join,$chan,$nick),1) | chanlockdown $chan $nick Join/Part flood detected, $+(,$hget(protection,$+($chan,nopj)),) joins/parts in $+(,$hget(protection,$+($chan,nopjs)),) seconds } 
    if ($len($strip($1-)) >= $hget(protection,$+($chan,pqlm))) { chanlockdown $chan $nick Long Part Message flood detected, message over $+(,$hget(protection,$+($chan,pqlm)),) characters long }
  }
}
on *:join:#: { 
  if ($($+(%,protect,$chan),2) == on) { 
    $iif($($+(%,join,$chan),2),inc $+(%,join,$chan) 1,set -u $+ $hget(protection,$+($chan,nojs)) $+(%,join,$chan) 1)
    $iif($($+(%,join,$chan,$nick),2),inc $+(%,join,$chan,$nick) 1,set -u $+ $hget(protection,$+($chan,nopjs)) $+(%,join,$chan,$nick) 1) 
    if ($($+(%,join,$chan),2) >= $hget(protection,$+($chan,noj))) { unset $($+(%,join,$chan),1) | chanlockdown $chan $nick Join flood detected, $+(,$hget(protection,$+($chan,noj)),) joins in $+(,$hget(protection,$+($chan,nojs)),) seconds }
  }
}
on 1:load: {
  echo -a ***** Thank you for loading "SassIRC Flood Protection V 1.7" Scripted by PuNkTuReD
  echo -a ***** This script will provide your network of channels with flood protection against,
  echo -a ***** Join/Part floods - (# JoinsParts/In # Seconds) - Per User
  echo -a ***** Mass join floods - (# Joins/In # Seconds) - Any User
  echo -a ***** Long Message floods channel - (# Messages/Bigger Than #/In # Seconds)
  echo -a ***** Mass Message floods channel - (# Messages/In # Seconds)
  echo -a ***** Long Message floods private - (# Messages/Bigger Than #/In # Seconds)
  echo -a ***** Mass Message floods private - (# Messages/In # Seconds)
}
on 1:unload: {
  echo -a ***** Thank you for using "SassIRC Flood Protection V 1.6" Scripted by PuNkTuReD with thanks to Cheiron
}
