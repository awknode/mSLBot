alias udlookup {

  var %switches, %def, %ex

  ;; since called as an identifier, we need to fix the tokens to be space delimited
  tokenize 32 $1-

  ;; remove switches from the other parameters
  if (-* iswm $1 && $0 > 1) {
    %switches = $mid($1, 2-)
    tokenize 32 $2-
  }

  ;; perform the request
  JSONOpen -du lookup http://api.urbandictionary.com/v0/define?term= $+ $replace($1-,$chr(32),$chr(43))
  if ($JSONError) {
    return JSONerror6: $v1
  }

  ;; check results
  elseif (!$JSON(lookup, list).length) {
    return 12No results.
  }

  ;; if a switch has been specified
  elseif ($regex(%switches, /l(\d+)/)) {
    var %n = $regml(1)
    %def = $JSON(lookup, list, %n, definition).value
    %ex  = $JSON(lookup, list, %n, example).value
  }

  ;; otherwise use the first entry
  else {
    %def = $JSON(lookup, list, 0, definition).value
    %ex  = $JSON(lookup, list, 0, example).value
  }

  ;; check for lookup errors
  if ($JSONError) {
    return JSONerror6: $v1
  }

  ;; return the result
  return %def .12example. %ex
}
on $*:TEXT:/^[$](urban|urbandictionary|ud)( |$)/iS:#:{
  var %switches

  ;; remove command from parameters
  tokenize 32 $2-

  ;; remove switches from parameters
  if (-* iswm $1) {
    %switches = $1
    tokenize 32 $2-
  }

  ;; flood protection check
  if (!%fud && !$($+(%,fud.,$nick),2)) {
    set -u3 %fud On
    set -u10 %fud. $+ $nick On  

    ;; invalid format
    if (!$0) {
      msg $chan 12Invalid format. 12[ie12. .ud word12]
    }
    if ($chan == #party ) {
      msg $chan 12.UD12. $+(.12, $2-, .) $left($replace($udlookup(%switches $1-), $crlf, $chr(32), $cr, $chr(32), $lf, $chr(32)), 250)
    }
    ;; lookup
    else {
      msg $chan 12.UD12. $+(.12, $1-, .) $left($replace($udlookup(%switches $1-), $crlf, $chr(32), $cr, $chr(32), $lf, $chr(32)), 250)
    }
  }
}

;on $*:text:/^[$](urban|urbandictionary|ud)( |$)/iS:#:{
;  ; if ($istok(%chan,#,44)) {
;  IF (!$2) { MSG $chan 12Invalid format. 12[ie12. .ud word12] | return }
;  IF ((%fud) || ($($+(%,fud.,$nick),2))) { return }
;  SET -u3 %fud On
;  SET -u10 %fud. $+ $nick On  
; if $regex($2-,/^(dongblasterlklsjfdla)/iS) {
;   msg $chan 12UD sup
; }
;  if (-* iswm $2- ) { MSG $chan 12.UD12. $+(.12,$3-4,.) $left($replace($udlookup($3-), $crlf, $chr(32), $cr, $chr(32), $lf, $chr(32)), 250) | halt }
;  else { MSG $chan 12.UD12. $+(.12,$2-3,.) $left($replace($udlookup($2-), $crlf, $chr(32), $cr, $chr(32), $lf, $chr(32)), 250) }

; Else {
;   IF ((%fud) || ($($+(%,fud.,$nick),2))) { return }
;   SET -u15 %fud On
;   SET -u30 %fud. $+ $nick On  
; MSG $chan [UD] isn't enabled here $nick $+ , fkn dbag.
; }
;}
