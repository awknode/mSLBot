on $owner:TEXT:!debug*:#: {
  if ($nick isop $chan) {
    msg $chan Sup $nick $+ . What have you been up to my nigga? Everything is good around this way homie. Hit me up later.
  }
  :error {
    if ($error != $null) {
      msg $chan dope / unkn0wn: $error
    }
  }
}
