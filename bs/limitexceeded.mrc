On ^*:TEXT:*:#: { halt |  
  if ($len($1-) > 750) {
    msg $chan Limit exceeded. Last bit of information seen through my system from last command used:
    msg $chan $gettok($right($1-, $calc($len($1-) - 400)), 1-3, 32)
  }
}
