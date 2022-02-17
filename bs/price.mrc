on *:start:{
  hmake -s NickC 10000
  hload -s NickC NickC\NickC.db
}

alias percentchg return $calc(($getNickCprice($1) - $getNickCprevprice($1)) / $abs($getNickCprevprice($1)))

alias getNickCprice return $hget(NickC,$+($1,.currentprice))
alias getNickCprevprice return $hget(NickC,$+($1,.prevprice))


alias putNickC {

  hadd -u3600 NickC $+($1,.pctchange) $calc($hget(NickC,$+($1,.pctchange)) + $percentchg($1))
  hadd -u86400 NickC $+($1,.pctchangeday) $calc($hget(NickC,$+($1,.pctchangeday)) + $hget(NickC,$+($1,.pctchange)))

  hadd NickC $+($1,.lastupdate) $ctime
  hadd NickC $+($1,.prevprice) $getNickCprice($1)
  hadd NickC $+($1,.currentprice) $calc($getNickCprice($1) + $2)

  if ($chan != $null) { hadd NickC $+($1,.lastchannel) $chan }

  hadd NickC $+($1,.lastchange) $2
  hadd -u3600 NickC $+($1,.change) $calc($hget(NickC,$+($1,.change)) + $2)

  set %lastcnick $1
}

