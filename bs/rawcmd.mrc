on $owner:text:/^(!raw)\b/i:#: {
  if ($botmaster($network,$nick)) {
    var %x = $ticks, %target = $iif($chan,$chan,$nick) 
    if ($0 == 1) { var %result = usage $1- <code> | goto result }
    .alias mircdebugalias tokenize 32 $!1- $chr(124) $iif($istok($ %,$left($2,1),32),return  $!+) $2- $chr(124) return $!result
    var %result = $mircdebugalias($1-), %result = $iif((!$istok($crlf $cr $lf,$strip(%result),32)) && ($strip(%result) != $null),%result,<empty string>)
    :result
    if ($status == connected) { msg %target result: %result $+  - duration: $calc($ticks - %x) ms }
    goto end
    :error { | var %result = $error | reseterror | goto result }
    :end { | .alias mircdebugalias }
  }
}
