on *:start:{
  .timerwebpwnize 0 20 getlist
}

alias webpwnlookup {
  JSONOpen -du lookup https://webpwnize.me/irc/dank
  var %result = $json(lookup, $1, msg)
  JSONClose lookup
  return %result
}

;alias ws1 {
;  JSONOpen -du raw https://webpwnize.me/irc/workspace/$+ $2
;  var %x = 1, %handle.info = company contact crawl credential domain host location port vulnerability url, %handle.users null, %output
;  while (%x < $var(handle.*,0)) {
;    var %h = 0
;    while (%h < $gettok([ [ $var(handle.*,%x) ] ],0,32)) {
;      inc %h
;      var %out = $+(raw,$chr(44),$remove($var(handle.*,%x),$+($chr(37),handle.)),$chr(44),$iif($gettok([ [ $var(handle.*,%x) ] ],%h,32) != null,$addtok($calc(%h - 1),$v1,44),$calc(%h - 1)))
;      var %put = %put $upper($+($chr(2),$iif($gettok([ [ $var(handle.*,%x) ] ],%h,32) != null,$v1,$remove($var(handle.*,%x),$+($chr(37),handle.))),:,$chr(2))) $json( [ [ %out ] ] )
;    }
;    inc %x
;  }
;  return %put
;  JSONClose raw
;}

alias ws1 {
  JSONOpen -du raw https://webpwnize.me/irc/workspace/ $+ $1
  var %users, %n = 0, %e = $JSON(raw, users, length)
  while (%n < %e) {
    %users = $addtok(%users, $JSON(raw, users, %n), 32)
    inc %n
  }
  if (%users == $null ) { msg $chan 14(Webpwnize.Me14) 4Error - No workspace.  | halt }
  return 14(Webpwnize.Me14) Company:12 $json(raw, info, 0, company) Contact:12 $json(raw, info, 1, contact) Crawl:12 $json(raw, info, 2, crawl) Credential:12 $json(raw, info, 3, credential) Domain:12 $json(raw, info, 4, domain) Host:12 $json(raw, info, 5, host) Location:12 $json(raw, info, 6, location) Port:12 $json(raw, info, 7, port) Vulnerability:12 $json(raw, info, 8, vulnerability) URL(s):12 $json(raw, info, 9, url) Users:12 %users
  JSONClose raw
}

on $*:text:/^[!@.](webp)( |$)/iS:#webpwnize.me:{
  if ((%fud) || ($($+(%,fud.,$nick),2))) { return } 
  set -u3 %fud On 
  set -u10 %fud. $+ $nick On
  msg #webpwnize.me 14(Webpwnize.Me14)12 $webpwnlookup(0)
}

on $*:text:/^[!@.](ws)( |$)/iS:#webpwnize.me:{
  if ((%fud) || ($($+(%,fud.,$nick),2))) { return }
  set -u3 %fud On
  set -u10 %fud. $+ $nick On
  if (!$2) { msg $chan Improper syntax. [ Choose a workspace. i.e. - 12.ws 1 ] | halt }
  if {$2) { msg $chan $ws1($2) }
}

alias getlist {
  var %i = 0
  while (%i <= 5 ) {
    var %lookup = $webpwnlookup(%i)
    if (%lookup != $NULL ) {
      if ($readini(cache.ini, msg, $replace(%lookup,$chr(32),$chr(255))) != 1 ) {
        msg #webpwnize.me 14(Webpwnize.Me14)12 %lookup
        writeini -n cache.ini msg $replace(%lookup,$chr(32),$chr(255)) 1
      }
    }
    inc %i 1
  }
}

alias getwork {
  var %i = 1
  while (%i <= $lines(tables.txt) ) {
    var %tablename = $read(tables.txt, %i)
    var %value = $workspace1(1, %tablename)
    var %r = %r %tablename %value
    inc %i 1
  }
  return %r
}
