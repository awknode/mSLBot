on $owner:TEXT:!bomb *:#: {
  if ($2 == $me) || ($2 == defiler) || ($2 == bl3k) { kick # $nick You tryin to bomb me or my nigga??? | halt }
  elseif ($2 == $nick) {
    set -u30 %bomb 1
    if ($2 ison $chan) && ($me isop $chan) || ($me ishop $chan) {
      spamprotect
      exprotect $1-
      set %bomber $nick   
      set %kicknick $2
      set %sec $rand(10,30)
      set %color $rand(1,3)
      set %time $calc( %sec / 1/2 )
      msg $chan Whoa, u wanna suicide, $nick $+ ? Okay, the bomb will explode in %sec seconds!
      msg $chan  $+ $2 $+ , type 4!red, 12!blue or 3!green to cut the wire and deactive the bomb!
      if (%color == 1) { set %color !red }
      if (%color == 2) { set %color !blue }
      if (%color == 3) { set %color !green }
      .timer 1 %time msg #  $+ %time seconds remaining!!
      .timer 1 %sec kick # %kicknick 4(((~~~~~KABOOOOOMMM!!!!~~~~~))) Time's up, dude!
      invite %kicknick $chan
      unset %bomber
      unset %kicknick
      unset %color
    }
  }
  elseif (%bomb == $null) {
    set -u30 %bomb 1
    if ($2 ison $chan) && ($me isop $chan) || ($me ishop $chan) {
      set %bomber $nick   
      set %kicknick $2
      set %sec $rand(10,30)
      set %color $rand(1,3)
      set %time $calc( %sec / 1/2 )
      msg $chan  $+ $nick planning a bomb on $2 $+ 's butt and will explode in %sec seconds!
      msg $chan  $+ $2 $+ , type 4!red, 12!blue or 3!green to cut the wire and deactive the bomb!
      if (%color == 1) { set %color !red }
      if (%color == 2) { set %color !blue }
      if (%color == 3) { set %color !green }
      .timer 1 %time msg #  $+ %time seconds remaining!!
      .timer 1 %sec kick # %kicknick 4(((~~~~~KABOOOOOMMM!!!!~~~~~))) Congratulation, You were bombed by $nick $+ !
      invite %kicknick $chan
      unset %bomber
      unset %kicknick
      unset %color
    }
  }
}

on *:TEXT:*:#: {
  if ($nick == %kicknick) {
    if ($1 == %color) {
      msg $chan Great, the bomb is off!
      .timers off
      unset %kicknick
      unset %bomber
      unset %color
    }
    if ($1 == !red) {
      kick $chan %kicknick 4(((~~~~~KABOOOOOMMM!!!!~~~~~))) You just pick up the wrong wire!
      invite %kicknick $chan
      .timers off
      unset %kicknick
      unset %bomber
      unset %color
    }
    if ($1 == !yellow) {
      kick $chan %kicknick 4(((~~~~~KABOOOOOMMM!!!!~~~~~))) You just pick up the wrong wire!
      invite %kicknick $chan
      .timers off
      unset %kicknick
      unset %bomber
      unset %color
    }
    if ($1 == !green) {
      kick $chan %kicknick 4(((~~~~~KABOOOOOMMM!!!!~~~~~))) You just pick up the wrong wire!
      invite %kicknick $chan
      .timers off
      unset %kicknick
      unset %bomber
      unset %color
    }
  }
}
