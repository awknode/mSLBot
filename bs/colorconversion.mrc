on $owner:TEXT:/^[$](rgb2hex)(\s|$)/Si:#: {
  spamprotect
  exprotect $1-
  if (!%fud && !$($+(%, fud., $nick), 2)) {
    set -u3 %fud On
    set -u10 %fud. $+ $nick On
    if ($2) { msg $chan $left($replace($rgbtohex($2-), $crlf, $chr(32), $cr, $chr(32), $lf, $chr(32)), 250)
    }
    else { msg $chan Incorrect format. rgbtohex 44 128 201 returns: #2C80C9 }
  } 
  else { msg $chan Slow down douche. }
}

on $owner:TEXT:/^[$](rgb2hsl)(\s|$)/Si:#: {
  spamprotect
  exprotect $1-
  if (!%fud && !$($+(%, fud., $nick), 2)) {
    set -u3 %fud On
    set -u10 %fud. $+ $nick On
    if ($2) { msg $chan $left($replace($rgb2hsl($2-), $crlf, $chr(32), $cr, $chr(32), $lf, $chr(32)), 250)
    }
    else { msg $chan Incorrect format. rgb2hsl 44 128 201 returns: 207.9 64.1 48 }
  } 
  else { msg $chan Slow down douche. }
}

on $owner:TEXT:/^[$](hex2rgb)(\s|$)/Si:#: {
  spamprotect
  exprotect $1-
  if (!%fud && !$($+(%, fud., $nick), 2)) {
    set -u3 %fud On
    set -u10 %fud. $+ $nick On
    if ($2) { msg $chan $left($replace($hextorgb($2-), $crlf, $chr(32), $cr, $chr(32), $lf, $chr(32)), 250)
    }
    else { msg $chan Incorrect format. hex2rgb (#2C80C9) returns: 44 128 201 }
  } 
  else { msg $chan Slow down douche. }
}

on $owner:TEXT:/^[$](hsl2hex)(\s|$)/Si:#: {
  spamprotect
  exprotect $1-
  if (!%fud && !$($+(%, fud., $nick), 2)) {
    set -u3 %fud On
    set -u10 %fud. $+ $nick On
    if ($2) { msg $chan $left($replace($hsltohex($2-), $crlf, $chr(32), $cr, $chr(32), $lf, $chr(32)), 250)
    }
    else { msg $chan Incorrect format. hsltohex (207.9 64.1 48) returns #2C80C9 }
  } 
  else { msg $chan Slow down douche. }
}

on $owner:TEXT:/^[$](hsl2rgb)(\s|$)/Si:#: {
  spamprotect
  exprotect $1-
  if (!%fud && !$($+(%, fud., $nick), 2)) {
    set -u3 %fud On
    set -u10 %fud. $+ $nick On
    if ($2) { msg $chan $left($replace($hsltorgb($2-), $crlf, $chr(32), $cr, $chr(32), $lf, $chr(32)), 250)
    }
    else { msg $chan Incorrect format. hsl2rgb (207.9 64.1 48) returns 44 128 201 }
  } 
  else { msg $chan Slow down douche. }
}


on $owner:TEXT:/^[$](hex2hsl)(\s|$)/Si:#: {
  spamprotect
  exprotect $1-
  if (!%fud && !$($+(%, fud., $nick), 2)) {
    set -u3 %fud On
    set -u10 %fud. $+ $nick On
    if ($2) { msg $chan $left($replace($hextohsl($2-), $crlf, $chr(32), $cr, $chr(32), $lf, $chr(32)), 250)
    }
    else { msg $chan Incorrect format. hex2hs1 (#2C80C9) returns: 207.9 64.1 48 }
  } 
  else { msg $chan Slow down douche. }
}

on $owner:TEXT:/^[$](hex2rgb)(\s|$)/Si:#: {
  spamprotect
  exprotect $1-
  if (!%fud && !$($+(%, fud., $nick), 2)) {
    set -u3 %fud On
    set -u10 %fud. $+ $nick On
    if ($2) { msg $chan $left($replace($hextorgb($2-), $crlf, $chr(32), $cr, $chr(32), $lf, $chr(32)), 250)
    }
    else { msg $chan Incorrect format. hex2rgb (hhex) }
  } 
  else { msg $chan Slow down douche. }
}


