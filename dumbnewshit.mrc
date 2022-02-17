;On *:TEXT:*ddos*:#: { if ($network == HackTimes ) && ($chan == #insecurity ) { halt } 
;  spamprotect
;  msg $chan Dudes Drink owl Sperm 
;}

;On *:TEXT:lol:#: { 
;  if ($network == HackTimes ) && ($chan == #insecurity ) { halt }
;  if ($nick == syn4pse ) { halt }
;  spamprotect  
;  timer_lol20 0 2 msg $chan $read(lol.txt) 
;  timer_lol21 0 3 timer_lol* off 
;  halt
;}

On *:TEXT:h:#: { spamprotect | timer_h30 0 2 msg $chan $read(h.txt) | timer_h31 0 3 timer_h* off | halt }

on $*:text:/^[@](voice)( |$)/iS:#:{
  if ($me == [Z]en ) {
    mode $chan +v $2
  }
  else {
    if ($3 isvoice $chan ) {
      msg $chan $2 is already voice
    }
  }
}


On $*:Text:/^[!$@.](asskey|aϟϟkey|as.skey)/Si:#: { 
  if (!%fud && !$($+(%, fud., $nick), 2)) {
    set -u3 %fud On
    set -u4 %fud. $+ $nick On
    ;; spamprotect
    ;; exprotect $1-
    if ($2 != random) && ($2 != search) { play $chan $scriptdir $+ \art\ $+ $2 $+ .txt 0 | halt } 
    if ($2 == search) && ($len($3) >= 2) { 
      var %files = $findfile($scriptdir/art/, $+ * $+ $3 $+ * $+ .txt,0,msg $chan $nopath($1-)) 
      msg $chan asskey found in $nick $+ 's anus → $nopath(%files) 
      halt 
    }
    if ($2 == random) { 
      var %files = $findfile($scriptdir/art/,*.txt,0,1) , %random = $r(1,%files) , %rfile = $findfile($scriptdir/art/,*.txt,%random,1)
      msg $chan asskey found in $nick $+ 's anus → $nopath(%rfile) 
      play $chan %rfile 0 
      halt 
    }
  }
  else { msg # 12Slow down douche. }
}




On $owner:text:merry christmas:#: { 
  if (!%fud && !$($+(%, fud., $nick), 2)) {
    set -u3 %fud On
    set -u10 %fud. $+ $nick On
    spamprotect
    exprotect $1-
    msg $chan                              .-(_)
    msg $chan                             / _/
    msg $chan                          .-'   \
    msg $chan                         /       '.
    msg $chan                       ,-~--~-~-~-~-,
    msg $chan                      {__.._...__..._}             ,888,
    msg $chan      ,888,          /\##"  6  6  "##/\          ,88' `88,
    msg $chan    ,88' '88,__     |(\`    (__)    `/)|     __,88'     `88
    msg $chan   ,88'   .8(_ \_____\_    '----'    _/_____/ _)8.       8'
    msg $chan   88    (___)\ \      '-.__    __.-'      / /(___)
    msg $chan   88    (___)88 |          '--'          | 88(___)
    msg $chan   8'      (__)88,___/                \___,88(__)
    msg $chan             __`88,_/__________________\_,88`__
    msg $chan            /    `88,       |88|       ,88'    \
    msg $chan           /        `88,    |88|    ,88'        \
    msg $chan          /____________`88,_\88/_,88`____________\
    msg $chan         /88888888888888888;8888;88888888888888888\
    msg $chan        /^^^^^^^^^^^^^^^^^^`/88\\^^^^^^^^^^^^^^^^^^\
    msg $chan       /                    |88| \============,     \
    msg $chan      /_  __  __  __   _ __ |88|_|^  4MERRY    | _ ___\
    msg $chan      |;:.                  |88| | 9CHRISTMAS! |      |
    msg $chan      |;;:.                 |88| '============'      |
    msg $chan      |;;:.                 |88|                     |
    msg $chan      |::.                  |88|                     |
    msg $chan      |;;:'                 |88|                     |
    msg $chan      |:;,                  |88|                     |
    msg $chan      '---------------------""""---------------------'
  }
}  

