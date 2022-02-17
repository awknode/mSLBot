; $fuzzy(table, item, [inc], [expire], [5, 1800], [..., ...])
ALIAS fuzzy {
  var %ctime, %table, %item, %inc, %exp, %data, %i, %cnt, %dur, %then, %diff
  set %ctime $ctime
  set %table $1
  set %item  $replace($2,$chr(32),$chr(1))
  set %inc   $str(%ctime $+ $chr(32),$3)
  set %exp   $iif($4,u $+ $4)

  set %data %inc $+ $left($hget(%table,%item),4000)
  hadd -m $+ %exp sanity %item %data

  set %i 5
  while (%i <= $0) {
    set %cnt $ [ $+ [ %i ] ]
    inc %i
    set %dur $ [ $+ [ %i ] ]
    inc %i

    set %then $gettok(%data,%cnt,32)
    set %diff %ctime - %then
    if (!%dur) return %diff
    if (%diff <= %dur) return %diff %cnt %dur
  }
} ; by Raccoon 2018

On @*:TEXT:*:#: {
  if ($fuzzy(sanitybot, TEXT $cid $chan $mask($fulladdress,3), 86400, 1,  5,10 , 20,300 , 100,3600)) {
    msg $chan $nick 12Slow down nerd! $gettok($v1,2,32) lines in $gettok($v1,1,32) seconds.
  } 
}
