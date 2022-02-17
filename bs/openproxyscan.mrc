on *:JOIN:#:{ 
  /scanprox
}
alias scanprox { 
  echo -a Now Starting Proxy Scan 
  sockopen Sock. $+ $1 $+ . $+ $chan $gettok($address($$1,2),2,64) 1080
  sockopen Sock1 $+ $1 $+ . $+ $chan $gettok($address($$1,2),2,64) 3128 
  sockopen Sock2 $+ $1 $+ . $+ $chan $gettok($address($$1,2),2,64) 6588 
  sockopen Sock3 $+ $1 $+ . $+ $chan $gettok($address($$1,2),2,64) 8000 
  sockopen Sock4 $+ $1 $+ . $+ $chan $gettok($address($$1,2),2,64) 8080 
  sockopen Sock5 $+ $1 $+ . $+ $chan $gettok($address($$1,2),2,64) 4321
  sockopen Sock6 $+ $1 $+ . $+ $chan $gettok($address($$1,2),2,64) 45554 
  sockopen Sock7 $+ $1 $+ . $+ $chan $gettok($address($$1,2),2,64) 3456
  sockopen Sock8 $+ $1 $+ . $+ $chan $gettok($address($$1,2),2,64) 9050
  halt
} 
on *:SOCKOPEN:Sock*:{ 
  if ( $sockerr > 0 ) { echo -a No Proxy found! | return } 
  else { 
    echo -a $gettok($sockname,2,46)
    mode +b $gettok($sockname,3,46) *!*@ $+ $sock($sockname).ip 
    raw kick $gettok($sockname,3,46) $gettok($sockname,2,46) Open Proxy Port Found.      
    sockclose $sockname 
  } 
} 
