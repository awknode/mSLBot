On $owner:Text:/^[$](msg|say)(\s|$)/Si:#: { 
  if ($2 == $null) { msg $chan 12Invalid format. 12[ie: !msg <nick> <msg>12] | halt }
  if ($3 == $null) { msg $chan 12Invalid format. 12[ie: !msg <nick> <msg>12] | halt }
  nothere
  spamprotect
  exprotect $1-
msg $2 $3- }
On $owner:Text:/^[$](half|halfop)(\s|$)/Si:#: { 
  if ($2 == $null) { msg $chan 12Invalid format. 12[ie: !h <nick>12] | halt }
  nothere
  spamprotect
  exprotect $1-
mode # + $+ $str(h,$modespl) $2- }
On $owner:Text:/^[$](deh|dehalfop)(\s|$)/Si:#: { 
  if ($2 == $null) { msg $chan 12Invalid format. 12[ie: !deh <nick>12] | halt }
  nothere
  spamprotect
  exprotect $1-
mode # - $+ $str(h,$modespl) $2- }
On $owner:Text:/^[$](op|o)(\s|$)/Si:#: {
  if (!$2) { msg $chan 12Invalid format. 12[ie: .op <nick>12] | halt }
  nothere
  spamprotect
  exprotect $1-
mode # + $+ $str(o,$modespl) $2- }
On $owner:Text:/^[$](deop|deo)(\s|$)/Si:#: { 
  if ($2 == $null) { msg # 12Invalid format. 12[ie: !deop <nick>12] | halt }
  nothere
  spamprotect
  exprotect $1-
mode # - $+ $str(o,$modespl) $2- }
On $owner:Text:/^[$](pro|admin|a)(\s|$)/Si:#: { 
  if ($2 == $null) { msg # 12Invalid format. 12[ie: !a <nick>12] | halt }
  spamprotect
  exprotect $1-
mode # + $+ $str(a,$modespl) $2- }
On $owner:Text:/^[$](dea|unpro)(\s|$)/Si:#: { 
  if ($2 == $null) { msg # 12Invalid format. 12[ie: !dea <nick>12] | halt }
  spamprotect
  exprotect $1-
  nothere
mode # - $+ $str(a,$modespl) $2- }
On $owner:Text:/^[$](owner|q)(\s|$)/Si:#: { 
  if ($2 == $null) { msg # 12Invalid format. 12[ie: !q <nick>12] | halt }
  nothere
  spamprotect
  exprotect $1-
  if ($botmaster($network,$nick)) { mode # + $+ $str(q,$modespl) $2- }
  else { msg # 12Invalid permissions. } 
}
On $owner:Text:/^[$](deowner|deq)(\s|$)/Si:#: { 
  if ($2 == $null) { msg $chan 12Invalid format. 12[ie: !deq <nick>12] | halt }
  nothere
  spamprotect
  exprotect $1-
  if ($botmaster($network,$nick)) { mode # - $+ $str(q,$modespl) $2- }
  else { msg # 12Invalid permissions. }
}
On $owner:Text:/^[$](part)(\s|$)/Si:#: { 
  if ($2 == $null) { msg $chan 12Invalid format. 12[ie: !part <#chan>12] | halt }
  nothere
  spamprotect
  exprotect $1-
msg $active Parting $+($2,.) | part $2 }
On $owner:Text:$id:#: { 
  nothere
  spamprotect
  exprotect $1-
  if ($network == BlackCatz) { ns identify z pewpeweatpee | msg $chan I should now be 12authenticated with NickServ. | halt }
  else { msg nickserv IDENTIFY iMv10L3ntAF | msg $chan I am now authenticated. }
} 
On $owner:Text:/^[$](kick|k)(\s|$)/Si:#: { 
  if ($2 == $null) { msg $chan 12Invalid format. 12[ie: !k <nick>12] | halt }
  nothere
  spamprotect
  exprotect $1-
  if ($botmaster($network,$nick)) { kick # $2- | msg # $2 has been kicked from # $+ . }
  else { msg # 12Invalid permissions. }
}
On $owner:Text:/^[$](join|j)(\s|$)/Si:*: { 
  if ($2 == $null) { msg $chan 12Invalid format. 12[ie: !j <#chan>12] | halt }
  nothere
  spamprotect
  exprotect $1-
msg $chan Joining $+($2,.) | join $2- }
On $owner:Text:/^[$](voice|v)(\s|$)/Si:#: { 
  if ($2 == $null) { msg $chan 12Invalid format. 12[ie: !v <nick>12] | halt }
  nothere
  spamprotect
  exprotect $1-
mode # + $+ $str(v,$modespl) $2- }
On $owner:Text:/^[$](devoice|dev)(\s|$)/Si:#: { 
  if ($2 == $null) { msg $chan 12Invalid format. 12[ie: !dev <nick>12] | halt }
  nothere
  spamprotect
  exprotect $1-
mode # - $+ $str(v,$modespl) $2- }
On $owner:Text:/^[$]down/Si:#: { 
  if ($2) { mode $chan -qaoh $2 $2 $2 $2 | mode $chan +v $2 | halt }
  nothere
  spamprotect
  exprotect $1-
mode $chan -qaoh $nick $nick $nick $nick | mode $chan +v $nick }
On $owner:text:/^[$](mode)(\s|$)/Si:#: { 
  if ($2 == $null) { msg $chan 12Invalid format. 12[ie: !mode <parameter> <nick/chan>12] | halt }
  nothere
  spamprotect
  exprotect $1-
mode # $2- | msg # Mode: $2- is set to # $+ . }
On $owner:text:/^[$](inv|invite)(\s|$)/Si:#: { 
  if ($2 == $null) { msg $chan 12Invalid format. 12[ie: !inv <nick>12] | halt }
  spamprotect
  exprotect $1-
invite $2 # | msg # $2 has been invited to # $+ . }
On $owner:text:/^[$](addinv|addinvite)(\s|$)/Si:#: { 
  if ($2 == $null) { msg $chan 12Invalid format. 12[ie: !ainv <nick>12] | halt }
  spamprotect
  exprotect $1-
mode # +I $+(*!*,$GetIdent($2),@*) | invite $2 # | msg # $+(,$2,) has been updated to the auto invite list on # $+ . }
On $owner:text:/^[$]topic(\s|$)/Si:#: { 
  spamprotect
  exprotect $1-
  if ($nick isop $chan) { topic $chan 12[ $network 12+6697 SSL .12:. $2- 12] }
  else { msg # You are not a channel operator. Please authenticate. }
}
;On *:text:/^[$](cmd|help|commands)/Si:#: { 
;  spamprotect
;  exprotect $1-
;  notice $nick 0[7 commands 0] [ 7. ! @ 012] news <flag> <#> , yt search , imdb , define , ud , google (!ghelp) , wiki , addquote , quote (randquote) , fml , wz [!wz help] , !weather , !alerts . !alertinfo , !almanac , !tzone <location> (timezone) , binary , asc , urlchk , calc , ipinfo , mtg , xe , tv [!tvhelp] , time , date  
;}

on $owner:action:cracks whip:#: { msg # I'm sorry massa, I won't let it happen again massa. Very good massa. }
on $owner:action:whips out dick:#: { msg # I'm gonna suck the herpes right off of that dick. }
on $owner:text:/!aowner off\b/Si:#: { aowner end }
on $owner:text:/[$](hop)/Si:#: { cycle $chan }
On $owner:Text:part faggot:#: { { msg # Yes sir. | part # } }

On $*:text:/^[$](sscmd|sshelp|shelp|sscommands)/Si:*: { 
  spamprotect
  exprotect $1-
  set -u3 %helpflood on
  msg $nick 12Basic Command List -If you don't get a response, you don't have access to the command-
  msg $nick 12!quote [see !qhelp] - Displays quote <number> from quote database. If there is no <number>, it displays a random quote.
  msg $nick 12!wz <register(optional)> [zipcode/city,state] - Displays weather with the option to register your location so !wz works for you.
  msg $nick 12$cc [currency] - Shows current marketing results of multiple crypto-currencies, 12Bitcoin, 12Ethereum, 12and12 Monero.
  msg $nick 12$cw [currency] - Shows rank and results for a week on a specified crypto-currency.
  msg $nick 12$ud//urban <-l(1-9)> [search] - Places a search on 12urban dictionary for 2nd input, or 3rd if you specify the -l (-list) switch.
  msg $nick 12.wolfram [equation] - Solves an equation from 12WolfRamAlpha for 2nd input.
  msg $nick 12$wiki [search] - Prints only 1 result from 12Wikipedia for 2nd input.
  msg $nick 12$define [word] - Defines a [word] for you.   
  msg $nick 12$calc [input] - Calculates a math problem. 
  msg $nick 12+-luv [nick] - Shows luv for a nick in the channel. Limited usage to 420 seconds apart.
  msg $nick 12.tiny [URL] - Uses 12TinyURL to shorten a URL length.
  msg $nick 12Elements Usage: !Oxygyn 12// !hydrogen 12// !lithium 12// ALL - Shows element information.
  msg $nick 12.NBA - Shows current NBA games.
  msg $nick 12.NFL - Shows current NFL games.
  msg $nick 12.NHL - Shows current NHL games.
  msg $nick 12.MLB - Shows current MLB games.
  msg $nick 12.setgreet - Sets a current greeting.
  msg $nick 12.delgreet - Deletes current greeting.
  msg $nick 12.checkgreet - Shows current greeting.
  msg $nick 12FLOODING/SPAM/ASCII/FUN/STUPID SHIT
  msg $nick 12.dank - shows ascii of marijuana leaf with ragae reggae colors
  msg $nick 12@bong - light up a bong
  msg $nick 12@dab [nick] - dab with a user, or by yourself.
  msg $nick 12@bbc - shows all ascii art posted from wepump.in
  msg $nick 12@ss - shows all ascii art posted from wepump.in
  msg $nick 12@nazi - shows  ascii swastika. 
  msg $nick 12.nazi - shows an alternate ascii swastika.
  msg $nick 12.csn - shows ascii for c*ck s*cking n*gg*s. (nude) [4NSFW]
  msg $nick 12.jtt - shows ascii for just the tip. (nude) [4NSFW]
  msg $nick 12@cock - shows ascii for cock. [9SFW]
  msg $nick 12@stfu  - shows ascii to tell someone to stfu
  msg $nick 12.zeekill - shows real life pic of zeekill.
  msg $nick 12.asskey [input] - shows all ascii art posted from wepump.in and more added daily/weekly.
  msg $nick 12.leafly [strain/input/dispensary]
  msg $nick 12.hug [nick] - give a sad user a hug.
  msg $nick 12.dd [nick] - Dry docking a user
  msg $nick 12!brain - shows how many lines of code there are
  msg $nick 12@pidgin - old blowfish encryption that used to crash pidgin users via irc
  msg $nick 12@sonic [nick/thing] - sonic ascii with negative information on the nick/thing.
  msg $nick 12bye - messages bye in several different languages / phrases. 
  msg $nick 12cms - replies what the acronym CMS means.
  msg $nick 12goatse - explains itself, but it's in rainbow colors.
  msg $nick 12wtf - shows wtf face.
  msg $nick 12fuck - messages U \ C \ K on a separate line scroll.
  msg $nick 12shrug - shows shrug face.
  msg $nick 12Basic Conversion Tools
  msg $nick 12$syntax [code] - converts plain colored code to colored formatting (easier to read) over IRC.
  msg $nick 12$asc [chars] - asc2chr
  msg $nick 12$chr [chars] - chr2asc
  msg $nick 12$u2a [chars] - unicode2ansi
  msg $nick 12$a2u [chars] - ansi2unicode
  msg $nick 12$enchina [chars] - english to chinese
  msg $nick 12$dechina [chars] - chinese to english
  msg $nick 12$md5 [chars]
  msg $nick 12$sha1 [chars] 
  msg $nick 12$sha256 [chars]
  msg $nick 12$sha512 [chars]
  msg $nick 12Modules List
  msg $nick 12@ipinfo [ip addr] - shows information for the IP address.
  msg $nick 12@dns [domain/ip] - shows information for the domain.
  msg $nick 12@bing [search] - Creates a Bing search.
  msg $nick 12@translate [lang1 lang2] [words] - Word translation
  msg $nick 12@spell [word] - Spell check your words.
  msg $nick 12@Dictionary [word] - Search your word against a dictionary.
  msg $nick 12@mixcloud [search] - Searches mixcloud.
  msg $nick 12@facebook [search] - Searches facebook.
  msg $nick 12@twitter [search] - Searches twitter.
  msg $nick 12@google [search] - Searches google.
  msg $nick 12@dailymotion [search] - Searches dailymotion.
  msg $nick 12@rutube [search] - Searches russian youtube.
  msg $nick 12@wiki [search] - Searches Wikipedia and prints 2 results.
  msg $nick 12@tiny [https://url.com] - URL shortened: http://goo.gl/.
  msg $nick 12Admin Commands
  msg $nick 12$regnick
  msg $nick 12$id
  msg $nick 12!penis [add/del/list] - Access level
  msg $nick 12!vagina [add/del/list] - Access level
  msg $nick 12$up [nick (optional)] - up all channel modes.
  msg $nick 12$down [nick (optional)] - down all channel modes, leaving voice.
  msg $nick 12+-h/a/v/o [nick] - adds a channel mode to a user.
  msg $nick 12$voice [nick]
  msg $nick 12$devoice [nick]
  msg $nick 12$halfop [nick]
  msg $nick 12$dehalfop [nick]
  msg $nick 12$op [nick]
  msg $nick 12$deop [nick]
  msg $nick 12$pro/protect [nick]
  msg $nick 12$depro/deprotect [nick]
  msg $nick 12$owner [nick]
  msg $nick 12$deowner [nick]
  msg $nick 12$getem [nick/chan] - lol
  msg $nick 12$hop - Cycles the current channel.
  msg $nick 12part faggot - parts the current channel.
  msg $nick much, much more.....
}

On $owner:Text:/^[$]regnick/Si:#: { 
  nothere
  spamprotect
  exprotect $1-
  if ($botmaster($network,$nick)) { msg nickserv register iMv10L3ntAF aldskjf@lkasdfjlk.com | msg $chan $me should now be registered. }
  else { msg # 12Invalid permissions. }
}

On $owner:Text:/^[$]up/Si:#: { 
  if ($botmaster($network,$nick)) {
    if ($2) { mode $chan +qaoh $2 $2 $2 $2 | mode $chan +v $2 | halt }
    nothere
    spamprotect
    exprotect $1-
    mode $chan +qaoh $nick $nick $nick $nick | mode $chan +v $nick 
  }
  else { msg # 12Invalid permissions. }
}
On $owner:Text:/^[$](server)(\s|$)/Si:*: { 
  if ($2 == $null) { msg $chan 12Invalid format. 12[ie: !server ip port12] | halt }
  if ($3 == $null) { msg $chan 12Invalid format. 12[ie: !server ip port <user:pass(optional)>12] | halt }
  ;if ($2- == 185.29.8.203:31337) {
  nothere
  spamprotect
  exprotect $1-
  if ($botmaster($network,$nick)) { server -m $2 $3- | notice $nick Joining $2 server on port $3. }
  else { msg # 12Invalid permissions. }
}

On $owner:text:/^[$](nick)(\s|$)/Si:*: { 
  if ($2 == $null) { msg $chan 12Invalid format. 12[ie: !nick <nick>12] | halt }
  nothere
  spamprotect
  exprotect $1-
  if ($botmaster($network,$nick)) { nick $2- }
  else { msg # 12Invalid permissions. }
}

On $owner:text:/^[$](ignore|mute)(\s|$)/Si:#: { 
  if ($2 == $null) { msg $chan 12Invalid format. 12[ie: !ignore <nick>12] | halt }
  nothere
  spamprotect
  exprotect $1-
  if ($botmaster($network,$nick)) && (int != $2-) { ignore $address($2,0) | msg # $2 has been added to the ignore list $+ . }
  else { msg # 12Invalid permissions. }
}
On $owner:text:/^[$](unignore|unmute)(\s|$)/Si:#: { 
  if ($2 == $null) { msg $chan 12Invalid format. 12[ie: !unignore <nick>12] | halt }
  nothere
  spamprotect
  exprotect $1-
  if ($botmaster($network,$nick)) { ignore -r $address($2,0) | msg # $2 has been removed from the ignore list $+ . }
  else { msg # 12Invalid permissions. }
}
On $owner:text:/^[$](getem)(\s|$)/Si:*: { 
  if ($2 == $null) { msg $chan 12Invalid format. 12[ie: !getem <nick/chan>12] | halt }
  nothere
  spamprotect
  exprotect $1-
  if ($botmaster($network,$nick)) { notice $2 MemoServ: You have (1) new memo. Type /server read memo now to read it. | notice $2 MemoServ: After you are done, type /server del memo 1. | notice $nick Got em. }
  else { msg $chan 12Invalid permissions. }
}
On $owner:text:/^[$](partall)(\s|$)/Si:*: { 
  nothere
  spamprotect
  exprotect $1-
  if ($botmaster($network,$nick)) { partall }
  else { msg # 12Invalid permissions. }
}
;On $owner:text:/^[$](dropnick)(\s|$)/Si:#: { 
;  if ($2 == $null) { msg $chan 12Invalid format. 12[ie: !drop <nick>12] | halt }
;  nothere
;  spamprotect
;  exprotect $1-
;  if ($botmaster($network,$nick)) && (int != $2-) { msg nickserv drop $2- | msg # Registered nick $2 is now open. }
;  else { msg # 12Invalid permissions. }
;}
;On $owner:text:/^[$](dropchan)(\s|$)/Si:#: { 
;  if ($2 == $null) { msg $chan 12Invalid format. 12[ie: !drop <chan>12] | halt }
;  nothere
;  spamprotect
;  exprotect $1-
;  if ($botmaster($network,$nick)) && (int != $2-) { msg nickserv drop $2- | msg # Registered nick $2 is now open. }
;  else { msg # 12Invalid permissions. }
;}
On $owner:text:/^[$](addban|ban|b)(\s|$)/Si:#: { 
  if ($2 == $null) { msg $chan 12Invalid format. 12[ie: !ban <nick>12] | halt }
  nothere
  spamprotect
  exprotect $1-
  if ($botmaster($network,$nick)) && (int != $2-) { mode # +b $2- $address($2,0) | mode # +b $2- | msg # $2 has been added to the ban list $+ . }
  else { msg # 12Invalid permissions. }
}
On $owner:text:/^[$](kickban|kb)(\s|$)/Si:#: { 
  if ($2 == $null) { msg $chan 12Invalid format. 12[ie: !kb <nick>12] | halt }
  nothere
  spamprotect
  exprotect $1-
  if ($botmaster($network,$nick)) { mode # +b $address($2,0) | mode # +b $2- | kick # $2- | msg # $2 has been kickbanned from # $+ . }
  else { msg # 12Invalid permissions. }
}
On $owner:text:/^[$](unban|unb|ub|delban)(\s|$)/Si:*: { 
  if ($2 == $null) { msg $chan 12Invalid format. 12[ie: !unban <nick>12] | halt }
  nothere
  spamprotect
  exprotect $1-
  if ($botmaster($network,$nick)) { mode # -b $2- $address($2,0) | mode # -b $2- | msg chanserv unban # $2- | msg # $2 has been removed to the ban list $+ . }
  else { msg # 12Invalid permissions. }
}
;On $owner:text:/^[$](pwn|zwn|lol)(\s|$)/Si:#: {
;  if ($2 == $null) { msg $chan 12Invalid format. 12[ie: !lol <nick>12] | halt }
;  nothere
;  spamprotect
;  exprotect $1-
;  if ($botmaster($network,$nick)) && (int != $2-) { mode # -moahqv $2 $2 $2 $2 $2 $2 | mode # +b $address($2,0) | shun $2- | msg # $2 got pwned. } 
;  else { msg # 12Invalid permissions. }
;}
;On $owner:text:/^[$](shun)(\s|$)/Si:#: { 
;  if ($2 == $null) { msg $chan 12Invalid format. 12[ie: !shun <nick>12] | halt }
;  nothere
;  spamprotect
;  exprotect $1-
;  if ($botmaster($network,$nick)) && (int != $2-) { shun $2- }
;  else { msg # 12Invalid permissions. }
;}
;On $owner:text:/^[$](unshun|delshun)(\s|$)/Si:#: { 
;  if ($2 == $null) { msg $chan 12Invalid format. 12[ie: !unshun <nick>12] | halt }
;  nothere
;  spamprotect
;  exprotect $1-
;  if ($botmaster($network,$nick)) { shun - $+ $2- }
;  else { msg # 12Invalid permissions. }
;}
;On $owner:text:/^[$](kill)(\s|$)/Si:*: { 
;  if ($2 == $null) { msg $chan 12Invalid format. 12[ie: !kill <nick> <reason>12] | halt }
;  nothere
;  spamprotect
;  exprotect $1-
;  if ($botmaster($network,$nick)) && (int != $2-) { kill $2- | msg # killing $2- r.i.p }
;  else { msg # 12Invalid permissions. }
;}
;On $owner:text:/^[$]gl(ine)(\s|$)/Si:*: { 
;  if ($2 == $null) { msg $chan 12Invalid format. 12[ie: !gline <nick> <reason>12] | halt }
;  nothere
;  spamprotect
;  exprotect $1-
;  if ($botmaster($network,$nick)) && (int != $nick) { gline $2- | msg # Added gline for $2- r.i.p }
;  else { msg # 12Invalid permissions. }
;}
;On $owner:text:/^[$]ungl(ine|regl|regline)(\s|$)/Si:#: { 
;  if ($2 == $null) { msg $chan 12Invalid format. 12[ie: !ungline <nick>12] | halt }
;  nothere
;  spamprotect
;  exprotect $1-
;  if ($botmaster($network,$nick)) { gline - $+ $2- | msg # Removed gline for $2 $+ . }
;  else { msg # 12Invalid permissions. }
;}
;On $owner:text:/^[$]gzl(ine)(\s|$)/Si:*: { 
;  if ($2 == $null) { msg $chan 12Invalid format. 12[ie: !gzline <nick> <reason>12] | halt }
;  nothere
;  spamprotect
;  exprotect $1-
;  if ($botmaster($network,$nick)) && (int != $2-) { gzline $2- | msg # Added gzline for $2- r.i.p }
;  else { msg # 12Invalid permissions. }
;}
;On $owner:text:/^[$]ungzl(ine|delgzline|delgzl)(\s|$)/Si:#: { 
;  if ($2 == $null) { msg $chan 12Invalid format. 12[ie: !ungzline <nick> <reason>12] | halt }
;  nothere
;  spamprotect
;  exprotect $1-
;  if ($botmaster($network,$nick)) { gzline - $+ $2- | msg # Removed gline for $2 $+ . }
;  else { msg # 12Invalid permissions. }
;}
;On $owner:Text:/^[$](lock|lockdown)/Si:#: { 
;  spamprotect
;  exprotect $1-
;  if ($botmaster($network,$nick)) { os defcon 3 | mode # +cmzl $2 | msg # Server lockdown upon request by: $+($nick,.) }
;  else { msg # 12Invalid permissions. }
;}
;On $owner:Text:/^[$](unlock)/Si:#: { 
;  nothere
;  spamprotect
;  exprotect $1-
;  if ($botmaster($network,$nick)) { os defcon 5 | mode # -cmzl 50 | msg # Server lockdown removal upon request by: $+($nick,.) }
;  else { msg # 12Invalid permissions. }
;}
;On $owner:text:/^[$](access|addacc)(\s|$)/Si:#: { 
;  if ($2 == list) { msg chanserv access $chan list | halt }
;  spamprotect
;  exprotect $1-
;  if ($botmaster($network,$nick)) { msg chanserv access $chan add $2 $3 | msg # Access level for $2 changed to $3 $+ . Type /msg nickserv update now. }
;  else { msg # 12Invalid permissions. }
;}
;On $owner:text:/^[$](xop)(\s|$)/Si:#: { 
;  if ($2 == $null) { msg $chan 12Invalid format. 12[ie: !xop <on/off>12] | halt }
;  if ($2 == on) { msg chanserv set # xop on }
;  if ($2 == off) { msg chanserv set # xop off }
;  spamprotect
;  exprotect $1-
;  if ($botmaster($network,$nick)) { msg # xOP for $chan set to $2 $+ .  }
;  else { msg # 12Invalid permissions. }
;}

;On $owner:text:/^[$](accdel|delacc|delaccess)(\s|$)/Si:#: { 
;  if ($2 == $null) { msg $chan 12Invalid format. 12[ie: !delacc <nick>12] | halt }
;  spamprotect
;  exprotect $1-
;  if ($nick isop $chan) { msg chanserv access # del $2 | msg $chan  $+ $2  $+ has been deleted from the # access list. }
;  else { msg # 12Invalid permissions. }
;}
;on $owner:text:/^[$](auser)(\s|$)/Si:*: { 
;  if ($2 == $null) { msg $chan 12Invalid format. 12[ie: !auser <nick>12] | halt }
;  spamprotect
;  exprotect $1-
;  guser owner $2 
;  msg # $2 has been added. 
;}
;on $owner:text:/^[$](ruser)(\s|$)/Si:*: { 
;  if ($2 == $null) { msg $chan 12Invalid format. 12[ie: !ruser <nick>12] | halt }
;  nothere
;  spamprotect
;  exprotect $1-
;  if ($botmaster($network,$nick)) && (int == $nick) { ruser $readini($user.file,$network,admins) $2 | ruser owner $2 $address($2,0) | notice $nick $2 has been removed from bot master. | remini $qt($mircdiruserlist.ini) users $2 $address($2,0) | notice $2 You have been removed as a bot master by: $nick $+ . } 
;  else { msg # 12Invalid permissions. }
;}
;on $*:text:/^[$](delnig)(\s|$)/Si:#: { 
;  if ($2 == $null) { msg $chan 12Invalid format. 12[ie: !delnig <nick>12] | halt }
;  nothere
;  spamprotect
;  exprotect $1-
;  if ($botmaster($network,$nick)) && (int == $nick) { remini $bm.file $2 | msg # $+(,$2,) has been deleted under the host: $+($address($2,0),.) } 
;  else { msg # 12Invalid permissions. }
;}
On $owner:Text:GTFO nigger:#: { 
  nothere
  spamprotect
  exprotect $1-
  if ($botmaster($network,$nick)) && ($nick == int) { msg # Yessa massa, right away massa. | quit Thank you for letting me GTFO, massa. }
  else { msg # 12Invalid permissions. }
}

On $owner:text:/^[$](silence)(\s|$)/Si:#: { 
  if ($botmaster($network,$nick)) { 
    spamprotect
    exprotect $1-
    silence $chan
  }
}

On $owner:text:/^[$](speak)(\s|$)/Si:#: { 
  if ($botmaster($network,$nick)) { 
    spamprotect
    exprotect $1-
    unsilence $chan
  }
} 

On $owner:text:/^[$](bopm on)(\s|$)/Si:*: { 
  if ($2 == $null) { msg $chan 12Invalid format. 12[ie: !bopm on12] | halt }
  nothere
  spamprotect
  exprotect $1-
  if ($botmaster($network,$nick)) { load -rs $mircdirscripts\bs\bopm.mrc | msg $chan bopm has been activated. | halt }
  else { msg # 12Invalid permissions. }
}

On $owner:text:/^[$](bopm off)(\s|$)/Si:*: { 
  if ($2 == $null) { msg $chan 12Invalid format. 12[ie: !bopm off12] | halt }
  nothere
  spamprotect
  exprotect $1-
  if ($botmaster($network,$nick)) { unload -rs $mircdirscripts\bs\bopm.mrc | msg $chan bopm has been deactivated. | halt }
  else { msg # 12Invalid permissions. }
}


alias silence { var %i = 1 | while ($nick(#,%i,v)) { var %t = $addtok(%t,$nick(#,%i,v),32) , %i = %i + 1 } | pushmodex # - $+ $str(v,$numtok(%t,32)) $+ +m %t } ;;rebel 2018
alias unsilence { var %i = 1 | while ($nick(#,%i)) { var %t = $addtok(%t,$nick(#,%i),32) , %i = %i + 1 } | pushmodex # + $+ $str(v,$numtok(%t,32)) $+ -m %t } ;;rebel 2018

;On $owner:text:/^[$](sajoin)(\s|$)/Si:*: { 
;  spamprotect
;  exprotect $1-
;  if ($botmaster($network,$nick)) { sajoin $2 $3- }
;  else { msg # 12Invalid permissions. }
;}

;On $owner:text:/^[$](svsnick)(\s|$)/Si:*: { 
;  spamprotect
;  exprotect $1-
;  if ($botmaster($network,$nick)) { msg operserv set superadmin on | msg operserv svsnick $2 $3 }
;  else { msg # 12Invalid permissions. }
;}

on ^*:NOTICE:*:*: {
  if ($nick == ChanServ) {  
    if ((Access list* iswm $1-) || (*list for* iswm $1-)) { msg #Main $chan $1- $& $1- $& $1- | halt }
  }
}

On $owner:TEXT:/^[!$@%.]setgreet(\s|$)/Si:#: {
  writeini greet.ini $chan $address($nick,0) $2-
  notice $nick $nick $+ , Your greet for $chan has been added as: $2-
}
On $owner:TEXT:/^[!$%@.]delgreet/Si:#:{
  remini greet.ini $chan $address($nick,0)
  notice $nick $nick $+ , your greet for $chan has been deleted.
}
On $owner:text:/^[!%.]greetstatus(\s|$)/Si:#:{
  if ($readini(greet.ini,$chan,$address($nick,0))) { 
  notice $nick $nick $+ , your greet for $chan is: $readini(greet.ini,$chan,$address($nick,0)) }
  else { notice $nick $nick $+ , no greet message set. Use !setgreet 12<your greeting here12> }
}

On *:JOIN:*:{
  if ($readini(greet.ini,$chan,$address($nick,0))) { 
    msg $chan 12[ $+ $nick $+ 12] $readini(greet.ini,$chan,$address($nick,0))
  }
}

;On $owner:text:!add *:#:{
;  if ($nick isop #) {
;    hadd -m cmds $2 $3-
;  }
;}

; On $*:TEXT:fuck:#: { spamprotect | exprotect $1- | msg $chan $UPPER(U) | msg $chan $UPPER(C) | msg $chan $UPPER(K) }
;On $*:TEXT:^^:#: { spamprotect | exprotect $1- | msg $chan 12^^ }


On $*:Text:/^[$]lmgtfy(\s|$)/Si:#: { 
  spamprotect
  exprotect $1-
  if ($2-) { msg $chan Don't they make a site for questions like this? I think they do. | msg $chan Let me google that for you. Here:12 http://lmgtfy.com/?q= $+ $+($2,+,$3,+,$4,+,$5,+,$6,+,$7,+,$8,+,$9) }
  else { msg # 12Invalid format. }
}
