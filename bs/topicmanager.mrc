dialog Topic {
  title "Topic Manager"
  size -1 -1 248 168
  option dbu
  edit "", 1, 74 12 163 10, autohs
  box "Set Topic", 2, 4 1 241 28
  list 3, 11 55 227 75, sort size extsel hsbar vsbar
  box "Past Topics", 4, 4 45 241 105
  button "Close", 6, 111 153 32 11, ok
  combo 7, 10 12 61 50, size drop
  button "Manage Channels", 8, 14 33 52 11
  button "Set Topic", 9, 201 33 31 11
  button "Set Selected Topic", 5, 59 134 58 11
  button "Delete Selected Topic", 10, 131 134 58 11
  button "Open Topics File", 11, 96 33 58 11
}

dialog TMChan {
  title "Channel Manager"
  size -1 -1 84 112
  option dbu
  list 1, 13 13 58 55, size
  box "Topic Manager Channels", 2, 8 3 69 86
  button "Add", 3, 14 72 26 11
  button "Delete", 4, 45 72 26 11
  button "Close", 5, 29 95 30 9, ok
}



on *:Dialog:Topic:init:*: {
  $iif($isfile(Topics.txt),loadbuf -o Topic 3 Topics.txt)
  $iif($isfile(TMChannels.txt),loadbuf -o Topic 7 TMChannels.txt)
}

on *:Dialog:TMChan:init:*: {
  $iif($isfile(TMChannels.txt),loadbuf -o TMChan 1 TMChannels.txt)
}

on *:Dialog:Topic:sclick:*: {
  if ($did == 5) { /chanserv topic $did(7).seltext $did(3).seltext }
  if ($did == 8) { dialog -m TMChan TMChan }
  if ($did == 9) { /cs topic $did(7).seltext $did(1) | write Topics.txt $did(1) | did -r Topic 3 | loadbuf -o Topic 3 Topics.txt | did -r Topic 1 }
  if ($did == 10) { write -dl $+ $did(3).sel Topics.txt | did -r Topic 3 | loadbuf -o Topic 3 Topics.txt }
  if ($did == 11) { did -r Topic 3 | run topics.txt |  $iif($input(Please click ok when you are done editing!,o,Past Topics),loadbuf -o Topic 3 topics.txt) }
}


on *:Dialog:TMChan:sclick:*: {
  if ($did == 3) { write TMChannels.txt $?="Add Channel") | did -r TMChan 1 | loadbuf -o TMChan 1 TMChannels.txt | did -r Topic 7 | loadbuf -o Topic 7 TMChannels.txt }
  if ($did == 4) { write -dl $+ $did(1).sel TMChannels.txt | did -r TMChan 1 | loadbuf -o TMChan 1 TMChannels.txt | did -r Topic 7 | loadbuf -o Topic 7 TMChannels.txt }
}

alias topic { dialog -m Topic Topic }

menu * {
  .Topic Manager: { topic }
}
