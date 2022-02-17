on *:TEXT:*:#: {
  if ($1 == !ncstart) {
    if (!$2) {
      var %adminchk = $+($nick,$chr(58),$address($nick,0))
      if ($istok($_pic.sets(admins),%adminchk,32)) {
        if ($_pic.sets(enabled)) { msg $chan The Nude Collector Script is Already ON! }
        else { writeini $_pic.path settings enabled 1 | msg $chan The Nude Collector Script is Now ON! }
      }
      else { msg $chan Access Denied. }
    }
    else { msg $chan Improper syntax. [Ex: !ncstart] }
  }
  if ($1 == !ncstop) {
    if (!$2) {
      var %adminchk = $+($nick,$chr(58),$address($nick,0))
      if ($istok($_pic.sets(admins),%adminchk,32)) {
        if ($_pic.sets(enabled)) { writeini $_pic.path settings enabled 0 | msg $chan The Nude Collector Script is Now OFF! }
        else { msg $chan The Nude Collector Script is Already OFF! }
      }
      else { msg $chan Access denied. }
    }
    else { msg $chan Improper syntax. [Ex: !ncstop] }
  }
  if ($1 == !ncadmin) {
    var %adminchk = $+($nick,$chr(58),$address($nick,0))
    if ($istok($_pic.sets(admins),%adminchk,32)) {
      if ($2 == add) {
        if ($3) {
          if ($4) {
            if ($regex($4,/^(\*\!.*?@.*?)$/)) {
              if (!$5) {
                var %newadmin = $+($3,$chr(58),$regml(1))
                if ($istok($_pic.sets(admins),%newadmin,32)) { msg $chan Nude Collector Admin Already Added. Nick: $3 Host: $regml(1) }
                else { writeini $_pic.path settings admins $iif($_pic.sets(admins),$_pic.sets(admins)) %newadmin | msg $chan New Nude Collector Admin Added. Nick: $3 Host: $regml(1) }
              }
              else { msg $chan Improper syntax. [Ex: !ncadmin add nick *!ident@host (Mask Type: 0)] }
            }
            else { msg $chan Improper host mask. [Ex: *!ident@host.host (Mask Type: 0)] }
          }
          else { msg $chan Improper syntax. [Ex: !ncadmin add nick *!ident@host (Mask Type: 0)] }
        }
        else { msg $chan Improper syntax. [Ex: !ncadmin add nick *!ident@host (Mask Type: 0)] }
      }
      elseif ($2 == del) {
        if ($3) {
          if ($4) {
            if ($regex($4,/^(\*\!.*?@.*?)$/)) {
              if (!$5) {
                var %remadmin = $+($3,$chr(58),$regml(1))
                if ($_pic.sets(admins) == %remadmin) { remini $_pic.path settings admins %remadmin | msg $chan Nude Collector Admin Removed. Nick: $3 Host: $regml(1) (Note: No Admins Left. Must Add A Admin by /cmdline To Continue.) }
                elseif ($istok($_pic.sets(admins),%remadmin,32)) { writeini $_pic.path settings admins $remtok($_pic.sets(admins),%remadmin,0,32) | msg $chan Nude Collector Admin Removed. Nick: $3 Host: $regml(1) }
                else { msg $chan Nude Collector Admin Doesn't Exist. Nick: $3 Host: $regml(1) }
              }
              else { msg $chan Improper syntax. [Ex: !ncadmin del nick *!ident@host (Mask Type: 0)] }
            }
            else { msg $chan Improper host mask. [Ex: *!ident@host.host (Mask Type: 0)] }
          }
          else { msg $chan Improper syntax. [Ex: !ncadmin del nick *!ident@host (Mask Type: 0)] }
        }
        else { msg $chan Improper syntax. [Ex: !ncadmin del nick *!ident@host (Mask Type: 0)] }
      }
      elseif ($2 == list) {
        if (!$3) {
          var %a = 1,%tota = $numtok($_pic.sets(admins),32)
          msg $chan Nude Collector Admins $+([Total:,$chr(32),,%tota,]:) Check your notice.
          while (%a <= %tota) {
            var %nick = $gettok($gettok($_pic.sets(admins),%a,32),1,58),%host = $gettok($gettok($_pic.sets(admins),%a,32),2,58)
            notice $nick $+(Admin,$chr(32),%a,:) Nick: %nick Host: %host
            inc %a
          }
        }
      }
      else { msg $chan Unknown Command. !ncadmin < add :: del :: list > }
    }
    else { msg $chan Access denied. }
  }
  if ($1 == !boobs) {
    spamprotect
    exprotect $1-
    if ($_pic.sets(enabled)) {
      if ($2 == add) {
        if ($3) {
          var %totb = $ini($_pic.path,boobs,0),%b = 1
          while (%b <= %totb) {
            var %burl = $gettok($readini($_pic.path,boobs,%b),1,32)
            if ($3 == %burl) { set %_nc.boobs_addurlfound %b }
            inc %b
          }
          if (%_nc.boobs_addurlfound) {
            var %bpicinfo = $readini($_pic.path,boobs,%_nc.boobs_addurlfound),%bpic = $gettok(%bpicinfo,1,32),%bpic_nick = $gettok($gettok(%bpicinfo,2,32),1,58),%bpic_host = $gettok($gettok(%bpicinfo,2,32),2,58),%bpic_time = $time($gettok(%bpicinfo,3,32),hh:nn:sstt),%bpic_date = $time($gettok(%bpicinfo,3,32),mm/dd/yyyy)
            msg $chan That Boob Pic Url Has Already Been Added:
            msg $chan Boob Pic $+($chr(35),%_nc.boobs_addurlfound,:) %bpic Added By: %bpic_nick $+($chr(40),%bpic_host,$chr(41)) At: %bpic_time On: %bpic_date
            unset %_nc.boobs_addurlfound
          }
          else {
            msg $chan Adding New Boob Pic: $3
            var %bnum = $calc(%totb + 1)
            writeini $_pic.path boobs %bnum $3 $+($nick,$chr(58),$address($nick,0)) $ctime
            var %bpicinfo = $readini($_pic.path,boobs,%bnum),%bpic = $gettok(%bpicinfo,1,32),%bpic_nick = $gettok($gettok(%bpicinfo,2,32),1,58),%bpic_host = $gettok($gettok(%bpicinfo,2,32),2,58),%bpic_time = $time($gettok(%bpicinfo,3,32),hh:nn:sstt),%bpic_date = $time($gettok(%bpicinfo,3,32),mm/dd/yyyy)
            msg $chan New Boob Pic Added: %bpic Added By: %bpic_nick $+($chr(40),%bpic_host,$chr(41)) At: %bpic_time On: %bpic_date
          }
        }
        else { Improper syntax. [Ex: !boobs add URL] }
      }
      elseif ($2 == del) {
        var %adminchk = $+($nick,$chr(58),$address($nick,0))
        if ($istok($_pic.sets(admins),%adminchk,32)) {
          if ($3) {
            var %totb = $ini($_pic.path,boobs,0),%b = 1
            while (%b <= %totb) {
              var %burl = $gettok($readini($_pic.path,boobs,%b),1,32)
              if ($3 == %burl) { set %_nc.boobs_delurlfound %b }
              inc %b
            }
            if (%_nc.boobs_delurlfound) {
              var %bpicinfo = $readini($_pic.path,boobs,%_nc.boobs_delurlfound),%bpic = $gettok(%bpicinfo,1,32),%bpic_nick = $gettok($gettok(%bpicinfo,2,32),1,58),%bpic_host = $gettok($gettok(%bpicinfo,2,32),2,58),%bpic_time = $time($gettok(%bpicinfo,3,32),hh:nn:sstt),%bpic_date = $time($gettok(%bpicinfo,3,32),mm/dd/yyyy)
              msg $chan Deleting Boob Pic $+($chr(35),%_nc.boobs_delurlfound,:) %bpic Added By: %bpic_nick $+($chr(40),%bpic_host,$chr(41)) At: %bpic_time On: %bpic_date
              remini $_pic.path boobs %_nc.boobs_delurlfound
              $_pic.inirw(boobs)
              msg $chan Boob Pic $qt($+($chr(35),%_nc.boobs_delurlfound)) Deleted.
              unset %_nc.boobs_delurlfound
            }
            else {
              msg $chan Boob Pic Not Found: $3
              msg $chan No Boob Pic Deleted.
            }
          }
          else { Improper syntax. [Ex: !boobs del URL] }
        }
        else { msg $chan Access denied. }
      }
      elseif ($2 == count) {
        if (!$3) {
          var %totb = $ini($_pic.path,boobs,0)
          if (%totb) {
            msg $chan Total Boob Pics In DataBase: $qt(%totb)
          }
          else { msg $chan No boobs currently in database. }
        }
        else { Improper syntax. [Ex: !boobs count] }
      }
      elseif ($2 == gblist) {
        spamprotect
        exprotect $1-
        var %totb = $ini($_pic.path,boobs,0),%b = 1
        if (%totb) {
          msg $chan Listing All Boob Pics In DataBase $+([Total: ,%totb,]:)
          while (%b <= %totb) {
            var %bpicinfo = $readini($_pic.path,boobs,%b),%bpic = $gettok(%bpicinfo,1,32),%bpic_nick = $gettok($gettok(%bpicinfo,2,32),1,58),%bpic_host = $gettok($gettok(%bpicinfo,2,32),2,58),%bpic_time = $time($gettok(%bpicinfo,3,32),hh:nn:sstt),%bpic_date = $time($gettok(%bpicinfo,3,32),mm/dd/yyyy)
            msg $chan Boob Pic $+($chr(35),%b,:) %bpic Added By: %bpic_nick $+($chr(40),%bpic_host,$chr(41)) At: %bpic_time On: %bpic_date
            inc %b
          }
        }
        else { msg $chan No boobs are currently in the database. }
      }
      elseif (!$2) {
        var %totb = $ini($_pic.path,boobs,0)
        if (%totb) {
          var %randb = $rand(1,%totb)
          var %bpicinfo = $readini($_pic.path,boobs,%randb),%bpic = $gettok(%bpicinfo,1,32),%bpic_nick = $gettok($gettok(%bpicinfo,2,32),1,58),%bpic_host = $gettok($gettok(%bpicinfo,2,32),2,58),%bpic_time = $time($gettok(%bpicinfo,3,32),hh:nn:sstt),%bpic_date = $time($gettok(%bpicinfo,3,32),mm/dd/yyyy)
          msg $chan Boob Pic $+($chr(35),%randb,:) %bpic Added By: %bpic_nick $+($chr(40),%bpic_host,$chr(41)) At: %bpic_time On: %bpic_date
        }
        else { msg $chan No boobs are currently in the database. }
      }
      else { msg $chan Unknown command. !boobs < add :: del :: count :: list> }
    }
    else { msg $chan Nude Collector Script is currently off. }
  }
  if ($1 == !ass) {
    if ($_pic.sets(enabled)) {
      if ($2 == add) {
        if ($3) {
          var %tota = $ini($_pic.path,ass,0),%a = 1
          while (%a <= %tota) {
            var %aurl = $gettok($readini($_pic.path,ass,%a),1,32)
            if ($3 == %aurl) { set %_nc.ass_addurlfound %a }
            inc %a
          }
          if (%_nc.ass_addurlfound) {
            var %apicinfo = $readini($_pic.path,ass,%_nc.ass_addurlfound),%apic = $gettok(%apicinfo,1,32),%apic_nick = $gettok($gettok(%apicinfo,2,32),1,58),%apic_host = $gettok($gettok(%apicinfo,2,32),2,58),%apic_time = $time($gettok(%apicinfo,3,32),hh:nn:sstt),%apic_date = $time($gettok(%apicinfo,3,32),mm/dd/yyyy)
            msg $chan That Ass Pic Url Has Already Been Added:
            msg $chan Ass Pic $+($chr(35),%_nc.ass_addurlfound,:) %apic Added By: %apic_nick $+($chr(40),%apic_host,$chr(41)) At: %apic_time On: %apic_date
            unset %_nc.ass_addurlfound
          }
          else {
            msg $chan Adding New Ass Pic: $3
            var %anum = $calc(%tota + 1)
            writeini $_pic.path ass %anum $3 $+($nick,$chr(58),$address($nick,0)) $ctime
            var %apicinfo = $readini($_pic.path,ass,%anum),%apic = $gettok(%apicinfo,1,32),%apic_nick = $gettok($gettok(%apicinfo,2,32),1,58),%apic_host = $gettok($gettok(%apicinfo,2,32),2,58),%apic_time = $time($gettok(%apicinfo,3,32),hh:nn:sstt),%apic_date = $time($gettok(%apicinfo,3,32),mm/dd/yyyy)
            msg $chan New Ass Pic Added: %apic Added By: %apic_nick $+($chr(40),%apic_host,$chr(41)) At: %apic_time On: %apic_date
          }
        }
        else { Improper syntax. [Ex: !ass add URL] }
      }
      elseif ($2 == del) {
        var %adminchk = $+($nick,$chr(58),$address($nick,0))
        if ($istok($_pic.sets(admins),%adminchk,32)) {
          if ($3) {
            var %tota = $ini($_pic.path,ass,0),%a = 1
            while (%a <= %tota) {
              var %aurl = $gettok($readini($_pic.path,ass,%a),1,32)
              if ($3 == %aurl) { set %_nc.ass_delurlfound %a }
              inc %a
            }
            if (%_nc.ass_delurlfound) {
              var %apicinfo = $readini($_pic.path,ass,%_nc.ass_delurlfound),%apic = $gettok(%apicinfo,1,32),%apic_nick = $gettok($gettok(%apicinfo,2,32),1,58),%apic_host = $gettok($gettok(%apicinfo,2,32),2,58),%apic_time = $time($gettok(%apicinfo,3,32),hh:nn:sstt),%apic_date = $time($gettok(%apicinfo,3,32),mm/dd/yyyy)
              msg $chan Deleting Ass Pic $+($chr(35),%_nc.ass_delurlfound,:) %apic Added By: %apic_nick $+($chr(40),%apic_host,$chr(41)) At: %apic_time On: %apic_date
              remini $_pic.path ass %_nc.ass_delurlfound
              $_pic.inirw(ass)
              msg $chan Ass Pic $qt($+($chr(35),%_nc.ass_delurlfound)) Deleted.
              unset %_nc.ass_delurlfound
            }
            else {
              msg $chan Ass Pic Not Found: $3
              msg $chan No Ass Pic Deleted.
            }
          }
          else { Improper syntax. [Ex: !ass del url] }
        }
        else { msg $chan Access denied. }
      }
      elseif ($2 == count) {
        if (!$3) {
          var %tota = $ini($_pic.path,ass,0)
          if (%tota) {
            msg $chan Total ass pics currently in database: $qt(%tota)
          }
          else { msg $chan No ass pics are currently in the database. }
        }
        else { Improper syntax. [Ex: !ass count] }
      }
      elseif ($2 == list) {
        spamprotect
        exprotect $1-
        var %tota = $ini($_pic.path,ass,0),%a = 1
        if (%tota) {
          msg $chan Listing Ass pics. $+([Total: ,%tota,]:)
          while (%a <= %tota) {
            var %apicinfo = $readini($_pic.path,ass,%a),%apic = $gettok(%apicinfo,1,32),%apic_nick = $gettok($gettok(%apicinfo,2,32),1,58),%apic_host = $gettok($gettok(%apicinfo,2,32),2,58),%apic_time = $time($gettok(%apicinfo,3,32),hh:nn:sstt),%apic_date = $time($gettok(%apicinfo,3,32),mm/dd/yyyy)
            msg $chan Ass Pic $+($chr(35),%a,:) %apic Added By: %apic_nick $+($chr(40),%apic_host,$chr(41)) At: %apic_time On: %apic_date
            inc %a
          }
        }
        else { msg $chan No ass pics are currently in the database. }
      }
      elseif (!$2) {
        var %tota = $ini($_pic.path,ass,0)
        if (%tota) {
          var %randa = $rand(1,%tota)
          var %apicinfo = $readini($_pic.path,ass,%randa),%apic = $gettok(%apicinfo,1,32),%apic_nick = $gettok($gettok(%apicinfo,2,32),1,58),%apic_host = $gettok($gettok(%apicinfo,2,32),2,58),%apic_time = $time($gettok(%apicinfo,3,32),hh:nn:sstt),%apic_date = $time($gettok(%apicinfo,3,32),mm/dd/yyyy)
          msg $chan Ass Pic $+($chr(35),%randa,:) %apic Added By: %apic_nick $+($chr(40),%apic_host,$chr(41)) At: %apic_time On: %apic_date
        }
        else { msg $chan No ass pics are currently in the database. }
      }
      else { msg $chan Unknown command. !ass < add :: del :: count :: list > }
    }
    else { msg $chan Nude Collector Script is currently off. }
  }
  if ($1 == !pussy) {
    if ($_pic.sets(enabled)) {
      if ($2 == add) {
        if ($3) {
          var %totp = $ini($_pic.path,pussy,0),%p = 1
          while (%p <= %totp) {
            var %purl = $gettok($readini($_pic.path,pussy,%p),1,32)
            if ($3 == %purl) { set %_nc.pussy_addurlfound %p }
            inc %p
          }
          if (%_nc.pussy_addurlfound) {
            var %ppicinfo = $readini($_pic.path,pussy,%_nc.pussy_addurlfound),%ppic = $gettok(%ppicinfo,1,32),%ppic_nick = $gettok($gettok(%ppicinfo,2,32),1,58),%ppic_host = $gettok($gettok(%ppicinfo,2,32),2,58),%ppic_time = $time($gettok(%ppicinfo,3,32),hh:nn:sstt),%ppic_date = $time($gettok(%ppicinfo,3,32),mm/dd/yyyy)
            msg $chan That Pussy Pic Url Has Already Been Added:
            msg $chan Pussy Pic $+($chr(35),%_nc.pussy_addurlfound,:) %ppic Added By: %ppic_nick $+($chr(40),%ppic_host,$chr(41)) At: %ppic_time On: %ppic_date
            unset %_nc.pussy_addurlfound
          }
          else {
            msg $chan Adding New Pussy Pic: $3
            var %pnum = $calc(%totp + 1)
            writeini $_pic.path pussy %pnum $3 $+($nick,$chr(58),$address($nick,0)) $ctime
            var %ppicinfo = $readini($_pic.path,pussy,%pnum),%ppic = $gettok(%ppicinfo,1,32),%ppic_nick = $gettok($gettok(%ppicinfo,2,32),1,58),%ppic_host = $gettok($gettok(%ppicinfo,2,32),2,58),%ppic_time = $time($gettok(%ppicinfo,3,32),hh:nn:sstt),%ppic_date = $time($gettok(%ppicinfo,3,32),mm/dd/yyyy)
            msg $chan New Pussy Pic Added: %ppic Added By: %ppic_nick $+($chr(40),%ppic_host,$chr(41)) At: %ppic_time On: %ppic_date
          }
        }
        else { Improper syntax. [Ex: !pussy add URL] }
      }
      elseif ($2 == del) {
        var %adminchk = $+($nick,$chr(58),$address($nick,0))
        if ($istok($_pic.sets(admins),%adminchk,32)) {
          if ($3) {
            var %totp = $ini($_pic.path,pussy,0),%p = 1
            while (%p <= %totp) {
              var %purl = $gettok($readini($_pic.path,pussy,%p),1,32)
              if ($3 == %purl) { set %_nc.pussy_delurlfound %p }
              inc %p
            }
            if (%_nc.pussy_delurlfound) {
              var %ppicinfo = $readini($_pic.path,pussy,%_nc.pussy_delurlfound),%ppic = $gettok(%ppicinfo,1,32),%ppic_nick = $gettok($gettok(%ppicinfo,2,32),1,58),%ppic_host = $gettok($gettok(%ppicinfo,2,32),2,58),%ppic_time = $time($gettok(%ppicinfo,3,32),hh:nn:sstt),%ppic_date = $time($gettok(%ppicinfo,3,32),mm/dd/yyyy)
              msg $chan Deleting Pussy Pic $+($chr(35),%_nc.pussy_delurlfound,:) %ppic Added By: %ppic_nick $+($chr(40),%ppic_host,$chr(41)) At: %ppic_time On: %ppic_date
              remini $_pic.path pussy %_nc.pussy_delurlfound
              $_pic.inirw(pussy)
              msg $chan Pussy Pic $qt($+($chr(35),%_nc.pussy_delurlfound)) Deleted.
              unset %_nc.pussy_delurlfound
            }
            else {
              msg $chan Pussy Pic Not Found: $3
              msg $chan No Pussy Pic Deleted.
            }
          }
          else { Improper syntax. [Ex: !pussy del URL] }
        }
        else { msg $chan Access denied. }
      }
      elseif ($2 == count) {
        if (!$3) {
          var %totp = $ini($_pic.path,pussy,0)
          if (%totp) {
            msg $chan Total Pussy Pics In DataBase: $qt(%totp)
          }
          else { msg $chan No pussy pics are currently in the database. }
        }
        else { Improper syntax. [Ex: !pussy count] }
      }
      elseif ($2 == list) {
        var %totp = $ini($_pic.path,pussy,0),%p = 1
        if (%totp) {
          msg $chan Listing pussy pics. $+([Total: ,%totp,]:)
          while (%p <= %totp) {
            var %ppicinfo = $readini($_pic.path,pussy,%p),%ppic = $gettok(%ppicinfo,1,32),%ppic_nick = $gettok($gettok(%ppicinfo,2,32),1,58),%ppic_host = $gettok($gettok(%ppicinfo,2,32),2,58),%ppic_time = $time($gettok(%ppicinfo,3,32),hh:nn:sstt),%ppic_date = $time($gettok(%ppicinfo,3,32),mm/dd/yyyy)
            msg $chan Pussy Pic $+($chr(35),%p,:) %ppic Added By: %ppic_nick $+($chr(40),%ppic_host,$chr(41)) At: %ppic_time On: %ppic_date
            inc %p
          }
        }
        else { msg $chan No Pussy Pics Currently In Pic DB! }
      }
      elseif (!$2) {
        var %totp = $ini($_pic.path,pussy,0)
        if (%totp) {
          var %randp = $rand(1,%totp)
          var %ppicinfo = $readini($_pic.path,pussy,%randp),%ppic = $gettok(%ppicinfo,1,32),%ppic_nick = $gettok($gettok(%ppicinfo,2,32),1,58),%ppic_host = $gettok($gettok(%ppicinfo,2,32),2,58),%ppic_time = $time($gettok(%ppicinfo,3,32),hh:nn:sstt),%ppic_date = $time($gettok(%ppicinfo,3,32),mm/dd/yyyy)
          msg $chan Pussy Pic $+($chr(35),%randp,:) %ppic Added By: %ppic_nick $+($chr(40),%ppic_host,$chr(41)) At: %ppic_time On: %ppic_date
        }
        else { msg $chan No pussy pics are currently in the database. }
      }
      else { msg $chan Unknown command. !pussy < add :: del :: count :: list > }
    }
    else { msg $chan Nude Collector Script is currently off. }
  }
  if ($1 == !lesb) {
    if ($_pic.sets(enabled)) {
      if ($2 == add) {
        if ($3) {
          var %totl = $ini($_pic.path,lesb,0),%l = 1
          while (%l <= %totl) {
            var %lurl = $gettok($readini($_pic.path,lesb,%l),1,32)
            if ($3 == %lurl) { set %_nc.lesb_addurlfound %l }
            inc %l
          }
          if (%_nc.lesb_addurlfound) {
            var %lpicinfo = $readini($_pic.path,lesb,%_nc.lesb_addurlfound),%lpic = $gettok(%lpicinfo,1,32),%lpic_nick = $gettok($gettok(%lpicinfo,2,32),1,58),%lpic_host = $gettok($gettok(%lpicinfo,2,32),2,58),%lpic_time = $time($gettok(%lpicinfo,3,32),hh:nn:sstt),%lpic_date = $time($gettok(%lpicinfo,3,32),mm/dd/yyyy)
            msg $chan That Lesbian Pic Url Has Already Been Added:
            msg $chan Lesbian Pic $+($chr(35),%_nc.lesb_addurlfound,:) %lpic Added By: %lpic_nick $+($chr(40),%lpic_host,$chr(41)) At: %lpic_time On: %lpic_date
            unset %_nc.lesb_addurlfound
          }
          else {
            msg $chan Adding New Lesbian Pic: $3
            var %lnum = $calc(%totl + 1)
            writeini $_pic.path lesb %lnum $3 $+($nick,$chr(58),$address($nick,0)) $ctime
            var %lpicinfo = $readini($_pic.path,lesb,%lnum),%lpic = $gettok(%lpicinfo,1,32),%lpic_nick = $gettok($gettok(%lpicinfo,2,32),1,58),%lpic_host = $gettok($gettok(%lpicinfo,2,32),2,58),%lpic_time = $time($gettok(%lpicinfo,3,32),hh:nn:sstt),%lpic_date = $time($gettok(%lpicinfo,3,32),mm/dd/yyyy)
            msg $chan New Lesbian Pic Added: %lpic Added By: %lpic_nick $+($chr(40),%lpic_host,$chr(41)) At: %lpic_time On: %lpic_date
          }
        }
        else { Improper syntax. [Ex: !lesb add URL] }
      }
      elseif ($2 == del) {
        var %adminchk = $+($nick,$chr(58),$address($nick,0))
        if ($istok($_pic.sets(admins),%adminchk,32)) {
          if ($3) {
            var %totl = $ini($_pic.path,lesb,0),%l = 1
            while (%l <= %totl) {
              var %lurl = $gettok($readini($_pic.path,lesb,%l),1,32)
              if ($3 == %lurl) { set %_nc.lesb_delurlfound %l }
              inc %l
            }
            if (%_nc.lesb_delurlfound) {
              var %lpicinfo = $readini($_pic.path,lesb,%_nc.lesb_delurlfound),%lpic = $gettok(%lpicinfo,1,32),%lpic_nick = $gettok($gettok(%lpicinfo,2,32),1,58),%lpic_host = $gettok($gettok(%lpicinfo,2,32),2,58),%lpic_time = $time($gettok(%lpicinfo,3,32),hh:nn:sstt),%lpic_date = $time($gettok(%lpicinfo,3,32),mm/dd/yyyy)
              msg $chan Deleting Lesbian Pic $+($chr(35),%_nc.lesb_delurlfound,:) %lpic Added By: %lpic_nick $+($chr(40),%lpic_host,$chr(41)) At: %lpic_time On: %lpic_date
              remini $_pic.path lesb %_nc.lesb_delurlfound
              $_pic.inirw(lesb)
              msg $chan Lesbian Pic $qt($+($chr(35),%_nc.lesb_delurlfound)) Deleted.
              unset %_nc.lesb_delurlfound
            }
            else {
              msg $chan Lesbian pic not found: $3
              msg $chan No lesbian pic deleted.
            }
          }
          else { Improper syntax. [Ex: !lesb del URL] }
        }
        else { msg $chan Access denied. }
      }
      elseif ($2 == count) {
        if (!$3) {
          var %totl = $ini($_pic.path,lesb,0)
          if (%totl) {
            msg $chan Total Lesbian Pics In DataBase: $qt(%totl)
          }
          else { msg $chan No lesbian pics are currently in the database. }
        }
        else { Improper syntax. [Ex: !lesb count] }
      }
      elseif ($2 == list) {
        var %totl = $ini($_pic.path,lesb,0),%l = 1
        if (%totl) {
          msg $chan Listing lesbian pics. $+([Total: ,%totl,]:)
          while (%l <= %totl) {
            var %lpicinfo = $readini($_pic.path,lesb,%l),%lpic = $gettok(%lpicinfo,1,32),%lpic_nick = $gettok($gettok(%lpicinfo,2,32),1,58),%lpic_host = $gettok($gettok(%lpicinfo,2,32),2,58),%lpic_time = $time($gettok(%lpicinfo,3,32),hh:nn:sstt),%lpic_date = $time($gettok(%lpicinfo,3,32),mm/dd/yyyy)
            msg $chan Lesbian Pic $+($chr(35),%l,:) %lpic Added By: %lpic_nick $+($chr(40),%lpic_host,$chr(41)) At: %lpic_time On: %lpic_date
            inc %l
          }
        }
        else { msg $chan No lesbian pics are currently in the database. }
      }
      elseif (!$2) {
        var %totl = $ini($_pic.path,lesb,0)
        if (%totl) {
          var %randl = $rand(1,%totl)
          var %lpicinfo = $readini($_pic.path,lesb,%randl),%lpic = $gettok(%lpicinfo,1,32),%lpic_nick = $gettok($gettok(%lpicinfo,2,32),1,58),%lpic_host = $gettok($gettok(%lpicinfo,2,32),2,58),%lpic_time = $time($gettok(%lpicinfo,3,32),hh:nn:sstt),%lpic_date = $time($gettok(%lpicinfo,3,32),mm/dd/yyyy)
          msg $chan Lesbian Pic $+($chr(35),%randl,:) %lpic Added By: %lpic_nick $+($chr(40),%lpic_host,$chr(41)) At: %lpic_time On: %lpic_date
        }
        else { msg $chan No lesbian pics are currently in the database. }
      }
      else { msg $chan Unknown command. !lesb < add :: del :: count :: list > }
    }
    else { msg $chan Nude Collector Script is currently off. }
  }
  if ($1 == !nsfw) {
    if ($_pic.sets(enabled)) {
      if ($2 == add) {
        if ($3) {
          var %totn = $ini($_pic.path,nsfw,0),%n = 1
          while (%n <= %totn) {
            var %nurl = $gettok($readini($_pic.path,nsfw,%n),1,32)
            if ($3 == %nurl) { set %_nc.nsfw_addurlfound %n }
            inc %n
          }
          if (%_nc.nsfw_addurlfound) {
            var %npicinfo = $readini($_pic.path,nsfw,%_nc.nsfw_addurlfound),%npic = $gettok(%npicinfo,1,32),%npic_nick = $gettok($gettok(%npicinfo,2,32),1,58),%npic_host = $gettok($gettok(%npicinfo,2,32),2,58),%npic_time = $time($gettok(%npicinfo,3,32),hh:nn:sstt),%npic_date = $time($gettok(%npicinfo,3,32),mm/dd/yyyy)
            msg $chan That NSFW Pic Url Has Already Been Added:
            msg $chan NSFW Pic $+($chr(35),%_nc.nsfw_addurlfound,:) %npic Added By: %npic_nick $+($chr(40),%npic_host,$chr(41)) At: %npic_time On: %npic_date
            unset %_nc.nsfw_addurlfound
          }
          else {
            msg $chan Adding New NSFW Pic: $3
            var %nnum = $calc(%totn + 1)
            writeini $_pic.path nsfw %nnum $3 $+($nick,$chr(58),$address($nick,0)) $ctime
            var %npicinfo = $readini($_pic.path,nsfw,%nnum),%npic = $gettok(%npicinfo,1,32),%npic_nick = $gettok($gettok(%npicinfo,2,32),1,58),%npic_host = $gettok($gettok(%npicinfo,2,32),2,58),%npic_time = $time($gettok(%npicinfo,3,32),hh:nn:sstt),%npic_date = $time($gettok(%npicinfo,3,32),mm/dd/yyyy)
            msg $chan New NSFW Pic Added: %npic Added By: %npic_nick $+($chr(40),%npic_host,$chr(41)) At: %npic_time On: %npic_date
          }
        }
        else { Improper syntax. [Ex: !nsfw add URL] }
      }
      elseif ($2 == del) {
        var %adminchk = $+($nick,$chr(58),$address($nick,0))
        if ($istok($_pic.sets(admins),%adminchk,32)) {
          if ($3) {
            var %totn = $ini($_pic.path,nsfw,0),%n = 1
            while (%n <= %totn) {
              var %nurl = $gettok($readini($_pic.path,nsfw,%n),1,32)
              if ($3 == %nurl) { set %_nc.nsfw_delurlfound %n }
              inc %n
            }
            if (%_nc.nsfw_delurlfound) {
              var %npicinfo = $readini($_pic.path,nsfw,%_nc.nsfw_delurlfound),%npic = $gettok(%npicinfo,1,32),%npic_nick = $gettok($gettok(%npicinfo,2,32),1,58),%npic_host = $gettok($gettok(%npicinfo,2,32),2,58),%npic_time = $time($gettok(%npicinfo,3,32),hh:nn:sstt),%npic_date = $time($gettok(%npicinfo,3,32),mm/dd/yyyy)
              msg $chan Deleting NSFW Pic $+($chr(35),%_nc.nsfw_delurlfound,:) %npic Added By: %npic_nick $+($chr(40),%npic_host,$chr(41)) At: %npic_time On: %npic_date
              remini $_pic.path nsfw %_nc.nsfw_delurlfound
              $_pic.inirw(nsfw)
              msg $chan NSFW Pic $qt($+($chr(35),%_nc.nsfw_delurlfound)) Deleted.
              unset %_nc.nsfw_delurlfound
            }
            else {
              msg $chan NSFW pic not found: $3
              msg $chan No NSFW pic deleted.
            }
          }
          else { Improper syntax. [Ex: !nsfw del URL] }
        }
        else { msg $chan Access denied. }
      }
      elseif ($2 == count) {
        if (!$3) {
          var %totn = $ini($_pic.path,nsfw,0)
          if (%totn) {
            msg $chan Total NSFW Pics In DataBase: $qt(%totn)
          }
          else { msg $chan No NSFW pics are currently in the database. }
        }
        else { Improper syntax. [Ex: !nsfw count] }
      }
      elseif ($2 == list) {
        var %totn = $ini($_pic.path,nsfw,0),%n = 1
        if (%totn) {
          msg $chan Listing All NSFW Pics In DataBase $+([Total: ,%totn,]:)
          while (%n <= %totn) {
            var %npicinfo = $readini($_pic.path,nsfw,%n),%npic = $gettok(%npicinfo,1,32),%npic_nick = $gettok($gettok(%npicinfo,2,32),1,58),%npic_host = $gettok($gettok(%npicinfo,2,32),2,58),%npic_time = $time($gettok(%npicinfo,3,32),hh:nn:sstt),%npic_date = $time($gettok(%npicinfo,3,32),mm/dd/yyyy)
            msg $chan NSFW Pic $+($chr(35),%n,:) %npic Added By: %npic_nick $+($chr(40),%npic_host,$chr(41)) At: %npic_time On: %npic_date
            inc %n
          }
        }
        else { msg $chan No NSFW are currently in the database. }
      }
      elseif (!$2) {
        var %totn = $ini($_pic.path,nsfw,0)
        if (%totn) {
          var %randn = $rand(1,%totn)
          var %npicinfo = $readini($_pic.path,nsfw,%randn),%npic = $gettok(%npicinfo,1,32),%npic_nick = $gettok($gettok(%npicinfo,2,32),1,58),%npic_host = $gettok($gettok(%npicinfo,2,32),2,58),%npic_time = $time($gettok(%npicinfo,3,32),hh:nn:sstt),%npic_date = $time($gettok(%npicinfo,3,32),mm/dd/yyyy)
          msg $chan NSFW Pic $+($chr(35),%randn,:) %npic Added By: %npic_nick $+($chr(40),%npic_host,$chr(41)) At: %npic_time On: %npic_date
        }
        else { msg $chan No NSFW pics are currently in the database. }
      }
      else { msg $chan Unknown command. !nsfw < add :: del :: count :: list > }
    }
    else { msg $chan Nude Collector Script is currently off. }
  }
  if ($1 == !countall) {
    var %totb = $ini($_pic.path,boobs,0),%tota = $ini($_pic.path,ass,0),%totp = $ini($_pic.path,pussy,0),%totl = $ini($_pic.path,lesb,0),%totn = $ini($_pic.path,nsfw,0),%totpics = $calc(%totb + %tota + %totp + %totl + %totn)
    msg $chan Nude Count: Boobs $qt($iif(%totb,%totb,0)) â€¢â€¢ Ass $qt($iif(%tota,%tota,0)) â€¢â€¢ Pussy $qt($iif(%totp,%totp,0)) â€¢â€¢ Lesbian $qt($iif(%totl,%totl,0)) â€¢â€¢ NSFW $qt($iif(%totn,%totn,0)) 14x7X14x[ Total: $iif(%totpics,%totpics,0) ]
  }
}

