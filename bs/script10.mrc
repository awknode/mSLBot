on *:JOIN:#:dnsbl rbl.efnetrbl.org $mid($address,$calc($pos($address,@) + 1)) /ban -ku600 # $nick 2

alias dnsbl {
  var %server = $1, %address = $2, %callback = $3-
  hinc -m dnsbl id
  hadd -m dnsbl $hget(dnsbl,id) %address %server %callback
  if ($iptype(%address) == ipv4) {
    var %ip = $+($gettok(%address,4,46),.,$gettok(%address,3,46),.,$gettok(%address,2,46),.,$gettok(%address,1,46))
    dns -h $+(%ip,.,%server)
  }
  else {
    dns -h %address
  }
}
on *:DNS: {
  var %ip = $+($gettok($dns(0).addr,4,46),.,$gettok($dns(0).addr,3,46),.,$gettok($dns(0).addr,2,46),.,$gettok($dns(0).addr,1,46))
  if ($hfind(dnsbl,$dns(0).addr *,0,w).data) {
    var %i = $v1
    while (%i) {
      var %n = $dns(0), %id = $hfind(dnsbl,$dns(0).addr *,%i,w).data, %server = $gettok($hget(dnsbl,%id),2,32), %callback = $gettok($hget(dnsbl,%id),3-,32), %i = %i - 1
      while (%n) {
        dnsbl %server $dns(%n).ip %callback
        dec %n
      }
      hdel dnsbl %id
    }
  }
  elseif ($hfind(dnsbl,%ip *,0,w).data) {
    var %i = $v1
    while (%i) {
      var %id = $hfind(dnsbl,%ip *,%i,w).data, %server = $gettok($hget(dnsbl,%id),2,32), %callback = $gettok($hget(dnsbl,%id),3-,32), %i = %i - 1
      if (%server == $gettok($dns(0).addr,5-,46)) {
        scid -r %callback DNSBL: resolved %ip to $dns(0).ip by %server
        hdel dnsbl %id
      }
    }
  }
}
