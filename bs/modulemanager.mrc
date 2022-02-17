/*

######################################

	# WESTOR Module Manager #
	 # v3.0 - (09/07/2016) #
	  # Thanks Supporters #

######################################

*/

; --- Start of dialogs ---

dialog -l wmm_module_sets {
  title ""
  size -1 -1 233 108
  option dbu disable
  tab "Settings 1", 1, 2 2 230 77
  icon $scriptdir $+ main.ico, 0
  list 3, 4 30 99 47, tab 1 size vsbar disable
  button $chr(9654), 4, 112 33 14 12, tab 1 disable
  text "Available Modules:", 7, 5 20 97 9, tab 1 center
  button $chr(9664), 6, 112 62 14 12, tab 1 disable
  list 5, 135 30 94 47, tab 1 size vsbar disable
  text "Auto-Update Modules:", 8, 136 20 92 9, tab 1 center
  tab "Settings 2", 9
  combo 10, 4 30 64 47, tab 9 size drop
  text "Language:", 11, 7 20 62 8, tab 9 center
  check "Automatically update the WESTOR Module Manager", 12, 4 68 225 10, tab 9
  check "Display the project menu item in the right click menu", 25, 4 48 225 10, tab 9
  check "Display the project settings menu item in the right click menu", 26, 4 58 225 10, tab 9
  tab "Settings 3", 27
  check "Display the project installed modules list item in the right click menu", 28, 4 18 225 10, tab 27
  check "Slow down all the screenshots downloading progress of the modules", 29, 4 28 225 10, tab 27
  button "Close this window", 2, 61 91 117 16, ok default
  text "", 13, 211 98 21 8, disable center
  menu "Menu", 14
  item "Help", 18, 14
  item break, 501
  item "Donate & Support", 24, 14
  item break, 502
  item "Open the WESTOR Module Manager", 19, 14
  item break, 505
  item "About", 20, 14
  item break, 503
  item "Restart", 21, 14
  item break, 504
  item "Exit", 22, 14
}

dialog -l wmm_module {
  title ""
  size -1 -1 265 265
  option dbu disable
  icon $scriptdir $+ main.ico, 0
  button "Close this window", 1, 48 249 165 15, default ok
  tab "Modules", 2, 2 2 262 189
  button "Install", 7, 200 99 61 12, disable tab 2
  tab "Installed", 3
  button "Uninstall", 11, 200 99 61 12, disable tab 3
  button "Reinstall", 12, 4 99 61 12, disable tab 3
  tab "Updates", 4
  button "Update", 13, 200 99 61 12, disable tab 4
  text "", 5, 246 255 18 8, disable center
  text "News:", 25, 80 195 100 8, center
  text "Loading the latest available news...", 26, 25 204 225 40, center
  list 6, 4 18 257 32, disable size vsbar
  list 60, 4 18 257 32, hide disable size vsbar
  list 600, 4 18 257 32, hide disable size vsbar
  text "Module Description:", 9, 75 57 113 8, center
  edit "" 8, 4 68 257 30, disable read multi autovs autohs vsbar center
  icon 15, 92 130 80 58, $scriptdir $+ no_preview.png, 1, noborder
  icon 16, 185 130 75 58, $scriptdir $+ no_preview.png, 1, noborder
  text "Module Screenshots:", 17, 75 117 113 8, center
  icon 14, 4 130 75 58, $scriptdir $+ no_preview.png, 1, noborder
  icon 23, 190 0 83 15, $scriptdir $+ main.ico, 1, noborder center
  menu "Menu", 10
  item "Help", 18, 10
  item break, 501
  item "Donate & Support", 24, 10
  item break, 502
  item "Options", 19, 10
  item break, 505
  item "About", 20, 10
  item break, 503
  item "Restart", 21, 10
  item break, 504
  item "Exit", 22, 10
}

; --- End of dialogs ---

; --- Start of events ---

