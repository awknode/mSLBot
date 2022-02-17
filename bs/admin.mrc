alias master { set %master $1 | echo -a Bot Owner Is Now $1 }
on *:text:!acchelp:#: {
  if ($nick != %master) {
    msg $chan $nick $+ , you are not my owner.
  }
  elseif ($nick == %master) {
    notice %master [Commands]:
    notice %master Use as follows: 14!addowner <nick> !addadmin <nick> !addop etc, same for !delowner <nick> !deladmin <nick>. 
    notice %master You can list the owners, admins, ops, hops and voices with commands such as: !listowners, !listadmins, !listops, etc.
  }
}
on *:text:!listowners:#: {
  if ($nick != %master) {
    msg $chan $nick $+ , you are not my owner.
  }
  elseif ($nick == %master) {
    if $read(owner.txt) == $null {
      msg $chan 15Owner list is currnetly empty.
    }
    elseif $read(owner.txt) != $null {
      var %x = 1
      while (%x <= $lines(owner.txt)) {
        if (%x = 1) {
          set %listowner $read(owner.txt,%x)
          inc %x
        }
        else {
          set %listowner %listowner $+ , $read(owner.txt,%x)
          inc %x
        }
      }
    }
    msg $chan 15Owner List: %listowner
    unset %listowner
  }
}
on *:text:!listadmins:#: {
  if ($nick != %master) {
    msg $chan $nick $+ , you are not my owner.
  }
  elseif ($nick == %master) {
    if $read(sysop.txt) == $null {
      msg $chan 15Your Admin list is empty.
    }
    elseif $read(sysop.txt) != $null {
      var %x = 1
      while (%x <= $lines(sysop.txt)) {
        if (%x = 1) {
          set %listsysop $read(sysop.txt,%x)
          inc %x
        }
        else {
          set %listsysop %listsysop $+ , $read(sysop.txt,%x)
          inc %x
        }
      }
    }
    msg $chan 15Admin list: %listsysop
    unset %listsysop
  }
}
on *:text:!listops:#: {
  if ($nick != %master) {
    msg $chan $nick $+ , you are not my owner.
  }
  elseif ($nick == %master) {
    if $read(op.txt) == $null {
      msg $chan 15Your Op List Is Empty.
    }
    elseif $read(op.txt) != $null {
      var %x = 1
      while (%x <= $lines(op.txt)) {
        if (%x = 1) {
          set %listop $read(op.txt,%x)
          inc %x
        }
        else {
          set %listop %listop $+ , $read(op.txt,%x)
          inc %x
        }
      }
    }
    msg $chan 15Op List: %listop
    unset %listop
  }
}
on *:text:!listhops:#: {
  if ($nick != %master) {
    msg $chan $nick $+ , you are not my owner.
  }
  elseif ($nick == %master) {
    if $read(halfop.txt) == $null {
      msg $chan 15Your Half Op List Is Empty.
    }
    elseif $read(halfop.txt) != $null {
      var %x = 1
      while (%x <= $lines(halfop.txt)) {
        if (%x = 1) {
          set %listhalfop $read(halfop.txt,%x)
          inc %x
        }
        else {
          set %listhalfop %listhalfop $+ , $read(halfop.txt,%x)
          inc %x
        }
      }
    }
    msg $chan 15Half Op List14:15 %listhalfop
    unset %listhalfop
  }
}
on *:text:!listvoices:#: {
  if ($nick != %master) {
    msg $chan $nick $+ , you are not my owner.
  }
  elseif ($nick == %master) {
    if $read(voice.txt) == $null {
      msg $chan Voice list is currently empty.
    }
    elseif $read(voice.txt) != $null {
      var %x = 1
      while (%x <= $lines(voice.txt)) {
        if (%x = 1) {
          set %listvoice $read(voice.txt,%x)
          inc %x
        }
        else {
          set %listvoice %listvoice $+ , $read(voice.txt,%x)
          inc %x
        }
      }
    }
    msg $chan 15Voice List: %listvoice
    unset %listvoice
  }
}
on *:text:!addowner *:#: {
  if ($nick != %master) {
    msg $chan $nick $+ , you are not my owner.
  }
  elseif ($nick == %master) {
    set %addowner $readowner.txt,w,$$2)
    if (%addowner == $$2) {
      msg $chan 15Owner: $$2 already exists.
      unset %addowner
    }
    else {
      write owner.txt $$2
      msg $chan $$2 has been added to the owners list.
      unset %addowner
    }
  }
}
on *:text:!addadmin *:#: {
  if ($nick != %master) {
    msg $chan $nick $+ , you are not my owner.
  }
  elseif ($nick == %master) {
    set %addsysop $read(sysop.txt,w,$$2)
    if (%addsysop == $$2) {
      msg $chan 15Admin: $$2 already exists.
      unset %addsysop
    }
    else {
      write sysop.txt $$2
      msg $chan $$2 has been added to admin list.
      unset %addsysop
    }
  }
}
on *:text:!addop *:#: {
  if ($nick != %master) {
    msg $chan $nick $+ , you are not my owner.
  }
  elseif ($nick == %master) {
    set %addop $read(op.txt,w,$$2)
    if (%addop == $$2) {
      msg $chan 15Op: $$2 already exists.
      unset %addop
    }
    else {
      write op.txt $$2
      msg $chan $$2 has been added to the op list.
      unset %addop
    }
  }
}
on *:text:!addhop *:#: {
  if ($nick != %master) {
    msg $chan $nick $+ , you are not my owner.
  }
  elseif ($nick == %master) {
    set %addhalfop $read(halfop.txt,w,$$2)
    if (%addhalfop == $$2) {
      msg $chan 15Hop: $$2 already exists.
      unset %addhalfop
    }
    else {
      write halfop.txt $$2
      msg $chan $$2 has been added to hop list.
      unset %addhalfop
    }
  }
}
on *:text:!addvoice *:#: {
  if ($nick != %master) {
    msg $chan $nick $+ , you are not my owner.
  }
  elseif ($nick == %master) {
    set %addvoice $read(voice.txt,w,$$2)
    if (%addvoice == $$2) {
      msg $chan Voice: $$2 already exists.
      unset %addvoice
    }
    else {
      write voice.txt $$2
      msg $chan $$2 has been added to the voice list.
      unset %addvoice
    }
  }
}
on *:text:!delowner *:#: {
  if ($nick != %master) {
    msg $chan $nick $+ , you are not my owner.
  }
  elseif ($nick == %master) {
    set %delowner $read(owner.txt,w,$$2)
    if (%delowner == $$2) {
      write  -dl [ $+ [ $readn ] ] owner.txt
      msg $chan 15Owner: 14 $$2 15deleted!
      unset %delowner
    }
    else {
      msg $chan 15 $$2 does not exist.
      unset %delowner
    }
  }
}
on *:text:!deladmin *:#: {
  if ($nick != %master) {
    msg $chan $nick $+ , you are not my owner.
  }
  elseif ($nick == %master) {
    set %delsysop $read(sysop.txt,w,$$2)
    if (%delsysop == $$2) {
      write  -dl [ $+ [ $readn ] ] sysop.txt
      msg $chan 15Admin: $$2 deleted!
      unset %delsysop
    }
    else {
      msg $chan 15SysOp: 14 $$2 15doesn't exist.
      unset %delsysop
    }
  }
}
on *:text:!delop *:#: {
  if ($nick != %master) {
    msg $chan $nick $+ , you are not my owner.
  }
  elseif ($nick == %master) {
    set %delop $read(op.txt,w,$$2)
    if (%delop == $$2) {
      write  -dl [ $+ [ $readn ] ] op.txt
      msg $chan 15Op: 14 $$2 15deleted!
      unset %delop
    }
    else {
      msg $chan 15Op: 14 $$2 15doesn't exist.
      unset %delop
    }
  }
}
on *:text:!delhalfop *:#: {
  if ($nick != %master) {
    msg $chan $nick $+ , you are not my owner.
  }
  elseif ($nick == %master) {
    set %delhalfop $read(halfop.txt,w,$$2)
    if (%delhalfop == $$2) {
      write  -dl [ $+ [ $readn ] ] halfop.txt
      msg $chan 15Half Op: 14 $$2 15deleted!
      unset %delhalfop
    }
    else {
      msg $chan 15Half Op: 14 $$2 15doesn't exist.
      unset %delhalfop
    }
  }
}
on *:text:!delvoice *:#: {
  if ($nick != %master) {
    msg $chan $nick $+ , you are not my owner.
  }
  elseif ($nick == %master) {
    set %delvoice $read(voice.txt,w,$$2)
    if (%delvoice == $$2) {
      write  -dl [ $+ [ $readn ] ] voice.txt
      msg $chan 15Voice: $$2 deleted.
      unset %delvoice
    }
    else {
      msg $chan 15Voice: 14 $$2 15doesn't exist.
      unset %delvoice
    }
  }
}
on *:join:#: {
  if ($nick isin $read(owner.txt, w, $nick)) {
    ; notice $nick 15Greetings 14" $+ $nick $+ 14" 15Since You Are Apart Of The 14"15Owner Group14" 15You Have Been Made 14"15Owner14"15.
    mode $chan +q $nick
  }
  elseif ($nick isin $read(sysop.txt, w, $nick)) {
    ; notice $nick 15Greetings 14" $+ $nick $+ 14" 15Since You Are Apart Of The 14"15System Op Group14" 15You Have Been Made 14"15Co-Owner14"15.
    mode $chan +ao $nick
  }
  elseif ($nick isin $read(op.txt, w, $nick)) {
    ; notice $nick 15Greetings 14" $+ $nick $+ 14" 15Since You Are Apart Of The 14"15Op Group14" 15You Have Been Made 14"15Op14"15.
    mode $chan +o $nick
  }
  elseif ($nick isin $read(halfop.txt, w, $nick)) {
    ; notice $nick 15Greetings 14" $+ $nick $+ 14" 15Since You Are Apart Of The 14"15Half Op Group14" 15You Have Been Made 14"15Half Op14"15.
    mode $chan +h $nick
  }
  elseif ($nick isin $read(voice.txt, w, $nick)) {
    ; notice $nick 15Greetings 14" $+ $nick $+ 14" 15Since You Are Apart Of The 14"15Voice Group14" 15You Have Been Made 14"15Voice14"15.
    mode $chan +v $nick
  }
}
