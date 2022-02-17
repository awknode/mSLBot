;;;IP LOOKUP by OrFeAsGr;;;;;;;;;;;
;;; http://humanity.ucoz.com - Humanity IRC Bot Services ;;;;;
;;; For Wikked ;;;;;;;;;
;;; <3 :D :P xD ;;;;;;;;;
;;; v0.1 23/1/2016 ;;;

on *:sockopen:iplook: {
  if ($sockerr) { echo -at Error While Looking Up IP }
  sockwrite -nt $sockname GET %iplook HTTP/1.1
  sockwrite -nt $sockname User-Agent: Mozilla/4.0
  sockwrite -nt $sockname Host: whatismyipaddress.com
  sockwrite $sockname $crlf
}

on *:sockread:iplook: {
  if ($sockerr) { echo -at Error While Looking Up IP }
  var %read
  sockread %read
  ;echo -at %read
  if (*!*PAC* iswm %read) {
    ;echo -at $findtok(%read,>,0,62)
    set %decimal $iif($gettok($gettok(%read,$calc($findtok(%read,Decimal:</th,1,62) + 2),62),1,60) == /td, Not Found, $v1)
    if (*Decimal:* !iswm %read) {
      set %decimal NA
    }
    set %hostname $iif($gettok($gettok(%read,$calc($findtok(%read,Hostname:</th,1,62) + 2),62),1,60) == /td, Not Found, $v1)
    if (*Hostname:* !iswm %read) {
      set %Hostname NA
    }
    set %asn $iif($gettok($gettok(%read,$calc($findtok(%read,ASN:</th,1,62) + 2),62),1,60) == /td, Not Found, $v1)
    if (*ASN:* !iswm %read) {
      set %asn NA
    }
    set %isp $iif($gettok($gettok(%read,$calc($findtok(%read,ISP:</th,1,62) + 2),62),1,60) == /td, Not Found, $v1)
    if (*ISP:* !iswm %read) {
      set %isp NA
    }
    set %org $iif($gettok($gettok(%read,$calc($findtok(%read,Organization:</th,1,62) + 2),62),1,60) == /td, Not Found, $v1)
    if (*Organization:* !iswm %read) {
      set %org NA
    }
    set %type $iif($gettok($gettok(%read,$calc($findtok(%read,Type:</th,1,62) + 3),62),1,60) == /td, Not Found, $v1)
    if (*Type:* !iswm %read) {
      set %type NA
    }
    set %assign $iif($gettok($gettok(%read,$calc($findtok(%read,Assignment:</th,1,62) + 3),62),1,60) == /td, Not Found, $v1)
    if (*Assignment:* !iswm %read) {
      set %assign NA
    }
    msg %ipchan $iif(%decimal != NA, 14(Decimal14) %decimal, $null) $iif(%hostname != NA, 14(Hostname14) %hostname, $nul) $iif(%asn != NA, 14(ASN14) %asn, $null) $iif(%isp == %org, 14(ISP14) %isp, $iif(%isp != NA, 3ISP:7 %isp, $null) $iif(%org != NA, 14(Organization14) %org, $null)) $iif(%type != NA, 14(Type14) %type, $null) $iif(%assign != NA, 14(Assignment14) %assign, $null)
  }
  if (*h2 id="Geolocation-Information* iswm %read) {
    set %geost 1
  }
  if (*Continent:* iswm %read) {
    set %continent $gettok($gettok(%read,$calc($findtok(%read,Continent:</th,1,62) + 2),62),1,60)
  }
  if (*Country:* iswm %read) {
    set %country $gettok($gettok(%read,$calc($findtok(%read,Country:</th,1,62) + 2),62),1,60)
  }
  if (*State/Region* iswm %read) {
    set %streg $gettok($gettok(%read,$calc($findtok(%read,State/Region:</th,1,62) + 2),62),1,60)
  }
  if (*City* iswm %read) {
    set %city $gettok($gettok(%read,$calc($findtok(%read,City:</th,1,62) + 2),62),1,60)
  }
  if (*Latitude* iswm %read) {
    set %findlat 1
    ;set %latitude $remove($gettok($gettok(%read,$calc($findtok(%read,Latitude:</th,1,62) + 2),62),1,60),&bnsp,&prime)
  }
  if (%findlat) && (*Latitude* !iswm %read) {
    unset %findlat
    set %latitude $gettok(%read,1,38)
  }
  if (*Longitude* iswm %read) {
    set %findlong 1
  }
  if (%findlong) && (*Longitude* !iswm %read) {
    unset %findlong
    set %longitude $gettok(%read,1,38)
  }
  if (*Postal* iswm %read) {
    set %PostalCode $gettok($gettok(%read,$calc($findtok(%read,Postal Code:</th,1,62) + 2),62),1,60)
  }
  if (*/table* iswm %read) && (%geost) {
    unset %geost
    msg %ipchan $iif(%continent,14(Continent14) %continent, $null) $iif(%country, 14(Country14) %country, $null) $iif(%streg, 14(State/Region14) %streg, $nulll) $iif(%city, 14(City14) %city, $null) $iif(%latitude, 14(Latitude14) %latitude, $null) $iif(%longitude, 14(Longitude14) %longitude, $null) $iif(%postalcode, 14(Postal Code14) %PostalCode, $null)
    sockclose $sockname
    unset %isp 
    unset %hostname
    unset %decimal
    unset %org
    unset %asn
    unset %assign
    unset %type
    unset %iplook
    unset %ipchan
    unset %continent 
    unset %country
    unset %streg
    unset %city
    unset %latitude
    unset %lognitude
    unset %postalcode
  }
}

alias iplookup {
  set %ipchan $2
  set %iplook $+(/ip/,$1)
  msg $2 Looking Up IP: $1
  sockopen iplook whatismyipaddress.com 80
}

on *:TEXT:*:#: {
  if ($1 == !digip) {
    if ($remove($strip($2),.) isnum) {
      iplookup $strip($2) $chan
    }
    if ($remove($strip($2),.) !isnum) {
      set %ipchan $chan
      .dns -h $strip($2)
    }
  }
}

on *:DNS: {
  iplookup $raddress %ipchan
}
