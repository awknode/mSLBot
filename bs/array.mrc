;# set value: /array name=>something=>something=>something your values
;# set value: $array(name, something, something, something, your values).set
;#
;# /array players=>game=>users=> $+ Karen 5
;# /array players=>game=>users=> $+ Brady 7
;# $array(players, game, users, Jack, 10).set
;# $array(players, game, users, Deg, 3).set
;#
;# Using $array().set as a command allows you to use spaces and => character combos in array names

;# get value: $array(something, somethingelse, nextbranch)
;#
;# $array(players,game,users,Karen) would return 5

;# delete item/array: /array -d the=>array=>to=>delete
;# delete item/array: $array(the, array, to, delete).del
;#
;# /array -d players=>game=>users=>Karen
;# $array(players, game, users, Karen).del
;#
;# Using $array().del as a command allows you to use spaces and => character combos in array names
;#
;# delete all elements: /array -d OR $array().del

;# /alist array=>nextbranch=>thirdbranch
;#
;# this displays a list of all the arrays from the 3rd branch onwards, in @arraylist.
;# by itself, /alist will display your full sheet

;# $array().type
;#
;# imagine: /array stored=>text nice
;# $array(stored).type returns: array
;# $array(stored,text).type returns: data

;# $array().index
;#
;# $array(players,game,users,1).index returns Karen
;# $array(players,game,users,0).index returns 4 (the total number of data elements in array)
;# $array(players,game,users,Karen) returns the VALUE because no index is specified. The value is 5.
;#
;# $array(0).index returns the number of base elements

;# $array().rand
;#
;# $array(players,game,users).rand returns: Any of the possible child elements, including other arrays
;# $array(players,game,users,Karen).rand will return the data value as normal (4)

alias array {
  if (($prop && $istok(delete.del.set,$prop,46)) || (!$isid)) {
    var %delete = $iif(!$isid,$iif($1 == -d,1,0),$iif($istok(delete.del,$prop,46),1,0)), %piece
    if ((!$1) && (!%delete)) echo -stq Invalid parameters: /array
    else {
      var %parent = ArrayTable, %new, %value = $iif(!$isid,$iif(%delete,$3-,$2-),$iif($len($2),$($+($chr(36),$0),2),0)), %x = 1, %arrayend = $iif(!$isid,$numtok($replace($iif(%delete,$2,$1),=>,$chr(17)),17),$iif(%delete,$0,$iif($len($2),$calc($0 - 1),1)))
      if (!%value) %value = 0
      if (!$isid) tokenize 17 $replace($iif(%delete,$2,$1),=>,$chr(17))
      if (!$hget(arrayMap)) hmake arrayMap 100
      while (%x <= %arrayend) {
        if (%new) %parent = %new
        %piece = $replace($($+($chr(36),%x),2),$chr(32),$chr(18))
        %new = $+(%parent,$chr(17),%piece)
        inc %x
        if (!$hget(arrayMap, %new)) && (%x <= %arrayend) hadd arrayMap %new %parent
        if ($len($hget(%parent, %piece)) > 0) && (%x <= %arrayend) hdel %parent %piece
      }
      if (!%delete) {
        if (!$hget(%parent)) hmake %parent 50
        hadd %parent %piece %value
        clearChildren $+(%parent,$iif($len(%piece),$+($chr(17),%piece),$null))
      }
      else {
        if ($hget(%parent,%piece)) hdel %parent %piece
        else clearItem $+(%parent,$iif($len(%piece),$+($chr(17),%piece),$null))
      }
    }
  }
  else {
    var %array = ArrayTable, %x = 1, %n = $calc($0 - 1)
    while (%x <= %n) {
      %array = $+(%array,$chr(17),$replace($($+($chr(36),%x),2),$chr(32),$chr(18)))
      inc %x
    }
    if ($right(%array,1) == $chr(17)) %array = $left(%array,-1)
    var %child = $replace($($+($chr(36),$0),2),$chr(32),$chr(18)), %com = $+(%array,$iif($len(%child),$+($chr(17),%child),$null))
    if ($prop == type) {
      if ($len($hget(%array, %child))) return data
      elseif ($hget(arrayMap,$+(%array,$chr(17),%child))) || ($hfind(arrayMap,$+(%array,$chr(17),%child),1).data) return array
      return $false
    }
    if ($prop == rand) {
      if ($len($hget(%array, %child))) return $hget(%array, %child)
      var %r = $calc($iif($hfind(arrayMap,%com,0).data,$ifmatch,0) + $iif($hget(%com,0).item,$ifmatch,0))
      if (!%r) return $false
      %r = $rand(1,%r)
      if (%r <= $iif($hget(%com,0).item,$ifmatch,0)) return $replace($hget(%com,%r).item,$chr(18),$chr(32))
      %r = $hfind(arrayMap,%com,$calc(%r - $iif($hget(%com,0).item,$ifmatch,0))).data
      return $replace($gettok(%r,$numtok(%r,17),17),$chr(18),$chr(32))
    }
    if ($prop == index) {
      if (%child isnum) {
        if ($hget(%array, %child).item) return $iif(%child == 0,$calc($hget(%array, %child).item + $hfind(arrayMap,%array,0).data),$replace($hget(%array, %child).item,$chr(18),$chr(32)))
        return $iif($hfind(arrayMap,%array,$calc(%child - $iif($hget(%array,0).item,$ifmatch,0))).data,$replace($gettok($ifmatch,$numtok($ifmatch,17),17),$chr(18),$chr(32)),$false)
      }
      return $false
    }
    if ($hget(%array, $replace($($+($,$0),2),$chr(32),$chr(18)))) return $ifmatch
    if ($hfind(arrayMap,%array,1).data) return [array]
    return $false
  }
}

