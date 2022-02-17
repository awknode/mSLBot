;on *:text:*spotify*:#:{
;  if (*spotify:track* iswm $1-) {
;    set %spot.uri $wildtok($1-,*spotify:track*,1,32)
;    sockopen spot ws.spotify.com 80
;  }
;}

on *:text:*:#: {
  var %x = 1
  while (%x <= $numtok($strip($1-),32)) {
    var %y = $gettok($strip($1-),%x,32)
    if (*spotify:track* iswm %y) {  
      set %spotchan $chan | set %spotID $+(/v1/tracks/e3ebc667c3384f5aa6007aa9a3fbaecf/,$gettok($replace(%y,spotify,spotify.com,:,),$iif(*http* iswm %y, 4, 3),47)) | sockopen -e spotify api.spotify.com 443 
    }
    if (*spotify.com/track* iswm %y) {
      set %spotchan $chan | set %spotID $+(/v1/tracks/e3ebc667c3384f5aa6007aa9a3fbaecf/,$gettok(%y,$iif(*http* iswm %y, 4, 3),47)) | sockopen -e spotify api.spotify.com 443 
    }
    if (*spotify.com/artist* iswm %y) {
      set %spotchan $chan | set %spotID $+(/v1/artists/e3ebc667c3384f5aa6007aa9a3fbaecf/,$gettok(%y,$iif(*http* iswm %y, 4, 3),47)) | sockopen -e spotifyartist api.spotify.com 443 
    }
    if (*spotify.com/album* iswm %y) {
      set %spotchan $chan | set %spotID $+(/v1/albums/e3ebc667c3384f5aa6007aa9a3fbaecf/,$gettok(%y,$iif(*http* iswm %y, 4, 3),47)) | sockopen -e spotifyalbum api.spotify.com 443 
    }
    inc %x
  }
}

on *:SOCKOPEN:*: {
  if ($sockname == spotify) || ($sockname == spotifyartist) || ($sockname == spotifyalbum) {
    sockwrite -nt $sockname GET %spotID HTTP/1.1
    sockwrite -nt $sockname Host: api.spotify.com
    sockwrite -nt $sockname Connection: Close
    sockwrite $sockname $crlf
  }
}

on *:SOCKREAD:*: {
  if ($sockname == spotifyalbum) {
    if ($sockerr) { msg %spotchan Error.. | sockclose $sockname }
    var %spotreadalb
    sockread %spotreadalb
    if (*name* iswm %spotreadalb) {
      inc %spotname 1
      if (%spotname == 1) {
        set %spotartist $remove($gettok(%spotreadalb,2,58),",$chr(44))
      }
      elseif (%spotname == 2) {
        set %spotalbum $remove($gettok(%spotreadalb,2,58),",$chr(44))
        unset %spotname
      }
    }
    if (*release_date* iswm %spotreadalb) {
      if (!%spotreldate) {
        set %spotreldate 1
        msg %spotchan 14(Spotify14) Name: %spotalbum Artist: %spotartist Release date: $remove($gettok(%spotreadalb,2,58),",$chr(44))
        sockclose $sockname 
        unset %spot*
      }
    }
  }
  if ($sockname == spotifyartist) {
    if ($sockerr) { msg %spotchan Error.. | sockclose $sockname }
    var %spotreadart
    sockread %spotreadart
    ;echo -at %spotreadart
    if (*total* iswm %spotreadart) {
      set %spotartfol $gettok(%spotreadart,2,58)
    }
    if (*genres* iswm %spotreadart) {
      set %spotartgenre $remove($gettok(%spotreadart,2,91),",$+([,$chr(44)))
    }
    if (*name* iswm %spotreadart) {
      set %spotartname $remove($gettok(%spotreadart,2,58),",$chr(44))
      sockclose $sockname
      msg %spotchan 14(Spotify14) Name: %spotartname Genres: %spotartgenre Followers: %spotartfol
      .timer 1 1 unset %spotart*
    }
  }
  if ($sockname == spotify) {
    if ($sockerr) { msg %spotchan Error.. | sockclose $sockname }
    var %spotread
    sockread %spotread
    ;echo -at %spotread
    if (*name* iswm %spotread) {
      inc %spotname 1
      if (%spotname == 1) {
        set %spotalbum $remove($gettok(%spotread,2,58),",$chr(44))
      }
      elseif (%spotname == 2) {
        set %spotartist $remove($gettok(%spotread,2,58),",$chr(44))
      }
      elseif (%spotname == 3) {
        set %spottrack $remove($gettok(%spotread,2,58),",$chr(44))
        sockclose $sockname
        msg %spotchan 14(Spotify14) 9Track: %spotalbum $iif(%spotexp, 14|4Explicit14|4✔14|, $null) 8Artist: %spotartist 4Album: %spottrack
        .timer 1 2 unset %spot*
      }
    }
    elseif (*explicit* iswm %spotread) {
      if (*true* iswm $gettok(%spotread,2,58)) {
        set %spotexp 1
      }
    }
  }
}
