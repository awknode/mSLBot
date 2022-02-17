on $*:TEXT:/((https?[\S]*imgur\.com[\S]*))/Si:#: {
  if (!$sock(ImgurLookup)) {
    noop $regex(imgururl,$1-,(https?[\S]*imgur\.com[\S]*))
    sockopen ImgurLookup imgur.com 80 | sockmark ImgurLookup $+(#,>,$gettok($gettok($regml(imgururl,1),3-,47),1,46))
  }
}
on *:sockopen:ImgurLookup: {
  var %a sockwrite -n $sockname
  %a GET $+(/,$gettok($sock(ImgurLookup).mark,2,62)) HTTP/1.1
  %a Host: imgur.com
  %a $crlf
}
on *:sockread:ImgurLookup: {
  var %x | sockread %x
  if ($left($gettok($sock(ImgurLookup).mark,2,62),2) == a/) { 
    if (</title> isin %x) { set %z 1 | sockmark ImgurLookup $addmark(ImgurLookup,$remove($Xchr($nohtml(%x)),- Imgur),62) }
    if (<p> isin %x) { sockmark ImgurLookup $addmark(ImgurLookup,$Xchr($nohtml(%x)),62) }
    if (class="textbox left"> isin %x) { sockmark ImgurLookup $addmark(ImgurLookup,$remove($Xchr($nohtml(%x)),Album:),62) }
    if (GMT"> isin %x) { sockmark ImgurLookup $addmark(ImgurLookup,$Xchr($nohtml(%x)),62) }
    if (class="stat"> isin %x) { sockmark ImgurLookup $addmark(ImgurLookup,$Xchr($nohtml(%x)),62) }    
  }
  else {
    if ("hash" isin %x) { 
      noop $regex(imgurtitle,%x,("title":".*?,))
      noop $regex(imgurviews,%x,("views"[\S]*,))
      noop $regex(imgurnsfw,%x,("nsfw"[\S]*,))
      noop $regex(imgurtime,%x,("timestamp"[\S]*\s[\S]*,)|("datetime"[\S]*\s[\S]*,))
      msg $gettok($sock(ImgurLookup).mark,1,62) 14(Imgur14)  $+($remove($between($regml(imgurtitle,1),$chr(58),$chr(44),1),")) $iif($between($regml(imgurviews,1),$chr(58),$chr(44),1), $between($regml(imgurviews,1),$chr(58),$chr(44),1) Views") $iif($remove($between($regml(imgurtime,1),$chr(58),$chr(44),1),"),14(Uploaded14) $timeago($calc($timezone + $ctime - $ctime($remove($between($regml(imgurtime,1),$chr(58),$chr(44),1),"))))) $iif($between($regml(imgurnsfw,1),$chr(58),$chr(44),1),)
    }
  }
}

on *:sockclose:ImgurLookup: {
  if (%z == 1) { 
    if ($left($gettok($sock(ImgurLookup).mark,2,62),2) == a/) { 
      if ($numtok($sock(ImgurLookup).mark,62) == 6) { sockmark ImgurLookup $instok($sock(ImgurLookup).mark,fillertext,5,62) }
      msg $gettok($sock(ImgurLookup).mark,1,62) 14(Imgur14) $gettok($sock(ImgurLookup).mark,3,62) $iif($gettok($sock(ImgurLookup).mark,5,62) != fillertext,$+($chr(91),$gettok($sock(ImgurLookup).mark,5,62),$chr(93)))  14(Album14) $gettok($sock(ImgurLookup).mark,4,62) $iif($gettok($sock(ImgurLookup).mark,6,62),14(Uploaded14) $gettok($sock(ImgurLookup).mark,6,62)) $iif($gettok($sock(ImgurLookup).mark,7,62),$gettok($sock(ImgurLookup).mark,7,62))
    }
  }
  unset %z
}

alias -l nohtml { var %x, %i = $regsub($1-,/(^[^<]*>|<[^>]*>|<[^>]*$)/g,$null,%x), %x = $remove(%x,&nbsp;) | return %x }
alias -l Xchr { 
  var %return $regsubex($regsubex($1-,/&#x([A-F0-9]{1,2});/g,$chr($base($regml(\n),16,10))),/&#([0-9]{2});/g,$chr(\1)) 
  return $replacecs(%return,&ndash;,,&middot;,·,&raquo;,»,&laquo;,«,&Uuml;,Ü,&uuml;,ü,&Aacute;,Á,&aacute;,á,&Eacute;,$&
    É,&eacute;,é,&Iacute;,Í,&iacute;,í,&Oacute;,Ó,&oacute;,ó,&Ntilde;,Ñ,&ntilde;,ñ,&Uacute;,Ú,&uacute;,ú,&nbsp;,$chr(32),$&
    &aelig;,æ,&quot;,",&amp;,&,&#039;,')
}
alias -l addmark { return $+($sock($1).mark,$chr($3),$2) }
alias -l between { noop $regex($1,/\Q $+ $2 $+ \E(.*?)\Q $+ $3 $+ \E/gi) | return $regml($4) }
alias -l timeago {
  if ($1 <= 59) { Return $1 seconds ago }
  if (($1 <= 3599) && ($1 > 59)) { return $floor($calc($1 / 60)) minutes ago }
  if (($1 <= 86399) && ($1 > 3599)) { return $round($calc($1 / 3600),0) hours ago }
  if (($1 <= 2592000) && ($1 > 86399)) { return $floor($calc($1 / 86400)) $iif($floor($calc($1 / 86400)) > 1,days,day) $+ , $round($calc($calc($1 - $calc($floor($calc($1 / 86400))*86400)) / 3600),0) hour(s) ago }
  if (($1 <= 31540000) && ($1 > 2592000)) { return $floor($calc($1 / 2592000)) $iif($floor($calc($1 / 2592000)) > 1,months,months) $+ , $round($calc($calc($1 - $calc($floor($calc($1 / 2592000))*2592000)) / 86400),0) day(s) ago }
  if ($1 > 31104000) { return $floor($calc($1 / 31104000)) $iif($floor($calc($1 / 31104000)) > 1,years,year) $+ , $round($calc($calc($1 - $calc($floor($calc($1 / 31104000))*31104000)) / 2592000),0) month(s) ago }
}
