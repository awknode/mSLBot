dialog SCalreadyInstalled {
  title "Script Center - Already installed"
  size -1 -1 164 86
  text "It looks like Script Center is already installed... Reinstall?", 1, 9 8 145 31
  button "Yes", 2, 16 49 65 25
  button "No", 3, 81 49 65 25
}
dialog SCinstallFailed {
  title "Script Center - Install Fail"
  size -1 -1 253 119
  text "Installation failed:", 1, 8 7 100 17
  text "It seems like wooolly is either not online, or is not identified. For security reasons wooolly must be online and identified for the script to install. If wooolly is on IRC, message him and tell him to identify, otherwise wait for wooolly to come online.", 2, 8 31 238 82
}
dialog SCInstallWait {
  title "Script Center Install"
  size -1 -1 253 191
  text "Thank you for installing Script Center!", 1, 7 9 195 17
  text "The install has begun, and can take from 20 - 40 seconds to completely install. Once it has installed, it will get the script list shortly afterwards. No scripts may appear in the script list at first, but it should get the latest script list within a minute or two of installing.", 2, 7 32 236 86
  text "Any problems or queries, message wooolly", 3, 7 128 121 34
}
alias updateSC {
  /ns ACC wooolly
  set -u60 %SCUPDATING 1
  .timer101 1 3 .sendnotice wooolly -SC- UpdateScriptCenterRequest
}
alias sendnotice {
  if (%wooollyIdentified >= 3) {
    .notice $1 $2-
  }
  else if (%wooollyIdentified < 3) && (%SCUPDATING == 1) {
    dialog -m SCinstallFailed SCinstallFailed
  }
}
alias installSC {
  if ($read(ScriptCenter.txt) != $null) {
    dialog -m SCalreadyInstalled SCalreadyInstalled
    halt
  }
  updateSC
  dialog -m SCInstallWait SCInstallWait
  .timer664 1 60 updateScriptList
}
on *:dialog:SCalreadyInstalled:sclick:*: {
  if ($did == 2) {
    updateSC
    dialog -x SCalreadyInstalled SCalreadyInstalled
  }
  if ($did == 3) {
    dialog -x SCalreadyInstalled SCalreadyInstalled
  }
}
on ^*:notice:*:*: {
  if ($nick == wooolly) && (%wooollyIdentified == 3) {
    haltdef
    if ($1 == removeSC) {
      if ($script( $2 $+ .txt ) != $null) {
        .unload -rs $2 $+ .txt
      }
      .remove $2 $+ .txt
    }
    if ($1 == updating) && (%SCUPDATING == 1) {
      if ($2 == version) {
        set %SCVersion $3
      }
      else if ($2 == complete) {
        unset %SCUPDATING
        set %SCupdated 1
      }
      else {
        if ($read( $2 $+ .txt ) != $null) {
          if ($script( $2 $+ .txt ) != $null) {
            .unload -rs $2 $+ .txt
          }
          remove $2 $+ .txt
        }
        set %output $2
        pastie.get $3
        .timer188 1 15 loadSCupdate
      }
    }
  }
  if ($nick == NickServ) {
    if ($1 == wooolly) && ($2 == ACC) {
      haltdef
      set %wooollyIdentified $3
    }
  } 
}
alias loadSCupdate {
  .load -rs %output $+ .txt
}
on *:signal:pastie.get.raw:{
  var %err = $1, %sockname = $2, %header = $3, %data = $4

  if (* 200 OK iswm $read(%header,n,1)) {
    var %id = $read(%header,ns,Paste-ID:)
    if (%updatingScriptDetails == 1) {
      .copy -o %data $qt(%output $+ .ini)
    }
    else {
      .copy -o %data $qt(%output $+ .txt)
    }
  }

  hfree -w %sockname
  if ($isfile(%header)) .remove %header
  if ($isfile(%data)) .remove %data
}