on $owner:TEXT:/^[$](hex2hsl)(\s|$)/Si:#: {
  spamprotect
  exprotect $1-
  if (!%fud && !$($+(%, fud., $nick), 2)) {
    set -u3 %fud On
    set -u10 %fud. $+ $nick On
    if ($2) { msg $chan $left($replace($hextohsl($2-), $crlf, $chr(32), $cr, $chr(32), $lf, $chr(32)), 250)
    }
    else { msg $chan Incorrect format. hex2hsl (hex) }
  } 
  else { msg $chan Slow down douche. }
}


alias rgbtohex {
  tokenize 44 $replace($1-3,$chr(32),$chr(44))
  if (!$2) tokenize 44 $rgb($1)
  return $+($chr(35),$base($1,10,16,2),$base($2,10,16,2),$base($3,10,16,2))
}

alias rgbtohsl {
  tokenize 44 $replace($1-3,$chr(32),$chr(44))
  if (!$2) tokenize 44 $rgb($1)
  var %r = $calc($1 / 255), %g = $calc($2 / 255), %b = $calc($3 / 255), %s = 0, %h = 0, %d
  var %sort = $sorttok(%r %g %b,32,n), %min = $gettok(%sort,1,32), %max = $gettok(%sort,3,32), %l = $calc((%max + %min) / 2)
  if (%min == %max) return 0 0 $iif($prop == decimal,$round(%l,3),$round($calc(%l * 100),1))
  %d = $calc(%max - %min)
  if (%max == %r) %h = $calc((%g - %b) / %d)
  elseif (%max == %g) %h = $calc(2 + ((%b - %r) / %d))
  else %h = $calc(4 + ((%r - %g) / %d))
  %h = $round($calc(%h * 60),1)
  if (%h < 0) inc %h 360
  %s = $iif(%l > 0.5,$calc(%d / (2 - %max - %min)),$calc(%d / (%max + %min)))
  if ($prop == decimal) return $round($calc((%h / 360)),3) $round(%s,3) $round(%l,3)
  return %h $round($calc(%s * 100),1) $round($calc(%l * 100),1)
}

alias hextorgb {
  var %h = $remove($1-,$chr(35)), %r = $rgb($base($mid(%h,1,2),16,10),$base($mid(%h,3,2),16,10),$base($mid(%h,5,2),16,10))
  if ($prop == single) return %r
  return $iif($prop != comma,$replace($rgb(%r),$chr(44),$chr(32)),$rgb(%r))
}

alias hextohsl {
  var %r = $hextorgb($1)
  return $iif($prop == decimal,$rgbtohsl(%r).decimal,$rgbtohsl(%r))
}

alias hsltorgb {
  tokenize 32 $replace($1-,$chr(44),$chr(32))
  if ($4 != decimal) tokenize 32 $calc($1 / 360) $calc($2 / 100) $calc($3 / 100)
  if ($2 == 0) var %r = $round($calc($3 * 255),0), %g = %r, %b = %r
  else {
    var %h = $1, %s = $2, %l = $3, %q, %p
    %q = $iif(%l < 0.5,$calc(%l * (1 + %s)),$calc((%l + %s) - (%l * %s)))
    %p = $calc((2 * %l) - %q)
    %r = $hue2rgb(%q, %p, $calc(%h + 1/3))
    %g = $hue2rgb(%q, %p, %h)
    %b = $hue2rgb(%q, %p, $calc(%h - 1/3))
    %r = $round($calc(%r * 255),0)
    %g = $round($calc(%g * 255),0)
    %b = $round($calc(%b * 255),0)
  }
  if ($prop == single) return $rgb(%r,%g,%b)
  return $iif($prop == comma,$+(%r,$chr(44),%g,$chr(44),%b),%r %g %b)
}

alias hsltohex {
  var %r = $hsltorgb($1-)
  return $rgbtohex(%r)
}

alias hue2rgb {
  var %t = $3
  if (%t < 0) inc %t
  if (%t > 1) dec %t
  if ($calc(6 * %t) < 1) return $calc($2 + (($1 - $2) * 6 * %t))
  if (%t < 0.5) return $1
  if ($calc(%t * 3) < 2) return $calc($2 + (($1 - $2) * 6 * (2/3 - %t)))
  return $2
}
