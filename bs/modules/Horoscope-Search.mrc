/*

#########################################

	 #    Horoscope-Search   #
	  # v1.5 - (18/07/2016) #
	   # Thanks Supporters #

#########################################

*/

; --- Start of dialogs ---

dialog -l whs_sets {
  title ""
  size -1 -1 329 154
  option dbu disable
  icon $scriptdir $+ whs_main.ico, 0
  button "Close this window", 1, 77 136 193 17, default ok
  tab "Settings 1", 2, 2 2 324 122
  text "Ignore channel(s):", 3, 4 20 75 8, tab 2 center
  list 4, 4 30 78 92, disable tab 2 size hsbar vsbar
  button "Add", 6, 84 30 43 10, tab 2
  button "Del", 7, 84 40 43 10, disable tab 2
  button "Clear", 8, 84 111 43 12, disable tab 2
  button "Add", 16, 200 30 43 10, tab 2
  text "Ignore user(s):", 14, 248 20 76 8, tab 2 center
  button "Del", 17, 200 40 43 10, disable tab 2
  list 15, 245 30 78 92, disable tab 2 size hsbar vsbar
  button "Clear", 18, 200 111 43 12, disable tab 2
  tab "Settings 2", 13
  text "Private Notice Command:", 9, 4 20 125 8, tab 13
  edit "", 5, 130 19 18 9, tab 13 limit 1
  text "Channel Message Command:", 11, 4 30 125 8, tab 13
  edit "", 10, 130 29 18 9, tab 13 limit 1
  combo 19, 4 65 63 57, tab 13 size drop
  text "Language:", 20, 4 55 63 8, tab 13 center
  check "Enable", 12, 2 141 54 10
  text "", 21, 306 144 22 8, center disable
  check "Show the 'Description' information", 29, 160 18 164 10, tab 13
  check "Show the 'Link' information", 31, 160 28 164 10, tab 13
  check "Show color/bold/underline in informations", 52, 4 80 164 10, tab 13
  check "Allow all output links to be shorten", 520, 4 90 164 10, tab 13
  tab "Settings 3", 53
  check "Display the 'menubar' module menu", 54, 4 20 200 10, tab 53
  check "Display the 'status' module menu", 55, 4 30 200 10, tab 53
  check "Display the 'channel' module menu", 56, 4 40 200 10, tab 53
  check "Display the 'query' module menu", 57, 4 50 200 10, tab 53
  check "Display the 'nicklist' module menu", 58, 4 60 200 10, tab 53
  menu "Menu", 22
  item "Help", 23, 22
  item break, 501
  item "About", 24, 22
  item break, 502
  item "Restart", 25, 22
  item break, 503
  item "Exit", 26, 22
}

; --- End of dialogs ---

; --- Start of events ---

