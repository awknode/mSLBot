alias -l IgnoreYoutubeLinks return 1
;Change this to change the logo
alias -l GetLinkInfoLogo return .12Twitter.
;Change this to change the text color
alias -l GetLinkInfoTextColor return 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;End Setup;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
menu Channel,Status {
  .$iif($group(#GetLinkInfo) == On,$style(1)) GetLinkInfo
  ..$iif($group(#GetLinkInfo) == On,$style(2)) On: .enable #GetLinkInfo
  ..$iif($group(#GetLinkInfo) == Off,$style(2)) Off: .disable #GetLinkInfo
}
#GetLinkInfo on
On $*:Text:/(^[+-]linxxxx|(https?|www\.)(www\.)?[\S]*)/Si:#: {
  var %action $strip($regml(1))
  if ($regex(action,%action,^[+-])) && ($regex($nick($chan,$nick).pnick,/(!|~|&|@)/)) {
    if (+* iswm %action) {
      if ($istok(%linkinfoChanList,$+($network,$chan),32)) { .msg $chan $nick script is already running }
      else { 
        .enable #GetLinkInfo
        Set %linkinfoChanList $addtok(%linkinfoChanList,$+($network,$chan),32)
        .msg $chan title script activated.
      }
    }
    else {
      if (!$istok(%linkinfoChanList,$+($network,$chan),32)) { .msg $chan $nick not currently running the script }
      else { 
        Set %linkinfoChanList $remtok(%linkinfoChanList,$+($network,$chan),1,32)
        .msg $chan title script deactivated. 
      }
    }
  }
  elseif (!$timer($+(linkinfo,$network,$chan))) && ($istok(%linkinfoChanList,$+($network,$chan),32)) {
    .timer $+ $+(linkinfo,$network,$chan) 1 1 noop
    var %method msg #
    if (!$IgnoreYoutubeLinks && $regex(%action,/(?:^https?:\/\/|www\.)(?:[\S]*twitter\.com)/i)) {
      return
    }
    else {
      Getlinkinfo %method $gettok(%action,2-,47)
    }
  }
}
#GetLinkInfo end
alias linkinfo { Getlinkinfo echo -a $1- }
alias -l Getlinkinfo {
  var %sockname $+(LinkInfo,$network,$2,$ticks)
  sockopen %sockname www.getlinkinfo.com 80
  svar %sockname method $1-2
  svar %sockname url $+(/info?link=,$urlencode($+(http://,$3)))
}
On *:sockopen:LinkInfo*: {
  if (!$sockerr) {
    sockwrite -nt $sockname GET $svar($sockname,url) HTTP/1.1
    sockwrite -n $sockname Host: $sock($sockname).addr
    sockwrite -n $sockname $crlf
  }
  else { echo -st Socket Error $nopath($script) | sockclose $sockname | return }
}
On *:sockread:LinkInfo*: {
  if ($sockerr) { echo -st Socket Error $nopath($script) | sockclose $sockname | return }
  else {
    var %LinkInfo | sockread %LinkInfo
    if ($regex(%LinkInfo,/<dd><b>(.*?)<\/b><\/dd>/i)) {
      $svar($sockname,method) $GetLinkInfoLogo $+($GetLinkInfoTextColor,$Xchr($Xchr($regml(1))))
      sockclose $sockname
      return
    }
  }
}
alias  Xchr { 
  var %return $regsubex($regsubex($1-,/&#x([A-F0-9]{1,2});/g,$chr($base($regml(\n),16,10))),/&#([0-9]{2,4});/g,$utf8(\1)) 
  return $xXchr($replacecs(%return,&ndash;,$utf8(8211),&mdash;,$utf8(8212),&iexcl;,$utf8(161),&middot;,·,&raquo;,»,&laquo;,«,&Uuml;,Ü,$&
    &uuml;,ü,&Aacute;,Á,&aacute;,á,&Eacute;,É,&iquest;,$utf8(191),&ldquo;,$utf8(8220),&rdquo;,$utf8(8221),&apos;,',$&
    &lsquo;,$utf8(8216),&rsquo;,$utf8(8217),&cent;,$utf8(162),&copy;,$utf8(169),&divide;,$utf8(247),&micro;,$utf8(181),$&
    &para;,$utf8(182),&plusmn;,±,&euro;,$utf8(8364),&pound;,£,&reg;,$utf8(174),&sect;,$utf8(167),&trade;,$utf8(153),$&
    &yen;,$utf8(165),&curren;,$utf8(164),&brvbar;,$utf8(166),&sect;,$utf8(167),&uml;,$utf8(168),&ordf;,$utf8(170),$&
    &not;,$utf8(172),&shy;,$utf8(173),&macr;,$utf8(175),&deg;,$utf8(176),&sup2;,$utf8(178),&sup3;,$utf8(179),$&
    &acute;,´,&ccedil;,$utf8(184),&sup1;,$utf8(185),&ordm;,$utf8(186),&frac14;,$utf8(188),&frac12;,$utf8(189),$&
    &frac34;,$utf8(190),&Agrave;,$utf8(192),&Acirc;,$utf8(194),&Atilde;,$utf8(195),&Auml;,$utf8(196),&Aring;,$utf8(197),$&
    &AElig;,$utf8(198),&Ccedil;,$utf8(199),&Egrave;,$utf8(200),&Ecirc;,$utf8(202),&Euml;,$utf8(203),&Igrave;,$utf8(204),&Icirc;,$utf8(206),$&
    &Iuml;,$utf8(207),&ETH;,$utf8(208),&Ograve;,$utf8(210),&Ocirc;,$utf8(212),&Otilde;,$utf8(213),&Ouml;,$utf8(214),&times;,$utf8(215),$&
    &Oslash;,$utf8(216),&Ugrave;,$utf8(217),&Ucirc;,$utf8(219),&Yacute;,$utf8(221),&THORN;,$utf8(222),&szlig;,$utf8(223),&agrave;,$utf8(224),$&
    &acirc;,$utf8(226),&atilde;,$utf8(227),&auml;,$utf8(228),&aring;,$utf8(229),&ccedil;,$utf8(231),&egrave;,$utf8(232),&ecirc;,$utf8(234),&euml;,$utf8(235),$&
    &igrave;,$utf8(236),&icirc;,$utf8(238),&iuml;,$utf8(239),&eth;,$utf8(240),&ograve;,$utf8(242),&ocirc;,$utf8(244),&otilde;,$utf8(245),&ouml;,$utf8(246),$&
    &divide;,$utf8(247),&oslash;,$utf8(248),&ugrave;,$utf8(249),&ucirc;,$utf8(251),&yacute;,$utf8(253),&thorn;,$utf8(254),&yuml;,$utf8(255),&ang;,$utf8(8736),$&
    &and;,$utf8(8743),&fnof;,$utf8(402),&Alpha;,$utf8(913),&Beta;,$utf8(914),&Gamma;,$utf8(915),&Delta;,$utf8(916),&Epsilon;,$utf8(917),&Zeta;,$utf8(918),$&
    &Eta;,$utf8(919),&Theta;,$utf8(920),&Iota;,$utf8(921),&Kappa;,$utf8(922),&Lambda;,$utf8(923),&Mu;,$utf8(924),&Nu;,$utf8(925),&Xi;,$utf8(926),$&
    &Omicron;,$utf8(927),&Pi;,$utf8(928),&Rho;,$utf8(929),&Sigma;,$utf8(931),&Tau;,$utf8(932),&Upsilon;,$utf8(933),&Phi;,$utf8(934),&Chi;,$utf8(935),$&
    &Psi;,$utf8(936),&Omega;,$utf8(937),&alpha;,$utf8(945),&beta;,$utf8(946),&gamma;,$utf8(947),&delta;,$utf8(948),&epsilon;,$utf8(949),&zeta;,$utf8(950)))
}
alias -l xXchr {
  return $replacecs($1-,&eta;,$utf8(951),&theta;,$utf8(952),&iota;,$utf8(953),&kappa;,$utf8(954),&lambda;,$utf8(955),&mu;,$utf8(956),$&
    &nu;,$utf8(957),&xi;,$utf8(958),&omicron;,$utf8(959),&pi;,$utf8(960),&rho;,$utf8(961),&sigmaf;,$utf8(962),$&
    &sigma;,$utf8(963),&tau;,$utf8(964),&upsilon;,$utf8(965),&phi;,$utf8(966),&chi;,$utf8(967),&psi;,$utf8(968),$&
    &omega;,$utf8(969),&thetasym;,$utf8(977),&upsih;,$utf8(978),&piv;,$utf8(982),&bull;,$utf8(8226),&hellip;,$utf8(8230),$&
    &prime;,$utf8(8242),&Prime;,$utf8(8243),&oline;,$utf8(8254),&frasl;,$utf8(8260),&weierp;,$utf8(8472),$&
    &image;,$utf8(8465),&real;,$utf8(8476),&trade;,$utf8(8482),&alefsym;,$utf8(8501),&larr;,$utf8(8592),$&
    &uarr;,$utf8(8593),&rarr;,$utf8(8594),&darr;,$utf8(8595),&harr;,$utf8(8596),&crarr;,$utf8(8629),&lArr;,$utf8(8656),$&
    &uArr;,$utf8(8657),&rArr;,$utf8(8658),&dArr;,$utf8(8659),&hArr;,$utf8(8660),&forall;,$utf8(8704),&part;,$utf8(8706),$&
    &exist;,$utf8(8707),&empty;,$utf8(8709),&nabla;,$utf8(8711),&isin;,$utf8(8712),&notin;,$utf8(8713),&ni;,$utf8(8715),$&
    &prod;,$utf8(8719),&sum;,$utf8(8721),&minus;,$utf8(8722),&lowast;,$utf8(8727),&radic;,$utf8(8730),&prop;,$utf8(8733),$&
    &infin;,$utf8(8734),&or;,$utf8(8744),&cap;,$utf8(8745),&cup;,$utf8(8746),&int;,$utf8(8747),&there4;,$utf8(8756),$&
    &sim;,$utf8(8764),&cong;,$utf8(8773),&asymp;,$utf8(8776),&ne;,$utf8(8800),&equiv;,$utf8(8801),&le;,$utf8(8804),$&
    &ge;,$utf8(8805),&sub;,$utf8(8834),&sup;,$utf8(8835),&nsub;,$utf8(8836),&sube;,$utf8(8838),&supe;,$utf8(8839),$&
    &oplus;,$utf8(8853),&otimes;,$utf8(8855),&perp;,$utf8(8869),&sdot;,$utf8(8901),&lceil;,$utf8(8968),&rceil;,$utf8(8969),$&
    &lfloor;,$utf8(8970),&rfloor;,$utf8(8971),&lang;,$utf8(9001),&rang;,$utf8(9002),&loz;,$utf8(9674),&spades;,$utf8(9824),$&
    &clubs;,$utf8(9827),&hearts;,$utf8(9829),&diams;,$utf8(9830),&eacute;,é,&Iacute;,Í,&iacute;,í,&Oacute;,Ó,&oacute;,ó,$&
    &Ntilde;,Ñ,&ntilde;,ñ,&Uacute;,Ú,&uacute;,ú,&nbsp;,$chr(32),&aelig;,æ,&quot;,",&lt;,<,&gt;,>, &amp;,&,&quot;,")
}
alias -l urlencode { 
  return $regsubex($replace($1-,$chr(32),$+(%,2d),$+(%,20),$+(%,2d)),/([^a-z0-9])/ig,% $+ $base($asc(\t),10,16,2))
}
alias -l Svar {
  var %sockname $1, %item $+($2,$1)
  if ($isid) {
    if ($regex(svar,$sock(%sockname).mark,/ $+ %item $+ \x01([^\x01]*)/i)) return $regml(svar,1)
  }
  elseif ($3)  {
    var %value $3-
    if (!$regex(svar,$sock(%sockname).mark,/ $+ %item $+ \x01/i)) { sockmark %sockname $+($sock(%sockname).mark,$chr(1),%item,$UTF8(1),%value) }
    else { sockmark %sockname $regsubex(svar,$sock(%sockname).mark,/( $+ %item $+ \x01[^\x01]*)/i,$+(%item,$chr(1),%value)) }
  }
}
alias -l UTF8 {
  if ($version >= 7) return $chr($1)
  elseif ($1 < 255) { return $chr($1) }
  elseif ($1 >= 256) && ($1 < 2048) { return $+($chr($calc(192 + $div($1,64))),$chr($calc(128 + $mod($1,64)))) }
  elseif ($1 >= 2048) && ($1 < 65536) { return $+($chr($calc(224 + $div($1,4096))),$chr($calc(128 + $mod($div($1,64),64))),$chr($calc(128 + $mod($1,64)))) }
  elseif ($1 >= 65536) && ($1 < 2097152) {
    return $+($chr($calc(240 + $div($1,262144))),$chr($calc(128 + $mod($div($1,4096),64))),$chr($calc(128 + $mod($div($1,64),64))),$&
      $chr($calc(128 + $mod($1,64))))
  }
}
alias -l div { return $int($calc($1 / $2)) }
alias -l mod {
  var %int $int($calc($1 / $2))
  return $calc($1 - (%int * $2))
}
alias -l H2U { return $utf8($base($1,16,10)) }
