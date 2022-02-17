
on *:text:*:*: {
  if ($regex($strip($1-),/imdb\.com\/title\/([a-z0-9]+)/i)) {
    ;Uncomment this linee and edit to halt th script on certain networks or chans
    ;if ($network == networktohalt) || ($network == anothernetwork) || ($chan == evenchans) { halt } 
    _imdb $cid $chan $+(/title/,$regml(1),/) 
  }
}
on *:sockopen:imdbsock.*: { 
  if ($sockerr) { /echo -g $gettok($sock($sockname).mark,2,32) Error. | halt }
  else {
    sockwrite -nt $sockname GET $gettok($sock($sockname).mark,3,32) HTTP/1.0 
    sockwrite -nt $sockname Host: www.imdb.com
    sockwrite -nt $sockname Content-type: text/html
    sockwrite -nt $sockname User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:20.0) Gecko/20100101 Firefox/20.0
    sockwrite -nt $sockname Connection: close
    sockwrite -nt $sockname $crlf
  }
}
on *:sockread:imdbsock.*: {
  var %v | sockread %v
  if ($regex(%v,/<title>(.*?)</title>/)) { sockmark $sockname $sock($sockname).mark title: $+ $encode($regml(1),m) }
  if (($regex(%v,/data-video="([^"]+)"/)) && (*Watch Trailer*</* iswmcs %v)) { sockmark $sockname $sock($sockname).mark trailer: $+ $encode($regml(1),m) }
  if (<div id="share-checkin"> isin %v) {
    var %title = $remove($decode($gettok($wildtok($sock($sockname).mark, title:*, 1, 32), 2, 58),m), - IMDb)
    var %trailer = $decode($gettok($wildtok($sock($sockname).mark, trailer:*, 1, 32), 2, 58),m)
    var %output = $+($chr(02),7Trailer:,$chr(32),$chr(31),http://www.imdb.com/video/imdb/,%trailer)
    scid $gettok($sock($sockname).mark, 1, 32) msg $gettok($sock($sockname).mark,2,32) %output
    sockclose $sockname
  }
}

alias _imdb { var %sockname = imdbsock. $+ $rand(10000,99999) | sockopen %sockname www.imdb.com 80 | sockmark %sockname $1- }