ON *:DIALOG:whs_sets:*:*: {
  if ($devent == init) {
    dialog -t $dname $addon v $+ $whs_ver $lang(4) $iif($isalias(wmm_bel),$wmm_bel,->) (/whs_sets)
    did -ra $dname 1 $lang(3)
    did -ra $dname 2 $lang(4) 1
    did -ra $dname 3 $lang(5)
    did -ra $dname 6 $lang(6)
    did -ra $dname 7 $lang(7)
    did -ra $dname 8 $lang(8)
    did -ra $dname 16 $lang(6)
    did -ra $dname 14 $lang(9)
    did -ra $dname 17 $lang(7)
    did -ra $dname 18 $lang(8)
    did -ra $dname 13 $lang(4) 2
    did -ra $dname 9 $lang(10)
    did -ra $dname 11 $lang(11)
    did -ra $dname 20 $lang(12)
    did -ra $dname 12 $lang(13)
    did -ra $dname 21 v $+ $whs_ver
    did -o $dname 22 $lang(14)
    did -o $dname 23 $lang(15)
    did -o $dname 24 $lang(16)
    did -o $dname 25 $lang(17)
    did -o $dname 26 $lang(18)
    did -ra $dname 29 $lang(47) $qt($lang(44)) $lang(48)
    did -ra $dname 31 $lang(47) $qt($lang(45)) $lang(48)
    did -ra $dname 52 $lang(49)
    did -ra $dname 520 $lang(19)

    did -ra $dname 53 $lang(4) 3
    did -ra $dname 54 $lang(50) $qt(menubar) $lang(51)
    did -ra $dname 55 $lang(50) $qt(status) $lang(51)
    did -ra $dname 56 $lang(50) $qt(channel) $lang(51)
    did -ra $dname 57 $lang(50) $qt(query) $lang(51)
    did -ra $dname 58 $lang(50) $qt(nicklist) $lang(51)

    if ($istok(%whs_menu,menubar,32)) { did -c $dname 54 }
    if ($istok(%whs_menu,status,32)) { did -c $dname 55 }
    if ($istok(%whs_menu,channel,32)) { did -c $dname 56 }
    if ($istok(%whs_menu,query,32)) { did -c $dname 57 }
    if ($istok(%whs_menu,nicklist,32)) { did -c $dname 58 }

    if ($istok(%whs_show,description,32)) { did -c $dname 29 }
    if ($istok(%whs_show,link,32)) { did -c $dname 31 }

    if (%whs_tiny) { did -c $dname 520 }
    if (%whs_strip) { did -c $dname 52 }
    if (%whs_status) { did -c $dname 12 }
    if (%whs_prefix_chan) { did -ra $dname 10 %whs_prefix_chan }
    if (%whs_prefix_nick) { did -ra $dname 5 %whs_prefix_nick }

    var %f = $scriptdir $+ whs_lang.ini
    if ($ini(%f,0)) { 
      var %t = $v1
      var %i = 1
      while (%i <= %t) {
        var %l = $ini(%f,%i)
        if (%l) && (%l !== %whs_lang) { did -a $dname 19 %l }
        inc %i
      }
      if (%whs_lang) { did -ca $dname 19 %whs_lang }
    }
    else { did -b $dname 19 }
    whs_ignore_chans_list
    whs_ignore_nicks_list
  }
  if ($devent == menu) {
    if ($did == 23) { url $help_url }
    if ($did == 24) { _input ok 60 v $+ $whs_ver $lang(36) $whs_crdate $lang(26) $whs_owner }
    if ($did == 25) { dialog -k $dname | .timer -mo 1 500 whs_sets }
    if ($did == 26) { dialog -k $dname }
  }
  if ($devent == close) {
    if (!%whs_show) { set %whs_show description link }
    if (!$did(5)) || ($did(5) isalnum) { set %whs_prefix_chan @ }
    if (!$did(10)) || ($did(10) isalnum) { set %whs_prefix_nick ! }
    if ($did(19)) { set %whs_lang $did(19) }
  }
  if ($devent == edit) {
    if ($did == 5) {
      if ($did($did).text) { set %whs_prefix_nick $v1 }
      else { unset %whs_prefix_nick }
    }
    if ($did == 10) {
      if ($did($did).text) { set %whs_prefix_chan $v1 }
      else { unset %whs_prefix_chan }
    }
  }
  if ($devent == sclick) {
    if ($did == 29) {
      var %v = description
      if (!$istok(%whs_show,%v,32)) { set %whs_show $addtok(%whs_show,%v,32) }
      else { set %whs_show $remtok(%whs_show,%v,1,32) }
    }
    if ($did == 31) {
      var %v = link
      if (!$istok(%whs_show,%v,32)) { set %whs_show $addtok(%whs_show,%v,32) }
      else { set %whs_show $remtok(%whs_show,%v,1,32) }
    }
    if ($did == 52) {
      if (!%whs_strip) { set %whs_strip 1 }
      else { set %whs_strip 0 }
    }
    if ($did == 12) {
      if (!%whs_status) { set %whs_status 1 }
      else { set %whs_status 0 }
    }
    if ($did == 520) {
      if (!%whs_tiny) { set %whs_tiny 1 }
      else { set %whs_tiny 0 }
    }
    if ($did == 54) {
      if (!$istok(%whs_menu,menubar,32)) { set %whs_menu $addtok(%whs_menu,menubar,32) }
      else { set %whs_menu $remtok(%whs_menu,menubar,1,32) }
    }
    if ($did == 55) {
      if (!$istok(%whs_menu,status,32)) { set %whs_menu $addtok(%whs_menu,status,32) }
      else { set %whs_menu $remtok(%whs_menu,status,1,32) }
    }
    if ($did == 56) {
      if (!$istok(%whs_menu,channel,32)) { set %whs_menu $addtok(%whs_menu,channel,32) }
      else { set %whs_menu $remtok(%whs_menu,channel,1,32) }
    }
    if ($did == 57) {
      if (!$istok(%whs_menu,query,32)) { set %whs_menu $addtok(%whs_menu,query,32) }
      else { set %whs_menu $remtok(%whs_menu,query,1,32) }
    }
    if ($did == 58) {
      if (!$istok(%whs_menu,nicklist,32)) { set %whs_menu $addtok(%whs_menu,nicklist,32) }
      else { set %whs_menu $remtok(%whs_menu,nicklist,1,32) }
    }
    if ($did == 4) { 
      var %s = $did($did).seltext
      if (!%s) { return }
      did -e $dname 7
    }
    if ($did == 15) { 
      var %s = $did($did).seltext
      if (!%s) { return }
      did -e $dname 17
    }
    if ($did == 7) {
      did -b $dname $did
      var %s = $did(4).seltext
      if (!%s) { return }
      var %net = $gettok(%s,1,32)
      var %chan = $gettok(%s,3,32)
      set %whs_ignore_ [ $+ [ %net ] $+ ] _chans $remtok(%whs_ignore_ [ $+ [ %net ] $+ ] _chans,%chan,1,32)
      if (!%whs_ignore_ [ $+ [ %net ] $+ ] _chans) { 
        unset %whs_ignore_ [ $+ [ %net ] $+ ] _chans
        set %whs_ignore_chans_networks $remtok(%whs_ignore_chans_networks,%net,1,32)
        if (!%whs_ignore_chans_networks) { unset %whs_ignore_chans_networks }
      }
      whs_ignore_chans_list
    }
    if ($did == 17) {
      did -b $dname $did
      var %s = $did(15).seltext
      if (!%s) { return }
      var %net = $gettok(%s,1,32)
      var %nick = $gettok(%s,3,32)
      set %whs_ignore_ [ $+ [ %net ] $+ ] _nicks $remtok(%whs_ignore_ [ $+ [ %net ] $+ ] _nicks,%nick,1,32)
      if (!%whs_ignore_ [ $+ [ %net ] $+ ] _nicks) { 
        unset %whs_ignore_ [ $+ [ %net ] $+ ] _nicks
        set %whs_ignore_nicks_networks $remtok(%whs_ignore_nicks_networks,%net,1,32)
        if (!%whs_ignore_nicks_networks) { unset %whs_ignore_nicks_networks }
      }
      whs_ignore_nicks_list
    }
    if ($did == 6) {
      var %net = $input($lang(27),eidbk60,$addon $iif($isalias(wmm_bel),$wmm_bel,->) $lang(22))
      if (!$dialog($dname)) { return }
      if (!%net) { whs_sets | return }
      if ($numtok(%net,32) !== 1) { _input error 60 $lang(28) | whs_sets | return }
      if ($len(%net) > 50) { _input error 60 $lang(29) | whs_sets | return }
      var %chan = $input($lang(30),eidbk60,$addon $iif($isalias(wmm_bel),$wmm_bel,->) $lang(22))
      if (!$dialog($dname)) { return }
      if (!%chan) { whs_sets | return }
      if ($numtok(%chan,32) !== 1) { _input error 60 $lang(31) | whs_sets | return }
      if ($numtok(%chan,44) !== 1) { _input error 60 $lang(31) | whs_sets | return }
      if ($left(%chan,1) !== $chr(35)) { _input error 60 $lang(32) | whs_sets | return }
      if ($istok(%whs_ignore_ [ $+ [ %net ] $+ ] _chans,%chan,32)) { _input error 60 $lang(33) | whs_sets | return }
      set %whs_ignore_ [ $+ [ %net ] $+ ] _chans $addtok(%whs_ignore_ [ $+ [ %net ] $+ ] _chans,%chan,32)
      if (!$istok(%whs_ignore_chans_networks,%net,32)) { set %whs_ignore_chans_networks $addtok(%whs_ignore_chans_networks,%net,32) }
      whs_ignore_chans_list
      whs_sets
    }
    if ($did == 16) {
      var %net = $input($lang(27),eidbk60,$addon $iif($isalias(wmm_bel),$wmm_bel,->) $lang(22))
      if (!$dialog($dname)) { return }
      if (!%net) { whs_sets | return }
      if ($numtok(%net,32) !== 1) { _input error 60 $lang(28) | whs_sets | return }
      if ($len(%net) > 50) { _input error 60 $lang(29) | whs_sets | return }
      var %nick = $input($lang(21),eidbk60,$addon $iif($isalias(wmm_bel),$wmm_bel,->) $lang(22))
      if (!$dialog($dname)) { return }
      if (!%nick) { whs_sets | return }
      if ($numtok(%nick,32) !== 1) { _input error 60 $lang(35) | whs_sets | return }
      if ($istok(%whs_ignore_ [ $+ [ %net ] $+ ] _nicks,%nick,32)) { _input error 60 $lang(34) | whs_sets | return }
      set %whs_ignore_ [ $+ [ %net ] $+ ] _nicks $addtok(%whs_ignore_ [ $+ [ %net ] $+ ] _nicks,%nick,32)
      if (!$istok(%whs_ignore_nicks_networks,%net,32)) { set %whs_ignore_nicks_networks $addtok(%whs_ignore_nicks_networks,%net,32) }
      whs_ignore_nicks_list
      whs_sets
    }
    if ($did == 8) {
      did -b $dname 8,7
      var %z = 1
      while (%z <= $numtok(%whs_ignore_chans_networks,32)) {
        var %net = $gettok(%whs_ignore_chans_networks,%z,32)     
        if (%whs_ignore_ [ $+ [ %net ] $+ ] _chans) { unset %whs_ignore_ [ $+ [ %net ] $+ ] _chans }
        inc %z
      }
      unset %whs_ignore_chans_networks
      whs_ignore_chans_list
    }
    if ($did == 18) {
      did -b $dname 18,17
      var %z = 1
      while (%z <= $numtok(%whs_ignore_nicks_networks,32)) {
        var %net = $gettok(%whs_ignore_nicks_networks,%z,32)     
        if (%whs_ignore_ [ $+ [ %net ] $+ ] _nicks) { unset %whs_ignore_ [ $+ [ %net ] $+ ] _nicks }
        inc %z
      }
      unset %whs_ignore_nicks_networks
      whs_ignore_nicks_list
    }
  }
}

