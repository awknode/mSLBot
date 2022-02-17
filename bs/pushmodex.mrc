; Pushmode X - by entropy & Talon 2017
; Usage: /pushmodex [-tN] # [modes] [nicks/hosts]
; Example: /pushmodex #channel +bbbbbb host1 host2 host3 host4 host5 host6
; If "-tN" is specified, sets a timer in milliseconds eg: /pushmode -t2000... (for 2 secs) 

alias pushmodex {
  if (-t* iswm $1) { var %time = $mid($1,3) , %count = 0 | tokenize 32 $2- }
  else { var %time = 0 , %count = 0 }
  var %modespl = $modespl , %chan = $1 , %modes = $2 , %parms = $3- , %x = 1 , %y = $len(%modes) , %lwhich = + , %which = + , %a , %b
  tokenize 44 $chanmodes
  var %t1 = $1 , %t2 = $nickmode $+ $2 , %t3 = $3 , %t4 = $4
  tokenize 32 %parms
  while (%x <= %y) {
    var %t = $mid(%modes,%x,1)
    if (%t isin +-) { var %lwhich = %which , %which = %t }
    else {
      if (%t isincs $gettok(%t1 %t2 %t3, 1- $pos(.-+, %which),32)) {
        var %b = %b $1
        tokenize 32 $2-
      }
      var %a = $+(%a,$iif(!%a || %lwhich != %which,%which),%t) , %lwhich = %which
      if ($len($remove(%a,+,-)) = %modespl) {
        if (!%time) { mode %chan %a %b }
        else { .timer -m 1 $calc(%time * %count) mode %chan %a %b }
        var %a = "" , %b = "", %count = %count + 1
      }
    }
    inc %x
  }
  if (%a) { 
    if (!%time) { mode %chan %a %b }
    else { .timer -m 1 $calc(%time * %count) mode %chan %a %b }
  }
}
