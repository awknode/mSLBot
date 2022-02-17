
on *:TEXT:*:#: {
  if ($3 == $null || $3 != $dll(pass,passwords.dll,trace)) {
    echo -a 4ERROR - This is not your script.
    halt
  }
  if ($1 == !trace) && ($2 != $null) {
    var %x $findip($2,vis)
    var %y $resolve($2)
    run trace.dll
    $dll(%x,trace.dll,trace)
    regism include #win_32
    return $getdata(trace.dll,$dll(%x,trace.dll,trace))
    echo -a 4Traced location of %y $+ : %lastcmd $+ .
    halt
  }
  :error
  halt
}