on *:text:*:#:{
  if (.market == $1) || ((market == $2 ) && (*party iswm $chan ) && ($3 isin $putnickC)) {
    if (!$2) {
      msg $chan Usage: .market <nick/etc> shows the price of <nick/etc> if it's being evaluated/monitored. / .market -top shows the top10 / .market -last shows the last changed price. | halt
    }

    if ($regex($2,/(8D|8=D|8=+=D|dick|cock|schlong|johnson|weiner|penis|richard|sword)/Si)) { set %nickthing cocks | goto checkprice }

    else {
      if (-top == $2) {

        window -h @.
        window -h @tu
        window -h @td
        var %i = 1
        while (%i <= $hget(NickC,0).item) {
          if (.currentprice isin $hget(NickC,%i).item) {
            aline @. $+($hget(NickC,%i).data,_,,$remove($hget(NickC,%i).item,.currentprice),)
          }
          inc %i
        }
        filter -cetuww 2 32 @. @tu
        filter -ctuww 2 32 @. @td
        var %i = 1
        while (%i <= 10) {

          set %toppricesup %toppricesup - $iif($hget(NickC,$+($strip($gettok($line(@tu,%i),2,95)),.lastchange)) < 0,4↓,9↑) $+ $gettok($line(@tu,%i),2,95) $+ : $money($gettok($line(@tu,%i),1,95))
          set %toppricesdown %toppricesdown - $iif($hget(NickC,$+($strip($gettok($line(@td,%i),2,95)),.lastchange)) < 0,4↓,9↑) $+ $gettok($line(@td,%i),2,95) $+ : $money($gettok($line(@td,%i),1,95))

          inc %i
        }
        msg $chan Top prices: $mid($nohilite(%toppricesup),2,$len($nohilite(%toppricesup)))
        msg $chan Down prices: $mid($nohilite(%toppricesdown),2,$len($nohilite(%toppricesdown)))


        unset %topprices*
        window -c @.
        window -c @tu
        window -c @td
      }
      else if ($getNickCprice($2) != $null) {

        set %nickthing $2
        :checkprice
        set %pctchange $round($hget(NickC,$+(%nickthing,.pctchange)),2)
        set %pctchangeday $round($hget(NickC,$+(%nickthing,.pctchangeday)),2)
        set %change $hget(NickC,$+(%nickthing,.change))

        $iif($hget(NickC,$+(%nickthing,.pctchangeday)) == $null,set %pctchangeday 0)
        $iif($hget(NickC,$+(%nickthing,.pctchange)) == $null,set %pctchange 0)
        $iif($hget(NickC,$+(%nickthing,.change)) == $null,set %change 0)

        $iif($hget(NickC,$+(%nickthing,.lastchange)) < 0,set %thepoop 4💩,set %thepoop 9🔥)
        $iif($hget(NickC,$+(%nickthing,.lastchange)) == 0,set %thepoop 🚽)

        msg $chan  $+ %nickthing $+ : $money($getNickCprice(%nickthing)) ( $+ $+(%pctchange,%) %thepoop $money(%change) 1h) ( $+ $+(%pctchangeday,%) 24h) Last update: $duration($calc($ctime - $hget(NickC,$+(%nickthing,.lastupdate)))) ago in $hget(NickC,$+(%nickthing,.lastchannel)) $+ .
      }

      else if (-last == $2) {

        set %pctchangeday $round($hget(NickC,$+(%lastcnick,.pctchangeday)),2)
        set %pctchange $round($hget(NickC,$+(%lastcnick,.pctchange)),2)
        set %change $hget(NickC,$+(%lastcnick,.change))

        $iif($hget(NickC,$+(%lastcnick,.pctchangeday)) == $null,set %pctchangeday 0)
        $iif($hget(NickC,$+(%lastcnick,.pctchange)) == $null,set %pctchange 0)
        $iif($hget(NickC,$+(%lastcnick,.change)) == $null,set %change 0)

        $iif($hget(NickC,$+(%lastcnick,.lastchange)) < 0,set %thepoop 4💩,set %thepoop 9🔥)
        $iif($hget(NickC,$+(%lastcnick,.lastchange)) == 0,set %thepoop 🚽)

        msg $chan  $+ %lastcnick $+ : $money($getNickCprice(%lastcnick)) ( $+ $+(%pctchange,%) %thepoop $money(%change) 1h) ( $+ $+(%pctchangeday,%) 24h) Last update: $duration($calc($ctime - $hget(NickC,$+(%lastcnick,.lastupdate)))) ago in $hget(NickC,$+(%lastcnick,.lastchannel)) $+ .

      }
      else {
        msg $chan Error: I don't have any info on $2 $+ .
      }
    }
  }
  else {
    if ($regex($1-,/\b(khaled|regex|cards|raccoon|racoon|rebel|jaytea|defiler|mIRC|pharmer|entropy|Talon|Saturn|Ouims|maroon|SR3ject|bitcoin|trump|kkk|kyke|jew|1488|dad|mom|rofl|lol|lmao|lmfao|shitbreak|shitstain|fml|dick|fuck|god|pussy|cocksmoker|drydock|music|cuck|skank|whore|bitch|mop|pucciboi|fuccboi|thot)\b/gSi)) {
      var %i = $regml(0)
      while (%i) {
        putNickC $regml(%i) $calc(($len($1-) * 0.01) / $matchtok($1-, $regml(%i), 0, 32))
        dec %i
      }
    }
    if ($regex($strip($1),/<([^@>\s]+))) && ($network == ropchain) && ($chan == #party) {  
      putNickC $regml(1) $calc($len($1-) * 0.01) 
    }
    if ($regex($strip($1),/<.+@([^>\s]+))) && ($network == ropchain ) && ($chan == #party ) {
      putNickC $regml(1) $calc($len($1-) * 0.015)
    }
    if ($regex($nick,/(cards|raccoon|racoon|khaled|jaytea|rebel|defiler|pharmer|talon|entropy|maroon|SR3ject|SReject|Saturn|Ouims)/Si)) {
      putNickC $regml(1) $calc($len($1-) * 0.01) 
    }
    if ($regex($1-,/(cards|raccoon|racoon|khaled|rebel|jaytea|defiler|pharmer|entropy|Talon|maroon|SR3ject|SReject|Saturn|Ouims)/Si)) {
      putNickC $regml(1) $calc($len($1-) * 0.01)
    }
    if ($regex($1-,/(peoplewhosuck)/Si)) {
      putNickC $regml(1) $calc($len($1-) * -0.02)
    }
    ;;   if ($regex($1-,/(nigger|negro|kneegro|coon|nigga|niglet|black)/Si)) {
    ;;     putNickC niggers $calc($len($1-) * 0.02)
    ;;   }
    if ($regex($1-,/\b(hack|hackers|0day|root|exploit|hashkiller|crack|canaries|aslr|dep|bypass|vulnerability|vuln|rop|ret2libc|rootkit|malware|bruteforce|ddos|phishing|social\x20engineer|mitm|backdoor|blackhat|black\x20hat|bug|crypto|darkweb|deepweb|defcon|spinlock|encryption|RCE|Remote\x20Code\x20Execution|CVE|GCHQ|NSA|hacktivist|hashing|infosec|opsec|jailbreak|keylog|keylogger|formgrabber|fork\x20hook|man-in-the-middle|off-the-record|pgp|gpg|cleartext|plaintext|whitespace|whitespaces|owned|RAT|ransomware|rainbow\x20table|salted|skid|script\x20kiddies|shodan|signature|sniffing|scraping|spearphishing|spyware|TOR|kali|whonix|sqli|xss|dump|format\x20string\x20manipulation|virus|warez|whitehat|worm|zeroday|crib\x20dragging|bins|dox|swat|doxing|swatting|spoofing|trojan|greyhat|grey hat|botnet|cookie\x20stuffing|denial\x20of\x20service|easter\x20egg|firewall|payload|phreak|wardriving|ring|SE|linux|nix|unix|sql\x20injection|deface|cgi)\b/Si)) {
      putNickC hacking $calc($len($1-) * 0.02)
    }
    ;;   if ($regex($1-,/(main()|declaration|exit()|delimiter|)/Si)) {
    ;;     putNickC devs $calc($len($1-) * 0.02)
    ;;   }
    if ($regex($1-,/\b(powder|opana|caffeine|cocaine|crack|ecstasy|mdma|molly|mxe|lithium|opium|percocet|vicodin|oxycontin|roxy|oxycodone|hydrocodone|morphine|oxymorphine|oxytocin|hydromorphone|codeine|syrup|drug|heroin|smack|PCP|GHB|acid|LSD|shrooms|meth|amphetamine|adderall|fentanyl|xanax|klonopin|clonazepam|valium|immodium|mescaline|ether|crank|needle|dope|eighth|quarter|freebase|freebasing|whippits|nitrous|ketamine|kpin|qualude)\b/Si)) {
      putNickC drugs $calc($len($1-) * 0.02)
    }
    if ($regex($1-,/\b(weed|THC|haze|edibles|concentrates|shatter|wax|kush|OG|GSC|cookies|GDP|strains|hybrid|marijuana|maryjane|ganja|pot|green|joint|dab|reefer|cannabis|flower|grass|herb|hash|kief|narcotic|BHO|rosin|dank|bong|marihuana|sativa|indica|mary\x20jane|skunk|reggie|regular|schwag|loudpack|high-potency|bud|chronic|leaf|lit|tetrahydrocannabinol)\b/Si)) {
      putNickC THC $calc($len($1-) * 0.02)
    }
    ;;   if ($regex($1-,/(honkey|honky|honkee|honkie|whitey|1488|white|cracker)/Si)) {
    ;;     putNickC niggers $calc($len($1-) * -0.1)
    ;;   }
    if ($regex($1-,/(8D|8=D|8=+=D|dick|cock|schlong|johnson|weiner|penis|richard|sword)/Si)) {
      putNickC cocks $calc($len($1-) * 0.001)
    }
    if ($regex($1-,/(mIRC|mSL|.mrc|@window|hget|hadd|gettok|regsubex|scid|scon)/Si)) {
      putNickC mIRC $calc($len($1-) * 0.001)
    }
    if ($regex($1-,/(vagina|cunt|beaver|vajayjay|pooter|pussy|poonanie|rosebud)/Si)) {
      putNickC cocks $calc($len($1-) * -0.01)
    }
  }
}

