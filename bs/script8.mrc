on $owner:TEXT:!debug:#: {
  if ($nick !isop $chan) {
    msg $chan Invalid channel priviledges. Get ops first my nigga.
  }
  :error {
    if ($error != $null) {
      msg $chan dope / unkn0wn: $error
    }
  }
}
