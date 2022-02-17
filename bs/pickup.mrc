on *:NICK: {
  if ($chan == #tfc.test) {
    var %pickup = $ini(pickup.ini,$ini(pickup.ini,0))
    if ($readini(pickup.ini,%pickup,$nick)) {
      writeini pickup.ini %pickup $newnick $readini (pickup.ini,%pickup,$nick)
      remini pickup.ini %pickup $nick
      msg $chan <!status>
    }
  }
}


on *:PART:#tfc.test: {
  var %pickup = $ini(pickup.ini,$ini(pickup.ini,0))
  if ($readini(pickup.ini,%pickup,$nick)) {
    remini pickup.ini %pickup $nick
    dec %num
    msg $chan <!status>
  }
}



on $*:TEXT:*:#tfc.test: {
  if ($1 == !add) {
    if (!$ini(pickup.ini,0)) {
      msg $chan No pickup has been started. Use !pickup to start one.
    }
    else {
      var %pickup = $ini(pickup.ini,$ini(pickup.ini,0))
      if ($readini(pickup.ini,%pickup,$nick)) {
        msg $chan You are already in the current pickup.
      }
      else {
        inc %num
        writeini -n pickup.ini %pickup $nick $+(p,%num)
        msg $chan Pickup on %mapname : $+(%num,/,%maxplayers)
      }
    }
  }
  elseif ($1 == !pickup) {
    if ($ini(pickup.ini,0)) {
      msg $chan A pickup has already been started.
    }
    elseif ($1 == !status) {
      if (!$ini(pickup.ini,0)) {
        msg $chan No pickup has been started. Use !pickup to start one.
      }
      else {
        set %votetime 0
        set %num 0
        set %mapname tbd
        set %maxplayers 8
        set %nomval 1
        set %hold 1
        set %failedon 1
        writeini -n pickup.ini $nick pickup $nick
        msg $chan $nick has started a pickup!  Use !add to join!
      }
    }

    elseif ($1 == !players) {
      if (!$ini(pickup.ini,0)) {
        msg $chan No pickup has been started. Use !pickup to start one.
      }
      else {
        if ($nick != $ini(pickup.ini,$ini(pickup.ini,0))) {
          msg $chan You must be the pickup owner to set the number of players.
        }
        else {
          set %maxplayers $2
          msg $chan Max players set to %maxplayers
        }
      }
    }
    elseif ($1 == !remove) {
      if (!$ini(pickup.ini,0)) {
        msg $chan No pickup has been started. Use !pickup to start one.
      }
      else {
        var %pickup = $ini(pickup.ini,$ini(pickup.ini,0))
        if (!$readini(pickup.ini,%pickup,$nick)) {
          msg $chan You are not in the current pickup.
        }
        else {
          dec %num
          remini -n pickup.ini %pickup $nick
          msg $chan Pickup on %mapname : $+(%num,/,%maxplayers)
        }
      }
    }
    elseif ($1 == !nominate) {
      if (!$ini(pickup.ini,0)) {
        msg $chan No pickup has been started. Use !pickup to start one.
      }
      else {
        var %pickup = $ini(pickup.ini,$ini(pickup.ini,0))
        if (!$readini(pickup.ini,%pickup,$nick)) {
          msg $nick You are not in the current pickup. Use !add to join.
        }
        else {
          if (%mapname != tbd) {
            msg $chan The map has already been chosen by the admin.
          }
          elseif ($2 == %nom1 || $2 == %nom2 || $2 == %nom3 || $2 == %nom4) {
            msg $chan That map is already nominated.
          }
          elseif (%nomval > 4) {
            msg $nick Nominations have already been picked.
          }
          else {
            if (%nomval <= 4) {
              set %nom [ $+ [ %nomval ] ] $2
              msg $chan $nick has nominated $2 in position %nomval of 4.
              inc %nomval
            }
          }
        }
      }
    }
    elseif ($1 == !sendinfo) {
      notice $nick [current pickup ip;password]
    }
    elseif ($1 == !end) {
      var %pickup = $ini(pickup.ini,$ini(pickup.ini,0))
      if ($nick == $ini(pickup.ini,$ini(pickup.ini,0))) {
        remini pickup.ini $nick
        msg $chan $nick has ended the pickup.
      }
      else {
        msg $chan The pickup will end if not !veto'd by %pickup within 1 minutes.
        set %vetotime 1
        timerveto 1 300 unset %vetotime | remini pickup.ini $nick
      }
    }
    elseif ($1 == !map) {
      if ($nick != $ini(pickup.ini,$ini(pickup.ini,0))) {
        msg $chan No.
      }
      else {
        set %mapname $2
        msg $chan Pickup on %mapname : $+(%num,/,%maxplayers)
      }
    }
    elseif ($1 == !hold) {
      if ($nick == $ini(pickup.ini,$ini(pickup.ini,0))) {
        msg $chan The current pickup has been put on hold by $nick
        set %hold 1
        set %votetime 0
      }
    }
    elseif ($1 == !unhold) { set %hold 0
      if ($nick = $ini(pickup.ini,$ini(pickup.ini,0))) && %num != %maxplayers && %hold == 0 {
        msg $chan The pickup has been taken off hold and will begin when filled.
        ;      <wait for %num == %maxplayers && %hold == 0 THEN start the vote>
      }
      else ($nick = $ini(pickup.ini,$ini(pickup.ini,0))) && %num == %maxplayers && %hold == 0 {
        msg $chan Map voting will begin so long as the pickup is filled.
        timer 1 2 msg $chan Vote for a map! You have 15 seconds. .: 1. %nom1 :. .: 2. %nom2 :. .: 3. %nom3 :. .: 4. %nom4 :.
        set %votetime 1
      }
    }
    elseif ($1 == 1) {
      if (%votetime == $null) {
        msg $chan there is no pickup in progress | halt
      }
      elseif (%votetime == 0) {
        msg $chan The pickup is on hold. | halt
      }
      elseif ($readini(vote.ini,$chan,$address($nick,2)) == two || three || four ) {
        msg $chan $nick You've changed your vote to %nom1
        remini vote.ini $chan $address($nick,2) two || three || four
        writeini vote.ini $chan $address($nick,2) one
      }
      else inc %one [ $+ [ $chan ] ]
      writeini vote.ini $chan $address($nick,2) one
      msg $chan $nick you've voted for %nom1 . Total number of votes for %nom1 : %one [ $+ [ $chan ] ]
    }
    elseif ($1 == 2) {
      if (%votetime == $null) {
        msg $chan there is no pickup in progress | halt
      }
      elseif (%votetime == 0) {
        msg $chan The pickup is on hold. | halt
      }
      elseif ($readini(vote.ini,$chan,$address($nick,2)) == one || three || four ) {
        msg $chan $nick You've changed your vote to %nom2
        remini vote.ini $chan $address($nick,2) one || three || four
        writeini vote.ini $chan $address($nick,2) two
      }
      else inc %two [ $+ [ $chan ] ]
      writeini vote.ini $chan $address($nick,2) two
      msg $chan $nick you've voted for %nom2 total number of votes for %nom2 : %two [ $+ [ $chan ] ]
    }
    elseif ($1 == 3) {
      if (%votetime == $null) {
        msg $chan there is no pickup in progress | halt
      }
      elseif (%votetime == 0) {
        msg $chan The pickup is on hold. | halt
      }
      elseif ($readini(vote.ini,$chan,$address($nick,2)) == one || two || four ) {
        msg $chan $nick You've changed your vote to %nom3
        remini vote.ini $chan $address($nick,2) one || two || four
        writeini vote.ini $chan $address($nick,2) three
      }
      else inc %three [ $+ [ $chan ] ]
      writeini vote.ini $chan $address($nick,2) three
      msg $chan $nick you've voted for %nom3 total number of votes for %nom3 : %three [ $+ [ $chan ] ]
    }
    elseif ($1 == 4) {
      if (%votetime == $null) {
        msg $chan there is no pickup in progress | halt
      }
      elseif (%votetime == 0) {
        msg $chan The pickup is on hold. | halt
      }
      elseif ($readini(vote.ini,$chan,$address($nick,2)) == one || two || three ) {
        msg $chan $nick You've changed your vote to %nom4
        remini vote.ini $chan $address($nick,2) one || two || three
        writeini vote.ini $chan $address($nick,2) four
      }
      else inc %four [ $+ [ $chan ] ]
      writeini vote.ini $chan $address($nick,2) four
      msg $chan $nick you've voted for %nom4 total number of votes for %nom4 : %four [ $+ [ $chan ] ]
    }
    elseif ($1 == !notice) {
      if (!$ini(pickup.ini,0)) {
        msg $chan No pickup has been started. Use !pickup to start one.
      }
      else {
        msg $chan Pickup on %mapname : $+(%num,/,%maxplayers)
      }
    }
    elseif ($1 == !add <alias> <ip> <password>) {
      if ($nick is [pickup admin]) {
        msg $nick You have updated the server list with <alias> on <ip> with '<password>' for the password.
      }
    }
    elseif ($1 == !delserver <alias>) {
      if ($nick isop $chan) {
        msg $chan $nick has deleted <alias> from the server list.
      }
    }
    elseif ($1 == !transfer <user>) {
      if ($nick isop $chan) {
        msg $chan $2 is the new pickup admin.
      }
    }
    elseif ($1 == !veto) {
      if ($nick isop $chan) {
        msg $chan The pickup will no longer end.
      }
    }
  }
}

