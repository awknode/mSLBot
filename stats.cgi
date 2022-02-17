alias httpdcgi.Stats {
  var %generation = $ticks
  htStatus 200
  htEcho Content-Type: text/html
  htEcho Pragma: no-cache
  htEcho Expires: 0
  htEcho

  htEcho <!DOCTYPE html>
  htEcho <html>
  htEcho    <head>
  htEcho    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
  htEcho    <title> $iif($QSInput(Room),$v1,Room) Stats </title>
  htEcho </head>
  htEcho <style>table{width: 100%;}th{background-color:#d2d2d2}tr{background-color:#E9E9E7}tr:nth-child(odd){background-color:#e2e2e2}</style>
  htEcho <body>
  htEcho    <h1> $iif($QSInput(Room),$scon($QSInput(scon)).network - $QSInput(room),Room) Stats </h1><hr>


  if ($ENV(Query-String) != $null) {
    htEcho <table><tr>
    htEcho <th>Nick</th>
    htEcho <th>Address</th>
    htEcho <th>Status</th>
    htEcho <th>Idle</th>
    htEcho </tr>

    scon $QSInput(scon)
    var %x = 0 | while (%x < $nick($QSInput(Room),0)) { inc %x
      htEcho <tr>
      htEcho <td> $nick($QSInput(Room),%x) </td>
      htEcho <td> $iif($ial($nick($QSInput(Room),%x)).addr,$v1,unknown) </td>
      htEcho <td> $iif($nick($QSInput(Room),%x) isop $QSInput(Room),Op,$iif($nick($QSInput(Room),%x) isvo $QSInput(Room),Voice,Regular)) </td>
      htEcho <td> $duration($nick($QSInput(Room),%x).idle) </td>
      htEcho </tr>
    }
    htEcho </table><hr /> Last 50 Lines Buffer: <hr />
    var %TotLines = $line($QSInput(Room),0,0)
    var %x = $iif(%TotLines > 50,$calc(%TotLines - 50),0) | while (%x < %TotLines) { inc %x
      htEcho <div class="ClrMe"> $replace($strip($line($QSInput(Room),%x,0)),<,&lt;,>,&gt;) </div>
    }
    htEcho <hr>
  }
  else {
    var %x = 0 | while (%x < $scon(0)) { inc %x
      scon %x
      htEcho $me $+([,$usermode,]) on $network ( $+ $+($server,:,$port) $+ ) Connected for: $uptime(server,1) <br />
      htEcho <table><tr><th>Room</th><th>Modes</th><th>Users</th><th>Topic</th></tr>
      var %y = 0 | while (%y < $chan(0)) { inc %y
        htEcho <tr><td><a href="Stats.cgi?scon= $+ %x $+ &amp;room= $+ $replace($chan(%y),$chr(35),$+(%,23)) $+ "> $chan(%y) </a></td><td> $chan(%y).mode </td><td> $nick($chan(%y),0) </td><td class="ClrMe">
        htEcho $replace($strip($chan(%y).topic),<,&lt;,>,&gt;)
        htEcho </td></tr>
      }
      htEcho </table><hr>
    }
  }
  htEcho Page Generated in: $calc(($ticks - %generation) / 1000) secs
  htEcho </body>
  htEcho </html>
}
