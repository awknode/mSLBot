on *:load: { hmake requests 1000 | if $isfile(requests.hash) { hload requests requests.hash } }
on *:exit: { hsave requests requests.hash }

on *:TEXT:!request *:#batcave-chat: {
  if !fld. [ $+ [ $nick ] ] {
    set -u2 %fld. [ $+ [ $nick ] ] 1
    if $+(*,$chr(46),*) iswm $2- { msg # Error with !request: No Spaces, you must use periods... !request title.name.goes.here | halt }
    if $2 == list { .msg # Listing 10 Most Recent Requests | var %c 1 | while %c <= 10 { .msg # $+(,%c,.) $hget(requests,%c).item | inc %c } | .msg # [EOF] - $+(,return $hget(requests,0).item,) Total Requests. }
    elseif $2- && $+(*,$chr(46),*) !iswm $2- { hadd requests $2- $nick | .msg # Request $+(,$2-,) by $+(,$nick,) has been added to the Requests list. }
  }
}
on $owner:TEXT:!filled *:#batcave-chat: {
  if !fld. [ $+ [ $nick ] ] {
    set -u2 %fld. [ $+ [ $nick ] ] 1
    if $+(*,$chr(46),*) iswm $2- { msg # Error with !filled: No Spaces, you must use periods... !filled title.name.goes.here | halt }
    if $hfind(requests, $2-, 1) { var %n $hget(requests, $2,1).data | hdel requests $2- | .msg # The !Request $+(,$2-,) by $+(,%n,,) has been Filled! }
  }
}
