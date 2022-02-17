;*MULTI MESSAGE SYSTEM
;*by newklear 2017, irc.chatx.co.za
;*Usage: !tell nickname your message goes here
;*When that nickname says something, the bot will relay the message in the channel
;*Copy and paste the entire contents into mIRC script editor and save as whatever.mrc

on *:TEXT:.note*:#: {
  if (%lasttell. [ $+ [ $address($nick,5) ] ] == 1) { halt }
  set -u30 %lasttell. [ $+ [ $address($nick,5) ] ] 1
  if (!$2) { msg $chan 12Invalid Syntax: 12[ .note <nick> "message here" 12] | halt }
  if ($2 == $me) { msg $chan 12Bitch send yourself a message, not to me. | halt }
  if ($read(Tell.txt,w,$+(*,$2,*))) { 
    write -l $+ $calc($readn + 10) Tell.txt $2 $nick $ctime $chan $3-
    msg $chan 12New message saved for $2 $+ .
  } 
  else {
    write Tell.txt $2 $nick $ctime $chan $3-
    msg $chan 12New message saved for $2 $+ .
  } 
}

on *:TEXT:*:#: {
  if ($read(Tell.txt,s,$nick)) { 
    ;; if (%tell. [ $+ [ $address($nick,5) ] ] != 1) { timertell 1 5 notice $nick This is your first message. 12Syntax: .note nickname yourmessage }
    set -u86400 %tell. [ $+ [ $address($nick,5) ] ] 1
    var %who $gettok($read(Tell.txt,s,$nick),1,32)
    var %time $gettok($read(Tell.txt,s, $nick),2,32)
    var %mchan $gettok($read(Tell.txt,s, $nick),3,32)
    var %msg $gettok($read(Tell.txt,s,$nick),4-,32)
    msg $chan $nick 12sent a message $duration($calc($ctime - %time)) ago. 12Msg: < $+ %who $+ > " $+ %msg $+ " 12in: %mchan 12on: $network $+ .
    write -ds $+ $nick Tell.txt
  }
}
