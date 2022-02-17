alias wolfram {
  JSONOpen -du wolf https://api.wolframalpha.com/v2/query?input= $+ $2 $+ %2B $+ $3 $+ %2B $+ $4 $+ &format=plaintext&output=JSON&appid=UXL8QH-TP99T3YEPQ
  var %wolf:calc = $round($JSON(wolf, pods, Result, plaintext).value, 2)
  var %ETH:USD = $round($JSON(coin, RAW, ETH, USD, PRICE).value, 2)
  var %LTC:USD = $round($JSON(coin, RAW, LTC, USD, PRICE).value, 2)
  var %PPC:USD = $round($JSON(coin, RAW, PPC, USD, PRICE).value, 2)
  var %high:btc = $round($JSON(coin, RAW, BTC, USD, HIGH24HOUR).value, 2)
  var %low:btc = $round($JSON(coin, RAW, BTC, USD, LOW24HOUR).value, 2)
  var %high:eth = $round($JSON(coin, RAW, ETH, USD, HIGH24HOUR).value, 2)
  var %low:eth = $round($JSON(coin, RAW, ETH, USD, LOW24HOUR).value, 2)
  var %xmr:usd = $round($JSON(coin, RAW, XMR, USD, PRICE).value, 2)
  JSONClose wolf
  return 6[WolfRam6] %wolf:calc
}

; $+(,$chr(91),9H,3,igh:,%high:btc,$chr(93)) $+(,$chr(91),4L,5,ow:,%low:btc,$chr(93)) Ethereum (ETH):12 %ETH:USD $+(,$chr(91),9H,3,igh:,%high:eth,$chr(93)) $+(,$chr(91),4L,5,ow:,%low:eth,$chr(93))  Litecoin (LTC):12 %LTC:USD Peercoin (PPC):12 %PPC:USD

on $*:text:/^[$](wolf)( |$)/iS:#:{
  if (!%fud && !$($+(%, fud., $nick), 2)) {
    set -u3 %fud On
    set -u10 %fud. $+ $nick On
    msg $chan $left($replace($wolf, $crlf, $chr(32), $cr, $chr(32), $lf, $chr(32)), 250)
  }
}
