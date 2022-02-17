	

alias gas {
  if $1- {
    if $1 == -a { set %g.m echo -a | set %ii $2- }
    else { set %ii $1- | set %g.m msg %g.notice $nick  }
    %g.m *** Searching for Lowest Gas Prices in $+(",%ii,")
    sockopen gas fuelmeup.com 80
    set %g.turn 0
  }
}
on *:text:!gas *:#: {
  if (!%gas. [ $+ [ $nick ] ]) {
    set -u3 %gas. [$+ [ $nick ] ] 1
    set %g.chan $chan | set %g.m msg %g.notice $nick
    if $2 isnum && $len($2) == 5 { set %g.turn 0 | gas $2- }
    elseif $2 !isnum || $len($2) != 5 { %g.m *** Error: !gas zipcode }
  }
}
on *:sockread:gas:{
  if ($sockerr) {
    echo -a Error.
    halt
  }
  else {
    var %hi, %i
    sockread %hi
    %i = $y(%hi)
    if %i != $null {
      if %r.onn == on {
        if %g.turn <= 10 {
          if *HTTP/* !iswm %i && *Mid* !iswm %i && *toggle grade* !iswm %i && *Address* !iswm %i && *Price/Date* !iswm %i && *Dsl* !iswm %i {
            if *Station* !iswm %i && *|* !iswm %i && *Sup* !iswm %i && *Dsl* !iswm %i {
              if %i != $null && *21b* !iswm %i && *1f6* !iswm %i && *1f4* !iswm %i && *Update Gas Prices* !iswm %i {
                if $+(*,$asctime(yyyy-mm-dd),*) iswm %i {
                  if $gettok(%i,1,32) != $null {
                    %i = $replace(%i,$gettok(%i,1,32),$+(,$chr(36),$remove($gettok(%i,1,32),$chr(32)),),$gettok(%i,2,32),$+(,$gettok(%i,2,32),),$gettok(%i,1-3,45),$+(LastChecked:,$chr(32),$gettok(%i,1-3,45),))
                  }
                }
                %g.m %i
                if $+(*,$asctime(yyyy-mm-dd),*) iswm %i { %g.m ------------- }
                inc %g.turn
              }
            }
          }
        }
        if *Top 10 gas stations shown* iswm %i  { set %r.onn off }
      }
      if Update Gas Prices isin %i { set %r.onn on }
    }
    if (</html> isin %hi) {
      .timers 1 5 sockclose gas
      %g.m *** End of Gas Results
      unset %g.*
    }
  }
}
alias -l y {
  var %x, %i = $regsub($1-,/(^[^<]*>|<[^>]*>|<[^>]*$)/g,$chr(32),%x), %x = $remove(%x,&nbsp;,$chr(9))
  return %x
}
on *:sockopen:gas:{
  sockwrite -n gas GET /go.php?city=&state=&zipcode= $+ %ii $+ &radius=20 HTTP/1.1
  sockwrite -n gas Host: fuelmeup.com $+ $crlf $+ $crlf
}
