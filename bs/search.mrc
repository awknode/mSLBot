; scripts for text
; /srch filename text
; /srch * :sock

alias srch  {
  ; change this to -ag to instead show to active window -> | var %echotarget = $chan
  if ($0 == 1) tokenize 32 * $1
  msg $chan /srch on searches scripts for text. Syntax: "/srch scriptname/wildcard text" 
  msg $chan Display: $+(#Match:,$chr(22),Line#,$chr(22)) $+(script line,$chr(22),matchtext,$chr(22),script line)
  msg $chan Example: /srch * :sock 
  if (!$0) return | var %totalscripts = $script(0) , %s = -1 , %s_or_a 1
  msg $chan ============  $chr(3) $+ 0,12 This search: $+ $chr(15) /srch $1- $chr(9)
  var %ticks = $ticks , %win = @srch, %matchcount 1 | window -h %win
  while (%s < %totalscripts) {
    inc %s | if (%s == 0) goto top | var %f = $remove($iif(%s_or_a,$script(%s),$alias(%s)),$mircdir)
    if ($+(*,$1,*) iswm %f) {
      filter -fwc $qt(%f) %win * | var %i = 1 , %line = 1 | msg $chan $chr(3) $+ 0,5 %s searching-> %f $chr(9)
      while (%line) {
        var %line = $fline(%win,$+(*,$2-,*),%i)
        if (%line) { msg $chan $+($chr(35),%matchcount,:,$chr(22),%line,$chr(22)) $replace($line(%win,%line),$2-,$+($chr(22),$2-,$chr(22))) | inc %i | inc %matchcount }
      }
    }
    :top
    if ((%s == %totalscripts) && (%s_or_a)) { var %s 0, %totalscripts = $alias(0) , %s_or_a 0 }
  }
  msg $chan $chr(3) $+ 0,5 Finished! $calc($ticks - %ticks) $+ ms $chr(9) | :exit | window -c %win
}
; Pairs: Counts 2 ASCII chars on a line, reports if they don't have the same COUNT
; Mostly useful for finding mis-matched (parenthesis) or [square braces]
; /pairs ( ) *
; /pairs [ ] *
; /pairs 40 41 *

; can use next aliases like: "/count_par *" or "/count_sq *"
alias count_par { pairs 40 41 $1- }
alias count_sq { pairs 91 93 $1- }

alias pairs  {
  ; change this to -ag to instead show to active window -> | var %echotarget = $chan
  if (($len($1) == 1) && ($len($2) == 1) && ($1 !isnum) && ($2 !isnum)) tokenize 32 $asc($1) $asc($2) $iif($3-,$3-,*)
  if ($0 isnum 0-1) tokenize 32 40 41 $iif($1,$1,*)
  msg $chan Pairs warns of different counts of a pair of ASCII numbers. Syntax: "/pairs ASCIInumber ASCIInumber scriptname/wildcard" or "/pairs Char1 Char2 *" 
  msg $chan False alarms include $chr(22) emoticons like :) $chr(22) or $chr(22) lines divided across $ $+ & $chr(22) or $chr(22) 1 side of pair using $ $+ chr(N) i.e. $ $+ chr(40) with ) $chr(22) <- these mis-matches causes this line to be reported by this script as 2-vs-4
  msg $chan Suggest fixing from the bottom upwards if add/removing lines
  msg $chan Displays: Count1-vs-Count2 $+(Line:,$chr(22),N,$chr(22)) script-line
  msg $chan ============ Example: /pairs ( ) * $chr(3) $+ 0,12 Current Search: /pairs $1 $2 $iif($3- == *,*, $+(*,$3-,*) ) $chr(9)
  var %ticks = $ticks , %win = @match_chars , %s = 0 , %totalscripts = $script(0) , %s_or_a 1
  window -h %win | if (!$2) tokenize 32 40 41 $iif($1,$1,*) | if (($1 !isnum 1-65535) || ($2 !isnum 1-65535)) return
  while (%s < %totalscripts) {
    inc %s | if (%s == 0) goto top | var %f = $remove($iif(%s_or_a,$script(%s),$alias(%s)),$mircdir)
    if ($+(*,$3-,*) iswm %f) {
      filter -fwc $qt(%f) %win * | var %i = 1 , %tl = $line(%win,0) | msg $chan $chr(3) $+ 0,5 %s searching-> %f $chr(9)
      while (%i < %tl) { inc %i | var %text = $line(%win,%i) | if ($count(%text,$chr($1)) != $count(%text,$chr($2))) msg $chan $+($v1,-vs-,$v2) $+(Line:,$chr(22),%i,$chr(22)) %text }
    }
    :top
    if ((%s == %totalscripts) && (%s_or_a)) { var %s 0, %totalscripts = $alias(0) , %s_or_a 0 }
  }
  msg $chan $chr(3) $+ 0,5 Finished! $calc($ticks - %ticks) $+ ms $chr(9) | :exit | window -c %win
}

on $owner:text:/^[$](srch)( |$)/iS:#:{
  if (!%fud && !$($+(%, fud., $nick), 2)) {
    set -u3 %fud On
    set -u10 %fud. $+ $nick On
    if ($2 == par) { msg $chan $count_par | halt }
    if ($2 == sq) { msg $chan $count_sq | halt }
    ;;   if ($2 == br) { msg $chan $count_br | halt }
    if (!$2) {    
      msg $chan Invalid format. Add search an input. i.e. - 12$srch par (parenthesis match)

    }
    else { .srch $2- | halt 
    }
  }
}
