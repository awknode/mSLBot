/*
To do:
- Better window positioning algro
- insert color codes around selected text
*/

/*
---------------------------
Customizable Settings

Edit these values to alter
aspects of the pallette's
display
---------------------------
*/
;; Hot key to display the pallette
alias f2 xpallette

;; Number of pixels of seperation between the window's border and cells within the pallette
;; default: 4
alias -l windowmargin return 4

;; The gap between color index 0-15, bold, italic, underline, reverse & clear buttons and the static pallette
;; default: 4
alias -l pallettegap return 4

;; If set to false, cells will not have a border
;; default: $true
alias -l cellborder return $true

;; The size of each cell, including border when applicable
;; default: 18
alias -l cellsize return 18

;; The spacing between each cell not including cell borders
;; default: 2
alias -l cellspacing return 2

;; The font to use when displaying color indexes within a cell
;; default: Arial
alias -l cellfont return Arial

;; The font size to use when displaying color indexes within a cell
;; default: 12
alias -l cellfontsize return 12

;; If true, the font used when displaying color indexes within a cell will be bold
;; default: $true
alias -l cellfontbold return $true

/*
---------------------------
Customizable Draw Settings end
---------------------------
*/

alias xpallette {
  if (!$window(@xpallette)) {
    xpallette.redraw
  }
  elseif (!$timer(xpallette)) {
    .timerxpallette -m 1 50 xpallette.redraw
  }
}
on *:LOAD:{
  if ($window(@xpallette)) {
    xpallette.redraw
  }
}
on *:ACTIVE:*:{
  if ($lactive == @xpallette) {
    cleanup
  }
}
on *:APPACTIVE:cleanup
on *:UNLOAD:cleanup
on *:KEYDOWN:@xpallette:*:{



  ;; todo: insert character into $lactive editbox



  cleanup
}
menu @xpallette {
  mouse: .timerxpallette -m 1 10 xpallette.redraw
  leave: .timerxpallette -m 1 10 xpallette.redraw
  sclick: clicked
  dclick: dclicked
}
alias xpallette.redraw {
  var %i, %x, %y, %n, %c, %fx, %fy, %o
  var %win        = @xpallette
  var %win.parent = $iif($active === @xpallette, $lactive, $active)
  var %win.width  = $calc(4 + ($windowmargin * 2) + (( $cellsize + $cellspacing ) * 11 + $cellsize) )
  var %win.height = $calc(4 + ($windowmargin * 2) + ($cellsize * 2 + $cellspacing) + $pallettegap + ($cellsize * 7 + $cellspacing * 6) )
  var %win.xpos   = $window(%win.parent).dx + 15
  var %win.ypos   = $calc( ( $window(%win.parent).dy + $window(%win.parent).h) - %win.height - 40)
  var %cell.pad   = $cellsize + $cellspacing
  var %cell.inner = $iif($cellborder, $calc($cellsize -2), $cellsize)
  if (!$window(%win) || $window(%win).bw !== %win.width || $window(%win).bh !== %win.height) {
    close -@ %win
    window -Bdk0opw0 +dL %win %win.xpos %win.ypos %win.width %win.height
    drawsize %win %win.width %win.height
  }
  elseif (%win.xpos !== $window(%win).dx || %win.ypos !== $window(%win).dy) {
    window %win %win.xpos %win.ypos
  }
  drawrect -fnr %win $rgb(240,240,240) 1 0 0 $window(%win).bw $window(%win).bh
  drawline -nr %win $rgb(227,227,227) 1 0 0 %win.width 0
  drawline -nr %win $rgb(227,227,227) 1 0 0 0 %win.height
  drawline -nr %win $rgb(105,105,105) 1 $calc(%win.width -1) 0 $calc(%win.width -1) %win.height
  drawline -nr %win $rgb(105,105,105) 1 0 $calc(%win.height -1) %win.width $calc(%win.height -1)
  drawline -nr %win $rgb(255,255,255) 1 1 1 $calc(%win.width -1) 1
  drawline -nr %win $rgb(255,255,255) 1 1 1 1 $calc(%win.height -1)
  drawline -nr %win $rgb(160,160,160) 1 $calc(%win.width -2) 1 $calc(%win.width -2) $calc(%win.height -1)
  drawline -nr %win $rgb(160,160,160) 1 1 $calc(%win.height -2) $calc(%win.width -2) $calc(%win.height -2)
  %i = 0
  while (%i < 5) {
    %n = %i
    %y = $floor($calc(%n / 3))
    %x = $calc(2 + $windowmargin + (%cell.pad * 9) + ((%n - 3 * %y) * %cell.pad))
    %y = $calc(2 + $windowmargin + %cell.pad * %y)
    if (%i == 0) {
      %n = $floor($calc( ( $cellsize - $width(B, $cellfont, $cellfontsize, 1) ) / 2))
      %fx = %x + %n
      %n = $floor($calc( ( $cellsize - $height(B, $cellfont, $cellfontsize) ) / 2 ))
      %fy = %y + %n
      drawtext -nor %win $color(88) $qt($cellfont) $cellfontsize %fx %fy B

    }
    elseif (%i == 1) {
      %n = $floor($calc( ( $cellsize - $width(I, $cellfont, $cellfontsize, 0) ) / 2 ))
      %fx = %x + %n
      %n = $floor($calc( ( $cellsize - $height(I, $cellfont, $cellfontsize) ) / 2 ))
      %fy = %y + %n
      drawtext -npr %win $color(88) $qt($cellfont) $cellfontsize %fx %fy I

    }
    elseif (%i == 2) {
      %n = $floor($calc( ( $cellsize - $width(O, $cellfont, $cellfontsize, 0) ) / 2 ))
      %fx = %x + %n
      %n = $floor($calc( ( $cellsize - $height(O, $cellfont, $cellfontsize) ) / 2 ))
      %fy = %y + %n
      drawtext -nr %win $color(88) $qt($cellfont) $cellfontsize %fx %fy O
    }
    elseif (%i == 3) {
      %n = $floor($calc( ( $cellsize - $width(U, $cellfont, $cellfontsize, 0) ) / 2 ))
      %fx = %x + %n
      %n = $floor($calc( ( $cellsize - $height(U, $cellfont, $cellfontsize) ) / 2 ))
      %fy = %y + %n
      drawtext -npr %win $color(88) $qt($cellfont) $cellfontsize %fx %fy U
    }
    else {
      %n = $floor($calc( ( $cellsize - $width(R, $cellfont, $cellfontsize, 0) ) / 2 ))
      %fx = %x + %n
      %n = $floor($calc( ( $cellsize - $height(R, $cellfont, $cellfontsize) ) / 2 ))
      %fy = %y + %n
      drawtext -nr %win $color(88) $qt($cellfont) $cellfontsize %fx %fy R
      %n = $iif($cellborder, $calc($cellsize -2), $cellsize)
      drawcopy -n %win $calc(%x +1) $calc(%y +1) %n %n %win $calc(%x + %n) $calc(%y + 1) $+(-, %n) %n
    }
    if ($inrect($mouse.x, $mouse.y, %x, %y, $cellsize, $cellsize)) {
      drawrect -nr %win 0 1 %x %y $cellsize $cellsize
    }
    elseif ($cellborder) {
      drawline -nr %win $rgb(255,255,255) 1 %x %y $calc(%x + $cellsize) %y
      drawline -nr %win $rgb(255,255,255) 1 %x %y %x $calc(%y + $cellsize)
      drawline -nr %win $rgb(160,160,160) 1 $calc(%x + $cellsize -1) %y $calc(%x + $cellsize -1) $calc(%y + $cellsize)
      drawline -nr %win $rgb(160,160,160) 1 %x $calc(%y + $cellsize -1) $calc(%x + $cellsize) $calc(%y + $cellsize -1)  
    }
    inc %i
  }
  %i = 0
  while (%i < 100) {
    if (%i < 16) {
      %n = %i
      %y = $floor($calc(%n / 8))
      %x = $calc(%n - %y * 8)
      %x = $calc(2 + $windowmargin + %x * %cell.pad)
      %y = $calc(2 + $windowmargin + %y * %cell.pad)
    }
    else {
      %n = %i - 16
      %y = $floor($calc(%n / 12))
      %x = $calc(%n - %y * 12)
      %x = $calc(2 + $windowmargin + %x * %cell.pad)
      %y = $calc(2 + $windowmargin + ( $cellsize *2 + $cellspacing ) + $pallettegap + %y * %cell.pad)
    }
    if (%i == 99) {
      %o = $floor($calc($cellsize /2))
      drawrect -nfr %win $color(98) 1 %x %y $cellsize $cellsize
      drawrect -nfr %win $color(96) 1 %x %y %o %o
      drawrect -nfr %win $color(96) 1 $calc(%x + %o) $calc(%y + %o) $calc($cellsize - %o) $calc($cellsize - %o)
    }
    else {
      drawrect -nfr %win $color(%i) 1 %x %y $cellsize $cellsize
    }
    if ($inrect($mouse.x, $mouse.y, %x, %y, $cellsize, $cellsize)) {
      %c = $iif(0.179 < $lum(%i), 0, $rgb(255,255,255))
      drawrect -nr %win %c 1 %x %y $cellsize $cellsize
      %n = $floor($calc( ( $cellsize - $width($base(%i, 10, 10, 2), $cellfont, $cellfontsize, $iif($cellfontbold,1,0)) ) / 2 ))
      %x = $iif(%n < 0, %x, $calc(%x + %n))
      %n = $floor($calc( ( $cellsize - $height($base(%i, 10, 10, 2), $cellfont, $cellfontsize) ) / 2 ))
      %y = $iif(%n < 0, %y, $calc(%y + %n))
      drawtext $iif($cellfontbold, -nor, -nr) %win %c $qt($cellfont) $cellfontsize %x %y $base(%i, 10, 10, 2)
    }
    elseif ($cellborder) {
      drawline -nr %win $rgb(160,160,160) 1 %x %y $calc(%x + $cellsize) %y
      drawline -nr %win $rgb(160,160,160) 1 %x %y %x $calc(%y + $cellsize)
      drawline -nr %win $rgb(255,255,255) 1 $calc(%x + $cellsize -1) %y $calc(%x + $cellsize -1) $calc(%y + $cellsize)
      drawline -nr %win $rgb(255,255,255) 1 %x $calc(%y + $cellsize -1) $calc(%x + $cellsize) $calc(%y + $cellsize -1)  
    }
    inc %i
  }
  drawdot %win
}
alias -l Lum {
  tokenize 44 $rgb($color($1))
  return $calc(0.2126 * $brightness($1) + 0.7152 * $brightness($2) + 0.0722* $brightness($3))
}
alias -l brightness {
  var %res = $1 / 255
  return $iif(%res <= 0.03928, $calc(%res / 12.92), $calc((( %res + 0.055) / 1.055) ^ 2.4))
}
alias -l clicked {
  if ($mouse.key !& 1 || $mouse.key & 16 || $mouse.key & 2 || $mouse.key & 8 || !$inrect($mouse.x, $mouse.y, $calc($windowmargin +3), $calc($windowmargin +3), $calc($window(@xpallette).bw - 2 - $windowmargin), $calc($window(@xpallette).bw - 2 - $windowmargin))) {
    unset %xpallette.sclicked
    return
  }
  unset %xpallette.sclicked
  var %win = @xpallette
  var %pad = $cellsize + $cellspacing
  var %mx  = $calc($mouse.x - 2 - $windowmargin)
  var %my  = $calc($mouse.y - 2 - $windowmargin)
  var %yo
  var %xo
  var %cc
  var %eb.txt = $editbox($lactive)
  var %eb.swt = -
  var %eb.tar = $lactive
  var %eb.sst = $editbox($lactive).selstart
  var %eb.end = $editbox($lactive).selend
  var %eb.pre = $left(%eb.txt, $calc(%eb.sst -1))
  var %eb.sel = $mid(%eb.txt, %eb.stl, $calc(%eb.sst - %eb.end))
  var %eb.pst = $mid(%eb.txt, %eb.end $+ -)
  if ($inrect(%mx, %my, $calc(%pad * 9), 0, $calc($cellsize * 3 + $cellspacing * 2), $calc($cellsize * 2 + $cellspacing))) {
    %mx = $calc(%mx - %pad * 9)
    %xo = $floor($calc(%mx / %pad))
    %yo = $floor($calc(%my / %pad))
    if ($inrect(%mx, %my, $calc(%xo * %pad), $calc(%yo * %pad), $cellsize, $cellsize)) {
      %cc = $gettok($chr(2) $chr(29) $chr(15) $chr(31) $chr(22), $calc(%yo * 3 + %xo + 1), 32)
    }
  }
  elseif ($inrect(%mx, %my, 0, 0, $calc($cellsize * 8 + $cellspacing * 7), $calc($cellsize * 2 + $cellspacing))) {
    %xo = $floor($calc(%mx / %pad))
    %yo = $floor($calc(%my / %pad))
    if ($inrect(%mx, %my, $calc(%xo * %pad), $calc(%yo * %pad), $cellsize, $cellsize)) {
      %cc = $calc(%yo * 8 + %xo)
    }
  }
  elseif ($inrect(%mx, %my, 0, $calc($cellsize * 2 + $cellspacing + $pallettegap), $calc($cellsize * 12 + $cellspacing * 11),$calc($cellsize * 7 + $cellspacing * 6))) {
    %my = $calc(%my - $cellsize * 2 - $cellspacing - $pallettegap)
    %xo = $floor($calc(%mx / %pad))
    %yo = $floor($calc(%my / %pad))
    if ($inrect(%mx, %my, $calc(%xo * %pad), $calc(%yo * %pad), $cellsize, $cellsize)) {
      %cc = $calc(%yo * 12 + %xo + 16)
    }
  }
  if (%cc === $null) {
    return
  }
  set -u1 %xpallette.sclicked $true
  if ($lactive == status window) {
    %eb.swt = -s
    %eb.tar = $null
  }
  if (%cc == $chr(15)) {
    if ($right(%eb.sel,1) == $chr(15) || $left(%eb.pst,1) == $chr(15)) {
      return
    }
    %eb.txt = %eb.pre $+ %eb.sel $+ $chr(15) $+ %eb.pst
  }
  elseif (%cc !isnum) {
    if (%eb.sst !== %eb.end) {
      %eb.txt = %eb.pre $+ %cc $+ %eb.sel $+ %cc $+ %eb.pst
      inc %eb.end
    }
    else {
      %eb.txt = %eb.pre $+ %eb.sel $+ %cc $+ %eb.pst
    }
    inc %eb.sst
    inc %eb.end
  }
  elseif (%eb.sst == %eb.end) {
    if ($mouse.key & 4) {
      %eb.txt = %eb.pre $+ $chr(3) $+ %cc $+ %eb.pst
      inc %eb.sst 3
    }
    elseif ($regex(%eb.pre, \x03$)) {
      %eb.txt = %eb.pre $+ %cc $+ %eb.pst
      inc %eb.sst 2
      inc %eb.end 2
    }
    elseif ($regex(%eb.pre, \x03\d\d?$)) {
      %eb.txt = %eb.pre $+ , $+ %cc $+ %eb.pst
      inc %eb.sst 3
      inc %eb.sst 3
    }
    elseif ($regex(%eb.pre, \x03\d\d?\x2C$)) {
      %eb.txt = %eb.pre $+ %cc $+ %eb.pst
      inc %eb.sst 2
      inc %eb.end 2
    }
    else {
      %eb.txt = %eb.pre $+ $chr(3) $+ %cc $+ %eb.pst
      inc %eb.sst 3
      inc %eb.end 3
    }
  }




  ;; todo : Handle inserting color codes around selected text





  editbox $+(%eb.swt, b, %eb.sst, e, %eb.end) %eb.tar %eb.txt
}
alias dclicked {
  if ($mouse.key !& 1 || $mouse.key & 16 || $mouse.key & 2 || $mouse.key & 8) {
    unset %xpallette.sclicked
  }
  elseif (%xpallette.sclicked) {
    cleanup
  } 
}
alias -l cleanup {
  unset %xpallette.sclicked
  unset %xpallette.refocus
  .timerxpallette off
  close -@ @xpallette
}