ON *:LOAD: { whs_load }

ON *:UNLOAD: {
  wmm_d_close whs_sets
  var %1 = $scriptdir $+ whs_main.ico
  var %2 = $scriptdir $+ whs_lang.ini
  if ($isfile(%1)) { .remove -b $qt(%1) }
  if ($isfile(%2)) { .remove -b $qt(%2) }
  unset %whs_*
  hfree -w WHS_*
  .signal -n wmm_close $addon
}

CTCP *:VERSION: { .notice $nick $chr(3) $+ $color(info) $+ ( $+ $chr(3) $+ $color(ctcp) $+ $wmm_bold($nick) $+ $chr(3) $+ $color(info) $+ ): $addon $wmm_under(v) $+ $wmm_bold($whs_ver) Created by: $wmm_bold($whs_owner) on: $wmm_bold($whs_crdate) }

ON $*:TEXT:$(/^(\Q $+ $replacecs(%whs_prefix_nick,\E,\E\\E\Q) $+ \E|\Q $+ $replacecs(%whs_prefix_chan,\E,\E\\E\Q) $+ \E).*/Si):#: {
  if (!$isalias(wmm_ver)) || ($wmm_ver < $tools_ver) || (!%whs_status) || ($istok(%whs_ignore_ [ $+ [ $network ] $+ ] _chans,$chan,32)) || ($istok(%whs_ignore_ [ $+ [ $network ] $+ ] _nicks,$nick,32)) { return }
  tokenize 32 $strip($1-)
  var %cn = $network $+ ~ $+ $nick $+ ~ $+ $chan
  if ($hget(WHS_FLOOD,%cn)) { return }
  if ($1 == %whs_prefix_nick $+ horo) {
    hadd -mu6 WHS_FLOOD %cn 1
    if (!$2) { .notice $nick ( $+ $wmm_bold($nick) $+ ): $lang(37) - $lang(38) $wmm_bold($1 < $+ $wmm_under($lang(46)) $+ >) - ( $+ $lang(39) $wmm_bold($1 $wmm_under($gettok($horos,$rand(1,12),32))) $+ ) | return }
    if (!$istok($horos,$2,32)) { .notice $nick ( $+ $wmm_bold($nick) $+ ): $lang(43) $wmm_bold($horos) - ( $+ $lang(39) $wmm_bold($1 $wmm_under($gettok($horos,$rand(1,12),32))) $+ ) | return }
    whs_horo_search $nick $chan .notice $2-
  }
  if ($1 == %whs_prefix_chan $+ horo) {
    hadd -mu6 WHS_FLOOD %cn 1
    if (!$2) { .msg $chan ( $+ $wmm_bold($nick) $+ ): $lang(37) - $lang(38) $wmm_bold($1 < $+ $wmm_under($lang(46)) $+ >) - ( $+ $lang(39) $wmm_bold($1 $wmm_under($gettok($horos,$rand(1,12),32))) $+ ) | return }
    if (!$istok($horos,$2,32)) { .msg $chan ( $+ $wmm_bold($nick) $+ ): $lang(43) $wmm_bold($horos) - ( $+ $lang(39) $wmm_bold($1 $wmm_under($gettok($horos,$rand(1,12),32))) $+ ) | return }
    whs_horo_search $nick $chan .msg $2-
  }
}

