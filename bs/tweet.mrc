;twitter TweetBot by Ford_Lawnmower irc.GeekShed.net #Script-Help
menu Channel,Status {
  .$iif($group(#TweetBot) == On,$style(1)) TweetBot Trigger
  ..$iif($group(#TweetBot) == On,$style(2)) On: .enable #TweetBot
  ..$iif($group(#TweetBot) == Off,$style(2)) Off: .disable #TweetBot
}
On $*:Text:/^[\.]AddAuth/Si:?: {
  if (!$sslready) echo -gst Error: OpenSSL is not installed. You must install OpenSSL to use this script. $&
    http://www.mirc.com/download/openssl/openssl-0.9.8r-setup.exe
  elseif (!$timer($+(Tweetbot,$network,$nick))) {
    .timer $+ $+(Tweetbot,$network,$nick) 1 5 noop
    if (!$2) || ($strip($2) == help) AuthError .msg $nick $nick
    else {
      var %s $strip($2), %UserInfo $iif($gettok(%s,2,58),%s,$decode(%s,m))
      twitter_get_access_token .msg $nick XxXxXxX XxXxXxX $replace(%UserInfo,$chr(58),$chr(32)) $address($nick,1)
    }
  }
}
#TweetBot on
On $*:Text:/^(\+|-|!|@)Tweet.*/Si:#,?: {
  var %action $regml(1)
  if (%action isin +-) && ($regex($nick($chan,$nick).pnick,/(!|~|&|@)/)) {
    if (%action == +) {
      if ($istok(%TweetBotChanList,$+($network,$chan),32)) { .msg $chan $nick $chan is already running the TweetBot script }
      else { 
        .enable #TweetBot
        Set %TweetBotChanList $addtok(%TweetBotChanList,$+($network,$chan),32)
        .msg $chan $nick has activated the TweetBot script for $chan .
      }
    }
    else {
      if (!$istok(%TweetBotChanList,$+($network,$chan),32)) { .msg $chan $nick $chan is not running the TweetBot script }
      else { 
        Set %TweetBotChanList $remtok(%TweetBotChanList,$+($network,$chan),1,32)
        .msg $chan $nick has deactivated the TweetBot script for $chan . 
      }
    }
  }
  elseif (!#) || ($istok(%TweetBotChanList,$+($network,$chan),32)) {
    if (!$timer($+(TweetBot,$network,$nick))) {
      .timer $+ $+(TweetBot,$network,$nick) 1 6 noop
      if (!$2) AuthError .notice $nick $nick
      elseif ($hget(TwitterData,$address($nick,1))) tweet .notice $nick $address($nick,1) $strip($2-)
      else AuthError .notice $nick $nick
    }
  }
}
#TweetBot end
;Syntax twitter_statuses_update echo -a consumer_key consumer_secret oauth_token oauth_token_secret status update here
;Note that echo -a can be changed to msg $chan or notice $nick ( must be two words )
alias -l twitter_statuses_update {
  var %ots $ctime, %sockname $+(twitter_statuses_update,$network,$ticks,$r(1,10000)), %once $md5(%sockname)
  var %os $signature(post,https://api.twitter.com/1.1/statuses/update.json,$3,$4,$5,$6,%once,%ots,$+(status=,$tuenc($7-)))
  sockopen -e %sockname api.twitter.com 443
  sockmark %sockname $1-2 /1.1/statuses/update.json $space2comma($+(oauth_nonce=,$qt(%once)) $osmqt $+(oauth_timestamp=,$qt(%ots)) $+(oauth_consumer_key=,$qt($tuenc($consumer_key))) $&
    $+(oauth_token=,$qt($tuenc($5))) $+(oauth_signature=,$qt($suenc(%os))) $overqt) $+(status=,$tuenc($7-))
}
;Syntax twitter_get_access_token echo -a consumerkey consumersecret username password UserAddress
alias -l twitter_get_access_token {
  var %ots $ctime, %sockname $+(twitter_statuses_update,$network,$ticks,$r(1,10000)), %once $md5(%sockname)
  var %os $signature(post,https://api.twitter.com/oauth/access_token,$3,$4,0,0,%once,%ots,$+(x_auth_mode=client_auth&x_auth_password=,$suenc($6),&x_auth_username=,$suenc($5)))
  sockopen -e %sockname api.twitter.com 443
  sockmark %sockname $1-2 /oauth/access_token $space2comma($+(oauth_nonce=,$qt(%once)) $osmqt $+(oauth_timestamp=,$qt(%ots)) $&
    $+(oauth_consumer_key=,$qt($tuenc($consumer_key))) $+(oauth_signature=,$qt($suenc(%os))) oauth_version="1.0") $&
    $+(x_auth_username=,$suenc($5),&x_auth_password=,$suenc($6),&x_auth_mode=client_auth) $7
}
on *:sockopen:twitter_statuses_update*: {
  if ($sockerr) echo -st Socket Error $nopath($script)
  else {
    tokenize 32 $sock($sockname).mark
    sockwrite -n $sockname POST $3 HTTP/1.1
    sockwrite -n $sockname Host: $sock($sockname).addr
    sockwrite -n $sockname User-Agent: IRCTweet
    sockwrite -n $sockname Authorization: $+(OAuth realm=,$qt($3),$chr(44),$4)
    sockwrite -n $sockname Content-Type: application/x-www-form-urlencoded
    if ($5) {
      sockwrite -n $sockname Content-Length: $len($5)
      sockwrite -n $sockname
      sockwrite -n $sockname $5
    }
    sockwrite -n $sockname
  }
}
on *:sockread:twitter_statuses_update*: {
  if ($sockerr) { $gettok($sock($sockname).mark,1-2,32) Unknown Socket error $nopath($script) }
  else {
    var %twitter_statuses_updatevar | sockread -f %twitter_statuses_updatevar
    ;echo -gat %twitter_statuses_updatevar
    if (HTTP/1.1 401 isin %twitter_statuses_updatevar) {
      $gettok($sock($sockname).mark,1-2,32) Password/Username Error --> %twitter_statuses_updatevar
      AuthError $gettok($sock($sockname).mark,1-2,32)
      sockclose $sockname | return
    }
    elseif (HTTP/1.1 502 isin %twitter_statuses_updatevar) || (HTTP/1.1 503 isin %twitter_statuses_updatevar) {
      $gettok($sock($sockname).mark,1-2,32) Server Busy Error --> %twitter_statuses_updatevar
      sockclose $sockname | return
    }
    elseif (HTTP/1.1 500 isin %twitter_statuses_updatevar) {
      $gettok($sock($sockname).mark,1-2,32) Server Side Error --> %twitter_statuses_updatevar
      sockclose $sockname | return      
    }
    elseif (HTTP/1.1 403 isin %twitter_statuses_updatevar) {
      $gettok($sock($sockname).mark,1-2,32) Connection Actively Refused --> %twitter_statuses_updatevar
      sockclose $sockname | return      
    }
    elseif (HTTP/1.1 400 isin %twitter_statuses_updatevar) {
      $gettok($sock($sockname).mark,1-2,32) Unknown Error --> %twitter_statuses_updatevar
      sockclose $sockname | return
    }
    elseif (HTTP/1.1 200 isin %twitter_statuses_updatevar) {
      $gettok($sock($sockname).mark,1-2,32) Updating Status Please Wait.........
    }
    elseif (status: 200 OK isin %twitter_statuses_updatevar) {
      if ($gettok($sock($sockname).mark,3,32) == /1.1/statuses/update.json) {
        .timer 1 3 $gettok($sock($sockname).mark,1-2,32) Your Status has been updated :)
        sockclose $sockname | return
      }
    }
    elseif ($regex($sockname,%twitter_statuses_updatevar,/oauth_token=(.*)&oauth_token_secret=(.*)&user_id=(.*)&screen_name=([^&]*)/)) {
      tokenize 32 $sock($sockname).mark
      var %item $iif($6,$6,$regml($sockname,4)), %key $r(1,10)
      hadd -m TwitterData %item $regml($sockname,4) $pack(%key,$encode($regml($sockname,1),m)) $pack(%key,$encode($regml($sockname,2),m)) %key
      hsave TwitterData TData.hsh
      $1-2 $regml($sockname,4) was added under record %item
      if ($2 !ischan) && ($window($2)) window -c $v1
      sockclose $sockname | return
    }
  }
}
;Syntax tweet echo -a address tweet
alias -l tweet {
  if ($hget(twitterdata,$3)) {
    var %Output $1-2, %tweet $left($4-,140)
    tokenize 32 $v1
    twitter_statuses_update %Output XxXxXxX XxXxXxX $decode($pack($4,$2),m) $decode($pack($4,$3),m) %tweet
  }
  else $1-2 Tweet error. Unknown User.
}
;Syntax $signature(POST/GET,URL,consumer_key,consumer_secret,oauth_token,oauth_token_secret,oauth_nonce,oauth_timestamp,PostData)
alias -l signature {
  tokenize 32 $1-
  var %method $+($upper($1),&), %url $+($tuenc($2),&), %ck $tuenc&($+(oauth_consumer_key=,$3)), %ot $iif($5,$tuenc&($+(oauth_token=,$5)))
  var %once $tuenc&($+(oauth_nonce=,$7)), %ots $tuenc&($+(oauth_timestamp=,$8)), %post $iif($9-,$tuenc($+(&,$9-)))
  return $hmac-sha1($+($4,&,$iif($6,$6)),$+(%method,%url,%ck,%once,$tuenc&($osm),%ots,%ot,$tuenc($over),%post),$+($ticks,$r(1,1000)))
}
alias -l AuthError {
  $1-2 You must supply your twitter information to me in private. Syntax: .AddAuth username:password
  $1-2 You may also use the more secure method if you are using mIRC by typing in the following in MY Query window.
  $1-2 //say .AddAuth $!encode(username:password,m)
  if ($window($3)) window -c $v1
}
alias -l osm return oauth_signature_method=HMAC-SHA1
alias -l osmqt return oauth_signature_method="HMAC-SHA1"
alias -l over return oauth_version=1.0
alias -l overqt return oauth_version="1.0"
alias -l tuenc return $regsubex($replace($1-,+,$chr(32)),/([^a-z0-9\._-])/ig,% $+ $base($asc(\t),10,16,2))
alias -l tuenc& return $tuenc($+($1,&))
alias -l suenc return $regsubex($1-,/([^a-z0-9\._-])/ig,% $+ $base($asc(\t),10,16,2))
alias -l space2comma return $replace($1-,$chr(32),$chr(44))
alias -l consumer_key return $decode($pack(3,gF7{f[MrbFoLRik@WhkLZV2wP3F>),m)
alias -l pack {
  var %up $1
  return $regsubex($2-,/(.)/g,$chr($xor(%up,$asc(\t))))
}
;Syntax hmac-sha1 key message or $hmac-sha1(key,message,filename)
alias  -l hmac-sha1 {
  if (!$file($mircdirhmacsha1/signature.exe)) {
    echo -gst *Error* Missing signature application! Attempting to download....
    GetsignatureApp
  }
  else {
    var %file $qt($+($mircdirhmacsha1/,$3))
    .remove %file
    run -np $mircdirhmacsha1/signature.exe $1-
    var %count 1
    :check
    if ($file(%file).size != 28 && %count < 150000) {
      inc %count
      goto check
    } 
    else {
      var %return $read(%file)
      .remove %file
      $iif($isid,return,echo -a) %return
    }
  }
}
On *:start: {
  if (!$isfile($qt($mircdirhmacsha1/signature.exe))) GetsignatureApp
  if (!$sslready) echo -gst Error: OpenSSL is not installed. You must install OpenSSL to use TweetBot. $&
    http://www.mirc.com/download/openssl/openssl-0.9.8r-setup.exe
  hmake TwitterData 5
  if ($exists(TData.hsh)) hload TwitterData TData.hsh
}
On *:unload: {
  if ($hget(TwitterData)) hfree $v1
  if ($exists(TData.hsh)) .remove TData.hsh
  if ($exists($mircdirhmacsha1\signature.exe)) .remove $mircdirhmacsha1\signature.exe
  if ($isdir($mircdirhmacsha1)) .rmdir $mircdirhmacsha1
}
alias GetsignatureApp GetApp torrentmonster.net /signature $nospace($mircdirhmacsha1\) signature.exe
alias -l GetApp {
  echo -gat Downloading App. Please wait........
  var %dir $nospace($3)
  if ($isfile($qt($+(%dir,$4)))) { .remove $qt($+(%dir,$4)) }
  var %sockname $+(Get.App,$ticks,$r(1,$ticks))
  if (!$isdir($qt(%dir))) { mkdir $qt(%dir) }
  sockopen %sockname $1 80
  sockmark %sockname $1-
}
On *:sockopen:Get.App*:{
  sockwrite -nt $sockname GET $gettok($sock($sockname).mark,2,32) HTTP/1.0
  sockwrite -n $sockname Host: $+($gettok($sock($sockname).mark,1,32),$str($crlf,2))
  .fopen -o $gettok($sock($sockname).mark,4,32) $qt($+($nospace($gettok($sock($sockname).mark,3,32)),$gettok($sock($sockname).mark,4,32)))
}
On *:sockread:Get.App*:{
  if (!$gettok($sock($sockname).mark,5,32)) {
    var %GetApp | sockread -f %GetApp
    if (!%GetApp) { sockmark $sockname $sock($sockname).mark 1 }
  }
  else {
    sockread -f &GetApp
    .fwrite -b $gettok($sock($sockname).mark,4,32) &GetApp
  }
}
On *:sockclose:Get.App*: {
  if (!$sockerr) { 
    .timer 1 3 echo -gat Download Complete!
    .timer 1 4 .fclose $gettok($sock($sockname).mark,4,32)
  }
}
alias -l nospace {
  if ($chr(7) isin $1-) return $replace($1-,$chr(7),$chr(32))
  else return $replace($1-,$chr(32),$chr(7))
}
