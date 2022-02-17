on 1:TEXT:*:#:{
  if (!rentals isin $1) || (!newrentals isin $1) || (!newdvds isin $1)  || (!dvds isin $1) {
    if (!rentals isin $1) || (!dvds isin $1) && (!$2) { .notice $nick Do you want the NEW dvd releases or TOP releases? Type $1 new or $1 top | return }
    set %get.newdvds.TEMP.chan $chan
    set %get.newdvds.TEMP.nick $nick
    set %get.newdvds.TEMP.info $1
    if ($2 == new) || (!newrentals isin $1) || (!newdvds isin $1) {
      if (!rentals isin $1) || (!dvds isin $1) && (!$2) { .notice $nick Do you want the NEW dvd releases or TOP releases? Type $1 new or $1 top | return }
      else {
        if (%get.newdvds.ON) { .notice %get.newdvds.TEMP.nick Please try again in 1 minute. :) | return }
        else get.newdvds
      }
    }
  }
}
alias get.newdvds {
  .notice %get.newdvds.TEMP.nick %get.newdvds.TEMP.info by mruno gathering data, please wait...
  if ($sock(get.newdvds)) sockclose get.newdvds
  set -u45 %get.newdvds.ON 1
  set %get.newdvds.TEMP.num 1
  sockopen get.newdvds www.imdb.com 80
  .timerget.newdvds.Timeout 1 45 get.newdvds.Timeout
}

on *:sockopen:get.newdvds: {
  sockwrite -nt $sockname GET /sections/dvd/
  sockwrite -nt $sockname User-Agent: Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; Trident/5.0)
  sockwrite -nt $sockname Host: www.imdb.com
  sockwrite -nt $sockname Accept-Language: en-us
  sockwrite -nt $sockname Accept: */*
  sockwrite -nt $sockname $crlf
}
on *:sockread:get.newdvds: {
  var %temp, %date, %item, %data
  if ($sockerr) {
    var %error
    if ($sockerr == 3) set %error Connection refused by remote host
    elseif ($sockerr == 4) set %error DNS lookup for hostname failed
    elseif ($sockerr > 0) set %error Unknown socket error ( $+ $sockerr $+ )
    echo -s get.newdvds:     4Socket Error: %error
    .timerget.newdvds.error 1 10 get.newdvds.msg       Socket Error. Please try again later. :(
    timerget.newdvds.close 1 15 get.newdvds.close
    halt
  }
  else {
    .timerget.newdvds.Timeout off
    sockread %temp
    if (New to Own: isin %temp) {
      get.newdvds.msg   12 $+ $striphtml(%temp)
      set %get.newdvds.TEMP.num 1
    }
    if (href="/title/ isin %temp) && ("item_description" !isin %temp) && (/vote? !isin %temp) && ($striphtml(%temp)) set %get.newdvds.TEMP.title $striphtml(%temp)
    if (<span class="year_type"> isin %temp) && ($striphtml(%temp)) && (%get.newdvds.TEMP.title) {

      if ($isodd(%get.newdvds.TEMP.num)) {
        set %get.newdvds.TEMP.echo  $+ %get.newdvds.TEMP.num $+ $chr(41) $+  %get.newdvds.TEMP.title $striphtml(%temp)  $+ $str(.,$calc(50 - $len(%get.newdvds.TEMP.num %get.newdvds.TEMP.title $striphtml(%temp)))) $+ 
        set %get.newdvds.TEMP.last %get.newdvds.TEMP.title
      }
      else {
        set %get.newdvds.TEMP.echo %get.newdvds.TEMP.echo  $+ %get.newdvds.TEMP.num $+ $chr(41)  $+ %get.newdvds.TEMP.title $striphtml(%temp)
        get.newdvds.msg     %get.newdvds.TEMP.echo
        unset %get.newdvds.TEMP.last
      }
      unset %get.newdvds.TEMP.title
      inc %get.newdvds.TEMP.num
    }
    if (See more lists isin %temp) && (%get.newdvds.TEMP.last) get.newdvds.msg      $+ $calc(%get.newdvds.TEMP.num - 1) $+ $chr(41)  $+ %get.newdvds.TEMP.last
    .timerget.newdvds.Close 1 10 get.newdvds.Close
  }
}
alias get.newdvds.Close {
  sockclose get.newdvds
  unset %get.newdvds.TEMP.*
}
alias get.newdvds.Timeout {
  get.newdvds.msg     Error: The request timed out. Please try again later. :(
  get.newdvds.Close
}
alias get.newdvds.msg if (%get.newdvds.TEMP.chan) msg %get.newdvds.TEMP.chan $1-

alias -l iseven return $iif(2 // $1,$true,$false)
alias -l isodd return $iif(!$iseven($1),$true,$false)
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
