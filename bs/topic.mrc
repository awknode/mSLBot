on *:TEXT:!topic:#:{
  if (!%topic. [ $+ [ $chan ] ]) { msg # $nick -> No topic is currently set. }
  else { msg #  Topic: $qt(%topic. [ $+ [ $chan ] ]) }
}


on *:TEXT:!topic *:#:{
  ; Checks to see if I am an op and the user is an op.
  ; If the user's name is the same as the channel, it will also work.
  if ($me isop # && (($nick isop #) || ($nick isin #))) {
    set %topic. [ $+ [ $chan ] ] $2- - (set by $nick $+ )
    msg # [Current topic] %topic.
  }
  elseif ($me !isop # && $nick isop #) { msg # [ $nick ] I must be a moderator of the room to change the topic for you sorry. }
  elseif ($nick !isop #) { msg # [ $nick ] You are not an op in this channel sorry Do good maybe you will become one }
  else return
} 
