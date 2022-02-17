alias asc { if ($regex($$1-,/[ -~]/ig) != $len($$1-)) { msg $chan YOU ARE NOT USING PROPER ASCII SIR. 0-255 PLEASE? THANKS. } else { echo -a ascii } }

;On *:TEXT:*:#: {   
;  if (!%fud && !$($+(%, fud., $nick), 2)) {
;    set -u3 %fud On
;    set -u120 %fud. $+ $nick On
;    if ($regex($strip($$1-),/[ -~]/ig) != $len($strip($$1-))) { 
;      spamprotect 
;      exprotect $1- 
;      msg $chan 0-255mph PLEASE? THANKS. 
;    }
;    else { msg $chan Incoming proper chats. }
;  }
;}
