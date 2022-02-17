alias readXML {
  var %tag = $+(<,$1,>), %closingTag = $+(</,$1,>) 
  bread vimeo 0 $file(vimeo).size &binVar
  var %open = $bfind(&binVar, 0, %tag), %close = $bfind(&binVar, 0, %closingTag)

  return $bvar(&binVar, $calc(%open + $len(%tag)), $calc(%close - (%open + $len(%tag)))).text
}

alias htmlencode {
  var %str = $replace($1-,&amp;,&,&lt;,&#60;,&gt;,&#62;)
  var %str = $regsubex(%str,/&#(\d+?);/g,$chr(\1))
  var %str = $regsubex(%str,/&#x([\dA-F][\dA-F]);/g,$chr($base(\1,16,10)))
  return %str
}

on $*:text:/vimeo.com/(\d+)/Si:#:{
  if ($sock(vimeo)) .sockclose vimeo
  var -g %id = $regml(1), %msg = msg $target
  sockopen -e vimeo vimeo.com 443 
}

on *:input:*:{
  if ($regex($1, /vimeo.com/(\d+)/Si)) {
    if ($sock(vimeo)) .sockclose vimeo
    var -g %id = $regml(1), %msg = msg $target
    sockopen -e vimeo vimeo.com 443 
  }
}

on *:SOCKOPEN:vimeo: {
  sockwrite -nt $sockname GET /api/v2/video/ $+ %id $+ .xml http/1.0
  sockwrite -nt $sockname Host: vimeo.com
  sockwrite $sockname $crlf
}

on *:SOCKREAD:vimeo: {
  if ($sock($sockname).mark) {
    while ($sock($sockname).rq) {
      sockread &download_file
      .bwrite vimeo -1 -1 &download_file
    }
  }
  else {
    var %a
    sockread %a
    if (!%a) sockmark $sockname 1
  }
}

on *:SOCKCLOSE:vimeo: {
  var %title = $readXML(title), %upload_date = $readXML(upload_date), %description = $readXML(description), %likes = $readXML(stats_number_of_likes), %uploader = $readXML(user_name), %duration = $readXML(duration), %plays = $readXML(stats_number_of_plays) 

  %msg 14(Vimeo14) 12Title: $htmlencode(%title) 12By: %uploader 12On: $htmlencode(%upload_date)  $iif(%likes, 12Likes: $bytes($v1, b),) $iif(%plays, 12Plays: + $bytes($v1, b),) 12Duration: $duration(%duration)

  .remove vimeo
}
