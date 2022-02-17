on $owner:TEXT:*:#: {
  if ($botmaster($network,$nick)) {
    if (.addnews == $1) { 
      spamprotect
      exprotect $1-
      if (!$2) { .msg $chan Add something noteworthy faggot. Need second input. Don't waste anymore of my time dickweed. } 
      if (!$read(News.txt, w, $2- *)) && ($2) { write News.txt 14(News14) by $nick $+ : $2- $+ . On $adate | .msg $chan News has been added. | halt }
      if ($read(News.txt, w, $2- *)) && ($2) { write -dw $+ * $+ $2- $+ * News.txt | write News.txt News item added by $nick on $fulldate $+ : $2- | .msg $chan News Added. | halt }
    }
    if (.delnews == $1) {
      spamprotect
      exprotect $1-
      if ($nick isop $chan) { write -dw $+ * $+ $2 $+ * News.txt | msg $chan News has been deleted. }
      else { msg $chan Your Not Oped }
    }
    if (.rmnews == $1) { spamprotect | exprotect $1- | write -c News.txt | msg $chan News deleted. }
  }
  if (.news == $1) { 
    /play $chan News.txt 
  }
  ;;  else { msg $chan Access denied, bitch. }
}
