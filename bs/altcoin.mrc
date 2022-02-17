alias coins {
  var %cur $1
  JSONOpen -du coin https://min-api.cryptocompare.com/data/pricemultifull?fsyms= $+ %cur $+ &tsyms=USD,EUR
  if (!$JSON(coin, DISPLAY).length) {
    return 12No results, check to make sure you are looking for an active crypto-currency. i.e. 12$cc BTC. 
  }
  var %price = $JSON(coin, DISPLAY, %cur, USD, PRICE).value
  var %high = $JSON(coin, DISPLAY, %cur, USD, HIGH24HOUR).value
  var %low = $JSON(coin, DISPLAY, %cur, USD, LOW24HOUR).value
  var %CHANGEPCT = $JSON(coin, DISPLAY, %cur, USD, CHANGEPCT24HOUR).value
  var %CHANGE = $JSON(coin, DISPLAY, %cur, USD, CHANGE24HOUR).value
  var %TRADE = $JSON(coin, DISPLAY, %cur, USD, LASTVOLUMETO).value
  var %VOLUME = $JSON(coin, DISPLAY, %cur, USD, VOLUME24HOUR).value
  var %wkpct = $JSON(pchg, 0, percent_change_7d).value
  JSONClose coin
  if ($jsonerror) return .12Crypto-12Currency. â†’ JSONerror6: $v1
  return .12 $+ %cur $+ . → $remove(%price, $chr(32)) USD 9↑3 $+ $remove(%high,$chr(32)) 05↓4 $+ $remove(%low,$chr(32)) .1224hChange. → $remove($iif(*-* iswm %CHANGE,04 $+ %CHANGE,09+ $+ %CHANGE),$chr(32)) $remove($iif(-* iswm %CHANGEPCT,04 $+ %CHANGEPCT,09+ $+ %CHANGEPCT),$chr(32)) $+ 12% .12Volume. → $remove(%VOLUME,$chr(32)) 
}

alias coinvals { 
  var %valcur $1
  JSONOpen -du pchg https://api.coinmarketcap.com/v1/ticker/ $+ $1
  if (!$JSON(pchg, 0).length) {
    return 12No results, check to make sure you are looking for an active crypto-currency. i.e. 12$cw bitcoin. 
  }
  var %wkpct = $JSON(pchg, 0, percent_change_7d).value
  var %rank = $JSON(pchg, 0, rank).value
  JSONClose pchg
  if ($jsonerror) return .12Crypto-12Currency. â†’ JSONerror6: $v1 
  return .12 $+ %valcur $+ .12 $+ Rank $+ . → $chr(35) $+ %rank  .12WkPctChg. → $iif(-* iswm %wkpct,04 $+ %wkpct,09+ $+ %wkpct)
}

on $*:text:/^[$](cc)( |$)/iS:#:{
  if (!%fud && !$($+(%, fud., $nick), 2)) {
    set -u3 %fud On
    set -u10 %fud. $+ $nick On
    if (!$2) {    
      msg $chan Invalid format. Add an input. i.e. - 12$cc BTC
      ;;  msg $chan $left($replace($coins, $crlf, $chr(32), $cr, $chr(32), $lf, $chr(32)), 250)
    }
    else { msg $chan $left($replace($coins($upper($2)), $crlf, $chr(32), $cr, $chr(32), $lf, $chr(32)), 250)
    }
  }
  else { msg $chan 23Slow down douche. }
}

on $*:text:/^[$](cw)( |$)/iS:#:{
  if (!%fud && !$($+(%, fud., $nick), 2)) {
    set -u3 %fud On
    set -u10 %fud. $+ $nick On
    if (!$2) {    
      msg $chan Invalid format. Add an input. i.e. - 12$cw bitcoin
      ;;  msg $chan $left($replace($coinvals, $crlf, $chr(32), $cr, $chr(32), $lf, $chr(32)), 250)
    }
    else { msg $chan $left($replace($coinvals($2), $crlf, $chr(32), $cr, $chr(32), $lf, $chr(32)), 250)
    }
  }
}

alias -l btctimer { if ($network == Juice-Did911) { //timer_btc 0 710 msg $chan $!coins($upper(BTC)) } }

On $*:TEXT:/^[$](btctimer)( |$)/iS:#:{
  if (!%fud && !$($+(%, fud., $nick), 2)) {
    if ($2 == disable) { //timer_btc off | msg # 9[BTC9] timer disabled. | halt }
    if (!$2) {
      set -u3 %fud On
      set -u10 %fud. $+ $nick On
      $btctimer
      msg # 9[BTC9] timer enabled.
    }
  }
  else { msg $chan 23Slow down douche. }
}
