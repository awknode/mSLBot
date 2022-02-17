alias -l s_loaded { var %i = 0 | var %sl | while (%i < $script(0)) { inc %i | var %sl %sl $regsubex($nopath($script(%i)), /(?<!^|[\\\/])\.[^\.]+$/,) } | msg $chan %sl }

on $*:text:/^[$](scripts)( |$)/iS:#:{
  if (!%fud && !$($+(%, fud., $nick), 2)) {
    set -u3 %fud On
    set -u10 %fud. $+ $nick On
    msg $chan $left($replace($s_loaded, $crlf, $chr(32), $cr, $chr(32), $lf, $chr(32)), 250)
  }
}
}
