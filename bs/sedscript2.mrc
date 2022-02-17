;on *:TEXT:s/*/*:#: {
;  ;;  exprotect $1-
;  spamprotect
;  ;; if ($botmaster($network,$nick)) { 
;  if ($regex($1-,/^s\x2F(.*)\x2F(.*)\x2F$/*)) {
;    var %pattern = $regml(1) , %substitution = $replace($regml(2), $cr, \r, $lf, \n) , %line = $line($chan,0) - 1
;    msg $chan $regsubex($line($chan,%line),$+(/,%pattern,/g), [ %substitution ] )
;    ;;  }
;  }
;  ;; else { msg # 12Invalid permissions. } 
;}
