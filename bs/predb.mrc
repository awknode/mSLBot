on *:TEXT:*:#:{
  if (!predb == $1) {
    if ($timer(predb).secs) {
      .timerpredb off
      .msg $predbch Pre Announce Stopped.
    }
    elseif (!$timer(predb).secs) {
      .timer 1 3 sockopen -e predb predb.org 443
      .timerpredb 0 60 sockopen -e predb predb.org 443
      .msg $predbch Pre Announce Started.
    }
  }
  if (!presearch == $1) {
    unset %predbsearch
    if ($3) {
      set %predbsearch.q $3-
      if ($2 isnum 1-10) {
        set %predbsearch.page $2
      }
      elseif ($2 !isnum 1-10) { msg $chan USAGE: !presearch <page>  <search term>  (page can be a number from 1 to 10) | return }
      sockopen -e predbsearch predb.org 443
      set %predbsearch.chan $chan
      msg $chan Type !prestop to stop the results.
    }
    elseif (!$3) { msg $chan USAGE: !presearch <page>  <search term>  (page can be a number from 1 to 10) }
  }
  if (!prestop == $1) { 
    if ($sock(predbsearch)) {
      .timerpredbsearch* off
      endpredb
    }
  }
}

on *:SOCKOPEN:predb: {
  sockwrite -nt $sockname GET / HTTP/1.1
  sockwrite -nt $sockname Host: predb.org
  sockwrite $sockname $crlf
}

on *:SOCKOPEN:predbsearch: {
  sockwrite -nt $sockname GET $+(/search/,%predbsearch.q,$iif(%predbsearch.page, $+(/page/,$v1), $null)) HTTP/1.1
  sockwrite -nt $sockname Host: predb.org
  sockwrite $sockname $crlf
}

on *:SOCKREAD:predb: {
  var %predb
  sockread %predb
  if (*tr class="post" id=* iswm %predb) {
    var %id = $gettok(%predb,4,34)
    if (!%predblastid) || (%predblastid != %id) { set %predblastid %id }
    elseif (%predblastid == %id) { sockclose $sockname }
    ;;; %predblastid is not a typo. the dot is missing on purpose :) ;;;
  }
  if (*td class="pretime"* iswm %predb) { set %predb.time $gettok($gettok(%predb,2,62),1,60) }
  if (*td class="cat"* iswm %predb) { set %predb.catl $+(www.predb.org,$gettok(%predb,4,34)) | set %predb.cat $gettok(%predb,6,34) }
  if (*td class="grp"* iswm %predb) { set %predb.grpl $+(www.predb.org,$gettok(%predb,4,34)) | set %predb.grp $gettok(%predb,6,34) }
  if (*td class="rls"* iswm %predb) { 
    set %predb.rls $gettok(%predb,6,34)
    sockclose $sockname
    msg $predbch %predb.time Ago. Category: %predb.catl %predb.cat Group: %predb.grpl %predb.grp Title: %predb.rls
    inc %counterpredb
    if (%counterpredb == 5000) { .timer 1 5 msg $predbch Predb.org mIRC Announcer Scripted by OrFeAsGr! mIRC Scripts & More: http://mirc-land.tk - My art work: http://orpheusgr.tk | unset %counterpredb }
    unset %predb.*
  }
}

on *:SOCKREAD:predbsearch: {
  var %predb
  sockread %predb
  if (*tr class="post" id=* iswm %predb) { set %predbsearch.id $gettok(%predb,4,34) }
  if (*td class="pretime"* iswm %predb) { set %predbsearch.time $gettok($gettok(%predb,2,62),1,60) }
  if (*td class="cat"* iswm %predb) { set %predbsearch.catl $+(www.predb.org,$gettok(%predb,4,34)) | set %predbsearch.cat $gettok(%predb,6,34) }
  if (*td class="grp"* iswm %predb) { set %predbsearch.grpl $+(www.predb.org,$gettok(%predb,4,34)) | set %predbsearch.grp $gettok(%predb,6,34) }
  if (*td class="rls"* iswm %predb) { 
    .timerendpredb off
    set %predbsearch.rls $gettok(%predb,6,34)
    inc %predbsearch.resc 2
    $+(.timerpredbsearch,%predbsearch.resc) 1 %predbsearch.resc msg %predbsearch.chan %predbsearch.time ago. 12Category %predbsearch.catl %predbsearch.cat Group: %predbsearch.grpl %predbsearch.grp Title: %predbsearch.rls $+(https://predb.org/post/,%predbsearch.id,/)
    .timerendpredb 1 5 endpredb
  }
}

alias predbch { 
  return #testzz,#pre 
  ;;seperate multiple channels with a comma -> , (e.g #Home,#chat,#cafe)
}

alias endpredb { sockclose predbsearch | unset %predbsearch.* }
