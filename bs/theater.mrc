on *:TEXT:*:#: {
  if ($1 == !theatre) || ($1 == !cinema) {
    ;if (m isin $chan(#).mode) { .timertheatre. $+ $nick 1 5 .notice $nick Script is OFF due to channel being mdoerated (+m). | halt }
    if (!$findtok(%theatre,$nick,0,46)) {
      set -u10 %theatre $addtok(%theatre,$nick,46)
      var %a = theatre
      h %a chan $chan
      h %a cid $cid
      h %a nick $nick
      h %a network $network
      theatre $nick $2-
    }
    else .timertheatre. $+ $nick 1 1 .notice $nick Please wait 10 seconds and try again...
  }
}
on *:INPUT:#:{
  if ($1 == !theatre) || ($1 == !cinema) {
    ;if (m isin $chan(#).mode) { .notice $nick Script is OFF due to channel being mdoerated (+m). | halt }
    var %a theatre
    h %a chan $chan
    h %a network $network
    h %a cid $cid
    h %a nick $me
    theatre $me $2-
  }
}

alias -l theatre {
  if ($1 != $me) echo -st theatreinfo $1-
  if (!$2) {
    var %cmd .notice $1
    %cmd !theatre Usage: !theatre [options]
    %cmd Options:
    %cmd       Results types: Top or New (Default is New) - Top will list top grossing movies, New will list newest movies
    %cmd       List results is a maximum of 10 results (Default is 10). Example: $1 New 5 - Lists 5 Newest movies
  }
  else {
    .timertheatre.gclean 0 180 theatre.gclean
    var %a, %b, %p, %u, %o
    var %options, %category, %query
    h theatre results 5
    h theatre result 5
    h theatre query New
    if ($2 == Top) {
      h theatre result $iif($3 isnum,$3,10)
      h theatre results $iif($3 isnum,$3,10)
      h theatre query Top
    }
    elseif ($2 == New) {
      h theatre result $iif($3 isnum,$3,10)
      h theatre results $iif($3 isnum,$3,10)
    }
    elseif ($2 isnum) {
      h theatre result $2
      h theatre results $2
    }
    elseif ($3 isnum) {
      if ($2 == New) || ($2 == Top) {
        h theatre result $3
        h theatre results $3
        h theatre query $2
      }
    }
    ;h theatre query $replace(%b,.,% $+ 20,_,% $+ 20,+,% $+ 20,-,% $+ 20)

    if ($h(theatre,result) > 10) { h theatre result 10 | h theatre results 10 }

    .notice $h(theatre,nick) Retrieving listings...
    set %u http://www.imdb.com/movies-in-theaters/
    h theatre u %u
    theatre.download theatre.complete %u theatre.txt
    ;echo -a ------ %u ---------------
  }
}
alias -l theatre.complete {
  if ($1 == 1) && ($2 == S_OK) {
    var %a = @theatre, %b, %d = 0, %e, %z = 0, %t, %cmd
    while (%z < $h(theatre,results)) {
      var %date, %rating, %metascore, %reviews, %genre, %title, %money, %url
      inc %z

      h theatre no %z

      if (%z == 1) {
        if ($window(%a)) window -c %a
        window -h %a
        loadbuf %a theatre.txt
        var %start 1- $+ $iif($h(theatre,query) == new,$calc($fline(%a,*Opening This Week*,1) - 1),$calc($fline(%a,*In Theaters Now - Box Office Top Ten*,1) - 1))
        if ($h(theatre,query) == new) {
          dline %a %start

          ;this deleted the lines after "in theatre now" so the top box office results will not be said
          dline %a $calc($fline(%a,*In Theaters Now - Box Office Top Ten*,%z) + 0) $+ - $+ $line(%a,0)
        }
        else dline %a %start
        set %b $calc($fline(@theatre,*<img class="poster shadowed"*,%z) + 1)
      }
      else {
        if ($fline(%a,*<img class="poster shadowed"*,1)) dline %a 1- $+ $iif($h(theatre,query) == new,74,90))
        ;echo -a %z - $fline(%a,*<img class="poster shadowed"*,0) one: $fline(%a,*<img class="poster shadowed"*,1) to $fline(%a,*<img class="poster shadowed"*,%z)
        ;if ($fline(%a,*<img class="poster shadowed"*,1)) dline %a 1- $+ $fline(%a,*<img class="poster shadowed"*,%z))
        set %b $calc($fline(@theatre,*<img class="poster shadowed"*,1) + 1)
      }

      ;set %t theatre. $+ $h(theatre,query) $+ %z
      set %url http://www.imdb.com $+ $remove($gettok($line(%a,$fline(%a,*href="/title/*/"*,1)),2,61),")
      set -n %title $replace($gettok($gettok($line(%a,$fline(%a,*title=*(*)*"*,1)),2,34),1,40),$chr(36),$chr(128))
      set %date $gettok($gettok($striphtml($line(%a,$fline(%a,*itemprop='url'>*(*)</a>*,1))),2,91),1,93)
      set %rating $remove($gettok($striphtml($line(%a,$fline(%a,*alt="Certificate*"*,1))),2,61),",certificate,$chr(32))
      set %metascore $remove($gettok($gettok($striphtml($line(%a,$fline(%a,*metascore:*,1))),1,47),2,58),$chr(32)) $+ $chr(37)
      set %reviews $remove($striphtml($line(%a,$calc($fline(%a,*metascore:*,1) + 1))),reviews,$chr(40),$chr(41),$chr(32))

      var %genreline = $fline(%a,*itemprop="genre"*,1)
      while ("genre" isin $line(%a,%genreline)) {
        set %genre $addtok(%genre,$gettok($gettok($line(%a,%genreline),2,62),1,60),47)
        inc %genreline 2
      }
      if ($h(theatre,query) == top) set %money $replace($line(%a,$fline(@theatre,*Weekend:*Gross:*,$iif(%z == 1,1,2))),$chr(36),$chr(187))

      if ($h(theatre,result) > 1) {
        ;more than one listing
        if (%z == 1) {
          if ($h(theatre,query) == new) dualcmd 12!Theatre - $striphtml($line(%a,$fline(%a,*Opening This Week*,1))) $+ :
          else dualcmd 12!Theatre $h(theatre,query) $h(theatre,result) - In Theaters Now - Box Office Top Ten:
        }
        if ($fline(@theatre,*<img class="poster shadowed"*,1)) dualcmd     $+  %z $+ . %title ( $+ %rating $+ ) $iif(%date,- %date) - %genre - Metascore: %metascore ( $+  %reviews reviews) $iif(%money,- $replace(%money,$chr(187),$))
      }
      if (%z >= $h(theatre,result)) {
        ;end of list
        .timertheatre.gclean 1 15 theatre.gclean
      }
      elseif (%z == $h(theatre,result)) {
        ;only 1 result
        dualcmd    %title ( $+ %rating $+ ) $iif(%date,- %date) - %genre - Metascore: %metascore ( $+  %reviews reviews) $iif(%money,- $replace(%money,$chr(187),$))
      }
    }
  }
  else $iif($h(theatre,nick) == $me,.notice $me,msg $h(theatre,chan)) Error downloading data. See  $+ $h(theatre,u)
  .timertheatre.gclean 1 180 theatre.gclean
}

alias -l h {
  if ($1 == isnum) return
  if (!$2) { echo -a error: no 2 for hash table | return }
  if (!$hget($1)) hmake $1 10
  if ($isid) return $hget($1,$2)
  else hadd $1 $2 $3-
}
alias -l dualcmd {
  msg $h(theatre,chan) $1-
  ;echo -t $h(theatre,chan) < $+ $me $+ > $1-
}
alias -l paren {
  if ($3) return $2 $+ $1 $+ $3
  elseif ($2) return $2 $+ $1 $+ $2
  elseif ($1 != $null) return ( $+ $1- $+ )
}
alias theatre.gclean {
  ;this removes the hash tables that were used AND closes @theatre
  if (%theatre) return
  var %r = 0
  while (%r < $hget(theatre,results)) {
    inc %r
    if ($hget(theatre. $+ $hget(theatre,query) $+ %r)) hfree $ifmatch
  }
  set %r $hget(0)
  while (%r) {
    dec %r
    if (theatre.* iswm $hget(%r)) hfree $v2
  }
  if ($hget(theatre)) hfree $ifmatch
  set %r $findfile($mircdir,theatre*.txt,0,1,.remove $1-)
  set %r $findfile($mircdir,theatre.download*.vbs,0,1,.remove $1-)
  if ($window(@theatre)) window -c @theatre
  unset %theatre
}

on 1:UNLOAD:{
  theatre.gclean
}

;==================================================================================
;Author  : fubar
;Function: $striphtml identifier
;          This identifier strips html code from a string of text.
;                 Good for using when retrieving webpages within mirc.  
;==================================================================================
;
;This identifier strips html code from a string of text. Good for using when retrieving webpages within mirc.
;
;Usage: $striphtml(html code)
alias -l Xchr {
  var %return $regsubex($regsubex($1-,/&#x([A-F0-9]{1,2});/g,$chr($base($regml(\n),16,10))),/&#([0-9]{2});/g,$chr(\1))
  return $replacecs(%return,&ndash;,,&middot;,·,&raquo;,»,&laquo;,«,&Uuml;,Ü,&uuml;,ü,&Aacute;,Á,&aacute;,á,&Eacute;,$&
    É,&eacute;,é,&Iacute;,Í,&iacute;,í,&Oacute;,Ó,&oacute;,ó,&Ntilde;,Ñ,&ntilde;,ñ,&Uacute;,Ú,&uacute;,ú,&nbsp;,$chr(32),$&
    &aelig;,æ,&quot;,")
}
alias -l striphtml {
  ; making sure there are parameters to work with
  IF ($1) {
    ; Setting my variables. The %opt is set kind of funky
    ; all it does is combine <two><brackets> into 1 <twobrackets>, fewer loops this way
    ; also stripped tab spaces
    VAR %strip,%opt = <> $remove($1-,> <,><,$chr(9)) <>,%n = 2
    ; using $gettok() I checked the text in front of '>' (chr 62)
    ; then the second $gettok checks the text behind '<' (chr 60)
    ; so I'm extracting anything between >text<
    WHILE ($gettok($gettok(%opt,%n,62),1,60)) {
      ; take each peice of text and add it to the same variable
      %strip = %strip $ifmatch
      %strip = $replace(%strip,&quot;,")
      ; increase the variable so the while statement can check the next part
      INC %n
    }
    ; now that the loop has finished we can return the stripped html code
    RETURN $xchr(%strip)
  }
}

;/download by SReject
;http://www.hawkee.com/snippet/9318/
alias theatre.download {
  if ($regex(Args,$1-,^-c (?|(?:"(?=.+")([^"]+)")|(\S+)) (\S+) (?|(?:"(?=.+")([^"]+)")|(\S+)) (\S+)$)) {
    var %callback = $regml(Args,1)
    var %url = $regml(Args,2)
    var %file = $qt($regml(Args,3))
    var %com = $regml(Args,4)
    var %r = $iif($comerr,1,$com(%com).result)
    .remove $qt($scriptdir $+ %com)
    if ($com(%com)) { .comclose %com }

    if (%r == -1) { %callback 1 S_OK %url $qt(%file) }
    elseif (%r == 1) { %callback 0 UnKnown_ComErr %url $qt(%file) }
    elseif (%r == 2) { %callback 0 IE6+_Needed %url $qt(%file) }
    elseif (%r == 3) { %callback 0 Connect_Error %url $qt(%file) }
    elseif (%r == 4) { %callback 0 Newer_ActiveX_Needed %url $qt(%file) }
    elseif (%r == 5) { %callback 0 Writefile_Error %url $qt(%file) }
    else { %callback 0 Unknown_Error %url $qt(%file) }
  }
  elseif ($1 != -c) {
    if ($isid) || (!$regex(Args,$1-,^(?|(?:"(?=.+")([^"]+)")|(\S+)) (\S+) (?|(?:"(?=.+")([^"]+)")|(\S+))$)) || ($regml(Args,0) != 3) { return }

    var %callback = $regml(Args,1)
    var %url = $qt($regml(Args,2))
    var %file = $qt($iif(: isin $regml(Args,3),$v2,$mircdir $+ $v2))
    var %com = theatre.download $+ $ticks $+ .vbs
    var %s = $qt($scriptdir $+ %com)
    var %w = write %s

    %w on error resume next
    %w Set C = CreateObject("msxml2.xmlhttp.3.0")
    %w if (err.number <> 0) then
    %w   err.clear
    %w   set C = CreateObject("msxml2.xmlhttp")
    %w   if (err.number <> 0) then
    %w     err.clear
    %w     set C = CreateObject("XMLHttpRequest")
    %w     if (err.number <> 0) then wscript.quit(2)
    %w   end if
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
    %w wscript.quit(-1)

    .comopen %com WScript.Shell
    if ($comerr || !$comcall(%com,theatre.download -c $qt(%callback) $noqt(%url) %file,run,1,bstr*,%s,uint,1,bool,true)) { goto error }
    return
  }
  :error
  if ($error) { reseterror }
  if ($isfile(%s)) { .remove %s }
  if ($com(%com)) { .comclose %com }
}
