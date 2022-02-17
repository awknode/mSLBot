;!MLB !NBA !NHL !NFL
;edited by mruno Oct.01.2017
;http://www.espn.com/nfl/bottomline/scores

alias -l sports.scores.reduce.msgs return 1
alias -l sports.scores.bold return 1

on $*:text:/^.(nhl|nba|nfl|mlb)/Si:#:{
  var %trig = $
  if ($chr(37) isin $1-) || ($chr(36) isin $1-) return
  ;if (nfl isin $1) && ($script(nfl.mrc)) return
  if ($timer(SPORTS. $+ $regml(1))) { .notice $nick 12Slow down nerd. $timer(SPORTS. $+ $regml(1)).secs seconds left. | return }
  else .timerSPORTS. $+ $regml(1) 1 125 noop

  if (!$hget(sports.scores,count)) {
    if ($sock(scores)) sockclose scores
    sockopen scores www.espn.com 80
    sockmark scores $regml(1) msg #
    if ($sports.scores.reduce.msgs) {
      if ($hget(sports.scores)) hdel -w sports.scores *
      else hmake sports.scores
    }
  }

}
on *:sockopen:scores: {
  sockwrite -n $sockname GET $+(/,$gettok($sock(scores).mark,1,32),/bottomline/scores) HTTP/1.1
  sockwrite -n $sockname Host: $+(www.espn.com,$str($crlf,2))
  sockwrite -n $sockname $useragent
  sockwrite -n $sockname Host: $gettok($sock($sockname).mark,3,32) $+ $str($crlf,2)
  sockwrite -n $sockname $crlf
}
on *:sockread:scores: {
  var %scores
  sockread %scores
  if (%scores) {
    var %loop 0
    while ($gettok(%scores,0,38) > %loop) {
      inc %loop
      var %read $gettok(%scores,%loop,38)
      if (_s_left isin %read) {
        set %read $replace($gettok(%read,2,61),$chr(37) $+ 20,$chr(32))
        var %sport $upper($gettok($sock(scores).mark,1,32))
        if (%read) && (msg isin $gettok($sock(scores).mark,2-,32)) {
          if ($sports.scores.reduce.msgs) hadd sports.scores $+(%sport,.,$calc($hget(sports.scores,0).item + 1)) %read
          else $gettok($sock(scores).mark,2-,32) %sport $+ : %read
        }
      }
    }
    if (_s_loaded=true isin %read) {
      ;end of scores
      if ($sports.scores.reduce.msgs) scores.msg %sport $gettok($sock(scores).mark,2-,32)
      sockclose $sockname
    }
  }
}
alias -l scores.msg {
  if (!$2) return
  var %sport $1, %cmd $iif($1 == msg,$1-,$2-)
  if ($hget(sports.scores,0).item) {
    var %i 0, %data, %msg, %len
    while ($hget(sports.scores,0).item > %i) {
      inc %i
      set %data $hget(sports.scores,$+(%sport,.,%i))
      if ($sports.scores.bold) && ($chr(94) isin %data) {
        var %winner $gettok(%data,$findtok(%data,$wildtok(%data,^*,1,32),1,32),32),,$findtok(%data,$wildtok(%data,^*,1,32),32)
        set %data $remove($replace(%data,%winner,12 $+ %winner $+ ),^)
      }

      if ($isodd(%i)) {
        set %msg 12 %sport → %data
        set %len $len(%data)
        if ($chr(2) isin %data) dec %len 1
      }
      else {
        %cmd %msg $str($chr(160),$calc(44 - %len)) %data
        set %msg
        set %len
      }
    }
    if (%msg) && (%data) %cmd %sport $+ : %data
  }
  else %cmd 12I couldn't find any scores. :(
}
alias -l iseven return $iif(2 // $1,$true,$false)
alias -l isodd return $iif(!$iseven($1),$true,$false)
alias -l useragent {
  var %r $rand(1,14)
  if (%r == 1) return User-Agent: Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; Trident/5.0)
  elseif (%r == 2) return User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-GB; rv:1.8.1.6) Gecko/20070725 Firefox/2.0.0.6
  elseif (%r == 3) return User-Agent: Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 5.1)
  elseif (%r == 4) return User-Agent: Opera/9.20 (Windows NT 6.0; U; en)
  elseif (%r == 5) return User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.7.5) Gecko/20060127 Netscape/8.1
  elseif (%r == 6) return User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_6_8) AppleWebKit/537.13+ (KHTML, like Gecko) Version/5.1.7 Safari/534.57.2
  elseif (%r == 7) return User-Agent: Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_6_7; da-dk) AppleWebKit/533.21.1 (KHTML, like Gecko) Version/5.0.5 Safari/533.21.1
  elseif (%r == 8) return User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.2; WOW64; rv:1.8.0.7) Gecko/20110321 MultiZilla/4.33.2.6a SeaMonkey/8.6.55
  elseif (%r == 9) return User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/37.0.2049.0 Safari/537.36
  elseif (%r == 10) return User-Agent: Mozilla/5.0 (Windows NT 5.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/36.0.1985.67 Safari/537.36
  elseif (%r == 11) return User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:31.0) Gecko/20100101 Firefox/31.0
  elseif (%r == 12) return User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/61.0.3163.100 Safari/537.36
  elseif (%r == 13) return User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/52.0.2743.116 Safari/537.36 Edge/15.15063
  elseif (%r == 14) return User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:56.0) Gecko/20100101 Firefox/56.0
}
