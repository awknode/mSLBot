;;------here's where you put your nickname as it is on the ZNC bot channel.------;;
alias -l zncowner { return ck }
;;-------------------------------------------------------------------------------;;    


On $owner:TEXT:*:#: {
  if ($1 == !znc) {
    if (!$2) { msg $chan 14[4ZNC14] Invalid Syntax. i.e. - !znc adduser user // !znc deluser user // !znc request | halt }
    if ($nick == $zncowner ) {
      var %r.pass $base($rand(0,$calc(36^8 -1)),10,36,8)
      if ($2 == adduser ) && ($3) { 
        /msg *controlpanel adduser $3 %r.pass 
        if ($3 ison $chan) { 
          notice $3 14[4ZNC14] Your new password will be ( %r.pass ). Please change it as soon as you sign in.
        }
        else { msg $chan 14[4ZNC14] That nick isn't in this channel, no user to notice. I am sending you the info, $nick $+ . | msg $nick 14[4ZNC14] The password: %r.pass is set for user: $3  }
      }
      if ($2 == deluser ) && ($3) { 
        /msg *controlpanel deluser $3 
        msg $chan 14[4ZNC14] User $3 $+ : has been removed. 
      }
    }
    if ($2 == request ) { 
      msg $chan 14[4ZNC14] An account request has been sent. 
      msg $zncowner 14[4ZNC14] ( $nick ) has requested a ZNC account.
    }
  }
}
