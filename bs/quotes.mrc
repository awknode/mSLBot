on *:LOAD: set %owner $input(Enter name of the bot owner:,e) 
#fcheck on
alias -l fcheck {
  if ($regex($1,/(quote|qotd|qsearch)$/Si)) {
    if ($prop = add) set -z $+(%,$regml(1),$site,$network) %fMins
    else return $+(%,$regml(1),$site,$network)
  }
}
#fcheck end

alias -l up return $+($left($1,1),$mid($1,2)) 

on *:text:*:#: {
  var %file quotes.txt, %x $lines(%file), %y $read(%file, n, $2), %rx $r(1,$lines(%file)), %ry $read(%file, n, %rx)
  if (!%x && $regex($1,/^!q(del|uote|otd|search|lines|open)$/Si)) { msg # I haven't seen any funny shit yet, if you do type !addquote 12some funny shit here. | halt }
  if ($1 = !addquote) {
    spamprotect
    ; if ($nick !isop # && $v1 != %owner) { notice $v1 You need ops 12bitch. | halt }
    if (!$2) { notice $nick 12Invalid format. | halt }
    tokenize 58 $2- | write %file $1- 12- $adate 12- $chan 12- $nick | var %x $lines(%file) | msg # .12Quote. %x has been submitted. 
  }
  if ($1 = !delquote) {
    if ($nick != %owner) { notice $v1 Tell $v2 to delete quotes. | halt }
    if (!$2) { notice $nick 15Proper syntax: $+(,[,,$1,) 1 - %x $+ ] | halt }
    var %i $numtok($2-, 32)
    while (%i) { var %list $sorttok($addtok(%list,$gettok($sorttok($2-, 32, n),%i,32),32),32,n) | dec %i }
    var %j $numtok(%list, 32) 
    while (%j) { 
      if (!$read(%file, n, $gettok(%list,%j,32))) msg # $gettok(%list,%j,32) is 12null af.
      else { 
        notice $nick Quote # $+ $gettok(%list,%j,32) has been 12deleted
        write -dl $gettok(%list,%j,32) %file 
      }  
      dec %j 
    }
  }  
  if ($1 = !quote) {
    spamprotect
    if ($2 && $2 !isnum) { notice $nick 12Invalid format. 12.ie. !quote 1 - %x $+ 12. | halt }
    if ($2 && !%y || $2 < 0) { notice $nick 12Quote $2 doesn't exist. There are only %x quotes in my db. | halt }
    if ($($fcheck($right($1, -1)),2)) { notice $nick 12Slow down nerd. $duration($v1) 12left. | halt }
    $fcheck($right($1, -1)).add
    if (!$2) { msg # .12Quotes. %rx 12- %ry | halt }
    msg # .12Quote. $2 12- %y
  }

  if ($1 == !qsearch) {
    spamprotect
    var %x $lines(quotes.txt)
    while (%x) {
      if ($2- isin $read(quotes.txt,%x)) {
        inc %quotes.search
        set %quotes.return $addtok(%quotes.return,%x,32)
      }
      dec %x
    }
    if (!%quotes.search) { 
      set -u3 %quoteflood on
    msg # .12Search.   No quotes found from string " $+ $2- $+ " | unset %quotes.* | halt }
    if (%quotes.search = 1) { 
      set -u3 %quoteflood on
    msg # .12Search. 1 quote found: $+([,%quotes.return,]) $read(quotes.txt,n,%quotes.return) | unset %quotes.* }
    else {
      set -u3 %quoteflood on
      msg # .12Quote. Found %quotes.search quotes that contain $+(",$2-,") 
      .timer 1 2 .msg $chan .12Quote. $+($gettok(%quotes.return,1,32),/,$lines(quotes.txt), $chr(32) $chr(41) )  $replace($read(quotes.txt, n, $gettok(%quotes.return,1,32)),|,$!chr(124))   
      .timer 1 4 .msg $chan .12Other Relevant Quotes14) $right(%quotes.return,-2) also contains $+(",$2-,") 
      unset %quotes.*
    }
  }

  if ($1 == !qhelp) {
    exprotect $1-
    spamprotect
    if ($nick !isin $readini(quotes.ini,bans,bans)) {
      set -u3 %quoteflood on
      /notice $nick 12Quote command list
      /notice $nick 12!quote - Displays quote <number> from quote database. If there is no <number>, it displays a 
      /notice $nick random quote.
      /notice $nick 12!addquote - Adds a quote to the database.
      /notice $nick 12!qnum - Displays the number of quotes in the database.
      /notice $nick 12!qsearch [text] - Places a search on second string of [text] in quote databas.
      /notice $nick 12!qban [add-del] <nick> - Adds or deletes <nick> to the banlist.
      /notice $nick 12!qban [list] - Lists the names on the ban list.
      /notice $nick 12!delquote <number> - Deletes quote <number> from the database.
      /notice $nick 12!qmod [add12/del] <nick> - Adds or deletes <nick> to the mod list.
      /notice $nick 12!qmod [list] - Lists names on quote mod list.
    }
    else {
      set -u3 %quoteflood on
      /msg $chan you are 12banned from my quote script. Contact 12int to see about removal of the ban
    }
  }





  ;  if ($1 = !qotd) {
  ;    spamprotect
  ;    exprotect $1-
  ;    if (%date != $date) var -g %date $v2, %qotd %rx
  ;    if ($($fcheck($right($1, -1)),2)) { notice $nick $duration($v1) before that cmd is available to you again. Slow it down pony boy. | halt }
  ;    $fcheck($right($1, -1)).add | msg # 8Quote of the the Day: $read(%file, n, %qotd) 
  ;  }
  ;  if ($1 = !qsearch) {
  ;    spamprotect
  ;    exprotect $1-
  ;    if ($($fcheck($right($1, -1)),2)) { notice $nick $duration($v1) before that cmd is available to you again. Slow it down pony boy. | halt }
  ;    $fcheck($right($1, -1)).add
  ;    if (!$2) { notice $nick 15Proper syntax: [ex: !qsearch <term>] | halt }
  ;    var %i 1 | while ($read(%file,n,%i)) {
  ;      if ($2 = -a) {
  ;        var %author $gettok($read(%file,n,%i),1,2)
  ;        if ($3- $+ : = $strip(%author,b)) var %qsearch $addtok(%qsearch,%i,32) 
  ;      }  
  ;      elseif ($2- isin $read(%file,n,%i)) var %qsearch $addtok(%qsearch,%i,32) 
  ;      inc %i
  ;    }
  ;    if (!%qsearch) notice $nick 15No quotes matching $+(15,$iif($2 = -a,$3-,$2),.) 
  ;    else msg # 15Quotes found $+(,$iif($2 = -a,$3-,$2-),: ,%qsearch,)
  ;  }
  if ($1 = !qon && $regex($2,/^o(|n|ff)$/Si) && $nick = %owner) {
    spamprotect
    exprotect $1-
    if (!%aMins) { notice $nick 15You must first set the duration. | notice $nick 15Proper syntax: [!atime <min>]] | halt }
    if ($regml(1) = n) { msg # Auto quote has been activated. | timerAQuote 0 %aMins msg # Quote: $!read( %file , n) }
    elseif ($timer(AQuote)) { timerAQuote $2 | msg # 15 $+ Auto quote has been deactivated. }
  }
  if ($1 = !qnum) msg # Total number of quotes: %x quotes added.
  if ($1 = !qfile && $nick = %owner) run %file
  if ($regex($1,/^!(a|f)time$/Si) && $nick = %owner) {
    if ($2 isnum && $2 >= 0) {
      set $+(%,$regml(1),Mins $calc($int($2) * 60 + $gettok($2,2,46)))
      msg # Quote set to $iif($regml(1) = a,aQuote,floodcheck) every $2 minutes.  
    }
  }
  if ($1 = !flookchk && $regex($2,/^o(|n|ff)$/Si) && $nick = %owner) {
    if (!%fMins) { notice $nick 15Set time duration dumbass. | notice $nick 15Proper syntax: [!fTime <mins>] | halt }
    $iif($regml(1) = n,en,dis) $+ able #fcheck
    msg # 15Flood check: $iif($v1 = $v2,en,dis) $+ abled.   
  }
}
