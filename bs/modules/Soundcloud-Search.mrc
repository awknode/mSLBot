/*

#########################################

	 #   Soundcloud-Search   #
	  # v2.2 - (22/10/2017) #
	   # Thanks Supporters #

#########################################

*/

; --- Start of dialogs ---

dialog -l wss_sets {
  title ""
  size -1 -1 327 185
  option dbu disable
  icon $scriptdir $+ $mod $+ _main.ico, 0
  button "Close this window", 1, 77 167 193 17, default ok
  icon 280, 295 167 30 9, $wmm_dir $+ donate.png, 1, noborder center
  tab "Settings 1", 2, 2 2 324 150
  text "Ignore channel(s):", 3, 4 20 75 8, tab 2 center
  list 4, 4 30 78 120, disable tab 2 size hsbar vsbar
  button "Add", 6, 84 30 43 10, tab 2
  button "Del", 7, 84 40 43 10, disable tab 2
  button "Clear", 8, 84 138 43 12, disable tab 2
  button "Add", 16, 200 30 43 10, tab 2
  text "Ignore user(s):", 14, 248 20 76 8, tab 2 center
  button "Del", 17, 200 40 43 10, disable tab 2
  list 15, 245 30 78 120, disable tab 2 size hsbar vsbar
  button "Clear", 18, 200 138 43 12, disable tab 2
  tab "Settings 2", 13
  text "Private Notice Command:", 9, 4 20 125 8, tab 13
  edit "", 5, 130 19 18 9, tab 13 limit 1 center
  text "Channel Message Command:", 11, 4 30 125 8, tab 13
  edit "", 10, 130 29 18 9, tab 13 limit 1 center
  combo 19, 4 65 63 57, tab 13 size drop
  text "Language:", 20, 4 55 63 8, tab 13 center
  text "Max Search Results:", 27, 4 40 126 8, tab 13
  edit "", 28, 130 39 18 9, tab 13 limit 1 center
  check "Enable", 12, 2 171 54 10
  text "", 21, 301 175 22 8, center disable
  check "Show the 'Title' information", 29, 160 18 164 10, tab 13
  check "Show the 'Length' information", 30, 160 28 164 10, tab 13
  check "Show the 'Views' information", 31, 160 38 164 10, tab 13
  check "Show the 'Favorites' information", 32, 160 48 164 10, tab 13
  check "Show the 'Comments' information", 33, 160 58 164 10, tab 13
  check "Show the 'Downloads' information", 34, 160 68 164 10, tab 13
  check "Show the 'Reposts' information", 35, 160 78 164 10, tab 13
  check "Show the 'Uploaded on' information", 36, 160 88 164 10, tab 13
  check "Show the 'Uploaded by' information", 37, 160 98 164 10, tab 13
  check "Show the 'Link' information", 38, 160 108 164 10, tab 13
  check "Show the 'Description' information", 39, 160 118 164 10, tab 13
  check "Show the 'Likes' information", 40, 160 128 164 10, tab 13
  check "Show the 'Size' information", 41, 160 138 164 10, tab 13
  check "Show the 'Genre' information", 42, 4 128 155 10, tab 13
  check "Show the 'Format' information", 43, 4 138 155 10, tab 13
  check "Show empty search informations", 44, 4 85 155 10, tab 13
  check "Show color/bold/underline in informations", 52, 4 95 155 10, tab 13
  check "Allow all output links to be shorten", 520, 4 105 155 10, tab 13
  check "Display the module output messages", 620, 4 115 150 10, tab 13
  tab "Settings 3", 45
  text "Max 'Title' information characters", 46, 5 20 155 8, tab 45
  edit "", 47, 160 19 18 9, tab 45 limit 3 center
  text "Max 'Description' information characters", 48, 5 30 155 8, tab 45
  edit "", 49, 160 29 18 9, tab 45 limit 3 center
  text "Date/Time format 'Uploaded on' information", 50, 5 40 155 8, tab 45
  edit "", 51, 160 39 90 9, tab 45 autohs center
  check "Display the 'menubar' module menu", 54, 4 60 200 10, tab 45
  check "Display the 'status' module menu", 55, 4 70 200 10, tab 45
  check "Display the 'channel' module menu", 56, 4 80 200 10, tab 45
  check "Display the 'query' module menu", 57, 4 90 200 10, tab 45
  check "Display the 'nicklist' module menu", 58, 4 100 200 10, tab 45
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

ON *:DIALOG:wss_sets:*:*: {
  if ($devent == init) {
    dialog -t $dname $addon v $+ $ [ $+ [ $mod ] $+ ] _ver $lang(4) $wmm_bel (/ [ $+ [ $mod ] $+ ] _sets)
    .timer[ $+ $mod $+ _ANIMATE_TITLE_NOW] -ho 1 2000 wmm_dtitle $dname $dialog($dname).title
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
    did -ra $dname 27 $lang(19)
    did -ra $dname 12 $lang(13)
    did -ra $dname 21 v $+ $ [ $+ [ $mod ] $+ ] _ver
    did -o $dname 22 $lang(14)
    did -o $dname 23 $lang(15)
    did -o $dname 24 $lang(16)
    did -o $dname 25 $lang(17)
    did -o $dname 26 $lang(18)
    did -ra $dname 29 $lang(47) $qt($lang(49)) $lang(48)
    did -ra $dname 30 $lang(47) $qt($lang(50)) $lang(48)
    did -ra $dname 31 $lang(47) $qt($lang(51)) $lang(48)
    did -ra $dname 32 $lang(47) $qt($lang(54)) $lang(48)
    did -ra $dname 33 $lang(47) $qt($lang(55)) $lang(48)
    did -ra $dname 34 $lang(47) $qt($lang(52)) $lang(48)
    did -ra $dname 35 $lang(47) $qt($lang(53)) $lang(48)
    did -ra $dname 36 $lang(47) $qt($lang(56)) $lang(48)
    did -ra $dname 37 $lang(47) $qt($lang(57)) $lang(48)
    did -ra $dname 38 $lang(47) $qt($lang(58)) $lang(48)
    did -ra $dname 39 $lang(47) $qt($lang(61)) $lang(48)
    did -ra $dname 40 $lang(47) $qt($lang(62)) $lang(48)
    did -ra $dname 41 $lang(47) $qt($lang(63)) $lang(48)
    did -ra $dname 42 $lang(47) $qt($lang(64)) $lang(48)
    did -ra $dname 43 $lang(47) $qt($lang(65)) $lang(48)
    did -ra $dname 44 $lang(68)
    did -ra $dname 45 $lang(4) 3
    did -ra $dname 46 $lang(69) $qt($lang(49)) $lang(70)
    did -ra $dname 48 $lang(69) $qt($lang(61)) $lang(70)
    did -ra $dname 50 $lang(71) $qt($lang(56)) $lang(48)
    did -ra $dname 52 $lang(72)

    did -ra $dname 54 $lang(73) $qt(menubar) $lang(74)
    did -ra $dname 55 $lang(73) $qt(status) $lang(74)
    did -ra $dname 56 $lang(73) $qt(channel) $lang(74)
    did -ra $dname 57 $lang(73) $qt(query) $lang(74)
    did -ra $dname 58 $lang(73) $qt(nicklist) $lang(74)
    did -ra $dname 520 $lang(75)
    did -ra $dname 620 $lang(76)

    if ($group(# [ $+ [ $mod ] $+ ] _menu_menubar) == on) { did -c $dname 54 }
    if ($group(# [ $+ [ $mod ] $+ ] _menu_status) == on) { did -c $dname 55 }
    if ($group(# [ $+ [ $mod ] $+ ] _menu_channel) == on) { did -c $dname 56 }
    if ($group(# [ $+ [ $mod ] $+ ] _menu_query) == on) { did -c $dname 57 }
    if ($group(# [ $+ [ $mod ] $+ ] _menu_nicklist) == on) { did -c $dname 58 }

    if ($istok(% [ $+ [ $mod ] $+ ] _show,title,32)) { did -c $dname 29 }
    if ($istok(% [ $+ [ $mod ] $+ ] _show,length,32)) { did -c $dname 30 }
    if ($istok(% [ $+ [ $mod ] $+ ] _show,views,32)) { did -c $dname 31 }
    if ($istok(% [ $+ [ $mod ] $+ ] _show,favorites,32)) { did -c $dname 32 }
    if ($istok(% [ $+ [ $mod ] $+ ] _show,comments,32)) { did -c $dname 33 }
    if ($istok(% [ $+ [ $mod ] $+ ] _show,downloads,32)) { did -c $dname 34 }
    if ($istok(% [ $+ [ $mod ] $+ ] _show,reposts,32)) { did -c $dname 35 }
    if ($istok(% [ $+ [ $mod ] $+ ] _show,uploaded_on,32)) { did -c $dname 36 }
    if ($istok(% [ $+ [ $mod ] $+ ] _show,uploaded_by,32)) { did -c $dname 37 }
    if ($istok(% [ $+ [ $mod ] $+ ] _show,link,32)) { did -c $dname 38 }
    if ($istok(% [ $+ [ $mod ] $+ ] _show,description,32)) { did -c $dname 39 }
    if ($istok(% [ $+ [ $mod ] $+ ] _show,likes,32)) { did -c $dname 40 }
    if ($istok(% [ $+ [ $mod ] $+ ] _show,size,32)) { did -c $dname 41 }
    if ($istok(% [ $+ [ $mod ] $+ ] _show,genre,32)) { did -c $dname 42 }
    if ($istok(% [ $+ [ $mod ] $+ ] _show,format,32)) { did -c $dname 43 }

    if (% [ $+ [ $mod ] $+ ] _tiny) { did -c $dname 520 }
    if (% [ $+ [ $mod ] $+ ] _show_empty) { did -c $dname 44 }
    if (% [ $+ [ $mod ] $+ ] _status) { did -c $dname 12 }
    if (% [ $+ [ $mod ] $+ ] _strip) { did -c $dname 52 }
    if (% [ $+ [ $mod ] $+ ] _output) { did -c $dname 620 }

    if (% [ $+ [ $mod ] $+ ] _prefix_chan) { did -ra $dname 10 % [ $+ [ $mod ] $+ ] _prefix_chan }
    if (% [ $+ [ $mod ] $+ ] _prefix_nick) { did -ra $dname 5 % [ $+ [ $mod ] $+ ] _prefix_nick }
    if (% [ $+ [ $mod ] $+ ] _max_results) { did -ra $dname 28 % [ $+ [ $mod ] $+ ] _max_results }
    if (% [ $+ [ $mod ] $+ ] _title_chars_max) { did -ra $dname 47 % [ $+ [ $mod ] $+ ] _title_chars_max }
    if (% [ $+ [ $mod ] $+ ] _desc_chars_max) { did -ra $dname 49 % [ $+ [ $mod ] $+ ] _desc_chars_max }
    if (% [ $+ [ $mod ] $+ ] _uploaded_on_format) { did -ra $dname 51 % [ $+ [ $mod ] $+ ] _uploaded_on_format }

    var %f = $scriptdir $+ $mod $+ _lang.ini
    if ($ini(%f,0)) { 
      var %t = $v1
      var %i = 1
      while (%i <= %t) {
        var %l = $ini(%f,%i)
        if (%l) && (%l !== % [ $+ [ $mod ] $+ ] _lang) { did -a $dname 19 %l }
        inc %i
      }
      if (% [ $+ [ $mod ] $+ ] _lang) { did -ca $dname 19 % [ $+ [ $mod ] $+ ] _lang }
    }
    else { did -b $dname 19 }
    wmm_ignore_cn_list
  }
  if ($devent == menu) {
    if ($did == 23) { url $help_url }
    if ($did == 24) { wmm_input ok 60 $addon v $+ $ [ $+ [ $mod ] $+ ] _ver $lang(36) $ [ $+ [ $mod ] $+ ] _crdate $lang(26) $ [ $+ [ $mod ] $+ ] _owner }
    if ($did == 25) { dialog -k $dname | .timer -mo 1 500 $mod $+ _sets }
    if ($did == 26) { dialog -k $dname }
  }
  if ($devent == close) {
    .timer[ $+ $mod $+ _*] off
    if (!% [ $+ [ $mod ] $+ ] _show) { set % $+ $mod $+ _show title link  }
    if (!$did(5)) || ($did(5) isalnum) { set % $+ $mod $+ _prefix_chan @ }
    if (!$did(10)) || ($did(10) isalnum) { set % $+ $mod $+ _prefix_nick ! }
    if (!$did(28)) || (!$wmm_isdigit($did(28))) || ($did(28) > 9) { set % $+ $mod $+ _max_results 3 }
    if (!$did(47)) || (!$wmm_isdigit($did(47))) || ($did(47) > 300) { set % $+ $mod $+ _title_chars_max 100 }
    if (!$did(49)) || (!$wmm_isdigit($did(49))) || ($did(49) > 300) { set % $+ $mod $+ _desc_chars_max 50 }
    if (!$did(51)) || (!$wmm_cdate($did(51))) { set % $+ $mod $+ _uploaded_on_format $wmm_d_format }
    if ($did(19)) { set % $+ $mod $+ _lang $did(19) }
  }
  if ($devent == edit) {
    if ($did == 280) { url $wmm_donate }
    if ($did == 5) {
      if ($did($did).text) { set % $+ $mod $+ _prefix_nick $v1 }
      else { unset % $+ $mod $+ _prefix_nick }
    }
    if ($did == 10) {
      if ($did($did).text) { set % $+ $mod $+ _prefix_chan $v1 }
      else { unset % $+ $mod $+ _prefix_chan }
    }
    if ($did == 28) {
      if ($did($did).text) { set % $+ $mod $+ _max_results $v1 }
      else { unset % $+ $mod $+ _max_results }
    }
    if ($did == 47) {
      if ($did($did).text) { set % $+ $mod $+ _title_chars_max $v1 }
      else { unset % $+ $mod $+ _title_chars_max }
    }
    if ($did == 49) {
      if ($did($did).text) { set % $+ $mod $+ _desc_chars_max $v1 }
      else { unset % $+ $mod $+ _desc_chars_max }
    }
    if ($did == 51) {
      if ($did($did).text) { set % $+ $mod $+ _uploaded_on_format $v1 }
      else { unset % $+ $mod $+ _uploaded_on_format }
    }
  }
  if ($devent == sclick) {
    if ($did == 29) {
      var %v = title
      if (!$istok(% [ $+ [ $mod ] $+ ] _show,%v,32)) { set % $+ $mod $+ _show $addtok(% [ $+ [ $mod ] $+ ] _show,%v,32) }
      else { set % $+ $mod $+ _show $remtok(% [ $+ [ $mod ] $+ ] _show,%v,1,32) }
    }
    if ($did == 30) {
      var %v = length
      if (!$istok(% [ $+ [ $mod ] $+ ] _show,%v,32)) { set % $+ $mod $+ _show $addtok(% [ $+ [ $mod ] $+ ] _show,%v,32) }
      else { set % $+ $mod $+ _show $remtok(% [ $+ [ $mod ] $+ ] _show,%v,1,32) }
    }
    if ($did == 31) {
      var %v = views
      if (!$istok(% [ $+ [ $mod ] $+ ] _show,%v,32)) { set % $+ $mod $+ _show $addtok(% [ $+ [ $mod ] $+ ] _show,%v,32) }
      else { set % $+ $mod $+ _show $remtok(% [ $+ [ $mod ] $+ ] _show,%v,1,32) }
    }
    if ($did == 32) {
      var %v = favorites
      if (!$istok(% [ $+ [ $mod ] $+ ] _show,%v,32)) { set % $+ $mod $+ _show $addtok(% [ $+ [ $mod ] $+ ] _show,%v,32) }
      else { set % $+ $mod $+ _show $remtok(% [ $+ [ $mod ] $+ ] _show,%v,1,32) }
    }
    if ($did == 33) {
      var %v = comments
      if (!$istok(% [ $+ [ $mod ] $+ ] _show,%v,32)) { set % $+ $mod $+ _show $addtok(% [ $+ [ $mod ] $+ ] _show,%v,32) }
      else { set % $+ $mod $+ _show $remtok(% [ $+ [ $mod ] $+ ] _show,%v,1,32) }
    }
    if ($did == 34) {
      var %v = downloads
      if (!$istok(% [ $+ [ $mod ] $+ ] _show,%v,32)) { set % $+ $mod $+ _show $addtok(% [ $+ [ $mod ] $+ ] _show,%v,32) }
      else { set % $+ $mod $+ _show $remtok(% [ $+ [ $mod ] $+ ] _show,%v,1,32) }
    }
    if ($did == 35) {
      var %v = reposts
      if (!$istok(% [ $+ [ $mod ] $+ ] _show,%v,32)) { set % $+ $mod $+ _show $addtok(% [ $+ [ $mod ] $+ ] _show,%v,32) }
      else { set % $+ $mod $+ _show $remtok(% [ $+ [ $mod ] $+ ] _show,%v,1,32) }
    }
    if ($did == 36) {
      var %v = uploaded_on
      if (!$istok(% [ $+ [ $mod ] $+ ] _show,%v,32)) { set % $+ $mod $+ _show $addtok(% [ $+ [ $mod ] $+ ] _show,%v,32) }
      else { set % $+ $mod $+ _show $remtok(% [ $+ [ $mod ] $+ ] _show,%v,1,32) }
    }
    if ($did == 37) {
      var %v = uploaded_by
      if (!$istok(% [ $+ [ $mod ] $+ ] _show,%v,32)) { set % $+ $mod $+ _show $addtok(% [ $+ [ $mod ] $+ ] _show,%v,32) }
      else { set % $+ $mod $+ _show $remtok(% [ $+ [ $mod ] $+ ] _show,%v,1,32) }
    }
    if ($did == 38) {
      var %v = link
      if (!$istok(% [ $+ [ $mod ] $+ ] _show,%v,32)) { set % $+ $mod $+ _show $addtok(% [ $+ [ $mod ] $+ ] _show,%v,32) }
      else { set % $+ $mod $+ _show $remtok(% [ $+ [ $mod ] $+ ] _show,%v,1,32) }
    }
    if ($did == 39) {
      var %v = description
      if (!$istok(% [ $+ [ $mod ] $+ ] _show,%v,32)) { set % $+ $mod $+ _show $addtok(% [ $+ [ $mod ] $+ ] _show,%v,32) }
      else { set % $+ $mod $+ _show $remtok(% [ $+ [ $mod ] $+ ] _show,%v,1,32) }
    }
    if ($did == 40) {
      var %v = likes
      if (!$istok(% [ $+ [ $mod ] $+ ] _show,%v,32)) { set % $+ $mod $+ _show $addtok(% [ $+ [ $mod ] $+ ] _show,%v,32) }
      else { set % $+ $mod $+ _show $remtok(% [ $+ [ $mod ] $+ ] _show,%v,1,32) }
    }
    if ($did == 41) {
      var %v = size
      if (!$istok(% [ $+ [ $mod ] $+ ] _show,%v,32)) { set % $+ $mod $+ _show $addtok(% [ $+ [ $mod ] $+ ] _show,%v,32) }
      else { set % $+ $mod $+ _show $remtok(% [ $+ [ $mod ] $+ ] _show,%v,1,32) }
    }
    if ($did == 42) {
      var %v = genre
      if (!$istok(% [ $+ [ $mod ] $+ ] _show,%v,32)) { set % $+ $mod $+ _show $addtok(% [ $+ [ $mod ] $+ ] _show,%v,32) }
      else { set % $+ $mod $+ _show $remtok(% [ $+ [ $mod ] $+ ] _show,%v,1,32) }
    }
    if ($did == 43) {
      var %v = format
      if (!$istok(% [ $+ [ $mod ] $+ ] _show,%v,32)) { set % $+ $mod $+ _show $addtok(% [ $+ [ $mod ] $+ ] _show,%v,32) }
      else { set % $+ $mod $+ _show $remtok(% [ $+ [ $mod ] $+ ] _show,%v,1,32) }
    }
    if ($did == 44) {
      if (!% [ $+ [ $mod ] $+ ] _show_empty) { set % $+ $mod $+ _show_empty 1 }
      else { set % $+ $mod $+ _show_empty 0 }
    }
    if ($did == 12) {
      if (!% [ $+ [ $mod ] $+ ] _status) { set % $+ $mod $+ _status 1 }
      else { set % $+ $mod $+ _status 0 }
    }
    if ($did == 620) {
      if (!% [ $+ [ $mod ] $+ ] _output) { set % $+ $mod $+ _output 1 }
      else { set % $+ $mod $+ _output 0 }
    }
    if ($did == 520) {
      if (!% [ $+ [ $mod ] $+ ] _tiny) { set % $+ $mod $+ _tiny 1 }
      else { set % $+ $mod $+ _tiny 0 }
    }
    if ($did == 52) {
      if (!% [ $+ [ $mod ] $+ ] _strip) { set % $+ $mod $+ _strip 1 }
      else { set % $+ $mod $+ _strip 0 }
    }
    if ($did == 54) {
      if ($group(# [ $+ [ $mod ] $+ ] _menu_menubar) == on) { .disable # [ $+ [ $mod ] $+ ] _menu_menubar }
      else { .enable # [ $+ [ $mod ] $+ ] _menu_menubar }
    }
    if ($did == 55) {
      if ($group(# [ $+ [ $mod ] $+ ] _menu_status) == on) { .disable # [ $+ [ $mod ] $+ ] _menu_status }
      else { .enable # [ $+ [ $mod ] $+ ] _menu_status }
    }
    if ($did == 56) {
      if ($group(# [ $+ [ $mod ] $+ ] _menu_channel) == on) { .disable # [ $+ [ $mod ] $+ ] _menu_channel }
      else { .enable # [ $+ [ $mod ] $+ ] _menu_channel }
    }
    if ($did == 57) {
      if ($group(# [ $+ [ $mod ] $+ ] _menu_query) == on) { .disable # [ $+ [ $mod ] $+ ] _menu_query }
      else { .enable # [ $+ [ $mod ] $+ ] _menu_query }
    }
    if ($did == 58) {
      if ($group(# [ $+ [ $mod ] $+ ] _menu_nicklist) == on) { .disable # [ $+ [ $mod ] $+ ] _menu_nicklist }
      else { .enable # [ $+ [ $mod ] $+ ] _menu_nicklist }
    }
    if ($did == 4) { 
      if ($did($did).seltext) { did -e $dname 7 }
    }
    if ($did == 15) { 
      if ($did($did).seltext) { did -e $dname 17 }
    }
    if ($did == 7) {
      did -b $dname $did
      var %s = $did(4).seltext
      if (!%s) { return }
      var %net = $gettok(%s,1,32)
      var %chan = $gettok(%s,3,32)
      set % $+ $mod $+ _ignore_ $+ %net $+ _chans $remtok(% [ $+ [ $mod ] $+ ] _ignore_ [ $+ [ %net ] $+ ] _chans,%chan,1,32)
      if (!% [ $+ [ $mod ] $+ ] _ignore_ [ $+ [ %net ] $+ ] _chans) { 
        unset % $+ $mod $+ _ignore_ $+ %net $+ _chans
        set % $+ $mod $+ _ignore_chans_networks $remtok(% [ $+ [ $mod ] $+ ] _ignore_chans_networks,%net,1,32)
        if (!% [ $+ [ $mod ] $+ ] _ignore_chans_networks) { unset % $+ $mod $+ _ignore_chans_networks }
      }
      wmm_ignore_cn_list
    }
    if ($did == 17) {
      did -b $dname $did
      var %s = $did(15).seltext
      if (!%s) { return }
      var %net = $gettok(%s,1,32)
      var %nick = $gettok(%s,3,32)
      set % $+ $mod $+ _ignore_ $+ %net $+ _nicks $remtok(% [ $+ [ $mod ] $+ ] _ignore_ [ $+ [ %net ] $+ ] _nicks,%nick,1,32)
      if (!% [ $+ [ $mod ] $+ ] _ignore_ [ $+ [ %net ] $+ ] _nicks) { 
        unset % $+ $mod $+ _ignore_ $+ %net $+ _nicks
        set % $+ $mod $+ _ignore_nicks_networks $remtok(% [ $+ [ $mod ] $+ ] _ignore_nicks_networks,%net,1,32)
        if (!% [ $+ [ $mod ] $+ ] _ignore_nicks_networks) { unset % [ $+ [ $mod ] $+ ] _ignore_nicks_networks }
      }
      wmm_ignore_cn_list
    }
    if ($did == 6) {
      var %net = $input($lang(27),eidbk60,$addon $wmm_bel $lang(22))
      if (!$dialog($dname)) { return }
      if (!%net) { $mod $+ _sets | return }
      if ($numtok(%net,32) !== 1) { wmm_input error 60 $lang(28) | $mod $+ _sets | return }
      if ($len(%net) > 50) { wmm_input error 60 $lang(29) | $mod $+ _sets | return }
      var %chan = $input($lang(30),eidbk60,$addon $wmm_bel $lang(22))
      if (!$dialog($dname)) { return }
      if (!%chan) { $mod $+ _sets | return }
      if ($numtok(%chan,32) !== 1) { wmm_input error 60 $lang(31) | $mod $+ _sets | return }
      if ($numtok(%chan,44) !== 1) { wmm_input error 60 $lang(31) | $mod $+ _sets | return }
      if ($left(%chan,1) !== $chr(35)) { wmm_input error 60 $lang(32) | $mod $+ _sets | return }
      if ($istok(% [ $+ [ $mod ] $+ ] _ignore_ [ $+ [ %net ] $+ ] _chans,%chan,32)) { wmm_input error 60 $lang(33) | $mod $+ _sets | return }
      set % $+ $mod $+ _ignore_ $+ %net $+ _chans $addtok(% [ $+ [ $mod ] $+ ] _ignore_ [ $+ [ %net ] $+ ] _chans,%chan,32)
      if (!$istok(% [ $+ [ $mod ] $+ ] _ignore_chans_networks,%net,32)) { set % $+ $mod $+ _ignore_chans_networks $addtok(% [ $+ [ $mod ] $+ ] _ignore_chans_networks,%net,32) }
      wmm_ignore_cn_list
      $mod $+ _sets
    }
    if ($did == 16) {
      var %net = $input($lang(27),eidbk60,$addon $wmm_bel $lang(22))
      if (!$dialog($dname)) { return }
      if (!%net) { $mod $+ _sets | return }
      if ($numtok(%net,32) !== 1) { wmm_input error 60 $lang(28) | $mod $+ _sets | return }
      if ($len(%net) > 50) { wmm_input error 60 $lang(29) | $mod $+ _sets | return }
      var %nick = $input($lang(21),eidbk60,$addon $wmm_bel $lang(22))
      if (!$dialog($dname)) { return }
      if (!%nick) { $mod $+ _sets | return }
      if ($numtok(%nick,32) !== 1) { wmm_input error 60 $lang(35) | $mod $+ _sets | return }
      if ($istok(% [ $+ [ $mod ] $+ ] _ignore_ [ $+ [ %net ] $+ ] _nicks,%nick,32)) { wmm_input error 60 $lang(34) | $mod $+ _sets | return }
      set % $+ $mod $+ _ignore_ $+ %net $+ _nicks $addtok(% [ $+ [ $mod ] $+ ] _ignore_ [ $+ [ %net ] $+ ] _nicks,%nick,32)
      if (!$istok(% [ $+ [ $mod ] $+ ] _ignore_nicks_networks,%net,32)) { set % $+ $mod $+ _ignore_nicks_networks $addtok(% [ $+ [ $mod ] $+ ] _ignore_nicks_networks,%net,32) }
      wmm_ignore_cn_list
      $mod $+ _sets
    }
    if ($did == 8) {
      did -b $dname 8,7
      var %z = 1
      while (%z <= $numtok(% [ $+ [ $mod ] $+ ] _ignore_chans_networks,32)) {
        var %net = $gettok(% [ $+ [ $mod ] $+ ] _ignore_chans_networks,%z,32)     
        if (% [ $+ [ $mod ] $+ ] _ignore_ [ $+ [ %net ] $+ ] _chans) { unset % $+ $mod $+ _ignore_ $+ %net $+ _chans }
        inc %z
      }
      unset % $+ $mod $+ _ignore_chans_networks
      wmm_ignore_cn_list
    }
    if ($did == 18) {
      did -b $dname 18,17
      var %z = 1
      while (%z <= $numtok(% [ $+ [ $mod ] $+ ] _ignore_nicks_networks,32)) {
        var %net = $gettok(% [ $+ [ $mod ] $+ ] _ignore_nicks_networks,%z,32)     
        if (% [ $+ [ $mod ] $+ ] _ignore_ [ $+ [ %net ] $+ ] _nicks) { unset % $+ $mod $+ _ignore_ $+ %net $+ _nicks }
        inc %z
      }
      unset % $+ $mod $+ _ignore_nicks_networks
      wmm_ignore_cn_list
    }
  }
  return
  :error | wmm_werror $addon $scriptline $error | reseterror
}

ON *:LOAD: { 
  if (!$manager) { noop $input(You must first download and install the $qt($upper($ [ $+ [ $mod ] $+ ] _owner) Module Manager) and install that module from the manager in order to work that module!,houdbk60,Error) | url $help_url | .unload -nrs $qt($script) | return }
  if ($wmm_error) { noop $input(There was an error due installing that module because there are missing some several functions from the $qt($upper($ [ $+ [ $mod ] $+ ] _owner) Module Manager) project source code!!! $+ $+ $crlf $crlf Error Code: $wmm_error,houdbk60,WMM -> Error) | .unload -nrs $qt($script) | return }
  if ($group(# [ $+ [ $lower($addon) ] ] ).fname !== $script) { wmm_input error 60 This module cannot work more than one time into this client because you already have this module installed! | .unload -nrs $qt($script) | return }
  wmm_dl $main_ico_url $qt($scriptdir $+ $mod $+ _main.ico)
  wmm_dl $lang_url $qt($scriptdir $+ $mod $+ _lang.ini)
  if (% [ $+ [ $mod ] $+ ] _status == $null) { set % $+ $mod $+ _status 1 }
  if (% [ $+ [ $mod ] $+ ] _tiny == $null) { set % $+ $mod $+ _tiny 1 }
  if (% [ $+ [ $mod ] $+ ] _strip == $null) { set % $+ $mod $+ _strip 0 }
  if (% [ $+ [ $mod ] $+ ] _show_empty == $null) { set % $+ $mod $+ _show_empty 0 }
  if (% [ $+ [ $mod ] $+ ] _output == $null) { set % $+ $mod $+ _output 0 }
  if (% [ $+ [ $mod ] $+ ] _lang == $null) { set % $+ $mod $+ _lang English }
  if (% [ $+ [ $mod ] $+ ] _max_results == $null) { set % $+ $mod $+ _max_results 3 }
  if (% [ $+ [ $mod ] $+ ] _prefix_nick == $null) { set % $+ $mod $+ _prefix_nick ! }
  if (% [ $+ [ $mod ] $+ ] _prefix_chan == $null) { set % $+ $mod $+ _prefix_chan @ }
  if (% [ $+ [ $mod ] $+ ] _title_chars_max == $null) { set % $+ $mod $+ _title_chars_max 100 }
  if (% [ $+ [ $mod ] $+ ] _desc_chars_max == $null) { set % $+ $mod $+ _desc_chars_max 50 }
  if (% [ $+ [ $mod ] $+ ] _uploaded_on_format == $null) { set % $+ $mod $+ _uploaded_on_format $wmm_d_format }
  if (% [ $+ [ $mod ] $+ ] _show == $null) { set % $+ $mod $+ _show title link uploaded_on uploaded_by downloads views length likes }
  hfree -w $mod $+ _*
  .signal -n wmm_close
  .signal -n wmm_hash
  return
  :error | wmm_werror $addon $scriptline $error | reseterror
}

ON *:UNLOAD: {
  if ($dialog( [ $+ [ $mod ] $+ ] _sets)) { dialog -x $v1 }
  var %1 = $scriptdir $+ $mod $+ _main.ico
  var %2 = $scriptdir $+ $mod $+ _lang.ini
  if ($isfile(%1)) { .remove $qt(%1) }
  if ($isfile(%2)) { .remove $qt(%2) }
  .timer[ $+ $mod $+ _*] off
  unset % $+ $mod $+ _*
  hfree -w $mod $+ _*
  .signal -n wmm_close
  return
  :error | wmm_werror $addon $scriptline $error | reseterror
}

ON $*:TEXT:$(/^(\Q $+ $replacecs(%wss_prefix_nick,\E,\E\\E\Q) $+ \E|\Q $+ $replacecs(%wss_prefix_chan,\E,\E\\E\Q) $+ \E).*/Si):#: {
  if (!$manager) || ($wmm_error) || (!% [ $+ [ $mod ] $+ ] _status) || ($istok(% [ $+ [ $mod ] $+ ] _ignore_ [ $+ [ $network ] $+ ] _chans,$chan,32)) || ($istok(% [ $+ [ $mod ] $+ ] _ignore_ [ $+ [ $network ] $+ ] _nicks,$nick,32)) { return }
  tokenize 32 $strip($1-)
  var %cn = $network $+ ~ $+ $nick $+ ~ $+ $chan
  if ($hget( [ $+ [ $mod ] $+ ] _FLOOD,%cn)) { return }
  if ($1 == %wss_prefix_nick $+ soundcloud) {
    hadd -mu6 $upper($mod) $+ _FLOOD %cn 1
    if (!$2) { $iif(% [ $+ [ $mod ] $+ ] _output,notice,.notice) $nick ( $+ $wmm_bold($nick) $+ ): $lang(37) - $lang(38) $wmm_bold($1 < $+ $wmm_under($lang(46)) $+ >) - ( $+ $lang(39) $wmm_bold($1 $wmm_under($addon)) $+ ) | return }
    $mod $+ _soundcloud_search $nick $chan $iif(% [ $+ [ $mod ] $+ ] _output,notice,.notice) $2-
  }
  if ($1 == %wss_prefix_chan $+ soundcloud) {
    hadd -mu6 $upper($mod) $+ _FLOOD %cn 1
    if (!$2) { $iif(% [ $+ [ $mod ] $+ ] _output,msg,.msg) $chan ( $+ $wmm_bold($nick) $+ ): $lang(37) - $lang(38) $wmm_bold($1 < $+ $wmm_under($lang(46)) $+ >) - ( $+ $lang(39) $wmm_bold($1 $wmm_under($addon)) $+ ) | return }
    $mod $+ _soundcloud_search $nick $chan $iif(% [ $+ [ $mod ] $+ ] _output,msg,.msg) $2-
  }
  return
  :error | wmm_werror $addon $scriptline $error | reseterror
}

; --- End of events ---

; --- Start of aliases ---

alias wss_ver { return $right($gettok($read($script,n,6),3,32),3) }
alias wss_crdate { return $remove($gettok($read($script,n,6),5,32),$chr(40),$chr(41)) }
alias wss_owner { return $+($chr(119),$chr(101),$chr(115),$chr(116),$chr(111),$chr(114)) }
alias -l mod { return wss }
alias -l manager { return $iif($isalias(wmm_ver),$wmm_ver,0) }
alias -l key { return $iif($hget( [ $+ [ $mod ] $+ ] _KEYS,KEY),$v1,0) }
alias -l addon { return $gettok($read($script,n,5),3,32) }
alias -l help_url { return $+(http://,$ [ $+ [ $mod ] $+ ] _owner,.ucoz.com/load/wmm/1-1-0-24) }
alias -l lang_url { return $+(http://,$ [ $+ [ $mod ] $+ ] _owner,.ucoz.com/wmm/languages/,$mod,_lang.ini) }
alias -l main_ico_url { return $+(http://,$ [ $+ [ $mod ] $+ ] _owner,.ucoz.com/wmm/images/,$mod,_main.ico) }

alias -l lang {
  var %f = $scriptdir $+ $mod $+ _lang.ini
  if (!% [ $+ [ $mod ] $+ ] _lang) { set % $+ $mod $+ _lang English }
  if (!$isfile(%f)) || (!$lines(%f)) || (!$isid) || (!$1) || ($1 !isnum) { return 0 }
  var %h = $upper($mod) $+ _LANG_ $+ % [ $+ [ $mod ] $+ ] _lang
  if (!$hget(%h)) && ($ini(%f,% [ $+ [ $mod ] $+ ] _lang)) { hmake %h 1000 | hload -i %h $qt(%f) % [ $+ [ $mod ] $+ ] _lang }
  var %r = $hget(%h,$1)
  if (%r) { return %r }
  else { return N/A }
  return
  :error | wmm_werror $scriptline $error | reseterror
}

; ########################################################## 

alias wss_sets { 
  if (!$manager) { noop $input(You must first download and install the $qt($upper($ [ $+ [ $mod ] $+ ] _owner) Module Manager) and install that module from the manager in order to work that module!,houdbk60,Error) | url $help_url | .unload -nrs $qt($script) | return }
  if ($wmm_error) { noop $input(There was an error due installing that module because there are missing some several functions from the $qt($upper($ [ $+ [ $mod ] $+ ] _owner) Module Manager) Module Manager) project source code!!! $+ $+ $crlf $crlf Error Code: $wmm_error,houdbk60,WMM -> Error) | .unload -nrs $qt($script) | return }
  if ($group(# [ $+ [ $lower($addon) ] ] ).fname !== $script) { wmm_input error 60 This module cannot work more than one time into this client because you already have this module installed! | .unload -nrs $qt($script) | return }
  var %d = $mod $+ _sets
  if ($dialog(%d)) { dialog -ve %d %d | return }
  var %i = $scriptdir $+ $mod $+ _main.ico
  var %l = $scriptdir $+ $mod $+ _lang.ini
  var %n = $wmm_dir $+ donate.png
  if (!$isfile(%l)) || (!$isfile(%i)) || (!$isfile(%n)) || (!$file(%l)) || (!$file(%i)) || (!$file(%n)) { var %delay = 1 }
  if (%delay) {
    if (!$wmm_internet) { wmm_input error 60 There are some require files that missing from this module, there must be an internet connection in order to download them! | return }
    wmm_dl $main_ico_url $qt(%i)
    wmm_dl $lang_url $qt(%l)
    wmm_dl $wmm_donate_png_url $qt(%n)
    .timer[ $+ $mod $+ _DELAY_DL_AND_OPEN] -o 1 3 $mod $+ _sets_reopen 
    wmm_input warn 3 Downloading some require module files...
    return 
  }
  dialog -md %d %d
  return
  :error | wmm_werror $addon $scriptline $error | reseterror
}

alias -l wss_sets_reopen {
  var %i = $scriptdir $+ $mod $+ _main.ico
  var %l = $scriptdir $+ $mod $+ _lang.ini
  var %n = $wmm_dir $+ donate.png
  if (!$isfile(%l)) || (!$isfile(%i)) || (!$isfile(%n)) || (!$file(%l)) || (!$file(%i)) || (!$file(%n)) { wmm_input error 60 FATAL ERROR! @newline@ @newline@ $+ Error Code: 0xm001 | return }
  $mod $+ _sets
  return
  :error | wmm_werror $addon $scriptline $error | reseterror
}

alias wss_soundcloud_search {
  if (!$wmm_internet) || (!$1-) || (!$key) { return }
  if (msg isin $3) { var %output = $3 $2 }
  elseif (notice isin $3) { var %output = $3 $1 }
  if (!% [ $+ [ $mod ] $+ ] _show) { set % $+ $mod $+ _show title link }
  if (!% [ $+ [ $mod ] $+ ] _title_chars_max) || (!$wmm_isdigit(% [ $+ [ $mod ] $+ ] _title_chars_max)) || (% [ $+ [ $mod ] $+ ] _title_chars_max > 300) { set % $+ $mod $+ _title_chars_max 100 }
  if (!% [ $+ [ $mod ] $+ ] _desc_chars_max) || (!$wmm_isdigit(% [ $+ [ $mod ] $+ ] _desc_chars_max)) || (% [ $+ [ $mod ] $+ ] _desc_chars_max > 300) { set % $+ $mod $+ _desc_chars_max 50 }
  if (!% [ $+ [ $mod ] $+ ] _max_results) || (!$wmm_isdigit(% [ $+ [ $mod ] $+ ] _max_results)) || (% [ $+ [ $mod ] $+ ] _max_results > 9) { set % $+ $mod $+ _max_results 3 }
  if (!% [ $+ [ $mod ] $+ ] _uploaded_on_format) || (!$wmm_cdate(% [ $+ [ $mod ] $+ ] _uploaded_on_format)) { set % $+ $mod $+ _uploaded_on_format $wmm_d_format }
  var %v = soundcloud_ $+ $wmm_random

  jsonopen -ud %v https://api.soundcloud.com/tracks/?client_id= $+ $key $+ &q= $+ $wmm_urlencode($4-) $+ &format=json&limit= $+ % [ $+ [ $mod ] $+ ] _max_results
  if ($jsonerror) { var %m = ( $+ $wmm_bold($1) $+ ): $lang(40) - ( $+ $lang(41) $wmm_bold($jsonerror) $+ ) | %output $iif(% [ $+ [ $mod ] $+ ] _strip,$strip(%m),%m) | return }

  var %tot = $json(%v).length
  if (!%tot) { var %m = ( $+ $wmm_bold($1) $+ ): $lang(42) | %output $iif(% [ $+ [ $mod ] $+ ] _strip,$strip(%m),%m) | return }
  var %x = 0
  while (%x < % [ $+ [ $mod ] $+ ] _max_results) {

    var %id = $json(%v,%x,id).value
    if (!%id) { goto next }
    var %total = $calc(%total +1)

    if ($istok(% [ $+ [ $mod ] $+ ] _show,title,32)) { 
      var %title = $wmm_html2asc($wmm_fixtab($json(%v,%x,title).value))
      if (%title) && ($len(%title) >= % [ $+ [ $mod ] $+ ] _title_chars_max) { var %title = $left(%title,$calc(% [ $+ [ $mod ] $+ ] _title_chars_max -3)) $+ ... }
      if (!%title) { var %title = $lang(67) }
    }
    if ($istok(% [ $+ [ $mod ] $+ ] _show,description,32)) { 
      var %desc = $wmm_html2asc($wmm_fixtab($json(%v,%x,description).value))
      if (%desc) && ($len(%desc) >= % [ $+ [ $mod ] $+ ] _desc_chars_max) { var %desc = $left(%desc,$calc(% [ $+ [ $mod ] $+ ] _desc_chars_max -3)) $+ ... }
      if (!%desc) { var %desc = $lang(67) }
    }
    if ($istok(% [ $+ [ $mod ] $+ ] _show,genre,32)) {
      var %genre = $json(%v,%x,genre).value
      if (!%genre) { var %genre = $lang(67) }
    }
    if ($istok(% [ $+ [ $mod ] $+ ] _show,format,32)) { 
      var %format = $json(%v,%x,original_format).value
      if (!%format) { var %format = $lang(67) }
    }
    if ($istok(% [ $+ [ $mod ] $+ ] _show,uploaded_by,32)) {
      var %uploader = $json(%v,%x,user,username).value
      if (!%uploader) { var %uploader = $lang(67) }
    }
    if ($istok(% [ $+ [ $mod ] $+ ] _show,uploaded_on,32)) {
      var %crdate = $date($ctime($gettok($json(%v,%x,created_at).value,1-2,32)),% [ $+ [ $mod ] $+ ] _uploaded_on_format)
      if (!%crdate) { var %crdate = $lang(67) }
    }
    if ($istok(% [ $+ [ $mod ] $+ ] _show,link,32)) { 
      var %url = $json(%v,%x,permalink_url).value
      if (% [ $+ [ $mod ] $+ ] _tiny) && (%url) { var %url = $wmm_tinycom(%url) }
      if (!%url) { var %url = $lang(67) }
    }
    if ($istok(% [ $+ [ $mod ] $+ ] _show,length,32)) { 
      var %duration = $duration($left($json(%v,%x,duration).value,3),3)
      if (!%duration) { var %duration = 00:00:00 }
    }
    if ($istok(% [ $+ [ $mod ] $+ ] _show,favorites,32)) { var %favorite = $json(%v,%x,favoritings_count).value }
    if ($istok(% [ $+ [ $mod ] $+ ] _show,views,32)) { var %views = $json(%v,%x,playback_count).value }
    if ($istok(% [ $+ [ $mod ] $+ ] _show,comments,32)) { var %comments = $json(%v,%x,comment_count).value }
    if ($istok(% [ $+ [ $mod ] $+ ] _show,likes,32)) { var %likes = $json(%v,%x,likes_count).value }
    if ($istok(% [ $+ [ $mod ] $+ ] _show,reposts,32)) { var %reposts = $json(%v,%x,reposts_count).value }
    if ($istok(% [ $+ [ $mod ] $+ ] _show,size,32)) { var %size = $json(%v,%x,original_content_size).value }
    if ($istok(% [ $+ [ $mod ] $+ ] _show,downloads,32)) { var %downloads = $json(%v,%x,download_count).value }

    if (% [ $+ [ $mod ] $+ ] _show_empty) { 
      var %msg = .12Sound.12Cloud. →  $iif(%title !== $null,$wmm_bold($lang(49)) $+ :6 %title $+ ) $iif(%desc !== $null,$wmm_bold($lang(61)) $+ :14 %desc $+ ) $iif(%duration !== $null,$wmm_bold($lang(50)) $+ :10 %duration $+ ) $iif(%views !== $null,$wmm_bold($iif(%views == 1,$lang(43),$lang(51))) $+ :13 $gettok($bytes(%views,bd),1,46) $+ ) $iif(%likes !== $null,$wmm_bold($iif(%likes == 1,$lang(62),$lang(66))) $+ :3 $gettok($bytes(%likes,bd),1,46) $+ ) $iif(%size !== $null,$wmm_bold($lang(63)) $+ :2 $bytes(%size).suf $+ ) $iif(%genre !== $null,$wmm_bold($lang(64)) $+ :12 %genre $+ ) $iif(%format !== $null,$wmm_bold($lang(65)) $+ :5 %format $+ ) $iif(%favorites !== $null,$wmm_bold($iif(%favorites == 1,$lang(59),$lang(54))) $+ :12 $gettok($bytes(%favorites,bd),1,46) $+ ) $iif(%reposts !== $null,$wmm_bold($iif(%reposts == 1,$lang(45),$lang(53))) $+ :11 $gettok($bytes(%reposts,bd),1,46) $+ ) $iif(%downloads !== $null,$wmm_bold($iif(%downloads == 1,$lang(44),$lang(52))) $+ :4 $gettok($bytes(%downloads,bd),1,46) $+ ) $iif(%comments !== $null,$wmm_bold($iif(%comments == 1,$lang(60),$lang(55))) $+ :8 $gettok($bytes(%comments,bd),1,46) $+ ) $iif(%crdate !== $null,$wmm_bold($lang(56)) $+ :7 %crdate $+ ) $iif(%uploader !== $null,$wmm_bold($lang(57)) $+ :2 %uploader $+ ) $iif(%url !== $null,$wmm_bold($lang(58)) $+ : 12 $+ %url $+ )
      %output $iif(% [ $+ [ $mod ] $+ ] _strip,$strip(%msg),%msg)
    }
    elseif (!% [ $+ [ $mod ] $+ ] _show_empty) { 
      var %msg = .12Sound.12Cloud. →  $iif(%title,$wmm_bold($lang(49)) $+ :6 %title $+ ) $iif(%desc,$wmm_bold($lang(61)) $+ :14 %desc $+ ) $iif(%duration,$wmm_bold($lang(50)) $+ :10 %duration $+ ) $iif(%views,$wmm_bold($iif(%views == 1,$lang(43),$lang(51))) $+ :13 $gettok($bytes(%views,bd),1,46) $+ ) $iif(%likes,$wmm_bold($iif(%likes == 1,$lang(66),$lang(62))) $+ :3 $gettok($bytes(%likes,bd),1,46) $+ ) $iif(%size,$wmm_bold($lang(63)) $+ :2 $bytes(%size).suf $+ ) $iif(%genre,$wmm_bold($lang(64)) $+ :12 %genre $+ ) $iif(%format,$wmm_bold($lang(65)) $+ :5 %format $+ ) $iif(%favorites,$wmm_bold($iif(%favorites == 1,$lang(59),$lang(54))) $+ :12 $gettok($bytes(%favorites,bd),1,46) $+ ) $iif(%reposts,$wmm_bold($iif(%reposts == 1,$lang(45),$lang(53))) $+ :11 $gettok($bytes(%reposts,bd),1,46) $+ ) $iif(%downloads,$wmm_bold($iif(%downloads == 1,$lang(44),$lang(52))) $+ :4 $gettok($bytes(%downloads,bd),1,46) $+ ) $iif(%comments,$wmm_bold($iif(%comments == 1,$lang(60),$lang(55))) $+ :8 $gettok($bytes(%comments,bd),1,46) $+ ) $iif(%crdate,$wmm_bold($lang(56)) $+ :7 %crdate $+ ) $iif(%uploader,$wmm_bold($lang(57)) $+ :2 %uploader $+ ) $iif(%url,$wmm_bold($lang(58)) $+ : 12 $+ %url $+ )
      %output $iif(% [ $+ [ $mod ] $+ ] _strip,$strip(%msg),%msg)
    }

    :next
    inc %x  
  }
  if (!%total) { var %m = ( $+ $wmm_bold($1) $+ ): $lang(42) | %output $iif(% [ $+ [ $mod ] $+ ] _strip,$strip(%m),%m) }
  return
  :error | wmm_werror $addon $scriptline $error | reseterror
}

; --- End of aliases ---

; --- Start of menus ---

#wss_menu_menubar off
menu menubar { 
  -
  $iif($isalias(wmm_isadi) && $wmm_isadi && $isfile($scriptdir $+ $mod $+ _main.ico) && $file($scriptdir $+ $mod $+ _main.ico),$menuicon($scriptdir $+ $mod $+ _main.ico)) $iif($dialog( [ $+ [ $mod ] $+ ] _sets),$style(1)) $iif($isalias(wmm_qd),$wmm_qd($addon v $+ $ [ $+ [ $mod ] $+ ] _ver - $iif($lang(4),$v1,Settings) $+ ),* $addon v $+ $ [ $+ [ $mod ] $+ ] _ver - Settings *): $+ $mod $+ _sets
  -
}
#wss_menu_menubar end
#wss_menu_status off
menu status { 
  -
  $iif($isalias(wmm_isadi) && $wmm_isadi && $isfile($scriptdir $+ $mod $+ _main.ico) && $file($scriptdir $+ $mod $+ _main.ico),$menuicon($scriptdir $+ $mod $+ _main.ico)) $iif($dialog( [ $+ [ $mod ] $+ ] _sets),$style(1)) $iif($isalias(wmm_qd),$wmm_qd($addon v $+ $ [ $+ [ $mod ] $+ ] _ver - $iif($lang(4),$v1,Settings) $+ ),* $addon v $+ $ [ $+ [ $mod ] $+ ] _ver - Settings *): $+ $mod $+ _sets
  -
}
#wss_menu_status end
#wss_menu_channel off
menu channel { 
  -
  $iif($isalias(wmm_isadi) && $wmm_isadi && $isfile($scriptdir $+ $mod $+ _main.ico) && $file($scriptdir $+ $mod $+ _main.ico),$menuicon($scriptdir $+ $mod $+ _main.ico)) $iif($dialog( [ $+ [ $mod ] $+ ] _sets),$style(1)) $iif($isalias(wmm_qd),$wmm_qd($addon v $+ $ [ $+ [ $mod ] $+ ] _ver - $iif($lang(4),$v1,Settings) $+ ),* $addon v $+ $ [ $+ [ $mod ] $+ ] _ver - Settings *): $+ $mod $+ _sets
  -
}
#wss_menu_channel end
#wss_menu_nicklist off
menu nicklist { 
  -
  $iif($isalias(wmm_isadi) && $wmm_isadi && $isfile($scriptdir $+ $mod $+ _main.ico) && $file($scriptdir $+ $mod $+ _main.ico),$menuicon($scriptdir $+ $mod $+ _main.ico)) $iif($dialog( [ $+ [ $mod ] $+ ] _sets),$style(1)) $iif($isalias(wmm_qd),$wmm_qd($addon v $+ $ [ $+ [ $mod ] $+ ] _ver - $iif($lang(4),$v1,Settings) $+ ),* $addon v $+ $ [ $+ [ $mod ] $+ ] _ver - Settings *): $+ $mod $+ _sets
  -
}
#wss_menu_nicklist end
#wss_menu_query off
menu query { 
  -
  $iif($isalias(wmm_isadi) && $wmm_isadi && $isfile($scriptdir $+ $mod $+ _main.ico) && $file($scriptdir $+ $mod $+ _main.ico),$menuicon($scriptdir $+ $mod $+ _main.ico)) $iif($dialog( [ $+ [ $mod ] $+ ] _sets),$style(1)) $iif($isalias(wmm_qd),$wmm_qd($addon v $+ $ [ $+ [ $mod ] $+ ] _ver - $iif($lang(4),$v1,Settings) $+ ),* $addon v $+ $ [ $+ [ $mod ] $+ ] _ver - Settings *): $+ $mod $+ _sets
  -
}
#wss_menu_query end

; --- End of menus ---

; -- Start of groups ---

#soundcloud-search off
#soundcloud-search end

; -- End of groups ---

; ------------------------------------------------------------------------------ WSS EOF ------------------------------------------------------------------------------
