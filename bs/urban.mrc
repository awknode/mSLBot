;Urban Dictionary Script by Ford_Lawnmower irc.GeekShed.net #Script-Help
menu Channel,Status {
  .$iif($group(#Slang) == On,$style(1)) Slang Trigger
  ..$iif($group(#Slang) == On,$style(2)) On: .enable #Slang
  ..$iif($group(#Slang) == Off,$style(2)) Off: .disable #Slang
  ..Add Badwords: {
    if (!$hget(censored)) { hmake censored 5 }
    $?="Enter the badword" 
    if ($!) {
      if (!$hfind(censored,$!).data) { 
        hadd  censored $calc($hget(censored,0).item + 1) $!
        echo -a $! added to badword list 
      }
      else { echo -a $! is already in my database. }
    }
  }
  ..Delete Badwords: {
    $?="Enter the bad word or the item number!"
    if ($!) {
      if ($! isnum) && ($hget(censored,$!)) {
        echo -a $hget(censored,$!) was deleted!
        hdel  censored $!
        halt
      } 
      if ($! isalpha) && ($hfind(censored,$!).data) {
        echo -a $! has been deleted from my database!
        hdel censored $hfind(censored,$!).data
      } 
      else { echo -a Can't find $! in my database. Try checking the list. }
    }
  }
  ..List Badwords:censored.list
}
#Slang on
On $*:Text:/^(\+|-|!|@)(Slang|ud).*/Si:#: {
  var %action $regml(1)
  if (%action isin +-) && ($regex($nick($chan,$nick).pnick,/(!|~|&|@)/)) {
    if (%action == +) {
      if ($istok(%SlangChanList,$+($network,$chan),32)) { .msg $chan $nick $chan is already running the Slang script }
      else { 
        .enable #Slang
        Set %SlangChanList $addtok(%SlangChanList,$+($network,$chan),32)
        .msg $chan $nick has activated the Slang script for $chan .
      }
    }
    else {
      if (!$istok(%SlangChanList,$+($network,$chan),32)) { .msg $chan $nick $chan is not running the Slang script }
      else { 
        Set %SlangChanList $remtok(%SlangChanList,$+($network,$chan),1,32)
        .msg $chan $nick has deactivated the Slang script for $chan . 
      }
    }
  }
  elseif (!$timer($+(Slang,$network,$nick))) && ($istok(%SlangChanList,$+($network,$chan),32)) {
    .timer $+ $+(Slang,$network,$nick) 1 6 noop
    var %method $iif(%action == !,.notice $nick,$iif($regex($nick($chan,$nick).pnick,/(!|~|&|@|%|\+)/),.msg $chan,.notice $nick))
    GetSlang %method $2-
  }
}
#Slang end
alias slang { GetSlang echo -a $1- }
alias -l GetSlang {
  var %sockname $+(SlangUD,$network,$2,$ticks)
  var %SlangUD.url $iif($3,$replace($+(/define.php?page=,$iif($ceil($calc($3 / 7)),$v1,1),&term=,$iif($3 !isnum,$3-,$4-)),$chr(32),+),/random.php)
  sockopen %sockname www.urbandictionary.com 80
  ;sockmark %sockname $1-2 %SlangUD.url $iif($3 isnum,$iif($calc($3 % 7),$v1,7),1) 0 0
  svar %sockname method $1-2
  svar %sockname url %SlangUD.url
  svar %sockname num $iif($3 isnum, $3, 1)
}
On *:sockopen:SlangUD*: {
  if (!$sockerr) {
    sockwrite -nt $sockname GET $svar($sockname,url) HTTP/1.1
    sockwrite -n $sockname Host: www.urbandictionary.com
    sockwrite -n $sockname $crlf
  }
  else { echo -st Socket Error $nopath($script) | sockclose $sockname | return }
}
On *:sockread:SlangUD*: {
  if ($sockerr) { echo -st Socket Error $nopath($script) | sockclose $sockname | return }
  else {
    var %SlangUD | sockread %SlangUD
    if (Location: http://www.urbandictionary.com/define.php?term isin %SlangUD) {
      GetSlang $svar($sockname,method) 1 $gettok(%SlangUD,-1,61)
      sockclose $sockname
      return
    }
    elseif (<div id='not_defined_yet'> isin %SlangUD) { $svar($sockname,method) Sorry that word has yet to be defined. }
    elseif ($regex(%SlangUD,/ribbon ribbon-without-header/)) { 
      svar $sockname div small
    }  
    elseif (($svar($sockname,div) == small) && ($regex(%SlangUD,/(^\d+)\.?/))) {
      svar $sockname itemnum $regml(1)
      svar $sockname div noop
    }
    elseif ($regex(%SlangUD,/<title>Urban\sDictionary:\s(.*?)<\/title>/i)) { 
      $svar($sockname,method) 06Word -04 $censored($httpstrip($regml(1)))
    }
    elseif ($svar($sockname,num) == $svar($sockname,itemnum)) {
      if ($regex(%SlangUD,/<div\sclass=['"]([^>]*)['"]>/i)) { 
        svar $sockname div $regml(1)
      } 
      if ($svar($sockname,div) == meaning) { 
        var %definition $svar($sockname,definition)
        svar $sockname definition $+($iif($+($svar($sockname,definition),$chr(32)),$v1),%SlangUD)
        if (</div> isin %SlangUD) {
          put $svar($sockname,method) 06Definition -04 $censored($replace($httpstrip($svar($sockname,definition)),$chr(13),$chr(32))) 
          svar $sockname div noop
        }
      }
      if ($svar($sockname,div) == example) { 
        svar $sockname example $+($svar($sockname,example),$chr(32),%SlangUD)
        if (</div> isin %SlangUD) {
          put $svar($sockname,method) 06Example -04 $censored($replace($httpstrip($svar($sockname,example)),$chr(13),$chr(32))) 
          svar $sockname div noop
        }
      } 
      if ($svar($sockname,div) == contributor) { 
        svar $sockname contributor $+($svar($sockname,contributor),$chr(32),%SlangUD)
        if (</div> isin %SlangUD) {
          put $svar($sockname,method) 06Author -04 $censored($replace($httpstrip($svar($sockname,contributor)),$chr(13),$chr(32))) - $+(07,http://www.urbandictionary.com,$svar($sockname,url)))
          sockclose $sockname
          return
        }
      }
    }
  }
}
alias -l httpstrip { var %x, %i = $regsub($1-,/(^[^<]*>|<[^>]*>|<[^>]*$)/g,$null,%x) | return $remove($replace(%x,&amp;,&,&quot;,",&gt;,>,&lt;,<),&nbsp;,&lt;) }
alias -l Put {
  if (!$regex($1,/(\.|^)(msg|notice|echo)$/Si)) || (!$3) { echo -st **Put error** Syntax /Put msg #channel text - or - /Put notice nickname text  | return }
  tokenize 32 $fix&#($regsubex($1-,/([$\|%\[\]\}\{][^\s]*)/g,$+($chr(2),$chr(2),\t)))
  var %tokens $0, %Tstart 3, %Dtimer 1500
  if ($timer($+(Put,$2,$network)).secs) { %Dtimer = $calc($v1 * 1000) }  
  while ($len($($+($,%Tstart,-,%tokens),2)) > 430) {
    dec %tokens
    if ($len($($+($,%Tstart,-,%tokens),2)) <= 430) {
      .timer -m 1 %Dtimer $1-2 $+(04,$($+($,%Tstart,-,%tokens),2)))
      inc %Dtimer 1500
      %Tstart = $calc(%tokens + 1)
      %tokens = $0
    }
  }
  .timer -m 1 %Dtimer $1-2 $+(04,$($+($,%Tstart,-,%tokens),2)))
  .timer $+ $+(Put,$2,$network) -m 1 $calc(%Dtimer + 1500) noop 
}
alias  censored {
  if (!$hget(censored)) { hmake censored 5 }
  var %censored.string = $1-, %censored.words = $gettok($1-,0,32)
  while %censored.words {
    if ($hfind(censored,$left($gettok(%censored.string,%censored.words,32),4) $+ *,1,w).data) || ($hfind(censored,$gettok(%censored.text,%censored.word,32)).data) {
      %censored.string = $replace(%censored.string,$gettok(%censored.string,%censored.words,32),!@#&)
    }
    dec %censored.words
  }
  return %censored.string
}
alias censored.list {
  var %censored.counter = $hget(censored,0).item
  while %censored.counter {
    echo -a $hget(censored,%censored.counter).item $hget(censored,%censored.counter).data
    dec %censored.counter
  }
}
alias -l fix&# { 
  return $regsubex($regsubex($replace($regsubex($1-,/\&\#([0-9]{1,});/g,$utf8(\t)),&quot;,",&amp;,&,&gt;,>,&lt;,<,&#39;,',$chr(9),$chr(32)),$&
    /([$\|%\[\]\}\{][^\s]*)/g,$+($chr(2),$chr(2),\t)),/\&\#x([0-9a-f]{1,});/gi,$H2U(\t))
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
alias -l Svar {
  var %sockname $1, %item $+($2,$1)
  if ($isid) {
    if ($regex(svar,$sock(%sockname).mark,/ $+ %item $+ \x01([^\x01]*)/i)) return $regml(svar,1)
  }
  elseif ($3)  {
    var %value $3-
    if (!$regex(svar,$sock(%sockname).mark,/ $+ %item $+ \x01/i)) { sockmark %sockname $+($sock(%sockname).mark,$chr(1),%item,$chr(1),%value) }
    else { sockmark %sockname $regsubex(svar,$sock(%sockname).mark,/( $+ %item $+ \x01[^\x01]*)/i,$+(%item,$chr(1),%value)) }
  }
}
On *:Unload: { hfree censored }
On *:Start: {
  unset %UDChanList
  if (!$hget(censored)) { hmake censored 5 }
  if ($isfile(censored.hsh)) { hload censored censored.hsh }
}
On *:Exit: { if ($hget(censored)) { hsave censored censored.hsh } }
On *:Disconnect: { if ($hget(censored)) { hsave censored censored.hsh } }