On $owner:text:steal christmas:#: { 
  if (!%fud && !$($+(%, fud., $nick), 2)) {
    set -u3 %fud On
    set -u10 %fud. $+ $nick On
    spamprotect
    exprotect $1-
    msg $chan                   4  .:::::::::::...                                       
    msg $chan                 4  .::::::::::::::::::::.                                  
    msg $chan               4  .::::::::::::::::::::::::.                                
    msg $chan              4  ::::::::::::::::::::::::::::.                              
    msg $chan             4  :::::::::::::::::::::::::::::::  .,uuu   ...                
    msg $chan            4  :::::::::::::::::::::::::::::::: dHHHHHLdHHHHb               
    msg $chan      4  ....:::::::'` 4   ::::::::::::::::::' uHHHHHHHHHHHHHF               
    msg $chan    .uHHHHHHHHH'      4   ::::::::::::::`.  uHHHHHHHHHHHHHP"                
    msg $chan    HHHHHHHHHHH       4   `:::::::::::',dHHuHHHHHHHHP".g@@g                 
    msg $chan   J"HHHHHHHHHP        4H4 ::::::::'  u$$$.    
    msg $chan   ".HHHHHHHHP"     .,uHP 4:::::' uHHHHHHHHHHP"",9e$$$$$c                    
    msg $chan    HHHHHHHF'      dHHHHf 4`````.HHHHHHHHHHP",9d$$$$$$$P%C                   
    msg $chan  .dHHHP""         JHHHHbuuuu,JHHHHHHHHP",9d$$$$$$$$$e=,z$$$$$$$$ee..       
    msg $chan  ""              .HHHHHHHHHHHHHHHHHP",9gdP"  ..3$$$Jd$$$$$$$$$$$$$$e.      
    msg $chan                  dHHHHHHHHHHHHHHP".9edP    " .zd$$$$$$$$$$$"3$$$$$$$$c     
    msg $chan                  `???""??HHHHP",9e$$F" .d$,?$$$$$$$$$$$$$F d$$$$$$$$F"     
    msg $chan                   9     ?be.eze$$$$$".d$$$$ $$$E$$$$P".,ede`?$$$$$$$$      
    msg $chan                   9    4."?$$$$$$$  z$$$$$$ $$$$r.,.e ?$$$$ $$$$$$$$$      
    msg $chan                   9    '$c  "$$$$ .d$$$$$$$ 3$$$.$$$$ 4$$$ d$$$$P"`,,      
    msg $chan                   9     """- "$$".`$$"    " $$f,d$$P".$$P zeee.zd$$$$$.    
    msg $chan                  9    ze.    .C$C"=^"    ..$$$$$$P".$$$'e$$$$$P?$$$$$$     
    msg $chan               9   .e$$$$$$$"="$f",c,3eee$$$$$$$$P $$$P'd$$$$"4..::..9"?$%    
    msg $chan              9   4d$$$P d$$$dF.d$$$$$$$$$$$$$$$$f $$$ d$$$"4 :::::::::.     
    msg $chan             9   $$$$$$ d$$$$$ $$$$$$$$$$$$$$$$$$ J$$",$$$'4.::::::::::::    
    msg $chan            9   "$$$$$$ ?$$$$ d$$$$$$$$$$$$$$$P".dP'e$$$$'4:::::::::::::::   
    msg $chan           9    4$$$$$$c $$$$b`$$$$$$$$$$$P"",e$$",$$$$$'4 ::::::::::::::::  
    msg $chan            9   ' ?"?$$$b."$$$$.?$$$$$$P".e$$$$F,d$$$$$F4 :::::::::::::::::: 
    msg $chan                9     "?$$bc."$b.$$$$F z$$P?$$",$$$$$$$4 :::::::::::::::::::: 
    msg $chan                     9    `"$$c"?$$$".$$$)e$$F,$$$$$$$'4 :::::::::::::::::::: 
    msg $chan                        4 ':.9 "$b...d$$P4$$$",$$$$$$$"4 ::::::::::::::::::::: 
    msg $chan                       4  '::::9 "$$$$$".,"".d$$$$$$$F4 :::::::::::::::::::::: 
    msg $chan                        4  ::::9 be."".d$$$4$$$$$$$$F4 ::::::::::::::::::::::: 
    msg $chan                         4  ::::9 "??$$$$$$$$$$?$P"4 ::::::::::::::::::::::::: 
    msg $chan                          4  ::::::9 ?$$$$$$$$f4 .:::::::::::::::::::::::::::: 
    msg $chan                           4  :::::::9`"????""4.::::::::::::::::::::::::::::::
    msg $chan                           9Play with me and I'll take your shit this year bitch.
  }
}    

On $*:text:fail:#: { 
  if (!%fud && !$($+(%, fud., $nick), 2)) {
    set -u3 %fud On
    set -u10 %fud. $+ $nick On
    spamprotect
    exprotect $1
    if ($network == internetz ) && ($3 == fail ) {   
      msg $chan 4▄7█8█9█11█12█13█4█7█8█9█11█12█13█4█7▄8▐9█11▄12▄13▄4▄7█8▌
      msg $chan 9█11█12█13█4█7█8▌9▄11▌12▄13▐4▐7▌8█9█11█12▌13▀4▀7█8█9▀11▀
      msg $chan 9█11█12█13█4▄7█8▌9▄11▌12▄13▐4▐7▌8▀9█11█12█13▄4▄7█8▌
      msg $chan 11▄12▄13▄4▄7▄8█9█11█12█13█4█7█8█9█11█12█13█4█7█8▀
    }
    msg $chan 4▄7█8█9█11█12█13█4█7█8█9█11█12█13█4█7▄8▐9█11▄12▄13▄4▄7█8▌
    msg $chan 9█11█12█13█4█7█8▌9▄11▌12▄13▐4▐7▌8█9█11█12▌13▀4▀7█8█9▀11▀
    msg $chan 9█11█12█13█4▄7█8▌9▄11▌12▄13▐4▐7▌8▀9█11█12█13▄4▄7█8▌
    msg $chan 11▄12▄13▄4▄7▄8█9█11█12█13█4█7█8█9█11█12█13█4█7█8▀
  }
}

On $owner:text:care meter:#: { 
  if (!%fud && !$($+(%, fud., $nick), 2)) {
    set -u3 %fud On
    set -u10 %fud. $+ $nick On
    spamprotect
    exprotect $1- 
    msg $chan care-meter: 4E _· ' ·. 9F 6&& 14[5....4..7..8..3..9..14] 140%
  }
}

On *:TEXT:!stimer*:#: {
  spamprotect 
  exprotect $1-
  if ($2) { 
    if ($2 <= 9) || (0 !isin $2) { msg $chan Number of smoke time must be in incriments of 10. | halt }
    var %s $2
    msg $chan 9\|/\|/ *10Public Service Announcement* Get ready to pack a bowl, roll a joint, vape a pen, dab a rig, JUST GET READY TO SMOKE! Be ready in10 %s seconds.9 \|/\|/ 
    timer_dank1 0 %s msg $chan 09\|/\|/\|/ 10Ladies & Gents, get your 09bowls and 09joints 4READY!! 09\|/\|/\|/ 
    timer_dank2 0 $remove($2,0) $+ 1 msg $chan 09\|/\|/\|/\|/\|/ 10509 \|/\|/\|/\|/\|/
    timer_dank3 0 $remove($2,0) $+ 2 msg $chan 09\|/\|/\|/\|/ 10409 \|/\|/\|/\|/
    timer_dank4 0 $remove($2,0) $+ 3 msg $chan 09\|/\|/\|/ 10309 \|/\|/\|/
    timer_dank5 0 $remove($2,0) $+ 4 msg $chan 09\|/\|/ 10209 \|/\|/
    timer_dank6 0 $remove($2,0) $+ 5 msg $chan 09\|/ 10109 \|/
    timer_dank7 0 $remove($2,0) $+ 6 msg $chan 09(̅_̅_̅_̅((_̅_̲̅08м̲̅a̲̅я̲̅i̲̅j̲̅u̲̅a̲̅n̲̅a̲̅̅04_̅_̅_̅() 9ڪے4  \|/\|/\|/ 10Smoking is now in session. Enjoy boys. 09\|/\|/\|/
    timer_dank8 0 $remove($2,0) $+ 9 timer_dank* off
    halt
  }
  else { msg $chan 9\|/\|/ *10Public Service Announcement* Get ready to pack a bowl, roll a joint, vape a pen, dab a rig, JUST GET READY TO SMOKE! Be ready in10 2 minutes.9 \|/\|/ 
    timer_dank1 0 120 msg $chan 09\|/\|/\|/ 10Ladies & Gents, get your 09bowls and 09joints 4READY!! 09\|/\|/\|/
    timer_dank2 0 121 msg $chan 09\|/\|/\|/\|/\|/ 10509 \|/\|/\|/\|/\|/
    timer_dank3 0 122 msg $chan 09\|/\|/\|/\|/ 10409 \|/\|/\|/\|/
    timer_dank4 0 123 msg $chan 09\|/\|/\|/ 10309 \|/\|/\|/
    timer_dank5 0 124 msg $chan 09\|/\|/ 10209 \|/\|/
    timer_dank6 0 125 msg $chan 09\|/ 10109 \|/
    timer_dank7 0 126 msg $chan 09(̅_̅_̅_̅((_̅_̲̅08м̲̅a̲̅я̲̅i̲̅j̲̅u̲̅a̲̅n̲̅a̲̅̅04_̅_̅_̅() 9ڪے4  \|/\|/\|/  10Smoking is now in session. Enjoy boys. 09\|/\|/\|/
    timer_dank8 0 127 timer_dank* off
    halt
  }
}



On $owner:text:goatse:#: { 
  if (!%fud && !$($+(%, fud., $nick), 2)) {
    set -u3 %fud On
    set -u10 %fud. $+ $nick On
    spamprotect
    exprotect $1- 
    msg $chan 5*5 4 4 7\7 8 8 9 9 3 3\10_10-11~11 12 12 2 2 6 6 13 13 5 5 4 4 7 7 8 8 9 9 3 3~10-10_11\11 12 12 2 2|6 6 13 13 5*
    msg $chan 5g4 4 7 7 8\8_9 9 3 3 10 10\11 11 12 12 2 2 6 6 13_13.5-5-4-4-7-7-8-8-9.9_3_3_10_10_11_11\12|12 2 2 6|6 13 13 5 5g
    msg $chan 4o4 7 7 8 8 9 9\3 3 10 10 11 11\12_12_2_2_6_6_13/13/5 5_4 4_7_7_8 8_9 9(3_3(10_10_11>11 12 12\2 2 6 6|13 13 5 5 4o
    msg $chan 4a7 7 8 8 9 9 3 3\10 10 11 11.12 12 2C2 6_6_13_13)5 5 4_4_7_7_8_8_9 9(3_3(10_10_11_11_12>12 2 2|6 6 13/13 5 5 4 4a
    msg $chan 7t7 8 8 9 9 3 3 10/10\11 11|12 12 2 2C6 6_13_13_5_5)4/4 7 7 8 8 9 9\3 3(10_10_11_11_12_12>2 2 6|6_13/13 5 5 4 4 7t
    msg $chan 7s8 8 9 9 3 3 10/10 11/11\12|12 2 2 6C6_13_13_5_5_4)4 7 7 8 8 9 9 3|3 10 10(11_11_12_12>2 2 6 6/13 13 5\5 4 4 7 7s
    msg $chan 8e8 9 9 3 3 10|10 11 11 12(12 2 2 6_6C13_13_5_5_4_4)7\7_8_8_9_9_3_3/10 10 11/11/12 12_2/2 6/6 13 13 5 5 4\4 7 7 8e
    msg $chan 8x9 9 3 3 10 10|11 11 12 12 2\2 6 6|13_13_5 5 4 4\7\7_8_8_9_9_3_3_10_10_11/11/12 12(2_2_6/6 13 13 5 5 4 4 7|7 8 8x
    msg $chan 9*9 3 3 10 10|11 11\12 12 2 2 6\6_13_13_5_5)4 4 7 7`8-8-9-9-3 3 10 10-11-11'12 12 2 2 6 6 13 13 5 5 4 4 7 7|8 8 9*
  }
}
