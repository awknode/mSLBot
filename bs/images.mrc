alias urlinf.depositfiles {
  if ($sock($1).addr == depositfiles.com) {
    if ($prop == sockopen) {
      if (*/files/?* iswm $gettok($sock($1).mark,8,32)) {
        if (/?*/files/?* iswm $v2) sockwrite -n $1 POST $+(/ru/,$gettok($v2,2-,47)) HTTP/1.0
        else sockwrite -n $1 POST $+(/ru,$gettok($sock($1).mark,8,32)) HTTP/1.0
        sockwrite -n $1 Content-Type: application/x-www-form-urlencoded
        sockwrite -n $1 Content-Length: 16
        sockwrite -n $1 Host: $sock($1).addr
        sockwrite -n $1
        sockwrite -n $1 gateway_result=1
        return $sock($1).sent
      }
    }
    if ($hget(urlinf.sockets,$1,$+(&,$1)) = 0) return
    var %offset = $bfind($+(&,$1),1,13 10 13 10), %name, %size, %link
    if ($prop == name) {
      if ($bfind($+(&,$1),%offset,<b title=")) {
        var %> = $bfind($+(&,$1),$v1,>) + 1, %name = $bvar($+(&,$1),%>,$calc($bfind($+(&,$1),%>,<) - %>)).text
        if ($isutf(%name)) var %name = $utfdecode(%name)
      }
      return %name
    }
    if ($prop == size) {
      if ($bfind($+(&,$1),%offset,<span class="nowrap">)) var %> = $bfind($+(&,$1),$v1,<b>) + 3, %size = $replace($bvar($+(&,$1),%>,$calc($bfind($+(&,$1),%>,<) - %>)).text,&nbsp;,$chr(32))
      return %size
    }
    if ($prop == link) {
      if ($bfind($+(&,$1),%offset,id="download_url")) {
        if ($bfind($+(&,$1),$v1,<form action=")) var %" = $bfind($+(&,$1),$v1,") + 1, %link = $bvar($+(&,$1),%",$calc($bfind($+(&,$1),%",") - %")).text
      }
      return %link
    }
    if ($bfind($+(&,$1),%offset,class="no_download_msg">)) return no_download_msg
    if (*/files/?* iswm $gettok($sock($1).mark,8,32)) return $bvar($+(&,$1),0)
  }
}
alias urlinf.bashorg {
  if ($sock($1).addr == www.bash.org.ru) || ($sock($1).addr == bash.org.ru) {
    if ($hget(urlinf.sockets,$1,$+(&,$1)) = 0) return
    var %offset = $bfind($+(&,$1),1,13 10 13 10), %quote
    if ($prop == quote) {
      if ($bfind($+(&,$1),%offset,<div>)) {
        var %div = $v1 + 5
        if ($bfind($+(&,$1),%div,</div>)) return $bvar($+(&,$1),%div,$calc($v1 - %div)).text
      }
      return
    }
    return %offset
  }
}
alias urlinf.tinyurl {
  if ($sock($1).addr == tinyurl.com) || ($sock($1).addr == www.tinyurl.com) {
    if ($hget(urlinf.sockets,$1,$+(&,$1)) = 0) return
    var %offset = $bfind($+(&,$1),1,13 10 13 10), %request = $gettok($sock($1).mark,8,32)
    if ($prop == redirect) {
      if ($bfind($+(&,$1),1,Location:)) && ($v1 < %offset) return $bvar($+(&,$1),$calc($v1 + 10),$calc($bfind($+(&,$1),$v1,13 10) - $v1 - 10)).text
      return
    }
    if ($prop == error) {
      if ($bfind($+(&,$1),%offset,<br />)) {
        var %offset = $v1
        if ($bfind($+(&,$1),%offset,</h1)) {
          var %h1 = $bfind($+(&,$1),%offset,<h1) + 4
          return $bvar($+(&,$1),%h1,$calc($v1 - %h1)).text
        }
      }
      return
    }
    if (/#* iswm %request) || (. isin %request) return
    return $bvar($+(&,$1),0)
  }
}
alias urlinf.txt {
  if ($hget(urlinf.sockets,$1,$+(&,$1)) = 0) return
  if ($bfind($+(&,$1),1,13 10 13 10 239 187 191)) return UTF-8
  if ($bfind($+(&,$1),1,13 10 13 10 255 254)) return UTF-16 Little Endian
  if ($bfind($+(&,$1),1,13 10 13 10 254 255)) return UTF-16 Big Endian
  if ($bfind($+(&,$1),1,13 10 13 10 255 254 0 0)) return UTF-32 Little Endian
  if ($bfind($+(&,$1),1,13 10 13 10 0 0 254 255)) return UTF-32 Big Endian
}
alias urlinf.jpeg {
  if ($hget(urlinf.sockets,$1,$+(&,$1)) = 0) return
  var %offset = $bfind($+(&,$1),1,13 10 13 10) + 4, %dimensions, %i = 1, %exif
  if ($prop == dimensions) {
    if ($sock($1).rcvd > $calc(32 * 1024)) || ($bvar($+(&,$1),$calc($sock($1).rcvd - 1),2) == 255 217) {
      while ($bfind($+(&,$1),%offset,255)) {
        var %offset = $v1 + 1
        if ($bvar($+(&,$1),%offset,1) isnum 192-195) var %dimensions = %offset
      }
    }
    return %dimensions
  }
  if ($prop == width) return $base($+($base($bvar($+(&,$1),$calc($2 + 6),1),10,16,2),$base($bvar($+(&,$1),$calc($2 + 7),1),10,16,2)),16,10)
  if ($prop == height) return $base($+($base($bvar($+(&,$1),$calc($2 + 4),1),10,16,2),$base($bvar($+(&,$1),$calc($2 + 5),1),10,16,2)),16,10)
  if ($prop == exif) {
    return
    while ($bfind($+(&,$1),%i,0)) {
      var %i = $v1 + 1, %data = $bvar($+(&,$1),%i,$calc($bfind($+(&,$1),%i,0) - %i)).text
      while ($left(%data,1)) && ($v1 !isalnum) var %data = $right(%data,-1)
      while ($right(%data,1)) && ($v1 !isalnum) var %data = $left(%data,-1)
      if (%data == Ducky) || (%data == Adobe) || (%data == JFIF) || (%data == Exif) continue
      if ($len(%data) > 3) {
        var %data = $urlinf.char(%data)
        if ($remove(%data,:,.,-,$chr(32),$chr(44)) isalnum) var %exif = %exif $+ ; %data
        if ($numtok(%data,59) > 3) || (*:*:* iswm %data) return $mid(%exif,2)
      }
    }
  }
  return $bfind($+(&,$1),1,13 10 13 10 255 216 255)
}
alias urlinf.gif {
  if ($hget(urlinf.sockets,$1,$+(&,$1)) = 0) return
  var %offset = $bfind($+(&,$1),1,13 10 13 10) + 4
  if ($prop == dimensions) {
    if ($bfind($+(&,$1),1,13 10 13 10 71 73 70 56 57 97)) return $v1
    if ($bfind($+(&,$1),1,13 10 13 10 71 73 70 56 55 97)) return $v1
  }
  if ($prop == width) return $base($+($base($bvar($+(&,$1),$calc(%offset + 7),1),10,16,2),$base($bvar($+(&,$1),$calc(%offset + 6),1),10,16,2)),16,10)
  if ($prop == height) return $base($+($base($bvar($+(&,$1),$calc(%offset + 9),1),10,16,2),$base($bvar($+(&,$1),$calc(%offset + 8),1),10,16,2)),16,10)
  return $bfind($+(&,$1),1,13 10 13 10 71 73 70)
}
alias urlinf.png {
  if ($hget(urlinf.sockets,$1,$+(&,$1)) = 0) return
  var %offset = $bfind($+(&,$1),1,13 10 13 10) + 4
  if ($prop == dimensions) {
    if ($bfind($+(&,$1),%offset,73 72 68 82)) return $v1
  }
  if ($prop == width) return $base($+($base($bvar($+(&,$1),$calc($2 + 4),1),10,16,2),$base($bvar($+(&,$1),$calc($2 + 5),1),10,16,2),$base($bvar($+(&,$1),$calc($2 + 6),1),10,16,2),$base($bvar($+(&,$1),$calc($2 + 7),1),10,16,2)),16,10)
  if ($prop == height) return $base($+($base($bvar($+(&,$1),$calc($2 + 8),1),10,16,2),$base($bvar($+(&,$1),$calc($2 + 9),1),10,16,2),$base($bvar($+(&,$1),$calc($2 + 10),1),10,16,2),$base($bvar($+(&,$1),$calc($2 + 11),1),10,16,2)),16,10)
  return $bfind($+(&,$1),1,13 10 13 10 137 80 78 71 13 10 26 10)
}
alias urlinf.flv {
  if ($hget(urlinf.sockets,$1,$+(&,$1)) = 0) return
  var %offset = $bfind($+(&,$1),1,13 10 13 10) + 4
  if ($prop) return $doublelong($bvar($+(&,$1),$calc($bfind($+(&,$1),%offset,$prop) + $len($prop) + 1),8))
  return $bfind($+(&,$1),1,13 10 13 10 70 76 86)
}
alias urlinf.char {
  var %i = 32, %str = $1
  while (%i) var %str = $replace(%str,$chr(%i),$chr(32)), %i = %i - 1
  return %str
}
alias urlinf.unicode {
  if ($1 < 128) return $chr($1)
  if ($1 < 2048) return $+($chr($calc(192 + $int($calc($1 / 64)))),$chr($calc(128 + ($1 % 64))))
  if ($1 < 65536) return $+($chr($calc(224 + $int($calc($1 / 4096)))),$chr($calc(128 + ($int($calc($1 / 64)) % 64))),$chr($calc(128 + ($1 % 64))))
  if ($1 < 2097152) return $+($chr($calc(240 + $int($calc($1 / 262144)))),$chr($calc(128 + ($int($calc($1 / 4096)) % 64))),$chr($calc(128 + ($int($calc($1 / 64)) % 64))),$chr($calc(128 + ($1 % 64))))
  return ?
}
alias urlinf.win2koi return $replacex($1,а,Ю,б,А,в,Б,г,Ц,д,Д,е,Е,ё,Е,ж,Ф,з,Г,и,Х,й,И,к,Й,л,К,м,Л,н,М,о,Н,п,О,р,П,с,Я,т,Р,у,С,ф,Т,х,У,ц,Ж,ч,В,ш,Ь,щ,Ы,э,Щ,ы,Ш,ю,Ч,я,Ъ,ъ,З,ь,Э)
alias urlinf.koi2win return $replacex($1,Ю,а,А,б,Б,в,Ц,г,Д,д,Е,е,Ф,ж,Г,з,Х,и,И,й,Й,к,К,л,Л,м,М,н,Н,о,О,п,П,р,Я,с,Р,т,С,у,Т,ф,У,х,Ж,ц,В,ч,Ь,ш,Ы,щ,Щ,э,Ш,ы,Ч,ю,Ъ,я,З,ъ,Э,ь)
alias urlinf.html {
  var %str = $remove($1,><,> <)
  while (<![*[*]]> iswm %str) var %str = $mid(%str,$calc($pos(%str,[,2) + 1),-3)
  while ($pos(%str,<)) var %str = $remove(%str,$mid(%str,$v1,$calc($pos(%str,>) - $v1 + 1)))
  if (*&#*;* iswm %str) var %str = $regsubex(%str,/&#(\d+?);/g,$urlinf.unicode(\1))
  return $replacex(%str,&amp;,&,&mdash;,-,&quot;,",&lt;,<,&gt;,>,&laquo;,<<,&raquo;,>>,&bull;,*,&nbsp;,$chr(32))
}
alias urlinf.idna {
  if ($lof(dlls/idna.dll)) return $dll(dlls/idna.dll,encode,$1)
  return $1
}
alias urlinf.space {
  tokenize 32 $1
  return $1-
}
alias urlinf.urlencode {
  var %i = 128, %str = $1
  while (%i <= 255) var %str = $replace(%str,$chr(%i),$+(%,$base(%i,10,16,2))), %i = %i + 1
  return %str
}
alias urlinf.urldecode {
  var %i = 255, %str = $1
  while (%i) var %str = $replace(%str,$+(%,$base(%i,10,16,2)),$chr(%i)), %i = %i - 1
  return %str
}
alias urlinf.size {
  return $bytes($1).suf
}
alias urlinf.database {
  if ($1 == load) {
    if ($lof(channels/urlinf.txt)) {
      if ($fopen(urlinf)) .fclose $v1
      .fopen urlinf channels/urlinf.txt
      while (!$feof) {
        var %read = $fread(urlinf)
        if (* iswm %read) {
          var %database = $mid($v2,2,-1)
          if ($hget(%database)) hdel -w %database *
          else hmake %database
        }
        else hadd %database %read
      }
      .fclose urlinf
    }
  }
  elseif ($1 == save) {
    if ($fopen(urlinf)) .fclose $v1
    .fopen -no urlinf channels/urlinf.txt
    var %i = 1
    while ($hget(%i)) {
      var %database = $v1, %o = 1, %i = %i + 1
      if (urlinf* iswm %database) {
        .fwrite -n urlinf $+(,%database,)
        while ($hget(%database,%o).item) {
          .fwrite -n urlinf $v1 $hget(%database,$v1)
          inc %o
        }
      }
    }
    .fclose urlinf
  }
}
on *:START: {
  urlinf.database load
  if ($hget(urlinf,created)) return
  hmake urlinf
  hmake urlinf.sockets
  hadd urlinf created $ctime
  urlinf.database save
}
on *:TEXT:*:#: {
  tokenize 32 $strip($1-)
  while ($0) {
    var %id = $ticks, %scheme, %user, %pass, %ssl = $false, %address = $1, %request = /
    if ($pos(%address,://)) {
      var %address = $mid(%address,$calc($v1 + 3))
      if ($v1 > 1) {
        var %scheme = $mid($1,1,$calc($v1 - 1))
        if (*s iswm %scheme) var %ssl = $true, %scheme = $left(%scheme,-1)
      }
    }
    if ($pos(%address,/)) var %request = $gettok($mid(%address,$v1),1,35)
    var %address = $gettok(%address,1,47)
    if (*?:?*@* iswm %address) {
      var %user = $gettok(%address,1,58)
      var %pass = $gettok($gettok(%address,2,58),1,64)
    }
    if ($pos(%address,@)) var %address = $mid(%address,$calc($v1 + 1))
    var %host = $gettok(%address,1,58)
    if (www.* iswm %host) var %scheme = http
    elseif (ftp.* iswm %host) var %scheme = ftp
    elseif (irc.* iswm %host) var %scheme = irc
    var %port = $gettok(%address,2,58)
    if (*.pdf* iswm $1-) || (*youtu*be* iswm $1-) { halt }
    if (%scheme == http) {
      if ($sock($+(urlinf.,%scheme,.,%id))) sockclose $v1
      sockopen $iif(%ssl,-e) $+(urlinf.,%scheme,.,%id) $urlinf.idna(%host) $iif(%port isnum,$v1,$iif(%ssl,443,80))
      sockmark $+(urlinf.,%scheme,.,%id) $ticks $ctime $network # $nick $address $+(%user,:,%pass) $urlinf.urlencode($utfencode(%request))
    }
    tokenize 32 $2-
  }
}
on *:SOCKOPEN:urlinf.*: {
  if (*.pdf* iswm $1-) || (*youtu*be* iswm $1-) { haltdef }
  tokenize 32 $sock($sockname).mark
  if ($sockerr) ; msg $4 $+([,$sock($sockname).addr,:,$sock($sockname).port,]) $sock($sockname).wsmsg
  elseif (urlinf.http.* iswm $sockname) {
    if ($urlinf.depositfiles($sockname).sockopen) return
    sockwrite -n $sockname GET $8 HTTP/1.0
    sockwrite -n $sockname User-Agent: Mozilla/??
    sockwrite -n $sockname Host: $+($sock($sockname).addr,$iif($sock($sockname).port != 80,$+(:,$v1)))
    sockwrite -n $sockname Accept: */*
    if ($sock($sockname).addr == vkontakte.ru) sockwrite -n $sockname Cookie: remixsid=be06679f9f3c9a4c95a91a37d398a77f69d9cb94c9e36f6279b5198c
    if (*?:?* iswm $7) sockwrite -n $sockname Authorization: Basic $encode($7,m)
    sockwrite -n $sockname
  }
}
on *:SOCKREAD:urlinf.*: {
  if (*.pdf* iswm $1-) || (*youtu*be* iswm $1-) { haltdef }
  tokenize 32 $sock($sockname).mark
  if ($sockerr) {
    ; REM msg $3 $+([,$sock($sockname).addr,:,$sock($sockname).port,]) $sock($sockname).wsmsg
    hdel urlinf.sockets $sockname
  }
  elseif (urlinf.http.* iswm $sockname) {
    sockread $+(&packet.,$sockname)
    if ($sockbr = 0) return
    bcopy $+(&,$sockname) $calc($hget(urlinf.sockets,$sockname,$+(&,$sockname)) + 1) $+(&packet.,$sockname) 1 -1
    bunset $+(&packet.,$sockname)
    hadd -b urlinf.sockets $sockname $+(&,$sockname)
    if ($bfind($+(&,$sockname),1,13 10 13 10)) {
      var %offset = $v1 + 4, %filename = $mkfn($urlinf.urldecode($nopath($8)))
      if ($bfind($+(&,$sockname),1,Location:)) && ($v1 < %offset) {
        var %location = $urlinf.char($urlinf.space($bvar($+(&,$sockname),$calc($v1 + 10),$calc($bfind($+(&,$sockname),$v1,13 10) - $v1 - 10)).text))
      }
      if ($bfind($+(&,$sockname),1,Content-Type:)) && ($v1 < %offset) {
        var %type = $urlinf.char($urlinf.space($bvar($+(&,$sockname),$calc($v1 + 14),$calc($bfind($+(&,$sockname),$v1,13 10) - $v1 - 14)).text))
        if ($pos(%type,;)) var %type = $mid(%type,1,$calc($v1 - 1))
      }
      if ($bfind($+(&,$sockname),1,Content-Length:)) && ($v1 < %offset) {
        var %length = $urlinf.char($urlinf.space($bvar($+(&,$sockname),$calc($v1 + 16),$calc($bfind($+(&,$sockname),$v1,13 10) - $v1 - 16)).text))
      }
    }
    elseif ($sock($sockname).rcvd > $calc(16 * 1024)) {
      hdel urlinf.sockets $sockname
      sockclose $sockname
      return
    }
    else {
      return
    }
  }
  if ($bvar($+(&,$sockname),0) = 0) return
  if ($urlinf.youtube($sockname)) {
    if ($urlinf.youtube($sockname).view) {
      if ($3 == Jabber::) {

      }
      else {
        ;  msg $4 [01,00You00,04Tube]: Title: $+(,$urlinf.youtube($sockname).title,) $(|) By: $+(,$urlinf.youtube($sockname).author,) (uploaded on $urlinf.youtube($sockname).date $+ ) $(|) Duration: $+(,$duration($urlinf.youtube($sockname).duration,3),) $(|) Views: $+(,$urlinf.youtube($sockname).view,) $(|) Rating: $+(,$urlinf.youtube($sockname).rate,) ( $+ $+(,$urlinf.youtube($sockname).rates,) ratings)
        ;  msg $4 Downloading the video... $+(14,$urlinf.youtube($sockname).download,)
      }
      hdel urlinf.sockets $sockname
      sockclose $sockname
    }
  }
  elseif ($urlinf.tinyurl($sockname)) {
    if ($urlinf.tinyurl($sockname).redirect) {
      if ($3 == Jabber::) {
        ;  REM jabber $4 TinyURL ( $+ $+(http://tinyurl.com,$8) $+ ) redirects to: $urlinf.char($urlinf.tinyurl($sockname).redirect)
      }
      else {
        ;  msg $4 00,02TinyURL ( $+ $+(http://tinyurl.com,$8) $+ ) redirects to: $+(,$urlinf.char($urlinf.tinyurl($sockname).redirect),)
      }
      hdel urlinf.sockets $sockname
      sockclose $sockname
    }
    elseif ($urlinf.tinyurl($sockname).error) {
      if ($3 == Jabber::) {
        ;  REM jabber $4 TinyURL $urlinf.tinyurl($sockname).error
      }
      else {
        ;  msg $4 00,02TinyURL $urlinf.tinyurl($sockname).error
      }
      hdel urlinf.sockets $sockname
      sockclose $sockname
    }
  }
  elseif ($urlinf.depositfiles($sockname)) {
    if ($v1 == no_download_msg) {
      if ($3 == Jabber::) {
        ;  REM jabber $4 [depositfiles]: $utfencode(Такого файла не существует или он был удален из-за нарушения авторских прав.)
      }
      else {
        ; msg $4 [01,00de05,00p04,00o01,00sit14,00files]: Такого файла не существует или он был удален из-за нарушения авторских прав.
      }
      hdel urlinf.sockets $sockname
      sockclose $sockname
    }
    elseif ($urlinf.depositfiles($sockname).link) {
      if ($3 == Jabber::) {
        REM jabber $4 [depositfiles]: $urlinf.depositfiles($sockname).name ( $+ $urlinf.depositfiles($sockname).size $+ ) @ $urlinf.depositfiles($sockname).link
      }
      else {
        msg $4 [01,00de05,00p04,00o01,00sit14,00files]: $+(,$urlinf.depositfiles($sockname).name,) ( $+ $urlinf.depositfiles($sockname).size $+ ) @ $+(14,$urlinf.depositfiles($sockname).link,)
      }
      hdel urlinf.sockets $sockname
      sockclose $sockname
    }
  }
  elseif ($urlinf.bashorg($sockname)) {
    if ($urlinf.bashorg($sockname).quote) {
      var %i = 1, %quote = $urlinf.html($replace($v1,<br>,$chr(1)))
      while ($gettok(%quote,%i,1)) {
        msg $4 14> $v1
        inc %i
      }
      hdel urlinf.sockets $sockname
      sockclose $sockname
    }
  }
  elseif ($urlinf.jpeg($sockname)) {
    if ($urlinf.jpeg($sockname,%length).dimensions) {
      var %dimensions = $v1, %exif
      if ($urlinf.jpeg($sockname).exif) var %exif = (Exif: $v1 $+ )
      if ($3 == Jabber::) {
        REM jabber $4 12[Image12] $+(12jpeg) $+(w12:,$urlinf.jpeg($sockname,%dimensions).width) $+(h12:,$urlinf.jpeg($sockname,%dimensions).height) %exif 12@ $iif(%length,$urlinf.size($v1), size12: $urlinf.size($sock($sockname).rcvd))
      }
      else {
        msg $4 12[Image12] $+(12jpeg) $+(w12:,$urlinf.jpeg($sockname,%dimensions).width) $+(h12:,$urlinf.jpeg($sockname,%dimensions).height) %exif 12@ $iif(%length,$urlinf.size($v1), size12: $urlinf.size($sock($sockname).rcvd))
        ;msg $4 12[Image12] Format: $+(JPEG) :: Dimensions: $+($urlinf.jpeg($sockname,%dimensions).width,x,$urlinf.jpeg($sockname,%dimensions).height) px. @ $iif(%length,$urlinf.size($v1), $urlinf.size($sock($sockname).rcvd))
      }
      hdel urlinf.sockets $sockname
      sockclose $sockname
    }
    elseif ($sock($sockname).rcvd > $calc(64 * 1024)) {
      hdel urlinf.sockets $sockname
      sockclose $sockname
    }
  }
  elseif ($urlinf.gif($sockname)) {
    if ($urlinf.gif($sockname).dimensions) {
      if ($3 == Jabber::) {
        REM jabber $4 12[Image12] $+(12gif) $+(w12:,$urlinf.gif($sockname,%dimensions).width) $+(h12:,$urlinf.gif($sockname,%dimensions).height) 12@ $iif(%length,$urlinf.size($v1), size: $urlinf.size($sock($sockname).rcvd))
      }
      else {
        msg $4 12[Image12] $+(12gif) $+(w12:,$urlinf.gif($sockname).width) $+(h12:,$urlinf.gif($sockname).height) 12@ $iif(%length,$urlinf.size($v1), size: $urlinf.size($sock($sockname).rcvd))
        ;msg $4 Image: Format: $+(GIF) :: Dimensions: $+($urlinf.gif($sockname,%dimensions).width,x,$urlinf.gif($sockname,%dimensions).height) px. @ $iif(%length,$urlinf.size($v1), $urlinf.size($sock($sockname).rcvd))
      }
      hdel urlinf.sockets $sockname
      sockclose $sockname
    }
    elseif ($sock($sockname).rcvd > $calc(4 * 1024)) {
      hdel urlinf.sockets $sockname
      sockclose $sockname
    }
  }
  elseif ($urlinf.png($sockname)) {
    if ($urlinf.png($sockname).dimensions) {
      var %dimensions = $v1
      if ($3 == Jabber::) {
        REM jabber $4 12[Image12] $+(12PNG) $+(w12:,$urlinf.png($sockname,%dimensions).width) $+(h12:,$urlinf.png($sockname,%dimensions).height) 12@ $iif(%length,$urlinf.size($v1), size12: $urlinf.size($sock($sockname).rcvd))
      }
      else {
        msg $4 12[Image12] $+(12PNG) $+(w12:,$urlinf.png($sockname,%dimensions).width) $+(h12:,$urlinf.png($sockname,%dimensions).height) 12@ $iif(%length,$urlinf.size($v1), size12: $urlinf.size($sock($sockname).rcvd))
        ;msg $4 12[Image12] $+(PNG) :: Dimensions: $+($urlinf.png($sockname,%dimensions).width,x,$urlinf.png($sockname,%dimensions).height) px. @ $iif(%length,$urlinf.size($v1), size12: $urlinf.size($sock($sockname).rcvd))
      }
      hdel urlinf.sockets $sockname
      sockclose $sockname
    }
    elseif ($sock($sockname).rcvd > $calc(16 * 1024)) {
      hdel urlinf.sockets $sockname
      sockclose $sockname
    }
  }
  elseif ($urlinf.txt($sockname)) {
    if ($urlinf.txt($sockname).codepage) {
      if ($3 == Jabber::) {
        REM jabber $4 12[Text12] $+([,%type,]) $urlinf.txt($sockname).codepage 12@ $iif(%length,$urlinf.size($v1), size12: $urlinf.size($sock($sockname).rcvd))
      }
      else {
        msg $4 12[Text12] $+([,%type,]) $urlinf.txt($sockname).codepage 12@ $iif(%length,$urlinf.size($v1), size12: $urlinf.size($sock($sockname).rcvd))
      }
      hdel urlinf.sockets $sockname
      sockclose $sockname
    }
    elseif ($sock($sockname).rcvd > $calc(2 * 1024)) {
      hdel urlinf.sockets $sockname
      sockclose $sockname
    }
  }
  elseif ($urlinf.flv($sockname)) {
    if ($bvar($+(&,$sockname),0) < 8192) return
    if ($3 == Jabber::) {
      REM jabber $4 12[Video12] $+(FLV[,%type,]) $+(12w:,$urlinf.flv($sockname).width) $+(12h:,$urlinf.flv($sockname).height) 12@ $int($urlinf.flv($sockname).framerate) FPS, $duration($urlinf.flv($sockname).duration,3) (Videocodec: $replacex($urlinf.flv($sockname).videocodecid,0,H.264,2,Sorenson H.263,3,Macromedia Screen Video,4,VP6-E,5,VP6-S,6,Macromedia Screen Video 2) $+ , $int($urlinf.flv($sockname).videodatarate) $+(kbit/s,;) Audiocodec: $replacex($urlinf.flv($sockname).audiocodecid,0,RAW (PCM),1,ADPCM,2,MP3,6,Nellymoser,11,Speex) $+ , $int($urlinf.flv($sockname).audiodatarate) kbit/s) @ $iif(%length,$urlinf.size($v1),[rcvd] $urlinf.size($sock($sockname).rcvd))
    }
    else {
      msg $4 12[Video12] $+(FLV[,%type,]) $+(12w:,$urlinf.flv($sockname).width) $+(12h:,$urlinf.flv($sockname).height) 12@ $int($urlinf.flv($sockname).framerate) FPS, $duration($urlinf.flv($sockname).duration,3) (Videocodec: $replacex($urlinf.flv($sockname).videocodecid,0,H.264,2,Sorenson H.263,3,Macromedia Screen Video,4,VP6-E,5,VP6-S,6,Macromedia Screen Video 2) $+ , $int($urlinf.flv($sockname).videodatarate) $+(kbit/s,;) Audiocodec: $replacex($urlinf.flv($sockname).audiocodecid,0,RAW (PCM),1,ADPCM,2,MP3,6,Nellymoser,11,Speex) $+ , $int($urlinf.flv($sockname).audiodatarate) kbit/s) @ $iif(%length,$urlinf.size($v1),[rcvd] $urlinf.size($sock($sockname).rcvd))
    }
    hdel urlinf $sockname
    sockclose $sockname
  }
  elseif ($bfind($+(&,$sockname),%offset,<html)) {
    if ($bfind($+(&,$sockname),%offset,<title)) {
      var %> = $bfind($+(&,$sockname),$v1,>) + 1, %</ = 4096, %lost = ... (packet lost)
      if ($bfind($+(&,$sockname),%>,</)) {
        var %</ = $v1 - %>, %lost
        if (%</ > 4096) var %</ = $v2
      }
      if ($bvar($+(&,$sockname),%>,%</).text) {
        var %title = $urlinf.html($urlinf.char($v1)), %rutracker
        if ($isutf(%title)) var %title = $utfdecode(%title)
        if ($len(%title) > 256) var %title = $left(%title,128) ... (over 256 byte, truncated to 128)
        if (*rutracker.org iswm $sock($sockname).addr) {
          if (/forum/viewtopic.php?t=* iswm $8) var %rutracker = @ $+(12,http://dl.rutracker.org/forum/dl.php?t=,$gettok($gettok($8,2,61),1,38),)
        }
        if ($3 == Jabber::) {
          ;        REM jabber $4 URL: %title %lost %rutracker
        }
        else {
          ;         msg $4 URL: %title %lost %rutracker
        }
      }
      else {
        if ($3 == Jabber::) {
          REM jabber $4 URL: (title is empty)
        }
        else {
          ;     msg $4 URL: (title is empty)
        }
      }
      hdel urlinf.sockets $sockname
      sockclose $sockname
    }
    elseif ($sock($sockname).rcvd > $calc(16 * 1024)) || (%length == $calc($v1 - %offset + 1)) || ($bfind($+(&,$sockname),%offset,</html)) {
      if ($3 == Jabber::) {
        ;      REM jabber $4 URL: (no title found in this page)
      }
      else {
        ;       msg $4 URL: (no title found in this page)
      }
      hdel urlinf.sockets $sockname
      sockclose $sockname
    }
  }
  elseif ($sock($sockname).rcvd > %offset) {
    hdel urlinf.sockets $sockname
    sockclose $sockname
  }
}
on *:SOCKCLOSE:urlinf.*: {
  hdel urlinf.sockets $sockname
}
