;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; PUSHMODE ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;info:
;
;  by wiebe @ QuakeNet
;  version 1.31     (written and tested on mIRC 6.15)
;
;  last edit: Fri Apr 30 2004
;
;
;What does this script do?
;
;  Queues and dumps modes together as much as possible.
;
;
;Some examples:
;
;  Example 1: from within same command
;  voicing some users with the following command:
;   //var %x = $nick($chan,0,r) | while (%x) { mode $chan +v $nick($chan,%x,r) | dec %x }
;  and this happens:
;
;   [18:45:32] * dev-mirc sets mode: +v zyrtepf
;   [18:45:32] * dev-mirc sets mode: +v zcttchv
;   [18:45:32] * dev-mirc sets mode: +v yznzko
;   [18:45:32] * dev-mirc sets mode: +v yuxf
;   [18:45:32] * dev-mirc sets mode: +v twyqh
;   [18:45:34] * dev-mirc sets mode: +v pitqxpg
;   [18:45:36] * dev-mirc sets mode: +v nsln
;   [18:45:38] * dev-mirc sets mode: +v moypfnk
;   [18:45:40] * dev-mirc sets mode: +v gibuhee
;   [18:45:42] * dev-mirc sets mode: +v evuwntm
;
;  This sends a mode command +v <nick> for each nick
;
;  Now we do the same but with pushmode instead of the normal mode command:
;   //var %x = $nick($chan,0,r) | while (%x) { pushmode $chan +v $nick($chan,%x,r) | dec %x }
;  and this happens:
;
;   [18:48:03] * dev-mirc sets mode: +vvvvvv zyrtepf zcttchv yznzko yuxf twyqh pitqxpg
;   [18:48:04] * dev-mirc sets mode: +vvvv nsln moypfnk gibuhee evuwntm
;
;  The modes were now pushed together, so only 2 mode commands are needed instead of 10
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;  Example 2: the same event repeated
;  An normal anti-flood script for example does this:
;
;   [18:23:32] <zcttchv> AVERAGE ANTI FLOOD SCRIPT WITHOUT PUSHMODE
;   [18:23:32] <evuwntm> AVERAGE ANTI FLOOD SCRIPT WITHOUT PUSHMODE
;   [18:23:32] <moypfnk> AVERAGE ANTI FLOOD SCRIPT WITHOUT PUSHMODE
;   [18:23:33] <zyrtepf> AVERAGE ANTI FLOOD SCRIPT WITHOUT PUSHMODE
;   [18:23:33] <gibuhee> AVERAGE ANTI FLOOD SCRIPT WITHOUT PUSHMODE
;   [18:23:33] <yznzko> AVERAGE ANTI FLOOD SCRIPT WITHOUT PUSHMODE
;   [18:23:33] <yuxf> AVERAGE ANTI FLOOD SCRIPT WITHOUT PUSHMODE
;   [18:23:33] <pitqxpg> AVERAGE ANTI FLOOD SCRIPT WITHOUT PUSHMODE
;   [18:23:33] <nsln> AVERAGE ANTI FLOOD SCRIPT WITHOUT PUSHMODE
;   [18:23:33] <twyqh> AVERAGE ANTI FLOOD SCRIPT WITHOUT PUSHMODE
;   [18:23:33] * dev-mirc sets mode: +b *!*qgeqd@8V5Ry4.8vtU30.virtual
;   [18:23:33] * dev-mirc sets mode: +b *!*ihgkzu@8V5Ry4.8vtU30.virtual
;   [18:23:33] * dev-mirc sets mode: +b *!*dqqyex@8V5Ry4.8vtU30.virtual
;   [18:23:36] * dev-mirc sets mode: +b *!*qfzzq@8V5Ry4.8vtU30.virtual
;   [18:23:40] * dev-mirc sets mode: +b *!*alavec@8V5Ry4.8vtU30.virtual
;   [18:23:44] * dev-mirc sets mode: +b *!*avwy@8V5Ry4.8vtU30.virtual
;   [18:23:48] * dev-mirc sets mode: +b *!*tqkukhp@8V5Ry4.8vtU30.virtual
;   [18:23:52] * dev-mirc sets mode: +b *!*xrvdohn@8V5Ry4.8vtU30.virtual
;   [18:23:56] * dev-mirc sets mode: +b *!*ujundvh@8V5Ry4.8vtU30.virtual
;   [18:24:00] * dev-mirc sets mode: +b *!*kid@8V5Ry4.8vtU30.virtual
;
;  The anti-flood script sends each ban with a mode command
;
;  The same script using pushmode does the following:
;
;   [18:25:11] <zcttchv> AVERAGE ANTI FLOOD SCRIPT WITH PUSHMODE
;   [18:25:11] <evuwntm> AVERAGE ANTI FLOOD SCRIPT WITH PUSHMODE
;   [18:25:11] <moypfnk> AVERAGE ANTI FLOOD SCRIPT WITH PUSHMODE
;   [18:25:11] <zyrtepf> AVERAGE ANTI FLOOD SCRIPT WITH PUSHMODE
;   [18:25:11] <gibuhee> AVERAGE ANTI FLOOD SCRIPT WITH PUSHMODE
;   [18:25:11] <yznzko> AVERAGE ANTI FLOOD SCRIPT WITH PUSHMODE
;   [18:25:11] <yuxf> AVERAGE ANTI FLOOD SCRIPT WITH PUSHMODE
;   [18:25:11] <pitqxpg> AVERAGE ANTI FLOOD SCRIPT WITH PUSHMODE
;   [18:25:11] <nsln> AVERAGE ANTI FLOOD SCRIPT WITH PUSHMODE
;   [18:25:12] <twyqh> AVERAGE ANTI FLOOD SCRIPT WITH PUSHMODE
;   [18:25:12] * dev-mirc sets mode: +bbbbbb *!*qgeqd@8V5Ry4.8vtU30.virtual *!*ihgkzu@8V5Ry4.8vtU30.virtual *!*dqqyex@8V5Ry4.8vtU30.virtual *!*qfzzq@8V5Ry4.8vtU30.virtual *!*alavec@8V5Ry4.8vtU30.virtual *!*avwy@8V5Ry4.8vtU30.virtual
;   [18:25:13] * dev-mirc sets mode: +bbbb *!*tqkukhp@8V5Ry4.8vtU30.virtual *!*xrvdohn@8V5Ry4.8vtU30.virtual *!*ujundvh@8V5Ry4.8vtU30.virtual *!*kid@8V5Ry4.8vtU30.virtual
;
;  The anti-flood script sends the modes to pushmode, which turns 10 mode commands into 2
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;  Example 3: multiple events
;  Some form of a bitchmode script:
;
;   on @!*:op:#channel:{ if ($opnick != $me) { mode $chan -o $opnick } }
;   on @!*:voice:#channel:{ if ($vnick != $me) { mode $chan -v $vnick } }
;   on @!*:help:#channel:{ if ($hnick != $me) { mode $chan -h $hnick } }
;   on @!*:mode:#channel:{
;     if (n isincs $1) && (n !isincs $gettok($chan($chan).mode,1,32)) { mode $chan +n }
;     if (t isincs $1) && (t !isincs $gettok($chan($chan).mode,1,32)) { mode $chan +t }
;   }
;
;   [13:54:31] * wiebe sets mode: -nt+ovh nick1 nick2 nick3
;   [13:54:31] * dev-mirc sets mode: +n
;   [13:54:31] * dev-mirc sets mode: +t
;   [13:54:31] * dev-mirc sets mode: -o nick1
;   [13:54:31] * dev-mirc sets mode: -v nick2
;   [13:54:31] * dev-mirc sets mode: -h nick3
;
;  With pushmode:
;
;   on @!*:op:#channel:{ if ($opnick != $me) { pushmode $chan -o $opnick } }
;   on @!*:voice:#channel:{ if ($vnick != $me) { pushmode $chan -v $vnick } }
;   on @!*:help:#channel:{ if ($hnick != $me) { pushmode $chan -h $hnick } }
;   on @!*:mode:#channel:{
;     if (n isincs $1) && (n !isincs $gettok($chan($chan).mode,1,32)) { pushmode $chan +n }
;     if (t isincs $1) && (t !isincs $gettok($chan($chan).mode,1,32)) { pushmode $chan +t }
;   }
;
;   [13:55:36] * wiebe sets mode: -nt+ohv nick1 nick2 nick3
;   [13:55:36] * dev-mirc sets mode: -ohv+nt nick1 nick2 nick3
;
;  only 1 mode line needed for the 4 events
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;
;How to use this script?
;
;  pushmode [-cdflnprswuNeM] <channel> <+/-mode> [arg]
;
;    can be used to push channel modes together, see below
;
;
;   The script has 4 different queue's,
;   a queue for single modes (like +m) is emptied everytime pushmode is sending modes
;   a faster queue, a normal queue (default) and a slower queue for modes with a parameter (like +b banmask)
;   first the faster queue is emptied, then the default queue and last the slower queue
;
;   The -n switch (next) queues the mode in the faster queue, the -l switch (low) can be used for the slower queue
;   this is only for modes with a parameter
;     pushmode #channel +v nick      adds +v nick to the default queue
;     pushmode -l #channel -v nick   adds -v nick to the slower queue
;     pushmode -n #channel +o nick   adds +o nick to the faster queue
;
;   The -c switch (clear) can be used to clear the queues
;   the -l (low), -d (default), -n (next) and -s (single) switch
;   can be used to clear a specific queue or multiple queues
;     pushmode -c                    clears all queues for all channels
;     pushmode -dc                   clears the default queue for all channels
;     pushmode -nc #channel          clears the faster queue for #channel
;     pushmode -cs #channel          clears the single queue for #channel
;     pushmode -cdl #channel         clears the default and slower queue for #channel
;
;   The -f switch (flush) starts to empty the queue at once without waiting for the timer to start it
;     pushmode -f                    starts pushmode for all channels
;     pushmode -f #channel           starts pushmode for #channel
;     pushmode -f #channel +o nick   starts pushmode for #channel after adding +o nick to the queue
;
;   The -p switch (passive) can be used to only add a mode to the queue,
;   but it will not cause pushmode to empty the queue,
;   this mode will be send the next time pushmode is dumping modes
;   or when the number of modes in the queues equals $modespl 
;     pushmode -p #channel +b                queues in the default queue and
;                                            sends +b (request banlist) the next time pushmode is dumping modes
;     pushmode -p #channel -b *!*@host.com   queues in the default queue and
;                                            sends -b *!*@host.com the next chance it gets
;
;   The -r switch (remove) removes a mode from the queue,
;   the -l (low), -d (default) and -n (next) switch
;   can be used to remove a mode from a specific queue or from multiple queues
;   when combined with the -w a wildcardmatch is done
;   if you want to clear the entire queue, it is better (read faster) to use the -c switch
;   usefull when you want to set a key with pushmode and you first clear any +k and -k modes
;     pushmode -dr #channel +b *!*@host.com    removes +b *!*@host.com from the default queue
;     pushmode -r #channel +v nick             removes +v nick from all queues
;     pushmode -rw #channel +b *               removes all bans from all queues
;     pushmode -rw #channel +?                 removes all single + modes from the queue
;     pushmode -rdl #channel +k key            removes +k key from the default and slower queue
;
;   The -uN switch can be used to remove a ban after N seconds using pushmode
;   using 0 for N, makes the script remove the ban from the internal tempban list
;   this will not remove the ban from the channel
;     pushmode -u120 #channel +b *!*@host.com        removes the ban *!*@host.com after 120 seconds
;     pushmode -u0 #channel +b *!*@leave.this.ban    removes *!*@leave.this.ban from the internal tempban list
;
;   The -eM switch (expire) removes the mode from the queue after M seconds,
;   so if the mode is not send within M seconds, it will not be send
;     pushmode -e10 #channel +m      mode +m will only be send within 10 seconds or not
;     pushmode -e60 #channel +l 100  mode +l 100 will only be send within 60 seconds or not
;
;   Combinations are possible, for example:
;     pushmode -nfpe60u600 #channel +b *!*user@*.host.com
;
;   The script can voice/devoice users even if they changed nick since the mode was in the queue
;   this can be done by giving nick!user@host as parameter
;   the default settings makes the script understand that @%+ is ohv, if you are on a server with additional
;   modes which can be set on users on a channel, you have to edit the prefix setting below
;   the target needs to be in your IAL list for this to work
;   the script adds/removes a tag to the IAL using ialmark and finds the nick when sending the mode
;   other scripts using ialmark may break this part
;
;     pushmode #channel +v goober!~bla@123.abc.isp.com                  will voice the user goober, even if he would
;                                                                       change nick before the mode is send
;
;     pushmode #channel -h somenick!someuser@abc.users.undernet.org     dehalfops somenick, even if he would
;                                                                       change nick before the mode is send
;
;     pushmode #channel +o dev-mirc!dev-mirc@def.users.quakenet.org     will op dev-mirc, even if he would
;                                                                       change nick before the mode is send
;
;
;  pushuser <+/-mode> [arg]
;
;    can be used for usermodes, usefull if you have several scripts setting usermodes on connect
;    pushuser will send them all at once instead of N times a mode command
;
;
;  Pushmode (pushuser) can only take 1 mode at a time
;  The - or + needs to be included
;  The script does not allow duplicates in the same queue
;  Temp bans work only if nick!user@host format is used (like *!*@host.com and not *host.com or just host.com)
;    this is because of the isban operator
;
;  Script is uses $modespl (MODES= setting),
;  here meaning how many parameter modes (like +b banmask) can be put into 1 line
;  the number of modes without parameter (like +m) is unlimited
;  if you want to use this script on a server where this is different, you have to change the script a bit
;  see the pushmode.dump alias
;
;  Some checks are done on the modes, like if the mode exists, if the mode makes "sense" etc.
;  it uses $chanmodes (with b,k,l,imnpst as default modes), checks op/halfop status.
;  you can see the checks and change them in the pushmode.dump alias
;
;
;What use has this script?
;
;  not only can you simply 'queue' mode changes from within the same event or script
;  but mode changes by all scripts can be pushed together
;
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; ALIAS PUSHMODE.DELAY ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; when first called, the script will wait N seconds before sending a mode change
alias -l pushmode.delay {
  return 1
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; ALIAS PUSHMODE.RESTART ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; set here the delay (seconds) pushmode should have between multiple mode lines
; after sending a mode change and there are items left in the queue,
; it will wait N seconds before sending the next mode change
alias -l pushmode.restart {
  return 2
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; ALIAS PUSHMODE.BAN ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; set here the delay (seconds) for checking which bans are to be unset
; a timer runs with this interval
; it checks the temp bans set by this script for all channels and unbans them with pushmode
; settings this to 600 (10 min) for example, makes a temp ban set for 5min being unset after 5~15 minutes
; so this setting defines how accurate the time of a temp ban is
alias -l pushmode.ban {
  return 600
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; ALIAS PUSHMODE.PREFIX ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; set here what modes can be set on a user on a channel (this is NOT b or any other list mode)
; default @ = o, % = h, + = v
; leave empty if you dont want to use this
; if you are not sure what this is, leave it
; replace each char with their mode char, @ is o for example
alias -l pushmode.prefix {
  return $nickmode
  ; should $nickmode not work, remove it and use the following line
  return $replace($prefix,~,&,@,o,%,h,+,v)
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; ALIAS PUSHMODE ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; pushmode [-cdflnprswuNeM] <channel> <+/-mode> [arg]
alias pushmode {
  var %f, %q, %p, %e, %u

  ; part for switches
  if ($left($1,1) == -) {

    ; c switch is there
    if (c isin $1) {

      ; no channel
      if (!$2) {

        ; d switch is there, clear all default queues for this connection
        if (d isin $1) { $pushmode.queue($+($cid,.pushmode.*.default)).clear }

        ; n switch is there, clear all next queues for this connection
        if (n isin $1) { $pushmode.queue($+($cid,.pushmode.*.next)).clear }

        ; l switch is there, clear all low queues for this connection
        if (l isin $1) { $pushmode.queue($+($cid,.pushmode.*.low)).clear }

        ; s switch is there, clear all single queues for this connection
        if (s isin $1) { $pushmode.queue($+($cid,.pushmode.*.single)).clear }

        ; no other switches, clear all queues for this connection
        if (n !isin $1) && (d !isin $1) && (l !isin $1) && (s !isin $1) { $pushmode.queue($+($cid,.pushmode.*)).clear }
      }
      else {

        ; d switch is there, clear the default queue for the channel
        if (d isin $1) { $pushmode.queue($+($cid,.pushmode.,$hash($2,32),.default)).clear }

        ; n switch is there, clear the next queue for the channel
        if (n isin $1) { $pushmode.queue($+($cid,.pushmode.,$hash($2,32),.next)).clear }

        ; l switch is there, clear the low queue for the channel
        if (l isin $1) { $pushmode.queue($+($cid,.pushmode.,$hash($2,32),.low)).clear }

        ; s switch is there, clear the single queue for this connection
        if (s isin $1) { $pushmode.queue($+($cid,.pushmode.,$hash($2,32),.single)).clear }

        ; no other switches, clear all queues for the channel
        if (n !isin $1) && (d !isin $1) && (l !isin $1) && (s !isin $1) {
          $pushmode.queue($+($cid,.pushmode.,$hash($2,32),.next)).clear
          $pushmode.queue($+($cid,.pushmode.,$hash($2,32),.default)).clear
          $pushmode.queue($+($cid,.pushmode.,$hash($2,32),.low)).clear
          $pushmode.queue($+($cid,.pushmode.,$hash($2,32),.single)).clear
        }
      }
      return
    }

    ; f switch is there, set a var
    if (f isin $1) { var %f = 1 }

    ; n switch is there, set a var
    if (n isin $1) { var %q = next }

    ; l switch is there, set a var
    elseif (l isin $1) { var %q = low }

    ; p switch is there, set a var
    if (p isin $1) { var %p = 1 }

    ; u or e switch is used, set a var
    if (u isin $1) || (e isin $1) { var %string = $remove($1,-,d,c,f,l,n,p,r,s,w) , %x = 1

      ; loop through all chars
      while (%x <= $len(%string)) {

        ; found u, set a var
        if ($mid(%string,%x,1) == u) { var %y = $calc(%x +1)

          ; as long as it is numbers, set a var, next char
          while ($mid(%string,%y,1) isnum) { var %u = %u $+ $mid(%string,%y,1) | inc %y }
        }

        ; found e, set a var
        if ($mid(%string,%x,1) == e) { var %y = $calc(%x +1)

          ; as long as it is numbers, set a var, next char
          while ($mid(%string,%y,1) isnum) { var %e = %e $+ $mid(%string,%y,1) | inc %y }
        }
        inc %x
      }

      ; '%e' is a number, set a var
      if (%e isnum) { var %e = -e $+ %e }
    }

    ; u switch is there with a number, +b and a banmask, add to the hash table, make it decrease each second
    if (u isin $1) && ($3 == +b) && ($4) && (%u > 0) {
      hadd -m $+($cid,.pushmode.,$hash($2,32),.bans) $4 %u | hdec -c $+($cid,.pushmode.,$hash($2,32),.bans) $4

      ; check the timer, start the timer
      if (!$timer($+($cid,.pushmode.bans))) {
        .timer $+ $cid $+ .pushmode.bans 1 $$pushmode.ban pushmode.tempban
      }
    }

    ; number with u is 0
    if (%u == 0) && ($3 == +b) && ($4) {

      ; check if it is already in the hash table as temp ban,  delete it
      if ($hget($+($cid,.pushmode.,$hash($2,32),.bans))) && ($hget($+($cid,.pushmode.,$hash($2,32),.bans),$4)) {
        hdel $+($cid,.pushmode.,$hash($2,32),.bans) $4

        ; check if the hash table is empty, free the hash table
        if ($hget($+($cid,.pushmode.,$hash($2,32),.bans),0).item == 0) {
          hfree $+($cid,.pushmode.,$hash($2,32),.bans)
        }
      }
      return
    }

    ; r switch is there and mode '$3' 
    if (r isin $1) && ($3) {

      ; w switch is there
      if (w isin $1) {

        ; no parameter, remove the mode from the single queue
        if ($4 == $null) { pushmode.queue -rw $+($cid,.pushmode.,$hash($2,32),.single) $3 }
        else {

          ; d switch is there, remove the mode from the default queue
          if (d isin $1) { pushmode.queue -rw $+($cid,.pushmode.,$hash($2,32),.default) $3-4 }

          ; n switch is there, remove the mode from the next queue
          if (n isin $1) { pushmode.queue -rw $+($cid,.pushmode.,$hash($2,32),.next) $3-4 }

          ; l switch is there, remove the mode from the low queue
          if (l isin $1) { pushmode.queue -rw $+($cid,.pushmode.,$hash($2,32),.low) $3-4 }

          ; no other switch is there, remove the mode from all queues
          if (n !isin $1) && (d !isin $1) && (l !isin $1) {
            pushmode.queue -rw $+($cid,.pushmode.,$hash($2,32),.next) $3-4 | pushmode.queue -rw $+($cid,.pushmode.,$hash($2,32),.low) $3-4 | pushmode.queue -rw $+($cid,.pushmode.,$hash($2,32),.default) $3-4
          }
        }
      }
      else {

        ; no parameter, remove mode from the single queue
        if ($4 == $null) { pushmode.queue -r $+($cid,.pushmode.,$hash($2,32),.single) $3 }
        else {

          ; d switch is there, remove mode form the default queue
          if (d isin $1) { pushmode.queue -r $+($cid,.pushmode.,$hash($2,32),.default) $3-4 }

          ; n switch is there, remove mode form next queue
          if (n isin $1) { pushmode.queue -r $+($cid,.pushmode.,$hash($2,32),.next) $3-4 }

          ; l switch is there, remove mode form the low queue
          if (l isin $1) { pushmode.queue -r $+($cid,.pushmode.,$hash($2,32),.low) $3-4 }

          ; no other switch is there, remove mode form all queues
          if (n !isin $1) && (d !isin $1) && (l !isin $1) && (s !isin $1) {
            pushmode.queue -r $+($cid,.pushmode.,$hash($2,32),.next) $3-4 | pushmode.queue -r $+($cid,.pushmode.,$hash($2,32),.low) $3-4 | pushmode.queue -r $+($cid,.pushmode.,$hash($2,32),.default) $3-4
          }
        }
      }
      return
    }
    tokenize 32 $2-
  }

  ; leave multiple modes out
  tokenize 32 $1 $left($2,2) $3

  ; '$2' starts with '+' or with '-', we are on channel '$1'
  if ($istok(+ -,$left($2,1),32)) && ($me ison $1) {

    ; '$3' does exist
    if ($3 != $null) {

      ; -n switch was used, queue mode '$2 $3' in the next queue
      if (%q == next) { pushmode.queue %e $+($cid,.pushmode.,$hash($1,32),.next) $2-3 }

      ; -l switch was used, queue mode '$2 $3' in the low queue
      elseif (%q == low) { pushmode.queue %e $+($cid,.pushmode.,$hash($1,32),.low) $2-3 }

      ; use default queue, queue mode '$2 $3' in the 'default' queue
      else { pushmode.queue %e $+($cid,.pushmode.,$hash($1,32),.default) $2-3 }
    }

    ; the mode does not have a parameter, queue mode '$2' it in the single queue
    else { pushmode.queue $+($cid,.pushmode.,$hash($1,32),.single) $2 }

    ; check if the timer is not already running and check the -p switch, start the timer
    if (!$timer($+($cid,.pushmode.,$hash($1,32)))) && (%p != 1) {
      .timer $+ $cid $+ .pushmode. $+ $hash($1,32) 1 $$pushmode.delay pushmode.dump $1
    }

    ; no timer, and passive switch, set a var
    if (!$timer($+($cid,.pushmode.,$hash($1,32)))) && (%p == 1) {
      var %x = 1, %queue = .next .default .low, %q = 1, %t = 0

      ; loop through each queue, inc var, next queue
      while ($gettok(%queue,%q,32)) {
        inc %t $pushmode.queue($+($cid,.pushmode.,$hash($1,32),$gettok(%queue,%q,32))).size | inc %q
      }

      ; at least $modespl modes in the queues, start the timer
      if (%t >= $modespl) {
        .timer $+ $cid $+ .pushmode. $+ $hash($1,32) 1 $$pushmode.delay pushmode.dump $1
      }
    }

    ; f switch was used
    if (%f == 1) {

      ; no channel, set a var
      if (!$1) { var %x = $chan(0)

        ; loop through all the channels, stop the timer, run 'pushmode.dump chan', decrease '%x' and go on to the next channel
        while (%x) {
          .timer $+ $+($cid,.pushmode.,$hash($chan(%x),32)) off | pushmode.dump $chan(%x) | dec %x
        }
      }

      ; we are on '$1', stop the timer, run 'pushmode.dump $1'
      elseif ($me ison $1) {
        .timer $+ $+($cid,.pushmode.,$hash($1,32)) off | pushmode.dump $1
      }
    }
  }
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; ALIAS PUSHMODE.DUMP ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; $1 = #channel
alias -l pushmode.dump {

  ; we are on channel '$1',  set vars
  if ($me ison $1) { var %x = 1, %queue = .next .default .low, %q = 1, %mode, %check, %smode

    ; loop through each queue
    while ($gettok(%queue,%q,32)) {

      ; we loop as long as '%x' <= '$modespl' and as long as the size of the queue is greater then 0
      while (%x <= $modespl) && ($pushmode.queue($+($cid,.pushmode.,$hash($1,32),$gettok(%queue,%q,32))).size > 0) {

        ; save the next item in a var
        var %next = $pushmode.queue($+($cid,.pushmode.,$hash($1,32),$gettok(%queue,%q,32))).next

        ; check if mode is not already going to be set
        if (!$istokcs(%check,%next,44)) && (%next) { var %1 = $gettok(%next,1,32), %2 = $gettok(%next,2,32)

          ; some checks / examples of checks
          if (%1 === +o) && (%2 isop $1) { }
          elseif (%1 === -o) && (%2 !isop $1) { }
          elseif (%1 === +h) && (%2 ishop $1) { }
          elseif (%1 === -h) && (%2 !ison $1) { }
          elseif (%1 === +v) && (%2 isvoice $1) { }
          elseif (%1 === -v) && (%2 !ison $1) { }
          elseif (%1 === +b) && (%2 isban $1) { }
          elseif (%1 === +l) && ((%2 !isnum) || (%2 < 1)) { }
          elseif (%1 === +l) && (%2 == $chan($1).limit) { }
          elseif (%1 === +k) && ($chan($1).key) { }
          elseif (%1 === -k) && (%2 !=== $chan($1).key) { }
          elseif ($right(%1,1) === o) && ($me !isop $1) { }
          elseif ($right(%1,1) === h) && ($me !isop $1) { }
          elseif ($me !isop $1) && ($me !ishop $1) { }

          ; add '%next' to '%check', add the mode in the var
          else { var %check = $addtok(%check,%next,44) | var %mode = $+($gettok(%mode,1,32),$gettok(%next,1,32)) $gettok(%mode,2-,32) $gettok(%next,2,32) }
          inc %x
        }
      }
      inc %q
    }

    ; we loop as long as the size of the single queue is greater then 0, set vars
    while ($pushmode.queue($+($cid,.pushmode.,$hash($1,32),.single)).size > 0) {
      var %next = $pushmode.queue($+($cid,.pushmode.,$hash($1,32),.single)).next
      var %a = $+($gettok($chanmodes,1,44),b), %b = $+($gettok($chanmodes,2,44),k)
      var %c = $+($gettok($chanmodes,3,44),l), %d = $+($gettok($chanmodes,4,44),imnpst)

      ; some checks / examples of checks
      if ($right(%next,1) isincs %b) { }
      elseif ($right(%next,1) isincs %c) && ($left(%next,1) == +) { }
      elseif ($right(%next,1) isincs %b) { }
      elseif ($me !isop $1) && ($me !ishop $1) && ($right(%next,1) !isincs %a) { }

      ; add next mode to the var
      else { var %smode = $+(%smode,%next) }
    }

    ; if the ibl isnt filled for that channel, add +b to request the banlist
    ; if you want this uncomment the following line
    ;if (b !isincs %smode) && (!$chan($1).ibl) { var %smode = $+(%smode,+b) }

    ; add the mode in the var
    var %mode = $+($gettok(%mode,1,32),%smode) $gettok(%mode,2-,32)

    ; there are modes in '%mode', send the modes
    if (%mode) { .quote MODE $1 %mode }
    var %q = 1

    ; loop through the queues
    while ($gettok(%queue,%q,32)) {

      ; items left, break
      if ($pushmode.queue($+($cid,.pushmode.,$hash($1,32),$gettok(%queue,%q,32))).size > 0) { break }
      inc %q
    }

    ; loop was ended with break, start the timer
    if (%q <= $numtok(%queue,32)) {
      .timer $+ $cid $+ .pushmode. $+ $hash($1,32) 1 $$pushmode.restart pushmode.dump $1
    }
  }
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; ALIAS PUSHUSER ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; $1 = +/-mode, $2 = param
alias pushuser {

  ; remove multiple modes, only use the 1st one given
  tokenize 32 $left($1,2) $2

  ; '$2' is 2 chars long and '$1' starts with '+' or with '-'
  if ($len($1) == 2) && ($istok(+ -, $left($1,1),32)) {

    ; '$2' exists, add the mode to the user queue
    if ($2 != $null) { pushmode.queue $+($cid,.user) $1-2 }

    ; '$2' does not exist, add the mode to the user queue
    else { pushmode.queue $+($cid,.user) $1 }

    ; check if the timer already runs, start the timer
    if (!$timer($+($cid,.pushuser))) {
      .timer $+ $cid $+ .pushuser 1 $$pushmode.delay pushuser.dump
    }
  }
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; ALIAS PUSHUSER.DUMP ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
alias -l pushuser.dump {

  ; loop as long as there are items in the user queue, set a var with the next item, add the mode to the var
  while ($pushmode.queue($+($cid,.user)).size > 0) { var %next = $pushmode.queue($+($cid,.user)).next
  var %mode = $+($gettok(%mode,1,32),$gettok(%next,1,32)) $gettok(%mode,2-,32) $gettok(%next,2,32) }

  ; if '%mode' exists, send the modes
  if (%mode) { .quote MODE $me %mode }
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; ALIAS PUSHMODE.QUEUE ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; pushmode.queue [-eNrw] table mode param
alias -l pushmode.queue {
  var %e

  ; switch is used
  if ($left($1,1) == -) {

    ; got a switch, there are numbers, set a var
    if (e isin $1) { if ($right($1,-2) isnum) { var %e = $+(-u,$right($1,-2)) } }

    ; r switch, w switch, set var
    if (r isin $1) { if (w isin $1) { var %x = $hfind($2,$3-4,0,w).data
        while (%x) {

          ; check hash table, delete
          if ($gettok($hget($2,$hfind($2,$3-4,%x,w).data),1,32) === $3) || ($3 iswm $gettok($hget($2,$hfind($2,$3-4,%x,w).data),1,32)) {
            hdel $2 $hfind($2,$3-4,%x,w).data
          }
          dec %x
        }
      }

      ; no w switch, set vars
      else {
        var %param = $replace($4,\,\\,|,\|,$chr(40),$+(\,$chr(40)),$chr(41),$+(\,$chr(41)),$chr(91),$+(\,$chr(91)),$chr(93),$+(\,$chr(93)),^,\^,$chr(123),$+(\,$chr(123)),$chr(125),$+(\,$chr(125)),.,\.,$,\$,+,\+,*,\*,?,\?)
        var %mode = \ $+ $left($3,1) $+ $chr(91) $+ $replace($left($3,2),\,\\,|,\|,$chr(40),$+(\,$chr(40)),$chr(41),$+(\,$chr(41)),$chr(91),$+(\,$chr(91)),$chr(93),$+(\,$chr(93)),^,\^,$chr(123),$+(\,$chr(123)),$chr(125),$+(\,$chr(125)),.,\.,$,\$,+,\+,*,\*,?,\?) $+ $chr(93)

        ; check hash table, delete
        if ($hfind($2,%mode %param,1,r).data) { hdel $2 $hfind($2,%mode %param,1,r).data }
      }

      ; 1 item left, free hash table
      if ($hget($2,0).item == 1) { hfree $2 }
      return
    }
    tokenize 32 $2-4
  }

  ; mode is a usermode, it matches *!*@* and no * or ? are there, and its not for the umode queue
  if ($right($2,1) isin $pushmode.prefix) && (*!*@* iswm $3) && (* !isin $3) && (? !isin $3) && (*.user !iswm $1) {

    ; the user is in the ial, add tag to ialmark, tokenize
    if ($ial($gettok($3,1,33))) {
      .ialmark $gettok($3,1,33) $ial($gettok($3,1,33)).mark $+($1,.,$iif($hget($1,last),$calc($ifmatch +1),1))
      tokenize 32 $1 $2 $+(*!,$gettok($3,2,33))
    }

    ; user is not in ial, tokenize
    else { tokenize 32 $1 $2 $gettok($3,1,33) }
  }

  ; set a var, prefix special chars in a regex with a \
  var %param = $replace($3,\,\\,|,\|,$chr(40),$+(\,$chr(40)),$chr(41),$+(\,$chr(41)),$chr(91),$+(\,$chr(91)),$chr(93),$+(\,$chr(93)),^,\^,$chr(123),$+(\,$chr(123)),$chr(125),$+(\,$chr(125)),.,\.,$,\$,+,\+,*,\*,?,\?)
  var %mode = \ $+ $left($2,1) $+ $chr(91) $+ $replace($left($2,2),\,\\,|,\|,$chr(40),$+(\,$chr(40)),$chr(41),$+(\,$chr(41)),$chr(91),$+(\,$chr(91)),$chr(93),$+(\,$chr(93)),^,\^,$chr(123),$+(\,$chr(123)),$chr(125),$+(\,$chr(125)),.,\.,$,\$,+,\+,*,\*,?,\?) $+ $chr(93)

  ; there is a 2nd parameter and mode '%mode %param' is not already in the queue, where '%mode' is case sensitive
  if ($2 != $null) && ($hfind($1,%mode %param,0,r).data == 0) {

    ; increase item 'last', add mode '$2-' to the hashtable with item name that 'last' has
    hinc -m $1 last | hadd $+(-m,%e) $1 $hget($1,last) $2-
  }

  ; propertie is next and hash table '$1' exists, increase item 'first'
  elseif ($isid) && ($prop == next) && ($hget($1)) { hinc -m $1 first

    ; 'first' is smaller or equal to 'last', set vars
    if ($hget($1,first) <= $hget($1,last)) {
      var %next = $hget($1,$hget($1,first)), %number = $hget($1,first)
      var %mode = $gettok(%next,1,32), %param = $gettok(%next,2,32)

      ; mode is a usermode, parameter matches *!*@*, set var
      if ($right(%mode,1) isin $pushmode.prefix) && (*!*@* iswm %param) {
        var %x = $ial(%param,0)
        while (%x) { var %nick = $ial(%param,%x).nick

          ; the tag is there, remove it, set var, stop loop
          if ($wildtok($ial(%nick).mark,$+($1,.,%number),1,32)) {
            .ialmark %nick $remove($ial(%nick).mark,$ifmatch)
            var %next = %mode %nick | break
          }
          dec %x
        }

        ; no matches found, clear var
        if (%x == 0) { var %next = $null }
      }

      ; delete this item from the hashtable
      hdel $1 $hget($1,first)

      ; this is the last item, free the hash table
      if ($hget($1,first) >= $hget($1,last)) { hfree $1 }
      return %next
    }
  }

  ; called as identifier ($alias) and propertie is size ($alias().size)
  ; decrease number of items with 1, (1 item in queue, and last is there)
  elseif ($isid) && ($prop == size) { return $iif($calc($hget($1,0).item -1) >= 0,$ifmatch,0) }

  ; called as identifier ($alias) and propertie is clear ($alias().clear), free hashtables that match $1
  elseif ($isid) && ($prop == clear) { hfree -w $1 }
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; ALIAS PUSHMODE.TEMPBAN ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
alias -l pushmode.tempban {
  var %x = 1

  ; loop through the channels
  while (%x <= $chan(0)) {

    ; loop as long as a match is found, items with values 0 or lower
    while ($hfind($+($cid,.pushmode.,$hash($chan(%x),32),.bans),/^[0-]/,1,r).data) {

      ; ibl is not filled, or the ban is set, use pushmode to remove the ban
      if (!$chan(%x).ibl) || ($hfind($+($cid,.pushmode.,$hash($chan(%x),32),.bans),/^[0-]/,1,r).data isban $chan(%x)) {
        pushmode $chan(%x) -b $hfind($+($cid,.pushmode.,$hash($chan(%x),32),.bans),/^[0-]/,1,r).data
      }

      ; del the item from the hash table
      hdel $+($cid,.pushmode.,$hash($chan(%x),32),.bans) $hfind($+($cid,.pushmode.,$hash($chan(%x),32),.bans),/^[0-]/,1,r).data
    }

    ; check if hash table is empty and the hash table exists, remove hash table
    if ($hget($+($cid,.pushmode.,$hash($chan(%x),32),.bans),0).item == 0) && ($hget($+($cid,.pushmode.,$hash($chan(%x),32),.bans))) {
      hfree $+($cid,.pushmode.,$hash($chan(%x),32),.bans)
    }
    inc %x
  }

  ; start the timer
  .timer $+ $cid $+ .pushmode.bans 1 $$pushmode.ban pushmode.tempban
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; DISCONNECT EVENT ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
on *:disconnect: { pushmode -c }