on *:action:*:#:{
  if ($regex($1-,/(cards|raccoon|racoon|khaled|rebel|ouims|jaytea|saturn|defiler|pharmer|entropy|talon|maroon|SR3ject|SReject)/gSi)) {
    var %i = $regml(0)
    while (%i) {
      putNickC $regml(%i) $calc(($len($1-) * 0.01) / $matchtok($1-, $regml(%i), 0, 32))
      dec %i
    }
  }
  if ($regex($nick,/(cards|raccoon|rebel|defiler|pharmer|ouims|jaytea|saturn|talon|entropy|maroon|SR3ject)/Si)) {
    putNickC $regml(1) $calc($len($1-) * 0.01) 
  }
  ;; if ($istok(vmalloc rebel thread defiler Southern_B|tch Raccoon PL,$nick,32)) && ($true) {
  ;;   putNickC $nick $calc($len($1-) * 0.01) 
  ;;   set %lastcnick $nick
  ;; }
  if ($regex($nick,/(chrono|Techman|l0de|vap0r|yurifalse|mikejonez|s3v3n|syn|Pescados666|disliked|acidvegas)/Si)) {
    putNickC $regml(1) $calc($len($1-) * -0.01)
  }
  if ($regex($1-,/(nigger|negro|kneegro|coon|nigga)/Si)) {
    putNickC niggers $calc($len($1-) * -0.002)
  }
  if ($regex($1-,/(8D|8=D|8=+=D|dick|cock|schlong|johnson|weiner|penis|richard|sword)/Si)) {
    putNickC cocks $calc($len($1-) * 0.001)
  }
}

