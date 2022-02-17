ON *:TEXT:*:#:{ 
  if ($chan == #services) || ($chan == #priv8 ) || ($chan == #ssl ) { halt }
  window -klue2zM -t0,12,23,36,54,40 @sed 
  aline -p @sed $chr(91) $+ $nick $+ $chr(93) $strip($1-) 
} 
