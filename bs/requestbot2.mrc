on *:load: { 
  hmake requests 1000
  if ($isfile(requests.hash)) { hload requests requests.hash }
}
on *:exit: { hsave requests requests.hash }
on *:start: {
  hmake requests 1000 
  if ($isfile(requests.hash)) { hload requests requests.hash } 
}
alias regtot { return $hget(requests,0).item }

On $*:Text:/^[!%.@](rq|request)(\s|$)/Si:#: {  
  if (!$2) { msg $chan [Ex. !12request <file12.name12.here>] }
  elseif (!fld. [ $+ [ $nick ] ]) {
    set -u2 %fld. [ $+ [ $nick ] ] 1
    if ($2 != list) { 
      hadd requests $2 $nick | msg $chan Request  $2- by $+(,$nick,) has been added to the Requests list. 
    }
    elseif ($2 == list) {
      var %cc $iif($regtot <= 10,$regtot,10) 
      msg # Listing Most Recent !Requests... 
      var %c 1 
      while (%c <= %cc) { 
        msg $chan $+(,%c,.) $hget(requests,%c).item 
        inc %c 
      }  
      msg # $+(,$retot,) Total Request(s). 
    } 
    elseif ($+(*,$chr(32),*) !iswm $2-) { 
      msg $chan Error with !request: No Spaces, you must use periods... !request title.name.goes.here
    }
  }
}
On $*:Text:/^[!%.@](fill|filled)(\s|$)/Si:#: {
  if (!$2) { msg $chan [Ex. !12filled <file12.name12.here>] }
  if (!fld. [ $+ [ $nick ] ]) {
    set -u2 %fld. [ $+ [ $nick ] ] 1
    if ($+(*,$chr(32),*) iswm $2) {
      msg $chan Error with !filled: No Spaces, you must use periods... !filled title.name.goes.here 
    }
    if ($hfind(requests,$2,1)) { 
      hdel requests $2
      msg $chan The !Request $+(,$2-,) has been Filled!
    }
  }
}