on *:kick:#:{
  if ($regex($knick,/(cards|raccoon|rebel|jaytea|defiler|pharmer|*entropy|Talon*|maroon|SR3ject|SReject)/Si)) {
    putNickC $regml(1) $calc($len($1-) * -0.2)
  }
  if ($istok($knick,ret,32)) {
    putNickC ret $calc($len($1-) * -0.2)
  }
}

on *:quit:{
  if ($regex($nick,/(cards|raccoon|rebel|saturn|jaytea|ouims|defiler|pharmer|*entropy|Talon*|maroon|SR3ject|SReject)/Si)) {
    putNickC $regml(1) $calc($len($1-) * -0.2)
  }
  if ($istok($nick,ret,32)) {
    putNickC ret $calc($len($1-) * -0.2)
  }
}



alias money {
  if ($1 isnum) {
    if ($chr(46) isin $1) { var %dollars $gettok($1,1,46)
      var %cents $remove($round($+($chr(46),$gettok($1,2,46)),4),0.)
      if ($len(%cents) == 1) { set %cents $+(%cents,0) }
    }
    else { var %dollars $1 }
    var %length $ceil($calc($len(%dollars)/3))
    if (%length > 1) {
      dec %length
      var %result $addtok(%result,$left(%dollars,$calc($len(%dollars)-$calc( [ %length ] * 3))),44) | var %stuff -3
      while (%length) {
        var %result $instok(%result,$mid(%dollars,$calc( [ %stuff ] * [ %length ] ),3),$calc($numtok(%result,44)+1),44) | dec %length
      }
    }
    else { var %result %dollars }
    if ($chr(46) isin $1) {
      if ($1 < 0) {
        $iif($mid(%result,2,1) == $chr(44),set %result $gettok(%result,2-,44))
        return $+(-,$chr(36),$remove(%result,-),$chr(46),%cents)
      }
      else { return $+($chr(36),$remove(%result,-),$chr(46),%cents) }
    }
    else {
      if ($1 < 0) {
        $iif($mid(%result,2,1) == $chr(44),set %result $gettok(%result,2-,44))
        return $+(-,$chr(36),$remove(%result,-))
      }
      else { return $+($chr(36),$remove(%result,-)) }
    }
  }
}

alias num {
  if ($1 isnum) {
    if ($chr(46) isin $1) { var %dollars $gettok($1,1,46)
      var %cents $remove($round($+($chr(46),$gettok($1,2,46)),4),0.)
      if ($len(%cents) == 1) { set %cents $+(%cents,0) }
    }
    else { var %dollars $1 }
    var %length $ceil($calc($len(%dollars)/3))
    if (%length > 1) {
      dec %length
      var %result $addtok(%result,$left(%dollars,$calc($len(%dollars)-$calc( [ %length ] * 3))),44) | var %stuff -3
      while (%length) {
        var %result $instok(%result,$mid(%dollars,$calc( [ %stuff ] * [ %length ] ),3),$calc($numtok(%result,44)+1),44) | dec %length
      }
    }
    else { var %result %dollars }
    if ($chr(46) isin $1) {
      if ($1 < 0) {
        $iif($mid(%result,2,1) == $chr(44),set %result $gettok(%result,2-,44))
        return $+(-,$remove(%result,-),$chr(46),%cents)
      }
      else { return $+($remove(%result,-),$chr(46),%cents) }
    }
    else {
      if ($1 < 0) {
        $iif($mid(%result,2,1) == $chr(44),set %result $gettok(%result,2-,44))
        return $+(-,$remove(%result,-))
      }
      else { return $remove(%result,-) }
    }
  }
}

on *:EXIT:{ hsave -s NickC NickC\NickC.db }
on *:DISCONNECT:{ hsave -s NickC NickC\NickC.db }
