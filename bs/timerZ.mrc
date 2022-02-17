;;;;;;;;;;;;;;;;;;;;;;;;;;
; Addon: Timer Wizard
;
; Author: Zmodem
;
; Version: 1.00
;
; Date: 07 December 2017
;;;;;;;;;;;;;;;;;;;;;;;;;;

;ALIASES
alias -l err return $input($1-,wok10,Create Timer Error)
alias -l do_about dialog - $+ $iif($dialog(about),a,m about) about
alias twizard dialog - $+ $iif($dialog(twizard),a,m twizard) twizard
alias -l newtimer dialog - $+ $iif($dialog(newtimer),a,m newtimer) newtimer
alias -l does_not_exist return This timer no longer exists. Please refresh the timers list. (Hotkey: ALT+R)
alias -l a_timers var %i = $timer(0), %l | while (%i) { %l = %l $+ $timer(%i) $+ $crlf | dec %i } | $iif(%l,return %l,return There are no timers loaded at this time.)
alias -l twizard_unload {
  .timerTwizard* off
  .timerTwizard 1 0 return $input(Timer Wizard Unloaded Successfully! $+ $crlf $+ $crlf $+ Thank you for using!,io,Unload Complete)
  .unload -rs $nopath($script)
}
alias -l btnDelete {
  var %t = $timer($1), %d = did -ra twizard 4
  if (!%t) { %d $does_not_exist | return }
  .timer $+ %t off
  gather_timers %d %t $+ : Timer successfully deleted...
}
alias -l gather_timers {
  var %d = twizard, %i = 1, %t = $timer(0)
  did -r %d 2
  did -b %d 7,8
  did -ra %d 1 Loaded &Timers ( $+ %t $+ )
  while (%i <= %t) {
    did -a %d 2 $timer(%i)
    inc %i
  }
  did -r %d 4
  if ($1-) $1-
}
alias -l create_new_timer {
  var %d = newtimer, %tName = $did(%d,2), %tCmd = $did(%d,4), %tRep = $did(%d,6), %tDel = $did(%d,9), %r = return, %c = $chr(44), %b = $crlf $+ $crlf, %tDelType = $iif($did(%d,10).state,0,1), %tSpec = $did(%d,12).state, %tSpecTime = $did(%d,13), %tMM = $did(%d,14).state, %tForce = $did(%d,15).state
  if ($chr(32) isin %tName) %r $err(Your timer name contains spaces $+ %c please remove them.)
  if (!$mid(%tCmd,0,0)) %r $err(Your timer needs some sort of command. Please enter one.)
  if (%tRep !isnum) %r $err(Your repeats contain errors. $+ %b $+ Note: Make sure you set it as a number only!)
  if (%tDel !isnum) %r $err(Your delay contains errors. $+ %b $+ Note: Make sure you set it as a number only!)
  if (%tSpec) $iif(($gettok(%tSpecTime,1,58) !isnum) || ($gettok(%tSpecTime,2,58) !isnum),%r $err(Your specified start time contains errors. $+ %b $+ Note: Your start time must be in the format of: hh:mm. ie: 21:50 for 9:50pm))
  .timer $+ %tName - $+ $+($iif(%tDelType,m),$iif(%tMM,h),$iif(%tForce,o)) $iif(%tSpec,%tSpecTime) %tRep %tDel %tCmd
  if ($dialog(newtimer)) dialog -x newtimer
  if ($dialog(twizard)) gather_timers
  return $input(Timer ' $+ %tName $+ ' created successfully!,iok6,New Timer Created)
}
alias -l btnPause {
  var %t = $1, %d = did -ra twizard 7
  if ($timer(%t).pause) {
    %d Pause
    .timer $+ $timer(%t) -r
    goto end
  }
  %d Resume
  .timer $+ $timer(%t) -p
  :end
  did -c twizard 2 %t
  get_timer_info %t
}
alias -l get_timer_info {
  var %t = $1, %d = twizard, %b = $crlf $+ $crlf, %a = did -a %d 4
  did -r %d 4
  %a ID: %t
  %a %b
  if ($timer(%t)) {
    %a Active: $iif($timer(%t).pause,Paused,Yes) $+ %b
    $iif($timer(%t).pause,did -ra %d 7 Resume,did -ra %d 7 Pause)
    %a Repetitions: $iif($timer(%t).reps,$timer(%t).reps,Unlimited) $+ %b
    %a Delay: $duration($timer(%t).delay) $+ %b
    %a Next Action Scheduled: $duration($timer(%t).secs) $+ %b
    %a Online/Offline Status: $timer(%t).type $+ %b
    %a Multimedia Timer: $iif($timer(%t).mmt,Yes,No) %+ %b
    %a Command: $timer(%t).com
    did -c %d 4 1
    did -e %d 7,8
    return
  }
  %a $does_not_exist
}

