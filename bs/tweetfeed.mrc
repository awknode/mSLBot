;TwitFeed Twitter RSS Script By Ford_Lawnmower irc.Geekshed.net #Script-Help
alias -l TwitFeed {
  var %sockname $+(TwitFeed,$1,$ticks), %site $gettok($2,2,47)
  sockopen %sockname %site 80
  sockmark %sockname $remove($2,%site,http://) 0 $1 %site 0
}
On *:Sockopen:TwitFeed*: {
  if (!$sockerr) { sockwrite -nt $sockname GET $gettok($sock($sockname).mark,1,32) HTTP/1.0 }
  if (!$sockerr) sockwrite -n $sockname User-Agent: Opera 9.6
  if (!$sockerr) { sockwrite -n $sockname Host: $gettok($sock($sockname).mark,4,32) }
  if (!$sockerr) sockwrite -n $sockname Connection: close
  if (!$sockerr) { sockwrite -n $sockname $crlf }
}
On *:Sockread:TwitFeed*: {
  if ($sockerr) { echo -at >Sock error TwitFeed< }
  else {
    sockread -f &twitfeed
    var %TwitFeed $bvar(&twitfeed,1-).text
    %TwitFeed = $replace(%TwitFeed,$chr(36),$+(,$chr(36),))
    if (<item isin %TwitFeed) || (<id> isin %TwitFeed) { sockmark $sockname $puttok($sock($sockname).mark,$calc($gettok($sock($sockname).mark,2,32) + 1),2,32) }
    if ($gettok($sock($sockname).mark,2,32) >= 5) { 
      TwitResults $regsubex($gettok($sock($sockname).mark,3,32)],/<!\[CDATA\[(.+)\s?\]\]>/g,\t)
      sockmark $sockname $puttok($sock($sockname).mark,0,5,32)
      sockclose $sockname
      return
    }
    if ($gettok($sock($sockname).mark,2,32)) {
      var %xx $calc($gettok($sock($sockname).mark,2,32) + 2)
      while (($between(%TwitFeed,<title>,</title>,%xx))) {
        hadd -m TwitFeed $+($gettok($sock($sockname).mark,3,32),$gettok($sock($sockname).mark,2,32)) $ifmatch
        if ($between(%TwitFeed,<pubdate>,</pubdate>,%xx)) || ($between(%TwitFeed,<published>,</published>,%xx)) || ($between(%TwitFeed,<pubdate>,+,%xx)) || ($between(%TwitFeed,<pubdate>,-,%xx)) {
          hadd -m TwitFeed $+($gettok($sock($sockname).mark,3,32),$gettok($sock($sockname).mark,2,32)) $&
            $hget(TwitFeed,$+($gettok($sock($sockname).mark,3,32),$gettok($sock($sockname).mark,2,32))) $httpstrip($ifmatch)
        }
        if ($between(%TwitFeed,<link>,</link>,%xx) || $between(%TwitFeed,<link><![CDATA[,]]></link>,%xx)) {
          hadd -m TwitFeed $+($gettok($sock($sockname).mark,3,32),$gettok($sock($sockname).mark,2,32)) $&
            $hget(TwitFeed,$+($gettok($sock($sockname).mark,3,32),$gettok($sock($sockname).mark,2,32))) $+(,$fixspace($ifmatch),)
        }
        inc %xx
        sockmark $sockname $puttok($sock($sockname).mark,$calc($gettok($sock($sockname).mark,2,32) + 1),2,32)
        if (%xx >= 7) {
          TwitResults $regsubex($gettok($sock($sockname).mark,3,32)],/<!\[CDATA\[(.+)\s?\]\]>/g,\t)
          sockmark $sockname $puttok($sock($sockname).mark,0,5,32)
          sockclose $sockname
          return        
        }      
      }
      if (<title isin %TwitFeed) {
        if ($between(%TwitFeed,<title><![CDATA[,]]></title>,1)) || ($between(%TwitFeed,<title>,</title>,1)) || ($between(%TwitFeed,<title type='text'>,</title>,1)) { 
          hadd -m TwitFeed $+($gettok($sock($sockname).mark,3,32),$gettok($sock($sockname).mark,2,32)) $httpstrip($ifmatch)
        }
        else { hadd -m TwitFeed $+($gettok($sock($sockname).mark,3,32),$gettok($sock($sockname).mark,2,32)) $httpstrip($right(%twitFeed,400)) }
      }
      if ($between(%TwitFeed,<pubdate>,</pubdate>,1)) || ($between(%TwitFeed,<pubdate>,+,1)) || ($between(%TwitFeed,<pubdate>,-,1)) || ($between(%TwitFeed,<updated>,</updated>,1)) {
        hadd -m TwitFeed $+($gettok($sock($sockname).mark,3,32),$gettok($sock($sockname).mark,2,32)) $&
          $hget(TwitFeed,$+($gettok($sock($sockname).mark,3,32),$gettok($sock($sockname).mark,2,32))) $ifmatch
      }
      if (<link isin %TwitFeed) || (</link> isin %TwitFeed) {
        if (($between(%TwitFeed,<link><![CDATA[,]]></link>,1)) || ($between(%TwitFeed,<link>,</link>,1))) {
          hadd -m TwitFeed $+($gettok($sock($sockname).mark,3,32),$gettok($sock($sockname).mark,2,32)) $&
            $hget(TwitFeed,$+($gettok($sock($sockname).mark,3,32),$gettok($sock($sockname).mark,2,32))) $+(,$fixspace($ifmatch),)
        }
        elseif ($between(%TwitFeed,<link rel="alternate" type="text/html" href="," title=",1)) {
          hadd -m TwitFeed $+($gettok($sock($sockname).mark,3,32),$gettok($sock($sockname).mark,2,32)) $&
            $hget(TwitFeed,$+($gettok($sock($sockname).mark,3,32),$gettok($sock($sockname).mark,2,32))) $+(,$v1,)      
        }        
        elseif ($regex(%TwitFeed,/<link rel="alternate".*href="(.*)"/)) {
          hadd -m TwitFeed $+($gettok($sock($sockname).mark,3,32),$gettok($sock($sockname).mark,2,32)) $&
            $hget(TwitFeed,$+($gettok($sock($sockname).mark,3,32),$gettok($sock($sockname).mark,2,32))) $+(,$regml(1),)      
        }
        elseif ($regex(%TwitFeed,/<link rel='alternate'.*href='(.*)'\/><link/)) {
          hadd -m TwitFeed $+($gettok($sock($sockname).mark,3,32),$gettok($sock($sockname).mark,2,32)) $&
            $hget(TwitFeed,$+($gettok($sock($sockname).mark,3,32),$gettok($sock($sockname).mark,2,32))) $+(,$regml(1),)      
        }
        elseif ($between(%TwitFeed,<link rel="alternate" type="text/html" href="," />,1)) {
          hadd -m TwitFeed $+($gettok($sock($sockname).mark,3,32),$gettok($sock($sockname).mark,2,32)) $&
            $hget(TwitFeed,$+($gettok($sock($sockname).mark,3,32),$gettok($sock($sockname).mark,2,32))) $+(,$v1,)      
        }        
        else {
          hadd -m TwitFeed $+($gettok($sock($sockname).mark,3,32),$gettok($sock($sockname).mark,2,32)) $&
            $hget(TwitFeed,$+($gettok($sock($sockname).mark,3,32),$gettok($sock($sockname).mark,2,32))) $+(,$httpstrip($right(%TwitFeed,400)),)         
        }
      }
      if (</rss> isin %TwitFeed) { TwitResults $regsubex($gettok($sock($sockname).mark,3,32)],/<!\[CDATA\[(.+)\s?\]\]>/g,\t) | sockclose $sockname | return }
    }
  }
}
On *;Sockclose:TwitFeed*: {
  TwitResults $regsubex($gettok($sock($sockname).mark,3,32)],/<!\[CDATA\[(.+)\s?\]\]>/g,\t)
  sockclose $sockname
  return
}
dialog -l TwitFeed {
  title "TwitFeed"
  size -1 -1 104 120
  option dbu
  text "Network:", 1, 8 6 25 8
  text "Channel:", 2, 8 18 25 8
  text "", 3, 36 6 65 8
  text "", 4, 36 18 65 8
  text "FEEDS", 5, 8 28 89 8
  list 6, 8 37 89 60, size vsbar
  button "Add", 7, 5 106 29 12
  button "Delete", 8, 38 106 29 12
  button "Edit", 9, 71 106 29 12
  text "", 10, 0 97 105 8
}
On *:Dialog:TwitFeed*:init:*: {
  did -a $dname 3 $network
  did -a $dname 4 $active
  var %count $hfind(TwitFeedLIST,$+($network,,$active,*),0,w).item
  while (%count) {
    did -a $dname 6 $gettok($hfind(TwitFeedLIST,$+($network,,$active,*),%count,w).item,3,7)
    dec %count
  }
}
On *:Dialog:TwitFeed*:Sclick:7-9: {
  if ($did == 7) { dialogopen $+(TwitEdit,,$did($dname,3).text,,$did($dname,4).text) TwitEdit | if ($dialog($dname)) { dialog -x $dname } }
  elseif ($did == 8) && ($did($dname,6).seltext) {
    var %removeme $+($did($dname,3).text,,$did($dname,4).text,,$did($dname,6).seltext)
    .timer $+ %removeme off
    hdel TwitFeedLIST %removeme
    did -df $dname 6 $did($dname,6).sel
  }
  elseif ($did == 9) && ($did($dname,6).seltext) { 
    dialogopen $+(TwitEdit,,$did($dname,3).text,,$did($dname,4).text,,$did($dname,6).seltext) TwitEdit
    if ($dialog($dname)) { dialog -x $dname }
  }
}
dialog -l TwitEdit {
  title "TwitFeed Add/Edit"
  size -1 -1 104 112
  option dbu
  text "Network:", 1, 8 6 25 8
  text "Channel:", 2, 8 18 25 8
  text "", 3, 36 6 65 8
  text "", 4, 36 18 65 8
  text "FEED NAME", 5, 8 28 89 8
  text "", 10, 0 86 105 8, center
  text "FEED LINK", 6, 8 52 89 8
  edit "", 7, 7 38 90 10, autohs
  edit "", 8, 7 62 90 10, autohs
  button "Cancel", 9, 66 96 29 12
  button "Accept", 11, 8 96 29 12
  text "Delay in Seconds:", 12, 8 77 43 8
  edit "", 13, 54 76 43 10
}
On *:dialog:TwitEdit*:Sclick:9,11: {
  if ($did == 11) {
    if ($did($dname,7).text) && ($did($dname,8).text) && ($did($dname,13).text) {
      if (http:// !isin $did($dname,8).text) {
        did -a $dname 10 Link missing prefix http://
        did -f $dname 8
        .timer 1 4 if ($!dialog($dname)) { did -a $dname 10 }
        return
      }
      if ($did($dname,13).text !isnum) {
        did -a $dname 10 Delay should be a NUMBER
        did -f $dname 13
        .timer 1 4 if ($!dialog($dname)) { did -a $dname 10 }
        return
      }
      var %addit $+($did($dname,3).text,,$did($dname,4).text,,$spunder($did($dname,7).text)), %del $did($dname,13).text, %flink $strip($did($dname,8).text)
      var %netcount $scon(0)
      while %netcount {
        if ($scon(%netcount).network == $did($dname,3).text) { var %netid %netcount }
        dec %netcount
      }
      $iif(%netid,scon %netid) TwitTimer %addit %flink %del
      hadd -m TwitfeedLIST %addit %addit %flink %del
      var %diagname $+(TwitFeed,,$did($dname,3).text,,$did($dname,4).text)
      if ($dialog(%diagname)) { did -a %diagname 6 $spunder($did($dname,7).text) }
      dialogopen %diagname TwitFeed
      if ($dialog($dname)) { dialog -x $dname }
    }
    else {
      did -a $dname 10 Please fill in all of the boxes
      .timer 1 4 if ($!dialog($dname)) { did -a $dname 10 }
    }
  }
  if ($did == 9) {
    var %diagname $+(TwitFeed,,$did($dname,3).text,,$did($dname,4).text)
    dialogopen %diagname TwitFeed
    if ($dialog($dname)) { dialog -x $dname }
  }
}
On *:dialog:TwitEdit*:init:*: {
  tokenize 7 $dname
  did -a $dname 3 $2
  did -a $dname 4 $3
  if ($4) {
    did -am $dname 7 $4
    did -af $dname 8 $gettok($hget(TwitFeedLIST,$remove($dname,TwitEdit)),2,32)
    did -a $dname 13 $gettok($hget(TwitFeedLIST,$remove($dname,TwitEdit)),3,32)
  }
}
On *:Start: { set -z %TwitFeedStartUp 300 }
On *:Connect: {
  if (!$hget(TwitFeedLIST)) {
    hmake TwitFeedLIST 5
    if ($exists(TwitFeedLIST.hsh)) { hload TwitFeedLIST TwitFeedLIST.hsh }
    var %records $hget(TwitFeedLIST,0).item
    while (%records) {
      .timer -o 1 $calc(%records * 20) TwitTimer $hget(TwitFeedLIST,%records).data
      dec %records
    }
  }
}
On *:Disconnect: {
  if ($hget(TwitFeedLIST)) { 
    hsave TwitFeedLIST TwitFeedLIST.hsh
  }
}
On *:Exit: { hfree TwitFeedLIST }
On *:Unload: { hfree TwitFeedLIST }
menu channel {
  TwitFeed:dialogopen $+(Twitfeed,,$network,,$chan) twitfeed
}
alias -l TwitResults {
  var %count 4
  while (%count) {
    if (!$hfind($+(twitfeedDONE,$1),$+(*,$right($hget(TwitFeed,$+($1,%count)),15),*),1,w).data) { 
      if ($me ison $gettok($1,2,7)) && ($repchars($hget(TwitFeed,$+($1,%count)))) { 
        var %Results $fix&#($v1)
        if (!%TwitFeedStartUp) {
          ShrinkLinks Put .msg $gettok($1,2,7) $TwitFeedLogo $gettok($1,3,7) %Results
        }
      }
    }
    dec %count
  }
  while (%count <= 3) {
    inc %count
    if (!$hfind($+(TwitFeedDONE,$1),$hget(TwitFeed,$+($1,%count))).data) {
      hadd -m $+(TwitFeedDONE,$1) $+($1,$calc(%count + $hget($+(TwitFeedDONE,$1),0).item) - 1) $hget(TwitFeed,$+($1,%count))
    }
  }
}
alias TwitFeedLogo return $+($chr(2),$chr(3),04RSS,$chr(15))
alias -l repchars {
  return $regsubex($replacex($1-,&amp;gt;,>,&quot;,",&amp;,&,&apos;,',&gt;,>,$chr(124),$chr(166)),/<\!\[CDATA\[(.+)\s?\]\]>/g,\t)
}
;Syntax TwitTimer NetworkChannelFeedName http://full/link/to/feedpage/4325677 delayinseconds
alias -l TwitTimer {
  var %netcount $scon(0)
  while %netcount {
    if ($scon(%netcount).network == $gettok($1,1,7)) { var %netid %netcount }
    dec %netcount
  }
  if (%netid) { scon %netid TwitFeed $1 $2 }
  $iif(%netid,scon %netid) .timer $+ $1 -o 1 $iif($3 > 60,$3,60) $iif(%netid,scon %netid) TwitTimer $1-
}
alias -l fixspace { return $replace($1-,$chr(32),% $+ 20) }
alias -l DialogOpen { dialog $iif($dialog($1),-v,-m) $1- }
alias -l spunder { return $replace($1-,$chr(32),_) }
alias -l httpstrip { var %s $replace($1-,&lt;,<,&gt;,>,&nsbsp,$chr(32)), %x, %i = $regsub(%s,/(^[^<]*>|<[^>]*>|<[^>]*$)/g,$null,%x) | return %x }
alias -l fix&# { 
  return $regsubex($charMap($1-),/\&\#([0-9]{1,4});/g,$h2u(\t)) 
}
alias charMap {
  var %map $remove(&euro;|&nota;|&sbquo;|&fnof;|&bdquo;|&hellip;|&dagger;|&Dagger;|&circ;|&permil;|&Scaron;|&lsaquo;|&OElig;|&nota;|&nota;|&nota;|&nota;|$&
    &lsquo;|&rsquo;|&ldquo;|&rdquo;|&bull;|&ndash;|&mdash;|&tilde;|&trade;|&scaron;|&rsaquo;|&oelig;|&nota;|&nota;|&Yuml;|&nbsp;|&iexcl;|&cent;|&pound;|$&
    &curren;|&yen;|&brvbar;|&sect;|&uml;|&copy;|&ordf;|&laquo;|&not;|&shy;|&reg;|&macr;|&deg;|&plusmn;|&sup2;|&sup3;|&acute;|&micro;|&para;|&middot;|$&
    &cedil;|&sup1;|&ordm;|&raquo;|&frac14;|&frac12;|&frac34;|&iquest;|&Agrave;|&Aacute;|&Acirc;|&Atilde;|&Auml;|&Aring;|&AElig;|&Ccedil;|&Egrave;|$&
    &Eacute;|&Ecirc;|&Euml;|&Igrave;|&Iacute;|&Icirc;|&Iuml;|&ETH;|&Ntilde;|&Ograve;|&Oacute;|&Ocirc;|&Otilde;|&Ouml;|&times;|&Oslash;|&Ugrave;|$&
    &Uacute;|&Ucirc;|&Uuml;|&Yacute;|&THORN;|&szlig;|&agrave;|&aacute;|&acirc;|&atilde;|&auml;|&aring;|&aelig;|&ccedil;|&egrave;|&eacute;|&ecirc;|&euml;|$&
    &igrave;|&iacute;|&icirc;|&iuml;|&eth;|&ntilde;|&ograve;|&oacute;|&ocirc;|&otilde;|&ouml;|&divide;|&oslash;|&ugrave;|&uacute;|&ucirc;|&uuml;|&yacute;|$&
    &thorn;|&yuml;|,$chr(32))
  var %char $regsubex($str(.,128),/(.)/g,$+($chr($calc(\n + 127)),|))
  return $regsubex($1-,/( $+ %map $+ )/g,$gettok(%char,$findtokcs(%map,\t,124),124))
}
alias -l between { noop $regex($1,/\Q $+ $2 $+ \E(.*?)\Q $+ $3 $+ \E/gi) | return $regml($4) }
alias -l UTF8 {
  if ($1 < 255) { return $chr($1) }
  if ($1 >= 256) && ($1 < 2048) { return $+($chr($calc(192 + $div($1,64))),$chr($calc(128 + $mod($1,64)))) }
  if ($1 >= 2048) && ($1 < 65536) { return $+($chr($calc(224 + $div($1,4096))),$chr($calc(128 + $mod($div($1,64),64))),$chr($calc(128 + $mod($1,64)))) }
  if ($1 >= 65536) && ($1 < 2097152) {
    return $+($chr($calc(240 + $div($1,262144))),$chr($calc(128 + $mod($div($1,4096),64))),$chr($calc(128 + $mod($div($1,64),64))),$&
      $chr($calc(128 + $mod($1,64))))
  }
}
alias -l div { return $int($calc($1 / $2)) }
alias -l mod {
  var %int $int($calc($1 / $2))
  return $calc($1 - (%int * $2))
}
alias -l H2U { return $utf8($base($1,16,10)) }
alias -l Put {
  if (!$regex($1,/(\.|^)(msg|notice|echo)$/Si)) || (!$3) { echo -st **Put error** Syntax /Put msg #channel text - or - /Put notice nickname text  | return }
  tokenize 32 $regsubex($1-,/([$\|%\[\]][^\s]*)/g,$+($chr(2),$chr(2),\t))
  var %tokens $0, %Tstart 3, %Dtimer 1500
  if ($timer($+(Put,$2,$network)).secs) { %Dtimer = $calc($v1 * 1000) }  
  while ($len($($+($,%Tstart,-,%tokens),2)) > 430) {
    dec %tokens
    if ($len($($+($,%Tstart,-,%tokens),2)) <= 430) {
      .timer -m 1 %Dtimer $1-2 $($+($,%Tstart,-,%tokens),2))
      inc %Dtimer 1500
      %Tstart = $calc(%tokens + 1)
      %tokens = $0
    }
  }
  .timer -m 1 %Dtimer $1-2 $($+($,%Tstart,-,%tokens),2))
  .timer $+ $+(Put,$2,$network) -m 1 $calc(%Dtimer + 1500) noop 
}
alias -l shrinklinks {
  if ($wildtok($strip($4-),http://*.*,0,32) == $wildtok($strip($4-),http://tinyurl.com*,0,32)) { 
    $eval($1-,1)
    return
  }
  var %count $wildtok($strip($4-),http://*.*,0,32), %text $strip($4-)
  while %count {
    if ($left($wildtok(%text,http://*.*,%count,32),18) != http://tinyurl.com) {
      tiny $1-3 $wildtok(%text,http://*.*,%count,32) $4-
      %count = 0
      return 
    }
    dec %count
  }
}
alias -l Tiny {
  var %sockname $+(Tiny,$network,$ticks,$r(1,$ticks))
  sockopen %sockname tinyurl.com 80
  sockmark %sockname $1-3 $+(/create.php?url=,$urlencode($4)) $4 $5-
}
On *:sockopen:Tiny*: {
  if (!$sockerr) {
    sockwrite -nt $sockname GET $gettok($sock($sockname).mark,4,32) HTTP/1.0
    sockwrite -n $sockname Host: tinyurl.com
    sockwrite -n $sockname $crlf
  }
  else { echo -st Socket Error $nopath($script) | sockclose $sockname | return }
}
On *:sockread:Tiny*: {
  if ($sockerr) { echo -st Socket Error $nopath($script) | sockclose $sockname | return }
  else {
    var %Tiny | sockread %Tiny
    if ($regex(%Tiny,/<blockquote><b>(.*)<\/b><br><small>/i)) {
      tokenize 32 $sock($sockname).mark
      shrinklinks $1-3 $replace($6-,$5,$remove($regml(1),preview.))
      sockclose $sockname
      return
    }
  }
}
alias -l urlencode return $regsubex($1-,/([^a-z0-9])/ig,% $+ $base($asc(\t),10,16,2))
alias -l Network {
  if ($Network) { return $v1 }
  else { return Unknown }
}
alias -l net {
  var %netcount $scon(0)
  while %netcount {
    if ($scon(%netcount).network == $1) { var %netid %netcount }
    dec %netcount
  }
  return %netid
}
