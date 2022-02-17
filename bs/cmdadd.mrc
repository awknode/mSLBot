; A script to add to a bot to easily add and delete custom
; commands to a bot, like twitter and facebook links to share
; information within a channel, instead of adding commands
; manually to a script, this script helps you maintain, quickly and
; easily add/delete/change information commands.
;===================================================
; Only channel ops can add and delete commands, anyone can
; use them in a channel, this script can be edited by anyone as
; they see fit.
;
; To add a command you must first turn on the script for the
; channel by typing BOTNAME cadd on - BOTNAME being the
; name of the bot with the loaded script.
; To add a command, type !cadd TRIGGER OUTPUT HERE
;
; For example, if you want to add !twitter, you type
; !cadd twitter My Twitter Can be Found at http://twitter.com/lozocn
; So then when you type !twitter - It will say
; My Twitter Can be Found at http://twitter.com/lozocn
; Triggers are automatically added with the ! and are not to be included
; when adding and deleting commands.
;
; To delete a command, type !cdel TRIGGER
; So for example, to delete !twitter, type !cdel twitter
; The command !twitter will then be deleted.
;
; To view all custom added commands, type !cmd in the channel
; and you will get a PM with all available commands.
;
; To turn off the script for a channel, type BOTNAME cadd off
; When you turn it off for a channel, commands are kept on file and
; are not deleted, so when you turn it back on, you can continue to
; use them, the only way to remove commands is by using the !cdel
; command.
;
; To view the help commands within the bot, type BOTNAME cadd help
; and the bot will send you a PM with all the commands for this script.
;===================================================

; Feel free to edit below but do it at your own risk.

on $owner:TEXT:$($me cadd *):#: {
  if ($botmaster($network,$nick)) {  
    if ($nick isop $chan) {
      if ($3 == on) {
        if (%CADD.On. [ $+ [ $network ] ] [ $+ [ . ] ] [ $+ [ $chan ] ] == $null) {
          set %CADD.On. [ $+ [ $network ] ] [ $+ [ . ] ] [ $+ [ $chan ] ] 1
          msg $chan Command adding has been activated for $chan on $network $+ .
        }
        else {
          msg $chan Command adding has already been activated for $chan on $network $+ .
        }
      }
      if ($3 == off) {
        if (%CADD.On. [ $+ [ $network ] ] [ $+ [ . ] ] [ $+ [ $chan ] ] != $null) {
          unset %CADD.On. [ $+ [ $network ] ] [ $+ [ . ] ] [ $+ [ $chan ] ]
          msg $chan Command adding has been de-activated for $chan on $network $+ . Commands still activated.
        }
        else {
          msg $chan Command adding has already been de-activated for $chan on $network $+ .
        }
      }
    }
    if ($3 == help) {
      notice $chan Custom Code Help Line.
      notice $nick ----------------------------------------------------------------------------------------
      notice $nick  $me cadd on = Turns the Script On for the channel on the network.
      notice $nick  $me cadd off = Turns the Script Off for the channel on the network.
      notice $nick  !cadd <COMMAND> <OUTPUT HERE> = Adds a Custom Command for the channel. 
      notice $nick  Note: Don't include the ! when you are typing in a command.
      notice $nick  !cdel <COMMAND> = Deletes a Custom Command for the channel. 
      notice $nick  Note: Don't include the ! when you are typing in a command.
      notice $nick  !cmd = Lists all available custom commands for the channel.
      notice $nick ----------------------------------------------------------------------------------------
    }
  }
}

on $owner:TEXT:!custcmd:#: {
  if (%CADD.On. [ $+ [ $network ] ] [ $+ [ . ] ] [ $+ [ $chan ] ] != $null) {
    var %command_file = rcdradio_commands.ini
    var %k = $+($network,-,$chan)
    var %x = $ini(%command_file,%k,0)     
    var %kk = ''

    if (%x) { 
      msg $chan Noticing $nick with custom coded commands for $chan on $network $+ .
      notice $nick == Customized Command List for $chan on $network
      while (%x) {
        %kk = $ini(%command_file,%k,%x)
        notice $nick = ! $+ %kk => $readini(%command_file,p,%k,%kk)
        dec %x
      }
      notice $nick End of added custom code section.
    } 
    else { 
      msg $chan No custom code available atm.
    }
  }
}

on $owner:TEXT:!cadd *:#:{
  if (%CADD.On. [ $+ [ $network ] ] [ $+ [ . ] ] [ $+ [ $chan ] ] != $null) {
    if ($nick isop $chan) {
      var %command_file = rcdradio_commands.ini
      var %k = $+($network,-,$chan)

      writeini %command_file %k $2 [ [ $chr(36) ] $+ ] 3-
      msg $chan The Command ! $+ $2 has been added to $chan on $network $+ .  
    }
  }
}

on $owner:TEXT:!cdel *:#:{
  if (%CADD.On. [ $+ [ $network ] ] [ $+ [ . ] ] [ $+ [ $chan ] ] != $null) {
    if ($nick isop $chan) {
      var %command_file = rcdradio_commands.ini
      var %k = $+($network,-,$chan)

      if ($ini(%command_file,%k,$2) >= 1) {
        remini %command_file %k $2
        msg $chan Command ! $+ $2 was found for $chan on $network and has been deleted.
      } 
      else { 
        msg $chan Command ! $+ $2 could not be found.
      }
    }
  }
}

on $owner:TEXT:m/\!.*/iS:#:{
  if (%CADD.On. [ $+ [ $network ] ] [ $+ [ . ] ] [ $+ [ $chan ] ] != $null) {
    var %command_file = rcdradio_commands.ini
    var %cmd = $mid($1,2)

    if ($me == $nick) {
      halt 
    }

    var %k = $+($network,-,$chan)
    var %t = $readini(%command_file,p,%k,%cmd)

    if ($len(%t)) { 
      if ((%floodcom. [ $+ [ $chan ] ]) || ($($+(%,floodcom. [ $+ [ $chan ] ] $+ .,$nick),2))) { return }
      set -u10 %floodcom. [ $+ [ $chan ] ] On
      set -u30 %floodcom. [ $+ [ $chan ] ] $+ . $+ $nick On
      msg # %t
    }
  }
}