alias -l _pic.inirw {
  if ($1 == boobs) { var %type = boobs }
  if ($1 == ass) { var %type = ass }
  if ($1 == pussy) { var %type = pussy }
  if ($1 == lesb) { var %type = lesb }
  if ($1 == nsfw) { var %type = nsfw }
  var %path = $_pic.path
  var %totlines = $ini(%path,%type,0)
  var %r = 1
  while (%r <= %totlines) {
    set $+(%,_pic.rewrite.,%r) $readini(%path,%type,$ini(%path,%type,%r))
    inc %r
  }
  var %totcvars = $var(%_pic.rewrite.*,0)
  var %w = 1
  remini %path %type
  while (%w <= %totcvars) {
    writeini %path %type %w $eval($var(%_pic.rewrite.*,%w),2)
    inc %w
  }
  unset %_pic.rewrite.*
}

alias add_picadmin {
  if ($1) {
    if ($2) {
      if ($regex($2,/^(\*\!.*?@.*?)$/)) {
        if (!$3) {
          var %newadmin = $+($1,$chr(58),$regml(1))
          if ($istok($_pic.sets(admins),%newadmin,32)) { echo -a * Nude Collector Admin Already Added. Nick: $1 Host: $regml(1) }
          else {
            echo -a * Adding Nude Collector Admin. Nick: $1 Host: $regml(1)
            writeini $_pic.path settings admins $iif($_pic.sets(admins),$_pic.sets(admins)) %newadmin
            echo -a * New Nude Collector Admin Added. Nick: $1 Host: $regml(1)
          }
        }
        else { echo -a * Improper Syntax. (ex: /add_picadmin nick *!ident@host [Mask Type: 0]) }
      }
      else { msg $chan Improper Host Mask. (ex: *!ident@host.host [Mask Type: 0]) }
    }
    else { echo -a * Improper Syntax. (ex: /add_picadmin nick *!ident@host [Mask Type: 0]) }
  }
  else { echo -a * Improper Syntax. (ex: /add_picadmin nick *!ident@host [Mask Type: 0]) }
}

alias -l _pic.path { return $qt($scriptdirnudecollector.ini) }

alias -l _pic.sets {
  if ($1 == enabled) { return $readini($_pic.path,settings,enabled) }
  if ($1 == admins) { return $readini($_pic.path,settings,admins) }
}