;DIALOGS
dialog -l twizard {
  title "Timer Wizard"
  size -1 -1 237 126
  option dbu
  box "Loaded &Timers", 1, 3 2 87 98
  list 2, 7 10 78 85, size hsbar vsbar
  box "Ti&mer Details", 3, 93 2 141 98
  edit "", 4, 97 10 132 85, read multi return vsbar
  button "", 5, -4 102 243 25, disable
  button "&New...", 6, 3 107 30 15
  button "&Pause", 7, 37 107 30 15
  button "&Delete", 8, 71 107 30 15
  box "", 9, 107 104 1 19
  button "&Refresh", 10, 115 107 30 15
  button "E&xit", 14, 207 107 27 15, cancel
}
;;EVENTS FOR 'twizard' DIALOG
ON *:DIALOG:twizard:*:*: {

  var %d = $dname, %e = $devent, %i = $did

  if (%e == init) {
    gather_timers
  }

  if (%e == sclick) {
    var %l = $did(2).sel
    if ((%i == 2) && (%l)) get_timer_info %l
    if (%i == 6) newtimer
    if (%i == 7) btnPause %l
    if (%i == 8) btnDelete %l
    if (%i == 10) gather_timers
  }

}

dialog -l newtimer {
  title "Create New Timer"
  size -1 -1 138 111
  option dbu
  text "Timer Name:", 1, 4 5 33 9
  edit "MyCustomerTimer1", 2, 40 3 96 12, multi return autohs
  text "Command:", 3, 4 19 33 9
  edit "", 4, 40 17 96 12, multi return autohs
  text "Repeats:", 5, 4 33 33 9
  edit "1", 6, 40 31 21 12, multi return autohs
  text "times (0 = Infinite)", 7, 65 33 45 9
  text "Delay:", 8, 4 47 33 9
  edit "1", 9, 40 45 21 12, multi return autohs
  radio "&Seconds", 10, 65 46 30 9, group
  radio "M&illiseconds", 11, 97 46 39 9
  check "Specify Start &Time:", 12, 4 61 57 9
  edit "hh:mm", 13, 65 60 27 12, multi return autohs
  check "&Multimedia Timer", 14, 4 76 51 9
  check "&Force as offline timer", 15, 65 76 63 9
  box "", 16, 1 86 135 4
  button "&Create", 17, 34 94 30 12, flat
  button "C&ancel", 18, 74 94 30 12, flat, cancel
}
;;EVENTS FOR 'newtimer' DIALOG
ON *:DIALOG:newtimer:*:*: {
  var %d = newtimer, %e = $devent, %i = $did
  if (%e == init) { did -c %d 10 | did -b %d 13,17 }
  if (%e == edit) {
    did - $+ $iif(($did(2) != $null) && ($did(4) != $null) && ($did(6) != $null) && ($did(9) != $null) && ($did(13) != $null),e,b) %d 17
  }
  if (%e == sclick) {
    if (%i == 12) did - $+ $iif($did(12).state,e,b) %d 13
    if (%i == 17) create_new_timer
  }
}

dialog -l about {
  title "About Timer Wizard"
  size -1 -1 138 78
  option dbu
  text "Addon:", 2, 52 16 30 9
  text "Timer Wizard v1.00", 3, 84 16 51 9
  text "Created by:", 4, 52 33 30 9
  text "Zmodem", 5, 84 33 51 9
  box "", 6, -4 53 145 4
  link "http://www.mircdepot.com/", 7, 6 63 70 9
  button "&Close", 8, 102 61 30 12, cancel
}
;;EVENTS FOR 'about' DIALOG
on *:DIALOG:about:sclick:7:echo -a defiler is a boss

;MENUS
menu status,menubar {
  Timer Wizard
  .Run...:twizard
  .-
  .Create Timer:newtimer
  .-
  .Basic Timer List:return $input(Here is a basic list of the currently active timers: $+ $str($crlf,2) $+ $a_timers,io,QuickView Timers)
  .-
  .Help
  ..About...:do_about
  .-
  .Unload:$iif($input(Are you sure you want to unload the Timer Wizard addon?,wy,Confirm Unload),twizard_unload)
}

;LOAD EVENTS
ON *:LOAD:var %q = $input(Timer Wizard Successfully Loaded! $+ $crlf $+ $crlf Would you like to run it now?,iyvk6,Addon Loaded!) | $iif((%q != $no) && (%q != $timeout),twizard,return $input(You can run the wizard at any time by typing: /twizard,iok6,Additional Help))
