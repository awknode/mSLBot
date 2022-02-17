;On *:TEXT:*:#: {
;  if ($chan == ##party) { 
;   ;; var -n %d = $eval(s/*/*/,0)
;    if (s/*/* iswm $2-) { 
;      var %a = $gettok($2,2-,47), %b = $gettok($2,3,47), %c = $fline(@sed,$chr(42) $+ %a $+ $chr(42),0)
;      msg $chan what he meant to say was: $strip($replace($fline(@sed,$chr(42) $+ %a $+ $chr(42), %c).text,%a,%b))
;      halt
;    }
;  }   
;  else {
;   ;; var -n %d = $eval(s/*/*/,0)
;    if (s/*/* iswm $1-) { 
;      var %a = $gettok($1-,2,47), %b = $gettok($1-,3,47), %c = $fline(@sed,* $+ %a $+ *,0)
;      msg $chan what he meant to say was: $strip($replace($fline(@sed,* $+ %a $+ *, $calc(%c -1)).text,%a,%b))
;      halt
;    }
;  }
;}

On *:TEXT:*:#: { 
  if (s/*/* iswm $1-) { 
    if (!%sed && !$($+(%, sed., $nick), 2)) {
      set -u3 %sed On
      set -u10 %sed. $+ $nick On
      spamprotect
      exprotect $1-
      var %a = $gettok($1-,2,47), %b = $gettok($1-,3,47), %c = $fline(#,* $+ %a $+ *,0), %d = $gettok( $strip($replace($fline(#,* $+ %a $+ *, $calc(%c -1)).text,%a,%b)) ,2-,32)
      msg $chan 14[4SED14] $gettok( $strip($replace($fline(#,* $+ %a $+ *, $calc(%c -1)).text,%a,%b)) ,2-,32) 
    } 
  }
}


;; //echo -a $regex(s/([^///////]+)/something/,/s\x2F(.*)\x2F(.*)\x2F$/) match: A = $regml(1) B = $regml(2)
;;1 match: A = ([^///////]+) B = something

;On *:TEXT:*:#: { 
;  if (s/*/* iswm $1-) { 
;    if (!%sed && !$($+(%, sed., $nick), 2)) {
;      set -u3 %sed On
;      set -u10 %sed. $+ $nick On
;      var %a = $gettok($1-,2,47), %b = $gettok($1-,3,47), %c = $fline(#,* $+ %a $+ *,0), %d = $gettok( $strip($replace($fline(#,* $+ %a $+ *, $calc(%c -1)).text,%a,%b)) ,2-,32)
;      msg $chan 14[4SED14]  $regsubex( %d , %b , $regml(1) ) %d
;    } 
;  }
;}