ON *:START: {
  if ($version < 7.44) || ($wmm_check_os) || ($group(#wmm).fname !== $script) { .unload -nrs $qt($script) | return }
  wmm_fix_extra_modules_installed
  var %l = $scriptdir $+ wmm_lang.ini
  var %ico = $scriptdir $+ main.ico
  var %png = $scriptdir $+ no_preview.png
  var %don = $scriptdir $+ donate.png
  if (!$isfile(%l)) { var %delay = 1 | wmm_dl $wmm_lang_url $qt(%l) }
  if (!$isfile(%ico)) { var %delay = 1 | wmm_dl $wmm_main_ico_url $qt(%ico) }
  if (!$isfile(%png)) { var %delay = 1 | wmm_dl $wmm_main_png_url $qt(%png) }
  if (!$isfile(%don)) { var %delay = 1 | wmm_dl $wmm_donate_png_url $qt(%don) }
  if (%wmm_lang == $null) { set %wmm_lang English }
  if (!%delay) { wmm_tool -s }
  else { .timer[WMM_TOOLBAR] -ho 1 3000 wmm_tool -s }
  if (%wmm_autoupdate) { .timer[WMM_CHECK_FOR_UPDATE_SILENT] -ho 1 5000 wmm_check_silent_update }
  if (%wmm_autoupdate_modules) { .timer[WMM_CHECK_FOR_UPDATE_MODULES_SILENT] -ho 1 15000 wmm_modules_silent_update }
}

ON *:LOAD: { 
  if ($version < 7.44) { wmm_input error 60 $iif($wmm_lang(41),$wmm_lang(41),This program client version that you are using does NOT support the specific addon $+ $chr(44) please use the latest version that is available!) | .unload -nrs $qt($script) | return }
  if ($wmm_check_os) { wmm_input error 60 $iif($wmm_lang(42),$wmm_lang(42),This addon cannot be used into this computer $+ $chr(44) it's only available into Windows operating system!) | .unload -nrs $qt($script) | return }
  if ($group(#wmm).fname !== $script) { wmm_input error 60 $iif($wmm_lang(62),$wmm_lang(62),You have already installed this addon into this program client!) | .unload -nrs $qt($script) | return } 
  wmm_fix_extra_modules_installed
  var %l = $scriptdir $+ wmm_lang.ini
  var %ico = $scriptdir $+ main.ico
  var %png = $scriptdir $+ no_preview.png
  var %don = $scriptdir $+ donate.png
  if (!$isfile(%l)) { wmm_dl $wmm_lang_url $qt(%l) }
  if (!$isfile(%ico)) { wmm_dl $wmm_main_ico_url $qt(%ico) }
  if (!$isfile(%png)) { wmm_dl $wmm_main_png_url $qt(%png) }
  if (!$isfile(%don)) { wmm_dl $wmm_donate_png_url $qt(%don) }
  if (%wmm_menu == $null) { set %wmm_menu wmm wmm_sets }
  if (%wmm_lang == $null) { set %wmm_lang English }
  if (%wmm_slow_images == $null) { set %wmm_slow_images 0 }
  if (%wmm_autoupdate == $null) { set %wmm_autoupdate 0 }
  if (%wmm_update) {
    var %up = %wmm_update
    unset %wmm_update
    wmm_dl $wmm_main_ico_url $qt(%ico) 
    wmm_dl $wmm_lang_url $qt(%l) 
    wmm_dl $wmm_main_png_url $qt(%png)
    if (%up == 1) { wmm_input ok 60 $wmm_lang(43) | .timer[WMM_OPEN] -ho 1 2000 wmm }
    wmm_tool -s
  }
  else { wmm_input ok 60 $wmm_lang(38) $upper($wmm_owner) $wmm_lang(16) v $+ $wmm_ver $wmm_lang(28) $wmm_crdate $wmm_lang(29) $wmm_owner $wmm_lang(39) | wmm_tool -s | .timer[WMM_OPEN] -ho 1 1000 wmm }
}

ON *:UNLOAD: { 
  wmm_d_close wmm_module
  wmm_d_close wmm_module_sets
  wmm_tool -c
  wmm_jsondebug off
  if ($wmm_lang(38)) && ($wmm_lang(16)) && ($wmm_lang(28)) && ($wmm_lang(29)) && ($wmm_lang(40)) { wmm_input ok 60 $wmm_lang(38) $upper($wmm_owner) $wmm_lang(16) v $+ $wmm_ver $wmm_lang(28) $wmm_crdate $wmm_lang(29) $wmm_owner $wmm_lang(40) }
  var %l = $scriptdir $+ wmm_lang.ini
  var %ico = $scriptdir $+ main.ico
  var %png = $scriptdir $+ no_preview.png
  var %don = $scriptdir $+ donate.png
  if ($isfile(%l)) { .remove -b $qt(%l) }
  if ($isfile(%ico)) { .remove -b $qt(%ico) }
  if ($isfile(%png)) { .remove -b $qt(%png) }
  if ($isfile(%don)) { .remove -b $qt(%don) }
  unset %wmm_*
}

CTCP *:VERSION:*: { .ctcpreply $nick VERSION $chr(3) $+ $color(info) $+ ( $+ $chr(3) $+ $color(ctcp) $+ $wmm_bold($nick) $+ $chr(3) $+ $color(info) $+ ): $upper($wmm_owner) Module Manager $wmm_under(v) $+ $wmm_bold($wmm_ver) Created by: $wmm_bold($wmm_owner) on: $wmm_bold($wmm_crdate) - Download it from: $wmm_bold($wmm_under($wmm_page)) }

ON *:DIALOG:wmm_module_sets:*:*: {
  if ($devent == init) {
    dialog -t $dname $upper($wmm_owner) $wmm_lang(16) $wmm_lang(69) $wmm_bel (/wmm_sets)
    did -ra $dname 1 $wmm_lang(69) 1
    did -ra $dname 9 $wmm_lang(69) 2
    did -ra $dname 7 $wmm_lang(67)
    did -ra $dname 8 $wmm_lang(68)
    did -ra $dname 11 $wmm_lang(32)
    did -ra $dname 12 $wmm_lang(31)
    did -ra $dname 2 $wmm_lang(1)
    did -o $dname 14 $wmm_lang(11)
    did -o $dname 18 $wmm_lang(12)
    did -o $dname 24 $wmm_lang(45) $chr(38) $+ $chr(38) $wmm_lang(46)
    did -o $dname 19 $wmm_lang(70) $upper($wmm_owner) $wmm_lang(16)
    did -o $dname 20 $wmm_lang(14)
    did -o $dname 21 $wmm_lang(30)
    did -o $dname 22 $wmm_lang(15)
    did -ra $dname 25 $wmm_lang(71)
    did -ra $dname 26 $wmm_lang(72)
    did -ra $dname 13 v $+ $wmm_ver
    did -ra $dname 27 $wmm_lang(69) 3
    did -ra $dname 28 $wmm_lang(78)
    did -ra $dname 29 $wmm_lang(79)

    if (%wmm_slow_images) { did -c $dname 29 }
    if (%wmm_autoupdate) { did -c $dname 12 }
    if ($istok(%wmm_menu,wmm,32)) { did -c $dname 25 }
    if ($istok(%wmm_menu,wmm_sets,32)) { did -c $dname 26 }
    if ($istok(%wmm_menu,wmm_mod_list,32)) { did -c $dname 28 }
    var %langs = $wmm_langs
    if (%langs) {
      var %i = 1
      while (%i <= $numtok(%langs,44)) {
        var %l = $gettok(%langs,%i,44)
        if (%l) && (%l !== %wmm_lang) { did -a $dname 10 %l }
        inc %i
      }
      did -ca $dname 10 %wmm_lang
    }
    else { did -b $dname 10 }
    if ($wmm_internet) { wmm_modules_settings_auto_update_list | wmm_modules_settings_list }
    wmm_tool -e
    wmm_tool -t
  }
  if ($devent == sclick) {
    if ($did == 25) {
      if (!$istok(%wmm_menu,wmm,32)) { set %wmm_menu $addtok(%wmm_menu,wmm,32) }
      else { set %wmm_menu $remtok(%wmm_menu,wmm,1,32) }
    }
    if ($did == 26) {
      if (!$istok(%wmm_menu,wmm_sets,32)) { set %wmm_menu $addtok(%wmm_menu,wmm_sets,32) }
      else { set %wmm_menu $remtok(%wmm_menu,wmm_sets,1,32) }
    }
    if ($did == 28) {
      if (!$istok(%wmm_menu,wmm_mod_list,32)) { set %wmm_menu $addtok(%wmm_menu,wmm_mod_list,32) }
      else { set %wmm_menu $remtok(%wmm_menu,wmm_mod_list,1,32) }
    }
    if ($did == 12) {
      if (!%wmm_autoupdate) { set %wmm_autoupdate 1 }
      else { set %wmm_autoupdate 0 }
    }
    if ($did == 29) {
      if (!%wmm_slow_images) { set %wmm_slow_images 1 }
      else { set %wmm_slow_images 0 }
    }
    if ($did == 5) && ($did(5).seltext) { did -e $dname 6 }
    if ($did == 3) && ($did(3).seltext) { did -e $dname 4 }
    if ($did == 4) { 
      var %s = $did(3).seltext
      if (!%s) { did -b $dname $did | return }
      did -ed $dname 3 $didwm(3,%s)
      did -u $dname 3
      did -ae $dname 5 %s
      did -b $dname 4
      set %wmm_autoupdate_modules $addtok(%wmm_autoupdate_modules,%s,32)
    }
    if ($did == 6) { 
      var %s = $did(5).seltext
      if (!%s) { did -b $dname $did | return }
      did -ed $dname 5 $didwm(5,%s)
      did -u $dname 5
      did -ae $dname 3 %s
      did -b $dname 6
      set %wmm_autoupdate_modules $remtok(%wmm_autoupdate_modules,%s,1,32)
    }
  }
  if ($devent == menu) {
    if ($did == 18) { url $wmm_page }
    if ($did == 24) { url $wmm_donate }
    if ($did == 22) { dialog -k $dname }
    if ($did == 21) { dialog -k $dname | .timer -ho 1 500 wmm_sets }
    if ($did == 20) { wmm_input ok 60 $wmm_lang(27) $wmm_lang(16) v $+ $wmm_ver $wmm_lang(28) $wmm_crdate $wmm_lang(29) $wmm_owner }
    if ($did == 19) { .timer -ho 1 100 wmm | dialog -k $dname }
  }
  if ($devent == close) {
    if ($did(10)) { set %wmm_lang $did(10) }
    wmm_tool -b
    wmm_tool -t
    .timer[WMM_*] off
    if ($dialog(wmm_module)) { wmm }
  }
}

ON *:DIALOG:wmm_module:*:*: {
  if ($devent == init) {
    var %f = $scriptdir $+ wmm_lang.ini
    var %don = $scriptdir $+ donate.png
    var %img = $scriptdir $+ no_preview.png
    if (!$isfile(%f)) { dialog -k $dname | wmm_input error 60 FATAL ERROR! @newline@ @newline@ $+ Error Code: 001 | return }
    if (!$isfile(%img)) { dialog -k $dname | wmm_input error 60 $wmm_lang(17) @newline@ @newline@ $+ $wmm_lang(18) 010 | return }
    if (!$isfile(%don)) { dialog -k $dname | wmm_input error 60 $wmm_lang(17) @newline@ @newline@ $+ $wmm_lang(18) 016 | return }
    dialog -t $dname $upper($wmm_owner) $wmm_lang(16) v $+ $wmm_ver $wmm_bel (/wmm) 
    did -ra $dname 1 $wmm_lang(1)
    did -ra $dname 2 $wmm_lang(3)
    did -ra $dname 3 $wmm_lang(2)
    did -ra $dname 7 $wmm_lang(4)
    did -ra $dname 11 $wmm_lang(5)
    did -ra $dname 12 $wmm_lang(6)
    did -ra $dname 4 $wmm_lang(7)
    did -ra $dname 13 $wmm_lang(8)
    did -ra $dname 9 $wmm_lang(9)
    did -ra $dname 17 $wmm_lang(10)
    did -o $dname 10 $wmm_lang(11)
    did -o $dname 18 $wmm_lang(12)
    did -o $dname 19 $wmm_lang(13)
    did -o $dname 20 $wmm_lang(14)
    did -o $dname 21 $wmm_lang(30)
    did -o $dname 22 $wmm_lang(15)
    did -o $dname 24 $wmm_lang(45) $chr(38) $+ $chr(38) $wmm_lang(46)
    did -ra $dname 5 v $+ $wmm_ver
    did -g $dname 14,15,16 0 $qt(%img)
    did -g $dname 23 $qt(%don)
    did -ra $dname 25 $wmm_lang(57)
    did -ra $dname 26 $wmm_lang(61)
    wmm_tool -t
    wmm_tool -e
    if ($wmm_internet) { 
      wmm_check_update
      .timer[WMM_GET_MODULES_LiST] -oh 1 300 wmm_modules_list
      .timer[WMM_GET_MODULES_INSTALLED_AND_CHECK_UPDATE_LIST] -oh 1 400 wmm_modules_installed_plus_updated_list
    }
    else { did -ra $dname 26 $wmm_lang(58) }
  }
  if ($devent == close) {
    wmm_tool -b
    .timer[WMM_*] off
    if ($hget(WMM_MODULES)) { hfree $v1 }
    if ($dialog(wmm_module_sets)) { wmm_sets }
  }
  if ($devent == dclick) { 
    if ($did == 60) {
      var %m = $did($did).seltext
      if (!%m) { return }
      var %h = WMM_MODULES
      var %chk = $hget(%h,%m $+ _check_version_alias)
      var %chk_sets_alias = $right($replace(%chk,_ver,_sets),-1)
      if (%chk_sets_alias) && ($isalias(%chk_sets_alias)) { $(%chk_sets_alias,2) }
    }
  }
  if ($devent == sclick) {
    if ($did) && ($did !== 6) && ($did !== 60) && ($did !== 600) && (!$did(6).sel) && (!$did(60).sel) && (!$did(600).sel) { did -fv $dname 23 }
    if ($did == 23) { url $wmm_donate }
    if ($did == 2) { 
      var %h = WMM_MODULES
      if ($hget(%h,DID_60)) { hdel %h DID_60 }
      did -hu $dname 6,60,600 
      did -v $dname 6
      wmm_reset_images
      wmm_modules_installed_plus_updated_list
    }
    if ($did == 3) {
      var %h = WMM_MODULES
      if ($hget(%h,DID_6)) { hdel %h DID_6 }
      did -hu $dname 6,60,600
      did -v $dname 60 
      wmm_reset_images
      wmm_modules_installed_plus_updated_list
    }
    if ($did == 4) {
      var %h = WMM_MODULES
      if ($hget(%h,DID_6)) { hdel %h DID_6 }
      if ($hget(%h,DID_60)) { hdel %h DID_60 }
      did -hu $dname 6,60,600
      did -v $dname 600
      wmm_reset_images 
      wmm_modules_installed_plus_updated_list
    }
    if ($did == 600) {
      var %m = $did($did).seltext
      if (!$wmm_getpath(%m)) { wmm_modules_installed_plus_updated_list | return }
      if (%m) { 
        var %h = WMM_MODULES
        did -e $dname 13,8

        var %chk_ver = $hget(%h,%m $+ _check_version_alias)
        var %upver = $hget(%h,%m $+ _version)
        var %ver = $iif($isalias($right(%chk_ver,-1)),$(%chk_ver,2),0)

        var %chk_chan = $hget(%h,%m $+ _channel)
        if (%chk_chan) && (%chk_chan == NOT_OK) { did -b $dname 13 }

        did -r $dname 8
        did -a $dname 8 $wmm_lang(54) $+ : $iif(%ver,$v1,N/A)
        did -a $dname 8 $crlf
        did -a $dname 8 $wmm_lang(55) $+ : $iif(%upver,$v1,N/A)
        did -c $dname 8 1 1
      }
      else { did -b $dname 13,8 }
    }
    if ($did == 6) {
      var %h = WMM_MODULES
      var %m = $did($did).seltext
      if ($hget(%h,DID_6) == %m) { return }
      hadd -m %h DID_6 %m
      var %desc = $hget(%h,%m $+ _desc)
      var %imgs = $hget(%h,%m $+ _images)
      var %chan = $hget(%h,%m $+ _channel)
      if (%m) && (!$wmm_getpath(%m)) { did -e $dname 7 }
      else { did -b $dname 7 }
      if (%desc) { did -re $dname 8 | did -az $dname 8 $replace(%desc,@newline@,$+ $+ $crlf $+ $+) | did -c $dname 8 1 1 }
      if (%imgs) {
        var %t = $numtok(%imgs,44)
        var %i = 1
        while (%i <= %t) {
          var %img = $gettok(%imgs,%i,44)
          if (%i == 1) { 
            var %f = $wmm_temp $+ $nopath(%img)
            if (!$isfile(%f)) || (!$lines(%f)) { 
              var %f = $scriptdir $+ no_preview.png
              if (!$isfile(%f)) || (!$lines(%f)) { wmm_input error 60 $wmm_lang(17) @newline@ @newline@ $+ $wmm_lang(18) 004 | dialog -k $dname | return }
            }
            did -g $dname 14 $qt(%f)
          }
          if (%i == 2) { 
            var %f = $wmm_temp $+ $nopath(%img)
            if (!$isfile(%f)) || (!$lines(%f)) { 
              var %f = $scriptdir $+ no_preview.png
              if (!$isfile(%f)) || (!$lines(%f)) { wmm_input error 60 $wmm_lang(17) @newline@ @newline@ $+ $wmm_lang(18) 005 | dialog -k $dname | return }
            }
            did -g $dname 15 $qt(%f)
          }
          if (%i == 3) {
            var %f = $wmm_temp $+ $nopath(%img)
            if (!$isfile(%f)) || (!$lines(%f)) { 
              var %f = $scriptdir $+ no_preview.png
              if (!$isfile(%f)) || (!$lines(%f)) { wmm_input error 60 $wmm_lang(17) @newline@ @newline@ $+ $wmm_lang(18) 006 | dialog -k $dname | return }
            }
            did -g $dname 16 $qt(%f)
          }
          inc %i
        }
      }
      if (%chan) && (%chan == NOT_OK) { did -b $dname 7 }
    }
    if ($did == 60) {
      var %h = WMM_MODULES
      var %m = $did($did).seltext
      if (!%m) || (!$wmm_getpath(%m)) { wmm_modules_installed_plus_updated_list | return }
      if ($hget(%h,DID_60) == %m) { return }
      hadd -m %h DID_60 %m
      did -e $dname 11,12,8

      var %chk_chan = $hget(%h,%m $+ _channel)
      if (%chk_chan) && (%chk_chan == NOT_OK) { did -b $dname 12 }

      var %chk_ver = $hget(%h,%m $+ _check_version_alias)
      var %chk_ver_alias $right(%chk_ver,-1)
      var %chk_owner_alias = $replace(%chk_ver_alias,_ver,_owner)
      var %chk_crdate_alias = $replace(%chk_ver_alias,_ver,_crdate)
      var %f = $isalias(%chk_ver_alias).fname
      var %ft = $nopath($isalias(%chk_ver_alias).ftype)

      var %ver = $iif($isalias(%chk_ver_alias),$(%chk_ver,2),0)
      var %chan = $iif(%ver && b isincs %ver,BETA,STABLE)
      var %installed = $date($file(%f).mtime,dd/mm/yyyy HH:nn:ss)
      var %crdate = $($chr(36) $+ %chk_crdate_alias,2)
      var %owner = $($chr(36) $+ %chk_owner_alias,2)
      var %file = $nopath(%f)
      var %size = $bytes($file(%f).size).suf
      var %lines = $lines(%f)
      var %md5 = $iif($isfile(%f) && ($lines(%f)),$md5(%f,2),0)

      did -r $dname 8
      did -a $dname 8 $wmm_lang(47) $+ : $iif(%ver,$v1,N/A)
      did -a $dname 8 $crlf
      did -a $dname 8 $wmm_lang(60) $+ : $iif(%chan,$v1,N/A)
      did -a $dname 8 $crlf
      did -a $dname 8 $wmm_lang(48) $+ : $iif(%crdate,$v1,N/A)
      did -a $dname 8 $crlf
      did -a $dname 8 $wmm_lang(51) $+ : $iif(%installed,$v1,N/A)
      did -a $dname 8 $crlf
      did -a $dname 8 $wmm_lang(64) $+ : $iif(%file,$v1,N/A)
      did -a $dname 8 $crlf
      did -a $dname 8 $wmm_lang(49) $+ : $iif(%owner,$v1,N/A)
      did -a $dname 8 $crlf
      did -a $dname 8 $wmm_lang(53) $+ : $iif(%lines,$v1,N/A)
      did -a $dname 8 $crlf
      did -a $dname 8 $wmm_lang(50) $+ : $iif(%size,$v1,N/A)
      did -a $dname 8 $crlf
      did -a $dname 8 $wmm_lang(56) $+ : $iif(%md5,$v1,N/A)
      did -a $dname 8 $crlf
      did -a $dname 8 $wmm_lang(52) $+ : $iif($isfile(%f) && ($lines(%f)),$longfn(%f),N/A)
      did -c $dname 8 1 1
    }
    if ($did == 12) {
      if ($wmm_check_initial_warn) { wmm_input error 60 $wmm_lang(33) | return }
      if ($wmm_check_monitor_warn) { wmm_input error 60 $wmm_lang(75) | return }
      if (!$wmm_internet) { wmm_input error 60 $wmm_lang(44) | return }
      var %h = WMM_MODULES
      var %m = $did(60).seltext
      if (!%m) || (!$wmm_getpath(%m)) { wmm_modules_installed_plus_updated_list | return }
      var %mod = %m $+ $wmm_getext(%m)
      var %fn = $scriptdir $+ modules $+ \ $+ %m $+ .mrc
      var %pos = $wmm_getpos(%m)
      var %url = $hget(%h,%m $+ _url)
      var %tools_ver = $hget(%h,%m $+ _tools_ver)
      if (%tools_ver) && ($wmm_ver < %tools_ver) { wmm_input error 60 $wmm_lang(63) | return }
      if (!$isdir($nofile(%fn))) { mkdir $qt($nofile(%fn)) }
      did -b $dname 11,12,60
      did -ft $dname 1

      .timer[WMM_MOD_REINSTALL_ $+ %mod $+ ] -ho 1 500 wmm_download $qt(wmm_mod_reinstall %mod %pos) %url $+ ?nocache= $+ $ticks $qt(%fn)
    }
    if ($did == 11) {
      var %m = $did(60).seltext
      if (!%m) || (!$wmm_getpath(%m)) { wmm_modules_installed_plus_updated_list | return }
      var %mod = %m $+ $wmm_getext(%m)
      var %f = $wmm_getpath(%m)
      did -b $dname 11,12,60,8
      did -r $dname 8

      set -eu60 %wmm_signal_noclose 1
      if ($wmm_ismod(%mod)) { .unload -rs $qt(%mod) }
      if ($isfile(%f)) { .remove -b $qt(%f) }
      unset %wmm_signal_noclose

      wmm_modules_installed_plus_updated_list
      wmm_input ok 60 $wmm_lang(36)
      did -fv $dname 23 
    }
    if ($did == 7) { 
      if ($wmm_check_initial_warn) { wmm_input error 60 $wmm_lang(33) | return }
      if ($wmm_check_monitor_warn) { wmm_input error 60 $wmm_lang(75) | return }
      if (!$wmm_internet) { wmm_input error 60 $wmm_lang(44) | return }
      var %h = WMM_MODULES
      var %m = $did(6).seltext
      if (!%m) || ($wmm_getpath(%m)) { 
        did -b $dname 7 
        did -u $dname 6
        did -rb $dname 8
        wmm_reset_images
        wmm_modules_installed_plus_updated_list
        return 
      }

      var %tools_ver = $hget(%h,%m $+ _tools_ver)
      if (%tools_ver) && ($wmm_ver < %tools_ver) { wmm_input error 60 $wmm_lang(63) | return }

      did -b $dname 6,7
      did -ft $dname 1

      var %url = $hget(%h,%m $+ _url)
      var %mod = %m $+ .mrc
      var %f = $scriptdir $+ modules $+ \ $+ %mod
      if (!$isdir($nofile(%f))) { mkdir $qt($nofile(%f)) }

      .timer[WMM_MOD_INSTALL_ $+ %mod $+ ] -ho 1 500 wmm_download $qt(wmm_mod_install %mod) %url $+ ?nocache= $+ $ticks $qt(%f)
    }
    if ($did == 14) { 
      var %url = $gettok($hget(WMM_MODULES,$did(6).seltext $+ _images),1,44)
      if (%url) { url %url }
    }
    if ($did == 15) {
      var %url = $gettok($hget(WMM_MODULES,$did(6).seltext $+ _images),2,44)
      if (%url) { url %url }
    }
    if ($did == 16) { 
      var %url = $gettok($hget(WMM_MODULES,$did(6).seltext $+ _images),3,44)
      if (%url) { url %url }
    }
    if ($did == 13) { 
      if ($wmm_check_initial_warn) { wmm_input error 60 $wmm_lang(33) | return }
      if ($wmm_check_monitor_warn) { wmm_input error 60 $wmm_lang(75) | return }
      if (!$wmm_internet) { wmm_input error 60 $wmm_lang(44) | return }
      var %h = WMM_MODULES
      var %m = $did(600).seltext
      if (!%m) || (!$wmm_getpath(%m)) { wmm_modules_installed_plus_updated_list | return }

      var %tools_ver = $hget(%h,%m $+ _tools_ver)
      if (%tools_ver) && ($wmm_ver < %tools_ver) { wmm_input error 60 $wmm_lang(63) | return }

      did -b $dname 13,600
      did -ft $dname 1

      var %url = $hget(%h,%m $+ _url)
      var %mod = %m $+ $wmm_getext(%m)
      var %pos = $wmm_getpos(%m)
      var %f = $scriptdir $+ modules $+ \ $+ %mod
      if (!$isdir($nofile(%f))) { mkdir $qt($nofile(%f)) }

      var %chk_sets $right($replace($hget(%h,%m $+ _check_version_alias),_ver,_sets),-1)
      wmm_d_close %chk_sets

      .timer[WMM_MOD_UPDATE_ $+ %mod $+ ] -ho 1 500 wmm_download $qt(wmm_mod_update %mod %pos) %url $+ ?nocache= $+ $ticks $qt(%f)
    }
  }
  if ($devent == menu) {
    if ($did == 18) { url $wmm_page }
    if ($did == 24) { url $wmm_donate }
    if ($did == 22) { dialog -k $dname }
    if ($did == 21) { dialog -k $dname | .timer -ho 1 500 wmm }
    if ($did == 20) { wmm_input ok 60 $wmm_lang(27) $wmm_lang(16) v $+ $wmm_ver $wmm_lang(28) $wmm_crdate $wmm_lang(29) $wmm_owner }
    if ($did == 19) { .timer -ho 1 100 wmm_sets | dialog -k $dname }
  }
}

ON *:SIGNAL:*: { 
  if (!$1) { return }
  if ($signal == wmm_close) && (!%wmm_signal_noclose) { wmm_d_close wmm_module | wmm_d_close wmm_module_sets }
}

; --- End of events ---

; --- Start of aliases ---

alias wmm_ver { return 3.0 }
alias wmm_crdate { return 09/07/2016 }
alias wmm_owner { return $+($chr(119),$chr(101),$chr(115),$chr(116),$chr(111),$chr(114)) }
alias wmm_page { return http:// $+ $wmm_owner $+ .ucoz.com/wmm }
alias wmm_donate { return http:// $+ $wmm_owner $+ .ucoz.com/donate }
alias wmm_sets_url { return http:// $+ $wmm_owner $+ .ucoz.com/wmm/modules.json $+ ?nocache= $+ $ticks }
alias wmm_main_ico_url { return http:// $+ $wmm_owner $+ .ucoz.com/wmm/images/main.ico?nocache= $+ $ticks }
alias wmm_main_png_url { return http:// $+ $wmm_owner $+ .ucoz.com/wmm/images/no_preview.png?nocache= $+ $ticks }
alias wmm_donate_png_url { return http:// $+ $wmm_owner $+ .ucoz.com/wmm/images/donate.png?nocache= $+ $ticks }
alias wmm_lang_url { return http:// $+ $wmm_owner $+ .ucoz.com/wmm/languages/wmm_lang.ini?nocache= $+ $ticks }

alias wmm { 
  if ($isid) { return }
  var %d = wmm_module
  wmm_d_close wmm_module_sets
  .timer[WMM_CHECK_FOR_UPDATE_MODULES_SILENT] off
  .timer[WMM_CHECK_FOR_UPDATE_SILENT] off
  .timer[WMM_MOD_SILENT_UPDATE_*] off
  if (%wmm_update) { wmm_tool -b | return }
  if ($dialog(%d)) { wmm_tool -e | dialog -ve %d %d | return }
  var %don = $scriptdir $+ donate.png
  var %ico = $scriptdir $+ main.ico
  var %png = $scriptdir $+ no_preview.png
  var %l = $scriptdir $+ wmm_lang.ini
  if (!$isfile(%l)) { var %delay = 1 | wmm_dl $wmm_lang_url $qt(%l) }
  if (!$isfile(%ico)) { var %delay = 1 | wmm_dl $wmm_main_ico_url $qt(%ico) }
  if (!$isfile(%png)) { var %delay = 1 | wmm_dl $wmm_main_png_url $qt(%png) }
  if (!$isfile(%don)) { var %delay = 1 | wmm_dl $wmm_donate_png_url $qt(%don) }
  wmm_fix_extra_modules_installed
  if (%delay) { .timer -ho 1 2000 wmm_tool -s | .timer -ho 1 3000 dialog -md %d %d }
  elseif (!%delay) { dialog -md %d %d }
}

alias wmm_sets { 
  if ($isid) { return }
  var %d = wmm_module_sets
  wmm_d_close wmm_module
  .timer[WMM_CHECK_FOR_UPDATE_MODULES_SILENT] off
  .timer[WMM_CHECK_FOR_UPDATE_SILENT] off
  .timer[WMM_MOD_SILENT_UPDATE_*] off
  if (%wmm_update) { wmm_tool -b | return }
  if ($dialog(%d)) { wmm_tool -e | dialog -ve %d %d | return }
  var %don = $scriptdir $+ donate.png
  var %ico = $scriptdir $+ main.ico
  var %png = $scriptdir $+ no_preview.png
  var %l = $scriptdir $+ wmm_lang.ini
  if (!$isfile(%l)) { var %delay = 1 | wmm_dl $wmm_lang_url $qt(%l) }
  if (!$isfile(%ico)) { var %delay = 1 | wmm_dl $wmm_main_ico_url $qt(%ico) }
  if (!$isfile(%png)) { var %delay = 1 | wmm_dl $wmm_main_png_url $qt(%png) }
  if (!$isfile(%don)) { var %delay = 1 | wmm_dl $wmm_donate_png_url $qt(%don) }
  wmm_fix_extra_modules_installed
  if (%delay) { .timer -ho 1 2000 wmm_tool -s | .timer -ho 1 3000 dialog -md %d %d }
  elseif (!%delay) { dialog -md %d %d }
}

alias wmm_check_os {
  if (!$isid) { return }
  var %1 = CheckOS_1
  var %2 = CheckOS_2
  var %3 = CheckOS_3
  var %4 = CheckOS_4
  wmm_c_close %1
  wmm_c_close %2
  wmm_c_close %3
  wmm_c_close %4
  .comopen %1 MSScriptControl.ScriptControl
  .comopen %2 WScript.Shell
  .comopen %3 MSXML2.SERVERXMLHTTP.6.0
  .comopen %4 Adodb.Stream
  if (!$com(%1)) || ($comerr) { return 1 }
  if (!$com(%2)) || ($comerr) { return 1 }
  if (!$com(%3)) || ($comerr) { return 1 }
  if (!$com(%4)) || ($comerr) { return 1 }
  :error
  reseterror
  wmm_c_close %1
  wmm_c_close %2
  wmm_c_close %3
  wmm_c_close %4
  return 0
}

alias wmm_check_initial_warn {
  if (!$isid) { return }
  if ($gettok($readini($mircini,n,options,n5),27,44)) { return 1 }
  else { return 0 }
}

alias wmm_check_monitor_warn {
  if (!$isid) { return }
  if ($gettok($readini($mircini,n,options,n7),13,44)) { return 1 }
  else { return 0 }
}

alias wmm_langs {
  var %f = $scriptdir $+ wmm_lang.ini
  if (!$isid) || (!$isfile(%f)) || (!$lines(%f)) || (!$ini(%f,0)) { return 0 }
  if (!%wmm_lang) { set %wmm_lang English } 
  var %t = $ini(%f,0)
  var %i = 1
  while (%i <= %t) {
    var %l = $ini(%f,%i)
    if (%l) { var %langs = $addtok(%langs,%l,44) }
    inc %i
  }
  if (%langs) { return %langs }
  else { return 0 }
}

alias wmm_fix_extra_modules_installed {
  if (!$script(0)) || ($isid) { return }
  set -eu60 %wmm_signal_noclose 1
  var %t = $script(0)
  while (%t) {
    var %s = $script(%t)
    if ($right($nopath(%s),4) == .ini) { var %type = ini | var %r = $read(%s,nw,*alias -l addon *) | var %rr = $read(%s,nw,*alias *_owner *) }
    else { var %type = mrc | var %r = $read(%s,nw,alias -l addon *) | var %rr = $read(%s,nw,alias *_owner *) }
    if (!%r) && (!%rr) || (*wmm_owner* iswm %rr) { goto next }
    var %o = $eval($gettok(%rr,5,32),2)
    var %m = $eval($remove(%r,alias,-l,addon,$chr(123),return,$chr(125)),2)
    if (= isincs %m) { var %m = $remove($gettok(%m,2,61),$chr(32)) }
    var %mod = %m $+ .mrc
    var %f = $replace(%s,$nopath(%s),%mod)
    if (%type) && (%m) && (%o) && (%o == $wmm_owner) && ($nopath(%s) !== %mod) {
      var %pos = $wmm_getpos($nopath($gettok(%s,1,46)))
      if ($wmm_ismod($nopath(%s))) { .unload -nrs $qt(%s) }

      if (%type == mrc) && ($isfile(%s)) && ($lines(%s)) && (!$isfile(%f)) { .rename $qt(%s) $qt(%f) }
      elseif (%type == ini) && (!$wmm_ismod($nopath(%f))) { wmm_convert_ini2mrc $qt($nopath(%f)) $qt(%s) }

      if ($isfile(%f)) && ($lines(%f)) && (!$wmm_ismod($nopath(%f))) { .reload -rs $+ $iif(%pos,%pos) $qt(%f) }
      if ($isfile(%s)) { .remove -b $qt(%s) }
    }
    :next
    dec %t
  }
  unset %wmm_signal_noclose
}

alias -l wmm_reset_images {
  var %d = wmm_module
  if (!$dialog(%d)) || ($isid) { return }
  var %f = $scriptdir $+ no_preview.png
  if (!$isfile(%f)) { wmm_input error 60 $wmm_lang(17) @newline@ @newline@ $+ $wmm_lang(18) 008 | wmm_d_close %d | return }
  did -g %d 14,15,16 $qt(%f)
}

alias -l wmm_mod_install {
  var %d = wmm_module
  if (!$1) || ($isid) || (!$dialog(%d)) { return }
  if ($3 !== S_OK) { wmm_input error 60 $wmm_lang(17) @newline@ @newline@ $+ $wmm_lang(18) 007 | wmm_d_close %d | return }
  var %f = $noqt($5-)
  if (!$isfile(%f)) { wmm_input error 60 $wmm_lang(17) @newline@ @newline@ $+ $wmm_lang(18) 018 | wmm_d_close %d | return }
  set -eu60 %wmm_signal_noclose 1
  if ($wmm_ismod($1)) { .unload -rs $qt($1) }
  .load -rs $qt(%f)
  unset %wmm_signal_noclose
  if (!$wmm_ismod($1)) { wmm_input error 60 $wmm_lang(17) @newline@ @newline@ $+ $wmm_lang(18) 012 | wmm_d_close %d | return }
  did -euz %d 6
  wmm_reset_images
  wmm_modules_installed_plus_updated_list
  wmm_input ok 60 $wmm_lang(35)
  if ($dialog(%d)) { did -fv %d 23 }
}

alias -l wmm_mod_reinstall { 
  var %h = WMM_MODULES
  var %d = wmm_module
  if (!$1) || ($isid) || (!$dialog(%d)) { return }
  if ($hget(%h,DID_60) == $left($1,-4)) { hdel %h DID_60 }
  if ($4 !== S_OK) { wmm_input error 60 $wmm_lang(17) @newline@ @newline@ $+ $wmm_lang(18) 017 | wmm_d_close %d | return }
  var %f = $noqt($6-)
  if (!$isfile(%f)) { wmm_input error 60 $wmm_lang(17) @newline@ @newline@ $+ $wmm_lang(18) 020 | wmm_d_close %d | return }
  set -eu60 %wmm_signal_noclose 1
  if ($wmm_ismod($1)) { .unload -rs $qt($1) }
  if ($wmm_ismod($nopath(%f))) { .unload -rs $qt($nopath(%f)) }
  .load -rs $+ $2 $qt(%f)
  unset %wmm_signal_noclose
  if (!$wmm_ismod($nopath(%f))) { wmm_input error 60 $wmm_lang(17) @newline@ @newline@ $+ $wmm_lang(18) 021 | wmm_d_close %d | return }
  wmm_modules_installed_plus_updated_list
  wmm_input ok 60 $wmm_lang(34)
  if ($dialog(%d)) { did -fv %d 23 }
}

alias -l wmm_mod_update { 
  var %d = wmm_module
  if (!$1) || ($isid) || (!$dialog(%d)) { return }
  if ($4 !== S_OK) { wmm_input error 60 $wmm_lang(17) @newline@ @newline@ $+ $wmm_lang(18) 011 | wmm_d_close %d | return }
  var %f = $noqt($6-)
  if (!$isfile(%f)) { wmm_input error 60 $wmm_lang(17) @newline@ @newline@ $+ $wmm_lang(18) 014 | wmm_d_close %d | return }
  set -eu60 %wmm_signal_noclose 1
  if ($wmm_ismod($1)) { .unload -nrs $qt($1) }
  if ($wmm_ismod($nopath(%f))) { .unload -nrs $qt($nopath(%f)) }
  .load -rs $+ $2 $qt(%f)
  unset %wmm_signal_noclose
  if (!$wmm_ismod($nopath(%f))) { wmm_input error 60 $wmm_lang(17) @newline@ @newline@ $+ $wmm_lang(18) 015 | wmm_d_close %d | return }
  wmm_modules_installed_plus_updated_list
  wmm_input ok 60 $wmm_lang(37)
  if ($dialog(%d)) { did -fv %d 23 }
}

alias wmm_lang { 
  var %f = $scriptdir $+ wmm_lang.ini
  if (!$isfile(%f)) || (!$lines(%f)) || (!$isid) { return 0 }
  if (!%wmm_lang) { set %wmm_lang English }
  var %chk_lang = $ini(%f,%wmm_lang)
  if (!%chk_lang) { return READ-ERROR! }
  var %r = $readini(%f,n,%wmm_lang,$1)
  if (!%r) { return N/A }
  elseif (%r) { return %r }
}

alias wmm_input {
  if (!$1) || ($isid) { return }
  if ($1 == ok) { .timer -ho 1 0 !noop $input($replace($3-,@newline@,$crlf),ouidbk $+ $iif($2 && $2 isnum,$2,0),$upper($wmm_owner) $iif($wmm_lang(16),$v1,Module Manager) $wmm_bel $iif($wmm_lang(19),$v1,OK)) }
  if ($1 == error) { .timer -ho 1 0 !noop $input($replace($3-,@newline@,$crlf),houdbk $+ $iif($2 && $2 isnum,$2,0),$upper($wmm_owner) $iif($wmm_lang(16),$v1,Module Manager) $wmm_bel $iif($wmm_lang(20),$v1,Error)) }
  if ($1 == warn) { .timer -ho 1 0 !noop $input($replace($3-,@newline@,$crlf),woudbk $+ $iif($2 && $2 isnum,$2,0),$upper($wmm_owner) $iif($wmm_lang(16),$v1,Module Manager) $wmm_bel $iif($wmm_lang(21),$v1,Warn)) }
}

alias -l wmm_check_update {
  var %d = wmm_module
  var %d2 = wmm_module_sets
  if (!$dialog(%d)) || ($isid) || (!$isalias(wmm_ver)) { return }
  var %v = wmm_update_ $+ $wmm_random
  wmm_jsonopen -u %v $wmm_sets_url
  if ($wmm_jsonerror) { wmm_jsonclose %v | wmm_input error 60 $wmm_lang(17) @newline@ @newline@ $+ $wmm_lang(18) 002 | return }
  var %ver = $wmm_json(%v,latest_version)
  var %chan = $wmm_json(%v,latest_version_channel)
  var %date = $wmm_json(%v,latest_version_date)
  var %url = $wmm_json(%v,latest_version_source_download)
  var %url_rar = $wmm_json(%v,latest_version_download)
  wmm_jsonclose %v
  if (%ver) && (%ver !== $wmm_ver) && (%chan !== NOT_OK) { 
    if ($dialog(%d)) { dialog -i %d }
    var %ask = $input($wmm_lang(23) $iif(%chan,$v1,N/A) $wmm_lang(24) %ver ( $+ $iif(%date,$v1,N/A) $+ ) $wmm_lang(25) $+ . $crlf $crlf $+ $+ $wmm_lang(26),yuidbk60,$upper($wmm_owner) $wmm_lang(16) $wmm_bel $wmm_lang(22))
    if (%ask) { 
      if (!$wmm_internet) { wmm_input error 60 $wmm_lang(44) | wmm | return }
      wmm_d_close %d
      wmm_d_close %d2
      if (%url_rar) && ($wmm_check_initial_warn) || ($wmm_check_monitor_warn) { url %url_rar }
      if (%url) && (!$wmm_check_initial_warn) && (!$wmm_check_monitor_warn) { set -eu120 %wmm_update 1 | wmm_download $qt(wmm_check_update_install) %url $+ ?nocache= $+ $ticks $qt($scriptdir $+ $upper($wmm_owner) Module Manager.mrc) }
    }
    else { wmm }
  }
}

alias -l wmm_check_update_install {
  if ($2 !== S_OK) { wmm_input error 60 $wmm_lang(17) @newline@ @newline@ $+ $wmm_lang(18) 019 | unset %wmm_update | return }
  if ($4-) { .timer -ho 1 1000 .load -rs1 $4- | wmm_tool -c | .unload -nrs $qt($script) }
}

alias wmm_check_silent_update {
  if ($dialog(wmm_module)) || ($isid) || ($dialog(wmm_module_sets)) || ($wmm_check_initial_warn) || ($wmm_check_monitor_warn) || (!$wmm_internet) || (!$isalias(wmm_ver)) { return }
  var %v = wmm_silent_update_ $+ $wmm_random
  wmm_jsonopen -u %v $wmm_sets_url
  if ($wmm_jsonerror) { wmm_jsonclose %v | return }
  var %ver = $wmm_json(%v,latest_version)
  var %chan = $wmm_json(%v,latest_version_channel)
  var %url = $wmm_json(%v,latest_version_source_download)
  wmm_jsonclose %v
  if (%url) && (%ver) && (%ver !== $wmm_ver) && (%chan !== NOT_OK) {
    set -eu120 %wmm_update 2
    wmm_download $qt(wmm_check_silent_update_install) %url $+ ?nocache= $+ $ticks $qt($scriptdir $+ $upper($wmm_owner) Module Manager.mrc) 
  }
}

alias -l wmm_check_silent_update_install {
  if ($2 !== S_OK) || ($isid) { unset %wmm_update | return }
  if ($4-) { .timer -ho 1 1000 .load -rs1 $4- | wmm_tool -c | .unload -nrs $qt($script) }
}

alias wmm_modules_silent_update {
  if (!%wmm_autoupdate_modules) || ($isid) || ($dialog(wmm_module)) || ($dialog(wmm_module_sets)) || (!$wmm_internet) || ($wmm_check_initial_warn) || ($wmm_check_monitor_warn) || (!$isalias(wmm_ver)) { return }
  if (!$isdir($scriptdir $+ modules)) { mkdir $qt($scriptdir $+ modules) }
  var %hs = WMM_MODULES_SUBMENU_INSTALLED
  var %v = wmm_modules_silent_update_ $+ $wmm_random
  if ($hget(%hs)) { hfree $v1 }
  hmake %hs 1000
  wmm_jsonopen -ud %v $wmm_sets_url
  if ($wmm_jsonerror) { return }
  var %t = $wmm_json(%v,modules,length)
  var %x = 0
  while (%x < %t) {
    var %mod = $wmm_json(%v,modules,%x,name)
    var %other = $wmm_json(%v,modules,%x,other)
    var %a = $right($replace($gettok(%other,2,32),_ver,_sets),-1)

    if (%a) && (%mod) && (!$hget(%hs,%mod)) { hadd %hs %mod %a }
    if (!%mod) || (!$wmm_getpath(%mod)) || (!$istok(%wmm_autoupdate_modules,%mod,32)) { goto next }

    var %ver = $gettok(%other,1,32)
    var %mod_ver = $gettok(%other,2,32)
    var %chan = $gettok(%other,3,32)
    var %url = $gettok(%other,5,32)
    var %tools_ver = $gettok(%other,6,32)
    var %iv = $iif($isalias($right(%mod_ver,-1)),$(%mod_ver,2),0)
    var %pos = $wmm_getpos(%mod)
    var %fn = $scriptdir $+ modules $+ \ $+ %mod $+ .mrc

    if (%url) && (%iv) && (%ver) && (%tools_ver) && (%iv !== %ver) && ($wmm_ver > %tools_ver) && (%chan !== NOT_OK) { 
      var %total = $calc(%total +1)
      var %chk_sets $right($replace(%mod_ver,_ver,_sets),-1)
      wmm_d_close %chk_sets
      .timer[WMM_MOD_SILENT_UPDATE_ $+ %mod $+ ] -ho 1 $calc(%total * 500) wmm_download $qt(wmm_mod_silent_update %mod %pos) %url $+ ?nocache= $+ $ticks $qt(%fn)
    }

    :next
    inc %x
  }
}

alias -l wmm_mod_silent_update {
  if (!$1) || ($isid) || ($dialog(wmm_module)) || ($dialog(wmm_module_sets)) || ($4 !== S_OK) { return }
  var %p = $nopath($wmm_getpath($1))
  var %f = $noqt($6-)
  if (!$isfile(%f)) || (!$lines(%f)) { return }
  if (%p) && ($wmm_ismod(%p)) { .unload -nrs $qt(%p) }
  if ($wmm_ismod($nopath(%f))) { .unload -nrs $qt($nopath(%f)) }
  .load -rs $+ $2 $qt(%f)
  if (!$wmm_ismod($nopath(%f))) { return }
}

alias -l wmm_modules_list {
  var %d = wmm_module
  var %h = WMM_MODULES
  var %hs = WMM_MODULES_SUBMENU_INSTALLED
  if (!$dialog(%d)) || ($isid) { return }
  if ($hget(%h)) { hfree $v1 }
  if ($hget(%hs)) { hfree $v1 }
  did -rb %d 6
  hmake %h 1000
  hmake %hs 1000
  var %v = wmm_modules_ $+ $wmm_random
  wmm_jsonopen -ud %v $wmm_sets_url
  if ($wmm_jsonerror) { wmm_input error 60 $wmm_lang(17) @newline@ @newline@ $+ $wmm_lang(18) 003 | wmm_d_close %d | return }
  var %news = $wmm_json(%v,latest_news)
  if (%news) { var %news = $replace(%news,@newline@,$+ $+ $crlf $+ $+) }
  var %t = $wmm_json(%v,modules,length)
  var %x = 0
  while (%x < %t) {
    var %mod = $wmm_json(%v,modules,%x,name)
    if (!%mod) { goto next }

    var %desc = $wmm_json(%v,modules,%x,desc)
    var %images = $wmm_json(%v,modules,%x,image)
    var %other = $wmm_json(%v,modules,%x,other)

    var %ver = $gettok(%other,1,32)
    var %mod_ver = $gettok(%other,2,32)
    var %chan = $gettok(%other,3,32)
    var %date = $gettok(%other,4,32)
    var %url = $gettok(%other,5,32)
    var %tools_ver = $gettok(%other,6,32)

    var %mods = $hget(%h,ALL)
    var %mods = $addtok(%mods,%mod,32)
    hadd %h ALL %mods

    if (%mod_ver) { 
      hadd %h %mod $+ _check_version_alias %mod_ver
      var %chk_mod_ver = $right(%mod_ver,-1)
      var %chk_mod_version = $iif($isalias(%chk_mod_ver),$(%mod_ver,2),0)
      hadd %h %mod $+ _check_version %chk_mod_version
    }
    if (%ver) { hadd %h %mod $+ _version %ver }
    if (%chan) { hadd %h %mod $+ _channel %chan }
    if (%date) { hadd %h %mod $+ _crdate %date }
    if (%url) { hadd %h %mod $+ _url %url }
    if (%tools_ver) { hadd %h %mod $+ _tools_ver %tools_ver }
    if (%images) { hadd %h %mod $+ _images %images | .timer[WMM_GET_IMAGES_ $+ %mod $+ ] -ho 1 $iif(%wmm_slow_images,$calc(200 * 60 * %x),100) wmm_get_images %images }
    if (%desc) { hadd %h %mod $+ _desc %desc }

    did -a %d 6 %mod

    var %a = $replace($right(%mod_ver,-1),_ver,_sets)
    if (!$hget(%hs,%mod)) && (%a) { hadd %hs %mod %a }

    :next
    inc %x
  }
  if (%news) { .timer[WMM_SET_NEWS] -ho 1 1000 did -ra %d 26 %news }
  else { did -ra %d 26 $wmm_lang(58) }
  if ($did(%d,6).lines) { 
    var %r = $wmm_lang(3) ( $+ $did(%d,6).lines $+ )
    if ($did(%d,2) !== %r) { did -ra %d 2 %r }
    did -e %d 6
  }
  else { 
    var %r = $wmm_lang(3)
    if ($did(%d,2) !== %r) { did -ra %d 2 %r }
  }
}

alias -l wmm_modules_installed_plus_updated_list {
  var %d = wmm_module
  var %h = WMM_MODULES
  if (!$dialog(%d)) || ($isid) { return }
  var %t = $did(%d,6).lines
  did -b %d 8,11,12,13,60,600
  did -r %d 8,60,600
  if (!%t) { did -fv %d 23 | return }
  var %i = 1
  while (%i <= %t) {
    var %mod = $did(%d,6,%i)
    if (!%mod) { goto next }
    var %module = %mod $+ $wmm_getext(%mod)
    if ($wmm_ismod(%module)) { 
      did -a %d 60 %mod

      var %mod_ver = $hget(%h,%mod $+ _check_version_alias)
      var %iv = $iif($isalias($right(%mod_ver,-1)),$(%mod_ver,2),0)
      var %ver = $hget(%h,%mod $+ _version)
      var %url = $hget(%h,%mod $+ _url)
      if (%url) && (%iv) && (%ver) && (%iv !== %ver) { did -a %d 600 %mod }
    }
    :next
    inc %i
  }
  if ($did(%d,60).lines) {
    var %r = $wmm_lang(2) ( $+ $did(%d,60).lines $+ )
    if ($did(%d,3) !== %r) { did -ra %d 3 %r }
    did -ez %d 60 
  }
  else { 
    if ($did(%d,3) !== $wmm_lang(2)) { did -ra %d 3 $wmm_lang(2) }
  }
  if ($did(%d,600).lines) { 
    var %r = $wmm_lang(7) ( $+ $did(%d,600).lines $+ )
    if ($did(%d,4) !== %r) { did -ra %d 4 %r }
    did -ez %d 600 
  }
  else { 
    if ($did(%d,4) !== $wmm_lang(7)) { did -ra %d 4 $wmm_lang(7) }
  }
  did -fv %d 23
}

alias -l wmm_get_images { 
  var %d = wmm_module
  if (!$1) || (!$dialog(%d)) || ($isid) { return }
  var %t = $numtok($1-,44)
  var %i = 1
  while (%i <= %t) {
    var %f = $gettok($1-,%i,44)
    var %ft = $wmm_temp $+ $gettok(%f,$numtok(%f,47),47)
    var %fd = $date($file(%ft).mtime,dd/mm/yyyy)
    if (!$isfile(%ft)) || (%fd !== $date) { $iif(%wmm_slow_images,.timer[WMM_GET_IMAGE_DL_ $+ $nopath(%ft) $+ ] -ho 1 $calc(180 * 60 * %i)) wmm_dl %f $+ ?nocache= $+ $ticks $qt(%ft) }
    inc %i
  }
}

alias wmm_tool {

  ; -s = start toolbar
  ; -c = close toolbar
  ; -e = check the toolbar
  ; -b = uncheck the toolbar
  ; -t = update tooltip via correct language

  if (!$1) || ($isid) || (-s !=== $1) && (-c !=== $1) && (-t !=== $1) && (-e !=== $1) && (-b !=== $1) { return }
  if (-s === $1) {
    var %d = wmm_module
    var %ico = $scriptdir $+ main.ico
    if (!$isfile(%ico)) { wmm_dl $wmm_main_ico_url $qt(%ico) | return }
    wmm_t_close wmm
    wmm_t_close wmm1
    toolbar -as wmm1
    toolbar -ak $+ $iif($dialog(%d),1,0) wmm $qt($upper($wmm_owner) $wmm_lang(16) - ( $+ $wmm_lang(74) $+ )) $qt(%ico) $qt(/wmm_check_open) @wmm
  }
  if (-c === $1) { wmm_t_close wmm | wmm_t_close wmm1 }
  if (-t === $1) && ($toolbar(wmm)) { toolbar -t wmm $qt($upper($wmm_owner) $wmm_lang(16) - ( $+ $wmm_lang(74) $+ )) }
  if (-e === $1) && ($toolbar(wmm)) { toolbar -k1 wmm }
  if (-b === $1) && ($toolbar(wmm)) { toolbar -k0 wmm }
}

alias -l wmm_check_open {
  if ($isid) { return }
  var %d = wmm_module
  var %d2 = wmm_module_sets
  if ($dialog(%d)) { wmm | return }
  if ($dialog(%d2)) { wmm_sets | return }
  wmm
}

alias -l wmm_modules_settings_auto_update_list {
  var %d = wmm_module_sets
  if (!$dialog(%d)) || ($isid) { return }
  if (!%wmm_autoupdate_modules) { did -b %d 5,6 | return }
  var %i = 1
  while (%i <= $numtok(%wmm_autoupdate_modules,32)) {
    var %m = $gettok(%wmm_autoupdate_modules,%i,32)

    if (!%m) { goto next }
    if (!$wmm_getpath(%m)) { set %wmm_autoupdate_modules $remtok(%wmm_autoupdate_modules,%m,1,32) | goto next }

    did -a %d 5 %m
    :next
    inc %i
  }
  if ($did(%d,5).lines) { did -e %d 5 }
  else { did -b %d 6 }
}

alias -l wmm_modules_settings_list {
  var %hs = WMM_MODULES_SUBMENU_INSTALLED
  var %d = wmm_module_sets
  if (!$dialog(%d)) || ($isid) { return }
  if ($hget(%hs)) { hfree %hs }
  hmake %hs 1000
  did -r %d 3
  did -b %d 3,4
  var %v = wmm_modules_sets_ $+ $wmm_random
  wmm_jsonopen -ud %v $wmm_sets_url
  if ($wmm_jsonerror) { return }
  var %t = $wmm_json(%v,modules,length)
  if (!%t) { return }
  var %x = 0
  while (%x < %t) {
    var %mod = $wmm_json(%v,modules,%x,name)
    var %other = $wmm_json(%v,modules,%x,other)

    var %a = $replace($right($gettok(%other,2,32),-1),_ver,_sets)
    if (%mod) && (%a) && (!$hget(%hs,%mod)) { hadd %hs %mod %a }

    if (!%mod) || (!$wmm_getpath(%mod)) || ($didwm(%d,5,%mod)) { goto next }

    did -a %d 3 %mod

    :next
    inc %x
  }
  if ($did(%d,3).lines) { did -e %d 3 }
  else { did -b %d 3,4 }
}

alias -l wmm_modules_all_installed_list {
  var %h = WMM_MODULES_SUBMENU_INSTALLED
  if (!$1) || (!$isid) || (!$hget(%h)) || ($1 > $hget(%h,0).item) { returnex }
  if ($1 > $hget(%h,0).item) { returnex }
  if ($istok(begin.end,$1,46)) { return - }
  var %n = $hget(%h,$1).item
  var %d = $hget(%h,$hget(%h,$1).item)
  var %al = $isalias(%d)
  if (%n) && (%d) && (!%al) { returnex $style(2) $chr(40) $+ $1 $+ $chr(41) $chr(1417) $chr(160) $wmm_qd(%n $iif($wmm_lang(76),$v1,Module)) $+ :noop }
  else { returnex $iif($dialog(%d),$style(1)) $chr(40) $+ $1 $+ $chr(41) $chr(1417) $chr(160) $wmm_qd(%n $iif($wmm_lang(76),$v1,Module)) $+ : $+ %d }
}

; --- End of aliases ---

; --- Start of menus ---

menu @wmm {
  -
  $wmm_qd($iif($wmm_lang(73),$v1,Open the) $upper($wmm_owner) $iif($wmm_lang(16),$v1,Module Manager)):wmm
  -
  $wmm_qd($iif($wmm_lang(66),$v1,Open the settings of) $upper($wmm_owner) $iif($wmm_lang(16),$v1,Module Manager)):wmm_sets
  -
  $wmm_qd($iif($wmm_lang(59),$v1,Hide this button)):wmm_tool -c
  -
}

menu menubar,status,channel {
  $iif(%wmm_menu,-)
  $iif($istok(%wmm_menu,wmm,32),$iif($dialog(wmm_module),$style(1)) $wmm_qd($upper($wmm_owner) $iif($wmm_lang(16),$v1,Module Manager) $+ )):wmm
  $iif($istok(%wmm_menu,wmm_sets,32),$iif($dialog(wmm_module_sets),$style(1)) $wmm_qd($upper($wmm_owner) $iif($wmm_lang(16),$v1,Module Manager) - $iif($wmm_lang(69),$v1,Settings) $+ )):wmm_sets
  $iif($istok(%wmm_menu,wmm_mod_list,32) && $hget(WMM_MODULES_SUBMENU_INSTALLED),$wmm_qd($upper($wmm_owner) $iif($wmm_lang(16),$v1,Module Manager) - $iif($wmm_lang(77),$v1,Modules List)))
  .$submenu($wmm_modules_all_installed_list($1))
  $iif(%wmm_menu,-)
}

; --- End of menus ---

; --- Start of groups ---

#wmm off
#wmm end

; --- End of groups ---

; --- Start other aliases ---

alias wmm_bel { return $chr(10140) }
alias wmm_qd { return $chr(9679) $chr(32) $+ $1 $+ $chr(32) $chr(9679) }
alias wmm_bold { return $+($chr(2),$1-,$chr(2)) }
alias wmm_under { return $+($chr(31),$1-,$chr(31)) }
alias wmm_italic { return $+($chr(29),$1-,$chr(29)) }
alias wmm_random { return $rand(1,10000000000000) }
alias wmm_d_format { return ddd ddoo mmm yyyy HH:nn:ss }
alias wmm_d_close { if ($1) && ($dialog($1)) { dialog -k $1 } }
alias wmm_c_close { if ($1) && ($com($1)) { .comclose $1 } }
alias wmm_t_close { if ($1) && ($toolbar($1)) { toolbar -d $1 } }
alias wmm_tiny_key { return AIzaSyAJb3HqimAjzP9h8QlRCmBwPqc4dEKC3qw }
alias wmm_fixtab { return $replace($1-,$chr(9),$chr(32),$chr(10),$chr(32),$chr(13),$chr(32)) }
alias wmm_urlencode { return $regsubex($1-,/([^a-z0-9])/ig,% $+ $base($asc(\t),10,16,2)) }
alias wmm_urldecode { return $utfdecode($regsubex($replace($1-, +, $chr(32)), /%([A-F\d]{2})/gi, $chr($base(\1, 16, 10)))) }
alias wmm_nohtml { return $regsubex($1-, /<[^>]+(?:>|$)|^[^<>]+>/g,) }

alias wmm_isdigit {
  if (!$isid) { return }
  if ($1 == $null) { return 0 }
  if ($regex($1,^\d+$)) { return 1 }
  else { return 0 }
}

alias wmm_getext {
  if (!$1) || (!$isid) { return 0 }
  var %t = $script(0)
  var %i = 1
  while (%i <= %t) {
    var %f = $nopath($script(%i))
    var %n = $gettok(%f,1,46)
    var %ext = $gettok(%f,2,46)
    if (%f) && (%ext) && (%n == $1) { return . $+ %ext }
    inc %i
  }
  return 0
}

alias wmm_getpath {
  if (!$1) || (!$isid) { return 0 }
  var %t = $script(0)
  var %i = 1
  while (%i <= %t) {
    var %f = $script(%i)
    var %n = $gettok($nopath(%f),1,46)
    if (%f) && (%n == $1) { return %f }
    inc %i
  }
  return 0
}

alias wmm_getpos {
  if (!$1) || (!$isid) { return 0 }
  var %t = $script(0)
  var %i = 1
  while (%i <= %t) {
    var %f = $script(%i)
    var %n = $gettok($nopath(%f),1,46)
    if (%f) && (%n == $1) { return %i }
    inc %i
  }
  return 0
}

alias wmm_ismod {
  if (!$1) || (!$script(0)) || (!$isid) { return 0 }
  if ($script($1)) { return 1 }
  return 0
}

alias wmm_tinycom {
  if (!$1) || (!$isid) || (!$wmm_internet) { return }
  var %v = tinyurl_ $+ $wmm_random
  wmm_jsonopen -uw %v https://www.googleapis.com/urlshortener/v1/url?key= $+ $wmm_tiny_key $+ &longUrl= $+ $wmm_urldecode($1)
  if ($wmm_jsonerror) { wmm_jsonclose %v | return $1 }
  wmm_jsonurlmethod %v POST
  wmm_jsonurlheader %v User-Agent */*
  wmm_jsonurlheader %v Content-Type application/json
  wmm_jsonurlheader %v Connection Close
  wmm_jsonurlget %v $chr(123) $+ $qt(longUrl) $+ : $qt($wmm_urldecode($1)) $+ $chr(125)
  var %url = $wmm_json(%v,id)
  wmm_jsonclose %v
  if (%url) { return %url }
  elseif (!%url) { return $1 }
}

alias wmm_temp {
  if (!$isid) { return }
  var %d = $longfn($envvar(temp))
  if (%d) && ($right(%d,1) !== $chr(92)) { var %d = %d $+ \ }
  if (!%d) { 
    var %d = $longfn($scriptdir)
    if (%d) && ($right(%d,1) !== $chr(92)) { var %d = %d $+ \ }
  }
  return %d
}

alias wmm_dl {
  if (!$1) || (!$2) || ($isid) || (!$wmm_internet) { return }

  :st
  var %f = $wmm_temp $+ dl_ $+ $wmm_random $+ .vbs
  if ($isfile(%f)) { goto st }

  write $qt(%f) On Error Resume Next
  write $qt(%f) Set args = WScript.Arguments
  write $qt(%f) Url = $qt($1)
  write $qt(%f) dim xHttp: Set xHttp = createobject("MSXML2.SERVERXMLHTTP.6.0")
  write $qt(%f) dim bStrm: Set bStrm = createobject("Adodb.Stream")
  write $qt(%f) xHttp.Open "GET", Url, False
  write $qt(%f) xHttp.Send
  write $qt(%f) with bStrm
  write $qt(%f)    .type = 1
  write $qt(%f)    .mode = 3
  write $qt(%f)    .open
  write $qt(%f)    .write xHttp.responseBody
  write $qt(%f)    .savetofile $2- $+ , 2
  write $qt(%f)    .close
  write $qt(%f) end with
  write $qt(%f) Err.Clear
  write $qt(%f) Set oFso = CreateObject("Scripting.FileSystemObject") : oFso.DeleteFile Wscript.ScriptFullName, True

  if ($isfile(%f)) && ($lines(%f) == 17) { run -h $qt(%f) }

  return
  :error
  reseterror
  if ($1) {
    var %md5 = $md5($1)
    var %h = WMM_ERRORS
    if ($hget(%h,%md5)) { return }
    hadd -mu10 %h %md5 1
    .timer -ho 1 500 wmm_dl $1 $2-
  }

}

alias wmm_internet {
  if (!$isid) { return }
  var %v = internet_ $+ $wmm_random
  wmm_jsonopen -u %v $wmm_sets_url
  if ($wmm_jsonerror) { wmm_jsonclose %v | return 0 }
  wmm_jsonclose %v
  return 1
}

alias wmm_getsite {
  if (!$1-) || (!$isid) || (!$wmm_internet) { return 0 }
  var %com = getsite_ $+ $wmm_random
  .comopen %com MSXML2.SERVERXMLHTTP.6.0
  noop $com(%com,Open,1,bstr,GET,bstr,$1-,bool,false) $com(%com,Send,1) $com(%com,ResponseText,2)
  var %a = $wmm_fixtab($left($com(%com).result,4096))
  :error
  reseterror
  if ($com(%com)) { .comclose %com }
  if ($comerr) { return 0 }
  return $iif(%a,$v1,0)
}

; ########################################################## 

/*
	# IniToMrc alias coded by SReject - (thanks for support) #

*/

alias wmm_convert_ini2mrc {
  var %1 = $noqt($1)
  var %2 = $noqt($2-)

  if (!%1) || (!%2) || ($isid) || (*.ini !iswm %2) || (*.ini iswm %1) || (!$isfile(%2)) || (!$lines(%2)) { return }
  var %f = $replace(%2,$nopath(%2),%1)
  if ($isfile(%f)) { .remove -b $qt(%f) }

  :start
  var %w = @wmm_convert_ini2mrc_ $+ $ticks
  if ($window(%w)) || ($fopen(%w)) { goto start }
  set -eu %wmm_temp_convert_win %w

  window -hnlj10000000000 %w
  loadbuf -tscript %w $qt($file(%2).longfn)

  .fopen -xon %w $qt(%f)
  filter -wk %w wmm_convert_ini2mrc_temp *
  .fclose %w

  unset %wmm_temp_convert_win
  if ($window(%w)) { window -c %w }
  if ($isfile(%2)) { .remove -b $qt(%2) }
}
alias -l wmm_convert_ini2mrc_temp { .fwrite -n %wmm_temp_convert_win $regsubex($1-, /^n\d+=/, ) }

; --

/*
	# CheckDateFormat alias coded by SReject - (thanks for support) #

*/

alias wmm_cdate { 
  if (!$1) || (!$isid) { return 0 }
  if ($regex($1,/^(?:[^a-zA-Z0-9]*(?:oo|yy|[zmdhHnstT])+)+$/gS)) { return 1 }
  return 0
}

; --

/*
	# ConvertTwitchTime alias coded by SReject - (thanks for support) #

	## Official Code Link: http://pastebin.com/gTrSLpJc ##
*/

alias wmm_convertdate {
  if (!$1) || (!$isid) { return 0 }
  if ($regex($1-, /^(\d\d(?:\d\d)?)-(\d\d)-(\d\d)T(\d\d)\:(\d\d)\:(\d\d)(?:(?:\.\d\d\d)?Z|([-+])(\d\d):(\d+)|$)/i)) {
    var %m = $gettok(January February March April May June July August September October November December, $regml(2), 32)
    var %d = $ord($base($regml(3),10,10))
    var %o = +0
    if ($regml(0) > 6) && ($regml(7) isin -+) { var %o = $regml(7) $+ $calc($regml(8) * 3600 + $regml(9)) }
    var %t = $calc($ctime(%m %d $regml(1) $regml(4) $+ : $+ $regml(5) $+ : $+ $regml(6)) - %o)
    if ($asctime(zz) !== 0 && $regex($v1, /^([+-])(\d\d)(\d+)$/)) { var %o = $regml(1) $+ $calc($regml(2) * 3600 + $regml(3)) | var %t = $calc(%t + %o ) }
    return %t
  }
  else { return 0 }
}

; ---

/*
	# Download alias coded by SReject - (thanks for support) #

	## Official Code Link: http://hawkee.com/snippet/9318 ##
*/

alias wmm_download {
  if ($isid) || (!$1) || (!$2) || (!$3) { return }
  if ($regex(Args,$1-,^-c (?|(?:"(?=.+")([^"]+)")|(\S+)) (\S+) (?|(?:"(?=.+")([^"]+)")|(\S+)) (\S+)$)) {
    var %callback = $regml(Args,1)
    var %url = $regml(Args,2)
    var %file = $qt($regml(Args,3))
    var %com = $regml(Args,4)
    var %r = $iif($comerr,1,$com(%com).result)

    if ($com(%com)) { .comclose %com }
    if (%r == -1) { %callback 1 S_OK %url $qt(%file) }
    elseif (%r == 1) { %callback 0 UnKnown_ComErr %url $qt(%file) }
    elseif (%r == 2) { %callback 0 IE6+_Needed %url $qt(%file) }
    elseif (%r == 3) { %callback 0 Connect_Error %url $qt(%file) }
    elseif (%r == 4) { %callback 0 Newer_ActiveX_Needed %url $qt(%file) }
    elseif (%r == 5) { %callback 0 Writefile_Error %url $qt(%file) }
    else { %callback 0 Unknown_Error %url $qt(%file) }
  }
  elseif ($1 !== -c) {
    if ($isid) || (!$regex(Args,$1-,^(?|(?:"(?=.+")([^"]+)")|(\S+)) (\S+) (?|(?:"(?=.+")([^"]+)")|(\S+))$)) || ($regml(Args,0) !== 3) { return }

    var %callback = $regml(Args,1)
    var %url = $qt($regml(Args,2))
    var %file = $qt($iif(: isin $regml(Args,3),$v2,$scriptdir $+ $v2))
    var %com = wmm_download $+ $wmm_random $+ .vbs
    var %s = $qt($wmm_temp $+ %com)
    var %w = write %s
    %w on error resume next
    %w   set C = CreateObject("MSXML2.SERVERXMLHTTP.6.0")
    %w   if (err.number <> 0) then
    %w     err.clear
    %w   set C = CreateObject("MSXML2.SERVERXMLHTTP.3.0")
    %w   if (err.number <> 0) then
    %w     err.clear
    %w   set C = CreateObject("MSXML2.SERVERXMLHTTP")
    %w   if (err.number <> 0) then
    %w     err.clear
    %w   set C = CreateObject("MSXML2.XMLHTTP.6.0")
    %w   if (err.number <> 0) then
    %w     err.clear
    %w   set C = CreateObject("MSXML2.XMLHTTP.3.0")
    %w   if (err.number <> 0) then
    %w     err.clear
    %w   set C = CreateObject("MSXML2.XMLHTTP")
    %w   if (err.number <> 0) then 
    %w     err.clear
    %w   set C = CreateObject("XMLHttpRequest")
    %w     if (err.number <> 0) then wscript.quit(2)
    %w   end if
    %w end if
    %w end if
    %w end if
    %w end if
    %w end if
    %w C.open "GET", %url $+ , false
    %w C.send 
    %w if (err.number <> 0) then wscript.quit(3)
    %w set O = createobject("adodb.stream")
    %w if (err.number <> 0) then wscript.quit(4)
    %w O.type=1 
    %w O.mode=3 
    %w O.open 
    %w O.write C.responsebody 
    %w O.savetofile %file $+ ,2
    %w if (err.number <> 0) then wscript.quit(5)
    %w O.close
    %w Set oFso = CreateObject("Scripting.FileSystemObject") : oFso.DeleteFile Wscript.ScriptFullName, True
    %w wscript.quit(-1)

    .comopen %com WScript.Shell
    if ($lines($noqt(%s)) !== 41 || $comerr || !$comcall(%com,wmm_download -c $qt(%callback) $noqt(%url) %file,run,1,bstr*,%s,uint,1,bool,true)) { goto error }
    return
  }
  :error
  if ($error) { reseterror }
  if ($com(%com)) { .comclose %com }
}

; ---

/*
	# JSON script coded by SReject - (thanks for support) #

	## Official GitHub Repo Link: https://github.com/SReject/JSON-For-Mirc ##
*/

alias wmm_JSONVersion { return 0.2.4 }
alias wmm_JSONError {
  if ($isid) { return $iif(%wmm_JSONError,$remove(%wmm_JSONError,$chr(13),$chr(10),$chr(9)),0) }
}
alias -l COMOpenTry {
  if (!$len($com($1))) {
    if ($len($~adiircexe) && $bits == 64) { .comopen $1 ScriptControl }
    else { .comopen $1 MSScriptControl.ScriptControl }
    if ($com($1) && !$comerr) { return $true }
  }
}
alias wmm_JSONOpen {
  if ($isid) { return }
  unset %wmm_JSONError
  Debugger -i 0 Calling /wmm_JSONOpen $1-
  var %switches = -, %error, %com, %file
  if (-* iswm $1) { %switches = $1 | tokenize 32 $2- }
  if ($regex(%switches, ([^dbfuw\-]))) { %error = Invalid switches specified: $regml(1) }
  elseif ($regex(%switches, ([dbfuw]).*?\1)) { %error = Duplicate switch specified: $regml(1) }
  elseif ($regex(%switches, /([bfu])/g) > 1) { %error = Conflicting switches: $regml(1) $+ , $regml(2) }
  elseif (u !isin %switches && w isin %switches) { %error = -w switch can only be used with -u }
  elseif ($0 < 2) { %error = Missing Parameters }
  elseif (!$regex($1, /^[a-z][a-z\d_.-]+$/i)) { %error = Invalid handler name: Must start with a letter and contain only letters numbers _ . and - }
  elseif ($com(wmm_JSONHandler:: $+ $1)) { %error = Name in use }
  elseif (b isin %switches && $0 != 2) { %error = Invalid parameter: Binary variable names cannot contain spaces }
  elseif (b isin %switches && &* !iswm $2) { %error = Invalid parameters: Binary variable names start with & }
  elseif (b isin %switches && !$bvar($2, 0)) { %error = Invalid parameters: Binary variable is empty }
  elseif (f isin %switches && !$isfile($2-)) { %error = Invalid parameters: File doesn't exist }
  elseif (f isin %switches && !$file($2-).size) { %error = Invalid parameters: File is empty }
  elseif (u isin %switches && $0 != 2) { %error = Invalid parameters: URLs cannot contain spaces }
  else {
    if (!$COMOpenTry(wmm_JSONHandler:: $+ $1)) { %error = Unable to create an instance of MSScriptControl.ScriptControl }
    else {
      %com = wmm_JSONHandler:: $+ $1
      if (!$com(%com, language, 4, bstr, jscript) || $comerr) { %error = Unable to set ScriptControl's language to Javascript }
      elseif (!$com(%com, timeout, 4, bstr, 60000) || $comerr) { %error = Unable to set ScriptControl's timeout to 60seconds }
      elseif (!$com(%com, ExecuteStatement, 1, bstr, $JScript) || $comerr) { %error = Unable to add required javascript to the ScriptControl instance }
      elseif (u isincs %switches) {
        if (1 OK != $jstry(%com, $jscript(urlInit), $escape($2-).quote)) { %error = $gettok($v2, 2-, 32) }
        elseif (w !isincs %switches && 0 ?* iswm $jsTry(%com, $jscript(urlParse), status="error").withError) { %error = $gettok($v2, 2-, 32) }
      }
      elseif (f isincs %switches) {
        if (1 OK != $jstry(%com, $jscript(fileParse), $escape($longfn($2-)).quote)) { %error = $gettok($v2, 2-, 32) }
      }
      elseif (b isincs %switches) {
        %file = $tempfile
        bwrite $qt(%file) -1 -1 $2
        Debugger %com Wrote $2 to $qt(%file)
        if (0 ?* iswm $jstry(%com, $jscript(fileParse), $escape(%file).quote)) { %error = $gettok($v2, 2-, 32) }
      }
      else {
        %file = $tempfile
        write -n $qt(%file) $2-
        Debugger %com Wrote $2- to $qt(%file)
        if (0 ?* iswm $jstry(%com, $jscript(fileParse), $escape(%file).quote)) { %error = $gettok($v2, 2-, 32) }
      }
      if (!%error) {
        if (d isin %switches) { $+(.timer, %com) -ho 1 2000 wmm_JSONClose $1 }
        Debugger -s %com Successfully created
      }
    }
  }
  :error
  %error = $iif($error, $error, %error)
  reseterror
  if (%file && $isfile(%file)) { .remove $qt(%file) | Debugger %com Removed $qt(%file) }
  if (%error) {
    if (%com && $com(%com)) { .comclose %com }
    set -eu0 %wmm_JSONError %error
    Debugger -e 0 /wmm_JSONOpen %switches $1- --RAISED-- %error
  }
}
alias wmm_JSONUrlMethod {
  if ($isid) { return }
  unset %wmm_JSONError
  Debugger -i 0 Calling /wmm_JSONUrlMethod $1-
  var %error, %com
  if ($0 < 2) { %error = Missing parameters }
  elseif ($0 > 2) { %error = Too many parameters specified }
  elseif (!$regex($1, /^[a-z][a-z\d_.\-]+$/i)) { %error = Invalid handler name: Must start with a letter and contain only letters numbers _ . and - }
  elseif (!$com(wmm_JSONHandler:: $+ $1)) { %error = Invalid handler name: JSON handler does not exist }
  elseif (!$regex($2, /^(?:GET|POST|PUT|DEL)$/i)) { %error = Invalid request method: Must be GET, POST, PUT, or DEL }
  else {
    var %com = wmm_JSONHandler:: $+ $1
    if (1 OK != $jsTry(%com, $JScript(UrlMethod), status="error", $qt($upper($2))).withError) { %error = $gettok($v2, 2-, 32) }
    else { Debugger -s $+(%com,>wmm_JSONUrlMethod) Method set to $upper($2) }
  }
  :error
  %error = $iif($error, $v1, %error)
  reseterror
  if (%error) {
    set -eu0 %wmm_JSONError %error
    if (%com) { set -eu0 % [ $+ [ %com ] $+ ] ::Error %error }
    Debugger -e $iif(%com, $v1, 0) /wmm_JSONUrlMethod %switches $1- --RAISED-- %error
  }
}
alias wmm_JSONUrlHeader {
  if ($isid) { return }
  unset %wmm_JSONError
  Debugger -i 0 Calling /wmm_JSONUrlHeader $1-
  var %error, %com
  if ($0 < 3) { %error = Missing parameters }
  elseif (!$regex($1, /^[a-z][a-z\d_.\-]+$/i)) { %error = Invalid handler name: Must start with a letter and contain only letters numbers _ . and - }
  elseif (!$com(wmm_JSONHandler:: $+ $1)) { %error = Invalid handler name: JSON handler does not exist }
  elseif (!$regex($2, /^[a-z_-]+:?$/i)) { %error = Invalid header name: Header names can only contain letters, _ and - }
  else {
    %com = wmm_JSONHandler:: $+ $1
    if (1 OK !== $jsTry(%com, $JScript(UrlHeader), status="error", $escape($regsubex($2, :+$, )).quote, $escape($3-).quote).withError) { %error = $gettok($v2, 2-, 32) }
    else { Debugger -s $+(%com,>wmm_JSONUrlHeader) Header $+(',$2,') set to $3- }
  }
  :error
  %error = $iif($error, $v1, %error)
  reseterror
  if (%error) {
    set -eu0 %wmm_JSONError %error
    if (%com) set -eu0 % [ $+ [ %com ] $+ ] ::Error %error
    Debugger -e $iif(%com, $v1, 0) /wmm_JSONUrlMethod %switches $1- --RAISED-- %error
  }
}

alias wmm_JSONUrlGet {
  if ($isid) { return }
  unset %wmm_JSONError
  Debugger -i 0 Calling /wmm_JSONUrlGet $1-
  var %switches = -, %error, %com, %file
  if (-* iswm $1) { %switches = $1 | tokenize 32 $2- }
  if (!$0 || (%switches != - && $0 < 2)) { %error = Missing parameters }
  elseif (!$regex(%switches, ^-[bf]?$)) { %error = Invalid switch(es) specified }
  elseif (!$regex($1, /^[a-z][a-z\d_.\-]+$/i)) { %error = Invalid handler name: Must start with a letter and contain only letters numbers _ . and - }
  elseif (!$com(wmm_JSONHandler:: $+ $1)) { %error = Specified handler does not exist }
  elseif (b isincs %switches && &* !iswm $2) { %error = Invalid bvar name: bvars start with & }
  elseif (b isincs %switches && $0 > 2) { %error = Invalid bvar name: Contains spaces: $2- }
  elseif (f isincs %switches && !$isfile($2-)) { %error = Specified file does not exist: $longfn($2-) }
  else {
    %com = wmm_JSONHandler:: $+ $1
    if ($0 > 1) {
      if (f isincs %switches) {
        if (0 ?* iswm $jsTry(%com, $JScript(UrlData), status="error", $escape($longfn($2-)).quote).withError) { %error = $gettok($v2, 2-, 32) }
        else { Debugger -s $+(%com,>wmm_JSONUrlGet) Stored $longfn($2-) as data to send with HTTP Request }
      }
      else {
        %file = $tempfile
        if (b isincs %switches) { bwrite $qt(%file) -1 -1 $2 }
        else { write -n $qt(%file) $2- }
        Debugger -s $+(%com,>wmm_JSONUrlGet) Wrote specified data to %file
        if (0 ?* iswm $jsTry(%com, $JScript(UrlData), status="error", $escape(%file).quote).withError) { %error = $gettok($v2, 2-, 32) }
        else { Debugger -s $+(%Com,>wmm_JSONUrlGet) Stored $2- as data to send with HTTP Request }
        .remove $qt(%file)
      }
    }
    if (!%error) {
      if (0 ?* iswm $jsTry(%com, $JScript(URLParse), status="error").withError) { %error = $gettok($v2, 2-, 32) }
      else { Debugger -s $+(%com,>wmm_JSONUrlGet) Request finished }
    }
  }
  :error
  %error = $iif($error, $v1, %error)
  reseterror
  if (%error) {
    set -eu0 %wmm_JSONError %error
    if (%com) set -eu0 % [ $+ [ %com ] $+ ] ::Error %error
    Debugger -e $iif(%com, $v1, 0) /wmm_JSONUrlGet %switches $1- --RAISED-- %error
  }
}

alias wmm_JSONClose {
  if ($isid) { return }
  unset %wmm_JSONError
  Debugger -i 0 /wmm_JSONClose $1-
  var %switches = -, %error, %com, %x
  if (-* iswm $1) { %switches = $1 | tokenize 32 $2- }
  if ($0 < 1) { %error = Missing parameters }
  elseif ($0 > 1) { %error = Too many parameters specified. }
  elseif (%switches !== - && %switches != -w) { %error = Unknown switches specified }
  elseif (%switches == -) {
    %com = wmm_JSONHandler:: $+ $1
    if ($com(%com)) { .comclose %com }
    if ($timer(%com)) { $+(.timer,%com) off }
    unset % [ $+ [ %com ] $+ ] ::Error
    Debugger -i %com Closed
  }
  else {
    %com = wmm_JSONHandler:: $+ $1
    %x = 1
    while (%x <= $com(0)) {
      if (%com iswm $com(%x)) { .comclose $v1 | $+(.timer,$v1) off | unset % [ $+ [ $v1 ] $+ ] ::* | Debugger -i %com Closed }
      else { inc %x }
    }
  }
  :error
  %error = $iif($error, $v1, %error)
  reseterror
  if (%error) { set -eu0 %wmm_JSONError %error }
}

alias wmm_JSONList {
  if ($isid) { return }
  linesep
  Debugger -i 0 Calling /wmm_JSONList $1-
  var %x = 1, %i = 0
  while ($com(%x)) {
    if (wmm_JSONHandler::* iswm $v1) { inc %i | echo $color(info) -a * # $+ %i : $regsubex($v2, /^wmm_JSONHandler::/, ) }
    inc %x
  }
  if (!%i) { echo $color(info) -a * No active JSON handlers. }
  linesep
}

alias wmm_JSON {
  if (!$isid) { return }
  var %x, %calling, %i = 0, %com, %get = json, %ref = $false, %error, %file
  if ($wmm_JSONDebug) {
    %x = 0
    while (%x < $0) { inc %x | %calling = %calling $+ $iif(%calling,$chr(44)) $($ $+ %x,2) }
    Debugger -i 0 Calling $!wmm_JSON( $+ %calling $+ $chr(41) $+ $iif($prop,. $+ $prop)
  }
  if (!$0) { return }
  if ($regex($1, ^\d+$)) {
    %x = 1
    while ($com(%x)) {
      if (wmm_JSONHandler::* iswm $v1) {
        inc %i
        if (%i == $1) { %com = $com(%x) | break }
      }
      inc %x
    }
    if ($0 == 1 && $1 == 0) { return %i }
  }
  elseif ($regex($1, /^[a-z][a-z\d_.-]+$/i)) { %com = wmm_JSONHandler:: $+ $1 }
  elseif ($regex($1, /^(wmm_JSONHandler::[a-z][a-z\d_.-]+)::(.+)$/i)) { %com = $regml(1) | %get = json $+ $regml(2) | %ref = $true }
  if (!%com) { %error = Invalid name specified }
  elseif (!$com(%com)) { %error = Handler doesn't exist }
  elseif (!$regex($prop, /^(?:Status|IsRef|IsChild|Error|Data|UrlStatus|UrlStatusText|UrlHeader|Fuzzy|FuzzyPath|Type|Length|ToBvar|IsParent)?$/i)) { %error = Unknown prop specified }
  elseif ($0 == 1) {
    if ($prop == isRef) { return %ref }
    elseif ($prop == isChild) { Debugger -i 0 $!wmm_JSON().isChild is depreciated use $!wmm_JSON().isRef | return %ref }
    elseif ($prop == status) {
      if ($com(%com, eval, 1, bstr, status) && !$comerr) { return $com(%com).result }
      else { %error = Unable to determine status }
    }
    elseif ($prop == error) {
      if ($eval($+(%,%com,::Error),2)) { return $v1 }
      elseif ($com(%com, eval, 1, bstr, error) && !$comerr) { return $com(%com).result }
      else { %error = Unable to determine if there is an error }
    }
    elseif ($prop == UrlStatus || $prop == UrlStatusText) {
      if (0 ?* iswm $jsTry(%com, $JScript($prop))) { %error = $gettok($v2, 2-, 32) }
      else { return $v2 }
    }
    elseif (!$prop) { return $regsubex(%com,/^wmm_JSONHandler::/,) }
  }
  elseif (!$regex($prop, /^(?:fuzzy|fuzzyPath|data|type|length|toBvar|isParent)?$/i)) { %error = $+(',$prop,') cannot be used when referencing items }
  elseif ($prop == toBvar && $chr(38) !== $left($2, 1) ) { %error = Invalid bvar specified: bvar names must start with & }
  elseif ($prop == UrlHeader) {
    if ($0 != 2) { %error = Missing or excessive header parameter specified }
    elseif (0 ?* iswm $jsTry(%com, $JScript(UrlHeader), $escape($2).quote)) { %error = $gettok($v2, 2-, 32) }
    else { return $gettok($v2, 2-, 32) }
  }
  elseif (fuzzy* iswm $prop) {
    if ($0 < 2) { %error = Missing parameters }
    else {
      var %x = 2, %path, %res
      while (%x <= $0) { %path = %path $+ $escape($($ $+ %x, 2)).quote $+ $chr(44) | inc %x }
      %res = $jsTry(%com, $JScript(fuzzy), %get, $left(%path, -1))
      if (0 ? iswm %res) { %error = $gettok(%res, 2-, 32) }
      elseif ($prop == fuzzy) { %get = %get $+ $gettok(%res, 2-, 32) }
      else { return $regsubex(%get, ^json, ) $+ $gettok(%res, 2-, 32) }
    }
  }
  if (!%error) {
    if (fuzzy* !iswm $prop) {
      %x = $iif($prop == toBvar, 3, 2)
      while (%x <= $0) {
        %i = $($ $+ %x, 2)
        if ($len(%i)) { %get = $+(%get, [", $escape(%i), "]) | inc %x }
        else { %error = Empty index|item passed. | break }
      }
    }
    if (!%error) {
      if ($prop == type) {
        if (0 ?* iswm $jsTry(%com, $JScript(typeof), %get)) { %error = $gettok($v2, 2-, 32) }
        else { return $gettok($v2, 2-, 32) }
      }
      elseif ($prop == length) {
        if (0 ?* iswm $jsTry(%com, $JScript(length), %get)) { %error = $gettok($v2, 2-, 32) }
        else { return $gettok($v2, 2-, 32) }
      }
      elseif ($prop == isParent) {
        if (0 ?* iswm $jsTry(%com, $JScript(isparent), %get)) { %error = $gettok($v2, 2-, 32) }
        else { return $iif($gettok($v2, 2-, 32), $true, $false) }
      }
      elseif ($prop == toBvar) {
        %file = $tempfile
        if (0 ?* iswm $jsTry(%com, $JScript(tofile), $escape(%file).quote, %get)) { %error = $gettok($v2, 2-, 32) }
        else { bread $qt(%file) 0 $file(%file) $2 }
        if ($isfile(%file)) { .remove $qt(%file) }
      }
      elseif (0 ?* iswm $jsTry(%com, $JScript(get), %get)) {
        %error = $gettok($v2, 2-, 32)
        if (%error == Object or Array referenced) { %error = $null | Debugger -s $+(%com,>$wmm_JSON) Result is an Object or Array; returning reference | return %com $+ :: $+ $regsubex(%get, /^json/, ) }
      }
      else { var %res = $gettok($v2, 2-, 32) | Debugger -s $+(%com,>$wmm_JSON) %get references %res | return %res }
    }
  }
  :error
  %error = $iif($error, $v1, %error)
  if (%error) {
    set -eu0 %wmm_JSONError
    if (%com && $com(%com)) { set -eu0 $+(%,%com,::Error) %error }
    var %r
    %x = 0
    while (%x < $0) { inc %x | %r = $addtok(%r, $chr(32) $+ $ [ $+ [ %x ] ] , 44) }
    Debugger -e $iif(%com && $com(%com),%com,0) $!wmm_JSON( $+ %r $+ ) $+ $+ $iif($prop,. $+ $prop) --RAISED-- %error
  }
}
alias wmm_JSONDebug {
  if ($isid) { return $iif($group(#wmm_JSONForMircDebug) == on,$true,$false) }
  if (!$1) { linesep | echo $color(info) -a * /wmm_JSONDebug: insufficient parameters | linesep | return }
  if (!$istok(on off enable disable,$1,32)) { linesep | echo $color(info) -a * /wmm_JSONDebug: invalid parameters | linesep | return }
  if ($1 == on) || ($1 == enable) { .enable #wmm_JSONForMircDebug | Debugger -i Debugger Now Enabled }
  elseif ($1 == off) || ($1 == disable) { .disable #wmm_JSONForMircDebug | $iif($window(@wmm_JSONForMircDebug),close -@ @wmm_JSONForMircDebug) }
}

#wmm_JSONForMircDebug off
alias -l Debugger {
  if ($isid) { return }
  if (!$window(@wmm_JSONForMircDebug)) { window -zk0 @wmm_JSONForMircDebug }
  var %switches = -, %c
  if (-* iswm $1) { %switches = $1 | tokenize 32 $2- }
  if (e isincs %switches) { %c = 04 }
  elseif (s isincs %switches) { %c = 12 }
  else { %c = 03 }
  var %n = $iif($1, $1, JSONForMirc)
  %n = $regsubex(%n, /^wmm_JSONHandler::, )
  aline -p @wmm_JSONForMircDebug $+($chr(3),%c,[,%n,],$chr(15)) $2-
}
#wmm_JSONForMircDebug end

alias -l Debugger { noop }

menu @wmm_JSONForMircDebug {
  .Clear: clear -@ @wmm_JsonForMircDebug
  .Disable and Close: wmm_JSONDebug off
}
alias -l tempfile {
  :st
  var %f = $wmm_temp $+ JSONTmpFile_ $+ $wmm_random $+ .json
  if ($isfile(%f)) { goto st }
  return %f
}
alias -l escape { var %esc = $replace($1-,\,\\,",\") | return $iif($prop == quote, $qt(%esc), %esc) }
alias -l JScript {
  if (!$isid) { return }
  if (!$0) return (function(){status="init";json=null;url={m:"GET",u:null,h:[],d:null};response=null;var r,x=['MSXML2.SERVERXMLHTTP.6.0','MSXML2.SERVERXMLHTTP.3.0','MSXML2.SERVERXMLHTTP','MSXML2.XMLHTTP.6.0','MSXML2.XMLHTTP.3.0','Microsoft.XMLHTTP'],i;while(x.length){try{r=new ActiveXObject(x.shift());break}catch(e){}}xhr=r?function(){r.open(url.m,url.u,false);for(i=0;i<url.h.length;i+=1)r.setRequestHeader(url.h[i][0],url.h[i][1]);r.send(url.d);return(response=r).responseText}:function(){throw new Error("HTTP Request object not found")};read=function(f){var a=new ActiveXObject("ADODB.stream"),d;a.CharSet="utf-8";a.Open();a.LoadFromFile(f);if(a.EOF){a.close();throw new Error("No content in file")}d=a.ReadText();a.Close();return d;};write=function(f,d){var a=new ActiveXObject("ADODB.stream");a.CharSet="utf-8";a.Open();a.WriteText(d);a.SaveToFile(f,2);a.Close()};parse=function(t){if(/^[\],:{}\s]*$/.test((t=(String(t)).replace(/[\u0000\u00ad\u0600-\u0604\u070f\u17b4\u17b5\u200c-\u200f\u2028-\u202f\u2060-\u206f\ufeff\ufff0-\uffff]/g,function(a){return'\\u'+('0000'+a.charCodeAt(0).toString(16)).slice(-4)})).replace(/\\(?:["\\\/bfnrt]|u[0-9a-fA-F]{4})/g,'@').replace(/"[^"\\\n\r]*"|true|false|null|-?\d+(?:\.\d*)?(?:[eE][+\-]?\d+)?/g,']').replace(/(?:^|:|,)(?:\s*\[)+/g,''))){try{return eval('('+t+')');}catch(e){throw new SyntaxError('Unable to Parse: Invalid JSON');}}throw new SyntaxError('Unable to Parse: Invalid JSON')};fuzzy=function(){var a=Array.prototype.slice.call(arguments),b=a.shift(),c="",d=Object.prototype.toString.call(b),e,f,g,h,i;for(e=0;e<a.length;e+=1){f=a[e];if(b.hasOwnProperty(f)){if(typeof b[f]==="function")throw new TypeError("Reference points to a function");b=b[f];c+="[\""+f+"\"]"}else if(d==="[object Object]"){if(typeof f==="number")f=f.toString(10);f=f.toLowerCase();g=-1;i=!1;for(h in b){if(b.hasOwnProperty(h)&&typeof b[h]!=="function"){g+=1;if(h.toLowerCase()===f){b=b[h];c+="[\""+h+"\"]";i=!0;break}else if(g.toString(10)===f){b=b[h];c+="[\""+h+"\"]";i=!0;break}}}if(!i)throw new Error("No matching reference found");}else{throw new Error("Reference does not exist")}d=Object.prototype.toString.call(b)}return c}}());
  if ($1 == FileParse)     return if(status!=="init")throw new Error("Parse Not Pending");json=parse(read(@1@));status="done";
  if ($1 == UrlInit)       return if(status!=="init")throw new Error("JSON handler not ready");url.u=@1@;status="url";
  if ($1 == UrlMethod)     return if(status!=="url")throw new Error("URL Request Not Pending");url.m=@1@;
  if ($1 == UrlHeader)     return if(status!=="url")throw new Error("URL Request Not Pending");url.h.push([@1@,@2@]);
  if ($1 == UrlData)       return if(status!=="url")throw new Error("URL Request Not Pending");url.d=read(@1@);
  if ($1 == UrlParse)      return if(status!=="url")throw new Error("URL Request Not Pending");json=parse(xhr());status="done";
  if ($1 == UrlStatus)     return if(status!=="done")throw new Error("Data not parsed");if(!response)throw new Error("URL request not made");return response.status;
  if ($1 == UrlStatusText) return if(status!=="done")throw new Error("Data not parsed");if(!response)throw new Error("URL request not made");return response.statusText;
  if ($1 == UrlHeader)     return if(status!=="done")throw new Error("Data not parsed");if(!response)throw new Error("URL Request not made");return response.getResponseHeader(@1@);
  if ($1 == fuzzy)         return if(status!=="done")throw new Error("Data not parsed");return "1 "+fuzzy(@1@,@2@);
  if ($1 == typeof)        return if(status!=="done")throw new Error("Data not parsed");var i=@1@;if(i===undefined)throw new TypeError("Reference doesn't exist");if(i===null)return"1 null";var s=Object.prototype.toString.call(i);if(s==="[object Array]")return"1 array";if(s==="[object Object]")return"1 object";return "1 "+typeof(i);
  if ($1 == length)        return if(status!=="done")throw new Error("Data not parsed");var i=@1@;if(i===undefined)throw new TypeError("Reference doesn't exist");if(/^\[object (?:String|Array)\]$/.test(Object.prototype.toString.call(i)))return"1 "+i.length.toString(10);throw new Error("Reference is not a string or array");
  if ($1 == isparent)      return if(status!=="done")throw new Error("Data not parsed");var i=@1@;if(i===undefined)throw new TypeError("Reference doesn't exist");if(/^\[object (?:Object|Array)\]$/.test(Object.prototype.toString.call(i)))return"1 1";return"1 0";
  if ($1 == tofile)        return if(status!=="done")throw new Error("Data not parsed");var i=@2@;if(i===undefined)throw new TypeError("Reference doesn't exist");if(typeof i!=="string")throw new TypeError("Reference must be a string");write(@1@,i);
  if ($1 == get)           return if(status!=="done")throw new Error("Data not parsed");var i=@1@;if(i===undefined)throw new TypeError("Reference doesn't exist");if(i===null)return"1";if(/^\[object (?:Array|Object)\]$/.test(Object.prototype.toString.call(i)))throw new TypeError("Object or Array referenced");if(i.length>4000)throw new Error("Data would exceed client's line length limit");if(typeof i == "boolean")return i?"1 1":"1 0";if(typeof i == "number")return "1 "+i.toString(10);return "1 "+i;
}
alias -l jsTry {
  if ($isid) {
    if ($0 < 2 || $prop == withError && $0 < 3) { return 0 Missing parameters }
    elseif (!$com($1)) { return 0 No such com }
    else {
      var %code = $2, %error, %n = 2, %o, %js
      if ($prop == withError) { %error = $3 | %n = 3 }
      %o = %n
      while (%n < $0) { inc %n | set -l $+(%, arg, $calc(%n - %o)) $eval($+($, %n), 2) }
      %code = $regsubex($regsubex(%code, /@(\d+)@/g, $var($+(%, arg, \t ),1).value), [\s;]+$, )
      %error = $regsubex($regsubex(%error, /@(\d+)@/g, $var($+(%, arg, \t ),1).value), [\s;]+$, )
      if ($len(%code)) { %code = %code $+ $chr(59) }
      if ($len(%error)) { %error = %error $+ $chr(59) }
      %js = (function(){error=null;try{ $+ %code $+ return"1 OK"}catch(e){ $+ %error $+ error=e.message;return"0 "+error}}());
      Debugger $1>$jsTry Executing: %js
      if (!$com($1, eval, 1, bstr, %js) || $comerr) { return 0 Unable to execute specified javascript }
      return $com($1).result
    }
  }
}

; ---

/*
	# HTML2Ascii (Unicode) script coded by David Schor - (thanks for support) #

	## GitHub Link: https://github.com/ds--/CodeArchive/blob/master/mSL/net/html2unicode.mrc ##
*/

alias wmm_html2asc {
  if (!$isid) { return }
  if (!$hget(WMM_HTML)) { wmm_html_make }
  return $regsubex(~, $1, /&(.+);/Ug, $wmm_ht_get(\t))
}
alias -l wmm_ht_get {
  if (#x* iswm $1) { return $chr($base($mid($1, 3), 16, 10)) }
  elseif (#* iswm $1) { return $chr($mid($1, 2)) }
  return $hget(WMM_HTML, $hfind(WMM_HTML, $1, 1, R))
}
alias -l wmm_html_make {
  var %h = WMM_HTML
  hmake %h 3000
  hadd %h /^amp$/9 $chr($base(0026, 16, 10))
  hadd %h /^lt$/22 $chr($base(003C, 16, 10))
  hadd %h /^gt$/27 $chr($base(003E, 16, 10))
  hadd %h /^nbsp$/50 $chr($base(00A0, 16, 10))
  hadd %h /^iexcl$/52 $chr($base(00A1, 16, 10))
  hadd %h /^cent$/53 $chr($base(00A2, 16, 10))
  hadd %h /^pound$/54 $chr($base(00A3, 16, 10))
  hadd %h /^curren$/55 $chr($base(00A4, 16, 10))
  hadd %h /^yen$/56 $chr($base(00A5, 16, 10))
  hadd %h /^brvbar$/57 $chr($base(00A6, 16, 10))
  hadd %h /^sect$/58 $chr($base(00A7, 16, 10))
  hadd %h /^uml$/62 $chr($base(00A8, 16, 10))
  hadd %h /^copy$/63 $chr($base(00A9, 16, 10))
  hadd %h /^ordf$/65 $chr($base(00AA, 16, 10))
  hadd %h /^laquo$/66 $chr($base(00AB, 16, 10))
  hadd %h /^not$/67 $chr($base(00AC, 16, 10))
  hadd %h /^shy$/68 $chr($base(00AD, 16, 10))
  hadd %h /^reg$/69 $chr($base(00AE, 16, 10))
  hadd %h /^macr$/72 $chr($base(00AF, 16, 10))
  hadd %h /^deg$/74 $chr($base(00B0, 16, 10))
  hadd %h /^plusmn$/75 $chr($base(00B1, 16, 10))
  hadd %h /^sup2$/78 $chr($base(00B2, 16, 10))
  hadd %h /^sup3$/79 $chr($base(00B3, 16, 10))
  hadd %h /^acute$/80 $chr($base(00B4, 16, 10))
  hadd %h /^micro$/82 $chr($base(00B5, 16, 10))
  hadd %h /^para$/83 $chr($base(00B6, 16, 10))
  hadd %h /^middot$/84 $chr($base(00B7, 16, 10))
  hadd %h /^cedil$/87 $chr($base(00B8, 16, 10))
  hadd %h /^sup1$/89 $chr($base(00B9, 16, 10))
  hadd %h /^ordm$/90 $chr($base(00BA, 16, 10))
  hadd %h /^raquo$/91 $chr($base(00BB, 16, 10))
  hadd %h /^frac14$/92 $chr($base(00BC, 16, 10))
  hadd %h /^frac12$/93 $chr($base(00BD, 16, 10))
  hadd %h /^frac34$/95 $chr($base(00BE, 16, 10))
  hadd %h /^iquest$/96 $chr($base(00BF, 16, 10))
  hadd %h /^Agrave$/97 $chr($base(00C0, 16, 10))
  hadd %h /^Aacute$/98 $chr($base(00C1, 16, 10))
  hadd %h /^Acirc$/99 $chr($base(00C2, 16, 10))
  hadd %h /^Atilde$/100 $chr($base(00C3, 16, 10))
  hadd %h /^Auml$/101 $chr($base(00C4, 16, 10))
  hadd %h /^Aring$/102 $chr($base(00C5, 16, 10))
  hadd %h /^AElig$/104 $chr($base(00C6, 16, 10))
  hadd %h /^Ccedil$/105 $chr($base(00C7, 16, 10))
  hadd %h /^Egrave$/106 $chr($base(00C8, 16, 10))
  hadd %h /^Eacute$/107 $chr($base(00C9, 16, 10))
  hadd %h /^Ecirc$/108 $chr($base(00CA, 16, 10))
  hadd %h /^Euml$/109 $chr($base(00CB, 16, 10))
  hadd %h /^Igrave$/110 $chr($base(00CC, 16, 10))
  hadd %h /^Iacute$/111 $chr($base(00CD, 16, 10))
  hadd %h /^Icirc$/112 $chr($base(00CE, 16, 10))
  hadd %h /^Iuml$/113 $chr($base(00CF, 16, 10))
  hadd %h /^ETH$/114 $chr($base(00D0, 16, 10))
  hadd %h /^Ntilde$/115 $chr($base(00D1, 16, 10))
  hadd %h /^Ograve$/116 $chr($base(00D2, 16, 10))
  hadd %h /^Oacute$/117 $chr($base(00D3, 16, 10))
  hadd %h /^Ocirc$/118 $chr($base(00D4, 16, 10))
  hadd %h /^Otilde$/119 $chr($base(00D5, 16, 10))
  hadd %h /^Ouml$/120 $chr($base(00D6, 16, 10))
  hadd %h /^times$/121 $chr($base(00D7, 16, 10))
  hadd %h /^Oslash$/122 $chr($base(00D8, 16, 10))
  hadd %h /^Ugrave$/123 $chr($base(00D9, 16, 10))
  hadd %h /^Uacute$/124 $chr($base(00DA, 16, 10))
  hadd %h /^Ucirc$/125 $chr($base(00DB, 16, 10))
  hadd %h /^Uuml$/126 $chr($base(00DC, 16, 10))
  hadd %h /^Yacute$/127 $chr($base(00DD, 16, 10))
  hadd %h /^THORN$/128 $chr($base(00DE, 16, 10))
  hadd %h /^szlig$/129 $chr($base(00DF, 16, 10))
  hadd %h /^agrave$/130 $chr($base(00E0, 16, 10))
  hadd %h /^aacute$/131 $chr($base(00E1, 16, 10))
  hadd %h /^acirc$/132 $chr($base(00E2, 16, 10))
  hadd %h /^atilde$/133 $chr($base(00E3, 16, 10))
  hadd %h /^auml$/134 $chr($base(00E4, 16, 10))
  hadd %h /^aring$/135 $chr($base(00E5, 16, 10))
  hadd %h /^aelig$/136 $chr($base(00E6, 16, 10))
  hadd %h /^ccedil$/137 $chr($base(00E7, 16, 10))
  hadd %h /^egrave$/138 $chr($base(00E8, 16, 10))
  hadd %h /^eacute$/139 $chr($base(00E9, 16, 10))
  hadd %h /^ecirc$/140 $chr($base(00EA, 16, 10))
  hadd %h /^euml$/141 $chr($base(00EB, 16, 10))
  hadd %h /^igrave$/142 $chr($base(00EC, 16, 10))
  hadd %h /^iacute$/143 $chr($base(00ED, 16, 10))
  hadd %h /^icirc$/144 $chr($base(00EE, 16, 10))
  hadd %h /^iuml$/145 $chr($base(00EF, 16, 10))
  hadd %h /^eth$/146 $chr($base(00F0, 16, 10))
  hadd %h /^ntilde$/147 $chr($base(00F1, 16, 10))
  hadd %h /^ograve$/148 $chr($base(00F2, 16, 10))
  hadd %h /^oacute$/149 $chr($base(00F3, 16, 10))
  hadd %h /^ocirc$/150 $chr($base(00F4, 16, 10))
  hadd %h /^otilde$/151 $chr($base(00F5, 16, 10))
  hadd %h /^ouml$/152 $chr($base(00F6, 16, 10))
  hadd %h /^divide$/153 $chr($base(00F7, 16, 10))
  hadd %h /^oslash$/155 $chr($base(00F8, 16, 10))
  hadd %h /^ugrave$/156 $chr($base(00F9, 16, 10))
  hadd %h /^uacute$/157 $chr($base(00FA, 16, 10))
  hadd %h /^ucirc$/158 $chr($base(00FB, 16, 10))
  hadd %h /^uuml$/159 $chr($base(00FC, 16, 10))
  hadd %h /^yacute$/160 $chr($base(00FD, 16, 10))
  hadd %h /^thorn$/161 $chr($base(00FE, 16, 10))
  hadd %h /^yuml$/162 $chr($base(00FF, 16, 10))
  hadd %h /^Tab$/1 $chr($base(0009, 16, 10))
  hadd %h /^NewLine$/2 $chr($base(000A, 16, 10))
  hadd %h /^excl$/3 $chr($base(0021, 16, 10))
  hadd %h /^quot$/4 $chr($base(0022, 16, 10))
  hadd %h /^QUOT$/5 $chr($base(0022, 16, 10))
  hadd %h /^num$/6 $chr($base(0023, 16, 10))
  hadd %h /^dollar$/7 $chr($base(0024, 16, 10))
  hadd %h /^percnt$/8 $chr($base(0025, 16, 10))
  hadd %h /^AMP$/10 $chr($base(0026, 16, 10))
  hadd %h /^apos$/11 $chr($base(0027, 16, 10))
  hadd %h /^lpar$/12 $chr($base(0028, 16, 10))
  hadd %h /^rpar$/13 $chr($base(0029, 16, 10))
  hadd %h /^ast$/14 $chr($base(002A, 16, 10))
  hadd %h /^midast$/15 $chr($base(002A, 16, 10))
  hadd %h /^plus$/16 $chr($base(002B, 16, 10))
  hadd %h /^comma$/17 $chr($base(002C, 16, 10))
  hadd %h /^period$/18 $chr($base(002E, 16, 10))
  hadd %h /^sol$/19 $chr($base(002F, 16, 10))
  hadd %h /^colon$/20 $chr($base(003A, 16, 10))
  hadd %h /^semi$/21 $chr($base(003B, 16, 10))
  hadd %h /^LT$/23 $chr($base(003C, 16, 10))
  hadd %h /^nvlt$/24 $chr($base(003C, 16, 10)) $+ $chr($base(20D2, 16, 10))
  hadd %h /^equals$/25 $chr($base(003D, 16, 10))
  hadd %h /^bne$/26 $chr($base(003D, 16, 10)) $+ $chr($base(20E5, 16, 10))
  hadd %h /^GT$/28 $chr($base(003E, 16, 10))
  hadd %h /^nvgt$/29 $chr($base(003E, 16, 10)) $+ $chr($base(20D2, 16, 10))
  hadd %h /^quest$/30 $chr($base(003F, 16, 10))
  hadd %h /^commat$/31 $chr($base(0040, 16, 10))
  hadd %h /^lsqb$/32 $chr($base(005B, 16, 10))
  hadd %h /^lbrack$/33 $chr($base(005B, 16, 10))
  hadd %h /^bsol$/34 $chr($base(005C, 16, 10))
  hadd %h /^rsqb$/35 $chr($base(005D, 16, 10))
  hadd %h /^rbrack$/36 $chr($base(005D, 16, 10))
  hadd %h /^Hat$/37 $chr($base(005E, 16, 10))
  hadd %h /^lowbar$/38 $chr($base(005F, 16, 10))
  hadd %h /^UnderBar$/39 $chr($base(005F, 16, 10))
  hadd %h /^grave$/40 $chr($base(0060, 16, 10))
  hadd %h /^DiacriticalGrave$/41 $chr($base(0060, 16, 10))
  hadd %h /^fjlig$/42 $chr($base(0066, 16, 10)) $+ $chr($base(006A, 16, 10))
  hadd %h /^lcub$/43 $chr($base(007B, 16, 10))
  hadd %h /^lbrace$/44 $chr($base(007B, 16, 10))
  hadd %h /^verbar$/45 $chr($base(007C, 16, 10))
  hadd %h /^vert$/46 $chr($base(007C, 16, 10))
  hadd %h /^VerticalLine$/47 $chr($base(007C, 16, 10))
  hadd %h /^rcub$/48 $chr($base(007D, 16, 10))
  hadd %h /^rbrace$/49 $chr($base(007D, 16, 10))
  hadd %h /^NonBreakingSpace$/51 $chr($base(00A0, 16, 10))
  hadd %h /^Dot$/59 $chr($base(00A8, 16, 10))
  hadd %h /^die$/60 $chr($base(00A8, 16, 10))
  hadd %h /^DoubleDot$/61 $chr($base(00A8, 16, 10))
  hadd %h /^COPY$/64 $chr($base(00A9, 16, 10))
  hadd %h /^circledR$/70 $chr($base(00AE, 16, 10))
  hadd %h /^REG$/71 $chr($base(00AE, 16, 10))
  hadd %h /^strns$/73 $chr($base(00AF, 16, 10))
  hadd %h /^pm$/76 $chr($base(00B1, 16, 10))
  hadd %h /^PlusMinus$/77 $chr($base(00B1, 16, 10))
  hadd %h /^DiacriticalAcute$/81 $chr($base(00B4, 16, 10))
  hadd %h /^centerdot$/85 $chr($base(00B7, 16, 10))
  hadd %h /^CenterDot$/86 $chr($base(00B7, 16, 10))
  hadd %h /^Cedilla$/88 $chr($base(00B8, 16, 10))
  hadd %h /^half$/94 $chr($base(00BD, 16, 10))
  hadd %h /^angst$/103 $chr($base(00C5, 16, 10))
  hadd %h /^div$/154 $chr($base(00F7, 16, 10))
  hadd %h /^Amacr$/163 $chr($base(0100, 16, 10))
  hadd %h /^amacr$/164 $chr($base(0101, 16, 10))
  hadd %h /^Abreve$/165 $chr($base(0102, 16, 10))
  hadd %h /^abreve$/166 $chr($base(0103, 16, 10))
  hadd %h /^Aogon$/167 $chr($base(0104, 16, 10))
  hadd %h /^aogon$/168 $chr($base(0105, 16, 10))
  hadd %h /^Cacute$/169 $chr($base(0106, 16, 10))
  hadd %h /^cacute$/170 $chr($base(0107, 16, 10))
  hadd %h /^Ccirc$/171 $chr($base(0108, 16, 10))
  hadd %h /^ccirc$/172 $chr($base(0109, 16, 10))
  hadd %h /^Cdot$/173 $chr($base(010A, 16, 10))
  hadd %h /^cdot$/174 $chr($base(010B, 16, 10))
  hadd %h /^Ccaron$/175 $chr($base(010C, 16, 10))
  hadd %h /^ccaron$/176 $chr($base(010D, 16, 10))
  hadd %h /^Dcaron$/177 $chr($base(010E, 16, 10))
  hadd %h /^dcaron$/178 $chr($base(010F, 16, 10))
  hadd %h /^Dstrok$/179 $chr($base(0110, 16, 10))
  hadd %h /^dstrok$/180 $chr($base(0111, 16, 10))
  hadd %h /^Emacr$/181 $chr($base(0112, 16, 10))
  hadd %h /^emacr$/182 $chr($base(0113, 16, 10))
  hadd %h /^Edot$/183 $chr($base(0116, 16, 10))
  hadd %h /^edot$/184 $chr($base(0117, 16, 10))
  hadd %h /^Eogon$/185 $chr($base(0118, 16, 10))
  hadd %h /^eogon$/186 $chr($base(0119, 16, 10))
  hadd %h /^Ecaron$/187 $chr($base(011A, 16, 10))
  hadd %h /^ecaron$/188 $chr($base(011B, 16, 10))
  hadd %h /^Gcirc$/189 $chr($base(011C, 16, 10))
  hadd %h /^gcirc$/190 $chr($base(011D, 16, 10))
  hadd %h /^Gbreve$/191 $chr($base(011E, 16, 10))
  hadd %h /^gbreve$/192 $chr($base(011F, 16, 10))
  hadd %h /^Gdot$/193 $chr($base(0120, 16, 10))
  hadd %h /^gdot$/194 $chr($base(0121, 16, 10))
  hadd %h /^Gcedil$/195 $chr($base(0122, 16, 10))
  hadd %h /^Hcirc$/196 $chr($base(0124, 16, 10))
  hadd %h /^hcirc$/197 $chr($base(0125, 16, 10))
  hadd %h /^Hstrok$/198 $chr($base(0126, 16, 10))
  hadd %h /^hstrok$/199 $chr($base(0127, 16, 10))
  hadd %h /^Itilde$/200 $chr($base(0128, 16, 10))
  hadd %h /^itilde$/201 $chr($base(0129, 16, 10))
  hadd %h /^Imacr$/202 $chr($base(012A, 16, 10))
  hadd %h /^imacr$/203 $chr($base(012B, 16, 10))
  hadd %h /^Iogon$/204 $chr($base(012E, 16, 10))
  hadd %h /^iogon$/205 $chr($base(012F, 16, 10))
  hadd %h /^Idot$/206 $chr($base(0130, 16, 10))
  hadd %h /^imath$/207 $chr($base(0131, 16, 10))
  hadd %h /^inodot$/208 $chr($base(0131, 16, 10))
  hadd %h /^IJlig$/209 $chr($base(0132, 16, 10))
  hadd %h /^ijlig$/210 $chr($base(0133, 16, 10))
  hadd %h /^Jcirc$/211 $chr($base(0134, 16, 10))
  hadd %h /^jcirc$/212 $chr($base(0135, 16, 10))
  hadd %h /^Kcedil$/213 $chr($base(0136, 16, 10))
  hadd %h /^kcedil$/214 $chr($base(0137, 16, 10))
  hadd %h /^kgreen$/215 $chr($base(0138, 16, 10))
  hadd %h /^Lacute$/216 $chr($base(0139, 16, 10))
  hadd %h /^lacute$/217 $chr($base(013A, 16, 10))
  hadd %h /^Lcedil$/218 $chr($base(013B, 16, 10))
  hadd %h /^lcedil$/219 $chr($base(013C, 16, 10))
  hadd %h /^Lcaron$/220 $chr($base(013D, 16, 10))
  hadd %h /^lcaron$/221 $chr($base(013E, 16, 10))
  hadd %h /^Lmidot$/222 $chr($base(013F, 16, 10))
  hadd %h /^lmidot$/223 $chr($base(0140, 16, 10))
  hadd %h /^Lstrok$/224 $chr($base(0141, 16, 10))
  hadd %h /^lstrok$/225 $chr($base(0142, 16, 10))
  hadd %h /^Nacute$/226 $chr($base(0143, 16, 10))
  hadd %h /^nacute$/227 $chr($base(0144, 16, 10))
  hadd %h /^Ncedil$/228 $chr($base(0145, 16, 10))
  hadd %h /^ncedil$/229 $chr($base(0146, 16, 10))
  hadd %h /^Ncaron$/230 $chr($base(0147, 16, 10))
  hadd %h /^ncaron$/231 $chr($base(0148, 16, 10))
  hadd %h /^napos$/232 $chr($base(0149, 16, 10))
  hadd %h /^ENG$/233 $chr($base(014A, 16, 10))
  hadd %h /^eng$/234 $chr($base(014B, 16, 10))
  hadd %h /^Omacr$/235 $chr($base(014C, 16, 10))
  hadd %h /^omacr$/236 $chr($base(014D, 16, 10))
  hadd %h /^Odblac$/237 $chr($base(0150, 16, 10))
  hadd %h /^odblac$/238 $chr($base(0151, 16, 10))
  hadd %h /^OElig$/239 $chr($base(0152, 16, 10))
  hadd %h /^oelig$/240 $chr($base(0153, 16, 10))
  hadd %h /^Racute$/241 $chr($base(0154, 16, 10))
  hadd %h /^racute$/242 $chr($base(0155, 16, 10))
  hadd %h /^Rcedil$/243 $chr($base(0156, 16, 10))
  hadd %h /^rcedil$/244 $chr($base(0157, 16, 10))
  hadd %h /^Rcaron$/245 $chr($base(0158, 16, 10))
  hadd %h /^rcaron$/246 $chr($base(0159, 16, 10))
  hadd %h /^Sacute$/247 $chr($base(015A, 16, 10))
  hadd %h /^sacute$/248 $chr($base(015B, 16, 10))
  hadd %h /^Scirc$/249 $chr($base(015C, 16, 10))
  hadd %h /^scirc$/250 $chr($base(015D, 16, 10))
  hadd %h /^Scedil$/251 $chr($base(015E, 16, 10))
  hadd %h /^scedil$/252 $chr($base(015F, 16, 10))
  hadd %h /^Scaron$/253 $chr($base(0160, 16, 10))
  hadd %h /^scaron$/254 $chr($base(0161, 16, 10))
  hadd %h /^Tcedil$/255 $chr($base(0162, 16, 10))
  hadd %h /^tcedil$/256 $chr($base(0163, 16, 10))
  hadd %h /^Tcaron$/257 $chr($base(0164, 16, 10))
  hadd %h /^tcaron$/258 $chr($base(0165, 16, 10))
  hadd %h /^Tstrok$/259 $chr($base(0166, 16, 10))
  hadd %h /^tstrok$/260 $chr($base(0167, 16, 10))
  hadd %h /^Utilde$/261 $chr($base(0168, 16, 10))
  hadd %h /^utilde$/262 $chr($base(0169, 16, 10))
  hadd %h /^Umacr$/263 $chr($base(016A, 16, 10))
  hadd %h /^umacr$/264 $chr($base(016B, 16, 10))
  hadd %h /^Ubreve$/265 $chr($base(016C, 16, 10))
  hadd %h /^ubreve$/266 $chr($base(016D, 16, 10))
  hadd %h /^Uring$/267 $chr($base(016E, 16, 10))
  hadd %h /^uring$/268 $chr($base(016F, 16, 10))
  hadd %h /^Udblac$/269 $chr($base(0170, 16, 10))
  hadd %h /^udblac$/270 $chr($base(0171, 16, 10))
  hadd %h /^Uogon$/271 $chr($base(0172, 16, 10))
  hadd %h /^uogon$/272 $chr($base(0173, 16, 10))
  hadd %h /^Wcirc$/273 $chr($base(0174, 16, 10))
  hadd %h /^wcirc$/274 $chr($base(0175, 16, 10))
  hadd %h /^Ycirc$/275 $chr($base(0176, 16, 10))
  hadd %h /^ycirc$/276 $chr($base(0177, 16, 10))
  hadd %h /^Yuml$/277 $chr($base(0178, 16, 10))
  hadd %h /^Zacute$/278 $chr($base(0179, 16, 10))
  hadd %h /^zacute$/279 $chr($base(017A, 16, 10))
  hadd %h /^Zdot$/280 $chr($base(017B, 16, 10))
  hadd %h /^zdot$/281 $chr($base(017C, 16, 10))
  hadd %h /^Zcaron$/282 $chr($base(017D, 16, 10))
  hadd %h /^zcaron$/283 $chr($base(017E, 16, 10))
  hadd %h /^fnof$/284 $chr($base(0192, 16, 10))
  hadd %h /^imped$/285 $chr($base(01B5, 16, 10))
  hadd %h /^gacute$/286 $chr($base(01F5, 16, 10))
  hadd %h /^jmath$/287 $chr($base(0237, 16, 10))
  hadd %h /^circ$/288 $chr($base(02C6, 16, 10))
  hadd %h /^caron$/289 $chr($base(02C7, 16, 10))
  hadd %h /^Hacek$/290 $chr($base(02C7, 16, 10))
  hadd %h /^breve$/291 $chr($base(02D8, 16, 10))
  hadd %h /^Breve$/292 $chr($base(02D8, 16, 10))
  hadd %h /^dot$/293 $chr($base(02D9, 16, 10))
  hadd %h /^DiacriticalDot$/294 $chr($base(02D9, 16, 10))
  hadd %h /^ring$/295 $chr($base(02DA, 16, 10))
  hadd %h /^ogon$/296 $chr($base(02DB, 16, 10))
  hadd %h /^tilde$/297 $chr($base(02DC, 16, 10))
  hadd %h /^DiacriticalTilde$/298 $chr($base(02DC, 16, 10))
  hadd %h /^dblac$/299 $chr($base(02DD, 16, 10))
  hadd %h /^DiacriticalDoubleAcute$/300 $chr($base(02DD, 16, 10))
  hadd %h /^DownBreve$/301 $chr($base(0311, 16, 10))
  hadd %h /^Aacgr$/302 $chr($base(0386, 16, 10))
  hadd %h /^Eacgr$/303 $chr($base(0388, 16, 10))
  hadd %h /^EEacgr$/304 $chr($base(0389, 16, 10))
  hadd %h /^Iacgr$/305 $chr($base(038A, 16, 10))
  hadd %h /^Oacgr$/306 $chr($base(038C, 16, 10))
  hadd %h /^Uacgr$/307 $chr($base(038E, 16, 10))
  hadd %h /^OHacgr$/308 $chr($base(038F, 16, 10))
  hadd %h /^idiagr$/309 $chr($base(0390, 16, 10))
  hadd %h /^Alpha$/310 $chr($base(0391, 16, 10))
  hadd %h /^Agr$/311 $chr($base(0391, 16, 10))
  hadd %h /^Bgr$/312 $chr($base(0392, 16, 10))
  hadd %h /^Beta$/313 $chr($base(0392, 16, 10))
  hadd %h /^Gamma$/314 $chr($base(0393, 16, 10))
  hadd %h /^Ggr$/315 $chr($base(0393, 16, 10))
  hadd %h /^Delta$/316 $chr($base(0394, 16, 10))
  hadd %h /^Dgr$/317 $chr($base(0394, 16, 10))
  hadd %h /^Egr$/318 $chr($base(0395, 16, 10))
  hadd %h /^Epsilon$/319 $chr($base(0395, 16, 10))
  hadd %h /^Zgr$/320 $chr($base(0396, 16, 10))
  hadd %h /^Zeta$/321 $chr($base(0396, 16, 10))
  hadd %h /^EEgr$/322 $chr($base(0397, 16, 10))
  hadd %h /^Eta$/323 $chr($base(0397, 16, 10))
  hadd %h /^THgr$/324 $chr($base(0398, 16, 10))
  hadd %h /^Theta$/325 $chr($base(0398, 16, 10))
  hadd %h /^Igr$/326 $chr($base(0399, 16, 10))
  hadd %h /^Iota$/327 $chr($base(0399, 16, 10))
  hadd %h /^Kgr$/328 $chr($base(039A, 16, 10))
  hadd %h /^Kappa$/329 $chr($base(039A, 16, 10))
  hadd %h /^Lambda$/330 $chr($base(039B, 16, 10))
  hadd %h /^Lgr$/331 $chr($base(039B, 16, 10))
  hadd %h /^Mgr$/332 $chr($base(039C, 16, 10))
  hadd %h /^Mu$/333 $chr($base(039C, 16, 10))
  hadd %h /^Ngr$/334 $chr($base(039D, 16, 10))
  hadd %h /^Nu$/335 $chr($base(039D, 16, 10))
  hadd %h /^Xgr$/336 $chr($base(039E, 16, 10))
  hadd %h /^Xi$/337 $chr($base(039E, 16, 10))
  hadd %h /^Ogr$/338 $chr($base(039F, 16, 10))
  hadd %h /^Omicron$/339 $chr($base(039F, 16, 10))
  hadd %h /^Pgr$/340 $chr($base(03A0, 16, 10))
  hadd %h /^Pi$/341 $chr($base(03A0, 16, 10))
  hadd %h /^Rgr$/342 $chr($base(03A1, 16, 10))
  hadd %h /^Rho$/343 $chr($base(03A1, 16, 10))
  hadd %h /^Sgr$/344 $chr($base(03A3, 16, 10))
  hadd %h /^Sigma$/345 $chr($base(03A3, 16, 10))
  hadd %h /^Tgr$/346 $chr($base(03A4, 16, 10))
  hadd %h /^Tau$/347 $chr($base(03A4, 16, 10))
  hadd %h /^Ugr$/348 $chr($base(03A5, 16, 10))
  hadd %h /^Upsilon$/349 $chr($base(03A5, 16, 10))
  hadd %h /^PHgr$/350 $chr($base(03A6, 16, 10))
  hadd %h /^Phi$/351 $chr($base(03A6, 16, 10))
  hadd %h /^KHgr$/352 $chr($base(03A7, 16, 10))
  hadd %h /^Chi$/353 $chr($base(03A7, 16, 10))
  hadd %h /^PSgr$/354 $chr($base(03A8, 16, 10))
  hadd %h /^Psi$/355 $chr($base(03A8, 16, 10))
  hadd %h /^OHgr$/356 $chr($base(03A9, 16, 10))
  hadd %h /^Omega$/357 $chr($base(03A9, 16, 10))
  hadd %h /^ohm$/358 $chr($base(03A9, 16, 10))
  hadd %h /^Idigr$/359 $chr($base(03AA, 16, 10))
  hadd %h /^Udigr$/360 $chr($base(03AB, 16, 10))
  hadd %h /^aacgr$/361 $chr($base(03AC, 16, 10))
  hadd %h /^eacgr$/362 $chr($base(03AD, 16, 10))
  hadd %h /^eeacgr$/363 $chr($base(03AE, 16, 10))
  hadd %h /^iacgr$/364 $chr($base(03AF, 16, 10))
  hadd %h /^udiagr$/365 $chr($base(03B0, 16, 10))
  hadd %h /^agr$/366 $chr($base(03B1, 16, 10))
  hadd %h /^alpha$/367 $chr($base(03B1, 16, 10))
  hadd %h /^beta$/368 $chr($base(03B2, 16, 10))
  hadd %h /^bgr$/369 $chr($base(03B2, 16, 10))
  hadd %h /^gamma$/370 $chr($base(03B3, 16, 10))
  hadd %h /^ggr$/371 $chr($base(03B3, 16, 10))
  hadd %h /^delta$/372 $chr($base(03B4, 16, 10))
  hadd %h /^dgr$/373 $chr($base(03B4, 16, 10))
  hadd %h /^egr$/374 $chr($base(03B5, 16, 10))
  hadd %h /^epsi$/375 $chr($base(03B5, 16, 10))
  hadd %h /^epsilon$/376 $chr($base(03B5, 16, 10))
  hadd %h /^zeta$/377 $chr($base(03B6, 16, 10))
  hadd %h /^zgr$/378 $chr($base(03B6, 16, 10))
  hadd %h /^eegr$/379 $chr($base(03B7, 16, 10))
  hadd %h /^eta$/380 $chr($base(03B7, 16, 10))
  hadd %h /^theta$/381 $chr($base(03B8, 16, 10))
  hadd %h /^thgr$/382 $chr($base(03B8, 16, 10))
  hadd %h /^igr$/383 $chr($base(03B9, 16, 10))
  hadd %h /^iota$/384 $chr($base(03B9, 16, 10))
  hadd %h /^kappa$/385 $chr($base(03BA, 16, 10))
  hadd %h /^kgr$/386 $chr($base(03BA, 16, 10))
  hadd %h /^lambda$/387 $chr($base(03BB, 16, 10))
  hadd %h /^lgr$/388 $chr($base(03BB, 16, 10))
  hadd %h /^mgr$/389 $chr($base(03BC, 16, 10))
  hadd %h /^mu$/390 $chr($base(03BC, 16, 10))
  hadd %h /^ngr$/391 $chr($base(03BD, 16, 10))
  hadd %h /^nu$/392 $chr($base(03BD, 16, 10))
  hadd %h /^xgr$/393 $chr($base(03BE, 16, 10))
  hadd %h /^xi$/394 $chr($base(03BE, 16, 10))
  hadd %h /^omicron$/395 $chr($base(03BF, 16, 10))
  hadd %h /^ogr$/396 $chr($base(03BF, 16, 10))
  hadd %h /^pgr$/397 $chr($base(03C0, 16, 10))
  hadd %h /^pi$/398 $chr($base(03C0, 16, 10))
  hadd %h /^rgr$/399 $chr($base(03C1, 16, 10))
  hadd %h /^rho$/400 $chr($base(03C1, 16, 10))
  hadd %h /^sfgr$/401 $chr($base(03C2, 16, 10))
  hadd %h /^sigmav$/402 $chr($base(03C2, 16, 10))
  hadd %h /^varsigma$/403 $chr($base(03C2, 16, 10))
  hadd %h /^sigmaf$/404 $chr($base(03C2, 16, 10))
  hadd %h /^sgr$/405 $chr($base(03C3, 16, 10))
  hadd %h /^sigma$/406 $chr($base(03C3, 16, 10))
  hadd %h /^tau$/407 $chr($base(03C4, 16, 10))
  hadd %h /^tgr$/408 $chr($base(03C4, 16, 10))
  hadd %h /^ugr$/409 $chr($base(03C5, 16, 10))
  hadd %h /^upsi$/410 $chr($base(03C5, 16, 10))
  hadd %h /^upsilon$/411 $chr($base(03C5, 16, 10))
  hadd %h /^phi$/412 $chr($base(03C6, 16, 10))
  hadd %h /^phgr$/413 $chr($base(03C6, 16, 10))
  hadd %h /^chi$/414 $chr($base(03C7, 16, 10))
  hadd %h /^khgr$/415 $chr($base(03C7, 16, 10))
  hadd %h /^psgr$/416 $chr($base(03C8, 16, 10))
  hadd %h /^psi$/417 $chr($base(03C8, 16, 10))
  hadd %h /^ohgr$/418 $chr($base(03C9, 16, 10))
  hadd %h /^omega$/419 $chr($base(03C9, 16, 10))
  hadd %h /^idigr$/420 $chr($base(03CA, 16, 10))
  hadd %h /^udigr$/421 $chr($base(03CB, 16, 10))
  hadd %h /^oacgr$/422 $chr($base(03CC, 16, 10))
  hadd %h /^uacgr$/423 $chr($base(03CD, 16, 10))
  hadd %h /^ohacgr$/424 $chr($base(03CE, 16, 10))
  hadd %h /^thetav$/425 $chr($base(03D1, 16, 10))
  hadd %h /^vartheta$/426 $chr($base(03D1, 16, 10))
  hadd %h /^thetasym$/427 $chr($base(03D1, 16, 10))
  hadd %h /^Upsi$/428 $chr($base(03D2, 16, 10))
  hadd %h /^upsih$/429 $chr($base(03D2, 16, 10))
  hadd %h /^straightphi$/430 $chr($base(03D5, 16, 10))
  hadd %h /^phiv$/431 $chr($base(03D5, 16, 10))
  hadd %h /^varphi$/432 $chr($base(03D5, 16, 10))
  hadd %h /^piv$/433 $chr($base(03D6, 16, 10))
  hadd %h /^varpi$/434 $chr($base(03D6, 16, 10))
  hadd %h /^Gammad$/435 $chr($base(03DC, 16, 10))
  hadd %h /^gammad$/436 $chr($base(03DD, 16, 10))
  hadd %h /^digamma$/437 $chr($base(03DD, 16, 10))
  hadd %h /^kappav$/438 $chr($base(03F0, 16, 10))
  hadd %h /^varkappa$/439 $chr($base(03F0, 16, 10))
  hadd %h /^rhov$/440 $chr($base(03F1, 16, 10))
  hadd %h /^varrho$/441 $chr($base(03F1, 16, 10))
  hadd %h /^epsiv$/442 $chr($base(03F5, 16, 10))
  hadd %h /^straightepsilon$/443 $chr($base(03F5, 16, 10))
  hadd %h /^varepsilon$/444 $chr($base(03F5, 16, 10))
  hadd %h /^bepsi$/445 $chr($base(03F6, 16, 10))
  hadd %h /^backepsilon$/446 $chr($base(03F6, 16, 10))
  hadd %h /^IOcy$/447 $chr($base(0401, 16, 10))
  hadd %h /^DJcy$/448 $chr($base(0402, 16, 10))
  hadd %h /^GJcy$/449 $chr($base(0403, 16, 10))
  hadd %h /^Jukcy$/450 $chr($base(0404, 16, 10))
  hadd %h /^DScy$/451 $chr($base(0405, 16, 10))
  hadd %h /^Iukcy$/452 $chr($base(0406, 16, 10))
  hadd %h /^YIcy$/453 $chr($base(0407, 16, 10))
  hadd %h /^Jsercy$/454 $chr($base(0408, 16, 10))
  hadd %h /^LJcy$/455 $chr($base(0409, 16, 10))
  hadd %h /^NJcy$/456 $chr($base(040A, 16, 10))
  hadd %h /^TSHcy$/457 $chr($base(040B, 16, 10))
  hadd %h /^KJcy$/458 $chr($base(040C, 16, 10))
  hadd %h /^Ubrcy$/459 $chr($base(040E, 16, 10))
  hadd %h /^DZcy$/460 $chr($base(040F, 16, 10))
  hadd %h /^Acy$/461 $chr($base(0410, 16, 10))
  hadd %h /^Bcy$/462 $chr($base(0411, 16, 10))
  hadd %h /^Vcy$/463 $chr($base(0412, 16, 10))
  hadd %h /^Gcy$/464 $chr($base(0413, 16, 10))
  hadd %h /^Dcy$/465 $chr($base(0414, 16, 10))
  hadd %h /^IEcy$/466 $chr($base(0415, 16, 10))
  hadd %h /^ZHcy$/467 $chr($base(0416, 16, 10))
  hadd %h /^Zcy$/468 $chr($base(0417, 16, 10))
  hadd %h /^Icy$/469 $chr($base(0418, 16, 10))
  hadd %h /^Jcy$/470 $chr($base(0419, 16, 10))
  hadd %h /^Kcy$/471 $chr($base(041A, 16, 10))
  hadd %h /^Lcy$/472 $chr($base(041B, 16, 10))
  hadd %h /^Mcy$/473 $chr($base(041C, 16, 10))
  hadd %h /^Ncy$/474 $chr($base(041D, 16, 10))
  hadd %h /^Ocy$/475 $chr($base(041E, 16, 10))
  hadd %h /^Pcy$/476 $chr($base(041F, 16, 10))
  hadd %h /^Rcy$/477 $chr($base(0420, 16, 10))
  hadd %h /^Scy$/478 $chr($base(0421, 16, 10))
  hadd %h /^Tcy$/479 $chr($base(0422, 16, 10))
  hadd %h /^Ucy$/480 $chr($base(0423, 16, 10))
  hadd %h /^Fcy$/481 $chr($base(0424, 16, 10))
  hadd %h /^KHcy$/482 $chr($base(0425, 16, 10))
  hadd %h /^TScy$/483 $chr($base(0426, 16, 10))
  hadd %h /^CHcy$/484 $chr($base(0427, 16, 10))
  hadd %h /^SHcy$/485 $chr($base(0428, 16, 10))
  hadd %h /^SHCHcy$/486 $chr($base(0429, 16, 10))
  hadd %h /^HARDcy$/487 $chr($base(042A, 16, 10))
  hadd %h /^Ycy$/488 $chr($base(042B, 16, 10))
  hadd %h /^SOFTcy$/489 $chr($base(042C, 16, 10))
  hadd %h /^Ecy$/490 $chr($base(042D, 16, 10))
  hadd %h /^YUcy$/491 $chr($base(042E, 16, 10))
  hadd %h /^YAcy$/492 $chr($base(042F, 16, 10))
  hadd %h /^acy$/493 $chr($base(0430, 16, 10))
  hadd %h /^bcy$/494 $chr($base(0431, 16, 10))
  hadd %h /^vcy$/495 $chr($base(0432, 16, 10))
  hadd %h /^gcy$/496 $chr($base(0433, 16, 10))
  hadd %h /^dcy$/497 $chr($base(0434, 16, 10))
  hadd %h /^iecy$/498 $chr($base(0435, 16, 10))
  hadd %h /^zhcy$/499 $chr($base(0436, 16, 10))
  hadd %h /^zcy$/500 $chr($base(0437, 16, 10))
  hadd %h /^icy$/501 $chr($base(0438, 16, 10))
  hadd %h /^jcy$/502 $chr($base(0439, 16, 10))
  hadd %h /^kcy$/503 $chr($base(043A, 16, 10))
  hadd %h /^lcy$/504 $chr($base(043B, 16, 10))
  hadd %h /^mcy$/505 $chr($base(043C, 16, 10))
  hadd %h /^ncy$/506 $chr($base(043D, 16, 10))
  hadd %h /^ocy$/507 $chr($base(043E, 16, 10))
  hadd %h /^pcy$/508 $chr($base(043F, 16, 10))
  hadd %h /^rcy$/509 $chr($base(0440, 16, 10))
  hadd %h /^scy$/510 $chr($base(0441, 16, 10))
  hadd %h /^tcy$/511 $chr($base(0442, 16, 10))
  hadd %h /^ucy$/512 $chr($base(0443, 16, 10))
  hadd %h /^fcy$/513 $chr($base(0444, 16, 10))
  hadd %h /^khcy$/514 $chr($base(0445, 16, 10))
  hadd %h /^tscy$/515 $chr($base(0446, 16, 10))
  hadd %h /^chcy$/516 $chr($base(0447, 16, 10))
  hadd %h /^shcy$/517 $chr($base(0448, 16, 10))
  hadd %h /^shchcy$/518 $chr($base(0449, 16, 10))
  hadd %h /^hardcy$/519 $chr($base(044A, 16, 10))
  hadd %h /^ycy$/520 $chr($base(044B, 16, 10))
  hadd %h /^softcy$/521 $chr($base(044C, 16, 10))
  hadd %h /^ecy$/522 $chr($base(044D, 16, 10))
  hadd %h /^yucy$/523 $chr($base(044E, 16, 10))
  hadd %h /^yacy$/524 $chr($base(044F, 16, 10))
  hadd %h /^iocy$/525 $chr($base(0451, 16, 10))
  hadd %h /^djcy$/526 $chr($base(0452, 16, 10))
  hadd %h /^gjcy$/527 $chr($base(0453, 16, 10))
  hadd %h /^jukcy$/528 $chr($base(0454, 16, 10))
  hadd %h /^dscy$/529 $chr($base(0455, 16, 10))
  hadd %h /^iukcy$/530 $chr($base(0456, 16, 10))
  hadd %h /^yicy$/531 $chr($base(0457, 16, 10))
  hadd %h /^jsercy$/532 $chr($base(0458, 16, 10))
  hadd %h /^ljcy$/533 $chr($base(0459, 16, 10))
  hadd %h /^njcy$/534 $chr($base(045A, 16, 10))
  hadd %h /^tshcy$/535 $chr($base(045B, 16, 10))
  hadd %h /^kjcy$/536 $chr($base(045C, 16, 10))
  hadd %h /^ubrcy$/537 $chr($base(045E, 16, 10))
  hadd %h /^dzcy$/538 $chr($base(045F, 16, 10))
  hadd %h /^ensp$/539 $chr($base(2002, 16, 10))
  hadd %h /^emsp$/540 $chr($base(2003, 16, 10))
  hadd %h /^emsp13$/541 $chr($base(2004, 16, 10))
  hadd %h /^emsp14$/542 $chr($base(2005, 16, 10))
  hadd %h /^numsp$/543 $chr($base(2007, 16, 10))
  hadd %h /^puncsp$/544 $chr($base(2008, 16, 10))
  hadd %h /^thinsp$/545 $chr($base(2009, 16, 10))
  hadd %h /^ThinSpace$/546 $chr($base(2009, 16, 10))
  hadd %h /^hairsp$/547 $chr($base(200A, 16, 10))
  hadd %h /^VeryThinSpace$/548 $chr($base(200A, 16, 10))
  hadd %h /^ZeroWidthSpace$/549 $chr($base(200B, 16, 10))
  hadd %h /^NegativeVeryThinSpace$/550 $chr($base(200B, 16, 10))
  hadd %h /^NegativeThinSpace$/551 $chr($base(200B, 16, 10))
  hadd %h /^NegativeMediumSpace$/552 $chr($base(200B, 16, 10))
  hadd %h /^NegativeThickSpace$/553 $chr($base(200B, 16, 10))
  hadd %h /^zwnj$/554 $chr($base(200C, 16, 10))
  hadd %h /^zwj$/555 $chr($base(200D, 16, 10))
  hadd %h /^lrm$/556 $chr($base(200E, 16, 10))
  hadd %h /^rlm$/557 $chr($base(200F, 16, 10))
  hadd %h /^hyphen$/558 $chr($base(2010, 16, 10))
  hadd %h /^dash$/559 $chr($base(2010, 16, 10))
  hadd %h /^ndash$/560 $chr($base(2013, 16, 10))
  hadd %h /^mdash$/561 $chr($base(2014, 16, 10))
  hadd %h /^horbar$/562 $chr($base(2015, 16, 10))
  hadd %h /^Verbar$/563 $chr($base(2016, 16, 10))
  hadd %h /^Vert$/564 $chr($base(2016, 16, 10))
  hadd %h /^lsquo$/565 $chr($base(2018, 16, 10))
  hadd %h /^OpenCurlyQuote$/566 $chr($base(2018, 16, 10))
  hadd %h /^rsquo$/567 $chr($base(2019, 16, 10))
  hadd %h /^rsquor$/568 $chr($base(2019, 16, 10))
  hadd %h /^CloseCurlyQuote$/569 $chr($base(2019, 16, 10))
  hadd %h /^lsquor$/570 $chr($base(201A, 16, 10))
  hadd %h /^sbquo$/571 $chr($base(201A, 16, 10))
  hadd %h /^ldquo$/572 $chr($base(201C, 16, 10))
  hadd %h /^OpenCurlyDoubleQuote$/573 $chr($base(201C, 16, 10))
  hadd %h /^rdquo$/574 $chr($base(201D, 16, 10))
  hadd %h /^rdquor$/575 $chr($base(201D, 16, 10))
  hadd %h /^CloseCurlyDoubleQuote$/576 $chr($base(201D, 16, 10))
  hadd %h /^ldquor$/577 $chr($base(201E, 16, 10))
  hadd %h /^bdquo$/578 $chr($base(201E, 16, 10))
  hadd %h /^dagger$/579 $chr($base(2020, 16, 10))
  hadd %h /^Dagger$/580 $chr($base(2021, 16, 10))
  hadd %h /^ddagger$/581 $chr($base(2021, 16, 10))
  hadd %h /^bull$/582 $chr($base(2022, 16, 10))
  hadd %h /^bullet$/583 $chr($base(2022, 16, 10))
  hadd %h /^nldr$/584 $chr($base(2025, 16, 10))
  hadd %h /^hellip$/585 $chr($base(2026, 16, 10))
  hadd %h /^mldr$/586 $chr($base(2026, 16, 10))
  hadd %h /^permil$/587 $chr($base(2030, 16, 10))
  hadd %h /^pertenk$/588 $chr($base(2031, 16, 10))
  hadd %h /^prime$/589 $chr($base(2032, 16, 10))
  hadd %h /^Prime$/590 $chr($base(2033, 16, 10))
  hadd %h /^tprime$/591 $chr($base(2034, 16, 10))
  hadd %h /^bprime$/592 $chr($base(2035, 16, 10))
  hadd %h /^backprime$/593 $chr($base(2035, 16, 10))
  hadd %h /^lsaquo$/594 $chr($base(2039, 16, 10))
  hadd %h /^rsaquo$/595 $chr($base(203A, 16, 10))
  hadd %h /^oline$/596 $chr($base(203E, 16, 10))
  hadd %h /^OverBar$/597 $chr($base(203E, 16, 10))
  hadd %h /^caret$/598 $chr($base(2041, 16, 10))
  hadd %h /^hybull$/599 $chr($base(2043, 16, 10))
  hadd %h /^frasl$/600 $chr($base(2044, 16, 10))
  hadd %h /^bsemi$/601 $chr($base(204F, 16, 10))
  hadd %h /^qprime$/602 $chr($base(2057, 16, 10))
  hadd %h /^MediumSpace$/603 $chr($base(205F, 16, 10))
  hadd %h /^ThickSpace$/604 $chr($base(205F, 16, 10)) $+ $chr($base(200A, 16, 10))
  hadd %h /^NoBreak$/605 $chr($base(2060, 16, 10))
  hadd %h /^ApplyFunction$/606 $chr($base(2061, 16, 10))
  hadd %h /^af$/607 $chr($base(2061, 16, 10))
  hadd %h /^InvisibleTimes$/608 $chr($base(2062, 16, 10))
  hadd %h /^it$/609 $chr($base(2062, 16, 10))
  hadd %h /^InvisibleComma$/610 $chr($base(2063, 16, 10))
  hadd %h /^ic$/611 $chr($base(2063, 16, 10))
  hadd %h /^euro$/612 $chr($base(20AC, 16, 10))
  hadd %h /^tdot$/613 $chr($base(20DB, 16, 10))
  hadd %h /^TripleDot$/614 $chr($base(20DB, 16, 10))
  hadd %h /^DotDot$/615 $chr($base(20DC, 16, 10))
  hadd %h /^Copf$/616 $chr($base(2102, 16, 10))
  hadd %h /^complexes$/617 $chr($base(2102, 16, 10))
  hadd %h /^incare$/618 $chr($base(2105, 16, 10))
  hadd %h /^gscr$/619 $chr($base(210A, 16, 10))
  hadd %h /^hamilt$/620 $chr($base(210B, 16, 10))
  hadd %h /^HilbertSpace$/621 $chr($base(210B, 16, 10))
  hadd %h /^Hscr$/622 $chr($base(210B, 16, 10))
  hadd %h /^Hfr$/623 $chr($base(210C, 16, 10))
  hadd %h /^Poincareplane$/624 $chr($base(210C, 16, 10))
  hadd %h /^quaternions$/625 $chr($base(210D, 16, 10))
  hadd %h /^Hopf$/626 $chr($base(210D, 16, 10))
  hadd %h /^planckh$/627 $chr($base(210E, 16, 10))
  hadd %h /^planck$/628 $chr($base(210F, 16, 10))
  hadd %h /^hbar$/629 $chr($base(210F, 16, 10))
  hadd %h /^plankv$/630 $chr($base(210F, 16, 10))
  hadd %h /^hslash$/631 $chr($base(210F, 16, 10))
  hadd %h /^Iscr$/632 $chr($base(2110, 16, 10))
  hadd %h /^imagline$/633 $chr($base(2110, 16, 10))
  hadd %h /^image$/634 $chr($base(2111, 16, 10))
  hadd %h /^Im$/635 $chr($base(2111, 16, 10))
  hadd %h /^imagpart$/636 $chr($base(2111, 16, 10))
  hadd %h /^Ifr$/637 $chr($base(2111, 16, 10))
  hadd %h /^Lscr$/638 $chr($base(2112, 16, 10))
  hadd %h /^lagran$/639 $chr($base(2112, 16, 10))
  hadd %h /^Laplacetrf$/640 $chr($base(2112, 16, 10))
  hadd %h /^ell$/641 $chr($base(2113, 16, 10))
  hadd %h /^Nopf$/642 $chr($base(2115, 16, 10))
  hadd %h /^naturals$/643 $chr($base(2115, 16, 10))
  hadd %h /^numero$/644 $chr($base(2116, 16, 10))
  hadd %h /^copysr$/645 $chr($base(2117, 16, 10))
  hadd %h /^weierp$/646 $chr($base(2118, 16, 10))
  hadd %h /^wp$/647 $chr($base(2118, 16, 10))
  hadd %h /^Popf$/648 $chr($base(2119, 16, 10))
  hadd %h /^primes$/649 $chr($base(2119, 16, 10))
  hadd %h /^rationals$/650 $chr($base(211A, 16, 10))
  hadd %h /^Qopf$/651 $chr($base(211A, 16, 10))
  hadd %h /^Rscr$/652 $chr($base(211B, 16, 10))
  hadd %h /^realine$/653 $chr($base(211B, 16, 10))
  hadd %h /^real$/654 $chr($base(211C, 16, 10))
  hadd %h /^Re$/655 $chr($base(211C, 16, 10))
  hadd %h /^realpart$/656 $chr($base(211C, 16, 10))
  hadd %h /^Rfr$/657 $chr($base(211C, 16, 10))
  hadd %h /^reals$/658 $chr($base(211D, 16, 10))
  hadd %h /^Ropf$/659 $chr($base(211D, 16, 10))
  hadd %h /^rx$/660 $chr($base(211E, 16, 10))
  hadd %h /^trade$/661 $chr($base(2122, 16, 10))
  hadd %h /^TRADE$/662 $chr($base(2122, 16, 10))
  hadd %h /^integers$/663 $chr($base(2124, 16, 10))
  hadd %h /^Zopf$/664 $chr($base(2124, 16, 10))
  hadd %h /^mho$/665 $chr($base(2127, 16, 10))
  hadd %h /^Zfr$/666 $chr($base(2128, 16, 10))
  hadd %h /^zeetrf$/667 $chr($base(2128, 16, 10))
  hadd %h /^iiota$/668 $chr($base(2129, 16, 10))
  hadd %h /^bernou$/669 $chr($base(212C, 16, 10))
  hadd %h /^Bernoullis$/670 $chr($base(212C, 16, 10))
  hadd %h /^Bscr$/671 $chr($base(212C, 16, 10))
  hadd %h /^Cfr$/672 $chr($base(212D, 16, 10))
  hadd %h /^Cayleys$/673 $chr($base(212D, 16, 10))
  hadd %h /^escr$/674 $chr($base(212F, 16, 10))
  hadd %h /^Escr$/675 $chr($base(2130, 16, 10))
  hadd %h /^expectation$/676 $chr($base(2130, 16, 10))
  hadd %h /^Fscr$/677 $chr($base(2131, 16, 10))
  hadd %h /^Fouriertrf$/678 $chr($base(2131, 16, 10))
  hadd %h /^phmmat$/679 $chr($base(2133, 16, 10))
  hadd %h /^Mellintrf$/680 $chr($base(2133, 16, 10))
  hadd %h /^Mscr$/681 $chr($base(2133, 16, 10))
  hadd %h /^order$/682 $chr($base(2134, 16, 10))
  hadd %h /^orderof$/683 $chr($base(2134, 16, 10))
  hadd %h /^oscr$/684 $chr($base(2134, 16, 10))
  hadd %h /^alefsym$/685 $chr($base(2135, 16, 10))
  hadd %h /^aleph$/686 $chr($base(2135, 16, 10))
  hadd %h /^beth$/687 $chr($base(2136, 16, 10))
  hadd %h /^gimel$/688 $chr($base(2137, 16, 10))
  hadd %h /^daleth$/689 $chr($base(2138, 16, 10))
  hadd %h /^CapitalDifferentialD$/690 $chr($base(2145, 16, 10))
  hadd %h /^DD$/691 $chr($base(2145, 16, 10))
  hadd %h /^DifferentialD$/692 $chr($base(2146, 16, 10))
  hadd %h /^dd$/693 $chr($base(2146, 16, 10))
  hadd %h /^ExponentialE$/694 $chr($base(2147, 16, 10))
  hadd %h /^exponentiale$/695 $chr($base(2147, 16, 10))
  hadd %h /^ee$/696 $chr($base(2147, 16, 10))
  hadd %h /^ImaginaryI$/697 $chr($base(2148, 16, 10))
  hadd %h /^ii$/698 $chr($base(2148, 16, 10))
  hadd %h /^frac13$/699 $chr($base(2153, 16, 10))
  hadd %h /^frac23$/700 $chr($base(2154, 16, 10))
  hadd %h /^frac15$/701 $chr($base(2155, 16, 10))
  hadd %h /^frac25$/702 $chr($base(2156, 16, 10))
  hadd %h /^frac35$/703 $chr($base(2157, 16, 10))
  hadd %h /^frac45$/704 $chr($base(2158, 16, 10))
  hadd %h /^frac16$/705 $chr($base(2159, 16, 10))
  hadd %h /^frac56$/706 $chr($base(215A, 16, 10))
  hadd %h /^frac18$/707 $chr($base(215B, 16, 10))
  hadd %h /^frac38$/708 $chr($base(215C, 16, 10))
  hadd %h /^frac58$/709 $chr($base(215D, 16, 10))
  hadd %h /^frac78$/710 $chr($base(215E, 16, 10))
  hadd %h /^larr$/711 $chr($base(2190, 16, 10))
  hadd %h /^leftarrow$/712 $chr($base(2190, 16, 10))
  hadd %h /^LeftArrow$/713 $chr($base(2190, 16, 10))
  hadd %h /^slarr$/714 $chr($base(2190, 16, 10))
  hadd %h /^ShortLeftArrow$/715 $chr($base(2190, 16, 10))
  hadd %h /^uarr$/716 $chr($base(2191, 16, 10))
  hadd %h /^uparrow$/717 $chr($base(2191, 16, 10))
  hadd %h /^UpArrow$/718 $chr($base(2191, 16, 10))
  hadd %h /^ShortUpArrow$/719 $chr($base(2191, 16, 10))
  hadd %h /^rarr$/720 $chr($base(2192, 16, 10))
  hadd %h /^rightarrow$/721 $chr($base(2192, 16, 10))
  hadd %h /^RightArrow$/722 $chr($base(2192, 16, 10))
  hadd %h /^srarr$/723 $chr($base(2192, 16, 10))
  hadd %h /^ShortRightArrow$/724 $chr($base(2192, 16, 10))
  hadd %h /^darr$/725 $chr($base(2193, 16, 10))
  hadd %h /^downarrow$/726 $chr($base(2193, 16, 10))
  hadd %h /^DownArrow$/727 $chr($base(2193, 16, 10))
  hadd %h /^ShortDownArrow$/728 $chr($base(2193, 16, 10))
  hadd %h /^harr$/729 $chr($base(2194, 16, 10))
  hadd %h /^leftrightarrow$/730 $chr($base(2194, 16, 10))
  hadd %h /^LeftRightArrow$/731 $chr($base(2194, 16, 10))
  hadd %h /^varr$/732 $chr($base(2195, 16, 10))
  hadd %h /^updownarrow$/733 $chr($base(2195, 16, 10))
  hadd %h /^UpDownArrow$/734 $chr($base(2195, 16, 10))
  hadd %h /^nwarr$/735 $chr($base(2196, 16, 10))
  hadd %h /^UpperLeftArrow$/736 $chr($base(2196, 16, 10))
  hadd %h /^nwarrow$/737 $chr($base(2196, 16, 10))
  hadd %h /^nearr$/738 $chr($base(2197, 16, 10))
  hadd %h /^UpperRightArrow$/739 $chr($base(2197, 16, 10))
  hadd %h /^nearrow$/740 $chr($base(2197, 16, 10))
  hadd %h /^searr$/741 $chr($base(2198, 16, 10))
  hadd %h /^searrow$/742 $chr($base(2198, 16, 10))
  hadd %h /^LowerRightArrow$/743 $chr($base(2198, 16, 10))
  hadd %h /^swarr$/744 $chr($base(2199, 16, 10))
  hadd %h /^swarrow$/745 $chr($base(2199, 16, 10))
  hadd %h /^LowerLeftArrow$/746 $chr($base(2199, 16, 10))
  hadd %h /^nlarr$/747 $chr($base(219A, 16, 10))
  hadd %h /^nleftarrow$/748 $chr($base(219A, 16, 10))
  hadd %h /^nrarr$/749 $chr($base(219B, 16, 10))
  hadd %h /^nrightarrow$/750 $chr($base(219B, 16, 10))
  hadd %h /^rarrw$/751 $chr($base(219D, 16, 10))
  hadd %h /^rightsquigarrow$/752 $chr($base(219D, 16, 10))
  hadd %h /^nrarrw$/753 $chr($base(219D, 16, 10)) $+ $chr($base(0338, 16, 10))
  hadd %h /^Larr$/754 $chr($base(219E, 16, 10))
  hadd %h /^twoheadleftarrow$/755 $chr($base(219E, 16, 10))
  hadd %h /^Uarr$/756 $chr($base(219F, 16, 10))
  hadd %h /^Rarr$/757 $chr($base(21A0, 16, 10))
  hadd %h /^twoheadrightarrow$/758 $chr($base(21A0, 16, 10))
  hadd %h /^Darr$/759 $chr($base(21A1, 16, 10))
  hadd %h /^larrtl$/760 $chr($base(21A2, 16, 10))
  hadd %h /^leftarrowtail$/761 $chr($base(21A2, 16, 10))
  hadd %h /^rarrtl$/762 $chr($base(21A3, 16, 10))
  hadd %h /^rightarrowtail$/763 $chr($base(21A3, 16, 10))
  hadd %h /^LeftTeeArrow$/764 $chr($base(21A4, 16, 10))
  hadd %h /^mapstoleft$/765 $chr($base(21A4, 16, 10))
  hadd %h /^UpTeeArrow$/766 $chr($base(21A5, 16, 10))
  hadd %h /^mapstoup$/767 $chr($base(21A5, 16, 10))
  hadd %h /^map$/768 $chr($base(21A6, 16, 10))
  hadd %h /^RightTeeArrow$/769 $chr($base(21A6, 16, 10))
  hadd %h /^mapsto$/770 $chr($base(21A6, 16, 10))
  hadd %h /^DownTeeArrow$/771 $chr($base(21A7, 16, 10))
  hadd %h /^mapstodown$/772 $chr($base(21A7, 16, 10))
  hadd %h /^larrhk$/773 $chr($base(21A9, 16, 10))
  hadd %h /^hookleftarrow$/774 $chr($base(21A9, 16, 10))
  hadd %h /^rarrhk$/775 $chr($base(21AA, 16, 10))
  hadd %h /^hookrightarrow$/776 $chr($base(21AA, 16, 10))
  hadd %h /^larrlp$/777 $chr($base(21AB, 16, 10))
  hadd %h /^looparrowleft$/778 $chr($base(21AB, 16, 10))
  hadd %h /^rarrlp$/779 $chr($base(21AC, 16, 10))
  hadd %h /^looparrowright$/780 $chr($base(21AC, 16, 10))
  hadd %h /^harrw$/781 $chr($base(21AD, 16, 10))
  hadd %h /^leftrightsquigarrow$/782 $chr($base(21AD, 16, 10))
  hadd %h /^nharr$/783 $chr($base(21AE, 16, 10))
  hadd %h /^nleftrightarrow$/784 $chr($base(21AE, 16, 10))
  hadd %h /^lsh$/785 $chr($base(21B0, 16, 10))
  hadd %h /^Lsh$/786 $chr($base(21B0, 16, 10))
  hadd %h /^rsh$/787 $chr($base(21B1, 16, 10))
  hadd %h /^Rsh$/788 $chr($base(21B1, 16, 10))
  hadd %h /^ldsh$/789 $chr($base(21B2, 16, 10))
  hadd %h /^rdsh$/790 $chr($base(21B3, 16, 10))
  hadd %h /^crarr$/791 $chr($base(21B5, 16, 10))
  hadd %h /^cularr$/792 $chr($base(21B6, 16, 10))
  hadd %h /^curvearrowleft$/793 $chr($base(21B6, 16, 10))
  hadd %h /^curarr$/794 $chr($base(21B7, 16, 10))
  hadd %h /^curvearrowright$/795 $chr($base(21B7, 16, 10))
  hadd %h /^olarr$/796 $chr($base(21BA, 16, 10))
  hadd %h /^circlearrowleft$/797 $chr($base(21BA, 16, 10))
  hadd %h /^orarr$/798 $chr($base(21BB, 16, 10))
  hadd %h /^circlearrowright$/799 $chr($base(21BB, 16, 10))
  hadd %h /^lharu$/800 $chr($base(21BC, 16, 10))
  hadd %h /^LeftVector$/801 $chr($base(21BC, 16, 10))
  hadd %h /^leftharpoonup$/802 $chr($base(21BC, 16, 10))
  hadd %h /^lhard$/803 $chr($base(21BD, 16, 10))
  hadd %h /^leftharpoondown$/804 $chr($base(21BD, 16, 10))
  hadd %h /^DownLeftVector$/805 $chr($base(21BD, 16, 10))
  hadd %h /^uharr$/806 $chr($base(21BE, 16, 10))
  hadd %h /^upharpoonright$/807 $chr($base(21BE, 16, 10))
  hadd %h /^RightUpVector$/808 $chr($base(21BE, 16, 10))
  hadd %h /^uharl$/809 $chr($base(21BF, 16, 10))
  hadd %h /^upharpoonleft$/810 $chr($base(21BF, 16, 10))
  hadd %h /^LeftUpVector$/811 $chr($base(21BF, 16, 10))
  hadd %h /^rharu$/812 $chr($base(21C0, 16, 10))
  hadd %h /^RightVector$/813 $chr($base(21C0, 16, 10))
  hadd %h /^rightharpoonup$/814 $chr($base(21C0, 16, 10))
  hadd %h /^rhard$/815 $chr($base(21C1, 16, 10))
  hadd %h /^rightharpoondown$/816 $chr($base(21C1, 16, 10))
  hadd %h /^DownRightVector$/817 $chr($base(21C1, 16, 10))
  hadd %h /^dharr$/818 $chr($base(21C2, 16, 10))
  hadd %h /^RightDownVector$/819 $chr($base(21C2, 16, 10))
  hadd %h /^downharpoonright$/820 $chr($base(21C2, 16, 10))
  hadd %h /^dharl$/821 $chr($base(21C3, 16, 10))
  hadd %h /^LeftDownVector$/822 $chr($base(21C3, 16, 10))
  hadd %h /^downharpoonleft$/823 $chr($base(21C3, 16, 10))
  hadd %h /^rlarr$/824 $chr($base(21C4, 16, 10))
  hadd %h /^rightleftarrows$/825 $chr($base(21C4, 16, 10))
  hadd %h /^RightArrowLeftArrow$/826 $chr($base(21C4, 16, 10))
  hadd %h /^udarr$/827 $chr($base(21C5, 16, 10))
  hadd %h /^UpArrowDownArrow$/828 $chr($base(21C5, 16, 10))
  hadd %h /^lrarr$/829 $chr($base(21C6, 16, 10))
  hadd %h /^leftrightarrows$/830 $chr($base(21C6, 16, 10))
  hadd %h /^LeftArrowRightArrow$/831 $chr($base(21C6, 16, 10))
  hadd %h /^llarr$/832 $chr($base(21C7, 16, 10))
  hadd %h /^leftleftarrows$/833 $chr($base(21C7, 16, 10))
  hadd %h /^uuarr$/834 $chr($base(21C8, 16, 10))
  hadd %h /^upuparrows$/835 $chr($base(21C8, 16, 10))
  hadd %h /^rrarr$/836 $chr($base(21C9, 16, 10))
  hadd %h /^rightrightarrows$/837 $chr($base(21C9, 16, 10))
  hadd %h /^ddarr$/838 $chr($base(21CA, 16, 10))
  hadd %h /^downdownarrows$/839 $chr($base(21CA, 16, 10))
  hadd %h /^lrhar$/840 $chr($base(21CB, 16, 10))
  hadd %h /^ReverseEquilibrium$/841 $chr($base(21CB, 16, 10))
  hadd %h /^leftrightharpoons$/842 $chr($base(21CB, 16, 10))
  hadd %h /^rlhar$/843 $chr($base(21CC, 16, 10))
  hadd %h /^rightleftharpoons$/844 $chr($base(21CC, 16, 10))
  hadd %h /^Equilibrium$/845 $chr($base(21CC, 16, 10))
  hadd %h /^nlArr$/846 $chr($base(21CD, 16, 10))
  hadd %h /^nLeftarrow$/847 $chr($base(21CD, 16, 10))
  hadd %h /^nhArr$/848 $chr($base(21CE, 16, 10))
  hadd %h /^nLeftrightarrow$/849 $chr($base(21CE, 16, 10))
  hadd %h /^nrArr$/850 $chr($base(21CF, 16, 10))
  hadd %h /^nRightarrow$/851 $chr($base(21CF, 16, 10))
  hadd %h /^lArr$/852 $chr($base(21D0, 16, 10))
  hadd %h /^Leftarrow$/853 $chr($base(21D0, 16, 10))
  hadd %h /^DoubleLeftArrow$/854 $chr($base(21D0, 16, 10))
  hadd %h /^uArr$/855 $chr($base(21D1, 16, 10))
  hadd %h /^Uparrow$/856 $chr($base(21D1, 16, 10))
  hadd %h /^DoubleUpArrow$/857 $chr($base(21D1, 16, 10))
  hadd %h /^rArr$/858 $chr($base(21D2, 16, 10))
  hadd %h /^Rightarrow$/859 $chr($base(21D2, 16, 10))
  hadd %h /^Implies$/860 $chr($base(21D2, 16, 10))
  hadd %h /^DoubleRightArrow$/861 $chr($base(21D2, 16, 10))
  hadd %h /^dArr$/862 $chr($base(21D3, 16, 10))
  hadd %h /^Downarrow$/863 $chr($base(21D3, 16, 10))
  hadd %h /^DoubleDownArrow$/864 $chr($base(21D3, 16, 10))
  hadd %h /^hArr$/865 $chr($base(21D4, 16, 10))
  hadd %h /^Leftrightarrow$/866 $chr($base(21D4, 16, 10))
  hadd %h /^DoubleLeftRightArrow$/867 $chr($base(21D4, 16, 10))
  hadd %h /^iff$/868 $chr($base(21D4, 16, 10))
  hadd %h /^vArr$/869 $chr($base(21D5, 16, 10))
  hadd %h /^Updownarrow$/870 $chr($base(21D5, 16, 10))
  hadd %h /^DoubleUpDownArrow$/871 $chr($base(21D5, 16, 10))
  hadd %h /^nwArr$/872 $chr($base(21D6, 16, 10))
  hadd %h /^neArr$/873 $chr($base(21D7, 16, 10))
  hadd %h /^seArr$/874 $chr($base(21D8, 16, 10))
  hadd %h /^swArr$/875 $chr($base(21D9, 16, 10))
  hadd %h /^lAarr$/876 $chr($base(21DA, 16, 10))
  hadd %h /^Lleftarrow$/877 $chr($base(21DA, 16, 10))
  hadd %h /^rAarr$/878 $chr($base(21DB, 16, 10))
  hadd %h /^Rrightarrow$/879 $chr($base(21DB, 16, 10))
  hadd %h /^zigrarr$/880 $chr($base(21DD, 16, 10))
  hadd %h /^larrb$/881 $chr($base(21E4, 16, 10))
  hadd %h /^LeftArrowBar$/882 $chr($base(21E4, 16, 10))
  hadd %h /^rarrb$/883 $chr($base(21E5, 16, 10))
  hadd %h /^RightArrowBar$/884 $chr($base(21E5, 16, 10))
  hadd %h /^duarr$/885 $chr($base(21F5, 16, 10))
  hadd %h /^DownArrowUpArrow$/886 $chr($base(21F5, 16, 10))
  hadd %h /^loarr$/887 $chr($base(21FD, 16, 10))
  hadd %h /^roarr$/888 $chr($base(21FE, 16, 10))
  hadd %h /^hoarr$/889 $chr($base(21FF, 16, 10))
  hadd %h /^forall$/890 $chr($base(2200, 16, 10))
  hadd %h /^ForAll$/891 $chr($base(2200, 16, 10))
  hadd %h /^comp$/892 $chr($base(2201, 16, 10))
  hadd %h /^complement$/893 $chr($base(2201, 16, 10))
  hadd %h /^part$/894 $chr($base(2202, 16, 10))
  hadd %h /^PartialD$/895 $chr($base(2202, 16, 10))
  hadd %h /^npart$/896 $chr($base(2202, 16, 10)) $+ $chr($base(0338, 16, 10))
  hadd %h /^exist$/897 $chr($base(2203, 16, 10))
  hadd %h /^Exists$/898 $chr($base(2203, 16, 10))
  hadd %h /^nexist$/899 $chr($base(2204, 16, 10))
  hadd %h /^NotExists$/900 $chr($base(2204, 16, 10))
  hadd %h /^nexists$/901 $chr($base(2204, 16, 10))
  hadd %h /^empty$/902 $chr($base(2205, 16, 10))
  hadd %h /^emptyset$/903 $chr($base(2205, 16, 10))
  hadd %h /^emptyv$/904 $chr($base(2205, 16, 10))
  hadd %h /^varnothing$/905 $chr($base(2205, 16, 10))
  hadd %h /^nabla$/906 $chr($base(2207, 16, 10))
  hadd %h /^Del$/907 $chr($base(2207, 16, 10))
  hadd %h /^isin$/908 $chr($base(2208, 16, 10))
  hadd %h /^isinv$/909 $chr($base(2208, 16, 10))
  hadd %h /^Element$/910 $chr($base(2208, 16, 10))
  hadd %h /^in$/911 $chr($base(2208, 16, 10))
  hadd %h /^notin$/912 $chr($base(2209, 16, 10))
  hadd %h /^NotElement$/913 $chr($base(2209, 16, 10))
  hadd %h /^notinva$/914 $chr($base(2209, 16, 10))
  hadd %h /^niv$/915 $chr($base(220B, 16, 10))
  hadd %h /^ReverseElement$/916 $chr($base(220B, 16, 10))
  hadd %h /^ni$/917 $chr($base(220B, 16, 10))
  hadd %h /^SuchThat$/918 $chr($base(220B, 16, 10))
  hadd %h /^notni$/919 $chr($base(220C, 16, 10))
  hadd %h /^notniva$/920 $chr($base(220C, 16, 10))
  hadd %h /^NotReverseElement$/921 $chr($base(220C, 16, 10))
  hadd %h /^prod$/922 $chr($base(220F, 16, 10))
  hadd %h /^Product$/923 $chr($base(220F, 16, 10))
  hadd %h /^coprod$/924 $chr($base(2210, 16, 10))
  hadd %h /^Coproduct$/925 $chr($base(2210, 16, 10))
  hadd %h /^sum$/926 $chr($base(2211, 16, 10))
  hadd %h /^Sum$/927 $chr($base(2211, 16, 10))
  hadd %h /^minus$/928 $chr($base(2212, 16, 10))
  hadd %h /^mnplus$/929 $chr($base(2213, 16, 10))
  hadd %h /^mp$/930 $chr($base(2213, 16, 10))
  hadd %h /^MinusPlus$/931 $chr($base(2213, 16, 10))
  hadd %h /^plusdo$/932 $chr($base(2214, 16, 10))
  hadd %h /^dotplus$/933 $chr($base(2214, 16, 10))
  hadd %h /^setmn$/934 $chr($base(2216, 16, 10))
  hadd %h /^setminus$/935 $chr($base(2216, 16, 10))
  hadd %h /^Backslash$/936 $chr($base(2216, 16, 10))
  hadd %h /^ssetmn$/937 $chr($base(2216, 16, 10))
  hadd %h /^smallsetminus$/938 $chr($base(2216, 16, 10))
  hadd %h /^lowast$/939 $chr($base(2217, 16, 10))
  hadd %h /^compfn$/940 $chr($base(2218, 16, 10))
  hadd %h /^SmallCircle$/941 $chr($base(2218, 16, 10))
  hadd %h /^radic$/942 $chr($base(221A, 16, 10))
  hadd %h /^Sqrt$/943 $chr($base(221A, 16, 10))
  hadd %h /^prop$/944 $chr($base(221D, 16, 10))
  hadd %h /^propto$/945 $chr($base(221D, 16, 10))
  hadd %h /^Proportional$/946 $chr($base(221D, 16, 10))
  hadd %h /^vprop$/947 $chr($base(221D, 16, 10))
  hadd %h /^varpropto$/948 $chr($base(221D, 16, 10))
  hadd %h /^infin$/949 $chr($base(221E, 16, 10))
  hadd %h /^angrt$/950 $chr($base(221F, 16, 10))
  hadd %h /^ang$/951 $chr($base(2220, 16, 10))
  hadd %h /^angle$/952 $chr($base(2220, 16, 10))
  hadd %h /^nang$/953 $chr($base(2220, 16, 10)) $+ $chr($base(20D2, 16, 10))
  hadd %h /^angmsd$/954 $chr($base(2221, 16, 10))
  hadd %h /^measuredangle$/955 $chr($base(2221, 16, 10))
  hadd %h /^angsph$/956 $chr($base(2222, 16, 10))
  hadd %h /^mid$/957 $chr($base(2223, 16, 10))
  hadd %h /^VerticalBar$/958 $chr($base(2223, 16, 10))
  hadd %h /^smid$/959 $chr($base(2223, 16, 10))
  hadd %h /^shortmid$/960 $chr($base(2223, 16, 10))
  hadd %h /^nmid$/961 $chr($base(2224, 16, 10))
  hadd %h /^NotVerticalBar$/962 $chr($base(2224, 16, 10))
  hadd %h /^nsmid$/963 $chr($base(2224, 16, 10))
  hadd %h /^nshortmid$/964 $chr($base(2224, 16, 10))
  hadd %h /^par$/965 $chr($base(2225, 16, 10))
  hadd %h /^parallel$/966 $chr($base(2225, 16, 10))
  hadd %h /^DoubleVerticalBar$/967 $chr($base(2225, 16, 10))
  hadd %h /^spar$/968 $chr($base(2225, 16, 10))
  hadd %h /^shortparallel$/969 $chr($base(2225, 16, 10))
  hadd %h /^npar$/970 $chr($base(2226, 16, 10))
  hadd %h /^nparallel$/971 $chr($base(2226, 16, 10))
  hadd %h /^NotDoubleVerticalBar$/972 $chr($base(2226, 16, 10))
  hadd %h /^nspar$/973 $chr($base(2226, 16, 10))
  hadd %h /^nshortparallel$/974 $chr($base(2226, 16, 10))
  hadd %h /^and$/975 $chr($base(2227, 16, 10))
  hadd %h /^wedge$/976 $chr($base(2227, 16, 10))
  hadd %h /^or$/977 $chr($base(2228, 16, 10))
  hadd %h /^vee$/978 $chr($base(2228, 16, 10))
  hadd %h /^cap$/979 $chr($base(2229, 16, 10))
  hadd %h /^caps$/980 $chr($base(2229, 16, 10)) $+ $chr($base(FE00, 16, 10))
  hadd %h /^cup$/981 $chr($base(222A, 16, 10))
  hadd %h /^cups$/982 $chr($base(222A, 16, 10)) $+ $chr($base(FE00, 16, 10))
  hadd %h /^int$/983 $chr($base(222B, 16, 10))
  hadd %h /^Integral$/984 $chr($base(222B, 16, 10))
  hadd %h /^Int$/985 $chr($base(222C, 16, 10))
  hadd %h /^tint$/986 $chr($base(222D, 16, 10))
  hadd %h /^iiint$/987 $chr($base(222D, 16, 10))
  hadd %h /^conint$/988 $chr($base(222E, 16, 10))
  hadd %h /^oint$/989 $chr($base(222E, 16, 10))
  hadd %h /^ContourIntegral$/990 $chr($base(222E, 16, 10))
  hadd %h /^Conint$/991 $chr($base(222F, 16, 10))
  hadd %h /^DoubleContourIntegral$/992 $chr($base(222F, 16, 10))
  hadd %h /^Cconint$/993 $chr($base(2230, 16, 10))
  hadd %h /^cwint$/994 $chr($base(2231, 16, 10))
  hadd %h /^cwconint$/995 $chr($base(2232, 16, 10))
  hadd %h /^ClockwiseContourIntegral$/996 $chr($base(2232, 16, 10))
  hadd %h /^awconint$/997 $chr($base(2233, 16, 10))
  hadd %h /^CounterClockwiseContourIntegral$/998 $chr($base(2233, 16, 10))
  hadd %h /^there4$/999 $chr($base(2234, 16, 10))
  hadd %h /^therefore$/1000 $chr($base(2234, 16, 10))
  hadd %h /^Therefore$/1001 $chr($base(2234, 16, 10))
  hadd %h /^becaus$/1002 $chr($base(2235, 16, 10))
  hadd %h /^because$/1003 $chr($base(2235, 16, 10))
  hadd %h /^Because$/1004 $chr($base(2235, 16, 10))
  hadd %h /^ratio$/1005 $chr($base(2236, 16, 10))
  hadd %h /^Colon$/1006 $chr($base(2237, 16, 10))
  hadd %h /^Proportion$/1007 $chr($base(2237, 16, 10))
  hadd %h /^minusd$/1008 $chr($base(2238, 16, 10))
  hadd %h /^dotminus$/1009 $chr($base(2238, 16, 10))
  hadd %h /^mDDot$/1010 $chr($base(223A, 16, 10))
  hadd %h /^homtht$/1011 $chr($base(223B, 16, 10))
  hadd %h /^sim$/1012 $chr($base(223C, 16, 10))
  hadd %h /^Tilde$/1013 $chr($base(223C, 16, 10))
  hadd %h /^thksim$/1014 $chr($base(223C, 16, 10))
  hadd %h /^thicksim$/1015 $chr($base(223C, 16, 10))
  hadd %h /^nvsim$/1016 $chr($base(223C, 16, 10)) $+ $chr($base(20D2, 16, 10))
  hadd %h /^bsim$/1017 $chr($base(223D, 16, 10))
  hadd %h /^backsim$/1018 $chr($base(223D, 16, 10))
  hadd %h /^race$/1019 $chr($base(223D, 16, 10)) $+ $chr($base(0331, 16, 10))
  hadd %h /^ac$/1020 $chr($base(223E, 16, 10))
  hadd %h /^mstpos$/1021 $chr($base(223E, 16, 10))
  hadd %h /^acE$/1022 $chr($base(223E, 16, 10)) $+ $chr($base(0333, 16, 10))
  hadd %h /^acd$/1023 $chr($base(223F, 16, 10))
  hadd %h /^wreath$/1024 $chr($base(2240, 16, 10))
  hadd %h /^VerticalTilde$/1025 $chr($base(2240, 16, 10))
  hadd %h /^wr$/1026 $chr($base(2240, 16, 10))
  hadd %h /^nsim$/1027 $chr($base(2241, 16, 10))
  hadd %h /^NotTilde$/1028 $chr($base(2241, 16, 10))
  hadd %h /^esim$/1029 $chr($base(2242, 16, 10))
  hadd %h /^EqualTilde$/1030 $chr($base(2242, 16, 10))
  hadd %h /^eqsim$/1031 $chr($base(2242, 16, 10))
  hadd %h /^NotEqualTilde$/1032 $chr($base(2242, 16, 10)) $+ $chr($base(0338, 16, 10))
  hadd %h /^nesim$/1033 $chr($base(2242, 16, 10)) $+ $chr($base(0338, 16, 10))
  hadd %h /^sime$/1034 $chr($base(2243, 16, 10))
  hadd %h /^TildeEqual$/1035 $chr($base(2243, 16, 10))
  hadd %h /^simeq$/1036 $chr($base(2243, 16, 10))
  hadd %h /^nsime$/1037 $chr($base(2244, 16, 10))
  hadd %h /^nsimeq$/1038 $chr($base(2244, 16, 10))
  hadd %h /^NotTildeEqual$/1039 $chr($base(2244, 16, 10))
  hadd %h /^cong$/1040 $chr($base(2245, 16, 10))
  hadd %h /^TildeFullEqual$/1041 $chr($base(2245, 16, 10))
  hadd %h /^simne$/1042 $chr($base(2246, 16, 10))
  hadd %h /^ncong$/1043 $chr($base(2247, 16, 10))
  hadd %h /^NotTildeFullEqual$/1044 $chr($base(2247, 16, 10))
  hadd %h /^asymp$/1045 $chr($base(2248, 16, 10))
  hadd %h /^ap$/1046 $chr($base(2248, 16, 10))
  hadd %h /^TildeTilde$/1047 $chr($base(2248, 16, 10))
  hadd %h /^approx$/1048 $chr($base(2248, 16, 10))
  hadd %h /^thkap$/1049 $chr($base(2248, 16, 10))
  hadd %h /^thickapprox$/1050 $chr($base(2248, 16, 10))
  hadd %h /^nap$/1051 $chr($base(2249, 16, 10))
  hadd %h /^NotTildeTilde$/1052 $chr($base(2249, 16, 10))
  hadd %h /^napprox$/1053 $chr($base(2249, 16, 10))
  hadd %h /^ape$/1054 $chr($base(224A, 16, 10))
  hadd %h /^approxeq$/1055 $chr($base(224A, 16, 10))
  hadd %h /^apid$/1056 $chr($base(224B, 16, 10))
  hadd %h /^napid$/1057 $chr($base(224B, 16, 10)) $+ $chr($base(0338, 16, 10))
  hadd %h /^bcong$/1058 $chr($base(224C, 16, 10))
  hadd %h /^backcong$/1059 $chr($base(224C, 16, 10))
  hadd %h /^asympeq$/1060 $chr($base(224D, 16, 10))
  hadd %h /^CupCap$/1061 $chr($base(224D, 16, 10))
  hadd %h /^nvap$/1062 $chr($base(224D, 16, 10)) $+ $chr($base(20D2, 16, 10))
  hadd %h /^bump$/1063 $chr($base(224E, 16, 10))
  hadd %h /^HumpDownHump$/1064 $chr($base(224E, 16, 10))
  hadd %h /^Bumpeq$/1065 $chr($base(224E, 16, 10))
  hadd %h /^NotHumpDownHump$/1066 $chr($base(224E, 16, 10)) $+ $chr($base(0338, 16, 10))
  hadd %h /^nbump$/1067 $chr($base(224E, 16, 10)) $+ $chr($base(0338, 16, 10))
  hadd %h /^bumpe$/1068 $chr($base(224F, 16, 10))
  hadd %h /^HumpEqual$/1069 $chr($base(224F, 16, 10))
  hadd %h /^bumpeq$/1070 $chr($base(224F, 16, 10))
  hadd %h /^nbumpe$/1071 $chr($base(224F, 16, 10)) $+ $chr($base(0338, 16, 10))
  hadd %h /^NotHumpEqual$/1072 $chr($base(224F, 16, 10)) $+ $chr($base(0338, 16, 10))
  hadd %h /^esdot$/1073 $chr($base(2250, 16, 10))
  hadd %h /^DotEqual$/1074 $chr($base(2250, 16, 10))
  hadd %h /^doteq$/1075 $chr($base(2250, 16, 10))
  hadd %h /^nedot$/1076 $chr($base(2250, 16, 10)) $+ $chr($base(0338, 16, 10))
  hadd %h /^eDot$/1077 $chr($base(2251, 16, 10))
  hadd %h /^doteqdot$/1078 $chr($base(2251, 16, 10))
  hadd %h /^efDot$/1079 $chr($base(2252, 16, 10))
  hadd %h /^fallingdotseq$/1080 $chr($base(2252, 16, 10))
  hadd %h /^erDot$/1081 $chr($base(2253, 16, 10))
  hadd %h /^risingdotseq$/1082 $chr($base(2253, 16, 10))
  hadd %h /^colone$/1083 $chr($base(2254, 16, 10))
  hadd %h /^coloneq$/1084 $chr($base(2254, 16, 10))
  hadd %h /^Assign$/1085 $chr($base(2254, 16, 10))
  hadd %h /^ecolon$/1086 $chr($base(2255, 16, 10))
  hadd %h /^eqcolon$/1087 $chr($base(2255, 16, 10))
  hadd %h /^ecir$/1088 $chr($base(2256, 16, 10))
  hadd %h /^eqcirc$/1089 $chr($base(2256, 16, 10))
  hadd %h /^cire$/1090 $chr($base(2257, 16, 10))
  hadd %h /^circeq$/1091 $chr($base(2257, 16, 10))
  hadd %h /^wedgeq$/1092 $chr($base(2259, 16, 10))
  hadd %h /^veeeq$/1093 $chr($base(225A, 16, 10))
  hadd %h /^trie$/1094 $chr($base(225C, 16, 10))
  hadd %h /^triangleq$/1095 $chr($base(225C, 16, 10))
  hadd %h /^equest$/1096 $chr($base(225F, 16, 10))
  hadd %h /^questeq$/1097 $chr($base(225F, 16, 10))
  hadd %h /^ne$/1098 $chr($base(2260, 16, 10))
  hadd %h /^NotEqual$/1099 $chr($base(2260, 16, 10))
  hadd %h /^equiv$/1100 $chr($base(2261, 16, 10))
  hadd %h /^Congruent$/1101 $chr($base(2261, 16, 10))
  hadd %h /^bnequiv$/1102 $chr($base(2261, 16, 10)) $+ $chr($base(20E5, 16, 10))
  hadd %h /^nequiv$/1103 $chr($base(2262, 16, 10))
  hadd %h /^NotCongruent$/1104 $chr($base(2262, 16, 10))
  hadd %h /^le$/1105 $chr($base(2264, 16, 10))
  hadd %h /^leq$/1106 $chr($base(2264, 16, 10))
  hadd %h /^nvle$/1107 $chr($base(2264, 16, 10)) $+ $chr($base(20D2, 16, 10))
  hadd %h /^ge$/1108 $chr($base(2265, 16, 10))
  hadd %h /^GreaterEqual$/1109 $chr($base(2265, 16, 10))
  hadd %h /^geq$/1110 $chr($base(2265, 16, 10))
  hadd %h /^nvge$/1111 $chr($base(2265, 16, 10)) $+ $chr($base(20D2, 16, 10))
  hadd %h /^lE$/1112 $chr($base(2266, 16, 10))
  hadd %h /^LessFullEqual$/1113 $chr($base(2266, 16, 10))
  hadd %h /^leqq$/1114 $chr($base(2266, 16, 10))
  hadd %h /^nlE$/1115 $chr($base(2266, 16, 10)) $+ $chr($base(0338, 16, 10))
  hadd %h /^nleqq$/1116 $chr($base(2266, 16, 10)) $+ $chr($base(0338, 16, 10))
  hadd %h /^gE$/1117 $chr($base(2267, 16, 10))
  hadd %h /^GreaterFullEqual$/1118 $chr($base(2267, 16, 10))
  hadd %h /^geqq$/1119 $chr($base(2267, 16, 10))
  hadd %h /^ngE$/1120 $chr($base(2267, 16, 10)) $+ $chr($base(0338, 16, 10))
  hadd %h /^ngeqq$/1121 $chr($base(2267, 16, 10)) $+ $chr($base(0338, 16, 10))
  hadd %h /^NotGreaterFullEqual$/1122 $chr($base(2267, 16, 10)) $+ $chr($base(0338, 16, 10))
  hadd %h /^lnE$/1123 $chr($base(2268, 16, 10))
  hadd %h /^lneqq$/1124 $chr($base(2268, 16, 10))
  hadd %h /^lvnE$/1125 $chr($base(2268, 16, 10)) $+ $chr($base(FE00, 16, 10))
  hadd %h /^lvertneqq$/1126 $chr($base(2268, 16, 10)) $+ $chr($base(FE00, 16, 10))
  hadd %h /^gnE$/1127 $chr($base(2269, 16, 10))
  hadd %h /^gneqq$/1128 $chr($base(2269, 16, 10))
  hadd %h /^gvnE$/1129 $chr($base(2269, 16, 10)) $+ $chr($base(FE00, 16, 10))
  hadd %h /^gvertneqq$/1130 $chr($base(2269, 16, 10)) $+ $chr($base(FE00, 16, 10))
  hadd %h /^Lt$/1131 $chr($base(226A, 16, 10))
  hadd %h /^NestedLessLess$/1132 $chr($base(226A, 16, 10))
  hadd %h /^ll$/1133 $chr($base(226A, 16, 10))
  hadd %h /^nLtv$/1134 $chr($base(226A, 16, 10)) $+ $chr($base(0338, 16, 10))
  hadd %h /^NotLessLess$/1135 $chr($base(226A, 16, 10)) $+ $chr($base(0338, 16, 10))
  hadd %h /^nLt$/1136 $chr($base(226A, 16, 10)) $+ $chr($base(20D2, 16, 10))
  hadd %h /^Gt$/1137 $chr($base(226B, 16, 10))
  hadd %h /^NestedGreaterGreater$/1138 $chr($base(226B, 16, 10))
  hadd %h /^gg$/1139 $chr($base(226B, 16, 10))
  hadd %h /^nGtv$/1140 $chr($base(226B, 16, 10)) $+ $chr($base(0338, 16, 10))
  hadd %h /^NotGreaterGreater$/1141 $chr($base(226B, 16, 10)) $+ $chr($base(0338, 16, 10))
  hadd %h /^nGt$/1142 $chr($base(226B, 16, 10)) $+ $chr($base(20D2, 16, 10))
  hadd %h /^twixt$/1143 $chr($base(226C, 16, 10))
  hadd %h /^between$/1144 $chr($base(226C, 16, 10))
  hadd %h /^NotCupCap$/1145 $chr($base(226D, 16, 10))
  hadd %h /^nlt$/1146 $chr($base(226E, 16, 10))
  hadd %h /^NotLess$/1147 $chr($base(226E, 16, 10))
  hadd %h /^nless$/1148 $chr($base(226E, 16, 10))
  hadd %h /^ngt$/1149 $chr($base(226F, 16, 10))
  hadd %h /^NotGreater$/1150 $chr($base(226F, 16, 10))
  hadd %h /^ngtr$/1151 $chr($base(226F, 16, 10))
  hadd %h /^nle$/1152 $chr($base(2270, 16, 10))
  hadd %h /^NotLessEqual$/1153 $chr($base(2270, 16, 10))
  hadd %h /^nleq$/1154 $chr($base(2270, 16, 10))
  hadd %h /^nge$/1155 $chr($base(2271, 16, 10))
  hadd %h /^NotGreaterEqual$/1156 $chr($base(2271, 16, 10))
  hadd %h /^ngeq$/1157 $chr($base(2271, 16, 10))
  hadd %h /^lsim$/1158 $chr($base(2272, 16, 10))
  hadd %h /^LessTilde$/1159 $chr($base(2272, 16, 10))
  hadd %h /^lesssim$/1160 $chr($base(2272, 16, 10))
  hadd %h /^gsim$/1161 $chr($base(2273, 16, 10))
  hadd %h /^gtrsim$/1162 $chr($base(2273, 16, 10))
  hadd %h /^GreaterTilde$/1163 $chr($base(2273, 16, 10))
  hadd %h /^nlsim$/1164 $chr($base(2274, 16, 10))
  hadd %h /^NotLessTilde$/1165 $chr($base(2274, 16, 10))
  hadd %h /^ngsim$/1166 $chr($base(2275, 16, 10))
  hadd %h /^NotGreaterTilde$/1167 $chr($base(2275, 16, 10))
  hadd %h /^lg$/1168 $chr($base(2276, 16, 10))
  hadd %h /^lessgtr$/1169 $chr($base(2276, 16, 10))
  hadd %h /^LessGreater$/1170 $chr($base(2276, 16, 10))
  hadd %h /^gl$/1171 $chr($base(2277, 16, 10))
  hadd %h /^gtrless$/1172 $chr($base(2277, 16, 10))
  hadd %h /^GreaterLess$/1173 $chr($base(2277, 16, 10))
  hadd %h /^ntlg$/1174 $chr($base(2278, 16, 10))
  hadd %h /^NotLessGreater$/1175 $chr($base(2278, 16, 10))
  hadd %h /^ntgl$/1176 $chr($base(2279, 16, 10))
  hadd %h /^NotGreaterLess$/1177 $chr($base(2279, 16, 10))
  hadd %h /^pr$/1178 $chr($base(227A, 16, 10))
  hadd %h /^Precedes$/1179 $chr($base(227A, 16, 10))
  hadd %h /^prec$/1180 $chr($base(227A, 16, 10))
  hadd %h /^sc$/1181 $chr($base(227B, 16, 10))
  hadd %h /^Succeeds$/1182 $chr($base(227B, 16, 10))
  hadd %h /^succ$/1183 $chr($base(227B, 16, 10))
  hadd %h /^prcue$/1184 $chr($base(227C, 16, 10))
  hadd %h /^PrecedesSlantEqual$/1185 $chr($base(227C, 16, 10))
  hadd %h /^preccurlyeq$/1186 $chr($base(227C, 16, 10))
  hadd %h /^sccue$/1187 $chr($base(227D, 16, 10))
  hadd %h /^SucceedsSlantEqual$/1188 $chr($base(227D, 16, 10))
  hadd %h /^succcurlyeq$/1189 $chr($base(227D, 16, 10))
  hadd %h /^prsim$/1190 $chr($base(227E, 16, 10))
  hadd %h /^precsim$/1191 $chr($base(227E, 16, 10))
  hadd %h /^PrecedesTilde$/1192 $chr($base(227E, 16, 10))
  hadd %h /^scsim$/1193 $chr($base(227F, 16, 10))
  hadd %h /^succsim$/1194 $chr($base(227F, 16, 10))
  hadd %h /^SucceedsTilde$/1195 $chr($base(227F, 16, 10))
  hadd %h /^NotSucceedsTilde$/1196 $chr($base(227F, 16, 10)) $+ $chr($base(0338, 16, 10))
  hadd %h /^npr$/1197 $chr($base(2280, 16, 10))
  hadd %h /^nprec$/1198 $chr($base(2280, 16, 10))
  hadd %h /^NotPrecedes$/1199 $chr($base(2280, 16, 10))
  hadd %h /^nsc$/1200 $chr($base(2281, 16, 10))
  hadd %h /^nsucc$/1201 $chr($base(2281, 16, 10))
  hadd %h /^NotSucceeds$/1202 $chr($base(2281, 16, 10))
  hadd %h /^sub$/1203 $chr($base(2282, 16, 10))
  hadd %h /^subset$/1204 $chr($base(2282, 16, 10))
  hadd %h /^vnsub$/1205 $chr($base(2282, 16, 10)) $+ $chr($base(20D2, 16, 10))
  hadd %h /^nsubset$/1206 $chr($base(2282, 16, 10)) $+ $chr($base(20D2, 16, 10))
  hadd %h /^NotSubset$/1207 $chr($base(2282, 16, 10)) $+ $chr($base(20D2, 16, 10))
  hadd %h /^sup$/1208 $chr($base(2283, 16, 10))
  hadd %h /^supset$/1209 $chr($base(2283, 16, 10))
  hadd %h /^Superset$/1210 $chr($base(2283, 16, 10))
  hadd %h /^vnsup$/1211 $chr($base(2283, 16, 10)) $+ $chr($base(20D2, 16, 10))
  hadd %h /^nsupset$/1212 $chr($base(2283, 16, 10)) $+ $chr($base(20D2, 16, 10))
  hadd %h /^NotSuperset$/1213 $chr($base(2283, 16, 10)) $+ $chr($base(20D2, 16, 10))
  hadd %h /^nsub$/1214 $chr($base(2284, 16, 10))
  hadd %h /^nsup$/1215 $chr($base(2285, 16, 10))
  hadd %h /^sube$/1216 $chr($base(2286, 16, 10))
  hadd %h /^SubsetEqual$/1217 $chr($base(2286, 16, 10))
  hadd %h /^subseteq$/1218 $chr($base(2286, 16, 10))
  hadd %h /^supe$/1219 $chr($base(2287, 16, 10))
  hadd %h /^supseteq$/1220 $chr($base(2287, 16, 10))
  hadd %h /^SupersetEqual$/1221 $chr($base(2287, 16, 10))
  hadd %h /^nsube$/1222 $chr($base(2288, 16, 10))
  hadd %h /^nsubseteq$/1223 $chr($base(2288, 16, 10))
  hadd %h /^NotSubsetEqual$/1224 $chr($base(2288, 16, 10))
  hadd %h /^nsupe$/1225 $chr($base(2289, 16, 10))
  hadd %h /^nsupseteq$/1226 $chr($base(2289, 16, 10))
  hadd %h /^NotSupersetEqual$/1227 $chr($base(2289, 16, 10))
  hadd %h /^subne$/1228 $chr($base(228A, 16, 10))
  hadd %h /^subsetneq$/1229 $chr($base(228A, 16, 10))
  hadd %h /^vsubne$/1230 $chr($base(228A, 16, 10)) $+ $chr($base(FE00, 16, 10))
  hadd %h /^varsubsetneq$/1231 $chr($base(228A, 16, 10)) $+ $chr($base(FE00, 16, 10))
  hadd %h /^supne$/1232 $chr($base(228B, 16, 10))
  hadd %h /^supsetneq$/1233 $chr($base(228B, 16, 10))
  hadd %h /^vsupne$/1234 $chr($base(228B, 16, 10)) $+ $chr($base(FE00, 16, 10))
  hadd %h /^varsupsetneq$/1235 $chr($base(228B, 16, 10)) $+ $chr($base(FE00, 16, 10))
  hadd %h /^cupdot$/1236 $chr($base(228D, 16, 10))
  hadd %h /^uplus$/1237 $chr($base(228E, 16, 10))
  hadd %h /^UnionPlus$/1238 $chr($base(228E, 16, 10))
  hadd %h /^sqsub$/1239 $chr($base(228F, 16, 10))
  hadd %h /^SquareSubset$/1240 $chr($base(228F, 16, 10))
  hadd %h /^sqsubset$/1241 $chr($base(228F, 16, 10))
  hadd %h /^NotSquareSubset$/1242 $chr($base(228F, 16, 10)) $+ $chr($base(0338, 16, 10))
  hadd %h /^sqsup$/1243 $chr($base(2290, 16, 10))
  hadd %h /^SquareSuperset$/1244 $chr($base(2290, 16, 10))
  hadd %h /^sqsupset$/1245 $chr($base(2290, 16, 10))
  hadd %h /^NotSquareSuperset$/1246 $chr($base(2290, 16, 10)) $+ $chr($base(0338, 16, 10))
  hadd %h /^sqsube$/1247 $chr($base(2291, 16, 10))
  hadd %h /^SquareSubsetEqual$/1248 $chr($base(2291, 16, 10))
  hadd %h /^sqsubseteq$/1249 $chr($base(2291, 16, 10))
  hadd %h /^sqsupe$/1250 $chr($base(2292, 16, 10))
  hadd %h /^SquareSupersetEqual$/1251 $chr($base(2292, 16, 10))
  hadd %h /^sqsupseteq$/1252 $chr($base(2292, 16, 10))
  hadd %h /^sqcap$/1253 $chr($base(2293, 16, 10))
  hadd %h /^SquareIntersection$/1254 $chr($base(2293, 16, 10))
  hadd %h /^sqcaps$/1255 $chr($base(2293, 16, 10)) $+ $chr($base(FE00, 16, 10))
  hadd %h /^sqcup$/1256 $chr($base(2294, 16, 10))
  hadd %h /^SquareUnion$/1257 $chr($base(2294, 16, 10))
  hadd %h /^sqcups$/1258 $chr($base(2294, 16, 10)) $+ $chr($base(FE00, 16, 10))
  hadd %h /^oplus$/1259 $chr($base(2295, 16, 10))
  hadd %h /^CirclePlus$/1260 $chr($base(2295, 16, 10))
  hadd %h /^ominus$/1261 $chr($base(2296, 16, 10))
  hadd %h /^CircleMinus$/1262 $chr($base(2296, 16, 10))
  hadd %h /^otimes$/1263 $chr($base(2297, 16, 10))
  hadd %h /^CircleTimes$/1264 $chr($base(2297, 16, 10))
  hadd %h /^osol$/1265 $chr($base(2298, 16, 10))
  hadd %h /^odot$/1266 $chr($base(2299, 16, 10))
  hadd %h /^CircleDot$/1267 $chr($base(2299, 16, 10))
  hadd %h /^ocir$/1268 $chr($base(229A, 16, 10))
  hadd %h /^circledcirc$/1269 $chr($base(229A, 16, 10))
  hadd %h /^oast$/1270 $chr($base(229B, 16, 10))
  hadd %h /^circledast$/1271 $chr($base(229B, 16, 10))
  hadd %h /^odash$/1272 $chr($base(229D, 16, 10))
  hadd %h /^circleddash$/1273 $chr($base(229D, 16, 10))
  hadd %h /^plusb$/1274 $chr($base(229E, 16, 10))
  hadd %h /^boxplus$/1275 $chr($base(229E, 16, 10))
  hadd %h /^minusb$/1276 $chr($base(229F, 16, 10))
  hadd %h /^boxminus$/1277 $chr($base(229F, 16, 10))
  hadd %h /^timesb$/1278 $chr($base(22A0, 16, 10))
  hadd %h /^boxtimes$/1279 $chr($base(22A0, 16, 10))
  hadd %h /^sdotb$/1280 $chr($base(22A1, 16, 10))
  hadd %h /^dotsquare$/1281 $chr($base(22A1, 16, 10))
  hadd %h /^vdash$/1282 $chr($base(22A2, 16, 10))
  hadd %h /^RightTee$/1283 $chr($base(22A2, 16, 10))
  hadd %h /^dashv$/1284 $chr($base(22A3, 16, 10))
  hadd %h /^LeftTee$/1285 $chr($base(22A3, 16, 10))
  hadd %h /^top$/1286 $chr($base(22A4, 16, 10))
  hadd %h /^DownTee$/1287 $chr($base(22A4, 16, 10))
  hadd %h /^bottom$/1288 $chr($base(22A5, 16, 10))
  hadd %h /^bot$/1289 $chr($base(22A5, 16, 10))
  hadd %h /^perp$/1290 $chr($base(22A5, 16, 10))
  hadd %h /^UpTee$/1291 $chr($base(22A5, 16, 10))
  hadd %h /^models$/1292 $chr($base(22A7, 16, 10))
  hadd %h /^vDash$/1293 $chr($base(22A8, 16, 10))
  hadd %h /^DoubleRightTee$/1294 $chr($base(22A8, 16, 10))
  hadd %h /^Vdash$/1295 $chr($base(22A9, 16, 10))
  hadd %h /^Vvdash$/1296 $chr($base(22AA, 16, 10))
  hadd %h /^VDash$/1297 $chr($base(22AB, 16, 10))
  hadd %h /^nvdash$/1298 $chr($base(22AC, 16, 10))
  hadd %h /^nvDash$/1299 $chr($base(22AD, 16, 10))
  hadd %h /^nVdash$/1300 $chr($base(22AE, 16, 10))
  hadd %h /^nVDash$/1301 $chr($base(22AF, 16, 10))
  hadd %h /^prurel$/1302 $chr($base(22B0, 16, 10))
  hadd %h /^vltri$/1303 $chr($base(22B2, 16, 10))
  hadd %h /^vartriangleleft$/1304 $chr($base(22B2, 16, 10))
  hadd %h /^LeftTriangle$/1305 $chr($base(22B2, 16, 10))
  hadd %h /^vrtri$/1306 $chr($base(22B3, 16, 10))
  hadd %h /^vartriangleright$/1307 $chr($base(22B3, 16, 10))
  hadd %h /^RightTriangle$/1308 $chr($base(22B3, 16, 10))
  hadd %h /^ltrie$/1309 $chr($base(22B4, 16, 10))
  hadd %h /^trianglelefteq$/1310 $chr($base(22B4, 16, 10))
  hadd %h /^LeftTriangleEqual$/1311 $chr($base(22B4, 16, 10))
  hadd %h /^nvltrie$/1312 $chr($base(22B4, 16, 10)) $+ $chr($base(20D2, 16, 10))
  hadd %h /^rtrie$/1313 $chr($base(22B5, 16, 10))
  hadd %h /^trianglerighteq$/1314 $chr($base(22B5, 16, 10))
  hadd %h /^RightTriangleEqual$/1315 $chr($base(22B5, 16, 10))
  hadd %h /^nvrtrie$/1316 $chr($base(22B5, 16, 10)) $+ $chr($base(20D2, 16, 10))
  hadd %h /^origof$/1317 $chr($base(22B6, 16, 10))
  hadd %h /^imof$/1318 $chr($base(22B7, 16, 10))
  hadd %h /^mumap$/1319 $chr($base(22B8, 16, 10))
  hadd %h /^multimap$/1320 $chr($base(22B8, 16, 10))
  hadd %h /^hercon$/1321 $chr($base(22B9, 16, 10))
  hadd %h /^intcal$/1322 $chr($base(22BA, 16, 10))
  hadd %h /^intercal$/1323 $chr($base(22BA, 16, 10))
  hadd %h /^veebar$/1324 $chr($base(22BB, 16, 10))
  hadd %h /^barvee$/1325 $chr($base(22BD, 16, 10))
  hadd %h /^angrtvb$/1326 $chr($base(22BE, 16, 10))
  hadd %h /^lrtri$/1327 $chr($base(22BF, 16, 10))
  hadd %h /^xwedge$/1328 $chr($base(22C0, 16, 10))
  hadd %h /^Wedge$/1329 $chr($base(22C0, 16, 10))
  hadd %h /^bigwedge$/1330 $chr($base(22C0, 16, 10))
  hadd %h /^xvee$/1331 $chr($base(22C1, 16, 10))
  hadd %h /^Vee$/1332 $chr($base(22C1, 16, 10))
  hadd %h /^bigvee$/1333 $chr($base(22C1, 16, 10))
  hadd %h /^xcap$/1334 $chr($base(22C2, 16, 10))
  hadd %h /^Intersection$/1335 $chr($base(22C2, 16, 10))
  hadd %h /^bigcap$/1336 $chr($base(22C2, 16, 10))
  hadd %h /^xcup$/1337 $chr($base(22C3, 16, 10))
  hadd %h /^Union$/1338 $chr($base(22C3, 16, 10))
  hadd %h /^bigcup$/1339 $chr($base(22C3, 16, 10))
  hadd %h /^diam$/1340 $chr($base(22C4, 16, 10))
  hadd %h /^diamond$/1341 $chr($base(22C4, 16, 10))
  hadd %h /^Diamond$/1342 $chr($base(22C4, 16, 10))
  hadd %h /^sdot$/1343 $chr($base(22C5, 16, 10))
  hadd %h /^sstarf$/1344 $chr($base(22C6, 16, 10))
  hadd %h /^Star$/1345 $chr($base(22C6, 16, 10))
  hadd %h /^divonx$/1346 $chr($base(22C7, 16, 10))
  hadd %h /^divideontimes$/1347 $chr($base(22C7, 16, 10))
  hadd %h /^bowtie$/1348 $chr($base(22C8, 16, 10))
  hadd %h /^ltimes$/1349 $chr($base(22C9, 16, 10))
  hadd %h /^rtimes$/1350 $chr($base(22CA, 16, 10))
  hadd %h /^lthree$/1351 $chr($base(22CB, 16, 10))
  hadd %h /^leftthreetimes$/1352 $chr($base(22CB, 16, 10))
  hadd %h /^rthree$/1353 $chr($base(22CC, 16, 10))
  hadd %h /^rightthreetimes$/1354 $chr($base(22CC, 16, 10))
  hadd %h /^bsime$/1355 $chr($base(22CD, 16, 10))
  hadd %h /^backsimeq$/1356 $chr($base(22CD, 16, 10))
  hadd %h /^cuvee$/1357 $chr($base(22CE, 16, 10))
  hadd %h /^curlyvee$/1358 $chr($base(22CE, 16, 10))
  hadd %h /^cuwed$/1359 $chr($base(22CF, 16, 10))
  hadd %h /^curlywedge$/1360 $chr($base(22CF, 16, 10))
  hadd %h /^Sub$/1361 $chr($base(22D0, 16, 10))
  hadd %h /^Subset$/1362 $chr($base(22D0, 16, 10))
  hadd %h /^Sup$/1363 $chr($base(22D1, 16, 10))
  hadd %h /^Supset$/1364 $chr($base(22D1, 16, 10))
  hadd %h /^Cap$/1365 $chr($base(22D2, 16, 10))
  hadd %h /^Cup$/1366 $chr($base(22D3, 16, 10))
  hadd %h /^fork$/1367 $chr($base(22D4, 16, 10))
  hadd %h /^pitchfork$/1368 $chr($base(22D4, 16, 10))
  hadd %h /^epar$/1369 $chr($base(22D5, 16, 10))
  hadd %h /^ltdot$/1370 $chr($base(22D6, 16, 10))
  hadd %h /^lessdot$/1371 $chr($base(22D6, 16, 10))
  hadd %h /^gtdot$/1372 $chr($base(22D7, 16, 10))
  hadd %h /^gtrdot$/1373 $chr($base(22D7, 16, 10))
  hadd %h /^Ll$/1374 $chr($base(22D8, 16, 10))
  hadd %h /^nLl$/1375 $chr($base(22D8, 16, 10)) $+ $chr($base(0338, 16, 10))
  hadd %h /^Gg$/1376 $chr($base(22D9, 16, 10))
  hadd %h /^ggg$/1377 $chr($base(22D9, 16, 10))
  hadd %h /^nGg$/1378 $chr($base(22D9, 16, 10)) $+ $chr($base(0338, 16, 10))
  hadd %h /^leg$/1379 $chr($base(22DA, 16, 10))
  hadd %h /^LessEqualGreater$/1380 $chr($base(22DA, 16, 10))
  hadd %h /^lesseqgtr$/1381 $chr($base(22DA, 16, 10))
  hadd %h /^lesg$/1382 $chr($base(22DA, 16, 10)) $+ $chr($base(FE00, 16, 10))
  hadd %h /^gel$/1383 $chr($base(22DB, 16, 10))
  hadd %h /^gtreqless$/1384 $chr($base(22DB, 16, 10))
  hadd %h /^GreaterEqualLess$/1385 $chr($base(22DB, 16, 10))
  hadd %h /^gesl$/1386 $chr($base(22DB, 16, 10)) $+ $chr($base(FE00, 16, 10))
  hadd %h /^cuepr$/1387 $chr($base(22DE, 16, 10))
  hadd %h /^curlyeqprec$/1388 $chr($base(22DE, 16, 10))
  hadd %h /^cuesc$/1389 $chr($base(22DF, 16, 10))
  hadd %h /^curlyeqsucc$/1390 $chr($base(22DF, 16, 10))
  hadd %h /^nprcue$/1391 $chr($base(22E0, 16, 10))
  hadd %h /^NotPrecedesSlantEqual$/1392 $chr($base(22E0, 16, 10))
  hadd %h /^nsccue$/1393 $chr($base(22E1, 16, 10))
  hadd %h /^NotSucceedsSlantEqual$/1394 $chr($base(22E1, 16, 10))
  hadd %h /^nsqsube$/1395 $chr($base(22E2, 16, 10))
  hadd %h /^NotSquareSubsetEqual$/1396 $chr($base(22E2, 16, 10))
  hadd %h /^nsqsupe$/1397 $chr($base(22E3, 16, 10))
  hadd %h /^NotSquareSupersetEqual$/1398 $chr($base(22E3, 16, 10))
  hadd %h /^lnsim$/1399 $chr($base(22E6, 16, 10))
  hadd %h /^gnsim$/1400 $chr($base(22E7, 16, 10))
  hadd %h /^prnsim$/1401 $chr($base(22E8, 16, 10))
  hadd %h /^precnsim$/1402 $chr($base(22E8, 16, 10))
  hadd %h /^scnsim$/1403 $chr($base(22E9, 16, 10))
  hadd %h /^succnsim$/1404 $chr($base(22E9, 16, 10))
  hadd %h /^nltri$/1405 $chr($base(22EA, 16, 10))
  hadd %h /^ntriangleleft$/1406 $chr($base(22EA, 16, 10))
  hadd %h /^NotLeftTriangle$/1407 $chr($base(22EA, 16, 10))
  hadd %h /^nrtri$/1408 $chr($base(22EB, 16, 10))
  hadd %h /^ntriangleright$/1409 $chr($base(22EB, 16, 10))
  hadd %h /^NotRightTriangle$/1410 $chr($base(22EB, 16, 10))
  hadd %h /^nltrie$/1411 $chr($base(22EC, 16, 10))
  hadd %h /^ntrianglelefteq$/1412 $chr($base(22EC, 16, 10))
  hadd %h /^NotLeftTriangleEqual$/1413 $chr($base(22EC, 16, 10))
  hadd %h /^nrtrie$/1414 $chr($base(22ED, 16, 10))
  hadd %h /^ntrianglerighteq$/1415 $chr($base(22ED, 16, 10))
  hadd %h /^NotRightTriangleEqual$/1416 $chr($base(22ED, 16, 10))
  hadd %h /^vellip$/1417 $chr($base(22EE, 16, 10))
  hadd %h /^ctdot$/1418 $chr($base(22EF, 16, 10))
  hadd %h /^utdot$/1419 $chr($base(22F0, 16, 10))
  hadd %h /^dtdot$/1420 $chr($base(22F1, 16, 10))
  hadd %h /^disin$/1421 $chr($base(22F2, 16, 10))
  hadd %h /^isinsv$/1422 $chr($base(22F3, 16, 10))
  hadd %h /^isins$/1423 $chr($base(22F4, 16, 10))
  hadd %h /^isindot$/1424 $chr($base(22F5, 16, 10))
  hadd %h /^notindot$/1425 $chr($base(22F5, 16, 10)) $+ $chr($base(0338, 16, 10))
  hadd %h /^notinvc$/1426 $chr($base(22F6, 16, 10))
  hadd %h /^notinvb$/1427 $chr($base(22F7, 16, 10))
  hadd %h /^isinE$/1428 $chr($base(22F9, 16, 10))
  hadd %h /^notinE$/1429 $chr($base(22F9, 16, 10)) $+ $chr($base(0338, 16, 10))
  hadd %h /^nisd$/1430 $chr($base(22FA, 16, 10))
  hadd %h /^xnis$/1431 $chr($base(22FB, 16, 10))
  hadd %h /^nis$/1432 $chr($base(22FC, 16, 10))
  hadd %h /^notnivc$/1433 $chr($base(22FD, 16, 10))
  hadd %h /^notnivb$/1434 $chr($base(22FE, 16, 10))
  hadd %h /^barwed$/1435 $chr($base(2305, 16, 10))
  hadd %h /^barwedge$/1436 $chr($base(2305, 16, 10))
  hadd %h /^Barwed$/1437 $chr($base(2306, 16, 10))
  hadd %h /^doublebarwedge$/1438 $chr($base(2306, 16, 10))
  hadd %h /^lceil$/1439 $chr($base(2308, 16, 10))
  hadd %h /^LeftCeiling$/1440 $chr($base(2308, 16, 10))
  hadd %h /^rceil$/1441 $chr($base(2309, 16, 10))
  hadd %h /^RightCeiling$/1442 $chr($base(2309, 16, 10))
  hadd %h /^lfloor$/1443 $chr($base(230A, 16, 10))
  hadd %h /^LeftFloor$/1444 $chr($base(230A, 16, 10))
  hadd %h /^rfloor$/1445 $chr($base(230B, 16, 10))
  hadd %h /^RightFloor$/1446 $chr($base(230B, 16, 10))
  hadd %h /^drcrop$/1447 $chr($base(230C, 16, 10))
  hadd %h /^dlcrop$/1448 $chr($base(230D, 16, 10))
  hadd %h /^urcrop$/1449 $chr($base(230E, 16, 10))
  hadd %h /^ulcrop$/1450 $chr($base(230F, 16, 10))
  hadd %h /^bnot$/1451 $chr($base(2310, 16, 10))
  hadd %h /^profline$/1452 $chr($base(2312, 16, 10))
  hadd %h /^profsurf$/1453 $chr($base(2313, 16, 10))
  hadd %h /^telrec$/1454 $chr($base(2315, 16, 10))
  hadd %h /^target$/1455 $chr($base(2316, 16, 10))
  hadd %h /^ulcorn$/1456 $chr($base(231C, 16, 10))
  hadd %h /^ulcorner$/1457 $chr($base(231C, 16, 10))
  hadd %h /^urcorn$/1458 $chr($base(231D, 16, 10))
  hadd %h /^urcorner$/1459 $chr($base(231D, 16, 10))
  hadd %h /^dlcorn$/1460 $chr($base(231E, 16, 10))
  hadd %h /^llcorner$/1461 $chr($base(231E, 16, 10))
  hadd %h /^drcorn$/1462 $chr($base(231F, 16, 10))
  hadd %h /^lrcorner$/1463 $chr($base(231F, 16, 10))
  hadd %h /^frown$/1464 $chr($base(2322, 16, 10))
  hadd %h /^sfrown$/1465 $chr($base(2322, 16, 10))
  hadd %h /^smile$/1466 $chr($base(2323, 16, 10))
  hadd %h /^ssmile$/1467 $chr($base(2323, 16, 10))
  hadd %h /^cylcty$/1468 $chr($base(232D, 16, 10))
  hadd %h /^profalar$/1469 $chr($base(232E, 16, 10))
  hadd %h /^topbot$/1470 $chr($base(2336, 16, 10))
  hadd %h /^ovbar$/1471 $chr($base(233D, 16, 10))
  hadd %h /^solbar$/1472 $chr($base(233F, 16, 10))
  hadd %h /^angzarr$/1473 $chr($base(237C, 16, 10))
  hadd %h /^lmoust$/1474 $chr($base(23B0, 16, 10))
  hadd %h /^lmoustache$/1475 $chr($base(23B0, 16, 10))
  hadd %h /^rmoust$/1476 $chr($base(23B1, 16, 10))
  hadd %h /^rmoustache$/1477 $chr($base(23B1, 16, 10))
  hadd %h /^tbrk$/1478 $chr($base(23B4, 16, 10))
  hadd %h /^OverBracket$/1479 $chr($base(23B4, 16, 10))
  hadd %h /^bbrk$/1480 $chr($base(23B5, 16, 10))
  hadd %h /^UnderBracket$/1481 $chr($base(23B5, 16, 10))
  hadd %h /^bbrktbrk$/1482 $chr($base(23B6, 16, 10))
  hadd %h /^OverParenthesis$/1483 $chr($base(23DC, 16, 10))
  hadd %h /^UnderParenthesis$/1484 $chr($base(23DD, 16, 10))
  hadd %h /^OverBrace$/1485 $chr($base(23DE, 16, 10))
  hadd %h /^UnderBrace$/1486 $chr($base(23DF, 16, 10))
  hadd %h /^trpezium$/1487 $chr($base(23E2, 16, 10))
  hadd %h /^elinters$/1488 $chr($base(23E7, 16, 10))
  hadd %h /^blank$/1489 $chr($base(2423, 16, 10))
  hadd %h /^oS$/1490 $chr($base(24C8, 16, 10))
  hadd %h /^circledS$/1491 $chr($base(24C8, 16, 10))
  hadd %h /^boxh$/1492 $chr($base(2500, 16, 10))
  hadd %h /^HorizontalLine$/1493 $chr($base(2500, 16, 10))
  hadd %h /^boxv$/1494 $chr($base(2502, 16, 10))
  hadd %h /^boxdr$/1495 $chr($base(250C, 16, 10))
  hadd %h /^boxdl$/1496 $chr($base(2510, 16, 10))
  hadd %h /^boxur$/1497 $chr($base(2514, 16, 10))
  hadd %h /^boxul$/1498 $chr($base(2518, 16, 10))
  hadd %h /^boxvr$/1499 $chr($base(251C, 16, 10))
  hadd %h /^boxvl$/1500 $chr($base(2524, 16, 10))
  hadd %h /^boxhd$/1501 $chr($base(252C, 16, 10))
  hadd %h /^boxhu$/1502 $chr($base(2534, 16, 10))
  hadd %h /^boxvh$/1503 $chr($base(253C, 16, 10))
  hadd %h /^boxH$/1504 $chr($base(2550, 16, 10))
  hadd %h /^boxV$/1505 $chr($base(2551, 16, 10))
  hadd %h /^boxdR$/1506 $chr($base(2552, 16, 10))
  hadd %h /^boxDr$/1507 $chr($base(2553, 16, 10))
  hadd %h /^boxDR$/1508 $chr($base(2554, 16, 10))
  hadd %h /^boxdL$/1509 $chr($base(2555, 16, 10))
  hadd %h /^boxDl$/1510 $chr($base(2556, 16, 10))
  hadd %h /^boxDL$/1511 $chr($base(2557, 16, 10))
  hadd %h /^boxuR$/1512 $chr($base(2558, 16, 10))
  hadd %h /^boxUr$/1513 $chr($base(2559, 16, 10))
  hadd %h /^boxUR$/1514 $chr($base(255A, 16, 10))
  hadd %h /^boxuL$/1515 $chr($base(255B, 16, 10))
  hadd %h /^boxUl$/1516 $chr($base(255C, 16, 10))
  hadd %h /^boxUL$/1517 $chr($base(255D, 16, 10))
  hadd %h /^boxvR$/1518 $chr($base(255E, 16, 10))
  hadd %h /^boxVr$/1519 $chr($base(255F, 16, 10))
  hadd %h /^boxVR$/1520 $chr($base(2560, 16, 10))
  hadd %h /^boxvL$/1521 $chr($base(2561, 16, 10))
  hadd %h /^boxVl$/1522 $chr($base(2562, 16, 10))
  hadd %h /^boxVL$/1523 $chr($base(2563, 16, 10))
  hadd %h /^boxHd$/1524 $chr($base(2564, 16, 10))
  hadd %h /^boxhD$/1525 $chr($base(2565, 16, 10))
  hadd %h /^boxHD$/1526 $chr($base(2566, 16, 10))
  hadd %h /^boxHu$/1527 $chr($base(2567, 16, 10))
  hadd %h /^boxhU$/1528 $chr($base(2568, 16, 10))
  hadd %h /^boxHU$/1529 $chr($base(2569, 16, 10))
  hadd %h /^boxvH$/1530 $chr($base(256A, 16, 10))
  hadd %h /^boxVh$/1531 $chr($base(256B, 16, 10))
  hadd %h /^boxVH$/1532 $chr($base(256C, 16, 10))
  hadd %h /^uhblk$/1533 $chr($base(2580, 16, 10))
  hadd %h /^lhblk$/1534 $chr($base(2584, 16, 10))
  hadd %h /^block$/1535 $chr($base(2588, 16, 10))
  hadd %h /^blk14$/1536 $chr($base(2591, 16, 10))
  hadd %h /^blk12$/1537 $chr($base(2592, 16, 10))
  hadd %h /^blk34$/1538 $chr($base(2593, 16, 10))
  hadd %h /^squ$/1539 $chr($base(25A1, 16, 10))
  hadd %h /^square$/1540 $chr($base(25A1, 16, 10))
  hadd %h /^Square$/1541 $chr($base(25A1, 16, 10))
  hadd %h /^squf$/1542 $chr($base(25AA, 16, 10))
  hadd %h /^squarf$/1543 $chr($base(25AA, 16, 10))
  hadd %h /^blacksquare$/1544 $chr($base(25AA, 16, 10))
  hadd %h /^FilledVerySmallSquare$/1545 $chr($base(25AA, 16, 10))
  hadd %h /^EmptyVerySmallSquare$/1546 $chr($base(25AB, 16, 10))
  hadd %h /^rect$/1547 $chr($base(25AD, 16, 10))
  hadd %h /^marker$/1548 $chr($base(25AE, 16, 10))
  hadd %h /^fltns$/1549 $chr($base(25B1, 16, 10))
  hadd %h /^xutri$/1550 $chr($base(25B3, 16, 10))
  hadd %h /^bigtriangleup$/1551 $chr($base(25B3, 16, 10))
  hadd %h /^utrif$/1552 $chr($base(25B4, 16, 10))
  hadd %h /^blacktriangle$/1553 $chr($base(25B4, 16, 10))
  hadd %h /^utri$/1554 $chr($base(25B5, 16, 10))
  hadd %h /^triangle$/1555 $chr($base(25B5, 16, 10))
  hadd %h /^rtrif$/1556 $chr($base(25B8, 16, 10))
  hadd %h /^blacktriangleright$/1557 $chr($base(25B8, 16, 10))
  hadd %h /^rtri$/1558 $chr($base(25B9, 16, 10))
  hadd %h /^triangleright$/1559 $chr($base(25B9, 16, 10))
  hadd %h /^xdtri$/1560 $chr($base(25BD, 16, 10))
  hadd %h /^bigtriangledown$/1561 $chr($base(25BD, 16, 10))
  hadd %h /^dtrif$/1562 $chr($base(25BE, 16, 10))
  hadd %h /^blacktriangledown$/1563 $chr($base(25BE, 16, 10))
  hadd %h /^dtri$/1564 $chr($base(25BF, 16, 10))
  hadd %h /^triangledown$/1565 $chr($base(25BF, 16, 10))
  hadd %h /^ltrif$/1566 $chr($base(25C2, 16, 10))
  hadd %h /^blacktriangleleft$/1567 $chr($base(25C2, 16, 10))
  hadd %h /^ltri$/1568 $chr($base(25C3, 16, 10))
  hadd %h /^triangleleft$/1569 $chr($base(25C3, 16, 10))
  hadd %h /^loz$/1570 $chr($base(25CA, 16, 10))
  hadd %h /^lozenge$/1571 $chr($base(25CA, 16, 10))
  hadd %h /^cir$/1572 $chr($base(25CB, 16, 10))
  hadd %h /^tridot$/1573 $chr($base(25EC, 16, 10))
  hadd %h /^xcirc$/1574 $chr($base(25EF, 16, 10))
  hadd %h /^bigcirc$/1575 $chr($base(25EF, 16, 10))
  hadd %h /^ultri$/1576 $chr($base(25F8, 16, 10))
  hadd %h /^urtri$/1577 $chr($base(25F9, 16, 10))
  hadd %h /^lltri$/1578 $chr($base(25FA, 16, 10))
  hadd %h /^EmptySmallSquare$/1579 $chr($base(25FB, 16, 10))
  hadd %h /^FilledSmallSquare$/1580 $chr($base(25FC, 16, 10))
  hadd %h /^starf$/1581 $chr($base(2605, 16, 10))
  hadd %h /^bigstar$/1582 $chr($base(2605, 16, 10))
  hadd %h /^star$/1583 $chr($base(2606, 16, 10))
  hadd %h /^phone$/1584 $chr($base(260E, 16, 10))
  hadd %h /^female$/1585 $chr($base(2640, 16, 10))
  hadd %h /^male$/1586 $chr($base(2642, 16, 10))
  hadd %h /^spades$/1587 $chr($base(2660, 16, 10))
  hadd %h /^spadesuit$/1588 $chr($base(2660, 16, 10))
  hadd %h /^clubs$/1589 $chr($base(2663, 16, 10))
  hadd %h /^clubsuit$/1590 $chr($base(2663, 16, 10))
  hadd %h /^hearts$/1591 $chr($base(2665, 16, 10))
  hadd %h /^heartsuit$/1592 $chr($base(2665, 16, 10))
  hadd %h /^diams$/1593 $chr($base(2666, 16, 10))
  hadd %h /^diamondsuit$/1594 $chr($base(2666, 16, 10))
  hadd %h /^sung$/1595 $chr($base(266A, 16, 10))
  hadd %h /^flat$/1596 $chr($base(266D, 16, 10))
  hadd %h /^natur$/1597 $chr($base(266E, 16, 10))
  hadd %h /^natural$/1598 $chr($base(266E, 16, 10))
  hadd %h /^sharp$/1599 $chr($base(266F, 16, 10))
  hadd %h /^check$/1600 $chr($base(2713, 16, 10))
  hadd %h /^checkmark$/1601 $chr($base(2713, 16, 10))
  hadd %h /^cross$/1602 $chr($base(2717, 16, 10))
  hadd %h /^malt$/1603 $chr($base(2720, 16, 10))
  hadd %h /^maltese$/1604 $chr($base(2720, 16, 10))
  hadd %h /^sext$/1605 $chr($base(2736, 16, 10))
  hadd %h /^VerticalSeparator$/1606 $chr($base(2758, 16, 10))
  hadd %h /^lbbrk$/1607 $chr($base(2772, 16, 10))
  hadd %h /^rbbrk$/1608 $chr($base(2773, 16, 10))
  hadd %h /^bsolhsub$/1609 $chr($base(27C8, 16, 10))
  hadd %h /^suphsol$/1610 $chr($base(27C9, 16, 10))
  hadd %h /^lobrk$/1611 $chr($base(27E6, 16, 10))
  hadd %h /^LeftDoubleBracket$/1612 $chr($base(27E6, 16, 10))
  hadd %h /^robrk$/1613 $chr($base(27E7, 16, 10))
  hadd %h /^RightDoubleBracket$/1614 $chr($base(27E7, 16, 10))
  hadd %h /^lang$/1615 $chr($base(27E8, 16, 10))
  hadd %h /^LeftAngleBracket$/1616 $chr($base(27E8, 16, 10))
  hadd %h /^langle$/1617 $chr($base(27E8, 16, 10))
  hadd %h /^rang$/1618 $chr($base(27E9, 16, 10))
  hadd %h /^RightAngleBracket$/1619 $chr($base(27E9, 16, 10))
  hadd %h /^rangle$/1620 $chr($base(27E9, 16, 10))
  hadd %h /^Lang$/1621 $chr($base(27EA, 16, 10))
  hadd %h /^Rang$/1622 $chr($base(27EB, 16, 10))
  hadd %h /^loang$/1623 $chr($base(27EC, 16, 10))
  hadd %h /^roang$/1624 $chr($base(27ED, 16, 10))
  hadd %h /^xlarr$/1625 $chr($base(27F5, 16, 10))
  hadd %h /^longleftarrow$/1626 $chr($base(27F5, 16, 10))
  hadd %h /^LongLeftArrow$/1627 $chr($base(27F5, 16, 10))
  hadd %h /^xrarr$/1628 $chr($base(27F6, 16, 10))
  hadd %h /^longrightarrow$/1629 $chr($base(27F6, 16, 10))
  hadd %h /^LongRightArrow$/1630 $chr($base(27F6, 16, 10))
  hadd %h /^xharr$/1631 $chr($base(27F7, 16, 10))
  hadd %h /^longleftrightarrow$/1632 $chr($base(27F7, 16, 10))
  hadd %h /^LongLeftRightArrow$/1633 $chr($base(27F7, 16, 10))
  hadd %h /^xlArr$/1634 $chr($base(27F8, 16, 10))
  hadd %h /^Longleftarrow$/1635 $chr($base(27F8, 16, 10))
  hadd %h /^DoubleLongLeftArrow$/1636 $chr($base(27F8, 16, 10))
  hadd %h /^xrArr$/1637 $chr($base(27F9, 16, 10))
  hadd %h /^Longrightarrow$/1638 $chr($base(27F9, 16, 10))
  hadd %h /^DoubleLongRightArrow$/1639 $chr($base(27F9, 16, 10))
  hadd %h /^xhArr$/1640 $chr($base(27FA, 16, 10))
  hadd %h /^Longleftrightarrow$/1641 $chr($base(27FA, 16, 10))
  hadd %h /^DoubleLongLeftRightArrow$/1642 $chr($base(27FA, 16, 10))
  hadd %h /^xmap$/1643 $chr($base(27FC, 16, 10))
  hadd %h /^longmapsto$/1644 $chr($base(27FC, 16, 10))
  hadd %h /^dzigrarr$/1645 $chr($base(27FF, 16, 10))
  hadd %h /^nvlArr$/1646 $chr($base(2902, 16, 10))
  hadd %h /^nvrArr$/1647 $chr($base(2903, 16, 10))
  hadd %h /^nvHarr$/1648 $chr($base(2904, 16, 10))
  hadd %h /^Map$/1649 $chr($base(2905, 16, 10))
  hadd %h /^lbarr$/1650 $chr($base(290C, 16, 10))
  hadd %h /^rbarr$/1651 $chr($base(290D, 16, 10))
  hadd %h /^bkarow$/1652 $chr($base(290D, 16, 10))
  hadd %h /^lBarr$/1653 $chr($base(290E, 16, 10))
  hadd %h /^rBarr$/1654 $chr($base(290F, 16, 10))
  hadd %h /^dbkarow$/1655 $chr($base(290F, 16, 10))
  hadd %h /^RBarr$/1656 $chr($base(2910, 16, 10))
  hadd %h /^drbkarow$/1657 $chr($base(2910, 16, 10))
  hadd %h /^DDotrahd$/1658 $chr($base(2911, 16, 10))
  hadd %h /^UpArrowBar$/1659 $chr($base(2912, 16, 10))
  hadd %h /^DownArrowBar$/1660 $chr($base(2913, 16, 10))
  hadd %h /^Rarrtl$/1661 $chr($base(2916, 16, 10))
  hadd %h /^latail$/1662 $chr($base(2919, 16, 10))
  hadd %h /^ratail$/1663 $chr($base(291A, 16, 10))
  hadd %h /^lAtail$/1664 $chr($base(291B, 16, 10))
  hadd %h /^rAtail$/1665 $chr($base(291C, 16, 10))
  hadd %h /^larrfs$/1666 $chr($base(291D, 16, 10))
  hadd %h /^rarrfs$/1667 $chr($base(291E, 16, 10))
  hadd %h /^larrbfs$/1668 $chr($base(291F, 16, 10))
  hadd %h /^rarrbfs$/1669 $chr($base(2920, 16, 10))
  hadd %h /^nwarhk$/1670 $chr($base(2923, 16, 10))
  hadd %h /^nearhk$/1671 $chr($base(2924, 16, 10))
  hadd %h /^searhk$/1672 $chr($base(2925, 16, 10))
  hadd %h /^hksearow$/1673 $chr($base(2925, 16, 10))
  hadd %h /^swarhk$/1674 $chr($base(2926, 16, 10))
  hadd %h /^hkswarow$/1675 $chr($base(2926, 16, 10))
  hadd %h /^nwnear$/1676 $chr($base(2927, 16, 10))
  hadd %h /^nesear$/1677 $chr($base(2928, 16, 10))
  hadd %h /^toea$/1678 $chr($base(2928, 16, 10))
  hadd %h /^seswar$/1679 $chr($base(2929, 16, 10))
  hadd %h /^tosa$/1680 $chr($base(2929, 16, 10))
  hadd %h /^swnwar$/1681 $chr($base(292A, 16, 10))
  hadd %h /^rarrc$/1682 $chr($base(2933, 16, 10))
  hadd %h /^nrarrc$/1683 $chr($base(2933, 16, 10)) $+ $chr($base(0338, 16, 10))
  hadd %h /^cudarrr$/1684 $chr($base(2935, 16, 10))
  hadd %h /^ldca$/1685 $chr($base(2936, 16, 10))
  hadd %h /^rdca$/1686 $chr($base(2937, 16, 10))
  hadd %h /^cudarrl$/1687 $chr($base(2938, 16, 10))
  hadd %h /^larrpl$/1688 $chr($base(2939, 16, 10))
  hadd %h /^curarrm$/1689 $chr($base(293C, 16, 10))
  hadd %h /^cularrp$/1690 $chr($base(293D, 16, 10))
  hadd %h /^rarrpl$/1691 $chr($base(2945, 16, 10))
  hadd %h /^harrcir$/1692 $chr($base(2948, 16, 10))
  hadd %h /^Uarrocir$/1693 $chr($base(2949, 16, 10))
  hadd %h /^lurdshar$/1694 $chr($base(294A, 16, 10))
  hadd %h /^ldrushar$/1695 $chr($base(294B, 16, 10))
  hadd %h /^LeftRightVector$/1696 $chr($base(294E, 16, 10))
  hadd %h /^RightUpDownVector$/1697 $chr($base(294F, 16, 10))
  hadd %h /^DownLeftRightVector$/1698 $chr($base(2950, 16, 10))
  hadd %h /^LeftUpDownVector$/1699 $chr($base(2951, 16, 10))
  hadd %h /^LeftVectorBar$/1700 $chr($base(2952, 16, 10))
  hadd %h /^RightVectorBar$/1701 $chr($base(2953, 16, 10))
  hadd %h /^RightUpVectorBar$/1702 $chr($base(2954, 16, 10))
  hadd %h /^RightDownVectorBar$/1703 $chr($base(2955, 16, 10))
  hadd %h /^DownLeftVectorBar$/1704 $chr($base(2956, 16, 10))
  hadd %h /^DownRightVectorBar$/1705 $chr($base(2957, 16, 10))
  hadd %h /^LeftUpVectorBar$/1706 $chr($base(2958, 16, 10))
  hadd %h /^LeftDownVectorBar$/1707 $chr($base(2959, 16, 10))
  hadd %h /^LeftTeeVector$/1708 $chr($base(295A, 16, 10))
  hadd %h /^RightTeeVector$/1709 $chr($base(295B, 16, 10))
  hadd %h /^RightUpTeeVector$/1710 $chr($base(295C, 16, 10))
  hadd %h /^RightDownTeeVector$/1711 $chr($base(295D, 16, 10))
  hadd %h /^DownLeftTeeVector$/1712 $chr($base(295E, 16, 10))
  hadd %h /^DownRightTeeVector$/1713 $chr($base(295F, 16, 10))
  hadd %h /^LeftUpTeeVector$/1714 $chr($base(2960, 16, 10))
  hadd %h /^LeftDownTeeVector$/1715 $chr($base(2961, 16, 10))
  hadd %h /^lHar$/1716 $chr($base(2962, 16, 10))
  hadd %h /^uHar$/1717 $chr($base(2963, 16, 10))
  hadd %h /^rHar$/1718 $chr($base(2964, 16, 10))
  hadd %h /^dHar$/1719 $chr($base(2965, 16, 10))
  hadd %h /^luruhar$/1720 $chr($base(2966, 16, 10))
  hadd %h /^ldrdhar$/1721 $chr($base(2967, 16, 10))
  hadd %h /^ruluhar$/1722 $chr($base(2968, 16, 10))
  hadd %h /^rdldhar$/1723 $chr($base(2969, 16, 10))
  hadd %h /^lharul$/1724 $chr($base(296A, 16, 10))
  hadd %h /^llhard$/1725 $chr($base(296B, 16, 10))
  hadd %h /^rharul$/1726 $chr($base(296C, 16, 10))
  hadd %h /^lrhard$/1727 $chr($base(296D, 16, 10))
  hadd %h /^udhar$/1728 $chr($base(296E, 16, 10))
  hadd %h /^UpEquilibrium$/1729 $chr($base(296E, 16, 10))
  hadd %h /^duhar$/1730 $chr($base(296F, 16, 10))
  hadd %h /^ReverseUpEquilibrium$/1731 $chr($base(296F, 16, 10))
  hadd %h /^RoundImplies$/1732 $chr($base(2970, 16, 10))
  hadd %h /^erarr$/1733 $chr($base(2971, 16, 10))
  hadd %h /^simrarr$/1734 $chr($base(2972, 16, 10))
  hadd %h /^larrsim$/1735 $chr($base(2973, 16, 10))
  hadd %h /^rarrsim$/1736 $chr($base(2974, 16, 10))
  hadd %h /^rarrap$/1737 $chr($base(2975, 16, 10))
  hadd %h /^ltlarr$/1738 $chr($base(2976, 16, 10))
  hadd %h /^gtrarr$/1739 $chr($base(2978, 16, 10))
  hadd %h /^subrarr$/1740 $chr($base(2979, 16, 10))
  hadd %h /^suplarr$/1741 $chr($base(297B, 16, 10))
  hadd %h /^lfisht$/1742 $chr($base(297C, 16, 10))
  hadd %h /^rfisht$/1743 $chr($base(297D, 16, 10))
  hadd %h /^ufisht$/1744 $chr($base(297E, 16, 10))
  hadd %h /^dfisht$/1745 $chr($base(297F, 16, 10))
  hadd %h /^lopar$/1746 $chr($base(2985, 16, 10))
  hadd %h /^ropar$/1747 $chr($base(2986, 16, 10))
  hadd %h /^lbrke$/1748 $chr($base(298B, 16, 10))
  hadd %h /^rbrke$/1749 $chr($base(298C, 16, 10))
  hadd %h /^lbrkslu$/1750 $chr($base(298D, 16, 10))
  hadd %h /^rbrksld$/1751 $chr($base(298E, 16, 10))
  hadd %h /^lbrksld$/1752 $chr($base(298F, 16, 10))
  hadd %h /^rbrkslu$/1753 $chr($base(2990, 16, 10))
  hadd %h /^langd$/1754 $chr($base(2991, 16, 10))
  hadd %h /^rangd$/1755 $chr($base(2992, 16, 10))
  hadd %h /^lparlt$/1756 $chr($base(2993, 16, 10))
  hadd %h /^rpargt$/1757 $chr($base(2994, 16, 10))
  hadd %h /^gtlPar$/1758 $chr($base(2995, 16, 10))
  hadd %h /^ltrPar$/1759 $chr($base(2996, 16, 10))
  hadd %h /^vzigzag$/1760 $chr($base(299A, 16, 10))
  hadd %h /^vangrt$/1761 $chr($base(299C, 16, 10))
  hadd %h /^angrtvbd$/1762 $chr($base(299D, 16, 10))
  hadd %h /^ange$/1763 $chr($base(29A4, 16, 10))
  hadd %h /^range$/1764 $chr($base(29A5, 16, 10))
  hadd %h /^dwangle$/1765 $chr($base(29A6, 16, 10))
  hadd %h /^uwangle$/1766 $chr($base(29A7, 16, 10))
  hadd %h /^angmsdaa$/1767 $chr($base(29A8, 16, 10))
  hadd %h /^angmsdab$/1768 $chr($base(29A9, 16, 10))
  hadd %h /^angmsdac$/1769 $chr($base(29AA, 16, 10))
  hadd %h /^angmsdad$/1770 $chr($base(29AB, 16, 10))
  hadd %h /^angmsdae$/1771 $chr($base(29AC, 16, 10))
  hadd %h /^angmsdaf$/1772 $chr($base(29AD, 16, 10))
  hadd %h /^angmsdag$/1773 $chr($base(29AE, 16, 10))
  hadd %h /^angmsdah$/1774 $chr($base(29AF, 16, 10))
  hadd %h /^bemptyv$/1775 $chr($base(29B0, 16, 10))
  hadd %h /^demptyv$/1776 $chr($base(29B1, 16, 10))
  hadd %h /^cemptyv$/1777 $chr($base(29B2, 16, 10))
  hadd %h /^raemptyv$/1778 $chr($base(29B3, 16, 10))
  hadd %h /^laemptyv$/1779 $chr($base(29B4, 16, 10))
  hadd %h /^ohbar$/1780 $chr($base(29B5, 16, 10))
  hadd %h /^omid$/1781 $chr($base(29B6, 16, 10))
  hadd %h /^opar$/1782 $chr($base(29B7, 16, 10))
  hadd %h /^operp$/1783 $chr($base(29B9, 16, 10))
  hadd %h /^olcross$/1784 $chr($base(29BB, 16, 10))
  hadd %h /^odsold$/1785 $chr($base(29BC, 16, 10))
  hadd %h /^olcir$/1786 $chr($base(29BE, 16, 10))
  hadd %h /^ofcir$/1787 $chr($base(29BF, 16, 10))
  hadd %h /^olt$/1788 $chr($base(29C0, 16, 10))
  hadd %h /^ogt$/1789 $chr($base(29C1, 16, 10))
  hadd %h /^cirscir$/1790 $chr($base(29C2, 16, 10))
  hadd %h /^cirE$/1791 $chr($base(29C3, 16, 10))
  hadd %h /^solb$/1792 $chr($base(29C4, 16, 10))
  hadd %h /^bsolb$/1793 $chr($base(29C5, 16, 10))
  hadd %h /^boxbox$/1794 $chr($base(29C9, 16, 10))
  hadd %h /^trisb$/1795 $chr($base(29CD, 16, 10))
  hadd %h /^rtriltri$/1796 $chr($base(29CE, 16, 10))
  hadd %h /^LeftTriangleBar$/1797 $chr($base(29CF, 16, 10))
  hadd %h /^NotLeftTriangleBar$/1798 $chr($base(29CF, 16, 10)) $+ $chr($base(0338, 16, 10))
  hadd %h /^RightTriangleBar$/1799 $chr($base(29D0, 16, 10))
  hadd %h /^NotRightTriangleBar$/1800 $chr($base(29D0, 16, 10)) $+ $chr($base(0338, 16, 10))
  hadd %h /^iinfin$/1801 $chr($base(29DC, 16, 10))
  hadd %h /^infintie$/1802 $chr($base(29DD, 16, 10))
  hadd %h /^nvinfin$/1803 $chr($base(29DE, 16, 10))
  hadd %h /^eparsl$/1804 $chr($base(29E3, 16, 10))
  hadd %h /^smeparsl$/1805 $chr($base(29E4, 16, 10))
  hadd %h /^eqvparsl$/1806 $chr($base(29E5, 16, 10))
  hadd %h /^lozf$/1807 $chr($base(29EB, 16, 10))
  hadd %h /^blacklozenge$/1808 $chr($base(29EB, 16, 10))
  hadd %h /^RuleDelayed$/1809 $chr($base(29F4, 16, 10))
  hadd %h /^dsol$/1810 $chr($base(29F6, 16, 10))
  hadd %h /^xodot$/1811 $chr($base(2A00, 16, 10))
  hadd %h /^bigodot$/1812 $chr($base(2A00, 16, 10))
  hadd %h /^xoplus$/1813 $chr($base(2A01, 16, 10))
  hadd %h /^bigoplus$/1814 $chr($base(2A01, 16, 10))
  hadd %h /^xotime$/1815 $chr($base(2A02, 16, 10))
  hadd %h /^bigotimes$/1816 $chr($base(2A02, 16, 10))
  hadd %h /^xuplus$/1817 $chr($base(2A04, 16, 10))
  hadd %h /^biguplus$/1818 $chr($base(2A04, 16, 10))
  hadd %h /^xsqcup$/1819 $chr($base(2A06, 16, 10))
  hadd %h /^bigsqcup$/1820 $chr($base(2A06, 16, 10))
  hadd %h /^qint$/1821 $chr($base(2A0C, 16, 10))
  hadd %h /^iiiint$/1822 $chr($base(2A0C, 16, 10))
  hadd %h /^fpartint$/1823 $chr($base(2A0D, 16, 10))
  hadd %h /^cirfnint$/1824 $chr($base(2A10, 16, 10))
  hadd %h /^awint$/1825 $chr($base(2A11, 16, 10))
  hadd %h /^rppolint$/1826 $chr($base(2A12, 16, 10))
  hadd %h /^scpolint$/1827 $chr($base(2A13, 16, 10))
  hadd %h /^npolint$/1828 $chr($base(2A14, 16, 10))
  hadd %h /^pointint$/1829 $chr($base(2A15, 16, 10))
  hadd %h /^quatint$/1830 $chr($base(2A16, 16, 10))
  hadd %h /^intlarhk$/1831 $chr($base(2A17, 16, 10))
  hadd %h /^pluscir$/1832 $chr($base(2A22, 16, 10))
  hadd %h /^plusacir$/1833 $chr($base(2A23, 16, 10))
  hadd %h /^simplus$/1834 $chr($base(2A24, 16, 10))
  hadd %h /^plusdu$/1835 $chr($base(2A25, 16, 10))
  hadd %h /^plussim$/1836 $chr($base(2A26, 16, 10))
  hadd %h /^plustwo$/1837 $chr($base(2A27, 16, 10))
  hadd %h /^mcomma$/1838 $chr($base(2A29, 16, 10))
  hadd %h /^minusdu$/1839 $chr($base(2A2A, 16, 10))
  hadd %h /^loplus$/1840 $chr($base(2A2D, 16, 10))
  hadd %h /^roplus$/1841 $chr($base(2A2E, 16, 10))
  hadd %h /^Cross$/1842 $chr($base(2A2F, 16, 10))
  hadd %h /^timesd$/1843 $chr($base(2A30, 16, 10))
  hadd %h /^timesbar$/1844 $chr($base(2A31, 16, 10))
  hadd %h /^smashp$/1845 $chr($base(2A33, 16, 10))
  hadd %h /^lotimes$/1846 $chr($base(2A34, 16, 10))
  hadd %h /^rotimes$/1847 $chr($base(2A35, 16, 10))
  hadd %h /^otimesas$/1848 $chr($base(2A36, 16, 10))
  hadd %h /^Otimes$/1849 $chr($base(2A37, 16, 10))
  hadd %h /^odiv$/1850 $chr($base(2A38, 16, 10))
  hadd %h /^triplus$/1851 $chr($base(2A39, 16, 10))
  hadd %h /^triminus$/1852 $chr($base(2A3A, 16, 10))
  hadd %h /^tritime$/1853 $chr($base(2A3B, 16, 10))
  hadd %h /^iprod$/1854 $chr($base(2A3C, 16, 10))
  hadd %h /^intprod$/1855 $chr($base(2A3C, 16, 10))
  hadd %h /^amalg$/1856 $chr($base(2A3F, 16, 10))
  hadd %h /^capdot$/1857 $chr($base(2A40, 16, 10))
  hadd %h /^ncup$/1858 $chr($base(2A42, 16, 10))
  hadd %h /^ncap$/1859 $chr($base(2A43, 16, 10))
  hadd %h /^capand$/1860 $chr($base(2A44, 16, 10))
  hadd %h /^cupor$/1861 $chr($base(2A45, 16, 10))
  hadd %h /^cupcap$/1862 $chr($base(2A46, 16, 10))
  hadd %h /^capcup$/1863 $chr($base(2A47, 16, 10))
  hadd %h /^cupbrcap$/1864 $chr($base(2A48, 16, 10))
  hadd %h /^capbrcup$/1865 $chr($base(2A49, 16, 10))
  hadd %h /^cupcup$/1866 $chr($base(2A4A, 16, 10))
  hadd %h /^capcap$/1867 $chr($base(2A4B, 16, 10))
  hadd %h /^ccups$/1868 $chr($base(2A4C, 16, 10))
  hadd %h /^ccaps$/1869 $chr($base(2A4D, 16, 10))
  hadd %h /^ccupssm$/1870 $chr($base(2A50, 16, 10))
  hadd %h /^And$/1871 $chr($base(2A53, 16, 10))
  hadd %h /^Or$/1872 $chr($base(2A54, 16, 10))
  hadd %h /^andand$/1873 $chr($base(2A55, 16, 10))
  hadd %h /^oror$/1874 $chr($base(2A56, 16, 10))
  hadd %h /^orslope$/1875 $chr($base(2A57, 16, 10))
  hadd %h /^andslope$/1876 $chr($base(2A58, 16, 10))
  hadd %h /^andv$/1877 $chr($base(2A5A, 16, 10))
  hadd %h /^orv$/1878 $chr($base(2A5B, 16, 10))
  hadd %h /^andd$/1879 $chr($base(2A5C, 16, 10))
  hadd %h /^ord$/1880 $chr($base(2A5D, 16, 10))
  hadd %h /^wedbar$/1881 $chr($base(2A5F, 16, 10))
  hadd %h /^sdote$/1882 $chr($base(2A66, 16, 10))
  hadd %h /^simdot$/1883 $chr($base(2A6A, 16, 10))
  hadd %h /^congdot$/1884 $chr($base(2A6D, 16, 10))
  hadd %h /^ncongdot$/1885 $chr($base(2A6D, 16, 10)) $+ $chr($base(0338, 16, 10))
  hadd %h /^easter$/1886 $chr($base(2A6E, 16, 10))
  hadd %h /^apacir$/1887 $chr($base(2A6F, 16, 10))
  hadd %h /^apE$/1888 $chr($base(2A70, 16, 10))
  hadd %h /^napE$/1889 $chr($base(2A70, 16, 10)) $+ $chr($base(0338, 16, 10))
  hadd %h /^eplus$/1890 $chr($base(2A71, 16, 10))
  hadd %h /^pluse$/1891 $chr($base(2A72, 16, 10))
  hadd %h /^Esim$/1892 $chr($base(2A73, 16, 10))
  hadd %h /^Colone$/1893 $chr($base(2A74, 16, 10))
  hadd %h /^Equal$/1894 $chr($base(2A75, 16, 10))
  hadd %h /^eDDot$/1895 $chr($base(2A77, 16, 10))
  hadd %h /^ddotseq$/1896 $chr($base(2A77, 16, 10))
  hadd %h /^equivDD$/1897 $chr($base(2A78, 16, 10))
  hadd %h /^ltcir$/1898 $chr($base(2A79, 16, 10))
  hadd %h /^gtcir$/1899 $chr($base(2A7A, 16, 10))
  hadd %h /^ltquest$/1900 $chr($base(2A7B, 16, 10))
  hadd %h /^gtquest$/1901 $chr($base(2A7C, 16, 10))
  hadd %h /^les$/1902 $chr($base(2A7D, 16, 10))
  hadd %h /^LessSlantEqual$/1903 $chr($base(2A7D, 16, 10))
  hadd %h /^leqslant$/1904 $chr($base(2A7D, 16, 10))
  hadd %h /^nles$/1905 $chr($base(2A7D, 16, 10)) $+ $chr($base(0338, 16, 10))
  hadd %h /^NotLessSlantEqual$/1906 $chr($base(2A7D, 16, 10)) $+ $chr($base(0338, 16, 10))
  hadd %h /^nleqslant$/1907 $chr($base(2A7D, 16, 10)) $+ $chr($base(0338, 16, 10))
  hadd %h /^ges$/1908 $chr($base(2A7E, 16, 10))
  hadd %h /^GreaterSlantEqual$/1909 $chr($base(2A7E, 16, 10))
  hadd %h /^geqslant$/1910 $chr($base(2A7E, 16, 10))
  hadd %h /^nges$/1911 $chr($base(2A7E, 16, 10)) $+ $chr($base(0338, 16, 10))
  hadd %h /^NotGreaterSlantEqual$/1912 $chr($base(2A7E, 16, 10)) $+ $chr($base(0338, 16, 10))
  hadd %h /^ngeqslant$/1913 $chr($base(2A7E, 16, 10)) $+ $chr($base(0338, 16, 10))
  hadd %h /^lesdot$/1914 $chr($base(2A7F, 16, 10))
  hadd %h /^gesdot$/1915 $chr($base(2A80, 16, 10))
  hadd %h /^lesdoto$/1916 $chr($base(2A81, 16, 10))
  hadd %h /^gesdoto$/1917 $chr($base(2A82, 16, 10))
  hadd %h /^lesdotor$/1918 $chr($base(2A83, 16, 10))
  hadd %h /^gesdotol$/1919 $chr($base(2A84, 16, 10))
  hadd %h /^lap$/1920 $chr($base(2A85, 16, 10))
  hadd %h /^lessapprox$/1921 $chr($base(2A85, 16, 10))
  hadd %h /^gap$/1922 $chr($base(2A86, 16, 10))
  hadd %h /^gtrapprox$/1923 $chr($base(2A86, 16, 10))
  hadd %h /^lne$/1924 $chr($base(2A87, 16, 10))
  hadd %h /^lneq$/1925 $chr($base(2A87, 16, 10))
  hadd %h /^gne$/1926 $chr($base(2A88, 16, 10))
  hadd %h /^gneq$/1927 $chr($base(2A88, 16, 10))
  hadd %h /^lnap$/1928 $chr($base(2A89, 16, 10))
  hadd %h /^lnapprox$/1929 $chr($base(2A89, 16, 10))
  hadd %h /^gnap$/1930 $chr($base(2A8A, 16, 10))
  hadd %h /^gnapprox$/1931 $chr($base(2A8A, 16, 10))
  hadd %h /^lEg$/1932 $chr($base(2A8B, 16, 10))
  hadd %h /^lesseqqgtr$/1933 $chr($base(2A8B, 16, 10))
  hadd %h /^gEl$/1934 $chr($base(2A8C, 16, 10))
  hadd %h /^gtreqqless$/1935 $chr($base(2A8C, 16, 10))
  hadd %h /^lsime$/1936 $chr($base(2A8D, 16, 10))
  hadd %h /^gsime$/1937 $chr($base(2A8E, 16, 10))
  hadd %h /^lsimg$/1938 $chr($base(2A8F, 16, 10))
  hadd %h /^gsiml$/1939 $chr($base(2A90, 16, 10))
  hadd %h /^lgE$/1940 $chr($base(2A91, 16, 10))
  hadd %h /^glE$/1941 $chr($base(2A92, 16, 10))
  hadd %h /^lesges$/1942 $chr($base(2A93, 16, 10))
  hadd %h /^gesles$/1943 $chr($base(2A94, 16, 10))
  hadd %h /^els$/1944 $chr($base(2A95, 16, 10))
  hadd %h /^eqslantless$/1945 $chr($base(2A95, 16, 10))
  hadd %h /^egs$/1946 $chr($base(2A96, 16, 10))
  hadd %h /^eqslantgtr$/1947 $chr($base(2A96, 16, 10))
  hadd %h /^elsdot$/1948 $chr($base(2A97, 16, 10))
  hadd %h /^egsdot$/1949 $chr($base(2A98, 16, 10))
  hadd %h /^el$/1950 $chr($base(2A99, 16, 10))
  hadd %h /^eg$/1951 $chr($base(2A9A, 16, 10))
  hadd %h /^siml$/1952 $chr($base(2A9D, 16, 10))
  hadd %h /^simg$/1953 $chr($base(2A9E, 16, 10))
  hadd %h /^simlE$/1954 $chr($base(2A9F, 16, 10))
  hadd %h /^simgE$/1955 $chr($base(2AA0, 16, 10))
  hadd %h /^LessLess$/1956 $chr($base(2AA1, 16, 10))
  hadd %h /^NotNestedLessLess$/1957 $chr($base(2AA1, 16, 10)) $+ $chr($base(0338, 16, 10))
  hadd %h /^GreaterGreater$/1958 $chr($base(2AA2, 16, 10))
  hadd %h /^NotNestedGreaterGreater$/1959 $chr($base(2AA2, 16, 10)) $+ $chr($base(0338, 16, 10))
  hadd %h /^glj$/1960 $chr($base(2AA4, 16, 10))
  hadd %h /^gla$/1961 $chr($base(2AA5, 16, 10))
  hadd %h /^ltcc$/1962 $chr($base(2AA6, 16, 10))
  hadd %h /^gtcc$/1963 $chr($base(2AA7, 16, 10))
  hadd %h /^lescc$/1964 $chr($base(2AA8, 16, 10))
  hadd %h /^gescc$/1965 $chr($base(2AA9, 16, 10))
  hadd %h /^smt$/1966 $chr($base(2AAA, 16, 10))
  hadd %h /^lat$/1967 $chr($base(2AAB, 16, 10))
  hadd %h /^smte$/1968 $chr($base(2AAC, 16, 10))
  hadd %h /^smtes$/1969 $chr($base(2AAC, 16, 10)) $+ $chr($base(FE00, 16, 10))
  hadd %h /^late$/1970 $chr($base(2AAD, 16, 10))
  hadd %h /^lates$/1971 $chr($base(2AAD, 16, 10)) $+ $chr($base(FE00, 16, 10))
  hadd %h /^bumpE$/1972 $chr($base(2AAE, 16, 10))
  hadd %h /^pre$/1973 $chr($base(2AAF, 16, 10))
  hadd %h /^preceq$/1974 $chr($base(2AAF, 16, 10))
  hadd %h /^PrecedesEqual$/1975 $chr($base(2AAF, 16, 10))
  hadd %h /^npre$/1976 $chr($base(2AAF, 16, 10)) $+ $chr($base(0338, 16, 10))
  hadd %h /^npreceq$/1977 $chr($base(2AAF, 16, 10)) $+ $chr($base(0338, 16, 10))
  hadd %h /^NotPrecedesEqual$/1978 $chr($base(2AAF, 16, 10)) $+ $chr($base(0338, 16, 10))
  hadd %h /^sce$/1979 $chr($base(2AB0, 16, 10))
  hadd %h /^succeq$/1980 $chr($base(2AB0, 16, 10))
  hadd %h /^SucceedsEqual$/1981 $chr($base(2AB0, 16, 10))
  hadd %h /^nsce$/1982 $chr($base(2AB0, 16, 10)) $+ $chr($base(0338, 16, 10))
  hadd %h /^nsucceq$/1983 $chr($base(2AB0, 16, 10)) $+ $chr($base(0338, 16, 10))
  hadd %h /^NotSucceedsEqual$/1984 $chr($base(2AB0, 16, 10)) $+ $chr($base(0338, 16, 10))
  hadd %h /^prE$/1985 $chr($base(2AB3, 16, 10))
  hadd %h /^scE$/1986 $chr($base(2AB4, 16, 10))
  hadd %h /^prnE$/1987 $chr($base(2AB5, 16, 10))
  hadd %h /^precneqq$/1988 $chr($base(2AB5, 16, 10))
  hadd %h /^scnE$/1989 $chr($base(2AB6, 16, 10))
  hadd %h /^succneqq$/1990 $chr($base(2AB6, 16, 10))
  hadd %h /^prap$/1991 $chr($base(2AB7, 16, 10))
  hadd %h /^precapprox$/1992 $chr($base(2AB7, 16, 10))
  hadd %h /^scap$/1993 $chr($base(2AB8, 16, 10))
  hadd %h /^succapprox$/1994 $chr($base(2AB8, 16, 10))
  hadd %h /^prnap$/1995 $chr($base(2AB9, 16, 10))
  hadd %h /^precnapprox$/1996 $chr($base(2AB9, 16, 10))
  hadd %h /^scnap$/1997 $chr($base(2ABA, 16, 10))
  hadd %h /^succnapprox$/1998 $chr($base(2ABA, 16, 10))
  hadd %h /^Pr$/1999 $chr($base(2ABB, 16, 10))
  hadd %h /^Sc$/2000 $chr($base(2ABC, 16, 10))
  hadd %h /^subdot$/2001 $chr($base(2ABD, 16, 10))
  hadd %h /^supdot$/2002 $chr($base(2ABE, 16, 10))
  hadd %h /^subplus$/2003 $chr($base(2ABF, 16, 10))
  hadd %h /^supplus$/2004 $chr($base(2AC0, 16, 10))
  hadd %h /^submult$/2005 $chr($base(2AC1, 16, 10))
  hadd %h /^supmult$/2006 $chr($base(2AC2, 16, 10))
  hadd %h /^subedot$/2007 $chr($base(2AC3, 16, 10))
  hadd %h /^supedot$/2008 $chr($base(2AC4, 16, 10))
  hadd %h /^subE$/2009 $chr($base(2AC5, 16, 10))
  hadd %h /^subseteqq$/2010 $chr($base(2AC5, 16, 10))
  hadd %h /^nsubE$/2011 $chr($base(2AC5, 16, 10)) $+ $chr($base(0338, 16, 10))
  hadd %h /^nsubseteqq$/2012 $chr($base(2AC5, 16, 10)) $+ $chr($base(0338, 16, 10))
  hadd %h /^supE$/2013 $chr($base(2AC6, 16, 10))
  hadd %h /^supseteqq$/2014 $chr($base(2AC6, 16, 10))
  hadd %h /^nsupE$/2015 $chr($base(2AC6, 16, 10)) $+ $chr($base(0338, 16, 10))
  hadd %h /^nsupseteqq$/2016 $chr($base(2AC6, 16, 10)) $+ $chr($base(0338, 16, 10))
  hadd %h /^subsim$/2017 $chr($base(2AC7, 16, 10))
  hadd %h /^supsim$/2018 $chr($base(2AC8, 16, 10))
  hadd %h /^subnE$/2019 $chr($base(2ACB, 16, 10))
  hadd %h /^subsetneqq$/2020 $chr($base(2ACB, 16, 10))
  hadd %h /^vsubnE$/2021 $chr($base(2ACB, 16, 10)) $+ $chr($base(FE00, 16, 10))
  hadd %h /^varsubsetneqq$/2022 $chr($base(2ACB, 16, 10)) $+ $chr($base(FE00, 16, 10))
  hadd %h /^supnE$/2023 $chr($base(2ACC, 16, 10))
  hadd %h /^supsetneqq$/2024 $chr($base(2ACC, 16, 10))
  hadd %h /^vsupnE$/2025 $chr($base(2ACC, 16, 10)) $+ $chr($base(FE00, 16, 10))
  hadd %h /^varsupsetneqq$/2026 $chr($base(2ACC, 16, 10)) $+ $chr($base(FE00, 16, 10))
  hadd %h /^csub$/2027 $chr($base(2ACF, 16, 10))
  hadd %h /^csup$/2028 $chr($base(2AD0, 16, 10))
  hadd %h /^csube$/2029 $chr($base(2AD1, 16, 10))
  hadd %h /^csupe$/2030 $chr($base(2AD2, 16, 10))
  hadd %h /^subsup$/2031 $chr($base(2AD3, 16, 10))
  hadd %h /^supsub$/2032 $chr($base(2AD4, 16, 10))
  hadd %h /^subsub$/2033 $chr($base(2AD5, 16, 10))
  hadd %h /^supsup$/2034 $chr($base(2AD6, 16, 10))
  hadd %h /^suphsub$/2035 $chr($base(2AD7, 16, 10))
  hadd %h /^supdsub$/2036 $chr($base(2AD8, 16, 10))
  hadd %h /^forkv$/2037 $chr($base(2AD9, 16, 10))
  hadd %h /^topfork$/2038 $chr($base(2ADA, 16, 10))
  hadd %h /^mlcp$/2039 $chr($base(2ADB, 16, 10))
  hadd %h /^Dashv$/2040 $chr($base(2AE4, 16, 10))
  hadd %h /^DoubleLeftTee$/2041 $chr($base(2AE4, 16, 10))
  hadd %h /^Vdashl$/2042 $chr($base(2AE6, 16, 10))
  hadd %h /^Barv$/2043 $chr($base(2AE7, 16, 10))
  hadd %h /^vBar$/2044 $chr($base(2AE8, 16, 10))
  hadd %h /^vBarv$/2045 $chr($base(2AE9, 16, 10))
  hadd %h /^Vbar$/2046 $chr($base(2AEB, 16, 10))
  hadd %h /^Not$/2047 $chr($base(2AEC, 16, 10))
  hadd %h /^bNot$/2048 $chr($base(2AED, 16, 10))
  hadd %h /^rnmid$/2049 $chr($base(2AEE, 16, 10))
  hadd %h /^cirmid$/2050 $chr($base(2AEF, 16, 10))
  hadd %h /^midcir$/2051 $chr($base(2AF0, 16, 10))
  hadd %h /^topcir$/2052 $chr($base(2AF1, 16, 10))
  hadd %h /^nhpar$/2053 $chr($base(2AF2, 16, 10))
  hadd %h /^parsim$/2054 $chr($base(2AF3, 16, 10))
  hadd %h /^parsl$/2055 $chr($base(2AFD, 16, 10))
  hadd %h /^nparsl$/2056 $chr($base(2AFD, 16, 10)) $+ $chr($base(20E5, 16, 10))
  hadd %h /^fflig$/2057 $chr($base(FB00, 16, 10))
  hadd %h /^filig$/2058 $chr($base(FB01, 16, 10))
  hadd %h /^fllig$/2059 $chr($base(FB02, 16, 10))
  hadd %h /^ffilig$/2060 $chr($base(FB03, 16, 10))
  hadd %h /^ffllig$/2061 $chr($base(FB04, 16, 10))
  hadd %h /^Ascr$/2062 $chr($base(1D49C, 16, 10))
  hadd %h /^Cscr$/2063 $chr($base(1D49E, 16, 10))
  hadd %h /^Dscr$/2064 $chr($base(1D49F, 16, 10))
  hadd %h /^Gscr$/2065 $chr($base(1D4A2, 16, 10))
  hadd %h /^Jscr$/2066 $chr($base(1D4A5, 16, 10))
  hadd %h /^Kscr$/2067 $chr($base(1D4A6, 16, 10))
  hadd %h /^Nscr$/2068 $chr($base(1D4A9, 16, 10))
  hadd %h /^Oscr$/2069 $chr($base(1D4AA, 16, 10))
  hadd %h /^Pscr$/2070 $chr($base(1D4AB, 16, 10))
  hadd %h /^Qscr$/2071 $chr($base(1D4AC, 16, 10))
  hadd %h /^Sscr$/2072 $chr($base(1D4AE, 16, 10))
  hadd %h /^Tscr$/2073 $chr($base(1D4AF, 16, 10))
  hadd %h /^Uscr$/2074 $chr($base(1D4B0, 16, 10))
  hadd %h /^Vscr$/2075 $chr($base(1D4B1, 16, 10))
  hadd %h /^Wscr$/2076 $chr($base(1D4B2, 16, 10))
  hadd %h /^Xscr$/2077 $chr($base(1D4B3, 16, 10))
  hadd %h /^Yscr$/2078 $chr($base(1D4B4, 16, 10))
  hadd %h /^Zscr$/2079 $chr($base(1D4B5, 16, 10))
  hadd %h /^ascr$/2080 $chr($base(1D4B6, 16, 10))
  hadd %h /^bscr$/2081 $chr($base(1D4B7, 16, 10))
  hadd %h /^cscr$/2082 $chr($base(1D4B8, 16, 10))
  hadd %h /^dscr$/2083 $chr($base(1D4B9, 16, 10))
  hadd %h /^fscr$/2084 $chr($base(1D4BB, 16, 10))
  hadd %h /^hscr$/2085 $chr($base(1D4BD, 16, 10))
  hadd %h /^iscr$/2086 $chr($base(1D4BE, 16, 10))
  hadd %h /^jscr$/2087 $chr($base(1D4BF, 16, 10))
  hadd %h /^kscr$/2088 $chr($base(1D4C0, 16, 10))
  hadd %h /^lscr$/2089 $chr($base(1D4C1, 16, 10))
  hadd %h /^mscr$/2090 $chr($base(1D4C2, 16, 10))
  hadd %h /^nscr$/2091 $chr($base(1D4C3, 16, 10))
  hadd %h /^pscr$/2092 $chr($base(1D4C5, 16, 10))
  hadd %h /^qscr$/2093 $chr($base(1D4C6, 16, 10))
  hadd %h /^rscr$/2094 $chr($base(1D4C7, 16, 10))
  hadd %h /^sscr$/2095 $chr($base(1D4C8, 16, 10))
  hadd %h /^tscr$/2096 $chr($base(1D4C9, 16, 10))
  hadd %h /^uscr$/2097 $chr($base(1D4CA, 16, 10))
  hadd %h /^vscr$/2098 $chr($base(1D4CB, 16, 10))
  hadd %h /^wscr$/2099 $chr($base(1D4CC, 16, 10))
  hadd %h /^xscr$/2100 $chr($base(1D4CD, 16, 10))
  hadd %h /^yscr$/2101 $chr($base(1D4CE, 16, 10))
  hadd %h /^zscr$/2102 $chr($base(1D4CF, 16, 10))
  hadd %h /^Afr$/2103 $chr($base(1D504, 16, 10))
  hadd %h /^Bfr$/2104 $chr($base(1D505, 16, 10))
  hadd %h /^Dfr$/2105 $chr($base(1D507, 16, 10))
  hadd %h /^Efr$/2106 $chr($base(1D508, 16, 10))
  hadd %h /^Ffr$/2107 $chr($base(1D509, 16, 10))
  hadd %h /^Gfr$/2108 $chr($base(1D50A, 16, 10))
  hadd %h /^Jfr$/2109 $chr($base(1D50D, 16, 10))
  hadd %h /^Kfr$/2110 $chr($base(1D50E, 16, 10))
  hadd %h /^Lfr$/2111 $chr($base(1D50F, 16, 10))
  hadd %h /^Mfr$/2112 $chr($base(1D510, 16, 10))
  hadd %h /^Nfr$/2113 $chr($base(1D511, 16, 10))
  hadd %h /^Ofr$/2114 $chr($base(1D512, 16, 10))
  hadd %h /^Pfr$/2115 $chr($base(1D513, 16, 10))
  hadd %h /^Qfr$/2116 $chr($base(1D514, 16, 10))
  hadd %h /^Sfr$/2117 $chr($base(1D516, 16, 10))
  hadd %h /^Tfr$/2118 $chr($base(1D517, 16, 10))
  hadd %h /^Ufr$/2119 $chr($base(1D518, 16, 10))
  hadd %h /^Vfr$/2120 $chr($base(1D519, 16, 10))
  hadd %h /^Wfr$/2121 $chr($base(1D51A, 16, 10))
  hadd %h /^Xfr$/2122 $chr($base(1D51B, 16, 10))
  hadd %h /^Yfr$/2123 $chr($base(1D51C, 16, 10))
  hadd %h /^afr$/2124 $chr($base(1D51E, 16, 10))
  hadd %h /^bfr$/2125 $chr($base(1D51F, 16, 10))
  hadd %h /^cfr$/2126 $chr($base(1D520, 16, 10))
  hadd %h /^dfr$/2127 $chr($base(1D521, 16, 10))
  hadd %h /^efr$/2128 $chr($base(1D522, 16, 10))
  hadd %h /^ffr$/2129 $chr($base(1D523, 16, 10))
  hadd %h /^gfr$/2130 $chr($base(1D524, 16, 10))
  hadd %h /^hfr$/2131 $chr($base(1D525, 16, 10))
  hadd %h /^ifr$/2132 $chr($base(1D526, 16, 10))
  hadd %h /^jfr$/2133 $chr($base(1D527, 16, 10))
  hadd %h /^kfr$/2134 $chr($base(1D528, 16, 10))
  hadd %h /^lfr$/2135 $chr($base(1D529, 16, 10))
  hadd %h /^mfr$/2136 $chr($base(1D52A, 16, 10))
  hadd %h /^nfr$/2137 $chr($base(1D52B, 16, 10))
  hadd %h /^ofr$/2138 $chr($base(1D52C, 16, 10))
  hadd %h /^pfr$/2139 $chr($base(1D52D, 16, 10))
  hadd %h /^qfr$/2140 $chr($base(1D52E, 16, 10))
  hadd %h /^rfr$/2141 $chr($base(1D52F, 16, 10))
  hadd %h /^sfr$/2142 $chr($base(1D530, 16, 10))
  hadd %h /^tfr$/2143 $chr($base(1D531, 16, 10))
  hadd %h /^ufr$/2144 $chr($base(1D532, 16, 10))
  hadd %h /^vfr$/2145 $chr($base(1D533, 16, 10))
  hadd %h /^wfr$/2146 $chr($base(1D534, 16, 10))
  hadd %h /^xfr$/2147 $chr($base(1D535, 16, 10))
  hadd %h /^yfr$/2148 $chr($base(1D536, 16, 10))
  hadd %h /^zfr$/2149 $chr($base(1D537, 16, 10))
  hadd %h /^Aopf$/2150 $chr($base(1D538, 16, 10))
  hadd %h /^Bopf$/2151 $chr($base(1D539, 16, 10))
  hadd %h /^Dopf$/2152 $chr($base(1D53B, 16, 10))
  hadd %h /^Eopf$/2153 $chr($base(1D53C, 16, 10))
  hadd %h /^Fopf$/2154 $chr($base(1D53D, 16, 10))
  hadd %h /^Gopf$/2155 $chr($base(1D53E, 16, 10))
  hadd %h /^Iopf$/2156 $chr($base(1D540, 16, 10))
  hadd %h /^Jopf$/2157 $chr($base(1D541, 16, 10))
  hadd %h /^Kopf$/2158 $chr($base(1D542, 16, 10))
  hadd %h /^Lopf$/2159 $chr($base(1D543, 16, 10))
  hadd %h /^Mopf$/2160 $chr($base(1D544, 16, 10))
  hadd %h /^Oopf$/2161 $chr($base(1D546, 16, 10))
  hadd %h /^Sopf$/2162 $chr($base(1D54A, 16, 10))
  hadd %h /^Topf$/2163 $chr($base(1D54B, 16, 10))
  hadd %h /^Uopf$/2164 $chr($base(1D54C, 16, 10))
  hadd %h /^Vopf$/2165 $chr($base(1D54D, 16, 10))
  hadd %h /^Wopf$/2166 $chr($base(1D54E, 16, 10))
  hadd %h /^Xopf$/2167 $chr($base(1D54F, 16, 10))
  hadd %h /^Yopf$/2168 $chr($base(1D550, 16, 10))
  hadd %h /^aopf$/2169 $chr($base(1D552, 16, 10))
  hadd %h /^bopf$/2170 $chr($base(1D553, 16, 10))
  hadd %h /^copf$/2171 $chr($base(1D554, 16, 10))
  hadd %h /^dopf$/2172 $chr($base(1D555, 16, 10))
  hadd %h /^eopf$/2173 $chr($base(1D556, 16, 10))
  hadd %h /^fopf$/2174 $chr($base(1D557, 16, 10))
  hadd %h /^gopf$/2175 $chr($base(1D558, 16, 10))
  hadd %h /^hopf$/2176 $chr($base(1D559, 16, 10))
  hadd %h /^iopf$/2177 $chr($base(1D55A, 16, 10))
  hadd %h /^jopf$/2178 $chr($base(1D55B, 16, 10))
  hadd %h /^kopf$/2179 $chr($base(1D55C, 16, 10))
  hadd %h /^lopf$/2180 $chr($base(1D55D, 16, 10))
  hadd %h /^mopf$/2181 $chr($base(1D55E, 16, 10))
  hadd %h /^nopf$/2182 $chr($base(1D55F, 16, 10))
  hadd %h /^oopf$/2183 $chr($base(1D560, 16, 10))
  hadd %h /^popf$/2184 $chr($base(1D561, 16, 10))
  hadd %h /^qopf$/2185 $chr($base(1D562, 16, 10))
  hadd %h /^ropf$/2186 $chr($base(1D563, 16, 10))
  hadd %h /^sopf$/2187 $chr($base(1D564, 16, 10))
  hadd %h /^topf$/2188 $chr($base(1D565, 16, 10))
  hadd %h /^uopf$/2189 $chr($base(1D566, 16, 10))
  hadd %h /^vopf$/2190 $chr($base(1D567, 16, 10))
  hadd %h /^wopf$/2191 $chr($base(1D568, 16, 10))
  hadd %h /^xopf$/2192 $chr($base(1D569, 16, 10))
  hadd %h /^yopf$/2193 $chr($base(1D56A, 16, 10))
  hadd %h /^zopf$/2194 $chr($base(1D56B, 16, 10))
  hadd %h /^b\.Gamma$/2195 $chr($base(1D6AA, 16, 10))
  hadd %h /^b\.Delta$/2196 $chr($base(1D6AB, 16, 10))
  hadd %h /^b\.Theta$/2197 $chr($base(1D6AF, 16, 10))
  hadd %h /^b\.Lambda$/2198 $chr($base(1D6B2, 16, 10))
  hadd %h /^b\.Xi$/2199 $chr($base(1D6B5, 16, 10))
  hadd %h /^b\.Pi$/2200 $chr($base(1D6B7, 16, 10))
  hadd %h /^b\.Sigma$/2201 $chr($base(1D6BA, 16, 10))
  hadd %h /^b\.Upsi$/2202 $chr($base(1D6BC, 16, 10))
  hadd %h /^b\.Phi$/2203 $chr($base(1D6BD, 16, 10))
  hadd %h /^b\.Psi$/2204 $chr($base(1D6BF, 16, 10))
  hadd %h /^b\.Omega$/2205 $chr($base(1D6C0, 16, 10))
  hadd %h /^b\.alpha$/2206 $chr($base(1D6C2, 16, 10))
  hadd %h /^b\.beta$/2207 $chr($base(1D6C3, 16, 10))
  hadd %h /^b\.gamma$/2208 $chr($base(1D6C4, 16, 10))
  hadd %h /^b\.delta$/2209 $chr($base(1D6C5, 16, 10))
  hadd %h /^b\.epsi$/2210 $chr($base(1D6C6, 16, 10))
  hadd %h /^b\.zeta$/2211 $chr($base(1D6C7, 16, 10))
  hadd %h /^b\.eta$/2212 $chr($base(1D6C8, 16, 10))
  hadd %h /^b\.thetas$/2213 $chr($base(1D6C9, 16, 10))
  hadd %h /^b\.iota$/2214 $chr($base(1D6CA, 16, 10))
  hadd %h /^b\.kappa$/2215 $chr($base(1D6CB, 16, 10))
  hadd %h /^b\.lambda$/2216 $chr($base(1D6CC, 16, 10))
  hadd %h /^b\.mu$/2217 $chr($base(1D6CD, 16, 10))
  hadd %h /^b\.nu$/2218 $chr($base(1D6CE, 16, 10))
  hadd %h /^b\.xi$/2219 $chr($base(1D6CF, 16, 10))
  hadd %h /^b\.pi$/2220 $chr($base(1D6D1, 16, 10))
  hadd %h /^b\.rho$/2221 $chr($base(1D6D2, 16, 10))
  hadd %h /^b\.sigmav$/2222 $chr($base(1D6D3, 16, 10))
  hadd %h /^b\.sigma$/2223 $chr($base(1D6D4, 16, 10))
  hadd %h /^b\.tau$/2224 $chr($base(1D6D5, 16, 10))
  hadd %h /^b\.upsi$/2225 $chr($base(1D6D6, 16, 10))
  hadd %h /^b\.phi$/2226 $chr($base(1D6D7, 16, 10))
  hadd %h /^b\.chi$/2227 $chr($base(1D6D8, 16, 10))
  hadd %h /^b\.psi$/2228 $chr($base(1D6D9, 16, 10))
  hadd %h /^b\.omega$/2229 $chr($base(1D6DA, 16, 10))
  hadd %h /^b\.epsiv$/2230 $chr($base(1D6DC, 16, 10))
  hadd %h /^b\.thetav$/2231 $chr($base(1D6DD, 16, 10))
  hadd %h /^b\.kappav$/2232 $chr($base(1D6DE, 16, 10))
  hadd %h /^b\.phiv$/2233 $chr($base(1D6DF, 16, 10))
  hadd %h /^b\.rhov$/2234 $chr($base(1D6E0, 16, 10))
  hadd %h /^b\.piv$/2235 $chr($base(1D6E1, 16, 10))
  hadd %h /^b\.Gammad$/2236 $chr($base(1D7CA, 16, 10))
  hadd %h /^b\.gammad$/2237 $chr($base(1D7CB, 16, 10))
}

; --- End of other aliases ---

; ------------------------------------------------------------------------------ EOF ------------------------------------------------------------------------------