;on *:TEXT:?:*: {
;  if ($1 == !addserver) {
;    if ($1 == server1 || $1 == server2 | $1 == server3 | $1 == server4 | $1 == server5 | $1 == server6 | $1 == server7 | $1 == server8 | $1 == server9 | $1 == server10)
;    var %server = $ini(pickup.ini,$ini(pickup.ini,0))
;    if -2$($readini(pickup.ini,%pickup,<server??>)) {
;      msg $nick Updated.
;    }
;    else {
;      inc %num
;      writeini -n pickup.ini %pickup $2 $+(p,%num)
;      msg $chan Pickup on %mapname : $+(%num,/,%maxplayers)
;    }
;  }
;}


;  on *:TEXT:!yes:#: {
;    if (%vote [ $+ [ $chan ] ] == $null) {
;      notice $nick there is no vote currently set for $chan | halt
;    }
;    if ($readini(vote.ini,$chan,$address($nick,2)) == yes) {
;      notice $nick you have already voted you cannot vote again | halt
;    }
;    if ($readini(vote.ini,$chan,$address($nick,2)) == no) {
;      notice $nick you have already voted you cannot vote again | halt
;    }
;    else inc %yes [ $+ [ $chan ] ]
;    writeini vote.ini $chan $address($nick,2) yes
;    notice $nick you've voted yes, total number of votes for yes: %yes [ $+ [ $chan ] ]
;  }
