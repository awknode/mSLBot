;BOF

;~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*;
;          Urban Dictionary Word Searcher        ;
;            Made by Kirby (Quakenet)            ;
;*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~;

;~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*;
;Urban Dictionary Aliases/Identifiers;
;~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*;
alias -l addmark { return $+($sock($1).mark,$chr($3),$2) }
alias -l bet { var %x $calc($pos($1,$2,$3) + $len($2)), %y $calc($pos($1,$4,$5) - %x) | return $mid($1,%x,%y) }
alias -l htmlfree { var %x, %i = $regsub($1-,/(^[^<]*>|<[^>]*>|<[^>]*$)/g,$null,%x), %x = $remove(%x,&nbsp;) | return $replace(%x,&quot;,",&lt;,<,&gt;,>,$cr,$chr(32),$lf,$chr(32),&amp;,&) }
alias -l lt { var %l $1, %t $2- | tokenize 124 $sock(urban).mark | while ($len(%t) > %l) { smsg $1 $left(%t,%l) | var %t $remove(%t,$left(%t,%l)) } | if (%t) smsg $1 %t }
alias -l ltz { var %l $1, %t $2- | tokenize 124 $sock(wod).mark | while ($len(%t) > %l) { smsg $1 $left(%t,%l) | var %t $remove(%t,$left(%t,%l)) } | if (%t) smsg $1 %t }
alias -l smsg { msg $iif(c isincs $chan($1).mode,$1 $strip($2-),$1-) }

menu * {
  Urban Dictionary
  .$iif($group(#UrbanDictionary) == On,$style(1)) Urban Dictionary
  ..$iif($group(#UrbanDictionary) == On,$style(2)) On: .enable #UrbanDictionary
  ..$iif($group(#UrbanDictionary) == Off,$style(2)) Off: .disable #UrbanDictionary
  .$iif($group(#WordOfDay) == On,$style(1)) Word of the Day
  ..$iif($group(#WordOfDay) == On,$style(2)) On: .enable #WordOfDay
  ..$iif($group(#WordOfDay) == Off,$style(2)) Off: .disable #WordOfDay
  .$iif($group(#Ud) == On,$style(1)) UD Information
  ..$iif($group(#Ud) == On,$style(2)) On: .enable #Ud
  ..$iif($group(#Ud) == Off,$style(2)) Off: .disable #Ud
}

;~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*;
;Search a word - Syntax: .ud[#] <word(s)>;
;~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*;
#UrbanDictionary on
on $*:text:/^[!%.@]ud(\s|$)/Si:#: { if (!$2-) { msg $chan [Urban Dictionary] Syntax: .ud[#] <word(s)>. } | elseif ($2-) { $iif($istok(%urbandictionary,#,32),halt,set -u1 %urbandictionary $addtok(%urbandictionary,#,32)) | if ($sock(urban)) { sockclose urban } | sockopen urban www.urbandictionary.com 80 | sockmark urban $+(#,$chr(124),$iif($remove($1,.ud) isnum 1-,$remove($1,.ud),1),$chr(124),$2-) }  }
on *:sockopen:urban: { tokenize 124 $sock(urban).mark | sockwrite -n $sockname GET $+(/define.php?page=,$ceil($calc($2 / 7)),&term=,$replace($3,$chr(32),$chr(43))) HTTP/1.0 | sockwrite -n $sockname Host: www.urbandictionary.com $+ $crlf $+ $crlf }
on *:sockread:urban: {
  tokenize 124 $sock(urban).mark
  if ($sockerr) { msg $1 * There was a problem retrieving data from the website. Please try again. }
  elseif (!$sockerr) {
    var %ud $2 | sockread %urban
    if ($regex(%urban,content=['|"](.*) - (.*) definitio(n|ns))) { sockmark urban $addmark(urban,$regml(2),124) }
    while (%ud > 7) { var $v1 $calc($v1 - 7) }
    if (<div class='meaning'> isin %urban) { inc %ud.def | if (%ud.def == $2) { sockread $htmlfree(%ud.definition) | inc %udc } }
    elseif (<div class='example'> isin %urban) { inc %ud.ex | if (%ud.ex == $2) { sockread $htmlfree(%ud.example) | inc %udc } }
    elseif (<span class='date'> isin %urban) { inc %ud.date | if (%ud.date == $2) { sockread %ud.date | sockmark urban $addmark(urban,%ud.date,124) } }
    elseif (by Anonymous isin %urban) { inc %ud.author | if (%ud.author == $2) { sockmark urban $addmark(urban,Anonymous,124) | haltdef } }
    elseif ($regex(%urban,"Contributor">(.*)</a>)) { inc %ud.author | if (%ud.author == $2) { sockmark urban $addmark(urban,$regml(1),124) | haltdef } }
    elseif (<div id='not_defined_yet'> isin %urban) { smsg $1 [Urban Dictionary] ~ Error: It appears that these niggers havent defined $qt($+(,$3,)) yet. Click: $+(,http://www.urbandictionary.com/add.php?word=,$replace($3,$chr(32),$chr(43)),) | sockclose urban | unset %ud* %urban | halt }
  }
}
on *:sockclose:urban: {
  tokenize 124 $sock(urban).mark | var %x 14(Urban Dictionary14) $+(,$3,,:) $+($chr(91),12,$2,,$4,,$chr(93)) $remove($iif($htmlfree(%ud.definition),$v1,),&#39;,&#39;) $remove($+($chr(40),$iif($htmlfree(%ud.example),$v1,These niggers haven't defined anything like that yet.),$chr(41)),&#39;,&#39;) %y 
  if (%udc != 2) { lt 425 %x | unset %urban %ud* | halt }
  elseif (%udc == 2) { lt 425 %x | unset %urban %ud* | halt }
  smsg $1 %y - (15 seconds until next definition) | unset %ud* %urban
}
#UrbanDictionary End

;~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~;
;Word of the Day (every week) - Syntax: .wod [1-7];
;~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~;
#WordOfDay On
on $*:text:/^[.!@]wod(\s|$)/Si:#: { $iif($istok(%wordofday,#,32),halt,set -u1 %wordofday $addtok(%wordofday,#,32)) | if (!$2) { sockopen wod www.urbandictionary.com 80 | sockmark wod $+(#,$chr(124),1) } | elseif ($2 isnum 1-7) { sockopen wod www.urbandictionary.com 80 | sockmark wod $+(#,$chr(124),$2) } | else { .notice $nick [Word of Day] Syntax: .wod [1~7]>. } }
on *:sockopen:wod: { sockwrite -n $sockname GET / HTTP/1.0 | sockwrite -n $sockname Host: www.urbandictionary.com $+ $crlf $+ $crlf }
on *:sockread:wod: {
  sockread %wod | tokenize 124 $sock(wod).mark
  if (<div class='word'> isin %wod) { inc %wodw | if (%wodw == $2) { sockread %wod | sockmark wod $addmark(wod,$htmlfree(%wod),124) } }
  elseif (<div class='meaning'> isin %wod) { inc %wodd | if (%wodd == $2) { sockread %wod | set %wod.def $htmlfree(%wod) | inc %wod.def } }
  elseif (<div class='example'> isin %wod) { inc %wode | if (%wode == $2) { sockread %wod | set %wod.ex $htmlfree(%wod) } }
  elseif (<div class='smallcaps'> isin %wod) { inc %wods | if (%wods == $2) { sockread %wod | sockmark wod $addmark(wod,$left($gettok($htmlfree(%wod),1,32),3) $+($gettok($htmlfree(%wod),2,32),$chr(44)) $iif($date(m) == 1,$iif($date(d) <= 7,$+(0,$calc($date(yyyy) - 1))),$date(yyyy)),124) } }
  elseif ($regex(%wod,"Contributor">(.*)</a>)) { inc %woda | if (%woda == $2) { sockmark wod $addmark(wod,$regml(1),124) } }
}
on *:sockclose:wod: { tokenize 124 $sock(wod).mark | ltz 425 [Word of Day $+(12,$2,,]) $3 %wod.def $+($chr(40),%wod.ex,$chr(41)) | unset %wod* }
#WordOfDay End

;~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~;
;What is Urban Dictionary? - Syntax: ?? ud;
;~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~;
#Ud On
on *:text:/^(\?\?) (ur(b|a|n)|ud|def(i|n|e))/Si:#: { sockopen total www.urbandictionary.com 80 | sockmark total # }
on *:sockopen:total: { sockwrite -n $sockname GET / HTTP/1.0 | sockwrite -n $sockname Host: www.urbandictionary.com $+ $crlf $+ $crlf }
on *:sockread:total: { sockread %total | if (<div class='count'> isin %total) { sockread %total | tokenize 32 $sock(total).mark | smsg $1 Urban Dictionary is the slang dictionary you wrote. Define your world. ~ $+(04,%total definitions written since 1999.) } }
#Ud End
;EOF
