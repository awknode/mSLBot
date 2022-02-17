on $owner:Text:!nickchk *:#:{
  set %nickinfonick $2
  set %nickinfochan $chan
  ns info $2 all
} 

on *:notice:*:*:{
  if ($nick == NickServ) {
    if (nickinfo isin $1-) { msg %nickinfochan The nick %nickinfonick is currently fucking gay. fuck that nigger's nickname. | halt }
    if (may not be isin $1-) { msg %nickinfochan The nick %nickinfonick is pretty fucking gay, choose another. | halt }
    if (is online from isin $1-) { msg %nickinfochan The nick %nickinfonick is currently online. | halt }
    if (last seen address isin $1-) { msg %nickinfochan The nick %nickinfonick is currently offline with @ddress: $4- $+ . | halt }
    if (isn't registered isin $1-) { msg %nickinfochan This nick is not currently registered. | halt }
    if (Last Seen Time isin $1-) { msg %nickinfochan last seen time: $4- | halt }
    if (is currently online. isin $1-) { msg %nickinfochan The nick %nickinfonick is currently online. | halt }
    if (Last quit message isin $1-) { msg %nickinfochan last quit message: $4- | halt }
    if (Time Registered isin $1-) { msg %nickinfochan time registered: $3- | halt }
    if (a services root isin $1-) { msg %nickinfochan $1 has the ability to fuck your shit up, be cautious. | halt }
    if (Expires on isin $1-) { msg %nickinfochan nick expires On: $3- | halt }
    if (vhost isin $1-) { msg %nickinfochan vHost: $2- }
  }
}