alias alist {
  window -ae[3] @arraylist
  var %array = $+(ArrayTable,$iif($replace($1,$+($chr(61),$chr(62)),$chr(17)),$+($chr(17),$ifmatch),$null)), %x = 1, %loop = 1, %d, %arraycopy = %array, %check, %count = 1
  echo @arraylist $c1($replace(%array,$chr(17),=>)) contains the following:
  var %x_1 = 1, %n = $iif($hfind(arrayMap,%array,0).data,$ifmatch,1)
  while (%x_1 <= %n) {
    if ($hget(%array)) && ($($+($chr(37),x_,%loop),2) == 1) {
      var %i = 1
      while (%i <= $hget(%array,0).item) {
        echo @arraylist $+($chr(91),!Data,$chr(93)) $c1($+($replace(%array,$chr(17),$c4(=>),$chr(18),$chr(32)),$c4(=>),$replace($hget(%array,%i).item,$chr(18),$chr(32)))) = $c3($hget(%array,%i).data)
        inc %i
      }
    }
    %d = $hfind(arrayMap,%array,$($+($chr(37),x_,%loop),2)).data
    if ($len(%d) > 1) {
      echo @arraylist $+($chr(91),Array,$chr(93)) $c1($replace(%d,$chr(17),$c4(=>),$chr(18),$chr(32)))
      inc %loop
      %array = %d
      var %x_ [ $+ [ %loop ] ] 0
    }
    elseif (%loop > 1) {
      dec %loop
      %array = $mid(%array,1,$calc($pos(%array,$chr(17),$pos(%array,$chr(17),0)) - 1))
    }
    %x_ [ $+ [ %loop ] ] = $calc($($+($chr(37),x_,%loop),2) + 1)
  }
}

alias -l c1 return $+(12,$1-,)
alias -l c3 return $+(03,$1-,)
alias -l c4 return $+(07,$1-,12)

alias -l clearChildren {
  var %table = $1-, %x = 1, %s, %m
  if ($hget(%table)) hfree %table
  while ($hfind(arrayMap,$+(%table,*),%x,w).data) {
    %m = $ifmatch
    if ($hget(%m)) hfree %m
    if ($hget(arrayMap,%m)) hdel arrayMap %m
    else inc %x
  }
  if ($hget(arraymap,%table)) hdel arraymap %table
}

alias -l clearItem {
  var %x = 0, %s, %m, %t = $1-
  while (!%x && $hget(arrayMap,%t)) || (%x && $hfind(arrayMap,$+(%t,$chr(17),*),%x,w)) {
    %m = $iif(%x,$hfind(arrayMap,$+(%t,$chr(17),*),%x,w),%t)
    if (!%x) %m = %t
    hdel arrayMap %m
    if ($hget(%m)) hfree %m
    else inc %x
  }
  if (%t == ArrayTable) {
    hfree -w ArrayTable*
    hdel -w ArrayMap *
  }
}
