on *:text:*:#noc:{
  ; msg #noc bopm activated. 
  if (LOGUSERS*connected*to* iswm $1- ) {
    msg #noc bopm scan $gettok($gettok($1-,1,93),2,91)
  }
  if ($nick == bopm ) {
    if (*appears*in* iswm $1- ) {
      if (Myriad iswm $1-) { halt }
      gline *@* [ $+ [ $5 ] ] yes bopm is activated. don't use a proxy for the moment. thanks for your patience.
      msg #noc added gline for *@* [ $+ [ $5 ] ]
    }
  }
}
