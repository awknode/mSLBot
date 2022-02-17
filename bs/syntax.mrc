alias syntaxx {
  var %r1 = /(\$[^\s\(\),\x03]+)/g | var %r2 = /([\(\)\[\]])/g | var %r3 = /([,\:><=&|!])/g | var %r4 = /(%[^\s\(\),\x03]+)/g
  var %r5 = /([\{\}])/g | var %r6 = /(?:^|\G)(\s)/g | var %r7 = /(#[^\s\(\),\x03]*)/g
  var %loop = 1, %end = $cb(0)
  while (%loop <= %end) {
    return $regsubex($regsubex($regsubex($regsubex($regsubex($regsubex($regsubex($1-,%r1,09\1),%r2,12\1),%r3,07\1),%r4,14\1),%r5,13\1),%r6,\1),%r7,04\1)
    inc %loop 1
  }
}

on $*:text:/^[$](syntax)( |$)/iS:#:{
  if (!%fud && !$($+(%, fud., $nick), 2)) {
    set -u3 %fud On
    set -u10 %fud. $+ $nick On
    if (!$2) {    
      msg $chan Invalid format. Add an input. i.e. - 12$syntax code
      ;;  msg $chan $left($replace($syntaxx, $crlf, $chr(32), $cr, $chr(32), $lf, $chr(32)), 250)
    }
    else { msg $chan $left($replace($syntaxx($2-), $crlf, $chr(32), $cr, $chr(32), $lf, $chr(32)), 250)
    }
  }
}
