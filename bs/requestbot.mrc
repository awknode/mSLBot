on *:load: { hmake requests 1000 | if $isfile(requests.hash) { hload requests requests.hash } }
on *:exit: { hsave requests requests.hash }
on *:start: { hmake requests 1000 | if $isfile(requests.hash) { hload requests requests.hash } }
alias regtot { return $hget(requests,0).item }

on *:TEXT:!request *:#batcave-chat: {
  if (!fld. [ $+ [ $nick ] ]) {
    set -u2 %fld. [ $+ [ $nick ] ] 1
    ;  if $hget(requests,0).item == 0 { msg $chan No Requests to List | return }
    if (!$2) { msg #batcave-chat ex. !request <file.name.here> }
    if ($2 && $+(*,$chr(32),*) !iswm $2-) && ($2 != list) { hadd requests $2 $nick | msg $chan Request  $2- by $+(,$nick,) has been added to the Requests list. | goto end }
    if ($2 == list) { var %cc $iif($regtot <= 10,$regtot,10) | msg # Listing Most Recent !Requests... | var %c 1 | while %c <= %cc { msg $chan $+(,%c,.) $hget(requests,%c).item | inc %c } | msg # [EOF] - $+(,$retot,) Total Request(s). | goto end }
    if ($+(*,$chr(32),*) !iswm $2-) { msg $chan Error with !request: No Spaces, you must use periods... !request title.name.goes.here | goto end }
    :end
  }
}

on $owner:TEXT:!filled *:#batcave-chat: {
  if (!fld. [ $+ [ $nick ] ]) {
    set -u2 %fld. [ $+ [ $nick ] ] 1
    if ($+(*,$chr(32),*) iswm $2) { msg $chan Error with !filled: No Spaces, you must use periods... !filled title.name.goes.here | goto end }
    if ($hfind(requests,$2,1)) { hdel requests $2 | msg $chan The !Request $+(,$2-,) has been Filled! | goto end }
    :end

  }
}
