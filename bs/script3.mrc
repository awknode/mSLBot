;GetLinkInfo Script by Ford_Lawnmower irc.GeekShed.net #Script-Help
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;Start Setup;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Change this to 0 to resolve youtube links
alias -l IgnoreYoutubeLinks return 1
;Change this to change the logo
alias -l GetLinkInfoLogo return $+($chr(3),7,Title:)
;Change this to change the text color
alias -l GetLinkInfoTextColor return $+($chr(15),$chr(2))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;End Setup;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
menu Channel,Status {
  .$iif($group(#GetLinkInfo) == On,$style(1)) GetLinkInfo
  ..$iif($group(#GetLinkInfo) == On,$style(2)) On: .enable #GetLinkInfo
  ..$iif($group(#GetLinkInfo) == Off,$style(2)) Off: .disable #GetLinkInfo
}
#GetLinkInfo on
On $*:Text:/(^[+-]LinkInfo|(https?|www\.)(www\.)?[\S]*)/Si:#: {
  var %action $strip($regml(1))
  if ($regex(action,%action,^[+-])) && ($regex($nick($chan,$nick).pnick,/(!|~|&|@)/)) {
    if (+* iswm %action) {
      if ($istok(%linkinfoChanList,$+($network,$chan),32)) { echo -a $nick $chan is already running the linkinfo script }
      else { 
        .enable #GetLinkInfo
        Set %linkinfoChanList $addtok(%linkinfoChanList,$+($network,$chan),32)
        echo -a $nick has activated the linkinfo script for $chan .
      }
    }
    else {
      if (!$istok(%linkinfoChanList,$+($network,$chan),32)) { echo -a $chan $nick is not running the linkinfo script }
      else { 
        Set %linkinfoChanList $remtok(%linkinfoChanList,$+($network,$chan),1,32)
        echo -a $nick has deactivated the linkinfo script for $chan . 
      }
    }
  }
  elseif (!$timer($+(linkinfo,$network,$chan))) && ($istok(%linkinfoChanList,$+($network,$chan),32)) {
    .timer $+ $+(linkinfo,$network,$chan) 1 1 noop
    var %method msg #
    if ($IgnoreYoutubeLinks && $regex(%action,/(?:^https?:\/\/|www\.)(?:[\S]*youtube\.com|youtu\.be)/i)) {
      return
    }
    else {
      Getlinkinfo %method $gettok(%action,2-,47)
    }
  }
}
#GetLinkInfo end
alias linkinfo { Getlinkinfo echo -a $1- }
alias -l Getlinkinfo {
  var %sockname $+(LinkInfo,$network,$2,$ticks)
  sockopen %sockname www.getlinkinfo.com 80
  svar %sockname method $1-2
  svar %sockname url $+(/info?link=,$urlencode($+(http://,$3)))
}
On *:sockopen:LinkInfo*: {
  if (!$sockerr) {
    sockwrite -nt $sockname GET $svar($sockname,url) HTTP/1.1
    sockwrite -n $sockname Host: $sock($sockname).addr
    sockwrite -n $sockname $crlf
  }
  else { echo -st Socket Error $nopath($script) | sockclose $sockname | return }
}
On *:sockread:LinkInfo*: {
  if ($sockerr) { echo -st Socket Error $nopath($script) | sockclose $sockname | return }
  else {
    var %LinkInfo | sockread %LinkInfo
    if ($regex(%LinkInfo,/<dd><b>(.*?)<\/b><\/dd>/i)) {
      $svar($sockname,method) $GetLinkInfoLogo $+($GetLinkInfoTextColor,$Xchr($regml(1)))
      sockclose $sockname
      return
    }
  }
}
alias -l Xchr { 
  var %return $regsubex($regsubex($1-,/&#x([A-F0-9]{1,2});/g,$chr($base($regml(\n),16,10))),/&#([0-9]{2});/g,$chr(\1)) 
  return $replacecs(%return,&ndash;,,&middot;,·,&raquo;,»,&laquo;,«,&Uuml;,Ü,&uuml;,ü,&Aacute;,Á,&aacute;,á,&Eacute;,$&
    É,&eacute;,é,&Iacute;,Í,&iacute;,í,&Oacute;,Ó,&oacute;,ó,&Ntilde;,Ñ,&ntilde;,ñ,&Uacute;,Ú,&uacute;,ú,&nbsp;,$chr(32),$&
    &aelig;,æ,&quot;,",&lt;,<,&gt;,>, &amp;,&)
}
alias -l urlencode { 
  return $regsubex($replace($1-,$chr(32),$+(%,2d),$+(%,20),$+(%,2d)),/([^a-z0-9])/ig,% $+ $base($asc(\t),10,16,2))
}
alias -l Svar {
  var %sockname $1, %item $+($2,$1)
  if ($isid) {
    if ($regex(svar,$sock(%sockname).mark,/ $+ %item $+ \x01([^\x01]*)/i)) return $regml(svar,1)
  }
  elseif ($3)  {
    var %value $3-
    if (!$regex(svar,$sock(%sockname).mark,/ $+ %item $+ \x01/i)) { sockmark %sockname $+($sock(%sockname).mark,$chr(1),%item,$chr(1),%value) }
    else { sockmark %sockname $regsubex(svar,$sock(%sockname).mark,/( $+ %item $+ \x01[^\x01]*)/i,$+(%item,$chr(1),%value)) }
  }
}