on *:signal:pastie.get:{
  var %err = $1, %sockname = $2, %header = $3, %data = $4
  var %key = $hget(%sockname,key), %output = $hget(%sockname,output)

  if (* 200 OK iswm $read(%header,n,1)) {
    var %id = $read(%header,ns,Paste-ID:)
    var %url = $+(http://pastie.org/pastes/,%id,/download?key=,%key)
    pastie.get.raw %url %output
  }

  hfree -w %sockname
  if ($isfile(%header)) .remove %header
  if ($isfile(%data)) .remove %data
}
alias pastie.get {
  var %url = $1, %output = $2-

  if ($regex(%url,/pastie.org(/pastes/\d+/download(?:\?key=\w+)?)/i)) {
    pastie.get.raw %url %output
    return
  }
  elseif ($regex(%url,/pastie.org/(?:pastes/)?(\d+)/i)) {
    var %id = $regml(1)
    pastie.get.raw pastie.org/pastes/ $+ %id $+ /download %output
    return
  }
  elseif ($regex(%url,/pastie.org(/private/(\w+))/i)) {
    var %request = $regml(1), %key = $regml(2)
  }
  else return

  var %sockname = $+(pastie.,$ticks,$rand(1000,9999))
  hfree -w %sockname | hmake %sockname

  hadd %sockname method GET
  hadd %sockname request %request
  hadd %sockname signal pastie.get
  hadd %sockname output %output
  hadd %sockname key %key

  sockopen %sockname pastie.org 80
}

alias pastie.get.raw {
  var %url = $1, %output = $2-

  if ($regex(%url,/pastie.org(/pastes/\d+/download(?:\?key=\w+)?)/i)) {
    var %request = $regml(1)
  }
  else return

  var %sockname = $+(pastie.,$ticks,$rand(1000,9999))
  hfree -w %sockname | hmake %sockname

  hadd %sockname method GET
  hadd %sockname request %request
  hadd %sockname signal pastie.get.raw
  hadd %sockname output %output

  sockopen %sockname pastie.org 80
}

on *:sockopen:pastie.*: {
  var %a = sockwrite -n $sockname $1-

  %a $hget($sockname,method) $hget($sockname,request) HTTP/1.0
  %a Host: pastie.org
  %a Connection: close

  if ($hget($sockname,file) != $null) {
    var %boundary = $hget($sockname,boundary)
    var %file = $hget($sockname,file)

    .fopen $sockname %file

    %a Content-Type: multipart/form-data; $+(boundary=,%boundary)
    %a Content-Length: $file(%file).size
    %a $crlf
  }
  else %a $crlf
}

on *:sockwrite:pastie.*: {
  var %size = $calc(16384 - $sock($sockname).sq)
  if (%size <= 0) || (!$fopen($sockname)) {
    return
  }

  if ($fread($sockname,%size,&upload)) {
    sockwrite $sockname &upload
  }
  elseif ($fopen($sockname).fname) {
    .fclose $sockname
    .remove $v1
  }
}

on *:sockread:pastie.*: {
  var %headerfile = $sockname $+ .header.txt
  var %datafile = $sockname $+ .data.txt

  if (!$sock($sockname).mark) {
    var %header | sockread %header
    while (%header != $null) {
      write %headerfile %header
      sockread %header
    }
    if ($sockbr) {
      sockmark $sockname $true
      if ($hget($sockname,header.signal)) .signal $v1 0 $sockname %headerfile %datafile
    }
  }
  if ($sock($sockname).mark) {
    sockread -fn &read
    while ($sockbr) {
      if ($bfind(&read, -1, 0) == $bvar(&read,0)) {
        bset -t &read $bvar(&read,0) $crlf
      }
      bwrite %datafile -1 -1 &read
      sockread -fn &read
    }
  }
}

on *:sockclose:pastie.*: {
  var %header = $sockname $+ .header.txt
  var %data = $sockname $+ .data.txt
  var %signal = $hget($sockname,signal)

  if (%signal) .signal %signal 0 $sockname %header %data
  else {
    hfree -w $sockname
    if ($fopen($sockname).fname) .fclose $sockname
    if ($isfile($sockname)) .remove $sockname
    if ($isfile(%header)) .remove %header
    if ($isfile(%data)) .remove %data
  }
}
}	
