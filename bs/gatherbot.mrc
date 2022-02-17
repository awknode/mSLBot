;;;;;;; Edit this to your channel name ;;;;;;;
alias -l gchan { return #tfc.invite }
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;; Edit this to change the default map, incase voting fails ;;;;;;;;
alias -l default_map { return destroy }
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;; Edit this to what color codes you would like ;;;;;;;
alias -l msg { msg $1 04,01[ 03-00 $2-  03-00 04,01] }

alias -l notice { notice $1 04,01[ 03-00 $2-  03-00 04,01] }

alias -l gtopic {
  if ($1 == g) { 
    topic $2 04,01[ 03-00 Gather Started, typed !add to play 03-00 04,01]04,01[ 03-00 04Map00: $iif($hget(gather,map),$v1,Undescided use !votemap.) 03-00 04,01]04,01[ 03-04 Admin00: $hget(gather,admin) 03-00 04,01]04,01[ 03- 04Type00: $iif($hget(gather,type),$v1,Unset) 03-00 04,01]
  }
  if ($1 == n) { topic $2 $hget(gather,topic) }
}

alias -l teams {
  var %a = $hget(gather,a), %b = $hget(gather,b)
  %a = ( $+ $numtok(%a,32) $+ /5 ): $replace(%a,$chr(32),$chr(32) 05-00 $chr(32)) $str($chr(32) 05-00 ?,$calc(5- $numtok(%a,32)))
  %b = ( $+ $numtok(%b,32) $+ /5): $replace(%b,$chr(32),$chr(32) 05-00 $chr(32)) $str($chr(32) 05-00 ?,$calc(5- $numtok(%b,32)))
  return Team A %a 03-00 04,01]04,01[ 03-00 Team B %b
}
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

alias -l isipp {
  if ($regex($1,\b(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?):(?:6[0-5]{2}[0-3][0-5]|[1-5][0-9]{0,4}|[1-9][0-9]{0,3}|[0-9])\b)) {
    return $1
  }
}

alias -l topmap {
  window @votemap
  clear @votemap
  var %x = 1, %chan = $1
  while ($hfind(votemap,*.map,%x,w)) {
    if ($hget(votemap,$v1)) { aline @votemap $v1 $gettok($hfind(votemap,*.map,%x,w),1,46) }
    inc %x
  }
  filter -eutc 1 32 @votemap @votemap
  tokenize 32 $line(@votemap,1)
  if ($2) && ($2 != $hget(gather,map)) {
    hadd gather map $2
    if (!$timer(map)) .timermap 1 3 msg %chan The most voted map is now $2 $+ , with $1 votes!
    gtopic g %chan
  }
  if (!$2) { hdel gather map | gtopic g %chan  }
}

alias -l startgame {
  if (!$hget(gather,map)) hadd gather map $default_map
  mode $gchan +m
  var %x = 1
  while (%x <= 10) {
    msg $gettok($hget(gather,a) $hget(gather,b),%x,32) Ip: $hget(gather,ip) Password: $hget(gather,pw) see you on the server, Your admin is $hget(gather,admin) $+ , The map is $hget(gather,map) $+ .
    inc %x
  }
  topic $gchan n
  mode $gchan -m
  hfree gather
}

alias -l endgame {
  msg $1- | gtopic n $1 | hfree gather | window -c @votemap
  if ($hget(votemap)) hfree votemap
}

on *:start:{ .flood on | .flood 300 100 10 0  }

on *:text:!teams:$($gchan):{
  if (!$hget(gather)) { notice $nick There is no gather on at the moment. | return }
  if (!$timer(teams)) { .timerteams 1 3 msg $gchan $!teams }
}

on *:text:!pickup:$($gchan):{
  if ($nick !ison $gchan) { msg $nick You must be in $v2 to start a gather. | return }
  if ($nick !isop $gchan) { msg $nick You must be opped in $v2 to start a gather. | return }
  if ($hget(gather)) { msg $nick There is already a gather started. | return }
  ; if (!$3) { msg $nick Correct format: Addgame IP Password [map] | return }
  ; if (!$isipp($2)) { msg $nick Invalid IP:Port, please use a valid ip:port. | return }
  if (!$4) { hmake votemap 100 | window -h @votemap }
  if ($hget(gather)) hfree gather
  hadd -m gather ip $2 | hadd gather pw $3 | hadd gather map $iif($4,$4,0)
  hadd gather topic $chan($gchan).topic | hadd gather admin $nick
  gtopic g $gchan
}

on *:text:!end:$($gchan):{
  if (!$hget(gather)) { msg $nick There is no gather started. | return }
  if ($nick != $hget(gather,admin)) { msg $nick You're not the admin of this gather. | return }
  endgame $gchan Gather stopped by request of admin: $nick $+ .
}

on *:text:!addmap &:$($gchan):{
  if (!$hget(gather)) { notice $nick There is no gather started. | return }
  if ($nick != $hget(gather,admin)) { notice $nick The admin for this gather is $v2 $+ . | return }
  if ($hget(gather,map) == $2) && (!$hget(votemap)) { notice $nick The current map is already $2 $+ . | return }
  hadd gather map $2
  if ($hget(votemap)) hfree votemap
  window -c @votemap | gtopic g $chan
}

on *:text:!addtype *:$($gchan):{
  if (!$hget(gather)) { notice $nick There is no gather started. | return }
  if ($nick != $hget(gather,admin)) { notice $nick The admin for this gather is $v2 $+ . | return }
  hadd gather type $2-
  gtopic g $chan
}

on *:text:!mapvotes:$($gchan):{
  if (!$hget(gather)) { notice $nick There is no gather started. | return }
  if (!$hget(votemap)) { notice $nick Votemap is not enabled. | return }
  var %x = 1, %maps
  while ($line(@votemap,%x)) { tokenize 32 $v1 | %maps = %maps $2 $+ $+($chr(40),$1,$chr(41)) | inc %x }
  msg $chan The map votes are: $iif(%maps,$v1,No votes recorded.)
}

on *:text:!map:$($gchan):{
  if (!$hget(gather)) { notice $nick There is no gather started. | return }
  msg $chan The map for this gather is: $iif($hget(gather,map),$v1,Not yet descided $+ $chr(44) use !votemap to vote.)
}

on $*:text:/^!votemap (?!on$)\S+$/i:$($gchan):{
  if (!$hget(gather)) { notice $nick There is no gather started. | return }
  if (!$hget(votemap)) { notice $nick Votemap is not enabled. | return }
  if (!$istok($hget(gather,a) $hget(gather,b),$nick,32)) { notice $nick You're not added to this gather $+ . | return }
  if ($hget(votemap,$+($nick,.vote))) { notice $nick You've already voted for map $v1 $+ , use !remvote to remove your vote. | return }
  hinc votemap $+($2,.map) | hadd votemap $+($nick,.vote) $2
  notice $nick Vote recorded. | topmap $chan
}

on *:text:!votemap on:$($gchan):{
  if ($nick != $hget(gather,admin)) { notice $nick You're not the admin of this gather. | return }
  if (!$hget(gather)) { notice $nick There is no gather started. | return }
  if ($hget(votemap)) { notice $nick Votemap is already enabled. | return }
  hmake votemap 100 | hadd gather map 0 | window -h @votemap
  gtopic g $chan

}

on *:text:!remvote:$($gchan):{
  if (!$hget(gather)) { notice $nick There is no gather started. | return }
  if (!$istok($hget(gather,a) $hget(gather,b),$nick,32)) { notice $nick You're not added to this gather $+ . | return }
  if (!$hget(votemap,$+($nick,.vote))) { notice $nick You haven't voted for a map. | return }
  var %map = $hget(votemap,$+($nick,.vote)) $+ .map
  hdec votemap %map | hdel votemap $nick $+ .vote
  notice $nick Vote removed.
  topmap $chan
}

on $*:text:/^!add(?= a$| b$|$)/i:$($gchan):{
  if (!$hget(gather)) { notice $nick There is no gather on at the moment. | return }
  if ($istok($hget(gather,a) $hget(gather,b),$nick,32)) { notice $nick You're already added to this gather. | return }
  if ($2) {
    if ($numtok($hget(gather,$2),32) < 5) { hadd gather $2 $nick $hget(gather,$2) }
    else { notice $nick Sorry team $2 $+ , is full. | return }
  }
  else {
    if ($numtok($hget(gather,a),32) < $numtok($hget(gather,b),32)) { hadd gather a $hget(gather,a) $nick }
    elseif ($numtok($hget(gather,b),32) < $numtok($hget(gather,a),32)) { hadd gather b $hget(gather,b) $nick }
    else { var %a = $r(a,b) | hadd gather %a $hget(gather,%a) $nick }
  }
  if ($numtok($hget(gather,a) $hget(gather,b),32) == 10) startgame
  if (!$timer(teams)) { .timerteams 1 3 msg $gchan $!teams }
}

on *:text:!remove:$($gchan):{
  if (!$hget(gather)) { notice $nick There is no gather on at the moment. | return }
  if (!$istok($hget(gather,a) $hget(gather,b),$nick,32)) { notice $nick You're not added to this gather. | return }
  if ($hget(votemap,$+($nick,.vote))) { hdec votemap $v1 $+ .map | hdel votemap $+($nick,.vote) | topmap $gchan }
  if (!$istok($hget(gather,a) $hget(gather,b),$nick,32)) { notice $nick You're not added to this gather. | return }
  hadd gather b $remtok($hget(gather,b),$nick,1,32)
  hadd gather a $remtok($hget(gather,a),$nick,1,32) 
  if (!$timer(teams)) { .timerteams 1 3 msg $gchan $!teams }
}

on *:part:$($gchan):{
  if (!$hget(gather)) return
  if ($nick == $me) { hfree gather | return }
  if ($nick == $hget(gather,admin)) { endgame $chan Game has ended after the admin parted the channel. | return }
  if ($hget(votemap,$+($nick,.vote))) { hdec votemap $v1 $+ .map | hdel votemap $+($nick,.vote) | topmap $gchan }
  if ($istok($hget(gather,a) $hget(gather,b),$nick,32)) {
    hadd gather a $remtok($hget(gather,a),$nick,1,32)
    hadd gather b $remtok($hget(gather,b),$nick,1,32)
    if (!$timer(teams)) { .timerteams 1 3 msg $gchan $!teams }
  }
}

on *:nick:{
  if (!$hget(gather)) return
  if ($nick == $hget(gather,admin)) hadd gather admin $newnick
  if ($istok($hget(gather,a),$nick,32)) { hadd gather a $reptok($hget(gather,a),$nick,$newnick,1,32) }
  if ($istok($hget(gather,b),$nick,32)) { hadd gather b $reptok($hget(gather,b),$nick,$newnick,1,32) }
  if ($hget(votemap,$+($nick,.vote))) { hdec votemap $v1 $+ .map | hadd votemap $newnick $v1 | hdel votemap $+($nick,.vote) }
}

on *:kick:$($gchan):{
  if (!$hget(gather)) return
  if ($knick == $hget(gather,admin)) { endgame $chan Gather has ended after admin got kicked from the channel. | return }
  if ($knick == $me) { if ($hget(gather)) hfree gather | if ($hget(votemap)) hfree votemap | return }
  if ($hget(votemap,$+($knick,.vote))) { hdec votemap $v1 $+ .map | hdel votemap $+($knick,.vote) | topmap $gchan }
  if ($istok($hget(gather,a) $hget(gather,b),$knick,32)) {
    hadd gather a $remtok($hget(gather,a),$knick,1,32)
    hadd gather b $remtok($hget(gather,b),$knick,1,32)
    if (!$timer(teams)) { .timerteams 1 3 msg $gchan $!teams }
  }
}

on *:quit:{
  if (!$hget(gather)) return
  if ($nick == $hget(gather,admin)) { endgame $gchan Gather has ended after the admin quit.| return }
  if ($hget(votemap,$+($nick,.vote))) { hadd votemap $v1 $+ .map $remtok($hget(votemap,$+($v1,.map)),$nick,1,32) | hdel votemap $+($nick,.vote) | topmap $gchan }
  if ($istok($hget(gather,a) $hget(gather,b),$nick,32)) {
    hadd gather a $remtok($hget(gather,a),$nick,1,32)
    hadd gather b $remtok($hget(gather,b),$nick,1,32)
    if (!$timer(teams)) { .timerteams 1 3 msg $gchan $!teams }
  }
}

on *:deop:$($gchan):{
  if (!$hget(gather)) return
  if ($opnick == $me) && ($hget(gather)) {
    msg $chan Gather has ended after being deopped from the channel.
    if ($hget(votemap)) hfree votemap | hfree gather
  }
  if ($hget(gather,admin) == $opnick) { endgame $chan Gather has ended after the admin being deopped from the channel. | return }
}