; --- End of events ---

; --- Start of aliases ---

alias whs_ver { return 1.5 }
alias whs_crdate { return 18/07/2016 }
alias whs_owner { return $+($chr(119),$chr(101),$chr(115),$chr(116),$chr(111),$chr(114)) }
alias -l tools_ver { return 2.6 }
alias -l horos { return aries taurus gemini cancer leo virgo libra scorpio sagittarius capricorn aquarius pisces }
alias -l addon { return $+($chr(72),$chr(111),$chr(114),$chr(111),$chr(115),$chr(99),$chr(111),$chr(112),$chr(101),$chr(45),$chr(83),$chr(101),$chr(97),$chr(114),$chr(99),$chr(104)) }
alias -l help_url { return http:// $+ $whs_owner $+ .ucoz.com/wmm }
alias -l main_ico_url { return http://www.astrocenter.com/favicon.ico?nocache= $+ $ticks }
alias -l lang_url { return http:// $+ $whs_owner $+ .ucoz.com/wmm/languages/whs_lang.ini?nocache= $+ $ticks }
alias -l _input {
  if (!$1) { return }
  if ($1 == ok) { .timer -ho 1 0 !noop $input($replace($3-,@newline@,$crlf),ouidbk $+ $iif($2 && $2 isnum,$2,0),$addon $iif($isalias(wmm_bel),$wmm_bel,->) $iif($lang(23),$v1,OK)) }
  if ($1 == warn) { .timer -ho 1 0 !noop $input($replace($3-,@newline@,$crlf),woudbk $+ $iif($2 && $2 isnum,$2,0),$addon $iif($isalias(wmm_bel),$wmm_bel,->) $iif($lang(24),$v1,Warn)) }
  if ($1 == error) { .timer -ho 1 0 !noop $input($replace($3-,@newline@,$crlf),houdbk $+ $iif($2 && $2 isnum,$2,0),$addon $iif($isalias(wmm_bel),$wmm_bel,->) $iif($lang(25),$v1,Error)) }
}

alias -l lang { 
  var %f = $scriptdir $+ whs_lang.ini
  if (!$isfile(%f)) { return 0 }
  if (!%whs_lang) { set %whs_lang English }
  var %chk_lang = $ini(%f,%whs_lang)
  if (!%chk_lang) { return READ-ERROR! }
  var %r = $readini(%f,n,%whs_lang,$1)
  if (!%r) { return N/A }
  elseif (%r) { return %r }
}

; ########################################################## 

alias whs_sets { 
  if (!$isalias(wmm_ver)) { _input error 60 You must download and install first the $qt($upper($whs_owner) Module Manager) in order to work this module! | url $help_url | .unload -nrs $qt($script) | return }
  if ($wmm_ver < $tools_ver) { _input error 60 You must download and install the latest $qt($upper($whs_owner) Module Manager) version in order to work this module! | url $help_url | .unload -nrs $qt($script) | return }
  if ($group(# [ $+ [ $lower($addon) ] ]).fname !== $script) { _input error 60 This module cannot work more than one time into this mIRC client because you already have this module installed! | .unload -nrs $qt($script) | return }
  var %d = whs_sets
  if ($dialog(%d)) { dialog -ve %d %d | return }
  var %i = $scriptdir $+ whs_main.ico
  var %l = $scriptdir $+ whs_lang.ini
  if (!$isfile(%l)) || (!$isfile(%i)) { var %delay = 1 }
  if (%delay) { whs_load | .timer[WHS_DELAY_DL_AND_OPEN] -o 1 3 whs_sets_reopen | _input ok 3 Downloading some require module files... | return }
  dialog -md %d %d
}

alias -l whs_sets_reopen {
  var %i = $scriptdir $+ whs_main.ico
  var %l = $scriptdir $+ whs_lang.ini
  if (!$isfile(%l)) || (!$isfile(%i)) { _input error 60 FATAL ERROR! @newline@ @newline@ $+ Error Code: 001 | return }
  whs_sets
}

alias -l whs_ignore_chans_list {
  var %d = whs_sets
  if (!$dialog(%d)) { return }
  did -b %d 7
  did -r %d 4
  if (!%whs_ignore_chans_networks) { did -b %d 4,8 | return }
  var %z = 1
  while (%z <= $numtok(%whs_ignore_chans_networks,32)) { 
    var %net = $gettok(%whs_ignore_chans_networks,%z,32)
    var %chans = %whs_ignore_ [ $+ [ %net ] $+ ] _chans
    if (!%net) { goto next_net }
    var %i = 1
    while (%i <= $numtok(%chans,32)) {
      var %c = $gettok(%chans,%i,32)
      if (%c) { did -a %d 4 %net $iif($isalias(wmm_bel),$wmm_bel,->) %c }
      inc %i
    }
    :next_net
    inc %z
  }
  if ($did(4).lines) { did -ez %d 4 | did -e %d 8 }
  else { did -b %d 4,8 }
}

alias -l whs_ignore_nicks_list {
  var %d = whs_sets
  if (!$dialog(%d)) { return }
  did -b %d 17
  did -r %d 15
  if (!%whs_ignore_nicks_networks) { did -b %d 15,18 | return }
  var %z = 1
  while (%z <= $numtok(%whs_ignore_nicks_networks,32)) { 
    var %net = $gettok(%whs_ignore_nicks_networks,%z,32)
    var %nicks = %whs_ignore_ [ $+ [ %net ] $+ ] _nicks
    if (!%net) { goto next_net }
    var %i = 1
    while (%i <= $numtok(%nicks,32)) {
      var %n = $gettok(%nicks,%i,32)
      if (%n) { did -a %d 15 %net $iif($isalias(wmm_bel),$wmm_bel,->) %n }
      inc %i
    }
    :next_net
    inc %z
  }
  if ($did(15).lines) { did -ez %d 15 | did -e %d 18 }
  else { did -b %d 15,18 }
}

alias whs_load {
  if (!$isalias(wmm_ver)) { _input error 60 You must download and install first the $qt($upper($whs_owner) Module Manager) in order to work this module! | url $help_url | .unload -nrs $qt($script) | return }
  if ($wmm_ver < $tools_ver) { _input error 60 You must download and install the latest $qt($upper($whs_owner) Module Manager) version in order to work this module! | url $help_url | .unload -nrs $qt($script) | return }
  if ($group(# [ $+ [ $lower($addon) ] ]).fname !== $script) { _input error 60 This module cannot work more than one time into this mIRC client because you already have this module installed! | .unload -nrs $qt($script) | return }
  if ($isalias(wmm_dl)) { wmm_dl $main_ico_url $qt($scriptdir $+ whs_main.ico) }
  if ($isalias(wmm_dl)) { wmm_dl $lang_url $qt($scriptdir $+ whs_lang.ini) }
  if (!$var(whs_menu,0)) { set %whs_menu menubar }
  if (%whs_status == $null) { set %whs_status 1 }
  if (%whs_tiny == $null) { set %whs_tiny 1 }
  if (%whs_strip == $null) { set %whs_strip 0 }
  if (%whs_lang == $null) { set %whs_lang English }
  if (%whs_prefix_nick == $null) { set %whs_prefix_nick ! }
  if (%whs_prefix_chan == $null) { set %whs_prefix_chan @ }
  if (%whs_show == $null) { set %whs_show description link }
  hfree -w WHS_*
  .signal -n wmm_close $addon
}

alias -l whs_horo_search {
  if (!$wmm_internet) || (!%whs_status) || (!$1-) { return }
  if ($3 == .msg) { var %output = $3 $2 }
  elseif ($3 == .notice) { var %output = $3 $1 }
  if (!%whs_show) { set %whs_show description link }

  var %v = horoscope_search_ $+ $wmm_random
  wmm_jsonopen -ud %v http://widgets.fabulously40.com/horoscope.json?sign= $+ $4
  if ($wmm_jsonerror) { %output ( $+ $wmm_bold($1) $+ ): $lang(40) - ( $+ $lang(41) $wmm_bold($wmm_jsonerror) $+ ) | return }

  if ($istok(%whs_show,description,32)) { var %desc = $wmm_html2asc($wmm_nohtml($wmm_fixtab($wmm_json(%v,horoscope,horoscope)))) }
  if ($istok(%whs_show,link,32)) {
    var %num = $calc($findtok($horos,$4,1,32) -1)
    var %url = http://www.astrocenter.com/us/horoscope-daily.aspx?When=0&ZSign= $+ %num $+ &Af=0
    if (%whs_tiny) { var %url = $wmm_tinycom(%url) }
  }

  var %msg = 0,6 $+ $gettok($addon,1,45) $+ -0,14 $+ $gettok($addon,2,45) $+ : $iif($isalias(wmm_bel),$wmm_bel,->) $iif(%desc,$wmm_bold($lang(44)) $+ :14 %desc $+ ) $iif(%url,-*- $wmm_bold($lang(45)) $+ :12 $wmm_under(%url) $+ )
  %output $iif(%whs_strip,$strip(%msg),%msg)
}

; --- End of aliases ---

; --- Start of menus ---

menu * {
  $iif($istok(%whs_menu,$menu,32),-)
  $iif($istok(%whs_menu,$menu,32),$iif($isalias(wmm_qd),$wmm_qd($addon v $+ $whs_ver - $iif($lang(4),$v1,Settings) $+ ),-*- $addon v $+ $whs_ver - Settings -*-)):whs_sets
  $iif($istok(%whs_menu,$menu,32),-)
}

; --- End of menus ---

; -- Start of groups ---

#horoscope-search off
#horoscope-search end

; -- End of groups ---

; ------------------------------------------------------------------------------ EOF ------------------------------------------------------------------------------
