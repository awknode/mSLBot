alias wolf {
  JSONOpen -du wolf https://api.wolframalpha.com/v2/query?input= $+ $urlencode($1-) $+ &format=plaintext&output=JSON&appid=UXL8QH-TP99T3YEPQ
  if ($jsonerror) return .12WolfRam. → JSONerror6: $v1
  var %wolfram:calc = $json(wolf, queryresult, pods, 1, subpods, 0, plaintext).value
  if ($jsonerror) return .12WolfRam. → JSONerror6: $v1
  JSONClose wolf
  return .12WolfRam. → %wolfram:calc
}

alias wolfint {
  JSONOpen -du wolfint https://api.wolframalpha.com/v2/query?input= $+ ( $+ $urlencode($1-) $+ ) $+ ) $+ &format=plaintext&output=JSON&appid=UXL8QH-TP99T3YEPQ
  if ($jsonerror) return .12WolfRam. → JSONerror6: $v1
  var %wolfram:calc2 = return $json(wolfint, queryresult, pods, 0, subpods, 0, plaintext).value
  if ($jsonerror) return .12WolfRam. → JSONerror6: $v1
  JSONClose wolfint
  return .12WolfRam. → $remove(%wolfram:calc2,return)
}


on $*:text:/^[$](wolf)( |$)/iS:#:{
  if (!%fud && !$($+(%, fud., $nick), 2)) {
    set -u3 %fud On
    set -u10 %fud. $+ $nick On
    if (integrate isin $2- ) { msg $chan $left($replace($wolfint($2-), $crlf, $chr(32), $cr, $chr(32), $lf, $chr(32)), 300) | halt } 
    msg $chan $left($replace($wolf($2-), $crlf, $chr(32), $cr, $chr(32), $lf, $chr(32)), 300)
  }
}
